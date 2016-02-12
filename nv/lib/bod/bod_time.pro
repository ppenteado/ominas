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
;	
;-
;=============================================================================
function bod_time, bxp
 bdp = class_extract(bxp, 'BODY')
 nv_notify, bdp, type = 1
 bd = nv_dereference(bdp)
 return, bd.time
end
;===========================================================================



