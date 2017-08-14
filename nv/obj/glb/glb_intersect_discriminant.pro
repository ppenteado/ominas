;===========================================================================
; glb_intersect_discriminant.pro
;
; Inputs are in body coordinates;
;
; view_pts is viewer location, ray_pts is direction
;
;
;===========================================================================
function glb_intersect_discriminant, gbd, view_pts, ray_pts, noevent=noevent, $
                                          alpha=alpha, beta=beta, gamma=gamma
@core.include
 nv_notify, gbd, type = 1, noevent=noevent
 
 _gbd = cor_dereference(gbd)

 nt = n_elements(_gbd)
 nv = (size(view_pts))[1]
 MM = make_array(nv,val=1)

 ;----------------------------
 ; compute the discriminant
 ;----------------------------
 a2 = reform([_gbd.radii[0]^2]##MM, nv,1,nt, /over)
 b2 = reform([_gbd.radii[1]^2]##MM, nv,1,nt, /over)
 c2 = reform([_gbd.radii[2]^2]##MM, nv,1,nt, /over)

; w = where(a2 EQ 0)
; if(w[0] NE -1) then a2[w] = 1d-8
; w = where(b2 EQ 0)
; if(w[0] NE -1) then b2[w] = 1d-8
; w = where(c2 EQ 0)
; if(w[0] NE -1) then c2[w] = 1d-8

 alpha = view_pts[*,0,*]^2/a2 + view_pts[*,1,*]^2/b2 + view_pts[*,2,*]^2/c2
 beta = view_pts[*,0,*]*ray_pts[*,0,*]/a2 + view_pts[*,1,*]*ray_pts[*,1,*]/b2 + view_pts[*,2,*]*ray_pts[*,2,*]/c2
 gamma = ray_pts[*,0,*]^2/a2 + ray_pts[*,1,*]^2/b2 + ray_pts[*,2,*]^2/c2

 discriminant = beta^2 + gamma*(1d - alpha)


 return, discriminant
end
;===========================================================================
