;=============================================================================
;+
; NAME:
;	map_set_size
;
;
; PURPOSE:
;	Replaces the size for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_size, md, size
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	size:	 Array (2,nt) of new map sizes.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro map_set_size, md, size, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.size=size

 cor_rereference, md, _md
 nv_notify, md, type = 0 , noevent=noevent
end
;===========================================================================
