;=============================================================================
;+
; NAME:
;	map_image_to_map_oblique_disk
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points
;	using an oblique projection for a disk.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map_oblique_disk(md, image_pts)
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
;	Array (2,nv,nt) of map coordinate points in an oblique disk 
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
function map_image_to_map_oblique_disk, mdp, _image_pts, valid=valid
@nv_lib.include
 md = nv_dereference(mdp)

 nt = n_elements(md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 _image_pts = reform(_image_pts, 2,nv*nt, /over)

 result = dblarr(2,nv*nt)

 R = 0.5*min(md.size)*md.scale

 image_pts = dblarr(2,nv*nt, /nozero)
 image_pts[0,*] = _image_pts[0,*] - md.origin[0]
 image_pts[1,*] = _image_pts[1,*] - md.origin[1]

 plane_pts = image_pts
 plane_pts[1,*] = plane_pts[1,*] / sin(md.center[0])

 rho = sqrt(plane_pts[0,*]^2 + plane_pts[1,*]^2)
 valid = where(rho LT R)
 if(valid[0] EQ -1) then $
  begin
   _image_pts = reform(_image_pts, 2,nv,nt, /over)
   return, 0
  end

 result[0,valid] = (rho[valid]/R * 2d*!dpi)  / md.units[0]
 result[1,valid] = (atan(plane_pts[1,valid], plane_pts[0,valid]) + $
                                               md.center[1]) / md.units[1]


 result = reform(result, 2,nv,nt, /over)


 _image_pts = reform(_image_pts, 2,nv,nt, /over)
 return, result
end
;===========================================================================



