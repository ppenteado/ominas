;=============================================================================
;+
; NAME:
;	map_units
;
;
; PURPOSE:
;	Returns the units for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	units = map_units(md)
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
;	Array (2,nt) of units associated with each given map descriptor.
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
function map_units, mdp
@nv_lib.include
 nv_notify, mdp, type = 1
 md = nv_dereference(mdp)
 return, md.units
end
;===========================================================================
