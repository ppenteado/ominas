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
;; inst=-61500l, 501=blu, 502=grn, 503=red
 _dd=cor_dereference(dd[0])
 picn=_dd.name.Substring(31,34)
 clri=picn MOD 3
 
 inst=-61500l
;; instc is the spice number for the filter
;; instc=-61501l
 CASE clri OF
  0: instc=-61501l
  1: instc=-61502l
  2: instc=-61503l
  ELSE: PRINT, 'Not RED, GREEN, or BLUE'
ENDCASE
;;  plat (in cas_spice_inpu, this is defined as sc000, e.g. sc=-82, plat=-82000
 plat=-61000l
;;  ref (must be J2000)
 ref='J2000'
;;  et 
 @loadjunokerns ;load in the kernels
 h=dat_header(dd); Need to read in header info first.
 cspice_str2et,h['START_TIME'],et
 et=et+60./1000
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
 
 instVARk1='INS'+strtrim(string(instc),1)+'_DISTORTION_K1'
 instVARk2='INS'+strtrim(string(instc),1)+'_DISTORTION_K2'
 instVARcx='INS'+strtrim(string(instc),1)+'_DISTORTION_X'
 instVARcy='INS'+strtrim(string(instc),1)+'_DISTORTION_Y'
 instVARfo='INS'+strtrim(string(instc),1)+'_FOCAL_LENGTH'
 instVARpx='INS'+strtrim(string(instc),1)+'_PIXEL_SIZE'
 cspice_gdpool, instVARk1, 0, 25, k1, k1found
 cspice_gdpool, instVARk2, 0, 25, k2, k2found
 cspice_gdpool, instVARcx, 0, 25, cx, cxfound
 cspice_gdpool, instVARcy, 0, 25, cy, cyfound
 cspice_gdpool, instVARfo, 0, 25, fo, fofound
 cspice_gdpool, instVARpx, 0, 25, px, pxfound
;; print,cx,cy
; XX=[[0,1,0,k1,0,k2],[0,0,0,0,0,0],[0,k1,0,2*k2,0,0],[0,0,0,0,0,0],[0,k2,0,0,0,0],[0,0,0,0,0,0]]
; YY=transpose(XX)
; XX[0]=x0
; YY[0]=y0
; PP=XX
; QQ=YY
; fi_data={XX:XX, YY:YY, PP:PP, QQ:QQ}
 fl=fo/px
 fi_data={k1:k1, k2:k2, cx:cx, cy:cy, fl:fl}
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
   fn_focal_to_image='cam_focal_to_image_juno_epo', $
   ; can leave undefined, defaults to 'cam_image_to_focal_linear' (from documentation)
   fn_image_to_focal='cam_image_to_focal_juno_epo', $
   ; additional info for two functions above (leave this empty for now)
   ;;fi_data=cam_fi_data, $
   ;;fi_data=[nv_ptr_new(XX), nv_ptr_new(YY), nv_ptr_new(PP), nv_ptr_new(QQ)], $
;   fi_data=nv_ptr_new(fi_data), $
   ; cam_scale is angular size of one pixel, x y, in radians (from documentation, 0.6727 in mrad)
   ;0.0006729d0,0.0006736
   scale=[0.0006727d0,0.0006727d0], $
   ; point spread function, see seciton 4.3 https://link.springer.com/article/10.1007/s11214-014-0079-x
   ; need to define a function to handle this... (from documentation)
   fn_psf=cam_fn_psf, $
   ; cam filters in h['FILTERS']
   filters=replicate(h['FILTER_NAME',0],cam_nfilters()), $
   ; cam_size pixels in x y (from documentation)
   ; "1640×1214 7.4-micron pixels (1600×1200 photoactive)" tho .PNG files have 1648 width. Strips have 128 height.
   size=[1648,128], $
   ; cam_oaxis pixel x y value for optical axis (from documentation)
   ;oaxis=cam_oaxis)
   oaxis=[cx,cy])
;   oaxis=[824,72])
 cam_set_fi_data, cd, fi_data, /noevent
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
 et=et+60./1000
 expoms=strsplit(h['EXPOSURE_DURATION'],' ',/EXTRACT)
 expos=double(expoms[0])/1000
 time=et+expos/2
 target=[h['TARGET_NAME']]
 ;; eph to gen
 return, gen_spice_planets(dd, ref, time=time, planets=planets, $
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
 ; return,0
 ref='J2000'
 @loadjunokerns
 h=dat_header(dd)
 cspice_str2et,h['START_TIME'],et
 et=et+60./1000
 expoms=strsplit(h['EXPOSURE_DURATION'],' ',/EXTRACT)
 expos=double(expoms[0])/1000
 time=et+expos/2
 return, gen_spice_sun(dd, ref, n_obj=n_obj, dim=dim, $
            status=status, time=time, constants=constants, obs=obs)

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
  
  if (keyword eq 'STR_DESCRIPTORS') then return,juno_epo_sun(dd, ref, constants=constants, $
    n_obj=n_obj, dim=dim, status=status, time=time, obs=obs)
; return, spice_input(dd, keyword, 'juno_epo', values=values, status=status, $
;@nv_trs_keywords_include.pro
;@nv_trs_keywords1_include.pro
;	end_keywords)

end
;===========================================================================
