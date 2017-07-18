;===========================================================================
;+
; NAME:
;	sld_set_mass
;
;
; PURPOSE:
;       Replaces the mass for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_mass, sld, mass
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
;
;	j:	 Array (nj,nt) of new masses.
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
; 	Written by:	Spitale, 7/2015
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro sld_set_mass, sld, mass, nosynch=nosynch, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 if(NOT keyword__set(nosynch)) then _sld.gm = _sld.gm * mass/_sld.mass
 _sld.mass = mass

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
