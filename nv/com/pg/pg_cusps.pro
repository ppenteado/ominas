;=============================================================================
;+
; NAME:
;	pg_cusps
;
;
; PURPOSE:
;	Computes image points at the limb/terminator cusps for each given 
;	globe object.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	cusp_ps = pg_cusps(cd=cd, od=od, gbx=gbx)
;	cusp_ps = pg_cusps(gd=gd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	 Array (n_timesteps) of camera descriptors.
;
;	od:	 Array (n_timesteps) of descriptors for the observer, 
;		 default is the sun is gd given.
;
;	gbx:	 Array (n_objects, n_timesteps) of descriptors of objects 
;		 which must be a subclass of GLOBE.
;
;	gd:	 Generic descriptor.  If given, the cd, od, and gbx inputs 
;		 are taken from this structure instead of from those keywords.
;
;	epsilon: Maximum angular error in the result.  Default is 1e-3.
;
;	reveal:	 Normally, points computed for objects whose opaque flag
;		 is set are made invisible.  /reveal suppresses this behavior.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects) of points_struct containing image
;	points and the corresponding inertial vectors.
;
;
; PROCEDURE:
;	This program uses an iterative scheme to find the two points on 
;	the surface of the globe where the surface normal is simultaneously
;	perpendicular to the vectors from the camera and the Sun.
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2010
;	
;-
;=============================================================================
function pg_cusps, cd=cd, od=od, gbx=gbx, gd=gd, epsilon=epsilon, reveal=reveal
@ps_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx, od=od, sund=sund
 if(NOT keyword_set(cd)) then return, ptr_new() 
 if(NOT keyword_set(gbx)) then return, ptr_new()

 ;-----------------------------
 ; default observer is sun
 ;-----------------------------
 if(NOT keyword_set(od)) then od=sund

 ;-----------------------------------
 ; default iteration parameters
 ;-----------------------------------
 if(NOT keyword_set(npoints)) then npoints=1000
 if(NOT keyword_set(epsilon)) then epsilon=1e-3


 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 nt1 = n_elements(od)
 pgs_count_descriptors, gbx, nd=n_objects, nt=nt2
 if(nt NE nt1 OR nt1 NE nt2) then nv_message, name='pg_cusps', $
                                                      'Inconsistent timesteps.'


 ;-----------------------------------------------
 ; contruct data set description
 ;-----------------------------------------------
 desc = 'cusp'
 hide_flags = make_array(npoints, val=PS_MASK_INVISIBLE)

 ;---------------------------------------------------------
 ; get cusps for each object for all times
 ;---------------------------------------------------------
 cusp_ps = ptrarr(n_objects)

 obs_pos = bod_pos(od)
 cam_pos = bod_pos(cd)
 for i=0, n_objects-1 do $
  begin
   xd = reform(gbx[i,*], nt)				; Object i for all t.

   Rs = bod_inertial_to_body_pos(xd, obs_pos)		; Source position
							; in object i's body
							; frame for all t.

   Rc = bod_inertial_to_body_pos(xd, cam_pos)		; Camera position
							; in object i's body
							; frame for all t.

   cusp_pts = glb_get_cusp_points(xd, Rc, Rs, epsilon)	; for all t.

   flags = bytarr(n_elements(cusp_pts[*,0]))
   points = body_to_image_pos(cd, xd, cusp_pts, inertial=inertial_pts, valid=valid)
   if(keyword__set(valid)) then $
    begin
     invalid = complement(cusp_pts[*,0], valid)
     if(invalid[0] NE -1) then flags[invalid] = PS_MASK_INVISIBLE
    end
   cusp_ps[i] = ps_init(name = get_core_name(xd), $
			desc=desc, $
			input=pgs_desc_suffix(gbx=gbx[i,0], od=od[0], cd=cd[0]), $
			assoc_idp = cor_idp(xd), $
                        points = points, $
			flags = flags, $
                        vectors = inertial_pts)
   if(NOT bod_opaque(gbx[i,0])) then ps_setflags, cusp_ps[i], hide_flags
  end



 return, cusp_ps
end
;=============================================================================
