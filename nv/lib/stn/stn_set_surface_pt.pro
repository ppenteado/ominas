;===========================================================================
;+
; NAME:
;	stn_set_surface_pt
;
;
; PURPOSE:
;	Replaces the surface_pt vector in each given station descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	stn_set_surface_pt, std, surface_pt
;
;
; ARGUMENTS:
;  INPUT: 
;	std:	Array (nt) of STATION descriptors.
;
;	surface_pt:	Array (1,3,nt) of surface_pt vectors.
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
pro stn_set_surface_pt, stxp, surface_pt, noevent=noevent
@nv_lib.include
 stdp = class_extract(stxp, 'STATION')
 std = nv_dereference(stdp)

 std.surface_pt=surface_pt

 nv_rereference, stdp, std
 nv_notify, stdp, type = 0, noevent=noevent
end
;===========================================================================



