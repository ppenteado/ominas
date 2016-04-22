;=============================================================================
;+
; NAME:
;	grim_menu_image_profile_event
;
;
; PURPOSE:
;	This option allows you extract a brightness profile in an arbitrary 
;	direction.  The left button selects the region's length and then 
;	width; the right button selects a region with a width of one-pixel.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2005
;	
;-
;=============================================================================
pro grim_menu_image_profile_help_event, event
 text = ''
 nv_help, 'grim_menu_image_profile_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_image_profile_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 junk = grim_get_cameras(grim_data, idp=idp_cam)

 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_image_sector(col=ctred())
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, color='red', psym=3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_image(plane.dd, sigma=sigma, $
                    cd=*plane.cd_p, outline_ps, distance=distance)
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, xtitle='Distance (pixels)', ytitle=['<DN>', 'Sigma'], $
                   title=['Image profile', 'Image profile sigma'], /new
 
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_ring_box_profile_radial_event
;
;
; PURPOSE:
;  This option allows you create a radial brightness profile from a 
;  rectangular image region. 
;  
;   1) Activate the ring from which you wish to extract the profile.  
;  
;   2) Select this option and use the mouse to outline a ring sector:
;  
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2003
;	
;-
;=============================================================================
pro grim_menu_ring_box_profile_radial_help_event, event
 text = ''
 nv_help, 'grim_menu_ring_box_profile_radial_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_ring_box_profile_radial_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 rd = grim_get_active_xds(plane, 'ring')
 if(NOT keyword__set(rd)) then $
  begin
   grim_message, 'There are no active ring points.'
   return
  end

 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_rings(grim_data, idp=idp_rng)
 if(NOT keyword__set(idp_rng[0])) then return


 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_ring_sector_box(col=ctred())
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the ring sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, 'RING_BOX_PROFILE_RADIAL', color='red', psym=-3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_ring(plane.dd, sigma=sigma, w=w, nn=nn, $
                  cd=*plane.cd_p, dkx=rd[0], $
                        gbx=*plane.pd_p, outline_ps, dsk_pts=dsk_pts)
 cor_set_udata, dd[0], 'DISK_PTS', dsk_pts
 cor_set_udata, dd[0], 'RING_BOX_PROFILE_RADIAL_OUTLINE', outline_ps
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, xtitle='Radius', ytitle=['<DN>', 'Sigma'], $
       title=['Radial ring profile', 'Radial ring profile sigmas'], /new
 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_ring_box_profile_longitudinal_event
;
;
; PURPOSE:
;  This option allows you create a longitudinal brightness profile from a 
;  rectangular image region.
;  
;    1) Activate the ring from which you wish to extract the profile. 
;  
;    2) Select this option and use the mouse to outline a ring sector.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2003
;	
;-
;=============================================================================
pro grim_menu_ring_box_profile_longitudinal_help_event, event
 text = ''
 nv_help, 'grim_menu_ring_box_profile_longitudinal_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_ring_box_profile_longitudinal_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 rd = grim_get_active_xds(plane, 'ring')
 if(NOT keyword__set(rd)) then $
  begin
   grim_message, 'There are no active ring points.'
   return
  end

 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_rings(grim_data, idp=idp_rng)
 if(NOT keyword__set(idp_rng[0])) then return


 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_ring_sector_box(col=ctred())
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the ring sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, 'RING_BOX_PROFILE_LONGITUDINAL', color='red', psym=-3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_ring(plane.dd, sigma=sigma, $
                 cd=*plane.cd_p, dkx=rd[0], $
                   gbx=*plane.pd_p, outline_ps, dsk_pts=dsk_pts, /az)
 cor_set_udata, dd[0], 'DISK_PTS', dsk_pts
 cor_set_udata, dd[0], 'RING_BOX_PROFILE_LONGITUDINAL_OUTLINE', outline_ps
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, /new, $
     xtitle='Longitude (deg)', ytitle=['<DN>', 'Sigma'], $
         title=['Longitudinal ring profile', 'Longitudinal ring profile sigmas']
 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_ring_profile_radial_event
