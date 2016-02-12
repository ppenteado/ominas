;=============================================================================
;+
; NAME:
;	pg_shadow_points
;
;
; PURPOSE:
;	Determines whether each given point is shadowed by the given object.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_shadow_points, object_ps, cd=cd, od=od, bx=bx
;
;
; ARGUMENTS:
;  INPUT:
;	object_ps:	Array of points_struct containing inertial vectors
;			to shadow.
;
;  OUTPUT: 
;	shadow_ps:	Array of points_struct containing the shadowed
;			points.
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Array (n_timesteps) of camera descriptors.
;
;	bx:	Array (nbx, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY describing the shadowing
;		bodies.
;
;	od:	Array (n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.  These objects are used
;		as the source from which points are projected.  If no observer
;		descriptor is given, then the sun descriptor in gd is used.
;		Only one observer is allowed.
;
;	gd:	Generic descriptor.  If given, the cd and bx inputs 
;		are taken from the corresponding fields of this structure
;		instead of from those keywords.
;
;	fov:	 If set shadow points are cropped to within this many camera
;		 fields of view.
;
;	cull:	 If set, points structures excluded by the fov keyword
;		 are not returned.  Normally, empty points structures
;		 are returned as placeholders.
;
;   backshadow:	 If set, only backshadows (shadows cast between the object and
; 		 observer) are considered.
;
;	both:	 If set, both shadows and backshadows are returned.
;
;	edge:	 If set, only points near the edge of the shadow are returned.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	Shadowed points are flagged as invisible.
;
;
; STATUS:
;	
;
;
; SEE ALSO:
;	pg_shadow, pg_shadow_globe, pg_shadow_disk
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2012
;	
;-
;=============================================================================
pro pg_shadow_points, cd=cd, od=od, bx=bx, gd=gd, object_ps, shadow_ps, $
                           nocull=nocull, edge=edge, $
                           fov=fov, cull=cull, both=both, backshadow=_backshadow, $
                           iterate=iterate, nosolve=nosolve, dbldbl=dbldbl
@ps_include.pro


 backshadow = 1 - keyword_set(_backshadow)

 shad_ps = pg_shadow(both=both, backshadow=backshadow, $
                       object_ps, cd=cd, od=od, bx=bx, gd=gd, $
                       all=all, fov=fov, nocull=NOT keyword_set(cull), $
                       iterate=iterate, nosolve=nosolve, dbldbl=dbldbl)

 object_flags = ps_flags(object_ps)
 shad_flags = ps_flags(shad_ps)

 flags = object_flags OR NOT shad_flags
 shadow_flags = object_flags OR shad_flags

 ps_set_flags, object_ps, flags

 if(arg_present(shadow_ps)) then $
  begin
    shadow_ps = nv_clone(object_ps)
    ps_set_flags, shadow_ps, shadow_flags
  end


end
;=============================================================================
