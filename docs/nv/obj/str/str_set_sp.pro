;=============================================================================
;+
; NAME:
;	str_set_sp
;
;
; PURPOSE:
;	Replaces the spectra class for each given star descriptor.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	str_set_sp, sd, sp
;
;
; ARGUMENTS:
;  INPUT: 
;	sd:	 Array (nt) of any subclass of STAR.
;
;	sp:	 Array (nt) of new sp strings.
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
pro str_set_sp, sd, sp, noevent=noevent
@core.include

 _sd = cor_dereference(sd)

 _sd.sp=sp

 cor_rereference, sd, _sd
 nv_notify, sd, type = 0, noevent=noevent
end
;===========================================================================

