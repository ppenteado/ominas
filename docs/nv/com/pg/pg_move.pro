;=============================================================================
;+
; NAME:
;	pg_move
;
;
; PURPOSE:
;	Translates and rotates the given points.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_move, object_ptd, dxy, dtheta, axis_ptd=axis_ptd
;
;
; ARGUMENTS:
;  INPUT:
;	object_ptd:	Array (n_objects) of POINT containing the
;			image points to be moved.
;
;	dxy:		2-element array specifying the translation as [dx,dy].
;
;	dtheta:		Rotation angle in radians.
;
;  OUTPUT:
;	object_ptd:	The input points are be modified on return.
;
;
; KEYWORDS:
;  INPUT:
;	axis_ptd:	POINT containing a single image point
;			to be used as the axis of rotation.
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
; SEE ALSO:
;	pg_drag
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro pg_move, object_ptd, dxy, dtheta, axis_ptd=axis_ptd

 n_objects=n_elements(object_ptd)

 ;---------------------
 ; rotation matrix
 ;---------------------
 sin_dtheta=sin(dtheta)
 cos_dtheta=cos(dtheta)
 R = [ [ cos_dtheta, -sin_dtheta], $
       [ sin_dtheta,  cos_dtheta] ]

 if(NOT keyword__set(axis_ptd)) then axis_points=[0.,0.] $
 else axis_points = pnt_points(axis_ptd)

 ;----------------------
 ; translate and rotate
 ;----------------------
 for i=0, n_objects-1 do $
  begin
   points = pnt_points(object_ptd[i])
   nn = pnt_nv(object_ptd[i])
   nt = pnt_nt(object_ptd[i])
   axis = (axis_points#make_array(nn,val=1))[linegen3z(2,nn,nt)]
   M = R[linegen3z(2,2,nt)]
   p = dxy[linegen3z(1,2,nt)]
   if(nt EQ 1) then v = transpose(points-axis) $ 
   else v = transpose(points-axis, [1,0,2])

   vt = v_transform_forward(M, P, v)

   if(nt EQ 1) then vv = transpose(vt) + axis $
   else vv = transpose(vt, [1,0,2]) + axis
   pnt_set_points, object_ptd[i], vv

  end


end
;=============================================================================
