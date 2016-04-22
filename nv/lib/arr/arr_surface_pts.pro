;===========================================================================
;+
; NAME:
;	arr_surface_pts
;
;
; PURPOSE:
;	Returns the surface_pts vector for each given array descriptor.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	surface_pts = arr_surface_pts(ard)
;
;
; ARGUMENTS:
;  INPUT: 
;	ard:	 Array (nt) of ARRAY descriptors.
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
;	Array (nv,3,nt) of surface_pts vectors associated with each given 
;	array descriptor.
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
function arr_surface_pts, arxp, noevent=noevent
@nv_lib.include
 ardp = class_extract(arxp, 'ARRAY')
 nv_notify, ardp, type = 1, noevent=noevent
 ard = nv_dereference(ardp)
 if(NOT ptr_valid(ard.surface_pts_p)) then return, 0
 return, *ard.surface_pts_p
end
;===========================================================================



