;=============================================================================
;+
; NAME:
;       radec_to_image
;
;
; PURPOSE:
;       Transforms points in polar ra/dec coords w.r.t the inertial frame
;	to image coords.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = radec_to_image(cd, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array of nt camera descriptors.
;
;	p:	Array (nv x 3 x nt) of radec points
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
;       Array (2 x nv x nt) of image points.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale 3/2002
;-
;=============================================================================
function radec_to_image, cd, p, body_pts=body_pts

  nt = n_elements(cd)

  cam_bd = class_extract(cd, 'BODY')

  p_inertial = bod_radec_to_body(bod_inertial(nt), p)

  body_pts = bod_inertial_to_body(cam_bd, p_inertial)

  return, $
     cam_focal_to_image(cd, $
        cam_body_to_focal(cd, body_pts))
end
;==========================================================================
