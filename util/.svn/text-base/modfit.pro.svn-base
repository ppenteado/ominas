;============================================================================
; modfit_eval
;
;============================================================================
pro modfit_eval, x, a, fn, pder
common modfit_block, image, model

 scale = a[0] 
 offset = a[1]
; dx = a[2] 
; dy = a[3]
dx = (dy = 0d)

 si = size(image)
 n = n_elements(image)

 xx = dindgen(si[1]) # make_array(si[2],val=1d)
 yy = dindgen(si[2]) ## make_array(si[1],val=1d)
 xx = xx - dx
 yy = yy - dy

 mm = bilinear(model, xx, yy)

; fn = reform( (mm - offset) * scale  - image, n)
 fn = reform( (mm - offset) * scale, n)
end
;============================================================================



;============================================================================
; modfit
;
;============================================================================
pro modfit, _image, _model, dxy=dxy, sample=sample, $
            scale=scale, offset=offset, chisq=chisq, $
            sig_scale=sig_scale, sig_offset=sig_offset, sig_dxy=sig_dxy
common modfit_block, image, model

 image = _image
 model = _model

 if(NOT keyword__set(dxy)) then dxy = [0d,0d]
 if(NOT keyword__set(scale)) then scale = 1d
 if(NOT keyword__set(offset)) then offset = 0d

; a = [scale, offset, dxy[0], dxy[1]]
 a = [scale, offset]

 n = n_elements(image)
 xx = dindgen(n)

; result = curvefit(xx, dblarr(n), $
;                  make_array(n, val=1d), a, sig, $
;                                chisq=chisq, fun='modfit_eval', /noder)
 result = curvefit(xx, reform(image, n), $
                  make_array(n, val=1d), a, sig, $
                                chisq=chisq, fun='modfit_eval', /noder)

 scale = a[0] & sig_scale = sig[0]
 offset = a[1] & sig_offset = sig[1]
; dxy = a[3:4] & sig_dxy = sig[3:4]

end
;============================================================================



