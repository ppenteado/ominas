;=============================================================================
;+
; NAME:
;	map_scale
;
;
; PURPOSE:
;	Returns the scale factor for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	scale = map_scale(md)
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
;	Array (nt) of scale factors associated with each given map descriptor.
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
function map_scale, mdp
@nv_lib.include
 nv_notify, mdp, type = 1
 md = nv_dereference(mdp)
 return, md.scale
end
;===========================================================================
