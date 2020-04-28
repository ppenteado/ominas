;===========================================================================
;+
; NAME:
;	sld_refl_fn
;
;
; PURPOSE:
;       Returns the name of the reflection function for each given solid 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	mass = sld_refl_fn(sld)
;
;
; ARGUMENTS:
;  INPUT:
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (nt) of reflection function names associated with each given 
;	solid descriptor.
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
;===========================================================================
function sld_refl_fn, sld, noevent=noevent
@core.include

 nv_notify, sld, type = 1, noevent=noevent
 _sld = cor_dereference(sld)
 return, _sld.refl_fn
end
;===========================================================================
