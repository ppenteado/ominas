;=============================================================================
;+
; NAME:
;	map_offset
;
;
; PURPOSE:
;	Returns the offset for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	offset = map_offset(md)
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
;	Array (2,nt) of offsets associated with each given map descriptor.
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
function map_offset, mdp, noevent=noevent
@nv_lib.include
 nv_notify, mdp, type = 1, noevent=noevent
 md = nv_dereference(mdp)
 return, md.offset
end
;===========================================================================
