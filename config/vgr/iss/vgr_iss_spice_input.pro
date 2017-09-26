;=============================================================================
;+
; NAME:
;	vgr_iss_spice_input
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
;	result = vgr_iss_spice_input(dd, keyword)
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
;	vgr_iss_spice_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================


;===========================================================================
; vgr_iss_spice_cameras
;
;===========================================================================
function vgr_iss_spice_cameras, dd, ref, pos=pos, constants=constants, $
        n_obj=n_obj, dim=dim, status=status, time=time, orient=orient, obs=obs

 ndd = n_elements(dd)
 sc_name = vgr_parse_inst(dat_instrument(dd), cam=name)
 sc = -31l
 if(sc_name EQ 'vg2') then sc = -32l

 plat = 0l

 inst = sc*1000 - 001l				; na camera
 if(name EQ 'wa') then inst = sc*1000 - 002l	; wa camera
 orient_fn = 'vgr_cmat_to_orient_iss'


 meta = dat_header_info(dd)

 return, vgr_to_ominas( $
           spice_cameras(dd, ref, '', '', pos=pos, $
		sc = sc, $
		inst = inst, $
		plat = plat, $
		tol = 800d, $
		orient = orient, $
		cam_time = meta.time, $
		cam_scale = meta.scale, $
		cam_oaxis = meta.oaxis, $
		cam_fn_psf = make_array(ndd, val='vgr_iss_psf'), $
		cam_size = meta.size, $
		cam_exposure = meta.exposure, $
		cam_fn_focal_to_image = make_array(ndd, val='cam_focal_to_image_linear'), $
		cam_fn_image_to_focal = make_array(ndd, val='cam_image_to_focal_linear'), $
		cam_fi_data = [ptrarr(ndd)], $
		n_obj=n_obj, dim=dim, status=status, constants=constants, obs=obs), $
                   orient_fn )

end
;===========================================================================



;===========================================================================
; vgr_iss_spice_planets
;
;===========================================================================
function vgr_iss_spice_planets, dd, ref, time=time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs

 meta = dat_header_info(dd)

 return, gen_spice_planets(dd, ref, time=meta.time, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, $
                            target=meta.target, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; vgr_iss_spice_sun
;
;===========================================================================
function vgr_iss_spice_sun, dd, ref, n_obj=n_obj, dim=dim, $
                   status=status, time=time, constants=constants, obs=obs

 meta = dat_header_info(dd)

 return, gen_spice_sun(dd, ref, n_obj=n_obj, dim=dim, $
                    status=status, time=meta.time, constants=constants, obs=obs)

end
;===========================================================================



;===========================================================================
; vgr_iss_spice_input.pro
;
;
;===========================================================================
function vgr_iss_spice_input, dd, keyword, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 return, spice_input(dd, keyword, 'vgr', 'iss', values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords)

end
;===========================================================================
