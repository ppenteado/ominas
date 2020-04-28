;=============================================================================
;+
; NAME:
;	map_set_units
;
;
; PURPOSE:
;	Replaces the units for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_units, md, units
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	units:	 Array (2,nt) of new map units.
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
pro map_set_units, md, units, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.units=units

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
