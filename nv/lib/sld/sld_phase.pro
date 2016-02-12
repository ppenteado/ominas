;=============================================================================
;+
; NAME:
;	sld_phase
;
;
; PURPOSE:
;	Computes a phase function.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	phase = sld_phase(gbd, mu, mu0)
;
;
; ARGUMENTS:
;  INPUT:
;	gbd:	 Globe descriptor.
;
;	mu:	 Cosine of the emission angle.
;
;	mu0:	 Cosine of the incidence angle.
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
;	Phase function value for the given mu and mu0 parameters.
;
;
; PROCEDURE:
;	The function indicated by the phase_fn field of the solid descriptor
;	is called and its return value is passed through to the caller of
;	sld_phase.  
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function sld_phase, gbdp, mu, mu0

 gbd = nv_dereference(gbdp)
 return, call_function(gbd.phase_fn, mu, mu0, gbd.phase_parm)

end
;==================================================================================
