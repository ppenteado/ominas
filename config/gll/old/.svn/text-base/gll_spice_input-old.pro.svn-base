;=============================================================================
;+
; NAME:
;	gll_spice_input
;
;
; PURPOSE:
;	NAIF/SPICE input translator for Galileo. 
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = gll_spice_input(dd, keyword)
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
;	gll_spice_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================


;===========================================================================
; gll_spice_cameras
;
;===========================================================================
function gll_spice_cameras, dd, ref, pos=pos, $
                                 n_obj=n_obj, dim=dim, status=status, time=time

 cam_name = nv_instrument(dd)

 ;-------------------------------------------------------------------
 ; instrument params
 ;  Actually, the instrument ID is -77036 and the platform ID is
 ;  -77001.  But the platform C-matrix is really what we'll need in
 ;  this case. 
 ;-------------------------------------------------------------------
 sc = -77l
 plat = 0l
 inst= -77001l

 label = nv_header(dd)

 ;----------------------------
 ; time
 ;----------------------------
 if(NOT keyword__set(time)) then $
  begin
   time = spice_str2et(gll_spice_time(label, dt=dt))
   cam_time = time + dt
  end $
 else cam_time = time

 if(keyword__set(label)) then $
  begin
   ;------------------------------
   ; exposure time
   ;------------------------------
   cam_exposure = vicgetpar(label, 'EXP')

   ;------------------------------------------------
   ; image size
   ;------------------------------------------------
   cam_nx = double(vicgetpar(label, 'NS'))
   cam_ny = double(vicgetpar(label, 'NL'))

   ;------------------------------------------------
   ; nominal optic axis coordinate, camera scale
   ;------------------------------------------------
   cam_oaxis = [(cam_nx - 1.), (cam_ny - 1.)]/2.
   cam_scale = 1.016d-05 				; from trial and error

   ;------------------------------------------------
   ; detect summation modes
   ;------------------------------------------------
   mode = vicgetpar(label, 'TLMFMT')
   if((mode EQ 'HIS') OR (mode EQ 'AI8')) then $
    begin
     cam_oaxis = cam_oaxis / 2d
     cam_scale = cam_scale*2.
    end
  end


 return, gll_to_minas( $
           spice_cameras(dd, ref, '', '', pos=pos, $
		sc = sc, $
		inst = inst, $
		plat = plat, $
		cam_time = cam_time, $
		cam_scale = cam_scale, $
		cam_oaxis = cam_oaxis, $
		cam_nx = cam_nx, $
		cam_ny = cam_ny, $
		cam_exposure = cam_exposure, $
		cam_fn_focal_to_image = cam_focal_to_image_linear, $
		cam_fn_image_to_focal = cam_image_to_focal_linear, $
		cam_fn_data = [ptr_new()], $
		n_obj=n_obj, dim=dim, status=status) )

end
;===========================================================================



;===========================================================================
; gll_spice_planets
;
;===========================================================================
function gll_spice_planets, dd, ref, planets=planets, $
                           n_obj=n_obj, dim=dim, status=status, time=time, $  
                           targets=targets, local=local


 label = nv_header(dd)

 ;----------------------
 ; get time string
 ;----------------------
 if(NOT keyword__set(time)) then $
  begin
   time = spice_str2et(gll_spice_time(label, dt=dt))
   sc_time = time + dt
  end $
 else sc_time = time

 ;-----------------------------------------------------------
 ; request all relevant planets if none specified
 ;-----------------------------------------------------------
 if(NOT keyword__set(planets)) then planets = spice_read_targets(targets)


 ;-----------------------------------------------------------
 ; move primary target to front of list 
 ;   If no planet names have been specified, or if TARGET_NAME was not in the
 ;   list, then the spice interface will retrieve all possible bodies from
 ;   the kernel pool.  In that case, TARGET_NAME is lost, so here, we 
 ;   record that string in the data descriptor.
 ;-----------------------------------------------------------
 target = 'UNKNOWN'
 if(keyword__set(label)) then $
  begin
   target = vicgetpar(label, 'TARGET')
   nv_set_udata, dd, 'TARGET_NAME', target

   w = where(planets EQ target)
   if(w[0] NE -1) then $
    begin
     if(n_elements(planets) EQ 1) then planets = target $
     else planets = [target, rm_list_item(planets, w[0], only='')]
    end
  end

 ;-----------------------------------------------------------
 ; get the descriptors 
 ;-----------------------------------------------------------
 return, gll_to_minas( $
            spice_planets(dd, ref, $
		sc = -77l, $		
		time = sc_time, $
		target=target, $
		plt_name = planets, $
		n_obj=n_obj, dim=dim, status=status, local=local) )


end
;===========================================================================



;===========================================================================
; gll_spice_sun
;
;===========================================================================
function gll_spice_sun, dd, ref, n_obj=n_obj, dim=dim, $
                                   status=status, time=time, local=local


 label = nv_header(dd)
 if(NOT keyword__set(time)) then $
  begin
   time = spice_str2et(gll_spice_time(label, dt=dt))
   sc_time = time + dt
  end $
 else sc_time = time

 ;------------------------------
 ; get planet descriptor for sun
 ;------------------------------
 pd = gll_to_minas( $
	spice_planets(dd, ref, $
		time = sc_time, $
		sc = -77l, $					
		plt_name = ['SUN'], $
		n_obj=n_obj, dim=dim, status=status, local=local) )
 if(status NE 0) then return, 0

 ;------------------------------
 ; convert to star descriptor
 ;------------------------------
 gbd = plt_globe(pd)
 bd = glb_body(gbd)

 sd = str_init_descriptors(n_obj, $
		name=get_core_name(pd), $
		orient=bod_orient(bd), $
		avel=bod_avel(bd), $
		pos=bod_pos(bd), $
		vel=bod_vel(bd), $
		time=bod_time(bd), $
		lref=glb_lref(gbd), $
		radii=glb_radii(gbd), $
		lora=glb_lora(gbd))

 return, sd

end
;===========================================================================



;===========================================================================
; gll_spice_input.pro
;
;
;===========================================================================
function gll_spice_input, dd, keyword, n_obj=n_obj, dim=dim, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 return, spice_input(dd, keyword, 'gll', n_obj=n_obj, dim=dim, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords)

end
;===========================================================================
