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
;	sld_set_albedo, sld, albedo
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro sld_set_albedo, sld, albedo, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.albedo=albedo

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
