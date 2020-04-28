;=============================================================================
;+
; NAME:
;       v_rotate_11
;
;
; PURPOSE:
;       Rotates the (nv,3,nt) column vectors, v, about the (nv,3,nt) column
;       vectors, n, by the (nv,nt) angles theta.  The sin and cos of theta are
;       given in order to improve performance.  Each vector in v is rotated
;       about the corresponding vector in n by the corresponding angle in theta.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_rotate_11(v, n, sin_theta, cos_theta)
;
;
; ARGUMENTS:
;  INPUT:
;               v:      An array of N column vectors
;
;               n:      An array of N column vectors
;
;       sin_theta:      Sine of rotation angle theta
;
;       cos_theta:      Cosine of rotation angle theta
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       If the arguments have dimensions v(nv,3,nt), n(nv,3,nt) and
;       sin_theta(nv,nt), cos_theta(nv,nt) then the result has dimensions
;       (nv,3,nt).
;
;
; RESTRICTIONS:
;       v and n must have exactly the same dimensions.
;       sin_theta and cos_theta must be 1-dimensional arrays of any length
;       as long as the lengths are the same.  Note that if only one theta
;       is specified, the arguments must be given as [sin_theta], [cos_theta]
;       instead of as scalars.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function v_rotate_11, v, n, sin_theta, cos_theta

 n_dot_v_x_1_cos_theta = total(n*v, 2)*(1d - cos_theta)

 sv = size(v)
 nv = sv[1]
 nt = 1
 if(sv[0] EQ 3) then nt = sv[3]

 r = dblarr(nv,3,nt, /nozero)
 r[*,0,*] = v[*,0,*]*cos_theta + n[*,0,*]*n_dot_v_x_1_cos_theta + $
                            (n[*,1,*]*v[*,2,*] - n[*,2,*]*v[*,1,*])*sin_theta
 r[*,1,*] = v[*,1,*]*cos_theta + n[*,1,*]*n_dot_v_x_1_cos_theta + $
                            (n[*,2,*]*v[*,0,*] - n[*,0,*]*v[*,2,*])*sin_theta
 r[*,2,*] = v[*,2,*]*cos_theta + n[*,2,*]*n_dot_v_x_1_cos_theta + $
                            (n[*,0,*]*v[*,1,*] - n[*,1,*]*v[*,0,*])*sin_theta

 return, r
end
;===========================================================================
