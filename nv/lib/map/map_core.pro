;=============================================================================
;+
; NAME:
;	map_core
;
;
; PURPOSE:
;	Returns the core descriptor for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	crd = map_core(md)
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
;	Array (nt) of core descriptors associated with each given map 
;	descriptor.
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
function map_core, mdp, noevent=noevent
@nv_lib.include
 nv_notify, mdp, type = 1, noevent=noevent
 md = nv_dereference(mdp)
 return, md.crd
end
;===========================================================================
