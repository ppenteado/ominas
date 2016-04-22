;===========================================================================
;+
; NAME:
;	stn_body
;
;
; PURPOSE:
;	Returns the body descriptor for each given station descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	bd = stn_body(std)
;
;
; ARGUMENTS:
;  INPUT: 
;	std:	 Array (nt) of STATION descriptors.
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
;	Body descriptor associated with each given station descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;===========================================================================
function stn_body, stxp, noevent=noevent
@nv_lib.include
 stdp = class_extract(stxp, 'STATION')
 nv_notify, stdp, type = 1, noevent=noevent
 std = nv_dereference(stdp)
 return, std.bd
end
;===========================================================================



