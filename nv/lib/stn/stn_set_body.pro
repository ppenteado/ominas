;===========================================================================
;+
; NAME:
;	stn_set_body
;
;
; PURPOSE:
;	Replaces the body descriptor in each given station descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	stn_set_body, std, bd
;
;
; ARGUMENTS:
;  INPUT: 
;	std:	 Array (nt) of STATION descriptors.
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
; 	Written by:	Spitale
;	
;-
;===========================================================================
pro stn_set_body, stxp, bdp
@nv_lib.include
 stdp = class_extract(stxp, 'STATION')
 std = nv_dereference(stdp)

 std.bd=bdp

 nv_rereference, stdp, std
 nv_notify, stdp, type = 0
end
;===========================================================================



