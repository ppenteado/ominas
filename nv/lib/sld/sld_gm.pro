;===========================================================================
;+
; NAME:
;	sld_gm
;
;
; PURPOSE:
;       Returns the GM value for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	gm = sld_gm(slx)
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
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (nt) of GM values associated with each given solid descriptor.
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
;===========================================================================
function sld_gm, slxp, noevent=noevent
 sldp = class_extract(slxp, 'SOLID')
 nv_notify, sldp, type = 1, noevent=noevent
 sld = nv_dereference(sldp)

 return, sld.GM
end
;===========================================================================
