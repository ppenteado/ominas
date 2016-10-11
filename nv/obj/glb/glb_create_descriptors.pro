;=============================================================================
;+
; NAME:
;	glb_create_descriptors
;
;
; PURPOSE:
;	Init method for the GLOBE class.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	gbd = glb_create_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	Number of descriptors to create.
;
;  OUTPUT: NONE
;
;
; KEYWORDS (in addition to those accepted by all superclasses):
;  INPUT:  
;	gbd:	Globe descriptor(s) to initialize, instead of creating a new one.
;
;	sld:	Solid descriptor(s) instead of using sld_create_descriptors.
;
;	bd:	Body descriptor(s) instead of using bod_create_descriptors.
;
;	crd:	Core descriptor(s) instead of using cor_create_descriptors.
;
;	type:	Array (n) of type strings.
;
;	lref:	Array (n) of longitude reference notes.
;
;	radii:	Array (3,n) of ellipsoid radii.
;
;	lora:	Array (n) giving longitudes  first ellipsoid radius.
;
;	rref:	Array (n) of reference radii.
;
;	J:	Array (n,nj) of zonal harmonics.
;
;	GM:	Array (n) of masses x gravitiational constant.
;
;	mass:	Array (n) of masses.
;
;	phase_fn: Array (n) of phase function names.
;
;	phase_parm:	Array (npht,n) of phase function parameters.
;
;	refl_fn: Array (n) of reflection function names.
;
;	refl_parm:	Array (npht,n) of reflection function parameters.
;
;	albedo:	Array (n) of bond albedos.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created or or freshly initialized globe descriptors, depending
;	on the presence of the bd keyword.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function glb_create_descriptors, n, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, $
@glb__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1


 gbd = objarr(n)
 for i=0, n-1 do $
  begin

   gbd[i] = ominas_globe(i, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, $
@glb__keywords.include
end_keywords)

  end


 return, gbd
end
;===========================================================================



