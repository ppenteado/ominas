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
;	int_pts = glb_intersect(gbd, view_pts, ray_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:		Array (nt) of any subclass of GLOBE descriptors.
;
;	view_pts:	Array (nv,3,nt) giving ray origins in the BODY frame.
;
;	ray_pts:	Array (nv,3,nt) giving ray directions in the BODY frame.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	near:	If set, only the "near" points are returned.  More specifically,
;		these points correspond to the nearest along the ray from the 
;		observer to the globe.  If the observer is exterior, these are 
;		the nearest interesections to the observer; if the observer is 
;		interior, these intersections are behind the observer.  
;
;	far:	If set, only the "far" points are returned.  See above; if the 
;		observer is exterior, these are the furthest interesections from 
;		the observer; if the observer is interior, these intersections 
;		are in front of the observer.
;
;	hit:	Array giving the indices of rays that hit the object.
;
;	valid:	Array in which each element indicates whether the object
;		was hit.
;
;	nosolve: If set, the intersections are not computed, though the
;		 discrimiant is.
;
;  OUTPUT: 
;	discriminant:	Discriminant of the quadriatic equation used to 
;			determine the intersections.
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
function glb_intersect, gbd, view_pts, ray_pts, hit=hit, near=near, far=far, $
                      discriminant=discriminant, nosolve=nosolve, valid=valid
@core.include

 nt = 1
 dim = size(view_pts, /dim)
 nv = dim[0]
 if(n_elements(dim) GT 2) then t = dim[2]

 ;----------------------------
 ; compute the discriminant
 ;----------------------------
 discriminant = glb_intersect_discriminant(gbd, view_pts, ray_pts, $
                                           alpha=alpha, beta=beta, gamma=gamma)

 ;----------------------------------
 ; compute the intersection points
 ;----------------------------------
 glb_intersect_points, gbd, view_pts, ray_pts, discriminant, alpha, beta, gamma, $
                            valid=valid, nosolve=nosolve, near=near_pts, far=far_pts
 if(arg_present(hit)) then hit = where(valid NE 0)


 ;----------------------------------
 ; select outputs
 ;----------------------------------
 if(keyword_set(near)) then return, near_pts
 if(keyword_set(far)) then return, far_pts
 return, [near_pts, far_pts]
end
;===========================================================================
