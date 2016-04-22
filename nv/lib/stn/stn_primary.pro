;===========================================================================
;+
; NAME:
;	stn_primary
;
;
; PURPOSE:
;	Returns the primary string for each given station descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	primary = stn_primary(std)
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
;	Primary string associated with each given station descriptor.
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
;===========================================================================
function stn_primary, stxp, noevent=noevent
@nv_lib.include
 stdp = class_extract(stxp, 'STATION')
 nv_notify, stdp, type = 1, noevent=noevent
 std = nv_dereference(stdp)
 return, std.primary
end
;===========================================================================



