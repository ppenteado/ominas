;=============================================================================
; grim_compute_fov
;
;=============================================================================
function grim_compute_fov, grim_data, plane, cov=cov

 if(grim_test_map(grim_data)) then return, 0

 cd = *plane.cd_p
 if(NOT keyword_set(cd)) then return, 0

 fov = (cov = 0)

 ;-----------------------------------------------------------------
 ; fov = 0: no filtering
 ;-----------------------------------------------------------------
 if(plane.fov EQ 0) then return, fov

 ;-----------------------------------------------------------------
 ; fov > 0: filtering relative to image / optic axis
 ;-----------------------------------------------------------------
 if(plane.fov GT 0) then return, plane.fov

 ;-----------------------------------------------------------------
 ; fov < 0: filtering relative to viewport
 ;-----------------------------------------------------------------
 cov = (convert_coord(/device, /to_data, !d.x_size/2, !d.y_size/2))[0:1]

 p = convert_coord(/device, /to_data, 0, 0)
 q = convert_coord(/device, /to_data, !d.x_size-1, !d.y_size-1)

 dpq = abs(q-p)
 fov = max(dpq) / min(cam_size(cd))

 return, fov
end
;=============================================================================




;=============================================================================
; grim_descriptor_notify_handle
;
;=============================================================================
pro grim_descriptor_notify_handle, grim_data, xd, refresh=refresh, new=new
@grim_constants.common

 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all)
 nplanes = n_elements(planes)

 new = 0

 ;-----------------------------------------------------------------
 ; if the data descriptor of the current plane is affected, then 
 ; remember to refresh the image
 ;-----------------------------------------------------------------
 use_pixmap = 1
 w = where(xd EQ plane.dd)
 if(w[0] NE -1) then $
  begin
   if(dat_update(plane.dd) EQ 1) then new = 1 $
   else $
    begin
     refresh = 1
     use_pixmap = 0
    end
  end

 ;---------------------------------------------------------------------------
 ; Call source routines for overlays that depend on any affected descriptors.
 ;
 ; Planes for which initial overlays have not yet been loaded are ignored
 ; because those overlays will be computed using the geometry that exists at 
 ; that time, and hence any dependencies should be automatically accounted for.
 ;---------------------------------------------------------------------------
 for j=0, nplanes-1 do $
  if(NOT keyword_set(*planes[j].initial_overlays_p)) then $
   begin
    points_ptd = grim_cat_points(grim_data, plane=planes[j])
    n = n_elements(points_ptd)

    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; build a list of source functions and dependencies
    ; such that each source function is called only once.
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
    name_list = ''
    dep_list = ptr_new()
    points_ptd_list = ptr_new()
    source_points_ptd_list = ptr_new()

    if(keyword_set(points_ptd)) then $
     for i=0, n-1 do if(obj_valid(points_ptd[i])) then $
      begin
       dep = cor_udata(points_ptd[i], 'grim_dep')
       if(keyword_set(dep)) then $
        begin
         w = where(dep EQ xd)
         if(w[0] NE -1) then $
          begin
           name = cor_udata(points_ptd[i], 'grim_name')

           ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           ; find any point dependencies
           ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           source_ptd = obj_new()
           w = nwhere(points_ptd, dep)
           if(w[0] NE -1) then source_ptd = points_ptd[w]

           ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           ; if first instance of this type of overlay, add a new item
           ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           w = where(name_list EQ name)
           if(w[0] EQ -1) then $
            begin
             name_list = append_array(name_list, name)
             dep_list = append_array(dep_list, ptr_new(dep))
             points_ptd_list = append_array(points_ptd_list, ptr_new(points_ptd[i]))
             source_points_ptd_list = append_array(source_points_ptd_list, ptr_new(source_ptd))
             if(plane.pn EQ planes[j].pn) then refresh = 1
            end $
           ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           ; otherwise, add to the existing item
           ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           else $
            begin
             ii = w[0]
             *dep_list[ii] = append_array(*dep_list[ii], dep)
             *points_ptd_list[ii] = append_array(*points_ptd_list[ii], points_ptd[i])
             *source_points_ptd_list[ii] = append_array(*source_points_ptd_list[ii], source_ptd)
            end 
          end
        end
      end

   ;- - - - - - - - - - - - - - - - - - - - - - - -
   ; get rid of redundant dependencies
   ;- - - - - - - - - - - - - - - - - - - - - - - -
   nn = 0
   if(keyword_set(name_list)) then nn = n_elements(name_list)
   for i=0, nn-1 do $
    begin
     deps = *dep_list[i]
     deps = deps[sort(deps)]
     deps = deps[uniq(deps)]
     *dep_list[i] = deps
    end

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if the cd time is changed, then all descriptors will need to be reloaded
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   if(NOT grim_test_map(grim_data)) then $
;    if(plane.t0 NE bod_time(*plane.cd_p)) then $
;     begin
;      grim_mark_descriptors, grim_data, /all, plane=plane, MARK_STALE
;      for i=0, nn-1 do *dep_list[i] = 0	; force everything to recompute.
;						; this is not the right way
;						; to do this since it destroys
;						; all memory of which overlays
;						; need to be recomputed
;     end


   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; Call each source function
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   for i=0, nn-1 do $
         grim_overlay, grim_data, plane=plane, $
               name_list[i], dep=*dep_list[i], $
               ptd=*points_ptd_list[i], source_ptd=*source_points_ptd_list[i]

   for i=0, nn-1 do ptr_free, dep_list[i], points_ptd_list[i], source_points_ptd_list[i]


  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; Call user overlay notification function
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - 
; if() then $
grim_user_notify, grim_data, plane=plane
end
;=============================================================================



