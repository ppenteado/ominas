;=============================================================================
;+
; NAME:
;	map_image_to_map_stereographic
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points
;	using an stereographic projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map_stereographic(md, image_pts)
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
;	Array (2,nv,nt) of map coordinate points in an stereographic 
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
;	  m1 = cos(center[0]]) / sqrt(1 - e^2*sin(center[0])^2)
;
;	  rho = sqrt(x^2 + y^2)
;
;	  X1 = 2*atan(tan(pi/4 + center[0]/2) * 
;	       ((1 - e*sin(center[0]))/(1 + e*sin(center[0])))^(e/2)) - pi/2d
; 
;	  ce = 2*atan(rho*cos(X1), 2*a*scale*m1)
;
;	  X = asin(cos(ce)*sin(X1) + y*sin(ce)*cos(X1)/rho)
;
;	the transformation is:
;
;	  2*atan(tan(pi/4 + X/2) * $
;	              ((1 + e*sin(lat))/(1 - e*sin(lat)))^(e/2) ) - pi/2
;
;	  lon = center[1] + atan( x*sin(ce) / 
;	          rho*cos(X1)*cos(ce) - y*sin(X1)*sin(ce) ) / units[1]
;
;	where the latitude equation is solved iteratively.
;
;	See [1], p. 161 for the mathematical derivation.
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
;	
;-
;=============================================================================


;===========================================================================
; imst_fn
;
;===========================================================================
function imst_fn, x, data

; X = data[0,*]
; e = data[1,*]
 X = data[0,*,*]
 e = data[1,*,*]

 return, 2d*atan(tan(!dpi/4d + X/2d) * $
                ((1d + e*sin(x))/(1d - e*sin(x)))^(e/2d) ) - !dpi/2d
end
;===========================================================================


;===========================================================================
; map_image_to_map_stereographic
;
; Inverse stereographic projection for the oblate spheroid.  See [1], p.161.
;
; References:
;	[1] Snyder (1987)
;	    Map projections -- A working manual
;	    USGS professional paper 1395
;
;===========================================================================
function map_image_to_map_stereographic, md, _image_pts, valid=valid
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

 ecc = (map_radii_to_ecc(_md.radii))[jj]


 image_pts = _image_pts - origin


 a = 0.25*size*scale

 m1 = cos(center[0,*,*])/sqrt(1d - ecc^2*sin(center[0,*,*])^2)
 rho = sqrt(image_pts[0,*,*]^2 + image_pts[1,*,*]^2)
 X1 = 2d*atan(tan(!dpi/4d + center[0,*,*]/2d) * $
               ((1d - ecc*sin(center[0,*,*]))/(1d + $
                      ecc*sin(center[0,*,*])))^(ecc/2d)) - !dpi/2d
 ce = 2d*atan(rho*cos(X1), 2d*a*scale*m1)
 X = asin(cos(ce)*sin(X1) + image_pts[1,*,*]*sin(ce)*cos(X1)/rho) 

 data = dblarr(2,nv,nt)
 data[0,*,*] = X
 data[1,*,*] = ecc

 result = dblarr(2,nv,nt, /nozero)
 result[0,*,*] = X
 result[0,*,*] = trans_solve('imst_fn', result[0,*,*], data) / units[0,*,*]

 result[1,*,*] = center[1,*,*] + atan(image_pts[0,*,*]*sin(ce), $
         rho*cos(X1)*cos(ce) - image_pts[1,*,*]*sin(X1)*sin(ce)) / units[1,*,*]

 valid = lindgen(nv*nt)

 return, result
end
;===========================================================================


