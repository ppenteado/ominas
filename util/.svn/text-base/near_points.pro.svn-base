;=============================================================================
; near_points
;
;  Returns indices of pts within rad of xpts.
;
;=============================================================================
function near_points, pts, xpts, xrad

 npts = n_elements(pts)/2
 nxpts = n_elements(xpts)/2

 dxy = points_dxy(pts, xpts)			; 2 x npts x nxpts
 d2 = dxy[0,*,*]^2 + dxy[1,*,*]^2		; 1 x npts x nxpts
 xrad2 = xrad^2

 w = where(d2 LT xrad2)
 if(w[0] EQ -1) then return, -1
 mark = bytarr(npts, nxpts)
 mark[w] = 1
 mm = total(mark, 1)

 return, where(mm GT 0)
end
;=============================================================================