;
;
; PURPOSE:
;  This option allows you create a radial brightness profile. 
;  
;   1) Activate the ring from which you wish to extract the profile.  
;  
;   2) Select this option and use the mouse to outline a ring sector:
;  
;      Left Button:   the sector is bounded by lines of constant 
;                     longitude.', $
;      Middle Button: the sector is selected in an arbitrary direction.
;      Left Button:   the sector is bounded by lines perpendicular to 
;                     the projected longitudinal direction.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2003
;	
;-
;=============================================================================
pro grim_menu_ring_profile_radial_help_event, event
 text = ''
 nv_help, 'grim_menu_ring_profile_radial_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_ring_profile_radial_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 rd = grim_get_active_xds(plane, 'ring')
 if(NOT keyword__set(rd)) then $
  begin
   grim_message, 'There are no active ring points.'
   return
  end

 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_rings(grim_data, idp=idp_rng)
 if(NOT keyword__set(idp_rng[0])) then return


 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_ring_sector(cd=*plane.cd_p, dkx=rd[0], $
                                                gbx=*plane.pd_p, col=ctred())
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the ring sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, 'RING_PROFILE_RADIAL', color='red', psym=3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_ring(plane.dd, sigma=sigma, $
                  cd=*plane.cd_p, dkx=rd[0], $
                        gbx=*plane.pd_p, outline_ps, dsk_pts=dsk_pts)
 cor_set_udata, dd[0], 'DISK_PTS', dsk_pts
 cor_set_udata, dd[0], 'RING_PROFILE_RADIAL_OUTLINE', outline_ps
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, xtitle='Radius', ytitle=['<DN>', 'Sigma'], $
       title=['Radial ring profile', 'Radial ring profile sigmas'], /new
 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_ring_profile_longitudinal_event
;
;
; PURPOSE:
;  This option allows you create a longitudinal brightness profile.
;  
;    1) Activate the ring from which you wish to extract the profile. 
;  
;    2) Select this option and use the mouse to outline a ring sector.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2003
;	
;-
;=============================================================================
pro grim_menu_ring_profile_longitudinal_help_event, event
 text = ''
 nv_help, 'grim_menu_ring_profile_longitudinal_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_ring_profile_longitudinal_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 rd = grim_get_active_xds(plane, 'ring')
 if(NOT keyword__set(rd)) then $
  begin
   grim_message, 'There are no active ring points.'
   return
  end

 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_rings(grim_data, idp=idp_rng)
 if(NOT keyword__set(idp_rng[0])) then return


 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_ring_sector(cd=*plane.cd_p, dkx=rd[0], $
                                       gbx=*plane.pd_p, lon=lon, col=ctred())
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the ring sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, 'RING_PROFILE_LONGITUDINAL', color='red', psym=3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_ring(plane.dd, sigma=sigma, $
                 cd=*plane.cd_p, dkx=rd[0], $
                   gbx=*plane.pd_p, outline_ps, dsk_pts=dsk_pts, /az)
 cor_set_udata, dd[0], 'DISK_PTS', dsk_pts
 cor_set_udata, dd[0], 'RING_PROFILE_LONGITUDINAL_OUTLINE', outline_ps
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, /new, $
     xtitle='Longitude (deg)', ytitle=['<DN>', 'Sigma'], $
         title=['Longitudinal ring profile', 'Longitudinal ring profile sigmas']
 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_limb_profile_azimuthal_event
