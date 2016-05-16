;===========================================================================
;+
; NAME:
;	surface_intersect
;
;
; PURPOSE:
;	Computes the intersection of rays with surface objects.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;	int_pts = surface_intersect(bx, v, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	Array (nt) of any subclass of BODY descriptors with
;		the expected surface parameters.
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
;  INPUT: 
;	frame_bd:  Frame descriptor, if required for bx.
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
; 	Written by:	Spitale, 7/2015
;	
;-
;===========================================================================
function surface_intersect, bx, v, r, $
                        hit=hit, near=near, far=far, frame_bd=frame_bd

 if(cor_isa(bx[0], 'GLOBE')) then $
          body_pts = glb_intersect(bx, v, r, near=near, far=far, hit=hit) $
 else if(cor_isa(bx[0], 'DISK')) then $
          body_pts = dsk_intersect(bx, v, r, $
                        near=near, far=far, hit=hit, frame_bd=frame_bd, /all)


 return, body_pts
end
;===========================================================================
