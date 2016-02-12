;=============================================================================
;+
; NAME:
;	map_size
;
;
; PURPOSE:
;	Returns the size for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	size = map_size(md)
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
;	Array (2,nt) of sizes associated with each given map descriptor.
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
function map_size, mdp
@nv_lib.include
 nv_notify, mdp, type = 1
 md = nv_dereference(mdp)
 return, md.size
end
;===========================================================================
