;=============================================================================
;++
; NAME:
;	map_image_to_map_orthographic_disk
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points
;	using an orthographic projection for a disk.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map_orthographic_disk(md, image_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	md	 	Array (nt) of MAP descriptors.
;
;	image_pts:	Array (2,nv,nt) of map image points.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	valid:	Indices of all input points that correspond to valid
;		output map points.  If not set then all points are
;		valid.
;
;
; RETURN:
;	Array (2,nv,nt) of map coordinate points in an orthographic disk 
;	projection.  This projection portrays a disk as seen from a
;	great distance.  Scale is uniform, but it is only true if the
;	projection is polar.  Likewise, areas are distorted for non-polar
;	projections.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function map_image_to_map_orthographic_disk, md, _image_pts, valid=valid
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

 R = 0.5*size*scale


 plane_pts = image_pts
 plane_pts[1,*,*] = plane_pts[1,*,*] / sin(center[0,*,*])

 rho = sqrt(plane_pts[0,*,*]^2 + plane_pts[1,*,*]^2)
 valid = where(rho LT R)
 if(valid[0] EQ -1) then return, 0

 r0 = dblarr(1,nv,nt)
 r1 = dblarr(1,nv,nt)

 rho = rho[valid]
 R = R[valid]

 c1 = (center[1,*,*])[valid]
 pp0 = (plane_pts[0,*,*])[valid]
 u0 = (units[0,*,*])[valid]
 u1 = (units[1,*,*])[valid]

 r0[valid] = (rho/R * 2d*!dpi) / u0
 r1[valid] = (atan(plane_pts[1,valid], pp0) + c1) / u1

 result = [r0,r1]
 return, result
end
;===========================================================================



;=============================================================================
function _map_image_to_map_orthographic_disk, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 _image_pts = reform(_image_pts, 2,nv*nt, /over)

 result = dblarr(2,nv*nt)

 R = 0.5*min(_md.size)*_md.scale

 image_pts = dblarr(2,nv*nt, /nozero)
 image_pts[0,*] = _image_pts[0,*] - _md.origin[0]
 image_pts[1,*] = _image_pts[1,*] - _md.origin[1]

 plane_pts = image_pts
 plane_pts[1,*] = plane_pts[1,*] / sin(_md.center[0])

 rho = sqrt(plane_pts[0,*]^2 + plane_pts[1,*]^2)
 valid = where(rho LT R)
 if(valid[0] EQ -1) then $
  begin
   _image_pts = reform(_image_pts, 2,nv,nt, /over)
   return, 0
  end

 result[0,valid] = (rho[valid]/R * 2d*!dpi)  / _md.units[0]
 result[1,valid] = (atan(plane_pts[1,valid], plane_pts[0,valid]) + $
                                               _md.center[1]) / _md.units[1]


 result = reform(result, 2,nv,nt, /over)


 _image_pts = reform(_image_pts, 2,nv,nt, /over)
 return, result
end
;===========================================================================



