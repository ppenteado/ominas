;=============================================================================
;+
; NAME:
;	map_type
;
;
; PURPOSE:
;	Returns the type name for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	type = map_type(md)
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
;	Array (nt) of type names associated with each given map descriptor.
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
function map_type, mdp, noevent=noevent
@nv_lib.include
 nv_notify, mdp, type = 1, noevent=noevent
 md = nv_dereference(mdp)
 return, md.type
end
;===========================================================================
