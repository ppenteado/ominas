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
;	pg_move, object_ps, dxy, dtheta, axis_ps=axis_ps
;
;
; ARGUMENTS:
;  INPUT:
;	object_ps:	Array (n_objects) of points_struct containing the
;			image points to be moved.
;
;	dxy:		2-element array specifying the translation as [dx,dy].
;
;	dtheta:		Rotation angle in radians.
;
;  OUTPUT:
;	object_ps:	The input points are be modified on return.
;
;
; KEYWORDS:
;  INPUT:
;	axis_ps:	points_struct containing a single image point
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
pro pg_move, object_ps, dxy, dtheta, axis_ps=axis_ps

 n_objects=n_elements(object_ps)

 ;---------------------
 ; rotation matrix
 ;---------------------
 sin_dtheta=sin(dtheta)
 cos_dtheta=cos(dtheta)
 R = [ [ cos_dtheta, -sin_dtheta], $
       [ sin_dtheta,  cos_dtheta] ]

 if(NOT keyword__set(axis_ps)) then axis_points=[0.,0.] $
 else axis_points = ps_points(axis_ps)

 ;----------------------
 ; translate and rotate
 ;----------------------
 for i=0, n_objects-1 do $
  begin
   points = ps_points(object_ps[i])
   nn = ps_nv(object_ps[i])
   nt = ps_nt(object_ps[i])
   axis = (axis_points#make_array(nn,val=1))[linegen3z(2,nn,nt)]
   M = R[linegen3z(2,2,nt)]
   p = dxy[linegen3z(1,2,nt)]
   if(nt EQ 1) then v = transpose(points-axis) $ 
   else v = transpose(points-axis, [1,0,2])

   vt = v_transform_forward(M, P, v)

   if(nt EQ 1) then vv = transpose(vt) + axis $
   else vv = transpose(vt, [1,0,2]) + axis
   ps_set_points, object_ps[i], vv

  end


end
;=============================================================================
