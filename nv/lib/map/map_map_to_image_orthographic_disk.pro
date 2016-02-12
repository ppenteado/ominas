;=============================================================================
;++
; NAME:
;	map_map_to_image_orthographic_disk
;
;
; PURPOSE:
;	Transforms the given map points to map image points using the 
;	orthographic projection on a disk.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image_orthographic_disk(md, map_pts)
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
;	Array (2,nv,nt) of map image points in an orthographic disk 
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
;	
;-
;=============================================================================
function map_map_to_image_orthographic_disk, mdp, map_pts
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

 rad = map_pts[0,*,*] * units[0,*,*]
 lon = (map_pts[1,*,*] - center[1,*,*]) * units[1,*,*]

 rr = rad / 2d/!dpi * R

 result = dblarr(2,nv,nt, /nozero)
 result[0,*,*] = rr*cos(lon)
 result[1,*,*] = rr*sin(lon)

 result[0,*,*] = result[0,*,*] + origin[0,*,*]
 result[1,*,*] = result[1,*,*]*sin(center[0,*,*]) + origin[1,*,*]	;;;;

 return, result
end
;===========================================================================



;=============================================================================
function _map_map_to_image_orthographic_disk, mdp, map_pts, valid=valid
 md = nv_dereference(mdp)

 nt = n_elements(md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)

 R = 0.5*min(md.size)*md.scale

 rad = map_pts[0,*,*] * md.units[0]
 lon = (map_pts[1,*,*] - md.center[1]) * md.units[1]

 rr = rad / 2d/!dpi * R

 result[0,*,*] = rr*cos(lon)
 result[1,*,*] = rr*sin(lon)

 result[0,*,*] = result[0,*,*] + md.origin[0]
 result[1,*,*] = result[1,*,*]*sin(md.center[0]) + md.origin[1]

 valid = lindgen(nv*nt)
 return, result
end
;===========================================================================



