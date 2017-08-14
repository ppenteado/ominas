;===========================================================================
; glb_intersect_points.pro
;
; Inputs and outputs are in globe body coordinates.
;
; Points that do not intersect are returned as the zero vector.
;
; view_pts and ray_pts must have same number of elements
;
; returned array is (2*nv,3,nt); 1st half is near points, 
;  2nd half is far points.
;
;===========================================================================
pro glb_intersect_points, gbd, view_pts, ray_pts, $
                  discriminant, alpha, beta, gamma, $
                   valid=valid, nosolve=nosolve, near=points_near, far=points_far
@core.include

 nt = n_elements(gbd)
 nv = (size(view_pts))[1]
 n = nv*nt

 MM = make_array(3, val=1d)
 points_near = dblarr(nv,3,nt)
 points_far = dblarr(nv,3,nt)

 valid = discriminant GE 0
 sub = where(valid)

 if(NOT keyword_set(nosolve)) then $
  if(sub[0] NE -1) then $
   begin
    ww = colgen(nv,3,nt, sub)
    sqd = sqrt(discriminant[sub])

    b = beta[sub]
    g = gamma[sub]

    tnear = ((-b - sqd)/g)
    tfar = ((-b + sqd)/g)

    pp = view_pts[ww] + ray_pts[ww]*(tnear#MM)
    qq = view_pts[ww] + ray_pts[ww]*(tfar#MM)

    w = where(tnear LT 0)
    if(w[0] NE -1) then valid[sub[w]] = 0
    w = where(tfar LT 0)
    if(w[0] NE -1) then valid[sub[w]] = 0

    points_near[ww] = pp
    points_far[ww] = qq
   end

end
;===========================================================================
