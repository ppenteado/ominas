;=============================================================================
;+
; NAME:
;	dawn_spice_input
;
;
; PURPOSE:
;	NAIF/SPICE input translator for Dawn. 
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = dawn_spice_input(dd, keyword)
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
;	dawn_spice_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================


;===========================================================================
; dawn_spice_cameras
;
;===========================================================================
function dawn_spice_cameras, dd, ref, pos=pos, constants=constants, $
         n_obj=n_obj, dim=dim, status=status, time=time, orient=orient, obs=obs

 cam_name = nv_instrument(dd)

 sc = -203l
 plat = -203000l

 label = nv_header(dd)

 if(NOT keyword_set(time)) then $
  begin
   time = dawn_spice_time(label, dt=dt, status=status)
   if(status NE 0) then return, ptr_new()
   time = spice_str2et(time)
   cam_time = time + dt
  end $
 else cam_time = time

 bin = 1
 cam_nx = (cam_ny = 1024d)
 if(keyword_set(label)) then $
  begin
   cam_exposure = pdspar(label, 'EXPOSURE_DURATION')/1000d
   cam_nx = double((pdspar(label, 'LINE_SAMPLES'))[0])
   cam_ny = double((pdspar(label, 'LINES'))[0])
  end

 cam_oaxis = [(cam_nx - 1.), (cam_ny - 1.)]/2.

 case cam_name of
	'DAWN_FC1': $
	  begin
	   inst=-203110l
	   orient_fn = 'dawn_cmat_to_orient_fc'
	  end
	'DAWN_FC2': $
	  begin
	   inst=-203120l
	   orient_fn = 'dawn_cmat_to_orient_fc'
	  end
 endcase

 cam_scale = dawn_spice_scale(inst)

filters=''
; filters = pdspar(label, 'FILTER_NAME')

 return, dawn_to_ominas( $
           spice_cameras(dd, ref, '', '', pos=pos, $
		sc = sc, $
		inst = inst, $
		plat = plat, $
		orient = orient, $
		cam_time = cam_time, $
		cam_scale = cam_scale, $
		cam_oaxis = cam_oaxis, $
		cam_fn_psf = 'dawn_psf', $
		cam_filters = filters, $
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
; dawn_spice_planets
;
;===========================================================================
function dawn_spice_planets, dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs

 label = nv_header(dd)

 if(NOT keyword_set(time)) then $
  begin
   time = dawn_spice_time(label, dt=dt, status=status)
   if(status NE 0) then return, ptr_new()
   time = spice_str2et(time)
   plt_time = time + dt
  end $
 else plt_time = time

 if(keyword_set(label)) then $
  begin
   target_name = strupcase(pdspar(label, 'TARGET_NAME'))
   target_desc = strupcase(pdspar(label, 'TARGET_TYPE'))

   target = target_name

;   obs_id = pdspar(label, 'OBSERVATION_ID')
;   if((strpos(strupcase(obs_id), 'OPNAV'))[0] NE -1) then target = target_desc
  end

 return, eph_spice_planets(dd, ref, time=plt_time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, $
                            target=target, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; dawn_spice_sun
;
;===========================================================================
function dawn_spice_sun, dd, ref, n_obj=n_obj, dim=dim, constants=constants, $
                                   status=status, time=time, obs=obs

 label = nv_header(dd)

 if(NOT keyword__set(time)) then $
  begin
   time = dawn_spice_time(label, dt=dt, status=status)
   if(status NE 0) then return, ptr_new()
   time = spice_str2et(time)
   sun_time = time + dt
  end $
 else sun_time = time
 
 return, eph_spice_sun(dd, ref, n_obj=n_obj, dim=dim, $
                      status=status, time=sun_time, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; dawn_spice_input.pro
;
;
;===========================================================================
function dawn_spice_input, dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 return, spice_input(dd, keyword, 'dawn', n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords)

end
;===========================================================================
