;=============================================================================
;+
; NAME:
;	map_map_to_image_rectangular
;
;
; PURPOSE:
;	Transforms the given map points to map image points using a
;	rectangular projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image_rectangular(md, map_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	md	 	Array (nt) of MAP descriptors.
;
;	map_pts:	Array (2,nv,nt) of map points.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nowrap:	If set, then points that lie outide the map will not be
;		around to the other side.
;
;  OUTPUT: 
;	valid:	Indices of all input points that correspond to valid
;		output image points.  If not se then all points are
;		valid.
;
;
; RETURN:
;	Array (2,nv,nt) of map image points in a rectangular projection.
;	In this projection, latitudes map linearly to the the y image 
;	direction, and longitudes map linearly to the x image direction.
;
;	With:
; 
;		a = [size[1]/pi, size[0]/2pi] * scale * units, 
;
;	the transformation is:
;
;		x = a[1] * (lon - center[1]) + origin[0]
;
;		y = a[0] * (lat - center[0]) + origin[1]

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
function map_map_to_image_equatorial_ring, md, map_pts
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(map_pts)
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

 result = dblarr(2,nv,nt, /nozero)

 result[1,*,*] = origin[1,*,*] + a[0,*,*]*(map_pts[0,*,*]-center[0,*,*])
 result[0,*,*] = origin[0,*,*] + a[1,*,*]*(map_pts[1,*,*]-center[1,*,*])

 return, result
end
;===========================================================================



;=============================================================================
function _map_map_to_image_rectangular, md, map_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

; The old approach was to force the scaling to be the same in both direcions, 
; regardless of the map dimensions.  The new approach is to scale the full range
; of lat and lon to each dimension, allowing the user to vary it using the
; 'units' field.
; a = min([_md.size[0], 2d*_md.size[1]])/2d/!dpi * _md.scale * _md.units	; pix/rad

 a = [_md.size[1]/!dpi, _md.size[0]/2d/!dpi] * _md.scale * _md.units

 result = dblarr(2,nv,nt, /nozero)

 result[1,*,*] = _md.origin[1] + a[0]*(map_pts[0,*,*]-_md.center[0])
 result[0,*,*] = _md.origin[0] + a[1]*(map_pts[1,*,*]-_md.center[1])

 valid = internal_points(result, 0, _md.size[0]-1, 0, _md.size[1]-1)
 return, result
end
;===========================================================================