;
;
; PURPOSE:
;  This option allows you create an azimutal brightness profile about a limb.
;  
;    1) Activate the planet from which you wish to extract the profile. 
;  
;    2) Select this option and use the mouse to outline a sector.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2006
;	
;-
;=============================================================================
pro grim_menu_limb_profile_azimuthal_help_event, event
 text = ''
 nv_help, 'grim_menu_limb_profile_azimuthal_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_limb_profile_azimuthal_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 pd = grim_get_active_xds(plane, 'planet')
 if(NOT keyword__set(pd)) then $
  begin
   grim_message, 'There are no active planets.'
   return
  end

 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return


 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_limb_sector(cd=*plane.cd_p, gbx=pd[0], $
                                      col=ctred(), dkd=dkd, az=scan_az)
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the ring sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, 'LIMB_PROFILE_AZIMUTHAL', color='red', psym=3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_ring(plane.dd, sigma=sigma, $
                 cd=*plane.cd_p, dkx=dkd, $
                   gbx=pd[0], outline_ps, dsk_pts=dsk_pts, /az)
 cor_set_udata, dd[0], 'DISK_PTS', dsk_pts
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, /new, $
     xtitle='Azimuth (deg)', ytitle=['<DN>', 'Sigma'], $
         title=['Azimuthal limb profile', 'Azimuthal limb profile sigmas']
 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_limb_profile_radial_event
;
;
; PURPOSE:
;  This option allows you create radial brightness profile across a limb.
;  
;    1) Activate the planet from which you wish to extract the profile. 
;  
;    2) Select this option and use the mouse to outline a sector.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2006
;	
;-
;=============================================================================
pro grim_menu_limb_profile_radial_help_event, event
 text = ''
 nv_help, 'grim_menu_limb_profile_radial_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_limb_profile_radial_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 pd = grim_get_active_xds(plane, 'planet')
 if(NOT keyword__set(pd)) then $
  begin
   grim_message, 'There are no active planets.'
   return
  end

 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return


 ;------------------------------------------------
 ; select the sector by dragging
 ;------------------------------------------------
 grim_logging, grim_data, /start
 outline_ps = pg_limb_sector(cd=*plane.cd_p, gbx=pd[0], col=ctred(), dkd=dkd)
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save the ring sector outline
 ;------------------------------------------------
 grim_add_user_points, outline_ps, 'LIMB_PROFILE_RADIAL', color='red', psym=3, plane=plane

 ;------------------------------------------------
 ; open a new grim window with the profile
 ;------------------------------------------------
 grim_message, /clear
 dd = pg_profile_ring(plane.dd, sigma=sigma, $
                 cd=*plane.cd_p, dkx=dkd, $
                   gbx=pd[0], outline_ps, dsk_pts=dsk_pts)
 cor_set_udata, dd[0], 'DISK_PTS', dsk_pts
 grim_message
 if(NOT keyword_set(dd)) then return

 widget_control, /hourglass
 grim, dd, /new, $
     xtitle='Radius (m)', ytitle=['<DN>', 'Sigma'], $
         title=['Radial limb profile', 'Radial limb profile sigmas']
 

end
;=============================================================================


;=============================================================================
;+
; NAME:
;	grim_menu_pointing_manual_event
;
;
; PURPOSE:
;   This option allows you to change the pointing manually using pg_drag. 
;  
;    1) Activate the points that you wish to drag.  
;  
;    2) Select this option and use the left button to translate your 
;       points, the middle button to rotate them, and the right button 
;       to accept the change and correct the pointing.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_pointing_manual_help_event, event
 text = ''
 nv_help, 'grim_menu_pointing_manual_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_pointing_manual_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;----------------------------------------------------------------------
 ; construct the outlines to use based on currently existing points
 ;----------------------------------------------------------------------
 point_ps = grim_cat_points(grim_data, /active)
 if(NOT keyword_set(point_ps)) then $
  begin
   grim_message, 'There are no active image points.'
   return
  end

 ;------------------------------------------------
 ; find the offset
 ;------------------------------------------------
 axis_ps = ps_init(points=cam_oaxis(*plane.cd_p))
 grim_print, grim_data, 'LEFT: Translate, MIDDLE: Rotate, RIGHT: Accept'

 grim_logging, grim_data, /start
 dxy = pg_drag(point_ps, draw=grim_data.draw, $
               dtheta=dtheta, axis=axis_ps, col=ctpurple(), sample=1)
 grim_logging, grim_data, /stop

 if((dxy[0] EQ 0) AND (dxy[1] EQ 0) AND (dtheta[0] EQ 0)) then return

 ;------------------------------------------------------------
 ; repoint the camera
 ;  NOTE: this will result in a data event and the handler
 ;        for that event will take it from there. 
 ;------------------------------------------------------------
 pg_repoint, dxy, dtheta, axis=axis_ps, cd=*plane.cd_p
 nv_free, axis_ps

 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_pointing_farfit_event
