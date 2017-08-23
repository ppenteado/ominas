;===========================================================================
;+
; NAME:
;	cam_reorient
;
;
; PURPOSE:
;       Repoints the camera orientiation matrix based on x,y, and theta 
;	image offsets.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_reorient, cd, image_axis, dxy, dtheta
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	Array (nt) of CAMERA descriptors.
;
;	image_axis:	Array (2,1,nt) of image points corresponding to the
;			rotation axis for each descriptor.
;
;	dxy:	Array (2,1,nt) of image offsets in x and y.
;
;	dheta:	Array (1,1,nt) of rotation angles.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	absolute: If set, the dxy argument represents an absolute image
;		  position rather than an offset.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro cam_reorient, cd0, image_axis, dxy, dtheta, absolute=absolute, $
                      n=n, sin_angle=sin_angle, cos_angle=cos_angle
 @core.include

 nt = n_elements(cd0)

 ;---------------------------------
 ; eliminate degenerate dimension
 ;---------------------------------
 s = size(cd0)
 reformed=0

 if(s[0] EQ 2) then $
  begin
   reformed=1
   cd = reform(cd0, nt)
  end $
 else cd=cd0


 ;-------------------------------------------------------
 ; on-axis image points; before and after reorientation
 ;-------------------------------------------------------
 p0 = image_axis
 p1 = dxy
 if(NOT keyword_set(absolute)) then p1 = p1 + image_axis

 ;----------------------------------
 ; choose an off-axis image point
 ;----------------------------------
 r = 100d
 dr = ([r,0.])[gen3x(2,1,nt)]
 q0 = p0 + dr
 q1 = p1 + r*([cos(dtheta),sin(dtheta)])


 ;-----------------------------------------------------
 ; get inertial vector pointing at each image point
 ;-----------------------------------------------------
; u0 = bod_body_to_inertial(cd, $
;          cam_focal_to_body(cd, $
;             cam_image_to_focal(cd, p0)))
 u0=bod_image_to_inertial(cd,p0)

; u1 = bod_body_to_inertial(cd, $
;          cam_focal_to_body(cd, $
;             cam_image_to_focal(cd, p1)))
 u1=bod_image_to_inertial(cd,p1)

; v0 = bod_body_to_inertial(cd, $
;          cam_focal_to_body(cd, $
;             cam_image_to_focal(cd, q0)))
 v0=bod_image_to_inertial(cd,q0)

; v1 = bod_body_to_inertial(cd, $
;          cam_focal_to_body(cd, $
;             cam_image_to_focal(cd, q1)))
 v1=bod_image_to_inertial(cd,q1)


 ;=========================================
 ; construct rotation axis and angle
 ;=========================================
 n = dblarr(1,3,nt, /nozero)
 cos_angle = dblarr(1,1,nt, /nozero)
 sin_angle = dblarr(1,1,nt, /nozero)


 ;-----------------------------------------
 ; no translation and no rotation
 ;-----------------------------------------
 w = where((dxy[0,0,*] EQ 0. AND dxy[1,0,*] EQ 0.) AND dtheta EQ 0.)
 if(w[0] NE -1) then $
  begin
   n[*,*,w]=u0[*,*,w]
   cos_angle[w]=1.0
   sin_angle[w]=0.0
  end

 ;-----------------------------------------
 ; rotation with no translation
 ;-----------------------------------------
 w = where((dxy[0,0,*] EQ 0. AND dxy[1,0,*] EQ 0.) AND dtheta NE 0.)
 if(w[0] NE -1) then $
  begin
   n[*,*,w] = u0[*,*,w]
   cos_angle[w] = cos(dtheta[w])
   sin_angle[w] = sin(dtheta[w])
  end

 ;-----------------------------------------
 ; translation with no rotation
 ;-----------------------------------------
 w = where((dxy[0,0,*] NE 0. OR dxy[1,0,*] NE 0.) AND dtheta EQ 0.)
 if(w[0] NE -1) then $
  begin
   nw = n_elements(w)

   n[*,*,w] = v_cross(u0[*,*,w], u1[*,*,w])

   sin_angle[w] = v_mag(n[*,*,w])
   cos_angle[w] = sqrt(1-sin_angle[w]^2)

   n[*,*,w] = n[*,*,w]/(sin_angle[w])[linegen3y(1,3,nw)]
  end

 ;-------------------------------------------------------------------
 ; translation and rotation - 
 ;      this is not working correctly for multiple time steps.
 ;-------------------------------------------------------------------
 w = where((dxy[0,0,*] NE 0. OR dxy[1,0,*] NE 0.) AND dtheta NE 0.)
 if(w[0] NE -1) then $
  begin
   nw = n_elements(w)

   n[*,*,w] = v_unit(v_cross(u1[*,*,w]-u0[*,*,w], v1[*,*,w]-v0[*,*,w]))

;   u0_dot_n = v_inner(u0[*,*,w],n[*,*,w])
   u0_dot_n = reform(v_inner(u0[*,*,w],n[*,*,w]), 1,1,nt, /overwrite)
   sign = sign(u0_dot_n)*sign(dtheta[w])

   u0_dot_n = u0_dot_n[linegen3y(1,3,nw)]

   cos_angle[w] = (v_inner(u0[*,*,w],u1[*,*,w]) - $
                            u0_dot_n^2)/v_sqmag(u0[*,*,w] - n[*,*,w]*u0_dot_n)
   sin_angle[w] = sign*sqrt(1 - cos_angle^2)
  end


 ;-----------------------------------------
 ; replicate for each basis vector
 ;-----------------------------------------
 n = n[linegen3x(3,3,nt)]
 gen = linegen3x(3,1,nt)
 cos_angle = cos_angle[gen]
 sin_angle = -sin_angle[gen]


 ;-----------------------------
 ; rotate orientation matrices
 ;-----------------------------
 bod_set_orient, cd, v_rotate_11(bod_orient(cd), n, [sin_angle], [cos_angle])


 if(reformed) then cd0=reform(cd, 1, nt) $
 else cd0=cd

end
;===========================================================================
