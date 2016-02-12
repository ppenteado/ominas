;=============================================================================
;+
; NAME:
;	map_set_fn_map_to_image
;
;
; PURPOSE:
;	Replaces the name of the map->image function for each given map 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_fn_map_to_image, md, fn
;
;
; ARGUMENTS:
;  INPUT: NONE
;	md:	Array (nt) of map descriptors.
;
;	fn:	Array (nt) of function names.
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
pro map_set_fn_map_to_image, mdp, fn
@nv_lib.include
 md = nv_dereference(mdp)

 md.fn_map_to_image=fn

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0
end
;===========================================================================
