;=============================================================================
; width_2d
;
;=============================================================================
function width_2d, data

 s = size(data)

 nn = 50
 xx = (dindgen(nn)/nn * s[1]) # make_array(nn, val=1d)
 yy = (dindgen(nn)/nn * s[2]) ## make_array(nn, val=1d)

 max = max(data)
 min = min(data)

 dd = (interpolate(data, xx, yy) - min) / (max-min)

 ww = (where(dd EQ 1))[0]
 xmax = ww mod nn
 ymax = long(ww/nn)

 w = where((dd GE 0.4) AND (dd LE 0.6))
 nw = n_elements(w)
 xw = w mod nn
 yw = long(w/nn)


 dx2 = (xw-xmax)^2
 wx = sqrt(total(dx2)/nw) / (nn/s[1])
 dy2 = (yw-ymax)^2
 wy = sqrt(total(dy2)/nw) / (nn/s[2])

 return, [wx, wy]
end
;=============================================================================
