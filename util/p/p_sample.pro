;=============================================================================
;+
; NAME:
;       p_sample
;
;
; PURPOSE:
;       Resamples the given points such that their spacing is 
;	uniform.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = p_sample(p, spacing=spacing)
;
;
; ARGUMENTS:
;  INPUT:
;               p:      An array of np points (i.e., 2 x np array) 
;			to resample.  Note that the reason there is no
;			nt direction is that unifrom spacing would impose
;			differing numbers of elements in that direction, which
;			is not permissible.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of np uniformly-spaced points.
;
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale  10/2012
;
;-
;=============================================================================
function p_sample, p, dd, spline=spline, lsquadratic=lsquadratic, quadratic=quadratic

 ;------------------------
 ; get dimensions
 ;------------------------
 np = n_elements(p)/2


 ;------------------------------------------------------------
 ; compute input spacings, and total path offsets 
 ;------------------------------------------------------------
 d = [0, p_mag(p[*,0:np-2] - p[*,1:*])]
 len = total(d)
 x = total(d, /cumulative)


 ;------------------------------------------------------------
 ; compute output spacings, and total path offsets 
 ;------------------------------------------------------------
 npp = round(len / dd)
 xx = dd * dindgen(npp)


 ;------------------------------------------------------------
 ; interpolate vectors by component
 ;------------------------------------------------------------
 pp = dblarr(2,npp)
 pp[0,*] = interpol(p[0,*], x, xx, spline=spline, lsquadratic=lsquadratic, quadratic=quadratic)
 pp[1,*] = interpol(p[1,*], x, xx, spline=spline, lsquadratic=lsquadratic, quadratic=quadratic)


 return, pp
end
;===========================================================================
