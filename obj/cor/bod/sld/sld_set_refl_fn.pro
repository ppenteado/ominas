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
;	sld_set_refl_fn, sld, refl_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro sld_set_refl_fn, sld, refl_fn, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.refl_fn=refl_fn

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
