;=============================================================================
;+
; NAME:
;	map_map_to_image_mercator
;
;
; PURPOSE:
;	Transforms the given map points to map image points using the
;	mercator projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image_mercator(md, map_pts)
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
;  INPUT: NONE
;
;  OUTPUT: 
;	valid:	Indices of all input points that correspond to valid
;		output image points.  If not se then all points are
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
;		x = a[1] * (lon - center[1]) + origin[0]
;
;		y = a[0] * log( tan(pi/4 + lat/2) * 
;		  ( (1 - e*sin(lat))/(1 + e*sin(lat)) )^(e/2) ) + origin[1]
;
;
;	See [1], p. 44 for the mathematical derivation.
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
function map_map_to_image_mercator, mdp, map_pts
 md = nv_dereference(mdp)

 nt = n_elements(md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 units = (md.units)[ii]
 scale = (md.scale)[jj]
 size = double((md.size)[ii])
 center = (md.center)[ii]
 origin = (md.origin)[ii]

 ecc = (map_radii_to_ecc(md.radii))[jj]


 sz = dblarr(2,nv,nt, /nozero)
 sz[0,*,*] = size[1,*,*]/!dpi
 sz[1,*,*] = size[0,*,*]/2d/!dpi
 sc = [scale,scale]

 a = sz*sc*units

 result = dblarr(2,nv,nt, /nozero)
 result[0,*,*] = a[1,*,*] * (map_pts[1,*,*]-center[1,*,*]) + origin[0,*,*]

 result[1,*,*] = $
         a[0,*,*] * alog( tan(0.25d*!dpi + 0.5d*map_pts[0,*,*]) * $
                    ((1d - ecc*sin(map_pts[0,*,*])) / $ 
                        (1d + ecc*sin(map_pts[0,*,*])))^(0.5d*ecc) ) + $
                                                                  origin[1,*,*]

 return, result
end
;===========================================================================



;=============================================================================
function _map_map_to_image_mercator, mdp, map_pts, valid=valid
 md = nv_dereference(mdp)


 nt = n_elements(md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)
 ecc = make_array(nv, nt, val=map_radii_to_ecc(md.radii))



 a = [md.size[1]/!dpi, md.size[0]/2d/!dpi] * md.scale * md.units


 result[0,*,*] = a[1] * (map_pts[1,*,*]-md.center[1]) + md.origin[0]

 result[1,*,*] = $
         a[0] * alog( tan(0.25d*!dpi + 0.5d*map_pts[0,*,*]) * $
                    ((1d - ecc*sin(map_pts[0,*,*])) / $ 
                        (1d + ecc*sin(map_pts[0,*,*])))^(0.5d*ecc) ) + $
                                                                    md.origin[1]



 valid = internal_points(result, 0, md.size[0]-1, 0, md.size[1]-1)
 return, result
end
;===========================================================================



