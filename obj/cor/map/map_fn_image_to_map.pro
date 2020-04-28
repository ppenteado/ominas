;=============================================================================
;+
; NAME:
;	map_fn_image_to_map
;
;
; PURPOSE:
;	Returns the name of the image->map function for each given map 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	fn_image_to_map = map_fn_image_to_map(md)
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
;	Array (nt) of image->map function names associated with each given 
;	map descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function map_fn_image_to_map, md, noevent=noevent
@core.include
 nv_notify, md, type = 1, noevent=noevent
 _md = cor_dereference(md)
 return, 'map_image_to_map_' + _md.projection
end
;===========================================================================
