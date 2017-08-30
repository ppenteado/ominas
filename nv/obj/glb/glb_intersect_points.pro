;===========================================================================
; glb_intersect_points.pro
;
; Inputs and outputs are in globe body coordinates.
;
; Points that do not intersect are returned as the zero vector.
;
; view_pts and ray_pts must have same number of elements
;
;===========================================================================
function glb_intersect_points, gbd, view_pts, ray_pts, $
                  discriminant, alpha, beta, gamma, $
                   valid=valid, nosolve=nosolve, back_pts=back_pts
@core.include

 nt = n_elements(gbd)
 nv = (size(view_pts))[1]
 n = nv*nt

 MM = make_array(3, val=1d)
 hit_pts = dblarr(nv,3,nt)
 back_pts = dblarr(nv,3,nt)

 valid = discriminant GE 0
 sub = where(valid)

 if(NOT keyword_set(nosolve)) then $
  if(sub[0] NE -1) then $
   begin
    ww = colgen(nv,3,nt, sub)
    sqd = sqrt(discriminant[sub])

    b = beta[sub]
    g = gamma[sub]

    tminus = ((-b - sqd)/g)
    tplus = ((-b + sqd)/g)

    pp = view_pts[ww] + ray_pts[ww]*(tminus#MM)
    qq = view_pts[ww] + ray_pts[ww]*(tplus#MM)

    w = where(tminus LT 0)
    if(w[0] NE -1) then valid[sub[w]] = 0
    w = where(tplus LT 0)
    if(w[0] NE -1) then valid[sub[w]] = 0

    hit_pts[ww] = pp
    back_pts[ww] = qq

   end

 return, hit_pts
end
;===========================================================================




;===========================================================================
; glb_intersect_points.pro
;
; Inputs and outputs are in globe body coordinates.
;
; Points that do not intersect are returned as the zero vector.
;
; view_pts and ray_pts must have same number of elements
;
;===========================================================================
pro __glb_intersect_points, gbd, view_pts, ray_pts, $
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

    tminus = ((-b - sqd)/g)
    tplus = ((-b + sqd)/g)

    pp = view_pts[ww] + ray_pts[ww]*(tminus#MM)
    qq = view_pts[ww] + ray_pts[ww]*(tplus#MM)

    ii = where(sign(tplus) NE sign(tminus), complement=iii)
;stop
;if(ii[0] NE -1) then print, cor_name(gbd)
;if(ii[0] NE -1) then stop

    ;- - - - - - - - - - - - - - - - - - - -
    ; exterior viewers
    ;- - - - - - - - - - - - - - - - - - - -
;    if(ii[0] EQ -1) then $
;     begin
      w = where(tminus LT 0)
      if(w[0] NE -1) then valid[sub[w]] = 0
      w = where(tplus LT 0)
      if(w[0] NE -1) then valid[sub[w]] = 0

      points_near[ww] = pp
      points_far[ww] = qq
;     end 
;    ;- - - - - - - - - - - - - - - - - - - -
;    ; interior viewers
;    ;- - - - - - - - - - - - - - - - - - - -
;    if(iii[0] EQ -1) then $
;     begin
;stop

;      points_near[ww] = qq
;      points_far[ww] = pp
;     end


   end

end
;===========================================================================
