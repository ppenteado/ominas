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
function vgr_spice_cameras, dd, ref, pos=pos, $
                              n_obj=n_obj, dim=dim, status=status, time=time

 sc_name = vgr_parse_inst(nv_instrument(dd), cam=cam_name)
 sc = -31l
 if(sc_name EQ 'vg2') then sc = -32l

 plat = 0l

 inst = sc*1000 - 001l					; na camera
 if(cam_name EQ 'wa') then inst = sc*1000 - 002l	; wa camera


 label = nv_header(dd)

 ;-----------------------------------
 ; cam_time
 ;-----------------------------------
 if(NOT keyword__set(time)) then $
  begin
   time = spice_str2et(vgr_spice_time(label, dt=dt))
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
   s = size(nv_data(dd))
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



 return, vgr_to_minas( $
           spice_cameras(dd, ref, '', '', pos=pos, $
		sc = sc, $
		inst = inst, $
		plat = plat, $
		tol = 100d, $
		cam_time=cam_time, $
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
; vgr_spice_planets
;
;===========================================================================
function vgr_spice_planets, dd, ref, planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, time=time, $ 
                            targets=targets, local=local

 label = nv_header(dd)

 sc_name = vgr_parse_inst(nv_instrument(dd), cam=cam_name)
 sc = -31l
 if(sc_name EQ 'vg2') then sc = -32l

 ;----------------------
 ; get time string
 ;----------------------
 if(NOT keyword__set(time)) then $
  begin
   time = spice_str2et(vgr_spice_time(label, dt=dt))
   sc_time = time + dt
  end $
 else sc_time = time

 ;----------------------------------------------------------------
 ; request all relevant planets if none specified
 ; if no targets file, then spice interface will get all bodies
 ;----------------------------------------------------------------
 if(NOT keyword__set(planets)) then planets = spice_read_targets(targets)

 ;----------------------------------------------------------------------------
 ; Move primary target to front of list 
 ;   If no planet names have been specified, or if TARGET_NAME was not in the
 ;   list, then the spice interface will retrieve all possible bodies from
 ;   the kernel pool.  In that case, TARGET_NAME is lost, so here, we 
 ;   record that string in the data descriptor.  The value of TARGET_DESC
 ;   is also provided as a backup.
 ;----------------------------------------------------------------------------
 target = 'UNKNOWN'
 if(keyword__set(label)) then $
  begin
   target_name = strupcase(vicgetpar(label, 'TARGET_NAME'))
   target_desc = strupcase(vicgetpar(label, 'TARGET_DESC'))

   target = target_name

;   if(keyword__set(target_desc)) then target = [target, target_desc]
   obs_id = vicgetpar(label, 'OBSERVATION_ID')
   if((strpos(strupcase(obs_id), 'OPNAV'))[0] NE -1) then target = target_desc

   nv_set_udata, dd, 'TARGET', target

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
 return, vgr_to_minas( $
            spice_planets(dd, ref, $
		sc = sc, $
		time = sc_time, $
		target = target, $
		plt_name = planets, $
		n_obj=n_obj, dim=dim, status=status, local=local) )


end
;===========================================================================



;===========================================================================
; vgr_spice_sun
;
;===========================================================================
function vgr_spice_sun, dd, ref, n_obj=n_obj, dim=dim, $
                                   status=status, time=time, local=local

 sc_name = vgr_parse_inst(nv_instrument(dd), cam=cam_name)
 sc = -31l
 if(sc_name EQ 'vg2') then sc = -32l

 label = nv_header(dd)
 if(NOT keyword__set(time)) then $
  begin
   time = spice_str2et(vgr_spice_time(label, dt=dt))
   sc_time = time + dt
  end $
 else sc_time = time

 ;------------------------------
 ; get planet descriptor for sun
 ;------------------------------
 pd = vgr_to_minas( $
	spice_planets(dd, ref, $
		time = sc_time, $
		sc = sc, $
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
; vgr_spice_input.pro
;
;
;===========================================================================
function vgr_spice_input, dd, keyword, n_obj=n_obj, dim=dim, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 return, spice_input(dd, keyword, 'vgr', n_obj=n_obj, dim=dim, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords)

end
;===========================================================================
