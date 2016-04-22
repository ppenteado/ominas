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
;	
;-
;=============================================================================
pro map_set_units, mdp, units, noevent=noevent
@nv_lib.include
 md = nv_dereference(mdp)

 md.units=units

 nv_rereference, mdp, md
 nv_notify, mdp, type = 0, noevent=noevent
end
;===========================================================================