;=============================================================================
; grim_suspend_events
;
;=============================================================================
pro grim_suspend_events
@grim_block.include

 _suspend_events = 1

end
;=============================================================================



;=============================================================================
; grim_resume_events
;
;=============================================================================
pro grim_resume_events
@grim_block.include

 _suspend_events = 0

end
;=============================================================================



;=============================================================================
; grim_descriptor_notify
;
;=============================================================================
pro grim_descriptor_notify, events, refresh=refresh, new=new
@grim_block.include

 widget_control, /hourglass

 if(keyword_set(_suspend_events)) then return

 n = n_elements(events)

 ;-------------------------------------------
 ; handle events one at a time
 ;-------------------------------------------
 for i=0, n-1 do $
  begin
   grim_data = 0
   top = long(events[i].data)
   xd = events[i].xd
   grim_data = grim_get_data(top)
   plane = grim_get_plane(grim_data)

; if(NOT keyword_set(grim_data)) then nv_notify_unregister, xd, ...

   ;- - - - - - - - - - - - - - - - - - - -
   ; handle the event
   ;- - - - - - - - - - - - - - - - - - - -
   if(keyword_set(grim_data)) then $
          grim_descriptor_notify_handle, grim_data, xd, refresh=refresh, new=new

   ;- - - - - - - - - - - - - - - - - - - -
   ; open a new grim window if necessary
   ;- - - - - - - - - - - - - - - - - - - -
   if((events[i].desc EQ 'DATA') OR (events[i].desc EQ 'ALL')) then $
    if(keyword_set(new)) then $
     begin
stop
; this is not working.  You just get an infinite number of events and new grim windows.
help, events[i].xd
      sibling_dd = dat_sibling(plane.dd)

      new = 0
;      if(NOT obj_valid(plane.sibling_dd)) then new = 1 $
;      else if(sibling_dd NE plane.sibling_dd) then new = 1

      if(obj_valid(plane.sibling_dd)) then  $
      if(sibling_dd NE plane.sibling_dd) then new = 1

;nv_suspend_events
      if(new) then grim, /new, sibling_dd
;nv_resume_events
      plane.sibling_dd = sibling_dd

      grim_set_plane, grim_data, plane
     end 

   if(keyword_set(refresh)) then grim_refresh, grim_data, use_pixmap=use_pixmap
  end


end
;=============================================================================



