;=============================================================================
;+
; NAME:
;	map_radii
;
;
; PURPOSE:
;	Returns the rference radii for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	radii = map_radii(md)
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
;	Array (3,nt) of refernce radii associated with each given map 
;	descriptor.
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
function map_radii, md, noevent=noevent
@core.include
 nv_notify, md, type = 1, noevent=noevent
 _md = cor_dereference(md)
 return, _md.radii
end
;===========================================================================
