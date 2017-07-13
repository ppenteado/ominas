;=============================================================================
;+
; NAME:
;	juno_epo_input
;
;
; PURPOSE:
;	Juno EPO input translator for Cassini. 
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = juno_epo_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity.
;
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	key1:		Camera descriptor.
;
;  OUTPUT:
;	status:		Zero if valid data is returned.
;
;
;
;
; RETURN:
;	Data associated with the requested keyword.
;
;
;
;
; SEE ALSO:
;	cas_spice_input
;
;
;	
;-
;=============================================================================


;=============================================================================


;===========================================================================
; juno_epo_cameras
;
;===========================================================================
function juno_epo_cameras, dd, ref, pos=pos, constants=constants, $
         n_obj=n_obj, dim=dim, status=status, time=time, orient=orient, obs=obs

 ndd = n_elements(dd)

 ;cas_spice_parse_labels, dd, time, $
 ;      exposure=exposure, size=size, filters=filters, oaxis=oaxis


 ;------------------------------
 ; create a camera descriptor
 ;------------------------------
 cd = cam_create_descriptors(ndd, $
   gd=dd, $
   name=cam_name, $
   orient=cmat, $
   exposure=cam_exposure, $
   avel=cam_avel, $
   pos=cam_pos, $
   vel=cam_vel, $
   time=cam_time, $
   fn_focal_to_image=cam_fn_focal_to_image, $
   fn_image_to_focal=cam_fn_image_to_focal, $
   fi_data=cam_fi_data, $
   scale=cam_scale, $
   fn_psf=cam_fn_psf, $
   filters=cam_filters, $
   size=cam_size, $
   oaxis=cam_oaxis)

return,cd
; return, cas_to_ominas( $
;           spice_cameras(dd, ref, '', '', pos=pos, $
;		sc = sc, $
;		inst = inst, $
;		plat = plat, $
;		orient = orient, $
;		cam_time = time, $
;		cam_scale = make_array(2,ndd, val=scale), $
;		cam_oaxis = oaxis, $
;		cam_fn_psf = make_array(ndd, val='cas_psf'), $
;		cam_filters = filters, $
;		cam_size = size, $
;		cam_exposure = exposure, $
;		cam_fn_focal_to_image = make_array(ndd, val='cam_focal_to_image_linear'), $
;		cam_fn_image_to_focal = make_array(ndd, val='cam_image_to_focal_linear'), $
;		cam_fi_data = [ptrarr(ndd)], $
;		n_obj=n_obj, dim=dim, status=status, constants=constants, obs=obs), $
;                  orient_fn )

end
;===========================================================================



;===========================================================================
; juno_epo_planets
;
;===========================================================================
function juno_epo_planets, dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs

 ;cas_spice_parse_labels, dd, time, target=target

return,0
 ;return, eph_spice_planets(dd, ref, time=time, planets=planets, $
 ;                           n_obj=n_obj, dim=dim, status=status, $ 
 ;                           targ_list=targ_list, $
 ;                           target=target, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; juno_epo_sun
;
;===========================================================================
function juno_epo_sun, dd, ref, n_obj=n_obj, dim=dim, constants=constants, $
                                   status=status, time=time, obs=obs

 ;cas_spice_parse_labels, dd, time
  return,0
 ;return, eph_spice_sun(dd, ref, n_obj=n_obj, dim=dim, $
 ;           status=status, time=time, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; juno_epo_input.pro
;
;
;===========================================================================
function juno_epo_input, dd, keyword, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

  if (keyword eq 'CAM_DESCRIPTORS') then return,juno_epo_cameras(dd, ref, pos=pos, constants=constants, $
	  n_obj=n_obj, dim=dim, status=status, time=time, orient=orient, obs=obs)
  
  return,0


; return, spice_input(dd, keyword, 'cas', values=values, status=status, $
;@nv_trs_keywords_include.pro
;@nv_trs_keywords1_include.pro
;	end_keywords)

end
;===========================================================================