;=============================================================================
; grim_rm_descriptor
;
;=============================================================================
pro grim_rm_descriptor, grim_data, plane=plane, xdp, xd

 ;--------------------------------------------------------
 ; remove the descriptor, remove all if no xd given
 ;--------------------------------------------------------
 if(NOT ptr_valid(xdp)) then return
 if(NOT keyword_set(*xdp)) then return
 if(NOT keyword_set(xd)) then xd = *xdp
 if(NOT keyword_set(xd)) then return

 w = nwhere((*xdp), xd)
 if(w[0] EQ -1) then return
 *xdp = rm_list_item(*xdp, w, only=obj_new(), /scalar)

 ;--------------------------------------------------------
 ; unregister event handler
 ;--------------------------------------------------------
 nv_notify_unregister, xd, 'grim_descriptor_notify'
 grim_deactivate_xd, plane, xd

 ;----------------------------------
 ; remove its overlays
 ;----------------------------------
 for i=0, n_elements(xd)-1 do $
  begin
   ptd = grim_get_object_overlays(grim_data, plane, xd[i])
   if(keyword_set(ptd)) then nv_notify_unregister, ptd, 'grim_descriptor_notify'
  end

 ;--------------------------------------------------------
 ; free descriptors
 ;--------------------------------------------------------
 nv_free, xd

 ;--------------------------------------------------------
 ; cull dd generic descriptor
 ;--------------------------------------------------------
 cor_set_gd, plane.dd, cor_create_gd(cor_gd(plane.dd), /explicit), /noevent
end
;=============================================================================



;=============================================================================
; grim_mark_descriptor
;
;=============================================================================
pro grim_mark_descriptor, xd, val
 nv_suspend_events
 for i=0, n_elements(xd)-1 do if(keyword_set(xd[i])) then $
                cor_set_udata, xd[i], 'grim_status', val, /noevent
 nv_resume_events
end
;=============================================================================



;=============================================================================
; grim_demark_descriptor
;
;=============================================================================
function grim_demark_descriptor, xd
 if(NOT keyword_set(xd)) then return, 0
 if(NOT obj_valid(xd[0])) then return, 0
 return, cor_udata(xd[0], 'grim_status')
end
;=============================================================================



;=============================================================================
; grim_mark_descriptors
;
;=============================================================================
pro grim_mark_descriptors, grim_data, all=all, $
     cd=cd, pd=pd, rd=rd, sd=sd, std=std, ard=ard, sund=sund, planes=planes, $
     val

 if(NOT keyword_set(planes)) then planes = grim_get_plane(grim_data)
 n = n_elements(planes)

 for i=0, n-1 do $
  begin
   ;----------------------------------
   ; clear descriptors
   ;----------------------------------
   if((keyword_set(all)) OR (keyword_set(cd))) then $
                                grim_mark_descriptor, *planes[i].cd_p, val
   if((keyword_set(all)) OR (keyword_set(pd))) then $
                                grim_mark_descriptor, *planes[i].pd_p, val
   if((keyword_set(all)) OR (keyword_set(rd))) then $
                                grim_mark_descriptor, *planes[i].rd_p, val
   if((keyword_set(all)) OR (keyword_set(sd))) then $
                                grim_mark_descriptor, *planes[i].sd_p, val
   if((keyword_set(all)) OR (keyword_set(std))) then $
                                grim_mark_descriptor, *planes[i].std_p, val
   if((keyword_set(all)) OR (keyword_set(ard))) then $
                                grim_mark_descriptor, *planes[i].ard_p, val
   if((keyword_set(all)) OR (keyword_set(sund))) then $
                                grim_mark_descriptor, *planes[i].sund_p, val
  end


end
;=============================================================================



;=============================================================================
; grim_add_descriptor
;
;=============================================================================
pro grim_add_descriptor, grim_data, xdp, _xd, one=one, $
                         noregister=noregister, assoc_dd=assoc_dd
@grim_constants.common


 if(NOT keyword_set(_xd)) then return
 plane = grim_get_plane(grim_data)

 xd = _xd

 ;----------------------------------------------------------
 ; if assoc_dd given, consider only associated descriptors 
 ;----------------------------------------------------------
 if(keyword_set(assoc_dd)) then $
  begin
   _assoc_dd = cor_gd(xd, /dd)
   w = where(_assoc_dd EQ assoc_dd)
   if(w[0] EQ -1) then return
   xd = xd[w]
  end

 ;-----------------------------------------------------------------------
 ; remove any descriptors to be replaced.
 ; if only one descriptor allowed, force remove
 ;-----------------------------------------------------------------------
 if(keyword_set(one)) then xd = xd[0] $
 else $
  begin
   w = where(cor_name(xd) EQ cor_name(*xdp))
   if(w[0] NE -1) then rm_xd = xd[w]
  end
 grim_rm_descriptor, grim_data, plane=plane, xdp, rm_xd

 ;-----------------------------------------------------------------------
 ; add descriptors and register
 ;-----------------------------------------------------------------------
 grim_mark_descriptor, xd, MARK_FRESH
 *xdp = append_array(*xdp, xd)
 if(NOT keyword_set(noregister)) then $
              nv_notify_register, xd, 'grim_descriptor_notify', $
                                                   scalar_data=grim_data.base

