;===========================================================================
;+
; NAME:
;	sld_phase_parm
;
;
; PURPOSE:
;       Returns the phase function parameters for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	mass = sld_phase_parm(slx)
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
;       Array (npht,nt) of phase function parameters associated with each 
;	given solid descriptor.
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
function sld_phase_parm, slxp, noevent=noevent
 sldp = class_extract(slxp, 'SOLID')
 nv_notify, sldp, type = 1, noevent=noevent
 sld = nv_dereference(sldp)
 return, sld.phase_parm
end
;===========================================================================
