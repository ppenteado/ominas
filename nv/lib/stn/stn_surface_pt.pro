;===========================================================================
;+
; NAME:
;	stn_surface_pt
;
;
; PURPOSE:
;	Returns the surface_pt vector for each given station descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	surface_pt = stn_surface_pt(std)
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
;	Array (1,3,nt) of surface_pt vectors associated with each given 
;	station descriptor.
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
function stn_surface_pt, stxp
@nv_lib.include
 stdp = class_extract(stxp, 'STATION')
 nv_notify, stdp, type = 1
 std = nv_dereference(stdp)
 return, std.surface_pt
end
;===========================================================================