;
;
; PURPOSE:
;   This option produces a rough pointing correction by comparing the
;   active points with edges detected in the image using pg_edges and 
;   pg_farfit.  
;  
;    1) Activate the edges that you wish to correlate.
;  
;    2) Select this option.
;  
;   Only active limbs, terminators, and ring edges are used.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_pointing_farfit_help_event, event
 text = ''
 nv_help, 'grim_menu_pointing_farfit_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_pointing_farfit_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 widget_control, grim_data.draw, /hourglass

 ;----------------------------------------------------------------------
 ; construct the outlines to use based on currently existing points
 ;----------------------------------------------------------------------
 point_ps = grim_cat_points(grim_data, /active)
 if(NOT keyword__set(point_ps)) then $
  begin
   grim_message, 'No active image points.'
   return
  end

 ;------------------------------------------------
 ; scan for edges
 ;------------------------------------------------
 np = n_elements(pg_points(point_ps))/2
 edge_ps = pg_edges(plane.dd, edge=10, np=4*np)
 pg_draw, edge_ps, col=ctgreen()
;stop

 ;------------------------------------------------
 ; find the offset
 ;------------------------------------------------
 grim_message, /clear
 dxy = pg_farfit(plane.dd, edge_ps, [point_ps])
 grim_message

 ;------------------------------------------------------------
 ; repoint the camera
 ;  NOTE: this will result in a data event and the handler
 ;        for that event will take it from here. 
 ;------------------------------------------------------------
 pg_repoint, dxy, 0d, cd=*plane.cd_p
 

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_pointing_lsq_event
;
;
; PURPOSE:
;	Opens a gr_lsqtool widget.  Using the current data, camera, active
;	planet, and active ring descriptors.  See gr_lsqtool.pro for details.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_pointing_lsq_help_event, event
 text = ''
 nv_help, 'gr_lsqtool', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_pointing_lsq_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_sun(grim_data, idp=idp_sun)
 if(NOT keyword__set(idp_sun[0])) then return


 ;------------------------------------------------
 ; open a gr_lsqtool
 ;------------------------------------------------
 wset, grim_data.wnum

 gr_lsqtool, event.top




end
;=============================================================================



;=============================================================================
; grim_get_shift_step
;
;=============================================================================
function grim_get_shift_step, grim_data

 step = grim_get_user_data(grim_data, 'SHIFT_STEP')
 if(NOT keyword_set(step)) then step = 1

 return, step
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_enter_step_event
;
;
; PURPOSE:
;   This option prompts the user to enter the step size for the image-shift
;   menu options.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2012
;	
;-
;=============================================================================
pro grim_menu_shift_enter_step_event_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_enter_step_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_shift_enter_step_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 done = 0
 repeat $
  begin
   steps = dialog_input('New step size:')
   if(NOT keyword_set(steps)) then return
   w = str_isfloat(steps)
   if(w[0] NE -1) then done = 1
  endrep until(done)

 step = double(steps)
 grim_set_user_data, grim_data, 'SHIFT_STEP', step

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_enter_offset_event
;
;
; PURPOSE:
;   This option prompts the user to shift an image by entering an offset.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2012
;	
;-
;=============================================================================
pro grim_menu_shift_enter_offset_event_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_enter_offset_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_shift_enter_offset_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 done = 0
 repeat $
  begin
   offs = dialog_input('New offset:')
   if(NOT keyword_set(offs)) then return
   w = str_isfloat(steps)
   if(w[0] NE -1) then done = 1
  endrep until(done)

 step = double(steps)



 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 step = grim_get_shift_step(grim_data)
 pg_shift, plane.dd, cd=*plane.cd_p, [step,0]


 grim_set_user_data, grim_data, 'SHIFT_STEP', step

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_left_event
;
;
; PURPOSE:
;   This option shifts the image left and corrects the camera pointing 
;   accordingly.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_shift_left_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_left_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_shift_left_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 step = grim_get_shift_step(grim_data)
 pg_shift, plane.dd, cd=*plane.cd_p, [step,0]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_right_event
