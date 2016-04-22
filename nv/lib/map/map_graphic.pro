;=============================================================================
;+
; NAME:
;	map_graphic
;
;
; PURPOSE:
;	Returns the graphic flag for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	graphic = map_graphic(md)
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
;	Array (nt) of graphic flags associated with each given map descriptor.
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
function map_graphic, mdp, noevent=noevent
@nv_lib.include
 nv_notify, mdp, type = 1, noevent=noevent
 md = nv_dereference(mdp)
 return, md.graphic
end
;===========================================================================
