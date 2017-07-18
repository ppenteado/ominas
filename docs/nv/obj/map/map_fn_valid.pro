;=============================================================================
;+
; NAME:
;	map_fn_valid
;
;
; PURPOSE:
;	Returns the name of the map->image validation function for each given 
;	map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	fn_valid = map_fn_image_to_map(md)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	md:	 Array (nt) of map descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nt) of map->image validation function names associated with each given 
;	map descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2012
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function map_fn_valid, md, noevent=noevent
@core.include
 nv_notify, md, type = 1, noevent=noevent
 _md = cor_dereference(md)
 return, '_map_valid_points_' + _md.type
end
;===========================================================================
