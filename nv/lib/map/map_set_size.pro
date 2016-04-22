;=============================================================================
;+
; NAME:
;	map_set_size
;
;
; PURPOSE:
;	Replaces the size for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_size, md, size
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	size:	 Array (2,nt) of new map sizes.
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
pro map_set_size, mdp, size, noevent=noevent
@nv_lib.include
 md = nv_dereference(mdp)

 md.size=size

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0 , noevent=noevent
end
;===========================================================================
