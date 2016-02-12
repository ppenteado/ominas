;=============================================================================
;+
; NAME:
;	map_set_offset
;
;
; PURPOSE:
;	Replaces the offset for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_offset, md, offset
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	offset:	 Array (2,nt) of new map offsets.
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
pro map_set_offset, mdp, offset
@nv_lib.include
 md = nv_dereference(mdp)

 md.offset=offset

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0
end
;===========================================================================
