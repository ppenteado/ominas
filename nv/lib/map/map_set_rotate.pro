;=============================================================================
;+
; NAME:
;	map_set_rotate
;
;
; PURPOSE:
;	Replaces the rotate value for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_rotate, md, rotate
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	rotate:	 Array (nt) of new rotate values.
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
pro map_set_rotate , mdp, rotate , noevent=noevent
@nv_lib.include
 md = nv_dereference(mdp)

 md.rotate = rotate 

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0, noevent=noevent
end
;===========================================================================
