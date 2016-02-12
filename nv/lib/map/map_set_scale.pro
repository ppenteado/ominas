;=============================================================================
;+
; NAME:
;	map_set_scale
;
;
; PURPOSE:
;	Replaces the scale factor for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_scale, md, scale
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	scale:	 Array (2,nt) of new scale factors.
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
pro map_set_scale, mdp, scale
@nv_lib.include
 md = nv_dereference(mdp)

 md.scale=scale

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0
end
;===========================================================================
