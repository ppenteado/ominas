;=============================================================================
;+-+
; NAME:
;	dh_std_output
;
;
; PURPOSE:
;	Output translator for detached headers.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_put_value):
;	dh_std_output, dd, keyword, value
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity to
;			write.
;
;	value:		The data to write.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	NONE
;
;  OUTPUT:
;	status:		Zero unless a problem occurs.
;
;
;  TRANSLATOR KEYWORDS:
;	format:		String giving the name of the output representation. 
;			Default is OMINAS internal representation.  The null  
;			string, '', indicates the default.
;
;
; SIDE EFFECTS:
;	The detached header in the data descriptor is modified.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dh_std_input
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================



;=============================================================================
; dhso_put_core
;
;=============================================================================
pro dhso_put_core, dh, crx, prefix

 n_obj = n_elements(crx)

 for i=0, n_obj-1 do dh_put_sclarr, dh, prefix + '_tasks', cor_tasks(crx[i])

 dh_put_string, dh, prefix + '_user', cor_user(crx)
 dh_put_string, dh, prefix + '_name', cor_name(crx)


end
;=============================================================================



;=============================================================================
; dhso_put_body
;
;=============================================================================
pro dhso_put_body, dh, bx, prefix

 n_obj = n_elements(bx)

 dh_put_matrix, dh, prefix + '_orient', bod_orient(bx)
 dh_put_vector, dh, prefix + '_pos', bod_pos(bx)
 dh_put_vector, dh, prefix + '_vel', bod_vel(bx)
 dh_put_vector, dh, prefix + '_avel', bod_avel(bx)
 dh_put_scalar, dh, prefix + '_time', bod_time(bx)
 dh_put_scalar, dh, prefix + '_opaque', bod_opaque(bx)

 dh_put_vector, dh, prefix + '_avel', bod_libv(bx)
 dh_put_sclarr, dh, prefix + '_dlibdt', bod_dlibdt(bx)
 dh_put_sclarr, dh, prefix + '_lib', bod_lib(bx)

end
;=============================================================================



;=============================================================================
; dhso_put_solid
;
;=============================================================================
pro dhso_put_solid, dh, slx, prefix

 n_obj = n_elements(slx)

 dh_put_scalar, dh, prefix + '_mass', sld_mass(slx)
 dh_put_scalar, dh, prefix + '_gm', sld_gm(slx)

end
;=============================================================================



;=============================================================================
; dhso_put_globe
;
;=============================================================================
pro dhso_put_globe, dh, gbx, prefix

 n_obj = n_elements(gbx)

 dh_put_scalar, dh, prefix + '_lora', glb_lora(gbx)
 dh_put_sclarr, dh, prefix + '_j', glb_j(gbx)
 dh_put_vector, dh, prefix + '_radii', reform(glb_radii(gbx), 1,3,n_obj, /over)

 dh_put_string, dh, prefix + '_type', glb_type(gbx)
 dh_put_string, dh, prefix + '_lref', glb_lref(gbx)

 dh_put_scalar, dh, prefix + '_rref', glb_rref(gbx)

end
;=============================================================================



;=============================================================================
; dhso_put_disk
;
;=============================================================================
pro dhso_put_disk, dh, dkx, prefix

 n_obj = n_elements(dkx)

 if(n_obj EQ 1) then $
  begin
   dh_put_point, dh, prefix + '_sma', transpose(dsk_sma(dkx))
   dh_put_point, dh, prefix + '_ecc', transpose(dsk_ecc(dkx))
  end $
 else $
  begin
   dh_put_point, dh, prefix + '_sma', transpose(dsk_sma(dkx), [1,0,2])
   dh_put_point, dh, prefix + '_ecc', transpose(dsk_ecc(dkx), [1,0,2])
  end

 dh_put_scalar, dh, prefix + '_nm', dsk_nm(dkx)

 m = dsk_m(dkx)
 dh_put_array, dh, prefix + '_m-inner', reform(m[*,0,*])
 dh_put_array, dh, prefix + '_m-outer', reform(m[*,1,*])

 em = dsk_em(dkx)
 dh_put_array, dh, prefix + '_em-inner', reform(em[*,0,*])
 dh_put_array, dh, prefix + '_em-outer', reform(em[*,1,*])

 lpm = dsk_m(dkx)
 dh_put_array, dh, prefix + '_lpm-inner', reform(lpm[*,0,*])
 dh_put_array, dh, prefix + '_lpm-outer', reform(lpm[*,1,*])

 lpm = dsk_m(dkx)
 dh_put_array, dh, prefix + '_lpm-inner', reform(lpm[*,0,*])
 dh_put_array, dh, prefix + '_lpm-outer', reform(lpm[*,1,*])


end
;=============================================================================



