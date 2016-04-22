;=============================================================================
;+
; NAME:
;       dsk_radial_resolution
;
;
; PURPOSE:
;	Computes the radial resolution at a point on a disk in a 
;	given camera.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       res = dsk_radial_resolution(dkx, cd, r, scale)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Any subclass of DISK.
;
;	cd:	Camera descriptor.
;
;	r:	Point on the dkx in inertial coordinates.
;
;  OUTPUT:  NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Radial resolution on dkx at r, computed as the length of a
;	segment bisecting the intersection ellipse in the radial direction.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function dsk_radial_resolution, dkd, cd, r, scale

 cam_orient = bod_orient(cd)
 dsk_orient = bod_orient(dkd)

 nv = n_elements(r)/3						; assume  nt = 1
 mm = make_array(nv, val=1d)
 m = make_array(3, val=1d)

 cam_pos = bod_pos(cd) ## mm
 dsk_pos = bod_pos(dkd) ## mm

 rad = v_mag(r - cam_pos) # m

 x = cam_orient[0,*] ## mm
 y = cam_orient[2,*] ## mm
 z = -cam_orient[1,*] ## mm

 n = dsk_orient[2,*] ## mm

 cos_phi = v_inner(x, v_unit(r - dsk_pos)) # m
 phi = acos(cos_phi)
 cos_theta = v_inner(z,n) # m
 theta = acos(cos_theta)

 tan_gamma = cos_theta*tan(phi)
 gamma = atan(tan_gamma)

 q = rad*( x*cos(gamma) + y*sin(gamma) - z*sin(gamma)*tan(theta) )

 sigma_rad = v_mag(q)

 return, scale * sigma_rad
end
;==============================================================================
