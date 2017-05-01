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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function arr_surface_pts, ard, noevent=noevent
@core.include

 nv_notify, ard, type = 1, noevent=noevent
 _ard = cor_dereference(ard)
 if(NOT ptr_valid(_ard.surface_pts_p)) then return, 0
 return, *_ard.surface_pts_p
end
;===========================================================================



