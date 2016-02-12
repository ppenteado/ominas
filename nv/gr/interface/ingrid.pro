;=============================================================================
;+
; NAME:
;	INGRID
;
;
; PURPOSE:
;	INterface to GRIm Data -- command-line access to grim data.
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	ingrid, gd=gd
;
;
; ARGUMENTS:
;  INPUT:
;	grnum:	Grim window number.  If not given, the most recently accessed
;	        grim instance is used.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	pn:	Plane numer(s) to access.  If not given, then current plane
;		is used.
;
;	all:	If set, all planes are used.
;
;  OUTPUT:
;	dd:	Grim's data descriptor.
;
;	cd:	Grim's camera descriptor.
;
;	pd:	Grim's planet descriptors.
;
;	rd:	Grim's ring descriptors.
;
;	sd:	Grim's star descriptors.
;
;	sund:	Grim's sun descriptor.
;
;	od:	Grim's observer descriptor.
;
;	cd:	Grim's camera descriptor.
;
;	gd:	Generic descriptor containing all of the above descriptors. 
;
;	limb_ps:	points_struct giving the limb points.
;
;	ring_ps:	points_struct giving the ring points.
;
;	star_ps:	points_struct giving the star points.
;
;	term_ps:	points_struct giving the terminator points.
;
;	plgrid_ps:	points_struct giving teh planet grid points.
;
;	center_ps:	points_struct giving the planet centers.
;
;	object_ps:	points_struct giving all overlay points.
;
;	tie_ps:		points_struct giving the tie points.
;
;	curve_ps:	points_struct giving the curve points.
;
;
; PROCEDURE:
;	The returned descriptors allow direct access to the memory images of
;	grim's descriptor set.  Therefore changes made from the command line
;	affect the descriptors that grim is using.  Moreover, grim monitors
;	those descriptors and updates itself whenever a change occurs.  
;
;
; EXAMPLE:
;	(1) Open a grim window, load an image, and compute limb points.
;
;	(2) At the command line:
;
;		IDL> ingrid, cd=cd
;		IDL> pg_repoint, [50,50], 0d, cd=cd
;
;	Grim should detect the change to the camera descriptor and update
;	itself by recomputing the limb points.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	grim, gr_draw
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro ingrid, grnum, gd=_gd, $
         dd=_dd, cd=_cd, pd=_pd, rd=_rd, sd=_sd, std=_std, ard=_ard, sund=_sund, od=_od, $
         limb_ps=_limb_ps, ring_ps=_ring_ps, star_ps=_star_ps, station_ps=_station_ps, array_ps=_array_ps, term_ps=_term_ps, $
         plgrid_ps=_plgrid_ps, center_ps=_center_ps, object_ps=_object_ps, $
         tie_ps=_tie_ps, curve_ps=_curve_ps, shadow_ps=_shadow_ps, pn=pn, all=all, grnum=_grnum, $
         active_pd=_active_pd, active_rd=_active_rd, active_sd=_active_sd, $
         active_std=_active_std, active_ard=_active_ard, active_xd=_active_xd, $
         active_limb_ps=_active_limb_ps, active_ring_ps=_active_ring_ps, $
         active_star_ps=_active_star_ps, active_term_ps=_active_term_ps, $
         active_plgrid_ps=_active_plgrid_ps, active_center_ps=_active_center_ps, $
         active_shadow_ps=_active_shadow_ps, active_station_ps=_active_station_ps, $
         active_array_ps=_active_array_ps


 active = keyword_set(active)

 if(defined(grnum)) then $
                     grim_data = grim_get_data(grim_grnum_to_top(grnum)) $
 else grim_data = grim_get_data(/primary)

 _grnum = grim_data.grnum

 if(NOT defined(pn)) then pn = grim_data.pn
 if(pn LT 0) then pn = grim_data.pn
 if(pn[0] LT 0) then pn = grim_data.pn
 if(keyword_set(all)) then $
  begin
   planes = grim_get_plane(grim_data, /all)
   pn = planes.pn
  end

 npn = n_elements(pn)

 for i=0, npn-1 do $
  begin
   plane = grim_get_plane(grim_data, pn=pn[i])
   if(plane.pn NE -1) then $
    begin

     if(arg_present(_dd)) then dd = append_array(dd, plane.dd)

     if(arg_present(_cd)) then cd = append_array(cd, *plane.cd_p)
     if(arg_present(_pd)) then pd = append_array(pd, tr(*plane.pd_p))
     if(arg_present(_rd)) then rd = append_array(rd, tr(*plane.rd_p))
     if(arg_present(_sd)) then sd = append_array(sd, tr(*plane.sd_p))
     if(arg_present(_std)) then std = append_array(std, tr(*plane.std_p))
     if(arg_present(_ard)) then ard = append_array(ard, tr(*plane.ard_p))
     if(arg_present(_sund)) then sund = append_array(sund, *plane.sund_p)
     if(arg_present(_od)) then od = append_array(od, *plane.od_p)

     if(arg_present(_active_pd)) then $
        active_pd = append_array(active_pd, grim_get_active_xds(plane, 'planet'))
     if(arg_present(_active_rd)) then $
        active_rd = append_array(active_rd, grim_get_active_xds(plane, 'ring'))
     if(arg_present(_active_sd)) then $
        active_sd = append_array(active_sd, grim_get_active_xds(plane, 'star'))
     if(arg_present(_active_std)) then $
        active_std = append_array(active_std, grim_get_active_xds(plane, 'station'))
     if(arg_present(_active_ard)) then $
        active_ard = append_array(active_ard, grim_get_active_xds(plane, 'station'))

     if(arg_present(_active_limb_ps)) then $
        _active_limb_ps = append_array(active_limb_ps, $
                          grim_get_active_overlays(grim_data, 'limb'))
     if(arg_present(_active_ring_ps)) then $
        _active_ring_ps = append_array(active_ring_ps, $
                          grim_get_active_overlays(grim_data, 'ring'))
     if(arg_present(_active_star_ps)) then $
        _active_star_ps = append_array(active_star_ps, $
                          grim_get_active_overlays(grim_data, 'star'))
     if(arg_present(_active_term_ps)) then $
        _active_term_ps = append_array(active_term_ps, $
                          grim_get_active_overlays(grim_data, 'terminator'))
     if(arg_present(_active_plgrid_ps)) then $
        _active_plgrid_ps = append_array(active_plgrid_ps, $
                          grim_get_active_overlays(grim_data, 'planet_grid'))
     if(arg_present(_active_center_ps)) then $
        _active_center_ps = append_array(active_center_ps, $
                          grim_get_active_overlays(grim_data, 'planet_center'))
     if(arg_present(_active_shadow_ps)) then $
        _active_shadow_ps = append_array(active_shadow_ps, $
                          grim_get_active_overlays(grim_data, 'shadow'))
     if(arg_present(_active_station_ps)) then $
        _active_station_ps = append_array(active_station_ps, $
                          grim_get_active_overlays(grim_data, 'station'))
     if(arg_present(_active_array_ps)) then $
        _active_array_ps = append_array(active_array_ps, $
                          grim_get_active_overlays(grim_data, 'array'))

     if(arg_present(_active_xd)) then $
                    active_xd = append_array(active_xd, *plane.active_xd_p)

     if(arg_present(_limb_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'limb'))) then $
                  limb_ps = append_array(limb_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'limb')))
     if(arg_present(_ring_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'ring'))) then $
                  ring_ps = append_array(ring_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'ring')))
     if(arg_present(_star_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'star'))) then $
                  star_ps = append_array(star_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'star'))) 
     if(arg_present(_term_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'terminator'))) then $
                  term_ps = append_array(term_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'terminator'))) 
     if(arg_present(_plgrid_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'planet_grid'))) then $
                  plgrid_ps = append_array(plgrid_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'planet_grid'))) 
     if(arg_present(_center_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'planet_center'))) then $
                  center_ps = append_array(center_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'planet_center'))) 
     if(arg_present(_shadow_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'shadow'))) then $
                  shadow_ps = append_array(shadow_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'shadow'))) 
     if(arg_present(_object_ps)) then $
        object_ps = append_array(object_ps, grim_cat_points(grim_data))
     if(arg_present(_station_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'station'))) then $
                  station_ps = append_array(station_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'station'))) 
     if(arg_present(_array_ps)) then $
      if(ptr_valid(grim_get_overlay_psp(grim_data, plane=plane, 'array'))) then $
                  array_ps = append_array(array_ps, *(grim_get_overlay_psp(grim_data, plane=plane, 'array'))) 

     if(arg_present(_tie_ps)) then $
                    tie_ps = append_array(tie_ps, *plane.tie_psp)

     if(arg_present(_curve_ps)) then $
                  curve_ps = append_array(curve_ps, *plane.curve_psp)
    end
  end
 if(keyword_set(pd)) then pd = reform(tr(pd))
 if(keyword_set(rd)) then rd = reform(tr(rd))
 if(keyword_set(sd)) then sd = reform(tr(sd))
 if(keyword_set(std)) then std = reform(tr(std))
 if(keyword_set(ard)) then ard = reform(tr(ard))


 if(keyword_set(dd)) then _dd = dd 
 if(keyword_set(cd)) then _cd = cd 
 if(keyword_set(pd)) then _pd = pd 
 if(keyword_set(rd)) then _rd = rd 
 if(keyword_set(sd)) then _sd = sd 
 if(keyword_set(std)) then _std = std 
 if(keyword_set(ard)) then _ard = ard 
 if(keyword_set(active_pd)) then _active_pd = active_pd 
 if(keyword_set(active_rd)) then _active_rd = active_rd 
 if(keyword_set(active_sd)) then _active_sd = active_sd 
 if(keyword_set(active_std)) then _active_std = active_std 
 if(keyword_set(active_ard)) then _active_ard = active_ard 
 if(keyword_set(sund)) then _sund = sund 
 if(keyword_set(od)) then _od = od
 if(keyword_set(active_limb_ps)) then _active_limb_ps = active_limb_ps 
 if(keyword_set(active_ring_ps)) then _active_ring_ps = active_ring_ps 
 if(keyword_set(active_star_ps)) then _active_star_ps = active_star_ps 
 if(keyword_set(active_term_ps)) then _active_term_ps = active_term_ps
 if(keyword_set(active_plgrid_ps)) then _active_plgrid_ps = active_plgrid_ps 
 if(keyword_set(active_center_ps)) then _active_center_ps = active_center_ps 
 if(keyword_set(active_station_ps)) then _active_station_ps = active_station_ps 
 if(keyword_set(active_array_ps)) then _active_array_ps = active_array_ps 
 if(keyword_set(limb_ps)) then _limb_ps = limb_ps 
 if(keyword_set(ring_ps)) then _ring_ps = ring_ps 
 if(keyword_set(star_ps)) then _star_ps = star_ps 
 if(keyword_set(term_ps)) then _term_ps = term_ps
 if(keyword_set(plgrid_ps)) then _plgrid_ps = plgrid_ps 
 if(keyword_set(center_ps)) then _center_ps = center_ps 
 if(keyword_set(station_ps)) then _station_ps = station_ps 
 if(keyword_set(array_ps)) then _array_ps = array_ps 
 if(keyword_set(object_ps)) then _object_ps = object_ps

 w = where(ps_valid(tie_ps))
 if(w[0] NE -1) then _tie_ps = tie_ps

 w = where(ps_valid(curve_ps))
 if(w[0] NE -1) then _curve_ps = curve_ps

 if(keyword_set(shadow_ps)) then _shadow_ps = shadow_ps

 gd = pgs_make_gd(dd=dd, crd=crd, bd=bd, md=md, dkd=dkd, $
                  gbd=gbd, pd=pd, sd=sd, std=std, ard=ard, rd=rd, cd=cd, sund=sund, od=od)

 if(keyword_set(gd)) then _gd = gd

end
;=============================================================================
