;===========================================================================
;+
; NAME:
;	sld_set_body
;
;
; PURPOSE:
;	Replaces the body descriptor in each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_body, slx, bd
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
;
;	bd:	 Array (nt) of BODY descriptors.
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
pro sld_set_body, slxp, bds, noevent=noevent
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 sld.bd=bds

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0, noevent=noevent
end
;===========================================================================



