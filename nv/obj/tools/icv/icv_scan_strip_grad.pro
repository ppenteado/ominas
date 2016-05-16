;=============================================================================
;+
; NAME:
;	icv_scan_strip_grad
;
;
; PURPOSE:
;	At each point along an image strip, finds a sharp edge using the
;	maximum-gradient method.
;
;
; CATEGORY:
;	NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;	result = icv_scan_strip_grad(strip, model, szero, mzero)
;
;
; ARGUMENTS:
;  INPUT:
;	strip:	Image strip (n_points,ns) to be scanned.  Output from
;		icv_strip_curve ns must be even.
;
;	model:	Not used.
;
;	szero:	Zero-offset position in the strip.
;
;	mzero:	Not used.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	norm:	If set, only the absolute value of the gradint is evaluated.
;
;  OUTPUT:
;	cc:	Not used, hardwired to 0.9999999d.
;
;	sigma:	Offset uncertainty for each point on the curve, computed as
;		one half of the half-width of the gradient peak. 
;
;
; RETURN:
;	Offset of maximum gradient points at each point on the curve.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function icv_scan_strip_grad, strip, model, szero, mzero, arg=inner, $
        cc=cc, sigma=sigma, norm=norm

 mzero = 0.
 inner = keyword_set(inner)

 ;-----------------
 ; get sizes
 ;-----------------
 s = size(strip)
 n = s[1]
 ns = s[2]
 half_ns = ns/2

 ;----------------------------------
 ; compute gradients
 ;----------------------------------
 grad_all = shift(strip, 0,1) - shift(strip, 0,-1)
 grad_all[*,0] = ( grad_all[*,ns-1] = 0)

 if(inner) then grad_all = -grad_all
 if(keyword_set(norm)) then grad_all = abs(grad_all)

 ;-----------------------------------------------------------------
 ; Find indices of max gradient and extract 3 pixels about peak.
 ; Also, find half widths of gradient peaks.
 ;-----------------------------------------------------------------
 scan_indices = dblarr(n,/nozero)
 sigma = make_array(n, val=ns)

 grad_peak = dblarr(n,3)
 for i=0, n-1 do $
  begin
   scan_indices[i] = (where(grad_all[i,*] EQ max(grad_all[i,*])))[0]
   if((scan_indices[i] GT 0) AND (scan_indices[i] LT ns)) then $
    begin
     grad_peak[i,*] = grad_all[i, scan_indices[i]+indgen(3)-1]

     ;- - - - - - - - - - - - - - - - - - - - -
     ; approx. half-width
     ;- - - - - - - - - - - - - - - - - - - - -
     w = where(grad_all[i,*] GT grad_peak[i,1]/2.)
     nw = n_elements(w)

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; if there are multiple peaks, then this scan offset is meaningless
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     bad = 0
;     if(nw LT 5) then bad = 1
;     if(w[nw-1] - w[0] NE nw-1) then bad = 1

     if(bad) then sigma[i] = ns $
     else sigma[i] = 1. > (max([max(w)-scan_indices[i], scan_indices[i]-min(w)]))
    end

  end


 ;----------------------------------------------------------------------
 ; use 3-point polynomial interpolation to find max grad for each point
 ;----------------------------------------------------------------------
 Ea = grad_peak[*,0]/2 - grad_peak[*,1] + grad_peak[*,2]/2
 Eb = 3*grad_peak[*,0]/2 - 2*grad_peak[*,1] + grad_peak[*,2]/2
 Eg = grad_peak[*,0]



 ;-------------------
 ; compute peaks
 ;-------------------
 xm = make_array(n, val=1d100)
 ww = where(Ea NE 0)
 if(ww[0] EQ -1) then return, xm

 xm[ww] = Eb/(2*Ea[ww])
 grad = Ea*xm^2 - Eb*xm + Eg

 w = where(sigma EQ ns)
 if(w[0] NE -1) then grad[w] = 0

 scan_indices = scan_indices + xm - 1


 ;--------------------------------
 ; convert to scan offsets
 ;--------------------------------
 scan_offsets = (scan_indices+mzero) - szero


 ;--------------------------------------------------------
 ; ensure that all points are accepted by the software
 ;--------------------------------------------------------
 cc = make_array(n, val=0.9999999d)


 return, scan_offsets
end
;=============================================================================
