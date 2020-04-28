;=============================================================================
;+
; NAME:
;	bod_time
;
;
; PURPOSE:
;	Returns the time for each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	time = bod_time(bx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	bx:	 Any subclass of BODY.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Time value associated with each given body descriptor.
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
function bod_time, bd, noevent=noevent
@core.include
 nv_notify, bd, type = 1, noevent=noevent
 _bd = cor_dereference(bd)
 return, _bd.time
end
;===========================================================================



