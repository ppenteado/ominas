;=============================================================================
; flatten_bg
;
;=============================================================================
function flatten_bg, data

 h = histogram(data)
 h[0] = 0
 h = smooth(h,15)
 hmax = max(h)

 w = (where(h EQ hmax))[0]
 
 ww = min(where(h GE (hmax/4)))

 width = 2d*abs(w[0] - ww[0])

 threshold = w[0]+width

 return, data > threshold
end
;=============================================================================
