;=============================================================================
;+
; NAME:
;	map_set_type
;
;
; PURPOSE:
;	Replaces the type name for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_type, md, type
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	type:	 Array (nt) of new type names.
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
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
pro map_set_type, mdp, type
@nv_lib.include
 md = nv_dereference(mdp)

 md.type=type
 map_lookup_transformations, md, fn_map_to_image, fn_image_to_map
 md.fn_map_to_image = decrapify(fn_map_to_image)
 md.fn_image_to_map = decrapify(fn_image_to_map)

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0
end
;===========================================================================
