;=============================================================================
;+
; NAME:
;	map_rotate
;
;
; PURPOSE:
;	Returns the rotate value for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	rotate = map_rotate(md)
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
;	Array (nt) of rotate values associated with each given map descriptor.
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
function map_rotate, mdp, noevent=noevent
@nv_lib.include
 nv_notify, mdp, type = 1, noevent=noevent
 md = nv_dereference(mdp)
 return, md.rotate
end
;===========================================================================
