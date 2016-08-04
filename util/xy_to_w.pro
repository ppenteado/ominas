;==============================================================================
; xy_to_w
;
;
;==============================================================================
function xy_to_w, im, p, sx=sx, sy=sy

 if(n_elements(im) EQ 2) then $
  begin
    sx = im[0]
    sy = im[1] 
  end $
 else $
  begin
   s = size(im)
   if(NOT keyword_set(sx)) then sx = s[1]
   if(NOT keyword_set(sy)) then sy = s[2]
  end

 w = round(p[0,*] + p[1,*]*sx)

; ii = where((p[0,*] LT 0) OR (p[0,*] GE sx) $
;               OR (p[1,*] LT 0) OR (p[1,*] GE sy))
; if(ii[0] NE -1) then w[ii] = -1

 return, reform(w)
end
;==============================================================================



;==============================================================================
; xy_to_w
;
;
;==============================================================================
function _xy_to_w, im, p

 if(n_elements(im) EQ 2) then dim = im $
 else dim = size(im, /dim)

 w = long(p[0,*] + p[1,*]*dim[0])

 return, w
end
;==============================================================================
