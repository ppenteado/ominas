;=============================================================================
;+
; NAME:
;	map_map_to_image_rectangular_disk
;
;
; PURPOSE:
;	Transforms the given map points to map image points using a
;	rectangular projection on a disk.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image_rectangular_disk(md, map_pts)
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
; 	Written by:	Spitale, 6/2016
;	
;-
;=============================================================================
function map_map_to_image_rectangular_disk, md, map_pts
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

 ecc = map_radii_to_ecc(_md.radii)
 dr0 = map_pts[0,*,*]*ecc[0]*cos(map_pts[1,*,*])
 map_pts[0,*,*] = map_pts[0,*,*] + dr0

 result = dblarr(2,nv,nt, /nozero)
 result[1,*,*] = origin[1,*,*] + a[0,*,*]*(map_pts[0,*,*]-center[0,*,*])
 result[0,*,*] = origin[0,*,*] + a[1,*,*]*(map_pts[1,*,*]-center[1,*,*])

 return, result
end
;===========================================================================
