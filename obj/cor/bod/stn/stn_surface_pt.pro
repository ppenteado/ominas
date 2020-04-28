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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function stn_surface_pt, std, noevent=noevent
@core.include

 nv_notify, std, type = 1, noevent=noevent
 _std = cor_dereference(std)
 return, _std.surface_pt
end
;===========================================================================



