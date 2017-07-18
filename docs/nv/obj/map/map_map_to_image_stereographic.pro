;=============================================================================
;+
; NAME:
;	map_map_to_image_stereographic
;
;
; PURPOSE:
;	Transforms the given map points to map image points using the 
;	stereographic projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image_stereographic(md, map_pts)
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
;	Array (2,nv,nt) of map image points in an stereographic 
;	projection.  This projection results from the projection through
;	a sphere onto a plane, from a point on the surface of the sphere.
;	Scale is true only at the map center.  Areas are distorted, 
;	especially away from the map center.  
;
;	With:
;
;	  a = [size[0],size[1]]/4 * scale,
;
;	and:
;
;	  e = sqrt(1 - (A/(B+C)/2)^2),
;
;	where A, B, and C are the triaxial ellipsoid radii, and:
;
;	  lat0 = lat / units[0]
;
;	  lon0 = lon / units[1]
;
;	  m1 = cos(center[0]]) / sqrt(1 - e^2*sin(center[0])^2)
;
;	  X = 2*atan(tan(pi/4 + lat/2) * $
;	       ((1 - e*sin(lat0))/(1 + e*sin(lat0)))^(e/2)) - pi/2
;
;	  X1 = 2*atan(tan(pi/4 + center[0]/2) * 
;	       ((1 - e*sin(center[0]))/(1 + e*sin(center[0])))^(e/2)) - pi/2d
; 
;	  A = 2*a*scale*m1 / 
;	   ( cos(X1)*(1 + sin(X1)*sin(X) + cos(X1)*cos(X)*cos(lon0 - center[1])) )
;
;	the transformation is:
;
;	  x = A * cos(X)*sin(lon0 - center[1]) + origin[0]
;
;	  y = A * ( cos(X1)*sin(X) - sin(X1)*cos(X)*sin(lon0 - center[1]) ) + 
;	                                                              origin[1]
;
;	See [1], p. 160 for the mathematical derivation.
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
function map_map_to_image_stereographic, md, map_pts
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
 size = double((nmin(_md.size,0))[jj])
 center = (_md.center)[ii]
 origin = (_md.origin)[ii]


 ecc = (map_radii_to_ecc(_md.radii))[jj]


 result = dblarr(2,nv,nt, /nozero)

 lat = map_pts[0,*,*] / units[0,*,*]
 lon = map_pts[1,*,*] / units[1,*,*]

 a = 0.25*size*scale


 m = cos(lat)/sqrt(1d - ecc^2*sin(lat)^2)
 m1 = cos(center[0,*,*])/sqrt(1d - ecc^2*sin(center[0,*,*])^2)
 X = 2d*atan(tan(!dpi/4d + lat/2d) * $
               ((1d - ecc*sin(lat))/(1d + $
                      ecc*sin(lat)))^(ecc/2d)) - !dpi/2d
 X1 = 2d*atan(tan(!dpi/4d + center[0,*,*]/2d) * $
               ((1d - ecc*sin(center[0,*,*]))/(1d + $
                      ecc*sin(center[0,*,*])))^(ecc/2d)) - !dpi/2d
 A = 2d*a*scale*m1 / $
         (cos(X1)*(1d + sin(X1)*sin(X) + $
             cos(X1)*cos(X)*cos(lon-center[1,*,*])))

 result[0,*,*] = A*cos(X)*sin(lon-center[1,*,*]) + origin[0,*,*]

 result[1,*,*] = A*(cos(X1)*sin(X) - $
        sin(X1)*cos(X)*cos(lon-center[1,*,*])) + origin[1,*,*]

 return, result
end
;===========================================================================



