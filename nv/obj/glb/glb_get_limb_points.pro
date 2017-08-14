;===========================================================================
;+
; NAME:
;	glb_get_limb_points
;
;
; PURPOSE:
;	Iteratively computes the points on the limb for each given globe 
;	object.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	limb_pts = glb_get_limb_points(gbd, view_pt, np, epsilon, niter)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:		Array (nt) of any subclass of GLOBE descriptors.
;
;	view_pt:	Array (1,3,nt) giving viewer position in the BODY frame.
;
;	np:		Number of points to compute around the limb.
;
;	epsilon:	Controls the precision of the iteration.  Default
;			is 1d-3.
;
;	niter:		Maximum number of iterations, default is 1000
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	alpha:	Array (np) of azimuths for each output point.
;
;
; RETURN: 
;	Array (np, 3, nt) of limb points in the BODY frame.
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
; _glb_get_limb_points.pro
;
;
;===========================================================================
function _glb_get_limb_points, gbd, view_pt, $
                                   n_points, epsilon, niter, alpha=alpha

 ;-----------------------------------------------
 ; if any radii are zero, then return a point
 ;-----------------------------------------------
 radii = glb_radii(gbd)
 if(prod(radii[*],0) EQ 0) then return, dblarr(n_points,3)

 MM = make_array(n_points, val=1.0)

 ;--------------------------------
 ; Angle to each limb point
 ;--------------------------------
 if(NOT keyword_set(alpha)) then alpha = dindgen(n_points)*2.*!dpi/(n_points-1)

 ;--------------------------------------
 ; Unit vectors from planet to observer
 ;--------------------------------------
 _view_pt = v_unit(view_pt)

 ;-----------------------------------------------------------------
 ; Construct normal to _view_pt - 
 ;  Use projection of pole on skyplane
 ;-----------------------------------------------------------------
 zz = tr([0d,0d,1d])
 vv = v_cross(zz, _view_pt)
 vo = v_unit(v_cross(vv, _view_pt))

 ;---------------------------------------------------------------
 ; Generate first guess at limb points - 
 ;  Use intersection of planet surface with plane normal to 
 ;  viewer passing through the center of the planet.  Generate
 ;  points by rotating v about n and determining the surface 
 ;  radius at that point.
 ;---------------------------------------------------------------
 guess_pts = transpose( v_rotate(vo, _view_pt, sin(alpha), cos(alpha) ) )
 view_pts = view_pt##MM

 ;-----------------------------------------------------------------
 ; Iterate to find the actual limb.  
 ; This recomputes many points unnecessarily
 ;-----------------------------------------------------------------
 done = 0
 axes = v_unit(v_cross(_view_pt##MM, guess_pts))
 nit = 0
 correct = 1d
 while(NOT done) do $
  begin
   ;---------------------------------
   ; compute current limb points
   ;---------------------------------
   limb_pts_surf = glb_body_to_globe(gbd, guess_pts)
   limb_pts_surf[*,2] = 0d
   limb_pts_body = glb_globe_to_body(gbd, limb_pts_surf)

   ;---------------------------------
   ; compute residuals
   ;---------------------------------
   ray_pts = v_unit(limb_pts_body - view_pts)
   norm_pts = glb_get_surface_normal(gbd, limb_pts_surf)

   residuals = v_inner(norm_pts, ray_pts)

   ;---------------------------------
   ; make new guesses if necessary
   ;---------------------------------
   w = where(abs(residuals) GT epsilon)
   offsets = 0.5d*residuals * correct
   if(w[0] EQ -1) then done = 1 $
   else guess_pts = v_rotate_11(guess_pts, axes, [offsets], [sqrt(1d - offsets^2)])
   nit = nit + 1
   if(nit GE niter) then done = 1
   if(nit mod (niter/4d) EQ 0) then correct = 0.5d*correct
  end


 return, limb_pts_body
end
;===========================================================================



;===========================================================================
; glb_get_limb_points
;
; view_pt is array (1,3,nt) of column vectors giving the position of the 
; viewer.  gbd is array of nt globe descriptors.  Result is array (n_points,3,nt)
; of limb column vectors.
;
;===========================================================================
function glb_get_limb_points, gbd, view_pt, $
                         n_points, epsilon, niter, alpha=alpha
@core.include
 

 if(NOT keyword_set(n_points)) then n_points = 1000
 if(NOT keyword_set(epsilon)) then epsilon = 1d-3
 if(NOT keyword_set(niter)) then niter = 1000

 nt = n_elements(gbd)
 result = dblarr(n_points, 3, nt, /nozero)

 for t=0, nt-1 do $
  result[*,*,t] = _glb_get_limb_points(gbd[t], view_pt[*,*,t], $
                                    n_points, epsilon, niter, alpha=alpha)

 return, result
end
;===========================================================================






