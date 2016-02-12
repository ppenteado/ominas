;=============================================================================
;+
; NAME:
;	map_map_to_image_orthographic
;
;
; PURPOSE:
;	Transforms the given map points to map image points using the 
;	orthographic projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image_orthographic(md, map_pts)
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
;	Array (2,nv,nt) of map image points in an orthographic 
;	projection.  This projection portrays a planet as seen from a
;	great distance.  Scale is true only at the map center.  Areas 
;	are distorted, especially away from the map center.  
;
;	With:
; 
;	  R = min(size[0],size[1])/2 * scale
;
;	the transformation is:
;
;	  x = R * cos(lat/units[0]) * sin(lon/units[1] 0 center[1]) + origin[0]
;
;	  y = R * 
;	     ( cos(center[0])*sin(lat/units[0]) - 
;	        sin(center[0])*cos(lat/units[0])*cos(lon - center[1]) ) + 
;	                                                            origin[1]
;
;	See [1], p. 149 for the mathematical derivation.
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
function map_map_to_image_orthographic, mdp, map_pts
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


 R = 0.5*size*scale

 lat = map_pts[0,*,*] / units[0,*,*]
 lon = map_pts[1,*,*] / units[1,*,*]

 result = dblarr(2,nv,nt, /nozero)
 result[0,*,*] = R*cos(lat)*sin(lon-center[1,*,*]) + origin[0,*,*]

 result[1,*,*] = R*(cos(center[0,*,*])*sin(lat) - $
          sin(center[0,*,*])*cos(lat)*cos(lon-center[1,*,*])) + origin[1,*,*]

 return, result
end
;===========================================================================



