;=============================================================================
;+
; NAME:
;	pg_fit
;
;
; PURPOSE:
;	Performs a simultaneous 1-,2-, or 3-parameter linear least-squares fit 
;	using the given coefficients.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	dxy = pg_fit(cf, dtheta=dtheta)
;
;
; ARGUMENTS:
;  INPUT:
;	cf:	Array of pg_fit_coeff_struct as produced by pg_cvscan_coeff or
;		pg_ptscan_coeff.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;	dtheta:	Fit offset in theta.
;
;
; RETURN:
;	2-element array giving the fit offset as [dx,dy].
;
;
; RESTRICTIONS:
;	It is the caller's responsibility to ensure that all of the input
;	coefficients were computed using with the same set of fixed parameters.
;
;
; PROCEDURE:
;	pg_fit extracts the fit coefficients from cf and inputs them to mbfit
;	to perform a simultatneous least square fit using all of the
;	coefficients.  See the documentation for that routine for more detail.
;
;
; EXAMPLE:
;	The following commands perform a simultaneous least square fit to
;	a limb, ring and star field with all parameters free:
;
;	cvscan_ps = pg_cvscan(dd, [limb_ps,ring_ps], width=40, edge=20)
;	ptscan_ps = pg_ptscan(dd, [star_ps], width=40, edge=20)
;
;	cvscan_cf = pg_cvscan_coeff(cvscan_ps, axis=center_ps)
;	ptscan_cf = pg_ptscan_coeff(ptscan_ps, axis=center_ps)
;
;	dxy = pg_fit([cvscan_cf,ptscan_cf], dtheta=dtheta)
;
;	In this example, center_ps, limb_ps, ring_ps, and star_ps are assumed 
;	to have been previously computed using the appropriate routines.
;
;	Note that since this is a linear fit, the input systems may have been
;	linearized and it may be necessary to iterate this procedure.
;
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_cvscan, pg_cvscan_coeff, pg_ptscan, pg_ptscan_coeff, 
;	pg_cvchisq, pg_ptchisq, pg_threshold
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function pg_fit, cf, dtheta=dtheta

 solution = mbfit(cf.M, transpose(cf.b))
 dxy = solution[0:1]
 dtheta = solution[2]

 return, dxy
end
;=============================================================================
