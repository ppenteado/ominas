;===========================================================================
;+
; NAME:
;	arr_set_surface_pts
;
;
; PURPOSE:
;	Replaces the surface_pts vector in each given array descriptor.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	arr_set_surface_pts, ard, surface_pts
;
;
; ARGUMENTS:
;  INPUT: 
;	ard:	Array (nt) of ARRAY descriptors.
;
;	surface_pts:	Array (nv,3,nt) of surface_pts vectors.
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
pro arr_set_surface_pts, arxp, surface_pts
@nv_lib.include
 ardp = class_extract(arxp, 'ARRAY')
 ard = nv_dereference(ardp)

 if(NOT ptr_valid(ard.surface_pts_p)) then ard.surface_pts_p = ptr_new(surface_pts) $
 else *ard.surface_pts_p = surface_pts

 nv_rereference, ardp, ard
 nv_notify, ardp, type = 0
end
;===========================================================================



