;=============================================================================
;+
; NAME:
;	map_set_origin
;
;
; PURPOSE:
;	Replaces the origin for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_origin, md, origin
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	origin:	 Array (2,nt) of new map origins.
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
pro map_set_origin, mdp, origin, noevent=noevent
@nv_lib.include
 md = nv_dereference(mdp)

 md.origin=origin

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0, noevent=noevent
end
;===========================================================================
