;===========================================================================
;+
; NAME:
;	sld_albedo
;
;
; PURPOSE:
;       Returns the bond albedo for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	mass = sld_albedo(slx)
;
;
; ARGUMENTS:
;  INPUT:
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (nt) of albedos associated with each given solid descriptor.
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
function sld_albedo, slxp, noevent=noevent
 sldp = class_extract(slxp, 'SOLID')
 nv_notify, sldp, type = 1, noevent=noevent
 sld = nv_dereference(sldp)
 return, sld.albedo
end
;===========================================================================
