;===========================================================================
;+
; NAME:
;	glb_hide_points
;
;
; PURPOSE:
;	Identifies points that are obscured by a GLOBE with respect to a given 
;	viewpoint.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	sub = glb_hide_points(gbd, view_pts, hide_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:		Array (nt) of any subclass of GLOBE descriptors.
;
;	view_pts:	Columns vector giving the BODY-frame position of the viewer.
;
;	hide_pts:	Array (nv) of BODY-frame vectors giving the points to hide.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	rm:	If set, points are flagged for being in front of or behind
;		the globe, rather then just behind it.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Subscripts of the points in p that are hidden by the object.  
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


;===========================================================================
; glb_hide_points.pro
;
; Inputs are in body coordinates.
;
; Returns subscripts of points hidden from the viewer at v by the globe.
;
; gbd -- nt
; v -- 1 x 3 x nt or nv x 3 x nt
; points, nv x 3 x nt
;
;===========================================================================
function glb_hide_points, gbd, _view_pts, hide_pts, rm=rm
@core.include
 
 epsilon = 100d						; kind of arbitray
epsion = 0

 nt = n_elements(gbd)
 nv = (size(hide_pts))[1]

 view_pts = _view_pts[linegen3x(nv,3,nt)] 
 ray_pts = hide_pts - view_pts 


 ;------------------------------------------------------------------
 ; determine which rays intersect the body
 ;------------------------------------------------------------------
 int_pts = glb_intersect(gbd, view_pts, ray_pts, hit=sub)

 ;---------------------------------------------------------------------
 ; retain intersecting rays that are in front of the body unless /rm
 ;---------------------------------------------------------------------
 if(NOT keyword_set(rm)) then $
  if(sub[0] NE -1) then $
   begin
; only for nt=1...
    dist_ray = v_mag(ray_pts[sub,*])
    dist_int = v_mag(int_pts[sub,*]-view_pts[sub,*])

    w = where(dist_ray LT dist_int+epsilon)

    if(w[0] NE -1) then sub = rm_list_item(sub, w, only=-1)
   end


 return, sub
end
;===========================================================================