;
;
; PURPOSE:
;   This option shifts the image right and corrects the camera pointing 
;   accordingly.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_shift_right_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_right_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_shift_right_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 step = grim_get_shift_step(grim_data)
 pg_shift, plane.dd, cd=*plane.cd_p, [-step,0]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_up_event
;
;
; PURPOSE:
;   This option shifts the image up and corrects the camera pointing 
;   accordingly.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_shift_up_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_up_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_shift_up_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 step = grim_get_shift_step(grim_data)
 dy = -step
 grim_wset, grim_data, grim_data.wnum, get=tvd
 if(tvd.order) then dy = step

 pg_shift, plane.dd, cd=*plane.cd_p, [0,dy]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_down_event
;
;
; PURPOSE:
;   This option shifts the image down and corrects the camera pointing 
;   accordingly.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_shift_down_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_down_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_shift_down_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 step = grim_get_shift_step(grim_data)
 dy = step
 grim_wset, grim_data, grim_data.wnum, get=tvd
 if(tvd.order) then dy = -step

 pg_shift, plane.dd, cd=*plane.cd_p, [0,dy]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_shift_drag_event
;
;
; PURPOSE:
;   This option allows the user to shift the image by dragging it with the mouse.
;   The camera pointing is adjusted accordinagly.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2008
;	
;-
;=============================================================================
pro grim_menu_shift_drag_help_event, event
 text = ''
 nv_help, 'grim_menu_shift_down_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_drag_plane_update, xp, yp, junk, color=color, $
       curve_sym=curve_sym, star_sym=star_sym, data=data, psize=psize, fn_data=fn_data
 pixmap = fn_data

 xy0 = (convert_coord([0d,0d], [0d,1d], /data, /to_device))[0:1,*]
 xy = (convert_coord(double(xp), double(yp), /data, /to_device))[0:1,*]

 dxy = xy - xy0
; dtheta = 

 device, set_gr=7
 device, copy=[0,0, !d.x_size,!d.y_size, dxy[0],dxy[1], pixmap]
 device, set_gr=3
end
;----------------------------------------------------------------------------
pro grim_menu_shift_drag_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 
 test_ps = ps_init(points=transpose([transpose([0d,0d]), transpose([0d,1d])])) 

 grim_print, grim_data, 'LEFT: Translate, MIDDLE: Rotate, RIGHT: Accept'

 grim_refresh, grim_data, plane=plane, current=1, /no_objects, /no_axes, $
		      /no_context, /no_callback, /no_back, /no_coord, /no_copy, /noglass

 dxy = -pg_drag(dtheta=dtheta, test_ps, draw=grim_data.draw, $
              fn='grim_drag_plane_update', data=grim_data.redraw_pixmap, sample=1) 

 nv_free, test_ps


 pg_shift, plane.dd, cd=*plane.cd_p, round(dxy)
; pg_shift, plane.dd, cd=*plane.cd_p, dxy


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_corrections_photometry_event
;
;
; PURPOSE:
;	Opens a gr_phttool widget.  Using the primary data, camera, planet, and 
;	ring descriptors.  See gr_phttool.pro for details.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_corrections_photometry_help_event, event
 text = ''
 nv_help, 'gr_phttool', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_corrections_photometry_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_sun(grim_data, idp=idp_sun)
 if(NOT keyword__set(idp_sun[0])) then return


 ;------------------------------------------------
 ; open a gr_phttool
 ;------------------------------------------------
 gr_phttool, event.top


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_project_map_event
;
;
; PURPOSE:
;	Opens a gr_maptool widget.  Using the primary data, camera, planet, and 
;	ring descriptors.  See gr_maptool.pro for details.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_project_map_help_event, event
 text = ''
 nv_help, 'gr_maptool', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_project_map_event, event
