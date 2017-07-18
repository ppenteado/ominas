


;=============================================================================
; grim
;
;=============================================================================
pro grim2, arg1, arg2, gd=gd, _extra=select, $
        cd=cd, pd=pd, rd=rd, sd=sd, std=std, ard=ard, sund=sund, od=od, $
	new=new, xsize=xsize, ysize=ysize, $
	default=default, previous=previous, restore=restore, activate=activate, $
	doffset=doffset, no_erase=no_erase, filter=filter, rgb=rgb, visibility=visibility, channel=channel, exit=exit, $
	zoom=zoom, rotate=rotate, order=order, offset=offset, retain=retain, maintain=maintain, $
	mode_init=mode_init, modal=modal, xzero=xzero, frame=frame, $
	refresh_callbacks=refresh_callbacks, refresh_callback_data_ps=refresh_callback_data_ps, $
	plane_callbacks=plane_callbacks, plane_callback_data_ps=plane_callback_data_ps, $
	nhist=nhist, compress=compress, path=path, symsize=symsize, $
	user_psym=user_psym, workdir=workdir, mode_args=mode_args, $
        save_path=save_path, load_path=load_path, overlays=overlays, pn=pn, $
	menu_fname=menu_fname, cursor_swap=cursor_swap, fov=fov, clip=clip, hide=hide, $
	menu_extensions=menu_extensions, button_extensions=button_extensions, $
	arg_extensions=arg_extensions, loadct=loadct, max=max, grnum=grnum, $
	extensions=extensions, beta=beta, rendering=rendering, npoints=npoints, $
	cam_trs=cam_trs, plt_trs=plt_trs, rng_trs=rng_trs, str_trs=str_trs, $
        sun_trs=sun_trs, stn_trs=stn_trs, arr_trs=arr_trs, assoc_dd=assoc_dd, $
        plane_syncing=plane_syncing, tiepoint_syncing=tiepoint_syncing, $
	curve_syncing=curve_syncing, render_sample=render_sample, $
	render_pht_min=render_pht_min, slave_overlays=slave_overlays, $
	position=position, delay_overlays=delay_overlays, $
     ;----- extra keywords for plotting only ----------
	color=color, xrange=xrange, yrange=yrange, thick=thick, nsum=nsum, ndd=ndd, $
        xtitle=xtitle, ytitle=ytitle, psym=psym, title=title
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
@grim_block.include
@grim_constants.common
compile_opt idl2
grim_compile

 if(keyword_set(exit)) then $
  begin
   grim_exit
   return
  end

 grim_constants

 grim_rc_settings, rcfile='.ominas/grimrc', select=select, $
	cam_select=cam_select, plt_select=plt_select, rng_select=rng_select, str_select=str_select, stn_select=stn_select, arr_select=arr_select, sun_select=sun_select, $
	new=new, xsize=xsize, ysize=ysize, mode_init=mode_init, $
	zoom=zoom, rotate=rotate, order=order, offset=offset, filter=filter, retain=retain, $
	path=path, save_path=save_path, load_path=load_path, symsize=symsize, $
        overlays=overlays, menu_fname=menu_fname, cursor_swap=cursor_swap, $
	fov=fov, clip=clip, menu_extensions=menu_extensions, button_extensions=button_extensions, arg_extensions=arg_extensions, $
	cam_trs=cam_trs, plt_trs=plt_trs, rng_trs=rng_trs, str_trs=str_trs, sun_trs=sun_trs, stn_trs=stn_trs, arr_trs=arr_trs, $
	hide=hide, mode_args=mode_args, xzero=xzero, $
        psym=psym, nhist=nhist, maintain=maintain, ndd=ndd, workdir=workdir, $
        activate=activate, frame=frame, compress=compress, loadct=loadct, max=max, $
	extensions=extensions, beta=beta, rendering=rendering, npoints=npoints, $
        plane_syncing=plane_syncing, tiepoint_syncing=tiepoint_syncing, curve_syncing=curve_syncing, $
	visibility=visibility, channel=channel, render_sample=render_sample, $
	render_pht_min=render_pht_min, slave_overlays=slave_overlays, rgb=rgb, $
	delay_overlays=delay_overlays

 if(keyword_set(ndd)) then dat_set_ndd, ndd

 if(NOT keyword_set(menu_extensions)) then $
                                     menu_extensions = 'grim_default_menus' $
 else if(strmid(menu_extensions[0],0,1) EQ '+') then $
  begin
   menu_extensions[0] = strmid(menu_extensions[0], 1, strlen(menu_extensions[0])-1)
   menu_extensions = ['grim_default_menus', menu_extensions]
  end

 ;=========================================================
 ; cursor modes
 ;=========================================================
 cursor_modes = grim_create_cursor_mode('activate', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('zoom_plot', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('zoom', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('pan_plot', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('pan', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('readout', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('tiepoints', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('curves', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('mask', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('magnify', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('xyzoom', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('remove', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('trim', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('select', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('region', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('smooth', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('plane', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('drag', mode_args, cursor_modes)
 cursor_modes = grim_create_cursor_mode('navigate', mode_args, cursor_modes)

 ;-------------------------------------------
 ; cursor mode extensions
 ;-------------------------------------------
 n_ext = n_elements(button_extensions)
 if(n_ext GT 0) then $
  begin
   if(NOT keyword_set(arg_extensions)) then arg_extensions = lonarr(n_ext)
   for i=0, n_ext-1 do $
    begin
     if(size(arg_extensions, /type) EQ 10) then arg_extension = *arg_extensions[i] $
     else arg_extension = arg_extensions[i]
    
     cursor_modes = append_array(cursor_modes, $
        grim_create_cursor_mode(button_extensions[i], arg_extension, /no_prefix))
    end
  end


 ;=========================================================
 ; input defaults
 ;=========================================================
 new = keyword_set(new)
 if(NOT keyword_set(fov)) then fov = 0
 if(NOT keyword_set(clip)) then clip = 0
 if(NOT defined(hide)) then hide = 1
 if(n_elements(retain) EQ 0) then retain = 2
 if(n_elements(maintain) EQ 0) then maintain = 1
 if(NOT keyword_set(compress)) then compress = ''
 if(NOT keyword_set(extensions)) then extensions = ''
 if(NOT keyword_set(trs)) then trs = ''
 if(NOT keyword_set(cam_trs)) then cam_trs = ''
 if(NOT keyword_set(plt_trs)) then plt_trs = ''
 if(NOT keyword_set(rng_trs)) then rng_trs = ''
 if(NOT keyword_set(str_trs)) then str_trs = ''
 if(NOT keyword_set(stn_trs)) then stn_trs = ''
 if(NOT keyword_set(arr_trs)) then arr_trs = ''
 if(NOT keyword_set(sun_trs)) then sun_trs = ''
 
 if(NOT keyword_set(title)) then title = ''
 if(NOT keyword_set(xtitle)) then xtitle = ''
 if(NOT keyword_set(ytitle)) then ytitle = ''

 ;=========================================================
 ; resolve arguments
 ;=========================================================
 grim_get_args, arg1, arg2, dd=dd, offsets=data_offsets, grnum=grnum, type=type, $
             nhist=nhist, maintain=maintain, compress=compress, $
             extensions=extensions, rgb=rgb

; if(keyword_set(rendering)) then ....

 if(NOT keyword_set(grim_get_data())) then new = 1

 if(NOT keyword_set(mode_init)) then $
  begin
   if(type EQ 'plot') then mode_init = 'grim_mode_zoom_plot' $
   else mode_init = 'grim_mode_activate'
  end


 if(type EQ 'plot') then $
  begin
   if(NOT keyword_set(xsize)) then xsize = 500
   if(NOT keyword_set(ysize)) then ysize = 500
  end

 ;=========================================================
 ; if new instance, set up widgets and data structures
 ;=========================================================
 if(new) then $
  begin
   ;-----------------------------
   ; defaults
   ;-----------------------------
   if(NOT keyword_set(dd)) then $
    begin
     if(NOT keyword_set(xsize)) then xsize = 768
     if(NOT keyword_set(ysize)) then ysize = 768
     dd = dat_create_descriptors(1, data=grim_blank(xsize, ysize), $
          name='BLANK', nhist=nhist, maintain=maintain, compress=compress)
    end $
   else $
    for i=0, n_elements(dd)-1 do $
     if(NOT keyword_set(dat_dim(dd[i]))) then $
      begin
       if(NOT keyword_set(xsize)) then xsize = 512
       if(NOT keyword_set(ysize)) then ysize = 512
       dat_set_maintain, dd[i], 0
       dat_set_compress, dd[i], compress
       dat_set_data, dd[i], grim_blank(xsize, ysize) 
      end

   if(NOT keyword_set(zoom)) then zoom = grim_get_default_zoom(dd[0])

   ;----------------------------------------------
   ; initialize data structure and common block
   ;----------------------------------------------
   grim_data = grim_init(dd, dd0=dd0, zoom=zoom, wnum=wnum, grnum=grnum, type=type, $
       filter=filter, retain=retain, user_callbacks=user_callbacks, $
       user_psym=user_psym, path=path, save_path=save_path, load_path=load_path, $
       cursor_swap=cursor_swap, fov=fov, clip=clip, hide=hide, $
       cam_trs=cam_trs, plt_trs=plt_trs, rng_trs=rng_trs, str_trs=str_trs, stn_trs=stn_trs, sun_trs=sun_trs, arr_trs=arr_trs, $
       cam_select=cam_select, plt_select=plt_select, rng_select=rng_select, str_select=str_select, stn_select=stn_select, arr_select=arr_select, sun_select=sun_select, $
       color=color, xrange=xrange, yrange=yrange, position=position, thick=thick, nsum=nsum, $
       psym=psym, xtitle=xtitle, ytitle=ytitle, cursor_modes=cursor_modes, workdir=workdir, $
       symsize=symsize, nhist=nhist, maintain=maintain, $
       compress=compress, extensions=extensions, max=max, beta=beta, npoints=npoints, $
       visibility=visibility, channel=channel, data_offsets=data_offsets, $
       title=title, render_sample=render_sample, slave_overlays=slave_overlays, $
       render_pht_min=render_pht_min, overlays=overlays, activate=activate)


   ;----------------------------------------------
   ; initialize colors common block
   ;----------------------------------------------
   if(NOT defined(loadct)) then loadct = 0
   if(NOT keyword_set(r_curr)) then loadct, loadct
   ctmod

   ;-----------------------------
   ; widgets
   ;-----------------------------
   if(type NE 'plot') then grim_get_window_size, grim_data, xsize=xsize, ysize=ysize
   grim_widgets, grim_data, xsize=xsize, ysize=ysize, cursor_modes=cursor_modes, $
         menu_fname=menu_fname, menu_extensions=menu_extensions

   grnum = grim_data.grnum 

   planes = grim_get_plane(grim_data, /all)
   for i=0, n_elements(planes)-1 do planes[i].grnum = grnum
   grim_set_plane, grim_data, planes

   grim_set_mode, grim_data, mode_init, /init
   grim_set_data, grim_data, grim_data.base

   grim_resize, grim_data, /init
   widget_control, grim_data.base, map=1
   widget_control, grim_data.draw_base, map=1;, $
             ; xsize=xsize, ysize=ysize;, xoff=SCALE_WIDTH, yoff=SCALE_WIDTH


   geom = widget_info(grim_data.base, /geom)
   grim_data.base_xsize = geom.xsize
   grim_data.base_ysize = geom.ysize

   ;----------------------------------------------
   ; store initial tvim settings
   ;----------------------------------------------
   grim_wset, grim_data, /save

   ;----------------------------------------------
   ; register data descriptor events
   ;----------------------------------------------
   nv_notify_register, dd, 'grim_descriptor_notify', scalar_data=grim_data.base

   xmanager, 'grim', grim_data.base, $
                 /no_block, modal=modal, cleanup='grim_kill_notify'
   if(keyword_set(modal)) then return

  end


 ;======================================================================
 ; change to new window if specified
 ;======================================================================
 if(defined(grnum)) then $
  begin
   grim_data = grim_get_data(grnum=grnum)
   grim_wset, grim_data
  end




 ;======================================================================
 ; update descriptors if any given
 ;  If one plane, then descriptors all go to that plane; in that case
 ;   only one cd, od, sund are allowed
 ;  If multiple planes, descriptors are sorted using gd dd's
 ;  If assoc_dd given as argument, use those instead.  
 ;   In that case, if a map descriptor given, associate cd with dd
 ;   instead of assoc_dd since dd will be the corresponding map.
 ;======================================================================
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(pd)) then pd = dat_gd(gd, dd=dd, /pd)
 if(NOT keyword_set(rd)) then rd = dat_gd(gd, dd=dd, /rd)
 if(NOT keyword_set(sd)) then sd = dat_gd(gd, dd=dd, /sd)
 if(NOT keyword_set(std)) then std = dat_gd(gd, dd=dd, /std)
 if(NOT keyword_set(ard)) then ard = dat_gd(gd, dd=dd, /ard)
 if(NOT keyword_set(sund)) then sund = dat_gd(gd, dd=dd, /sund)
 if(NOT keyword_set(od)) then od = dat_gd(gd, dd=dd, /od)

 grim_data = grim_get_data()
 planes = grim_get_plane(grim_data, /all)
 nplanes = n_elements(planes)
;ncd = n_elements(cd)

 for i=0, nplanes-1 do $
  begin
   _assoc_dd = 0
   if(nplanes NE 1) then _assoc_dd = planes[i].dd
   if(keyword_set(assoc_dd)) then _assoc_dd = assoc_dd[i]

   if(keyword_set(pd)) then $
	 grim_add_descriptor, grim_data, planes[i].pd_p, pd, assoc_dd=_assoc_dd
   if(keyword_set(rd)) then $
	 grim_add_descriptor, grim_data, planes[i].rd_p, rd, assoc_dd=_assoc_dd
   if(keyword_set(std)) then $
	 grim_add_descriptor, grim_data, planes[i].std_p, std, assoc_dd=_assoc_dd
   if(keyword_set(ard)) then $
	 grim_add_descriptor, grim_data, planes[i].ard_p, ard, assoc_dd=_assoc_dd
   if(keyword_set(sd)) then $
	 grim_add_descriptor, grim_data, planes[i].sd_p, sd, assoc_dd=_assoc_dd
   if(keyword_set(sund)) then $
	 grim_add_descriptor, grim_data, planes[i].sund_p, sund[i], /one, assoc_dd=_assoc_dd
   if(keyword_set(od)) then $
     grim_add_descriptor, grim_data, planes[i].od_p, od[i], /one, /noregister, assoc_dd=_assoc_dd

   if(keyword_set(cd)) then $
    begin
     if(keyword_set(_assoc_dd)) then $
       if(cor_class(cd[i]) EQ 'MAP') then _assoc_dd = planes[i].dd
     grim_add_descriptor, grim_data, planes[i].cd_p, cd[i], /one, assoc_dd=_assoc_dd
    end
  end


 ;----------------------------------------------
 ; compute any initial overlays
 ;----------------------------------------------
 if(keyword_set(overlays)) then $
    if(NOT keyword_set(delay_overlays)) then $
                        grim_initial_overlays, grim_data, plane=_plane




 ;=========================================================
 ; if new instance, setup initial view
 ;=========================================================
 if(new) then $
  begin
   grim_set_primary, grim_data.base

   ;----------------------------------------------
   ; sampling
   ;----------------------------------------------
   if(type NE 'plot') then $
      for i=0, nplanes-1 do $
         dat_set_sampling_fn, planes[i].dd, 'grim_sampling_fn', /noevent

   entire = 1 & default = 0
   if(type EQ 'plot') then $
    begin
     entire = 0 & default = 1
    end

   ;----------------------------------------------
   ; initial settings
   ;----------------------------------------------
   widget_control, grim_data.draw, /hourglass
   grim_refresh, grim_data, default=default, entire=entire, $
	xsize=xsize, ysize=ysize, $
	xrange=planes[0].xrange, yrange=planes[0].yrange, $
	zoom=zoom, $
	rotate=rotate, $
	order=order, $
	offset=offset, /no_plot, /no_objects
  end $
 ;=========================================================
 ; if not new instance, just tvim with new settings
 ;=========================================================
 else $
  begin
   grim_data = grim_get_data()

   widget_control, grim_data.draw, /hourglass
   grim_refresh, grim_data, $
	default=default, previous=previous, restore=restore, $
	doffset=doffset, $
	zoom=zoom, $
	rotate=rotate, $
	order=order, $
	offset=offset, no_erase=no_erase
  end


 ;----------------------------------------------
 ; add any callbacks
 ;----------------------------------------------
 if(keyword_set(refresh_callbacks)) then $
        grim_add_refresh_callback, refresh_callbacks, refresh_callback_data_ps

 if(keyword_set(plane_callbacks)) then $
        grim_add_plane_callback, plane_callbacks, plane_callback_data_ps


 ;----------------------------------------------
 ; initial framing
 ;----------------------------------------------
 if(keyword_set(frame)) then $
        grim_initial_framing, grim_data, frame, delay_overlays=delay_overlays


 ;-------------------------
 ; save initial view
 ;-------------------------
 grim_save_initial_view, grim_data
 

 ;----------------------------------------------
 ; initial toggles
 ;----------------------------------------------
 if(keyword_set(plane_syncing)) then $
                   grim_set_toggle_flag, grim_data, 'PLANE_SYNCING', 1
 if(keyword_set(tiepoint_syncing)) then $
                   grim_set_toggle_flag, grim_data, 'TIEPOINT_SYNCING', 1
 if(keyword_set(curve_syncing)) then $
                   grim_set_toggle_flag, grim_data, 'CURVE_SYNCING', 1
 if(keyword_set(highlght)) then $
                   grim_set_toggle_flag, grim_data, 'PLANE_HIGHLIGHT', 1


 ;----------------------------------------------
 ; if new instance, initialize menu extensions
 ;----------------------------------------------
 if(new) then $
  begin
   if(keyword_set(menu_extensions)) then $
    begin
     for i=0, n_elements(menu_extensions)-1 do $
         if(routine_exists(menu_extensions[i]+'_init')) then $
                  call_procedure, menu_extensions[i]+'_init', grim_data
    end
  end

 ;----------------------------------------------
 ; if new instance, initialize cursor modes
 ;----------------------------------------------
 if(new) then $
     for i=0, n_elements(cursor_modes)-1 do $
        if(routine_exists(cursor_modes[i].name+'_init')) then $
            call_procedure, cursor_modes[i].name+'_init', grim_data, cursor_modes[i].data_p



 ;----------------------------------------------
 ; if new instance, initialize menu toggles
 ;----------------------------------------------
 if(new) then $
  begin
   grim_update_menu_toggle, grim_data, $
         'grim_menu_plane_toggle_plane_syncing_event', $
          grim_get_toggle_flag(grim_data, 'PLANE_SYNCING')
   grim_update_menu_toggle, grim_data, $
         'grim_menu_plane_toggle_tiepoint_syncing_event', $
          grim_get_toggle_flag(grim_data, 'TIEPOINT_SYNCING')
   grim_update_menu_toggle, grim_data, $
         'grim_menu_plane_toggle_curve_syncing_event', $
          grim_get_toggle_flag(grim_data, 'CURVE_SYNCING')
   grim_update_menu_toggle, grim_data, $
         'grim_menu_plane_highlight_event', $
          grim_get_toggle_flag(grim_data, 'PLANE_HIGHLIGHT')
  end


 ;-------------------------
 ; draw initial image
 ;-------------------------
 grim_refresh, grim_data, no_erase=no_erase
end
;=============================================================================
