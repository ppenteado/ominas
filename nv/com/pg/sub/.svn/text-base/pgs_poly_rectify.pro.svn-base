;===========================================================================
; pgs_poly_rectify
;
;===========================================================================
pro pgs_poly_rectify, ps

 pgs_points, ps, p=p, v=v, $
                 flags=flags, $
                 data=data, tags=tags, $
                 uname=uname, udata=udata, assoc_idp=assoc_idp

 pp = poly_rectify(p, sub=ii)
 vv = 0
 if(keyword_set(v)) then vv = v[ii,*]
 ff = flags[ii]

 ps = pgs_set_points(ps, p=pp, v=vv, flags=ff)

end
;===========================================================================
