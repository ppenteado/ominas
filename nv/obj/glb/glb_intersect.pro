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
;	nosolve: If set, the intersections are not computed, though the
;		 discriminant is.
;
;  OUTPUT: 
;	hit:	Array giving the indices of rays that hit the object in 
;		the forward direction.
;
;	miss:	Array giving the indices of rays that miss the object.
;
;	score:	Array in which each element indicates the number of forward hits. 
;
;	discriminant:	Discriminant of the quadriatic equation used to 
;			determine the intersections.
;
;	back_pts:
;		Array (nv,3,nt) of additional intersections in order of distance 
;		from the observer.  
;	
;
; RETURN: 
;	Array (nv,3,nt) of points in the BODY frame corresponding to the
;	first intersections with the ray.  Zero vector is returned for points 
;	with no solution, including those behind the viewer.
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
function glb_intersect, gbd, view_pts, ray_pts, hit=hit, miss=miss, back_pts=back_pts, $
                      discriminant=discriminant, nosolve=nosolve, score=score
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
 hit_pts = glb_intersect_points(gbd, view_pts, ray_pts, discriminant, alpha, beta, gamma, $
                          score=score, nosolve=nosolve, back_pts=back_pts)
 if(arg_present(hit)) then hit = where(score GT 0)
 if(arg_present(miss)) then miss = where(score EQ 0)


 ;----------------------------------
 ; select outputs
 ;----------------------------------
 return, hit_pts
end
;===========================================================================



;===========================================================================
function ___glb_intersect, gbd, view_pts, ray_pts, hit=hit, miss=miss, near=near, far=far, $
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
 if(arg_present(miss)) then miss = where(valid EQ 0)


 ;----------------------------------
 ; select outputs
 ;----------------------------------
 if(keyword_set(near)) then return, near_pts
 if(keyword_set(far)) then return, far_pts
 return, [near_pts, far_pts]
end
;===========================================================================
