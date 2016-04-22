;===========================================================================
;+
; NAME:
;	sld_refl_parm
;
;
; PURPOSE:
;       Returns the reflection function parameters for each given solid 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	mass = sld_refl_parm(gbx)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	 Array (nt) of any subclass of SOLID descriptors.
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
;       Array (npht,nt) of reflection function parameters associated with 
;	each given solid descriptor.
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
;===========================================================================
function sld_refl_parm, gbxp, noevent=noevent
 gbdp = class_extract(gbxp, 'SOLID')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)
 return, gbd.refl_parm
end
;===========================================================================
