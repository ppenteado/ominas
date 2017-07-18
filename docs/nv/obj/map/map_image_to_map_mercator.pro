;=============================================================================
;+
; NAME:
;	map_image_to_map_mercator
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points
;	using a mercator projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map_mercator(md, image_pts)
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
;	Array (2,nv,nt) of map coordinate points in a mercator projection.
;	This projection results from projecting a sphere onto a cylinder
;	that is tangent at the equator.  The scale is true along the equator
;	only.  Areas are distorted, especially near the poles.  
;
;	With:
; 
;		a = [size[1]/pi, size[0]/2pi] * scale * units,
;
;	and:
;
;		e = sqrt(1 - (A/(B+C)/2)^2),
;
;	where A, B, and C are the triaxial ellipsoid radii, the 
;	transformation is:
;
;		pi/2 - 2*atan(exp(-y/a[0]) * 
;		         ((1 - e*sin(lat))/(1 + e*sin(lat)))^(e/2)) 
;
;		lon = x/a[1] + center[1]
;
;	where the latitude equation is solved iteratively.
;
;	See [1], p. 45 for the mathematical derivation.
;
;	[1] Snyder (1987)
;	    Map projections -- A working manual
;	    USGS professional paper 1395
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


;===========================================================================
; immc_fn
;
;===========================================================================
function immc_fn, x, data

 t = data[0,*]
 e = data[1,*]

 return, 0.5d*!dpi - 2d*atan(t*((1d - e*sin(x))/(1d + e*sin(x)))^(e/2d))
end
;===========================================================================


;===========================================================================
; map_image_to_map_mercator
;
;
;===========================================================================
function map_image_to_map_mercator, md, _image_pts, valid=valid
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
 size = double((_md.size)[ii])
 center = (_md.center)[ii]
 origin = (_md.origin)[ii]

 image_pts = _image_pts - origin

 ecc = (map_radii_to_ecc(_md.radii))[jj]

 sz = dblarr(2,nv,nt, /nozero)
 sz[0,*,*] = size[1,*,*]/!dpi
 sz[1,*,*] = size[0,*,*]/2d/!dpi
 sc = [scale,scale]

 a = sz*sc*units


 lon = image_pts[0,*,*]/a[1,*,*] + center[1,*,*]
 valid = where((lon-center[1,*,*] GE -!dpi) AND (lon-center[1,*,*] LE !dpi))
 if(valid[0] EQ -1) then return, 0
 nvalid = n_elements(valid)

 r0 = dblarr(1,nv,nt)
 r1 = dblarr(1,nv,nt)

 im1 = (image_pts[1,*,*])[valid]
 a0 = (a[0,*,*])[valid]

 r1[valid] = lon[valid]
 lon = 0

 t = exp(-im1/a0)
 data = dblarr(2,nvalid)
 data[0,*] = t
 data[1,*] = ecc

 r0[valid] = 0.5d*!dpi - 2d*atan(t)
 r0[valid] = trans_solve('immc_fn', r0[valid], data)

 result = [r0,r1]
 return, result
end
;===========================================================================



;===========================================================================
function _map_image_to_map_mercator, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 ecc = map_radii_to_ecc(_md.radii)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 _image_pts = reform(_image_pts, 2,nv*nt, /over)

 result = dblarr(2,nv*nt)


 image_pts = dblarr(2,nv*nt, /nozero)
 image_pts[0,*] = _image_pts[0,*] - _md.origin[0]
 image_pts[1,*] = _image_pts[1,*] - _md.origin[1]

 
 a = [_md.size[1]/!dpi, _md.size[0]/2d/!dpi] * _md.scale * _md.units

 lon = image_pts[0,*]/a[1] + _md.center[1]
 valid = where((lon-_md.center[1] GE -!dpi) AND (lon-_md.center[1] LE !dpi))
 if(valid[0] EQ -1) then $
  begin
   _image_pts = reform(_image_pts, 2,nv,nt, /over)
   return, 0
  end

 result[1,valid] = lon[valid]
 lon = 0

 t = exp(-image_pts[1,valid]/a[0])
 data = dblarr(2,n_elements(valid))
 data[0,*] = t
 data[1,*] = ecc

 result[0,valid] = 0.5d*!dpi - 2d*atan(t)
 result[0,valid] = trans_solve('immc_fn', result[0,valid], data)

 result = reform(result, 2,nv,nt, /over)


 _image_pts = reform(_image_pts, 2,nv,nt, /over)
 return, result
end
;===========================================================================



