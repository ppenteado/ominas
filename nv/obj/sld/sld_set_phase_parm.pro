;===========================================================================
;+
; NAME:
;	sld_set_phase_parm
;
;
; PURPOSE:
;       Replaces the phase function parameters for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_phase_parm, sld, phase_parm
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:		Array (nt) of any subclass of SOLID descriptors.
;
;	phase_parm:	Array (nt) of new phase function parameters.
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
; 	Written by:	Spitale, 3/2017
;	
;-
;===========================================================================
pro sld_set_phase_parm, sld, phase_parm, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.phase_parm=phase_parm

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
