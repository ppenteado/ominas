;=============================================================================
;+
; NAME:
;	glb_init_descriptors
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
;	gbd = glb_init_descriptors(n)
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
;	sld:	Solid descriptor(s) instead of using sld_init_descriptors.
;
;	bd:	Body descriptor(s) instead of using bod_init_descriptors.
;
;	crd:	Core descriptor(s) instead of using cor_init_descriptors.
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
;	
;-
;=============================================================================
function glb_init_descriptors, n, gbd=gbd, sld=sld, bd=bd, crd=crd, $
@glb__keywords.include
end_keywords
@nv_lib.include

 npht = glb_npht()

 if(NOT keyword_set(n)) then n = n_elements(gbd)

 if(NOT keyword_set(gbd)) then gbd=replicate({globe_descriptor}, n)
 gbd.class=decrapify(make_array(n, val='GLOBE'))
 gbd.abbrev=decrapify(make_array(n, val='GLB'))

 if(keyword_set(lref)) then gbd.lref=decrapify(lref)

 ;----------------------------------------
 ; ellipsoid parameters
 ;----------------------------------------
 gbd.type = 'ELLIPSOID'
 if(keyword_set(radii)) then gbd.radii=radii
 if(keyword_set(lora)) then gbd.lora=decrapify(lora)

 ;----------------------------------------
 ; higher-order shape parameters
 ;----------------------------------------
 if(keyword_set(rref)) then gbd.rref = rref

 if(keyword_set(J)) then $
  begin
   _nj = n_elements(J)/n
   nj = n_elements(gbd.J)
   if(_nj GT nj) then $
    begin
     nv_message, /con, name='glb_init_descriptors', $
         'Warning -- J contains more terms than allowed, truncating.'
     J = J[0:nj-1,*]
    end
   _nj = n_elements(J)/n
   gbd.J[0:_nj-1,*] = J
  end



 if(keyword_set(sld)) then gbd.sld = sld $
 else gbd.sld=sld_init_descriptors(n, sld=sld, bd=bd, crd=crd, $
@sld__keywords.include
end_keywords)


 gbdp = ptrarr(n)
 nv_rereference, gbdp, gbd


 return, gbdp
end
;===========================================================================



