;===========================================================================
;+
; NAME:
;	sld_extn_parm
;
;
; PURPOSE:
;       Returns the extinction function parameters for each given solid 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	mass = sld_extn_parm(sld)
;
;
; ARGUMENTS:
;  INPUT:
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
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
;       Array (npht,nt) of extinction function parameters associated with 
;	each given solid descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2017
;	
;-
;===========================================================================
function sld_extn_parm, sld, noevent=noevent
@core.include

 nv_notify, sld, type = 1, noevent=noevent
 _sld = cor_dereference(sld)
 return, _sld.extn_parm
end
;===========================================================================
