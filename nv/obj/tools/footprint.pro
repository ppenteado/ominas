;=============================================================================
;+
; NAME:
;       footprint
;
;
; PURPOSE:
;	Computes the footprint of a camera on a given body.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       surface_pts = footprint(cd, bx)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:		Camera descripor.
;
;	bx:		Body descriptor; globe or disk.
;
;  OUTPUT:  NONE
;
;
; KEYWORDS:
;  INPUT: 
;	corners:	Array(2,2) giving corers of image region to consider.
;
;	slop:		Number of pixels by which to expand the image in each
;			direction.
;
;	image_pts:	Array (2,np) of points along the edge of the image.
;
;	sample:		Sampling rate; default is 1 pixel.
;
;
;  OUTPUT: 
;	image_pts:	Footprint points in the image frame.
;
;	body_pts:	Footprint points in the body frame.
;
;       valid:  	Indices of valid output points.
;
; RETURN: 
;	Array nv,3,nt of surface points.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale		5/2014
;
;-
;=============================================================================
function footprint, cd, bx, slop=slop, corners=corners, $
                   image_pts=image_pts, body_pts=body_pts, valid=valid, sample=sample

 status = -1

 ;-----------------------------------
 ; compute image border points
 ;-----------------------------------
 if(NOT keyword_set(image_pts)) then $
              image_pts = get_image_border_pts(cd, corners=corners, sample=sample)
 np = n_elements(image_pts)/2


 ;--------------------------------------------------
 ; get body edge points
 ;--------------------------------------------------
; limb_pts_body = $
;     glb_get_limb_points(bx, bod_inertial_to_body_pos(bx, bod_pos(cd)))
;;; edge_pts_body = get_edge_points(cd=cd, bx=bx)


 ;-----------------------------------
 ; compute footprint
 ;-----------------------------------
 surface_pts = image_to_surface(cd, bx, image_pts, body_pts=body_pts, valid=valid)

 nsurf = n_elements(surface_pts)/3
 if(nsurf GT np) then $
  begin
   surface_pts = surface_pts[0:np-1,*]
   body_pts = body_pts[0:np-1,*]
  end

;;; test whether any limb points fall inside footprint; in image space

 return, surface_pts
end
;================================================================================
