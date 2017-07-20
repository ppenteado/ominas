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


;; Need to define:
;;  sc  Need to be long
 sc=-61l
;;  inst
 inst=-61500l
;;  plat (in cas_spice_inpu, this is defined as sc000, e.g. sc=-82, plat=-82000
 plat=-61000l
;;  ref (must be J2000)
 ref='J2000'
;;  et (needs to be read from metadat, I think...
 @loadjunokerns ;load in the kernels
 h=dat_header(dd); Need to read in header info first.
 cspice_str2et,h['START_TIME'],et
;;  tol (must be 0)
 tol=0
;;  pos_only (should be 0)
 pos_only=0
;; obs (must be 0)
 obs=0
;; Need call to spice_get_cameras, sc, inst, plat, ref, et, tol, $
;; cam_pos, cam_vel, cmat, cam_avel, pos_only, obs=obs
;;   See ~/Dropbox/.../spice_get_cameras__ref.pro for references

 status=spice_get_cameras( sc, inst, plat, ref, et, tol, $
    cam_pos, cam_vel, cmat, cam_avel, pos_only, obs=obs)

 ;------------------------------
 ; create a camera descriptor
 ;------------------------------
 ; see commented section beloy for CAS examples
 expoms=strsplit(h['EXPOSURE_DURATION'],' ',/EXTRACT)
 expos=double(expoms[0])/1000
 cd = cam_create_descriptors(ndd, $
   gd=dd, $
   ; cam name dat_instrument(dd)
   name=dat_instrument(dd), $
   orient=cmat, $
   ;cam exposure h['EXPOSURETIME??']   
   exposure=expos, $
   avel=cam_avel, $
   pos=cam_pos, $
   vel=cam_vel, $
   ; cam_time is et in middle of exposure (may need to add half exposure time) h['EXPOSURETIME']
   time=et+expos/2, $
   ; can leave undefined, defaults to 'cam_focal_to_image_linear' (from documentation)
   fn_focal_to_image=cam_focal_to_image_linear, $
   ; can leave undefined, defaults to 'cam_image_to_focal_linear' (from documentation)
   fn_image_to_focal=cam_image_to_focal_linear, $
   ; additional info for two functions above (leave this empty for now)
   fi_data=cam_fi_data, $
   ; cam_scale is angular size of one pixel, x y, in radians (from documentation, 0.6727 in mrad)
   scale=[0.0006727d0,0.0006727d0], $
   ; point spread function, see seciton 4.3 https://link.springer.com/article/10.1007/s11214-014-0079-x
   ; need to define a function to handle this... (from documentation)
   fn_psf=cam_fn_psf, $
   ; cam filters in h['FILTERS']
   filters=replicate(h['FILTER_NAME',0],cam_nfilters()), $
   ; cam_size pixels in x y (from documentation)
   ; "1640×1214 7.4-micron pixels (1600×1200 photoactive)" tho .PNG files have 1648 width. Strips have 128 height.
   size=[1600,128], $
   ; cam_oaxis pixel x y value for optical axis (from documentation)
   ;oaxis=cam_oaxis)
   oaxis=[824,64])

 bod_set_orient, cd, call_function('juno_epo_cmat_to_orient', bod_orient(cd))
 ;bod_set_orient, cd, bod_orient(cd)
 bod_set_pos, cd, bod_pos(cd)*1000d   ; km --> m
 bod_set_vel, cd, bod_vel(cd)*1000d   ; km/s --> m/s

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
function juno_epo_spice_planets, dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs

 ;cas_spice_parse_labels, dd, time, target=target

;return,0
 ref='J2000'
 @loadjunokerns
 h=dat_header(dd)
 cspice_str2et,h['START_TIME'],et
 expoms=strsplit(h['EXPOSURE_DURATION'],' ',/EXTRACT)
 expos=double(expoms[0])/1000
 time=et+expos/2
 target=[h['TARGET_NAME']]
 return, eph_spice_planets(dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, $
                            target=target, constants=constants, obs=obs)

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
  
;  return,0

if (keyword eq 'PLT_DESCRIPTORS') then return,juno_epo_spice_planets(dd, ref, constants=constants, $
  n_obj=n_obj, dim=dim, status=status, time=time, obs=obs,  targ_list=targ_list,planets=planets)
; return, spice_input(dd, keyword, 'juno_epo', values=values, status=status, $
;@nv_trs_keywords_include.pro
;@nv_trs_keywords1_include.pro
;	end_keywords)

end
;===========================================================================
