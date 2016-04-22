;===========================================================================
;+
; NAME:
;	sld_body
;
;
; PURPOSE:
;	Returns the body descriptor for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	bd = sld_body(slx)
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
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
; RETURN:
;	Body descriptor associated with each given solid descriptor.
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
function sld_body, slxp, noevent=noevent
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 nv_notify, sldp, type = 1, noevent=noevent
 sld = nv_dereference(sldp)
 return, sld.bd
end
;===========================================================================



