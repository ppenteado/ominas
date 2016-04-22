;=============================================================================
;+
; NAME:
;	map_set_graphic
;
;
; PURPOSE:
;	Replaces the graphic flag for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_graphic, md, graphic
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	graphic:	 Array (nt) of new graphic flags.
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
pro map_set_graphic, mdp, graphic, noevent=noevent
@nv_lib.include
 md = nv_dereference(mdp)

 md.graphic=graphic

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0, noevent=noevent
end
;===========================================================================
