;===========================================================================
;+
; NAME:
;	sld_set_albedo
;
;
; PURPOSE:
;       Replaces the bond albedo for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_albedo, slx, albedo
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
;
;	albedo:	 Array (nt) of new bond albedos.
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
pro sld_set_albedo, slxp, albedo, noevent=noevent
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 sld.albedo=albedo

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0, noevent=noevent
end
;===========================================================================
