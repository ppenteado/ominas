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
;	sld_set_phase_fn, sld, phase_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro sld_set_phase_fn, sld, phase_fn, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.phase_fn=phase_fn

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
