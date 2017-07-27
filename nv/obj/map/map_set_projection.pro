;=============================================================================
;+
; NAME:
;	map_set_projection
;
;
; PURPOSE:
;	Replaces the projection name for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_projection, md, projection
;
;
; ARGUMENTS:
;  INPUT: 
;	md:		 Array (nt) of map descriptors.
;
;	projection:	 Array (nt) of new projection names.
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
pro map_set_projection, md, projection, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.projection = projection

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
