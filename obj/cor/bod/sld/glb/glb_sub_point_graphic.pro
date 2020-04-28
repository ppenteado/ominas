;===========================================================================
;+
; NAME:
;	glb_sub_point_graphic
;
;
; PURPOSE:
;	Computes the planetographic sub-point in body coordinates.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_sub_point_graphic(gbd, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
;
;	r:	Array (nv,3,nt) of points in the BODY frame.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	epsilon:	Convergence criterion for angular deviation from normal.
;			Default is 1d-8.
;
;	niter:		Maximum number of iterations.  Default is 5000.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (nv,3,nt) points in the BODY frame that lie on the surface
;	of each globe, directly 'beneath' r, i.e., such that each 
;	planetographic surface normal points at each r.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:		Spitale, 1/1998
; 	Adapted by:		Spitale, 5/2016
;	Added iteration count:	Moretto, 8/2016
;	
;-
;===========================================================================
function glb_sub_point_graphic, gbd, v, noevent=noevent, epsilon=epsilon, niter=niter
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent

 if(NOT keyword_set(niter)) then niter = 1000
 if(NOT keyword_set(epsilon)) then epsilon = 1d-8

 result = glb_sub_point(gbd, v)				; 1st guess

 ;------------------------------------------------
 ; iterate to find point where normal points at v
 ;------------------------------------------------
 done = 0
 c=0
 while(NOT done AND (c le niter)) do $
  begin
   vv = v_unit(v - result)
   normal = glb_get_surface_normal(/body, gbd, result)

   theta = v_angle(vv, normal)

   w = where(theta GT epsilon)
   if(w[0] EQ -1) then done = 1 $
   else $
    begin
     axis = v_unit(v_cross(normal, vv))
     result = v_rotate_11(result, axis, sin(theta), cos(theta))
     result = glb_sub_point(gbd, result)
     c=c+1
    end

  end


 return, result
end
;==============================================================================