@grim_block.include
 grim_set_primary, event.top

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 junk = grim_get_cameras(grim_data, idp=idp_cam)
 if(NOT keyword__set(idp_cam[0])) then return
 junk = grim_get_planets(grim_data, idp=idp_plt)
 if(NOT keyword__set(idp_plt[0])) then return
 junk = grim_get_sun(grim_data, idp=idp_sun)
 if(NOT keyword__set(idp_sun[0])) then return


 ;------------------------------------------------
 ; open a gr_maptool
 ;------------------------------------------------
 gr_maptool


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_mosaic_event
;
;
; PURPOSE:
;	Uses pg_mosaic to combine all visible image planes into a mosaic.  
;	The new mosiac is opened in a new grim instance.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_mosaic_help_event, event
 text = ''
 nv_help, 'grim_menu_mosaic_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_mosaic_event, event

 ;------------------------------------------------
 ; get all visible planes
 ;------------------------------------------------
 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 planes = grim_visible_planes(grim_data)


 ;------------------------------------------------
 ; construct mosaic
 ;------------------------------------------------
 dd_mosaic = pg_mosaic(planes.dd, combine='pgms_combine_median')


 ;--------------------------------------------------------------
 ; open mosaic in new grim window
 ;--------------------------------------------------------------
 grim, /new, dd_mosaic


end
;=============================================================================



;=============================================================================
; NAME:
;	grim_menu_mread_mind_event
;
;=============================================================================
pro grim_menu_mread_mind_event, event

 grim_message, 'Not implemented.'

end
;=============================================================================



;=============================================================================
; grim_default_menus
;
;=============================================================================
function grim_default_menus

 desc = [ '*1\Extract', $
           '1\Ring sector profile' , $
            '0\Radial\grim_menu_ring_profile_radial_event', $ 
            '2\Longitudinal\grim_menu_ring_profile_longitudinal_event', $
           '1\Ring box profile' , $
            '0\Radial\grim_menu_ring_box_profile_radial_event', $ 
            '2\Longitudinal\grim_menu_ring_box_profile_longitudinal_event', $
           '1\Limb sector profile' , $
            '0\Radial\grim_menu_limb_profile_radial_event', $ 
            '2\Azimuthal\grim_menu_limb_profile_azimuthal_event', $
           '0\Image Profile\*grim_menu_image_profile_event', $ 
           '2\Read Mind\grim_menu_mread_mind_event', $ 

	  '*1\Corrections', $
           '1\Pointing' , $
            '0\Manual\grim_menu_pointing_manual_event', $ 
            '0\Farfit\grim_menu_pointing_farfit_event', $
            '2\Least Squares\grim_menu_pointing_lsq_event', $
           '*1\Shift Image' , $
            '0\Enter Step Size \*grim_menu_shift_enter_step_event', $ 
            '0\Enter Offset \*grim_menu_shift_enter_offset_event', $ 
            '0\Left \*grim_menu_shift_left_event', $ 
            '0\Right\*grim_menu_shift_right_event', $
            '0\Up   \*grim_menu_shift_up_event', $
            '0\Down \*grim_menu_shift_down_event', $
            '2\Drag \*grim_menu_shift_drag_event', $
           '2\Photometry\grim_menu_corrections_photometry_event' , $
  
          '#1\Reproject' , $
           '2\Map\#grim_menu_project_map_event', $ 
    
          '#1\Combine' , $
           '2\Mosaic\#grim_menu_mosaic_event' ]


 return, desc
end
;=============================================================================