end
;=============================================================================



;=============================================================================
; grim_get_cameras
;
;=============================================================================
function grim_get_cameras, grim_data, plane=plane
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)

 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _trs = cor_udata(plane.dd, 'GRIM_CAM_TRS')
 if(NOT grim_compare(_trs, plane.cam_trs)) then load = 1
 mark = grim_demark_descriptor(*plane.cd_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1
 if(NOT keyword_set(*plane.cd_p)) then load = 1

 if(NOT load) then return, *plane.cd_p


 ;------------------------------------------------
 ; get camera and map descriptors
 ;------------------------------------------------
 cd0 = *plane.cd_p
 t = ''
 if(keyword_set(cd0)) then $
  begin
   if(cor_isa(cd0[0], 'BODY')) then t = bod_time(cd0)
   orient = bod_orient(cd0)
  end

 grim_message, /clear
 grim_print, grim_data, 'Getting camera descriptor...'
 cd = pg_get_cameras(plane.dd, plane.cam_trs, $
                 time=t, default_orient=orient, _extra=grim_data.cam_select)
 md = pg_get_maps(plane.dd)
 grim_message

 if(NOT keyword_set(cd)) then $
  if(NOT keyword_set(md)) then return, 0

 map = grim_test_map(grim_data)
 if(keyword_set(md)) then map = 1

 ;------------------------------------------------
 ; if not a map, then cd is camera descriptor
 ;------------------------------------------------
 if(NOT map) then $
  begin
   grim_add_descriptor, grim_data, plane.cd_p, cd, /one 
   plane.t0 = bod_time(cd)
   grim_set_plane, grim_data, plane;, pn=plane.pn
  end $

 ;------------------------------------------------------------------
 ; otherwise, cd is map descriptor and od is camera descriptor
 ;------------------------------------------------------------------
 else $
  begin
   grim_add_descriptor, grim_data, plane.cd_p, md, /one
   if(keyword_set(cd)) then $
	       grim_add_descriptor, grim_data, plane.od_p, cd, /one
  end
 cor_set_udata, plane.dd, 'GRIM_CAM_TRS', plane.cam_trs, /noevent

 return, *plane.cd_p
end
;=============================================================================



;=============================================================================
; grim_get_planets
;
;=============================================================================
function grim_get_planets, grim_data, plane=plane, names=names
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)

 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _names = cor_udata(plane.dd, 'GRIM_PLT_NAMES')
 if(NOT grim_compare(_names, names)) then load = 1
 _trs = cor_udata(plane.dd, 'GRIM_PLT_TRS')
 if(NOT grim_compare(_trs, plane.plt_trs)) then load = 1
 mark = grim_demark_descriptor(*plane.pd_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1		;;;
 if(NOT keyword_set(*plane.pd_p)) then load = 1			;;;


 if(NOT load) then return, get_object_by_name(*plane.pd_p, names)


 ;----------------------------------------------------------------------------
 ; load descriptors
 ;----------------------------------------------------------------------------
 fov = grim_compute_fov(grim_data, plane, cov=cov)

 ;- - - - - - - - - - - - - - - - - - - - - - - -
 ; get main planets
 ;- - - - - - - - - - - - - - - - - - - - - - - -
 grim_print, grim_data, 'Getting planet descriptors...'
 pd = pg_get_planets(plane.dd, od=*plane.cd_p, sd=*plane.sund_p, $
                name=names, plane.plt_trs, fov=fov, cov=cov, _extra=grim_data.plt_select)

 ;- - - - - - - - - - - - - - - - - - - - - - - -
 ; get planets that require primary descriptors
 ;- - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(pd)) then $
  begin
   pdd = pg_get_planets(plane.dd, od=*plane.cd_p, sd=*plane.sund_p, pd=pd, $
                        name=names, plane.plt_trs, fov=fov, cov=cov, _extra=grim_data.plt_select)
   if(keyword_set(pdd)) then pd = [pd, pdd]

   _names = cor_name(pd)
   w = where(_names NE 'UNKNOWN')
   if(w[0] EQ -1) then pd = 0 $
   else pd = pd[w]
  end

 cor_set_udata, plane.dd, 'GRIM_PLT_NAMES', names, /noevent

 if(keyword_set(pd[0])) then grim_add_descriptor, grim_data, plane.pd_p, pd
 
 return, pd
