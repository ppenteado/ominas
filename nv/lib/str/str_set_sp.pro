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
;	str_set_sp, sx, sp
;
;
; ARGUMENTS:
;  INPUT: 
;	sx:	 Array (nt) of any subclass of STAR.
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
;	
;-
;=============================================================================
pro str_set_sp, sxp, sp
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')
 sd = nv_dereference(sdp)

 sd.sp=sp

 nv_rereference, sdp, sd
 nv_notify, sdp, type = 0
end
;===========================================================================

