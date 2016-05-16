;===========================================================================
;+
; NAME:
;	glb_intersect
;
;
; PURPOSE:
;	Computes the intersection of rays with GLOBE objects.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	int_pts = glb_intersect(gbd, v, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
;
;	v:	Array (nv,3,nt) giving ray origins in the BODY frame.
;
;	r:	Array (nv,3,nt) giving ray directions in the BODY frame.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (2*nv,3,nt) of points in the BODY frame, where 
;	int_pts[0:nv-1,*,*] correspond to the near-side intersections
;	and int_pts[nv:2*nv-1,*,1] correspond to the far side.  Zero 
;	vector is returned for points with no solution.
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
function glb_intersect, gbd, v, r, hit=hit, near=near, far=far, all=all, frame_bd=frame_bd, $
          discriminant=discriminant, iterate=iterate, nosolve=nosolve, valid=valid
@core.include

 nt = 1
 dim = size(v, /dim)
 nv = dim[0]
 if(n_elements(dim) GT 2) then t = dim[2]

 discriminant_fn = 'glb_intersect_discriminant'

 points_fn = 'glb_intersect_points'
 if(keyword_set(iterate)) then points_fn = 'glb_intersect_points_iter'

 ;----------------------------
 ; compute the discriminant
 ;----------------------------
 discriminant = call_function(discriminant_fn, gbd, v, r, $
                                           alpha=alpha, beta=beta, gamma=gamma)

 ;----------------------------------
 ; compute the intersection points
 ;----------------------------------
 points = call_function(points_fn, gbd, v, r, discriminant, alpha, beta, gamma, $
                       valid=valid, nosolve=nosolve) 
 if(arg_present(hit)) then hit = where(valid NE 0)


 ;----------------------------------
 ; select outputs
 ;----------------------------------
 near = points[0:nv-1,*,*]
 far = points[nv:*,*,*]

 return, points
end
;===========================================================================
