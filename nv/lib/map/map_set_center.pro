;=============================================================================
;+
; NAME:
;	map_set_center
;
;
; PURPOSE:
;	Replaces the center for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_center, md, center
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	center:	 Array (2,nt) of new map centers.
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
pro map_set_center, mdp, center, noevent=noevent
@nv_lib.include
 md = nv_dereference(mdp)

 md.center=center

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0, noevent=noevent
end
;===========================================================================
