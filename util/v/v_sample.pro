;=============================================================================
;+
; NAME:
;       v_sample
;
;
; PURPOSE:
;       Resamples the given column vectors such that their spacing is 
;	uniform.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_sample(v, dv)
;
;
; ARGUMENTS:
;  INPUT:
;               v:      An array of nv column vectors  (i.e., nv x 3 array) 
;			to resample.  Note that the reason there is no
;			nt direction is that unifrom spacing would impose
;			differing numbers of elements in that direction, which
;			is not permissible.
;
;		dv:	Spacing for new array.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of nv uniformly-spaced column vectors.
;
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale  9/2012
;
;-
;=============================================================================
function v_sample, v, dv, $
         spline=spline, lsquadratic=lsquadratic, quadratic=quadratic

 return, v_interp(v, dv, /uniform, $
             spline=spline, lsquadratic=lsquadratic, quadratic=quadratic)
end
;=============================================================================





;=============================================================================
function v_sample, v, dv, $
         spline=spline, lsquadratic=lsquadratic, quadratic=quadratic


 ;------------------------
 ; get dimensions
 ;------------------------
 nv = n_elements(v)/3


 ;------------------------------------------------------------
 ; compute input spacings, and 1-D path offsets 
 ;------------------------------------------------------------
 d = [0, v_mag(v[0:nv-2,*] - v[1:*,*])]
 len = total(d)
 x = total(d, /cumulative)


 ;------------------------------------------------------------
 ; compute output spacings, and total path offsets 
 ;------------------------------------------------------------
 if(NOT keyword_set(dv)) then dv = min(d[1:*])
 nvv = round(len / dv)
 xx = dv * dindgen(nvv)


 ;------------------------------------------------------------
 ; interpolate vectors by component
 ;------------------------------------------------------------
 vv = dblarr(nvv,3)
 vv[*,0] = interpol(v[*,0], x, xx, spline=spline, lsquadratic=lsquadratic, quadratic=quadratic)
 vv[*,1] = interpol(v[*,1], x, xx, spline=spline, lsquadratic=lsquadratic, quadratic=quadratic)
 vv[*,2] = interpol(v[*,2], x, xx, spline=spline, lsquadratic=lsquadratic, quadratic=quadratic)


 return, vv
end
;===========================================================================
