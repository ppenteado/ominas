;===========================================================================
; map_image_to_map_mollweide
;
; Inverse Mollweide projection for the sphere.  See [1], p.252.
;
; References:
;	[1] Snyder (1987)
;	    Map projections -- A working manual
;	    USGS professional paper 1395
;
;===========================================================================
function map_image_to_map_mollweide, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 units = (_md.units)[ii]
 scale = (_md.scale)[jj]
 size = double((nmin(_md.size,0))[jj])
 center = (_md.center)[ii]
 origin = (_md.origin)[ii]

 image_pts = _image_pts - origin

 R = 0.25*size*scale

 valid = where(image_pts[1,*,*] LT (sqrt(2d)*R))
 if(valid[0] EQ -1) then return, 0

 r0 = dblarr(1,nv,nt)
 r1 = dblarr(1,nv,nt)

 c1 = (center[1,*,*])[valid]
 im0 = (image_pts[0,*,*])[valid]
 im1 = (image_pts[1,*,*])[valid]
 u0 = (units[0,*,*])[valid]
 u1 = (units[1,*,*])[valid]

 theta = asin(im1/(sqrt(2d)*R))

 r0[valid] = asin((2d*theta + sin(2d*theta))/!dpi) / u0
 r1[valid] = (!dpi*im0/(sqrt(8d)*R*cos(theta)) + c1) / u1

 result = [r0,r1]
 return, result
end
;===========================================================================



;===========================================================================
function _map_image_to_map_mollweide, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 _image_pts = reform(_image_pts, 2,nv*nt, /over)

 result = dblarr(2,nv*nt)

 image_pts = dblarr(2,nv*nt, /nozero)
 image_pts[0,*] = _image_pts[0,*] - _md.origin[0]
 image_pts[1,*] = _image_pts[1,*] - _md.origin[1]


 R = 0.25*min(_md.size)*_md.scale

 valid = where(image_pts[1,*] LT (sqrt(2d)*R))
 if(valid[0] EQ -1) then $
  begin
   _image_pts = reform(_image_pts, 2,nv,nt, /over)
   return, 0
  end

 image_pts = image_pts[*,valid]

 theta = asin(image_pts[1,*]/(sqrt(2d)*R))

 result[0,valid] = asin((2d*theta + sin(2d*theta))/!dpi) / _md.units[0]
 result[1,valid] = $
   (!dpi*image_pts[0,*]/(sqrt(8d)*R*cos(theta)) + _md.center[1]) / _md.units[1]

 result = reform(result, 2,nv,nt, /over)


 _image_pts = reform(_image_pts, 2,nv,nt, /over)
 return, result
end
;===========================================================================



