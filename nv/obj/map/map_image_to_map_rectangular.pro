;=============================================================================
;+
; NAME:
;	map_image_to_map_rectangular
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points
;	using a rectangular projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map_rectangular(md, image_pts)
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
;	Array (2,nv,nt) of map coordinate points in a rectangular projection.
;	In this projection, latitudes map linearly to the the y image 
;	direction, and longitudes map linearly to the x image direction.
;
;	With:
; 
;		a = [size[1]/pi, size[0]/2pi] * scale * units, 
;
;	the transformation is:
;
;		lat = (y - origin[1])/a[0] + center[0]
;
;		lon = (x - origin[0])/a[1] + center[1]
;
;	where the latitude equation is solved iteratively.
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
function map_image_to_map_rectangular, md, image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 units = (_md.units)[ii]
 scale = (_md.scale)[jj]
 size = double((_md.size)[ii])
 center = (_md.center)[ii]
 origin = (_md.origin)[ii]

 sz = dblarr(2,nv,nt, /nozero)
 sz[0,*,*] = size[1,*,*]/!dpi
 sz[1,*,*] = size[0,*,*]/2d/!dpi
 sc = [scale,scale]

 a = sz*sc*units

 lon = (image_pts[0,*,*] - origin[0,*,*])/a[1,*,*] + center[1,*,*]

 valid = where((lon-center[1,*,*] GE -!dpi) AND (lon-center[1,*,*] LE !dpi))
 if(valid[0] EQ -1) then return, 0
 nvalid = n_elements(valid)

 r0 = dblarr(1,nv,nt)
 r1 = dblarr(1,nv,nt)
 c0 = (center[0,*,*])[valid]
 o1 = (origin[1,*,*])[valid]

 im1 = (image_pts[1,*,*])[valid]
 a0 = (a[0,*,*])[valid]

 r1[valid] = lon[valid]
 lon = 0

 r0[valid] = (im1 - o1)/a0 + c0

 result = [r0,r1]
 return, result
end
;===========================================================================



;=============================================================================
function _map_image_to_map_rectangular, md, image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 image_pts = reform(image_pts, 2,nv*nt, /over)

 result = dblarr(2,nv*nt)

; The old approach was to force the scaling to be the same in both direcions, 
; regardless of the map dimensions.  The new approach is to scale the full range
; of lat and lon to each dimension, allowing the user to vary it using the
; 'units' field.
; a = min([_md.size[0], 2d*_md.size[1]])/2d/!dpi * _md.scale * _md.units

 a = [_md.size[1]/!dpi, _md.size[0]/2d/!dpi] * _md.scale * _md.units

 lon = (image_pts[0,*] - _md.origin[0])/a[1] + _md.center[1]

 valid = where((lon-_md.center[1] GE -!dpi) AND (lon-_md.center[1] LE !dpi))
 if(valid[0] EQ -1) then $
  begin
   image_pts = reform(image_pts, 2,nv,nt, /over)
   return, 0
  end

 result[1,valid] = lon[valid]
 lon = 0

 result[0,valid] = $
      (image_pts[1,valid] - _md.origin[1])/a[0] + _md.center[0]


 image_pts = reform(image_pts, 2,nv,nt, /over)
 return, result
end
;===========================================================================



