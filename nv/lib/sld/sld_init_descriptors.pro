;=============================================================================
;+
; NAME:
;	sld_init_descriptors
;
;
; PURPOSE:
;	Init method for the SOLID class.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld = sld_init_descriptors(n)
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
;	sld:	Globe descriptor(s) to initialize, instead of creating a new one.
;
;	bd:	Body descriptor(s) instead of using bod_init_descriptors.
;
;	crd:	Core descriptor(s) instead of using cor_init_descriptors.
;
;	opacity: Array (n) of opacities for each body.
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
;	Newly created or or freshly initialized solid descriptors, depending
;	on the presence of the bd keyword.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function sld_init_descriptors, n, sld=sld, bd=bd, crd=crd, $
@sld__keywords.include
end_keywords
@nv_lib.include

 npht = sld_npht()

 if(NOT keyword_set(n)) then n = n_elements(sld)

 if(NOT keyword_set(sld)) then sld=replicate({solid_descriptor}, n)
 sld.class=decrapify(make_array(n, val='SOLID'))
 sld.abbrev=decrapify(make_array(n, val='SLD'))


 ;----------------------------------------
 ; dynamical parameters
 ;----------------------------------------
 if(keyword_set(GM)) then sld.GM = GM
 if(keyword_set(mass)) then sld.mass = mass


 ;----------------------------------------
 ; photometric parameters
 ;----------------------------------------
 if(keyword_set(refl_fn)) then sld.refl_fn = refl_fn
 if(keyword_set(refl_parm)) then $
       sld.refl_parm[0:(n_elements(refl_parm)<npht)-1,*] $
               = refl_parm[0:(n_elements(refl_parm)<npht)-1,*]

 if(keyword_set(phase_fn)) then sld.phase_fn = phase_fn
 if(keyword_set(phase_parm)) then $
       sld.phase_parm[0:(n_elements(phase_parm)<npht)-1,*] $
               = phase_parm[0:(n_elements(phase_parm)<npht)-1,*]

 if(keyword_set(albedo)) then sld.albedo = albedo $
 else sld.albedo = 1d

 if(keyword_set(opacity)) then sld.opacity=decrapify(opacity) $
 else sld.opacity = 1d



 if(keyword_set(bd)) then sld.bd = bd $
 else sld.bd=bod_init_descriptors(n, crd=crd, $
@bod__keywords.include
end_keywords)


 sldp = ptrarr(n)
 nv_rereference, sldp, sld


 return, sldp
end
;===========================================================================



