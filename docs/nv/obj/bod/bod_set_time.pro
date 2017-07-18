;=============================================================================
;+
; NAME:
;	bod_set_time
;
;
; PURPOSE:
;	Replaces the time of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_time, bx, time
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Any subclass of BODY.
;
;	time:	 New time value.
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
pro bod_set_time, bd, time, noevent=noevent
@core.include
 _bd = cor_dereference(bd)

 _bd.time=time

 cor_rereference, bd, _bd
 nv_notify, bd, type = 0, noevent=noevent
end
;===========================================================================



