;=============================================================================
;+
; NAME:
; juno_epo_input
;
;
; PURPOSE:
; Juno EPO input translator for Cassini. 
;
;
; CATEGORY:
; NV/CONFIG
;
;
; CALLING SEQUENCE:
; result = juno_epo_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
; dd:   Data descriptor.
;
; keyword:  String giving the name of the translator quantity.
;
;
;  OUTPUT:
; NONE
;
;
; KEYWORDS:
;  INPUT:
; key1:   Camera descriptor.
;
;  OUTPUT:
; status:   Zero if valid data is returned.
;
;
;
;
; RETURN:
; Data associated with the requested keyword.
;
;
;
;
; SEE ALSO:
; cas_spice_input
;
;
; 
;-
;=============================================================================



;===========================================================================
; juno_epo_spice_cameras
;
;===========================================================================
function juno_epo_spice_cameras, dd, ref, pos=pos, constants=constants, $
  n_obj=n_obj, dim=dim, status=status, time=time, orient=orient, obs=obs

  ndd = n_elements(dd)
  
  ret=list()  
  for idd=0,ndd-1 do begin
    
    _dd=cor_dereference(dd[idd])
    h=dat_header(dd[idd]); Need to read in header info first.
  
    ;; Need to define:
    ;;  sc  Need to be long
    sc=-61l
    inst=-61500l
    ;;  plat (in cas_spice_inpu, this is defined as sc000, e.g. sc=-82, plat=-82000
    plat=-61000l
    ;;  ref (must be J2000)
    ref='J2000'
    ;;  et
    cspice_str2et,h['START_TIME'],et0
    et0=et0+60d-3 ;exposure starts 60ms after the time indicated in the header
    idelay=double((strsplit(h['INTERFRAME_DELAY'],/extract))[0])
    ;;  tol (must be 0)
    tol=0
    ;;  pos_only (should be 0)
    pos_only=0
    ;; obs (must be 0)
    obs=0
  
  
    nframes=h['LINES']/128
    
    
    for iframe=0,nframes-1 do begin
    
      picn=iframe;_dd.name.Substring(31,34)
      clri=picn MOD 3
      et=et0+(iframe/3)*idelay
    
      ;; instc is the spice number for the filter
      ;; inst=-61500l, 501=blu, 502=grn, 503=red
      CASE clri OF
        0: instc=-61501l
        1: instc=-61502l
        2: instc=-61503l
        ELSE: PRINT, 'Not RED, GREEN, or BLUE'
      ENDCASE
      ;; Need call to spice_get_cameras, sc, inst, plat, ref, et, tol, $
      ;; cam_pos, cam_vel, cmat, cam_avel, pos_only, obs=obs
      ;;   See ~/Dropbox/.../spice_get_cameras__ref.pro for references
    
      status=spice_get_cameras( sc, inst, plat, ref, et, tol, $
        cam_pos, cam_vel, cmat, cam_avel, pos_only, obs=obs)
        
      cspice_getfov,instc,4,shape,frame,bsight,bounds
      
      ;do some geometry checks
      cspice_sincpt,'ellipsoid','JUPITER',et,'IAU_JUPITER','NONE', $
                     '-61000',frame,bsight,spoint,trgepc,srfvec,found
      nv_message,verb=1.1,'junocam frame:'+strtrim(iframe,2)
      cspice_reclat, spoint,  radius, lon, lat
      if found then nv_message,verb=1.1,'boresight surface intercept:'+string(lon*180/!dpi,lat*180d0/!dpi)
      cspice_spkezr,'JUPITER', et,frame,'NONE','-61000',starg,ltime
      nv_message,verb=1.1,string(cspice_vsep(bsight,starg[0:2])*180d0/!dpi)
      nv_message,verb=1.1,'target-observer distance:'+strtrim(norm(starg),2)
      cspice_sincpt,'ellipsoid','JUPITER',et,'IAU_JUPITER','NONE', $
        '-61000',frame,starg[0:2],spoint,trgepc,srfvec,found
      cspice_reclat, spoint,  radius, lon, lat
      nv_message,verb=1.1,'subspacecraft point:'+string(lon*180/!dpi,lat*180d0/!dpi)
      
      ;build cmat for instrument (there is no frame associated with each band,
      ;so cannot just use spice_get_cameras
      ;need to create cmat from junocam frame and bsight vector
      cspice_pxform,frame,'J2000',et,rotatem
      ang=cspice_vsep([0d0,0d0,1d0],bsight)
      cspice_ucrss,[0d0,0d0,1d0],bsight,iaxis
      cspice_axisar,iaxis,-ang,r
      cmat=-r##transpose(rotatem)
      cmat[*,2]*=-1
      
      
    
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
        ;fn_focal_to_image='cam_focal_to_image_juno_epo', $
        ; can leave undefined, defaults to 'cam_image_to_focal_linear' (from documentation)
        ;fn_image_to_focal='cam_image_to_focal_juno_epo', $
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
        filters=replicate(h['FILTER_NAME',clri],cam_nfilters()), $
        ; cam_size pixels in x y (from documentation)
        ; "1640×1214 7.4-micron pixels (1600×1200 photoactive)" tho .PNG files have 1648 width. Strips have 128 height.
        size=[1608,128], $ ;without overscan
        ; cam_oaxis pixel x y value for optical axis (from documentation)
        ;oaxis=cam_oaxis)
        ;oaxis=[cx,cy])
        oaxis=[802.5d0,63.5d0]) ;center of each band's field of view
      ;   oaxis=[824,72])
      cam_set_fi_data, cd, fi_data, /noevent
      bod_set_orient, cd, call_function('juno_epo_cmat_to_orient', bod_orient(cd))
      ;bod_set_orient, cd, bod_orient(cd)
      bod_set_pos, cd, bod_pos(cd)*1000d   ; km --> m
      bod_set_vel, cd, bod_vel(cd)*1000d   ; km/s --> m/s
  
      ret.add,cd[0]
  
    endfor ;loop in frames
  endfor ;loop in dd
  
  return,ret.toarray()

end
;===========================================================================





;===========================================================================
; juno_epo_spice_planets
;
;===========================================================================
function juno_epo_spice_planets, dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs


  ;return,0
  ref='J2000'
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
; juno_epo_spice_sun
;
;===========================================================================
function juno_epo_spice_sun, dd, ref, n_obj=n_obj, dim=dim, constants=constants, $
                                   status=status, time=time, obs=obs

  ;cas_spice_parse_labels, dd, time
  ; return,0
  ref='J2000'
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
; juno_epo_spice_input.pro
;
;
;===========================================================================
function juno_epo_spice_input, dd, keyword, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 return, spice_input(dd, keyword, 'juno', 'epo', values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords)

end
;===========================================================================
