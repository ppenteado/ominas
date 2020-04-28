;=============================================================================
; ngf_gaussian
;
;=============================================================================
function ngf_gaussian, x, coeff
 z = (x - coeff[1])/coeff[2]
 return, coeff[0] * exp(-z^2/2d)
end
;=============================================================================



;=============================================================================
; ngf_dgaussian
;
;=============================================================================
function ngf_dgaussian, x, coeff, a0=a0, a1=a1, a2=a2
 if(keyword__set(a0)) then return, ngf_gaussian(x, coeff) /  coeff[0]
 if(keyword__set(a1)) then $
              return, ngf_gaussian(x, coeff) * (x - coeff[1]) / coeff[2]^2
 if(keyword__set(a2)) then $
            return, ngf_gaussian(x, coeff) * (x - coeff[1])^2 / coeff[2]^3
end
;=============================================================================



;=============================================================================
; ngf_eval
;
;=============================================================================
pro ngf_eval, x, coeff, result, pder
common ngf_block, yy

 n = n_elements(coeff)/3

 result = 0d
 for i=0, n-1 do yy[*,i] = ngf_gaussian(x, coeff[3*i:3*i+2])
 result = total(yy, 2)

 pder0 = 0d
 for i=0, n-1 do pder0 = $
           append_array(pder0, tr(ngf_dgaussian(x, coeff[3*i:3*i+2], /a0)))
 pder1 = 0d
 for i=0, n-1 do pder1 = $
           append_array(pder1, tr(ngf_dgaussian(x, coeff[3*i:3*i+2], /a1)))
 pder2 = 0d
 for i=0, n-1 do pder2 = $
           append_array(pder2, tr(ngf_dgaussian(x, coeff[3*i:3*i+2], /a2)))


 pder = 0d
 for i=0, n-1 do pder = append_array(pder, [pder0[i,*], pder1[i,*], pder2[i,*]])

 pder = tr(pder)
end
;=============================================================================



;=============================================================================
; ngaussfit
;
;
;=============================================================================
function ngaussfit, x, y, coeff, chisq=chisq, itmax=itmax, yy=_yy
common ngf_block, yy

 if(NOT keyword_set(coeff)) then $
  begin
   ymax = max(y)
   x0 = x[where(y EQ ymax)]
   coeff = [ymax, x0, 2d*abs(x[min(where(y GT ymax/2d))] - x0)]
  end

 ndata = n_elements(x)
 ncoeff = n_elements(coeff)/3
 yy = dblarr(ndata,ncoeff)

 w = x & w[*] = 1d

 result = curvefit(x, y, w, coeff, chisq=chisq, funct='ngf_eval', itmax=itmax, /noder)

 _yy = yy
 return, result
end
;=============================================================================
