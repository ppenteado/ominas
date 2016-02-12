;===========================================================================
;+
; NAME:
;	sld_set_phase_fn
;
;
; PURPOSE:
;       Replaces the phase function for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_phase_fn, slx, phase_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
;
;	phase_fn: Array (nt) of new phase functions.
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
;===========================================================================
pro sld_set_phase_fn, slxp, phase_fn
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 sld.phase_fn=phase_fn

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0
end
;===========================================================================
