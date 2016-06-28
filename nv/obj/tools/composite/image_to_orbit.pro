;=============================================================================
;+
; NAME:
;       image_to_orbit
;
;
; PURPOSE:
;	Computes orbital elements corresponding to image points, assuming
;	a circular orbit.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       dkd = image_to_orbit(cd, gbx, dkx, image_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array of nt camera or map descriptors.
;
;	gbx:	Array of nt globe descriptor describing the primary body.
;
;	dkx:	Array of nt disk descriptor describing the assumed orbit plane.
;
;	image_pts:	Array (1,3,nt) of image points.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT: NONE
;
;
; RETURN: 
;	Array of nt disk descriptors reresenting the computed orbits.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function image_to_orbit, _cd, _gbx, dkx0, image_pts, GG=GG

 nt = n_elements(dkx0)
 cd = make_array(nt, val=_cd)
 gbx = make_array(nt, val=_gbx)

 disk_pts = image_to_disk(cd, dkx0, image_pts, body=body_pts)
 inertial_pts = bod_body_to_inertial_pos(dkx0, body_pts)

 dkx = orb_cartesian_to_orbit(gbx, inertial_pts, /circular, GG=GG)

 return, dkx
end
;===============================================================================
