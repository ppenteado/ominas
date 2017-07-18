;=============================================================================
;+
; NAME:
;       image_to_radec
;
;
; PURPOSE:
;       Transforms points in image coordinates to polar ra/dec coords
;	w.r.t the inertial frame.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = image_to_radec(cd, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array of nt camera descriptors.
;
;	p:	Array (2 x nv x nt) of image points.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT:
;	body_pts:	Body coordinates of output points.
;
;
; RETURN:
;       Array (nv x 3 x nt) of radec vectors in the cd BODY frame.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale 3/2002, to replace image_to_ra_dec
;-
;=============================================================================
function image_to_radec, cd, p, body_pts=body_pts

 if(NOT keyword_set(p)) then return, 0

  nt = n_elements(cd)

  body_pts = cam_focal_to_body(cd, $
	       cam_image_to_focal(cd, p))

  r = bod_body_to_inertial(cd, body_pts)

  bd_inertial = make_array(nt, val=bod_inertial())

  return, bod_body_to_radec(bd_inertial, r)
end
;==========================================================================