end
;=============================================================================



;=============================================================================
; grim_get_sun
;
;=============================================================================
function grim_get_sun, grim_data, plane=plane
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)

 ;----------------------------------------------------------------------------
 ; can use a planet instead of the sun if 'name' translator keyword is given
 ;----------------------------------------------------------------------------
 kv = dat_parse_keyvals(dat_parse_transient_keyvals(plane.sun_trs), keywords=keywords)
 nv_free, kv  

 star = 1
 name = 'SUN'   
 if(keyword_set(keywords)) then $
  begin
   w = where(keywords EQ 'name')
   if(w[0] NE -1) then star = 0
  end 


 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _name = cor_udata(plane.dd, 'GRIM_SUN_NAME')
 if(NOT grim_compare(_name, name)) then load = 1
 _trs = cor_udata(plane.dd, 'GRIM_SUN_TRS')
 if(NOT grim_compare(_trs, plane.sun_trs)) then load = 1
 mark = grim_demark_descriptor(*plane.sund_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1
 if(NOT keyword_set(*plane.sund_p)) then load = 1

 if(NOT load) then return, get_object_by_name(*plane.sund_p, names)


 ;----------------------------------------------------------------------------
 ; load descriptors
 ;----------------------------------------------------------------------------
 grim_print, grim_data, 'Getting Sun descriptor...'
 if(star) then sund = pg_get_stars(plane.dd, od=*plane.cd_p, $
                 name=name, plane.sun_trs, _extra=grim_data.sun_select) $
 else $
  begin
   pd = (pg_get_planets(plane.dd, od=*plane.cd_p, $
             name=name, plane.sun_trs, _extra=grim_data.sun_select))[1]
   sund = str_create_descriptors(1, gbd=pd)
  end

 cor_set_udata, plane.dd, 'GRIM_SUN_NAME', name, /noevent
 cor_set_udata, plane.dd, 'GRIM_SUN_TRS', plane.sun_trs, /noevent

 if(keyword_set(sund)) then grim_add_descriptor, grim_data, plane.sund_p, sund, /one

 return, sund
end
;=============================================================================



;=============================================================================
; grim_get_stars
;
;=============================================================================
function grim_get_stars, grim_data, plane=plane, names=names
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)

 trs = '/tr_nosort'
 if(keyword_set(plane.str_trs)) then trs = trs + ', ' + plane.str_trs


 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _names = cor_udata(plane.dd, 'GRIM_STR_NAMES')
 if(NOT grim_compare(_names, names)) then load = 1
 _trs = cor_udata(plane.dd, 'GRIM_STR_TRS')
 if(NOT grim_compare(_trs, trs)) then load = 1
 mark = grim_demark_descriptor(*plane.sd_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1
 if(NOT keyword_set(*plane.sd_p)) then load = 1

 if(NOT load) then return, get_object_by_name(*plane.sd_p, names)


 ;----------------------------------------------------------------------------
 ; load descriptors
 ;----------------------------------------------------------------------------
 fov = grim_compute_fov(grim_data, plane, cov=cov)

 grim_print, grim_data, 'Getting star descriptors...'
 sd = pg_get_stars(plane.dd, od=*plane.cd_p, $
                 trs, name=names, fov=fov, cov=cov, _extra=grim_data.str_select)
 cor_set_udata, plane.dd, 'GRIM_STR_NAMES', names, /noevent
 cor_set_udata, plane.dd, 'GRIM_STR_TRS', trs, /noevent

 if(keyword_set(sd[0])) then grim_add_descriptor, grim_data, plane.sd_p, sd

 return, sd
end
;=============================================================================



;=============================================================================
; grim_get_rings
;
;=============================================================================
function grim_get_rings, grim_data, plane=plane, names=names
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)

 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _names = cor_udata(plane.dd, 'GRIM_RNG_NAMES')
 if(NOT grim_compare(_names, names)) then load = 1
 _trs = cor_udata(plane.dd, 'GRIM_RNG_TRS')
 if(NOT grim_compare(_trs, plane.rng_trs)) then load = 1
 mark = grim_demark_descriptor(*plane.rd_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1
 if(NOT keyword_set(*plane.rd_p)) then load = 1

 if(NOT load) then return, get_object_by_name(*plane.rd_p, names)

 ;----------------------------------------------------------------------------
 ; load descriptors
 ;----------------------------------------------------------------------------
 fov = grim_compute_fov(grim_data, plane, cov=cov)

 grim_print, grim_data, 'Getting ring descriptors...'
 pd = *plane.pd_p
 if(NOT keyword_set(pd)) then return, obj_new()

 rd = pg_get_rings(plane.dd, $
         od=*plane.cd_p, pd=pd, name=names, $
                   plane.rng_trs, fov=fov, cov=cov, _extra=grim_data.rng_select)
 cor_set_udata, plane.dd, 'GRIM_RNG_NAMES', names, /noevent
 cor_set_udata, plane.dd, 'GRIM_RNG_TRS', plane.rng_trs, /noevent

 if(keyword_set(rd)) then grim_add_descriptor, grim_data, plane.rd_p, rd

 return, rd
end
;=============================================================================



;=============================================================================
; grim_get_stations
;
;=============================================================================
function grim_get_stations, grim_data, plane=plane, names=names
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)
 map = grim_test_map(grim_data)

 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _names = cor_udata(plane.dd, 'GRIM_STN_NAMES')
 if(NOT grim_compare(_names, names)) then load = 1
 _trs = cor_udata(plane.dd, 'GRIM_STN_TRS')
 if(NOT grim_compare(_trs, plane.stn_trs)) then load = 1
 mark = grim_demark_descriptor(*plane.std_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1
 if(NOT keyword_set(*plane.std_p)) then load = 1

 if(NOT load) then return, get_object_by_name(*plane.std_p, names)


 ;----------------------------------------------------------------------------
 ; load descriptors
 ;----------------------------------------------------------------------------
 grim_print, grim_data, 'Getting station descriptors...'
 if(NOT map) then bx = *plane.pd_p
 std = pg_get_stations(plane.dd, $
		   od=*plane.cd_p, bx=bx, name=names, $
                          plane.stn_trs, _extra=grim_data.stn_select)
 cor_set_udata, plane.dd, 'GRIM_STN_NAMES', names, /noevent
 cor_set_udata, plane.dd, 'GRIM_STN_TRS', plane.stn_trs, /noevent

 if(keyword_set(std)) then grim_add_descriptor, grim_data, plane.std_p, std

 return, std
end
;=============================================================================



;=============================================================================
; grim_get_arrays
;
;=============================================================================
function grim_get_arrays, grim_data, plane=plane, names=names
@grim_constants.common

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)
 map = grim_test_map(grim_data)

 ;----------------------------------------------------------------------------
 ; determine whether to reload or keep current descriptor set
 ;----------------------------------------------------------------------------
 load = 0
 _names = cor_udata(plane.dd, 'GRIM_ARR_NAMES')
 if(NOT grim_compare(_names, names)) then load = 1
 _trs = cor_udata(plane.dd, 'GRIM_ARR_TRS')
 if(NOT grim_compare(_trs, plane.arr_trs)) then load = 1
 mark = grim_demark_descriptor(*plane.ard_p)
 if((where(mark NE MARK_FRESH))[0] NE -1) then load = 1
 if(NOT keyword_set(*plane.ard_p)) then load = 1

 if(NOT load) then return, get_object_by_name(*plane.ard_p, names)


 ;----------------------------------------------------------------------------
 ; load descriptors
 ;----------------------------------------------------------------------------
 grim_print, grim_data, 'Getting array descriptors...'
 if(NOT map) then bx = *plane.pd_p
 ard = pg_get_arrays(plane.dd, $
		   od=*plane.cd_p, bx=bx, name=names, $
                         plane.arr_trs, _extra=grim_data.arr_select)
 cor_set_udata, plane.dd, 'GRIM_ARR_NAMES', names, /noevent
 cor_set_udata, plane.dd, 'GRIM_ARR_TRS', plane.arr_trs, /noevent

 if(keyword_set(ard)) then grim_add_descriptor, grim_data, plane.ard_p, ard

 return, ard
