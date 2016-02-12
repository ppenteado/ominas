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
;	sld_set_mass, slx, mass
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
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
;	
;-
;===========================================================================
pro sld_set_mass, slxp, mass, nosynch=nosynch
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 if(NOT keyword__set(nosynch)) then sld.gm = sld.gm * mass/sld.mass
 sld.mass = mass

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0
end
;===========================================================================
