;=============================================================================
;+
; NAME:
;	vgr_spice_input
;
;
; PURPOSE:
;	NAIF/SPICE input translator for Voyager.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = vgr_spice_input(dd, keyword)
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
;	n_obj:		Number of objects returned.
;
;	dim:		Dimensions of return objects.
;
;
;  TRANSLATOR KEYWORDS:
;	ref:		Name of the reference frame for the output quantities.
;			Default is 'j2000'.
;
;	j2000:		/j2000 is equivalent to specifying ref=j2000.
;
;	b1950:		/b1950 is equivalent to specifying ref=b1950.
;
;	klist:		Name of a file giving a list of SPICE kernels to use.
;			If no path is included, the path is taken from the 
;			NV_SPICE_KER environment variable.
;
;	ck_in:		List of input C kernel files to use.  List must be 
;			delineated by semimcolons with no space.  The kernel
;			list file is still used, but these kernels take
;			precedence.  Entries in this list may be file
;			specification strings.
;
;	planets:	List of planets to for which to request ephemeris.  
;			Must be delineated by semicolons with no space.
;
;	reload:		If set, new kernels are loaded, as specified by the
;			klist and ck_in keywords.
;
;
; RETURN:
;	Data associated with the requested keyword.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	vgr_spice_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================


;===========================================================================
; vgr_spice_cameras
;
;===========================================================================
function vgr_spice_cameras, dd, ref, pos=pos, constants=constants, $
        n_obj=n_obj, dim=dim, status=status, time=time, orient=orient, obs=obs

 sc_name = vgr_parse_inst(dat_instrument(dd), cam=cam_name)
 sc = -31l
 if(sc_name EQ 'vg2') then sc = -32l

 plat = 0l

 inst = sc*1000 - 001l					; na camera
 if(cam_name EQ 'wa') then inst = sc*1000 - 002l	; wa camera
 orient_fn = 'vgr_cmat_to_orient_iss'

 label = dat_header(dd)

 ;-----------------------------------
 ; cam_time
 ;-----------------------------------
 if(NOT keyword__set(time)) then $
  begin
   time = vgr_spice_time(label, dt=dt, status=status)
   if(status NE 0) then return, obj_new()
   time = spice_str2et(time)
   cam_time = time + dt
  end $
 else cam_time = time

 ;-----------------------------------
 ; geom'd image
 ;-----------------------------------
 geom = 0
 if(keyword__set(label)) then $
  begin
   if(strpos(label,'GEOM') NE -1) then geom = 1
   if(strpos(label,'FARENC') NE -1) then geom = 1
   if(strpos(label,'*** OBJECT SPACE') NE -1) then geom = 1
   s = size(dat_data(dd))
   if(s[1] EQ 1000 AND s[2] EQ 1000) then geom = 1
  end
 
 if((geom)) then $
  begin
   cam_scale = vgr_pixel_scale(cam_name, /geom)
   cam_nx = 1000d
   cam_ny = 1000d
  end $
 ;-------------------------------------------------------
 ; raw image   
 ;  Here we use initial guesses.  That's the best that
 ;  can be done before reseau marks are analyzed.
 ;-------------------------------------------------------
 else $
  begin
   cam_scale = vgr_pixel_scale(cam_name)
;   cam_scale = cam_scale / 0.85d			; just a guess!!
   cam_nx = 800d
   cam_ny = 800d
  end

 ;-----------------------------------
 ; oaxis
 ;-----------------------------------
 cam_oaxis = [(cam_nx - 1.), (cam_ny - 1.)]/2.

 ;-----------------------------------
 ; exposure time
 ;-----------------------------------
 if(keyword__set(label)) then $
                    cam_exposure = vicar_vgrkey(label, 'EXP') / 1000d



 return, vgr_to_ominas( $
           spice_cameras(dd, ref, '', '', pos=pos, $
		sc = sc, $
		inst = inst, $
		plat = plat, $
		tol = 100d, $
		orient = orient, $
		cam_time=cam_time, $
		cam_scale = cam_scale, $
		cam_oaxis = cam_oaxis, $
		cam_fn_psf = 'vgr_psf', $
		cam_size = [cam_nx, cam_ny], $
		cam_exposure = cam_exposure, $
		cam_fn_focal_to_image = cam_focal_to_image_linear, $
		cam_fn_image_to_focal = cam_image_to_focal_linear, $
		cam_fn_data = [nv_ptr_new()], $
		n_obj=n_obj, dim=dim, status=status, constants=constants, obs=obs), $
                   orient_fn )

end
;===========================================================================



;===========================================================================
; vgr_spice_planets
;
;===========================================================================
function vgr_spice_planets, dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs

 label = dat_header(dd)

 if(NOT keyword__set(time)) then $
  begin 
   time = vgr_spice_time(label, dt=dt, status=status)
   if(status NE 0) then return, obj_new()
   time = spice_str2et(time)
   plt_time = time + dt
  end $
 else plt_time = time

 if(keyword__set(label)) then $
  begin
   target = strupcase(vicgetpar(label, 'TARGET_NAME'))
  end

 return, eph_spice_planets(dd, ref, time=plt_time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, $
                            target=target, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; vgr_spice_sun
;
;===========================================================================
function vgr_spice_sun, dd, ref, n_obj=n_obj, dim=dim, $
                   status=status, time=time, constants=constants, obs=obs

 label = dat_header(dd)

 if(NOT keyword__set(time)) then $
  begin
   time = vgr_spice_time(label, dt=dt, status=status)
   if(status NE 0) then return, obj_new()
   time = spice_str2et(time)
   sun_time = time + dt
  end $
 else sun_time = time

 return, eph_spice_sun(dd, ref, n_obj=n_obj, dim=dim, $
                    status=status, time=sun_time, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; vgr_spice_input.pro
;
;
;===========================================================================
function vgr_spice_input, dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 return, spice_input(dd, keyword, 'vgr', n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords)

end
;===========================================================================
