;===========================================================================
; glb_intersect_discriminant_dd.pro
;
; Inputs are in body coordinates.
;
; Inputs are double preciseion, outputs are double-double precision.
;
;
;===========================================================================
function glb_intersect_discriminant_dd, gbxp, v, r, $
                                          alpha=alpha, beta=beta, gamma=gamma
@nv_lib.include
 nv_notify, gbdp, type = 1
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
 one = reform(make_array(nv,1,nt, val=1d), nv,1,nt, /over)

 w = where(a2 EQ 0)
 if(w[0] NE -1) then a2[w] = 1d-8
 w = where(b2 EQ 0)
 if(w[0] NE -1) then b2[w] = 1d-8
 w = where(c2 EQ 0)
 if(w[0] NE -1) then c2[w] = 1d-8


 ;-------------------------------
 ; split into double-doubles
 ;-------------------------------
 vv0 = dd_split(v[*,0,*]) & vv1 = dd_split(v[*,1,*]) & vv2 = dd_split(v[*,2,*]) 
 rr0 = dd_split(r[*,0,*]) & rr1 = dd_split(r[*,1,*]) & rr2 = dd_split(r[*,2,*]) 
 aa2 = dd_split(a2) & bb2 = dd_split(b2) & cc2 = dd_split(c2)
 one = dd_split(one)


 ;-------------------------------
 ; evaluate discriminant
 ;-------------------------------
 alpha = dd_add( $
           dd_add(dd_div(dd_square(vv0), aa2), $
                    dd_div(dd_square(vv1), bb2)), $
                      dd_div(dd_square(vv2), cc2))
 beta = dd_add( $
          dd_add(dd_div(dd_mult(vv0,rr0), aa2), $
                   dd_div(dd_mult(vv1,rr1), bb2)), $
                     dd_div(dd_mult(vv2,rr2), cc2))
 gamma = dd_add( $
           dd_add(dd_div(dd_square(rr0), aa2), $
                    dd_div(dd_square(rr1), bb2)), $
                      dd_div(dd_square(rr2), cc2))
 discriminant = dd_add(dd_square(beta), dd_mult(gamma, dd_add(one, dd_neg(alpha))))



 alpha = dd_reduce(alpha)
 beta = dd_reduce(beta)
 gamma = dd_reduce(gamma)


 return, discriminant
end
;===========================================================================
