;===========================================================================
; mimw_fn
;
;===========================================================================
function mimw_fn, x, data

 lat = data[0,*,*]

 return, 0.5d*(!dpi*sin(lat) - sin(2d*x))
end
;===========================================================================


;===========================================================================
; map_map_to_image_mollweide
;
; Forward Mollweide projection for the sphere.  See [1], p.251.
;
; References:
;	[1] Snyder (1987)
;	    Map projections -- A working manual
;	    USGS professional paper 1395
;
;===========================================================================
function map_map_to_image_mollweide, mdp, map_pts
 md = nv_dereference(mdp)

 nt = n_elements(md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 units = (md.units)[ii]
 scale = (md.scale)[jj]
 size = double((nmin(md.size,0))[jj])
 center = (md.center)[ii]
 origin = (md.origin)[ii]


 lat = map_pts[0,*,*] / units[0,*,*]
 lon = map_pts[1,*,*] / units[1,*,*]

 R = 0.25*size*scale

 theta = lat
 data = dblarr(1,nv,nt)
 data[0,*,*] = lat
 theta = trans_solve('mimw_fn', theta, data, eps=1d-4)

 result = dblarr(2,nv,nt, /nozero)
 result[0,*,*] = $
    (sqrt(8d)/!dpi)*R*(lon-center[1,*,*])*cos(theta) + origin[0,*,*]

 result[1,*,*] = sqrt(2)*R*sin(theta) + origin[1,*,*]

 return, result
end
;===========================================================================



;===========================================================================
; map_map_to_image_mollweide
;
; Forward Mollweide projection for the sphere.  See [1], p.251.
;
; References:
;	[1] Snyder (1987)
;	    Map projections -- A working manual
;	    USGS professional paper 1395
;
;===========================================================================
function _map_map_to_image_mollweide, mdp, map_pts, valid=valid
 md = nv_dereference(mdp)

 nt = n_elements(md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)


 lat = map_pts[0,*,*] / md.units[0]
 lon = map_pts[1,*,*] / md.units[1]

 R = 0.25*min(md.size)*md.scale

 theta = lat
 data = dblarr(1,nv)
 data[0,*] = lat
 theta = trans_solve('mimw_fn', theta, data, eps=1d-4)

 result[0,*,*] = $
    (sqrt(8d)/!dpi)*R*(lon-md.center[1])*cos(theta) + md.origin[0]

 result[1,*,*] = sqrt(2)*R*sin(theta) + md.origin[1]

 valid = lindgen(nv*nt)
 return, result
end
;===========================================================================



