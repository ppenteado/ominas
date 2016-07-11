;=============================================================================
;+
; NAME:
;	map_set_range
;
;
; PURPOSE:
;	Replaces the range for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_range, md, range
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	range:	 Array (2,2,nt) of new map ranges.
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
; 	Written by:	Spitale, 7/2016
;	
;-
;=============================================================================
pro map_set_range, md, range, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.range = range

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
