;=============================================================================
;+
; NAME:
;       abcorr
;
;
; PURPOSE:
;	Performs stellar aberration and light-travel-time corrections.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       abcorr, obs_bx, targ_bx, c=c
;
;
; ARGUMENTS:
;  INPUT:
;	obs_bx:	Any subclass of BODY describing the observer.
;
;	obs_bx:	Array(nt) of any subclass of BODY describing the targets.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	c:	Speed of light.
;
;	iterate:	If set, then the lt correction routine will iterate 
;			to refine its solution.
;
;	epsilon:	Stopping criterion for the lt correction: maximum 
;			allowable timing error.  Default is 1d-7.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
pro abcorr, obs_bx, targ_bx, c=c, iterate=iterate, epsilon=epsilon, fast=fast

 ;-----------------------------------------------
 ; correct for light-travel time
 ;-----------------------------------------------
 ltcorr, obs_bx, targ_bx, c=c, iterate=iterate, epsilon=epsilon

 ;-----------------------------------------------
 ; correct for stellar aberration
 ;-----------------------------------------------
 stellab, obs_bx, targ_bx, c=c, fast=fast

end
;============================================================================
