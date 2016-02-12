;=============================================================================
;+
; NAME:
;       ringplane_radial_bounds
;
;
; PURPOSE:
;	Finds ringplane radial bounds by projecting the camera FOV on 
;	the ringplane.  
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = ringplane_radial_bounds(cd, dkx, frame_bd=frame_bdp)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	dkx:	Any subclass of DISK.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (2) giving the minimum and maximum disk radii visible 
;	to the camera.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function ringplane_radial_bounds, cd, dkx, frame_bd=frame_bd

 v = (bod_orient(cd))[1,*] 			; optic axis vector
 n = (bod_orient(dkx))[2,*]			; ringplane normal
 r = bod_pos(cd)

 cam_size = cam_size(cd)
 theta = 0.5 * sqrt(0.5*(((cam_scale(cd))[0]*cam_size[0])^2 + $
                                      ((cam_scale(cd))[1]*cam_size[1])^2))

 axis = v_unit(v_cross(n, v))

 sin_theta = sin(theta)
 cos_theta = cos(theta)
 v1 = v_rotate(v, axis, sin_theta, cos_theta)
 v2 = v_rotate(v, -axis, sin_theta, cos_theta)

 vv1 = dsk_intersect_inertial(dkx, r, v1)
 vv2 = dsk_intersect_inertial(dkx, r, v2)
 vv1_disk = inertial_to_disk_pos(dkx, vv1, frame_bd=frame_bd)
 vv2_disk = inertial_to_disk_pos(dkx, vv2, frame_bd=frame_bd)

 rad1 = vv1_disk[0]
 rad2 = vv2_disk[0]

 rads = [rad1, rad2]
 rads = rads[sort(rads)]

 return, rads
end
;==============================================================================
