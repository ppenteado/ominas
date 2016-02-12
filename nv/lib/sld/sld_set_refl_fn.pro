;===========================================================================
;+
; NAME:
;	sld_set_refl_fn
;
;
; PURPOSE:
;       Replaces the reflection function for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_refl_fn, slx, refl_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
;
;	refl_fn: Array (nt) of new reflection functions.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
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
;===========================================================================
pro sld_set_refl_fn, slxp, refl_fn
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 sld.refl_fn=refl_fn

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0
end
;===========================================================================
