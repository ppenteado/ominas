;===========================================================================
; glb_intersect_points.pro
;
; Inputs and outputs are in globe body coordinates.
;
; Points that do not intersect are returned as the zero vector.
;
; v and r must have same number of elements
;
; returned array is (2*nv,3,nt); 1st half is near points, 
;  2nd half is far points.
;
;===========================================================================
function glb_intersect_points, gbd, v, r, discriminant, alpha, beta, gamma, $
                       valid=valid, nosolve=nosolve
@core.include

 nt = n_elements(gbd)
 nv = (size(v))[1]
 n = nv*nt


 points = dblarr(2*nv,3,nt)

;;;; 'valid' does not come out right here...
 valid = discriminant GE 0
 sub = where(valid)

 if(NOT keyword_set(nosolve)) then $
  if(sub[0] NE -1) then $
   begin
    ww = colgen(nv,3,nt, sub)
    sqd = sqrt(discriminant[sub])

    b = beta[sub]
    g = gamma[sub]

    tclose = ((-b - sqd)/g)
    tfar = ((-b + sqd)/g)
    w = where(tclose LT 0)

    pp = v[ww] + r[ww]*(tclose#make_array(3, val=1d))
    qq = v[ww] + r[ww]*(tfar#make_array(3, val=1d))

    if(w[0] NE -1) then valid[ww[w]] = 0

    points_close = dblarr(nv,3,nt)
    points_far = dblarr(nv,3,nt)
    points_close[ww] = pp
    points_far[ww] = qq

    points[0:nv-1,*,*] = points_close
    points[nv:*,*,*] = points_far
   end


 return, points
end
;===========================================================================
