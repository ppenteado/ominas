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
;	str_set_lum, sd, lum
;
;
; ARGUMENTS:
;  INPUT: 
;	sd:	 Array (nt) of any subclass of STAR.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro str_set_lum, sd, lum, noevent=noevent
@core.include

 _sd = cor_dereference(sd)

 _sd.lum=lum

 cor_rereference, sd, _sd
 nv_notify, sd, type = 0, noevent=noevent
end
;===========================================================================



