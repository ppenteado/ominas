;=============================================================================
;+
; NAME:
;	map_set_radii
;
;
; PURPOSE:
;	Replaces the reference radii for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_radii, md, radii
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	radii:	 Array (3,nt) of new reference radii.
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
pro map_set_radii, md, radii, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.radii=radii

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
