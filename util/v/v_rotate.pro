;=============================================================================
;+
; NAME:
;       v_rotate
;
;
; PURPOSE:
;       Rotates the (N,3) column vectors, v, about the (N,3) column vectors,
;       n, by the angles theta.  The sin and cos of theta are given in
;       order to improve performance.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_rotate(v, n, sin_theta, cos_theta)
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
;       If the arguments have dimensions v(N,3), n(N,3) and sin_theta(M),
;       cos_theta(M) then the result has dimensions (N,3,M)
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
function v_rotate, v, n, sin_theta, cos_theta

;-------------------------------------------------------------
; easier to read, but slower and can only have scalar theta : 
;-------------------------------------------------------------
; return, v*cos_theta + n*v_inner(n,v)*(1d - cos_theta) + v_cross(n,v)*sin_theta


;-----------------------------------------------------
; equivalent, except that there are no function calls 
; and theta can have any number of elements : 
;-----------------------------------------------------
 n_dot_v_x_1_cos_theta = total(n*v, 2)#(1d - cos_theta)
 s=size(v)

 r = dblarr(s[1], s[2], n_elements(sin_theta), /nozero)
 MM = make_array(n_elements(sin_theta), val=1d)
 r[*,0,*] = v[*,0]#cos_theta + (n[*,0]#MM)*n_dot_v_x_1_cos_theta + $
                                   (n[*,1]*v[*,2] - n[*,2]*v[*,1])#sin_theta
 r[*,1,*] = v[*,1]#cos_theta + (n[*,1]#MM)*n_dot_v_x_1_cos_theta + $
                                   (n[*,2]*v[*,0] - n[*,0]*v[*,2])#sin_theta
 r[*,2,*] = v[*,2]#cos_theta + (n[*,2]#MM)*n_dot_v_x_1_cos_theta + $
                                   (n[*,0]*v[*,1] - n[*,1]*v[*,0])#sin_theta

 return, r
end
;===========================================================================
