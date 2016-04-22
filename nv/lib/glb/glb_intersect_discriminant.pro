;===========================================================================
; glb_intersect_discriminant.pro
;
; Inputs are in body coordinates
;
;
;===========================================================================
function glb_intersect_discriminant, gbxp, v, r, noevent=noevent, $
                                          alpha=alpha, beta=beta, gamma=gamma
@nv_lib.include
 nv_notify, gbdp, type = 1, noevent=noevent
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 nt = n_elements(gbd)
 nv = (size(v))[1]
 MM = make_array(nv,val=1)

 ;----------------------------
 ; compute the discriminant
 ;----------------------------
 a2 = reform([gbd.radii[0]^2]##MM, nv,1,nt, /over)
 b2 = reform([gbd.radii[1]^2]##MM, nv,1,nt, /over)
 c2 = reform([gbd.radii[2]^2]##MM, nv,1,nt, /over)

 w = where(a2 EQ 0)
 if(w[0] NE -1) then a2[w] = 1d-8
 w = where(b2 EQ 0)
 if(w[0] NE -1) then b2[w] = 1d-8
 w = where(c2 EQ 0)
 if(w[0] NE -1) then c2[w] = 1d-8

 alpha = v[*,0,*]^2/a2 + v[*,1,*]^2/b2 + v[*,2,*]^2/c2
 beta = v[*,0,*]*r[*,0,*]/a2 + v[*,1,*]*r[*,1,*]/b2 + v[*,2,*]*r[*,2,*]/c2
 gamma = r[*,0,*]^2/a2 + r[*,1,*]^2/b2 + r[*,2,*]^2/c2
 discriminant = beta^2 + gamma*(1d - alpha)


 return, discriminant
end
;===========================================================================
