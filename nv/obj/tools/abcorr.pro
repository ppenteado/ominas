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
;       targ_bx = abcorr(obs_bx, targ_bx0, c=c)
;
;
; ARGUMENTS:
;  INPUT:
;	obs_bx:	  Any subclass of BODY describing the observer.
;
;	targ_bx0: Array(nt) of any subclass of BODY describing the targets.
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
; RETURN: 
;	New target descriptors.  
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function abcorr, obs_bx, targ_bx0, c=c, iterate=iterate, epsilon=epsilon, fast=fast

 ;-----------------------------------------------
 ; correct for light-travel time
 ;-----------------------------------------------
 targ_bx = ltcorr(obs_bx, targ_bx0, c=c, iterate=iterate, epsilon=epsilon)

 ;-----------------------------------------------
 ; correct for stellar aberration
 ;-----------------------------------------------
 stellab, obs_bx, targ_bx, c=c, fast=fast

 return, targ_bx
end
;============================================================================
