;=============================================================================
;+
; NAME:
;	map_set_center
;
;
; PURPOSE:
;	Replaces the center for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_center, md, center
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	center:	 Array (2,nt) of new map centers.
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
pro map_set_center, md, center, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.center = center
 _md.center[1,*,*] = reduce_angle(_md.center[1,*,*])

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
