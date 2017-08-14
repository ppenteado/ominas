;=============================================================================
;+
; NAME:
;       phase_correction
;
;
; PURPOSE:
;	Assuming body gbx is a sphere, this routine computes the correction
;	in pixels needed to obtain its true image center given a measurement 
;	of its center of light.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       dxy = phase_correction(cd, gbx, ltd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Any subclass of DISK.
;
;	gbx:	Any subclass of GLOBE.
;
;	ltd:	BODY descriptor representing the light source.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (2) giving the phase correction offset.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function phase_correction, cd, gbx, ltd

 nv = n_elements(gbx)

 ;--------------------------
 ; phase angle
 ;--------------------------
 v = bod_pos(cd)
 s = bod_pos(ltd)
 p = bod_pos(gbx)

 vv = bod_inertial_to_body_pos(gbx, v)
 ss = bod_inertial_to_body_pos(gbx, s) ## make_array(nv, val=1d)

 phase = v_angle(vv,ss) 

 ;--------------------------
 ; body radius on image
 ;--------------------------
 R = total(glb_radii(gbx))/3d
 Rpix = make_array(nv, val=R) / v_mag(vv) / (cam_scale(cd))[0,*]

 ;--------------------------
 ; correction in pixels
 ;--------------------------
 c = 4d/(3d*!dpi) * sin(phase)^2 / (1d + cos(phase)) * Rpix

 ;--------------------------
 ; rotate to get cx, cy
 ;--------------------------
 sp = bod_inertial_to_body(cd, p-s)
 sp[*,1] = 0
 sp = v_unit(sp)
 xx = tr([1,0,0])
 zz = tr([0,0,1])
 cx = c*v_inner(sp,xx)
 cy = c*v_inner(sp,zz)


 return, [cx, cy]
end
;===========================================================================



