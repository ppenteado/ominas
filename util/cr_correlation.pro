;=========================================================================
;+
; cr_correlation
;
; PURPOSE :
;`
;  Computes the cross correlation function:
;
;
;                    /
;            R(t) =  | f(x) g(x+t) dx
;                    /
;
; of f and g as a funtion of t.
;
;'
; f and g may be 1, 2, 3, or 4 dimensional, but they must 
; be of the same size and dimension.  g is shifted and wrapped 
; by t pixels and then the integration is performed.
;
;
; CALLING SEQUENCE :
;
;  eta = cr_correlation(f, g, t)
;
;
; ARGUMENTS
;  INPUT : f - reference function; 1, 2, 3, or 4 dimensional array.
;
;          g - function to be shifted, must be of same dimension as f
;
;          t - shift vector.
;
;  OUTPUT : NONE
;
;
;
; KEYWORDS 
;  INPUT : NONE
;
;  OUTPUT : NONE
;
;
;
; RETURN : the cross correlation value; see PURPOSE above.
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURES USED: NONE
;
;
;
; KNOWN BUGS : NONE
;
;
;
; ORIGINAL AUTHOR : J. Spitale ; 8/94
;
; UPDATE HISTORY : 
;
;-
;================================================================
function cr_correlation, f, g, t, normalize=normalize

 f = float(f)
 g = float(g)

 case n_elements(t) of
  1: shift_g = shift(g, t)
  2: shift_g = shift(g, t(0), t(1))
  3: shift_g = shift(g, t(0), t(1), t(2))
  4: shift_g = shift(g, t(0), t(1), t(2), t(3))
 endcase

 if(NOT keyword__set(normalize)) then result = total(f * shift_g) $
 else $
  begin
   nn = n_elements(f)
   sig_f = stdev(f, f_mean)
   sig_g = stdev(g, g_mean)

   if((sig_f EQ 0) OR (sig_g EQ 0)) then result = 0d $
   else result = total((f-f_mean)*(shift_g-g_mean)) / (nn*sig_f*sig_g)
  end

 return, result
end
;================================================================