end
;=============================================================================



;=============================================================================
; grim_clear_descriptors
;
;=============================================================================
pro grim_clear_descriptors, grim_data, planes=planes

 if(NOT keyword_set(planes)) then planes = grim_get_plane(grim_data)
 n = n_elements(planes)

 for i=0, n-1 do $
  begin
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].cd_p
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].pd_p
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].rd_p
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].sd_p
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].std_p
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].ard_p
   grim_rm_descriptor, grim_data, plane=planes[i], planes[i].sund_p

   *planes[i].active_xd_p = 0
  end

 grim_set_data, grim_data, grim_data.base

end
;=============================================================================












;=============================================================================
; grim_load_descriptors
;
;=============================================================================
pro grim_load_descriptors, grim_data, name, plane=plane, class=class, $
       cd=cd, pd=pd, rd=rd, sund=sund, sd=sd, ard=ard, std=std, od=od, $
       obj_name=obj_name, gd=gd

 if(NOT keyword_set(plane)) then plane = grim_get_plane(grim_data)


 ;-----------------------------------------------------------------------
 ; get dependiencies
 ;-----------------------------------------------------------------------
 junk = grim_get_overlay_ptdp(grim_data, name, plane=plane, $
                                                   class=class, dep=dep)
 dep = append_array(dep, class)
 if(NOT keyword_set(dep)) then return

 if(NOT keyword_set(obj_name)) then obj_name = ''

 ;----------------------------------------------------------------
 ; load descriptors based on dependencies for this type of object
 ;----------------------------------------------------------------
 cd = (pd = (rd = (sund = (sd = (std = (ard = (od = 0)))))))

 cd = grim_get_cameras(grim_data, plane=plane)
 if(NOT keyword_set(cd[0])) then return

 map = grim_test_map(grim_data)

 ;----------------------------------------------------------------
 ; camera-only descriptors...
 ;----------------------------------------------------------------
 if(NOT map) then $
  begin
   if((where(dep EQ 'sun'))[0] NE -1) then $
           sund = grim_get_sun(grim_data, plane=plane)

   if((where(dep EQ 'planet'))[0] NE -1) then $
    begin
     names = ''
     if(class EQ 'planet') then names = obj_name
     pd = grim_get_planets(grim_data, plane=plane, names=names)
    end

   if((where(dep EQ 'ring'))[0] NE -1) then $
    begin
     names = ''
     if(class EQ 'ring') then names = obj_name
     rd = grim_get_rings(grim_data, plane=plane, names=names)
    end

   if((where(dep EQ 'star'))[0] NE -1) then $
    begin
     names = ''
     if(class EQ 'star') then names = obj_name
     sd = grim_get_stars(grim_data, plane=plane, names=names)
    end
  end $
 else $
  begin
   pd = *plane.pd_p
   sund = *plane.sund_p
   od = *plane.od_p
  end


 ;----------------------------------------------------------------
 ; common descriptors...
 ;----------------------------------------------------------------
 if((where(dep EQ 'station'))[0] NE -1) then $
  begin
   names = ''
   if(class EQ 'station') then names = obj_name
   std = grim_get_stations(grim_data, plane=plane, names=names)
  end

 if((where(dep EQ 'array'))[0] NE -1) then $
  begin
   names = ''
   if(class EQ 'array') then names = obj_name
   ard = grim_get_arrays(grim_data, plane=plane, names=names)
  end


 gd = {cd: cd, $
       pd: pd, $
       rd: rd, $
       sund: sund, $
       sd: sd, $
       std: std, $
       ard: ard, $
       od: od}
end
;=============================================================================


pro grim_descriptors_include
a=!null
end



