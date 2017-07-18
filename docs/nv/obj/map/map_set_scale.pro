;=============================================================================
;+
; NAME:
;	map_set_scale
;
;
; PURPOSE:
;	Replaces the scale factor for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_scale, md, scale
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	scale:	 Array (2,nt) of new scale factors.
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
pro map_set_scale, md, scale, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.scale=scale

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
