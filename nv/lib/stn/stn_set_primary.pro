;===========================================================================
;+
; NAME:
;	stn_set_primary
;
;
; PURPOSE:
;	Replaces the primary string in each given station descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	stn_set_primary, std, primary
;
;
; ARGUMENTS:
;  INPUT: 
;	std:	Array (nt) of STATION descriptors.
;
;	primary:	Array (nt) of primary strings.
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
pro stn_set_primary, stxp, primary
@nv_lib.include
 stdp = class_extract(stxp, 'STATION')
 std = nv_dereference(stdp)

 std.primary=primary

 nv_rereference, stdp, std
 nv_notify, stdp, type = 0
end
;===========================================================================



