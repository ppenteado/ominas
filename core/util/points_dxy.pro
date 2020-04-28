;==============================================================================
; points_dxy
;
;==============================================================================
function points_dxy, p1, p2, x1=x1, y1=y1, x2=x2, y2=y2

 n1 = n_elements(p1)/2
 n2 = n_elements(p2)/2
 n = n1*n2

 x1 = tr(p1[0,*])
 y1 = tr(p1[1,*])
 x2 = tr(p2[0,*])
 y2 = tr(p2[1,*])

 ii = lindgen(n1)#make_array(n2,val=1)
 jj = lindgen(n2)##make_array(n1,val=1)

 dxx = reform(x1[ii] - x2[jj], n, /over)
 dyy = reform(y1[ii] - y2[jj], n, /over)
 dxx = x1[ii] - x2[jj]
 dyy = y1[ii] - y2[jj]

 dxy = dblarr(2,n1,n2)
 dxy[0,*,*] = dxx
 dxy[1,*,*] = dyy

 return, dxy
end
;==============================================================================
