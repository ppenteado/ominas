;===========================================================================
;+
; NAME:
;	sld_extn_fn
;
;
; PURPOSE:
;       Returns the name of the extinction function for each given solid 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	mass = sld_extn_fn(sld)
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
;       Array (nt) of extinction function names associated with each given 
;	solid descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2017
;	
;-
;===========================================================================
function sld_extn_fn, sld, noevent=noevent
@core.include

 nv_notify, sld, type = 1, noevent=noevent
 _sld = cor_dereference(sld)
 return, _sld.extn_fn
end
;===========================================================================
