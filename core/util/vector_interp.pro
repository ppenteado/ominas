;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	vector_interp
;
;
; PURPOSE:
;	Performs Lagrange interpolation on an array of vectors.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	vi:	Array (nv,3,nt) of vectors.
;
;	ti:	Array (nt) of times for the given vectors.
;
;	t:	Array (n) of times at which to interpolate.
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	Array (nv,3,n) of interpolated vectors.
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function vector_interp, vi, ti, t

 nt = n_elements(ti)
 n = n_elements(t)
 nv = (size(vi))[1]


 ;-------------------------
 ; construct differences
 ;-------------------------
 t_tj = (t[gen3x(n,nt,1)] - ti[gen3y(n,nt,1)])[linegen3z(n,nt,nt)]
 diag = lindgen(n)#make_array(nt, val=1d) + linegen3x(n,nt,1)*n*(nt+1)
 t_tj[diag] = 1

 ti_tj = ti[gen3x(nt,nt,1)] - ti[gen3y(nt,nt,1)]
 diag = lindgen(nt)
 ti_tj[diag,diag] = 1


 ;------------------------------
 ; products of differences
 ;------------------------------
 numer = reform(prod(t_tj,2), 1,n,nt, /over)
 denom = reform(prod(ti_tj,2)##make_array(n, val=1d), 1,n,nt, /over)

 coeff = (numer/denom)[linegen3x(nv,n,nt)]


 ;----------------------------------------------------
 ; interpolate each vector element separately
 ;----------------------------------------------------
 v = dblarr(nv,3,n)

 terms = coeff * (vi[*,0,*])[linegen3y(nv,n,nt)]
 v[*,0,*] = total(terms,3)

 terms = coeff * (vi[*,1,*])[linegen3y(nv,n,nt)]
 v[*,1,*] = total(terms,3)

 terms = coeff * (vi[*,2,*])[linegen3y(nv,n,nt)]
 v[*,2,*] = total(terms,3)


 return, v
end
;=============================================================================

; nv = 10
; nt = 5
; n = 3

; ti = dindgen(nt)/nt * 100d
; x = dindgen(nv)/nv * 1000d
; t = dindgen(n)/n * 99d

; w = 1d-4
; k = 1d-2

; wt = w*ti ## make_array(nv, val=1d)
; kx = k*x # make_array(nt, val=1d)

; vi = dblarr(nv,3,nt)
; vi[*,0,*] = sin(wt - kx)
; vi[*,1,*] = cos(wt - kx)
; vi[*,2,*] = tan(wt - kx)

; v = vector_interp(vi, ti, t)

; plot, ti, vi[0,0,*]
; oplot, t, v[0,0,*], psym=1




