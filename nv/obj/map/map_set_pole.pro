;=============================================================================
;+
; NAME:
;	map_set_pole
;
;
; PURPOSE:
;	Replaces the pole for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_pole, md, pole
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	pole:	 Array (nt) of new ominas_map_pole structs.
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
; 	Written by:	Spitale, 8/2016
;	
;-
;=============================================================================
pro map_set_pole, md, pole, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.pole=pole

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
