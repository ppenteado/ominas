;=============================================================================
;+-+
; NAME:
;	dh_std_input
;
;
; PURPOSE:
;	Input translator for detached header
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_get_value):
;	result = dh_std_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity to
;			read.
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
;	status:		Zero if valid data is returned
;
;
;  TRANSLATOR KEYWORDS:
;	history:	History index to use in matching the keyword.  If not 
;			specified, the keyowrd with the highest history index
;			is matched.
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
;	dh_std_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================



;=============================================================================
; dhsi_match_primary
;
;=============================================================================
function dhsi_match_primary, xd, s
 w = where(cor_name(xd) EQ s)
 if(w[0] EQ -1) then return, obj_new()
 return, xs[w[0]]
end
;=============================================================================



;=============================================================================
; dhsi_get_core
;
;=============================================================================
function dhsi_get_core, dd, dh, prefix


 name = dh_get_string(dh, prefix + '_name', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 if(status NE 0) then return, 0

 user = dh_get_string(dh, prefix + '_user', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 tasks = dh_get_sclarr(dh, prefix + '_tasks', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)

 crds = cor_create_descriptors(n_obj, $
	assoc_xd=dd, $
	name=name, $
 	user=user, $
	tasks=tasks)

 return, crds
end
;=============================================================================



;=============================================================================
; dhsi_get_body
;
;=============================================================================
function dhsi_get_body, dh, prefix, crds=crds


 time = dh_get_scalar(dh, prefix + '_time', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 if(status NE 0) then return, 0

 opaque = dh_get_scalar(dh, prefix + '_opaque', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 orient = dh_get_matrix(dh, prefix + '_orient', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 pos = dh_get_vector(dh, prefix + '_pos', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 vel = dh_get_vector(dh, prefix + '_vel', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 avel = dh_get_vector(dh, prefix + '_avel', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)

 libv = dh_get_vector(dh, prefix + '_libv', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 dlibdt = dh_get_sclarr(dh, prefix + '_dlibdt', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 lib = dh_get_sclarr(dh, prefix + '_lib', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)

 bds = bod_create_descriptors(n_obj, crd=crds, $
	time=time, $
 	opaque=opaque, $
 	orient=orient, $
 	pos=pos, $
 	vel=vel, $
 	avel=avel, $
 	libv=libv, $
 	dlibdt=dlibdt, $
	__lib=lib)

 return, bds
end
;=============================================================================



;=============================================================================
; dhsi_get_solid
;
;=============================================================================
function dhsi_get_solid, dh, prefix, crds=crds, bds=bds


 mass = dh_get_scalar(dh, prefix + '_mass', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 if(status NE 0) then return, 0

 gm = dh_get_scalar(dh, prefix + '_gm', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)



 slds = sld_create_descriptors(n_obj, crd=crds, bd=bds, $
	mass=mass, $
	gm=gm)

 return, slds
end
;=============================================================================



;=============================================================================
; dhsi_get_globe
;
;=============================================================================
function dhsi_get_globe, dh, prefix, crds=crds, bds=bds, slds=slds


 mass = dh_get_scalar(dh, prefix + '_mass', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 if(status NE 0) then return, 0

 lora = dh_get_scalar(dh, prefix + '_lora', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 j = dh_get_sclarr(dh, prefix + '_j', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 radii = dh_get_vector(dh, prefix + '_radii', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 radii = reform(radii, /over, 3, n_obj)
 type = dh_get_string(dh, prefix + '_type', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 lref = dh_get_string(dh, prefix + '_lref', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 rref = dh_get_scalar(dh, prefix + '_rref', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 gm = dh_get_scalar(dh, prefix + '_gm', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)



 gbds = glb_create_descriptors(n_obj, crd=crds, bd=bds, sld=slds, $
	lora=lora, $
	j=j, $
	radii=radii, $
	type=type, $
	lref=lref, $
	rref=rref)

 return, gbds
end
;=============================================================================



;=============================================================================
; dhsi_get_disk
;
;=============================================================================
function dhsi_get_disk, dh, prefix, crds=crds, bds=bds, slds=slds


 nm = dh_get_scalar(dh, prefix + '_nm', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
 if(status NE 0) then return, 0


 if(n_obj EQ 1) then $
  begin
   sma = transpose(dh_get_point(dh, prefix + '_sma', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status))
   ecc = transpose(dh_get_point(dh, prefix + '_ecc', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status))
  end $
 else $
  begin
   sma = transpose(dh_get_point(dh, prefix + '_sma', n_obj=n_obj, dim=dim, $
			               hi=hi, status=status), [1,0,2])
   ecc = transpose(dh_get_point(dh, prefix + '_ecc', n_obj=n_obj, dim=dim, $
			               hi=hi, status=status), [1,0,2])
  end



 dkds = dsk_create_descriptors(n_obj, crd=crds, bd=bds, sld=slds, $
	sma=sma, $
	ecc=ecc, $
	scale=scale, $
	nm=nm, $
	m=m, $
	em=em, $
	lpm=lpm, $
	dlpmdt=dlpmdt, $
	libam=libam, $
	libm=libm, $
	dlibmdt=dlibmdt, $
	nl=nl, $
	_l=l, $
	il=il, $
	lanl=lanl, $
	dlanldt=dlanldt, $
	libal=libal, $
	libl=libl, $
	dlibldt=dlibldt)

 return, dkds
end
;=============================================================================



;=============================================================================
; dh_std_input
;
;=============================================================================
function dh_std_input, dd, keyword, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 status = -1
 n_obj = 0


 ;-----------------------------------------------
 ; translator keywords
 ;-----------------------------------------------
 history = tr_keyword_value(dd, 'history')
 if(keyword_set(history)) then hi = fix(history)

 xds = 0
 ndd = n_elements(dd)
 for i=0, ndd-1 do $
  begin
   ;--------------------------
   ; get detached header
   ;--------------------------
   dh = dh_get(dd[i])
   if(NOT keyword_set(dh)) then return, 0


   ;--------------------------
   ; match keyword
   ;--------------------------
   case keyword of $

	;-------------------camera keywords--------------------

	'CAM_DESCRIPTORS'   : $
	  begin
	   crds = dhsi_get_core(dd, dh, 'cam')
	   if(NOT keyword_set(crds)) then return, 0
	   bds = dhsi_get_body(dh, 'cam', crds=crds)

	   cam_exposure = dh_get_scalar(dh, 'cam_exposure', n_obj=n_obj, $
                                             dim=dim, hi=hi, status=status)

	   val = $
	      dh_get_point(dh, 'cam_size', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      cam_size = reform(val, 2,n_obj, /overwrite)

	   val = $
	      dh_get_point(dh, 'cam_scale', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      cam_scale = reform(val, 2,n_obj, /overwrite)

	   val = $
	      dh_get_point(dh, 'cam_oaxis', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      cam_oaxis = reform(val, 2,n_obj, /overwrite)

	   cam_fn_focal_to_image = $
	       dh_get_string(dh, 'cam_fn_f2i', n_obj=n_obj, dim=dim, $
			                               hi=hi, status=status)

	   cam_fn_image_to_focal = $
	       dh_get_string(dh, 'cam_fn_i2f', n_obj=n_obj, dim=dim, $
			                               hi=hi, status=status)

	   cam_fi_data = dh_get_array(dh, 'cam_fi_data', n_obj=n_obj, dim=dim, $
			                               hi=hi, status=status)

	   cam_fn_psf = $
	       dh_get_string(dh, 'cam_fn_psf', n_obj=n_obj, dim=dim, $
			                               hi=hi, status=status)

	   cam_filters = dh_get_point(dh, 'cam_filters', n_obj=n_obj, $
			                               hi=hi, status=status)

	   n_obj = n_elements(crds)
	   cds = cam_create_descriptors(n_obj, crd=crds, bd=bds, $
		exposure=cam_exposure, $
		fn_focal_to_image=cam_fn_focal_to_image, $
		fn_image_to_focal=cam_fn_image_to_focal, $
		filters=cam_filters, $
		fi_data=cam_fi_data, $
		fn_psf=cam_fn_psf, $
		scale=cam_scale, $
		size=cam_size, $
		oaxis=cam_oaxis)

	   format = dh_get_string(dh, 'cam_format', hi=hi)
	   if(keyword_set(format)) then cds = dh_to_ominas(format[0], cds)

	   status = 0
           dim = [1]

	   xds = append_array(xds, cds)
;	   return, cds
	  end


	;-------------------planet keywords--------------------

	'PLT_DESCRIPTORS'   : $
	  begin
	   crds = dhsi_get_core(dd, dh, 'plt')
	   if(NOT keyword_set(crds)) then return, 0
	   bds = dhsi_get_body(dh, 'plt', crds=crds)
	   slds = dhsi_get_solid(dh, 'plt', bds=bds)
	   gbds = dhsi_get_globe(dh, 'plt', crds=crds, bds=bds, slds=slds)

	   n_obj = n_elements(crds)
	   pds = plt_create_descriptors(n_obj, crd=crds, bd=bds, gbd=gbds, sld=slds)

	   format = dh_get_string(dh, 'plt_format', hi=hi)
	   if(keyword_set(format)) then pds = dh_to_ominas(format[0], pds)

	   status = 0
           dim = [1]

	   xds = append_array(xds, pds)
;	   return, pds
	  end

	;-------------------ring keywords--------------------

	'RNG_DESCRIPTORS'   : $
	  begin
	   if(keyword_set(key1)) then pd = key1
	   crds = dhsi_get_core(dd, dh, 'rng')
	   if(NOT keyword_set(crds)) then return, 0
	   bds = dhsi_get_body(dh, 'rng', crds=crds)
	   slds = dhsi_get_solid(dh, 'rng', bds=bds)
	   dkds = dhsi_get_disk(dh, 'rng', crds=crds, bds=bds, slds=slds)

	   rng_primary = dh_match_primary(pd, $
                 dh_get_string(dh, 'rng_primary', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status) )

	   n_obj = n_elements(crds)
	   rds = rng_create_descriptors(n_obj, crd=crds, bd=bds, sld=slds, dkd=dkds, $
		primary=rng_primary)

	   format = dh_get_string(dh, 'rng_format', hi=hi)
	   if(keyword_set(format)) then rds = dh_to_ominas(format[0], rds)

	   status = 0
           dim = [1]

	   xds = append_array(xds, rds)
;	   return, rds
	  end

        ;-------------------star keywords--------------------

	'STR_DESCRIPTORS'   : $
	  begin
	   crds = dhsi_get_core(dd, dh, 'str')
	   if(NOT keyword_set(crds)) then return, 0
	   bds = dhsi_get_body(dh, 'str', crds=crds)
	   slds = dhsi_get_solid(dh, 'str', bds=bds)
	   gbds = dhsi_get_globe(dh, 'str', crds=crds, bds=bds, slds=slds)


	   str_lum = dh_get_scalar(dh, 'str_lum', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)
	   str_sp = dh_get_string(dh, 'str_sp', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)

	   n_obj = n_elements(crds)
	   sds = str_create_descriptors(n_obj, crd=crds, bd=bds, sld=slds, gbd=gbds, $
		lum=str_lum, $
		sp=str_sp)

	   format = dh_get_string(dh, 'str_format', hi=hi)
	   if(keyword_set(format)) then sds = dh_to_ominas(format[0], sds)

	   status = 0
           dim = [1]

	   xds = append_array(xds, sds)
;	   return, sds
	  end


	;-------------------map keywords--------------------

	'MAP_DESCRIPTORS'   : $
	  begin
	   crds = dhsi_get_core(dd, dh, 'map')
	   if(NOT keyword_set(crds)) then return, 0

	   map_fn_data = dh_get_array(dh, 'map_fn_data', n_obj=n_obj, $
	                                       dim=dim, hi=hi, status=status)

	   map_type = dh_get_string(dh, 'map_type', n_obj=n_obj, dim=dim, $
			                                hi=hi, status=status)

	   val = $
	      dh_get_point(dh, 'map_origin', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      map_origin = reform(val, 2,n_obj, /overwrite)

	   val = $
	      dh_get_point(dh, 'map_center', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      map_center = reform(val, 2,n_obj, /overwrite)

	   val = $
	      dh_get_point(dh, 'map_units', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      map_units = reform(val, 2,n_obj, /overwrite)

	   map_scale = dh_get_scalar(dh, 'map_scale', n_obj=n_obj, $
	                                                hi=hi, status=status)

	   val = $
	      dh_get_vector(dh, 'map_radii', n_obj=n_obj, hi=hi, status=status)
	   if(keyword_set(val)) then $
	                      map_radii = reform(val, 3,n_obj, /overwrite)

	   map_graphic = dh_get_scalar(dh, 'map_graphic', n_obj=n_obj, $
	                                                hi=hi, status=status)

	   map_rotate = dh_get_scalar(dh, 'map_rotate', n_obj=n_obj, $
	                                                hi=hi, status=status)

	   map_size = dh_get_point(dh, 'map_size', n_obj=n_obj, dim=dim, $
	                                                hi=hi, status=status)

	   map_range = dh_get_array(dh, 'map_range', n_obj=n_obj, dim=dim, $
			                               hi=hi, status=status)

	   n_obj = n_elements(crds)
	   mds = map_create_descriptors(n_obj, $
		crd=crds, $
		type=map_type, $
		fn_data=map_fn_data, $
		graphic=map_graphic, $
		rotate=map_rotate, $
		size=map_size, $
		units=map_units, $
		origin=map_origin, $
		center=map_center, $
		range=map_range, $
		scale=map_scale, $
		radii=map_radii)

	   format = dh_get_string(dh, 'map_format', hi=hi)
	   if(keyword_set(format)) then mds = dh_to_ominas(format[0], mds)

	   status = 0
           dim = [1]

	   xds = append_array(xds, mds)
;	   return, mds
	  end



	else : 	status = -1
   endcase
  end

 return, xds
end
;===========================================================================
