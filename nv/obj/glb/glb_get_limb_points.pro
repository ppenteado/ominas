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
;	limb_pts = glb_get_limb_points(gbd, r, np, epsilon, niter)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
;
;	r:	Array (1,3,nt) giving viewer position in the BODY frame.
;
;	np:	Number of points to compute around the limb.
;
;	epsilon:	Controls the precision of the iteration.  Default
;			is 1d-3.
;
;	niter:	Maximum number of iterations, default is 1000
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
function _glb_get_limb_points, gbd, r, n_points, epsilon, niter, alpha=alpha

 nt = n_elements(gbd)

 ;-----------------------------------------------
 ; if any radii are zero, then return a point
 ;-----------------------------------------------
 radii = glb_radii(gbd)
 if(prod(radii[*,0],0) EQ 0) then return, dblarr(n_points,3,nt)

 ;--------------------------------
 ; Angle to each limb point
 ;--------------------------------
 if(NOT keyword_set(alpha)) then alpha = dindgen(n_points)*2.*!dpi/n_points

 ;--------------------------------------
 ; Unit vectors from planet to observer
 ;--------------------------------------
 n = v_unit(r)

; ;-----------------------------------------------------------------
; ; Construct normal to n - 
; ;  Look at cross product with each coordinate axis and choose the 
; ;  vector with the largest magnitude
; ;-----------------------------------------------------------------
; vv = v_cross(n##make_array(3, val=1.0), $
;                                 [[1.0,0.0,0.0], [0.0,1.0,0.0], [0.0,0.0,1.0]])
; vm = v_mag(vv)
; w = where(vm EQ max(vm))
; vo = vv[w[0],*]
 ;-----------------------------------------------------------------
 ; Construct normal to n - 
 ;  Use projection of pole on skyplane
 ;-----------------------------------------------------------------
 zz = tr([0d,0d,1d])
 vv = v_cross(zz,n)
; vo = v_unit(v_cross(n,vv))
 vo = v_unit(v_cross(vv,n))

 ;---------------------------------------------------------------
 ; Generate first guess at limb points - 
 ;  Use intersection of planet surface with plane normal to 
 ;  viewer passing through the center of the planet.  Generate
 ;  points by rotating v about n and determining the surface 
 ;  radius at that point.
 ;---------------------------------------------------------------
 v = transpose( reform( v_rotate(vo, n, sin(alpha), cos(alpha) ), nt, 3, n_points) )
; v = transpose( v_rotate(vo, n, sin(alpha), cos(alpha) ) )
 rr = r##make_array(n_points, val=1.0)

 ;-----------------------------------------------------------------
 ; Iterate to find the actual limb.
 ;-----------------------------------------------------------------
 done = 0
 axes = v_cross(n##make_array(n_points, val=1.0), v)
 nit = 0
 correct = 1d
 while(NOT done) do $
  begin
   ;---------------------------------
   ; compute current limb points
   ;---------------------------------
   rlimb_surface = glb_body_to_globe(gbd, v)
   lat = rlimb_surface[*,0]
   lon = rlimb_surface[*,1]

   rlimb_surface[*,2] = 0d
   rlimb_body = glb_globe_to_body(gbd, rlimb_surface)

   ;---------------------------------
   ; compute residuals
   ;---------------------------------
   x = rlimb_body - rr
   x_mag = v_mag(x)

   rnorm_body = v_unit(glb_get_surface_normal(gbd, lat, lon))
   residuals = v_inner(rnorm_body, x) / x_mag

   ;---------------------------------
   ; make new guesses if necessary
   ;---------------------------------
   w = where(abs(residuals) GT epsilon)
   offsets = 0.5d*residuals * correct
   if(w[0] EQ -1) then done = 1 $
   else v = v_rotate_11(v, axes, [offsets], [sqrt(1d - offsets^2)])
   nit = nit + 1
   if(nit GE niter) then done = 1
   if(nit mod (niter/4d) EQ 0) then correct = 0.5d*correct
  end


 return, rlimb_body
end
;===========================================================================



;===========================================================================
; glb_get_limb_points
;
; r is array (1,3,nt) of column vectors giving the position of the viewer.
; gbd is array of nt globe descriptors.  Result is array (n_points,3,nt)
; of limb column vectors.
;
;===========================================================================
function glb_get_limb_points, gbd, r, n_points, epsilon, niter, alpha=alpha
@core.include
 

 if(NOT keyword_set(n_points)) then n_points = 1000
 if(NOT keyword_set(epsilon)) then epsilon = 1d-3
 if(NOT keyword_set(niter)) then niter = 1000

 nt = n_elements(gbd)
 result = dblarr(n_points, 3, nt, /nozero)

 for t=0, nt-1 do $
  result[*,*,t] = _glb_get_limb_points(gbd[t], r[*,*,t], n_points, epsilon, niter, alpha=alpha)

 return, result
end
;===========================================================================