;=============================================================================
; dh_std_output
;
;=============================================================================
pro dh_std_output, dd, keyword, value, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 status=0

 ;--------------------------
 ; get detached header
 ;--------------------------
 dh=dh_get(dd)

 
 ;-----------------------------------------------
 ; translator keywords
 ;-----------------------------------------------
 format = tr_keyword_value(dd, 'format')
 if(keyword_set(format)) then ods = dh_from_ominas(format, value) $
 else ods = value

 n = n_elements(ods)


 ;--------------------------
 ; match keyword
 ;--------------------------
 case keyword of $

	;-------------------camera keywords--------------------

	'CAM_DESCRIPTORS'   : $
	   begin
	    cds = ods
	    n_obj = n_elements(cds)

	    dhso_put_core, dh, cds, 'cam'
	    dhso_put_body, dh, cds, 'cam'

	    dh_put_scalar, dh, 'cam_exposure', cam_exposure(cds)
	    dh_put_string, dh, 'cam_fn_psf', cam_fn_psf(cds)
	    dh_put_string, dh, 'cam_fn_f2i', cam_fn_focal_to_image(cds)
	    dh_put_string, dh, 'cam_fn_i2f', cam_fn_image_to_focal(cds)
	    dh_put_array, dh, 'cam_fi_data', cam_fi_data(cds)
	    dh_put_point, dh, 'cam_size', $
	                             reform(cam_size(cds), 2,1,n_obj, /over)
	    dh_put_point, dh, 'cam_scale', $
	                             reform(cam_scale(cds), 2,1,n_obj, /over)
	    dh_put_point, dh, 'cam_oaxis', $
	                             reform(cam_oaxis(cds), 2,1,n_obj, /over)
	    dh_put_point, dh, 'cam_filters', cam_filters(cds)

	    if(keyword_set(format)) then $
	            dh_put_string, dh, 'cam_format', format, $
	                               comment=dh_format_comment(format, ods)
	   end


	;-------------------planet keywords--------------------

	'PLT_DESCRIPTORS'   : $
	   begin
	    pds = ods
	    dhso_put_core, dh, pds, 'plt'
	    dhso_put_body, dh, pds, 'plt'
	    dhso_put_solid, dh, pds, 'plt'
	    dhso_put_globe, dh, pds, 'plt'

	    if(keyword_set(format)) then $
	             dh_put_string, dh, 'plt_format', format, $
	                               comment=dh_format_comment(format, ods)
	   end


	;-------------------ring keywords--------------------

	'RNG_DESCRIPTORS'   : $
	   begin
	    rds = ods
	    dhso_put_core, dh, rds, 'rng'
	    dhso_put_body, dh, rds, 'rng'
	    dhso_put_solid, dh, rds, 'rng'
	    dhso_put_disk, dh, rds, 'rng'

	    dh_put_string, dh, 'rng_primary', cor_name(rng_primary(rds))

	    if(keyword_set(format)) then $
	             dh_put_string, dh, 'rng_format', format, $
	                               comment=dh_format_comment(format, ods)
	   end


        ;-------------------star keywords--------------------

	'STR_DESCRIPTORS'   : $
	   begin
	    sds = ods
	    dhso_put_core, dh, sds, 'str'
	    dhso_put_body, dh, sds, 'sds'
	    dhso_put_solid, dh, sds, 'sds'
	    dhso_put_globe, dh, sds, 'str'

	    dh_put_scalar, dh, 'str_lum', str_lum(sds)
	    dh_put_string, dh, 'str_sp', str_sp(sds)

	    if(keyword_set(format)) then $
	             dh_put_string, dh, 'str_format', format, $
	                               comment=dh_format_comment(format, ods)
	   end


        ;-------------------map keywords--------------------

	'MAP_DESCRIPTORS'   : $
	   begin
	    mds = ods

	    n_obj = n_elements(mds)

	    dhso_put_core, dh, mds, 'map'

	    dh_put_string, dh, 'map_type', map_type(mds)
	    dh_put_scalar, dh, 'map_scale', map_scale(mds)
	    dh_put_scalar, dh, 'map_graphic', map_graphic(mds)
	    dh_put_scalar, dh, 'map_rotate', map_rotate(mds)

	    if(n_obj EQ 1) then $
	     begin
	      dh_put_point, dh, 'map_origin', transpose(map_origin(mds))
	      dh_put_point, dh, 'map_center', transpose(map_center(mds))
	      dh_put_point, dh, 'map_units', transpose(map_units(mds))
	      dh_put_point, dh, 'map_size', transpose(map_size(mds))
	      dh_put_vector, dh, 'map_radii', transpose(map_radii(mds))
	     end $
	    else $
	     begin
	      dh_put_point, dh, 'map_origin', $
	                              transpose(map_origin(mds), [1,0,2])
	      dh_put_point, dh, 'map_center', $
	                              transpose(map_center(mds), [1,0,2])
	      dh_put_point, dh, 'map_units', $
	                                   transpose(map_units(mds), [1,0,2])
	      dh_put_point, dh, 'map_size', $
	                                   transpose(map_size(mds), [1,0,2])
	      dh_put_point, dh, 'map_radii', $
	                                   transpose(map_radii(mds), [1,0,2])
	     end

	    dh_put_array, dh, 'map_range', map_range(mds)
	    dh_put_array, dh, 'map_fn_data', map_fn_data(mds)


	    if(keyword_set(format)) then $
	             dh_put_string, dh, 'map_format', format, $
	                               comment=dh_format_comment(format, ods)
	   end


	else : 	status=-1
 endcase


 ;--------------------------
 ; modify detached header
 ;--------------------------
 dh_set, dd, dh

end
;===========================================================================
