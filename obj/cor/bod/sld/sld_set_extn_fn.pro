;===========================================================================
;+
; NAME:
;	sld_set_extn_fn
;
;
; PURPOSE:
;       Replaces the extinction function for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_extn_fn, sld, extn_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
;
;	extn_fn: Array (nt) of new extinction functions.
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
; 	Written by:	Spitale, 9/2017
;	
;-
;===========================================================================
pro sld_set_extn_fn, sld, extn_fn, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.extn_fn=extn_fn

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
