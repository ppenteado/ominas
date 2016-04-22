;=============================================================================
;+
; NAME:
;	str_set_lum
;
;
; PURPOSE:
;	Replaces the luminosities for each given star descriptor.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	str_set_lum, sx, lum
;
;
; ARGUMENTS:
;  INPUT: 
;	sx:	 Array (nt) of any subclass of STAR.
;
;	lum:	 Array (nt) of new luminosity values.
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
;=============================================================================
pro str_set_lum, sxp, lum, noevent=noevent
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')
 sd = nv_dereference(sdp)

 sd.lum=lum

 nv_rereference, sdp, sd
 nv_notify, sdp, type = 0, noevent=noevent
end
;===========================================================================



