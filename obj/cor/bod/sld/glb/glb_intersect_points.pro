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
                  discriminant, alpha, beta, gamma, epsilon=epsilon, $
                  score=score, nosolve=nosolve, back_pts=back_pts
@core.include

 if(NOT keyword_set(epsilon)) then epsilon = 1d 

 nt = n_elements(gbd)
 nv = (size(view_pts))[1]
 n = nv*nt

 MM = make_array(3, val=1d)
 hit_pts = dblarr(nv,3,nt)
 back_pts = dblarr(nv,3,nt)

 ;-----------------------------------------------------
 ; check for hits
 ;-----------------------------------------------------
 sub = where(discriminant GE 0)
 score = bytarr(n)

 ;-----------------------------------------------------
 ; if there are hits, determine coordinates
 ;-----------------------------------------------------
 if(NOT keyword_set(nosolve)) then $
  if(sub[0] NE -1) then $
   begin
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; select only the rays that hit the target
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
    ii = colgen(nv,3,nt, sub)

    sqd = sqrt(discriminant[sub])
    b = beta[sub]
    g = gamma[sub]

    ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; compute hit ranges, 2 per ray
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
    tminus = (-b - sqd)/g
    tplus = (-b + sqd)/g

    ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; compute hit vectors
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
    hit_pts_plus = view_pts[ii] + ray_pts[ii]*(tplus#MM)
    hit_pts_minus = view_pts[ii] + ray_pts[ii]*(tminus#MM)

    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; if t- in front, then t- are hits and t+ are backs
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    w = where(tminus GT epsilon)
    if(w[0] NE -1) then $
     begin
      score[sub[w]] = 2
      hit_pts[ii[w,*]] = hit_pts_minus[w,*]
      back_pts[ii[w,*]] = hit_pts_plus[w,*]
     end

    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; if t- behind, but t+ in front, then t+ are hits; no backs
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    w = where((tminus LE epsilon) AND (tplus GT epsilon))
    if(w[0] NE -1) then $
     begin
      score[sub[w]] = 1
      hit_pts[ii[w,*]] = hit_pts_plus[w,*]
     end
   end

 return, hit_pts
end
;===========================================================================
