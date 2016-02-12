;=============================================================================
;+
; NAME:
;	pg_shadow
;
;
; PURPOSE:
;	Computes image coordinates of given inertial vectors projected onto
;	surface of the given disks and globes with respect to the given
;	observer.  Returns only the closest shadow point for each objoect 
;	point.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_shadow, object_ps, cd=cd, ods=ods, dkx=dkx, gbx=gbx
;
;
; ARGUMENTS:
;  INPUT:
;	object_ps:	Array of points_struct containing inertial vectors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Array (n_timesteps) of camera descriptors.
;
;	gbx:	Array (n_globes, n_timesteps) of descriptors of objects 
;		which must be a subclass of GLOBE.
;
;	dkx:	Array (n_disks, n_timesteps) of descriptors of objects 
;		which must be a subclass of DISK.
;
;	bx:	Array (n_disks, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.
;
;	od:	Array (n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.  These objects are used
;		as the source from which points are projected.  If no observer
;		descriptor is given, then the sun descriptor in gd is used.
;		Only one observer is allowed.
;
;	gd:	Generic descriptor.  If given, the cd, dkx, gbx, and bx inputs 
;		are taken from the corresponding fields of this structure
;		instead of from those keywords.
;
;	  All other keywords are passed directly to pg_shadow_globe
;	  and pg_shadow_disk and are documented with those programs.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (n_disks,n_objects) of points_struct containing image 
;	points and the corresponding inertial vectors.
;
;
; STATUS:
;	
;
;
; SEE ALSO:
;	pg_shadow_disk, pg_shadow_globe, pg_shadow_points
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function pg_shadow, cd=cd, od=od, dkx=dkx, gbx=gbx, bx=bx, gd=gd, object_ps, $
              reveal=reveal, fov=fov, nocull=nocull, all=all, $
              both=both, backshadow=backshadow, $
              iterate=iterate, nosolve=nosolve, dbldbl=dbldbl

 pgs_gd, bx=bx

 ;----------------------------------
 ; extract objects from bx
 ;----------------------------------
 if(keyword_set(bx)) then $
  begin
   class = class_get(bx)

   _gbx = class_extract(bx, 'GLOBE')
   if(keyword_set(_gbx)) then gbx = append_array(gbx, _gbx)

   _dkx = class_extract(bx, 'DISK')
   if(keyword_set(_dkx)) then dkx = append_array(dkx, _dkx)
  end

 ;----------------------------------
 ; project onto all globes
 ;----------------------------------
 if(keyword_set(gbx)) then $
   globe_shadow_ps = $
       pg_shadow_globe(object_ps, cd=cd, od=od, gbx=gbx, gd=gd, $
               /nocull, reveal=reveal, fov=fov, both=both, backshadow=backshadow, $
               iterate=iterate, nosolve=nosolve, dbldbl=dbldbl)

 ;----------------------------------
 ; project onto all disks
 ;----------------------------------
 if(keyword_set(dkx)) then $
   disk_shadow_ps = $
       pg_shadow_disk(object_ps, cd=cd, od=od, dkx=dkx, gbx=gbx, gd=gd, $
               /nocull, reveal=reveal, fov=fov, both=both, backshadow=backshadow)


 ;----------------------------------
 ; combine results
 ;----------------------------------
 if(keyword_set(globe_shadow_ps)) then $
   _shadow_ps = append_array(_shadow_ps, transpose_struct(globe_shadow_ps))
 if(keyword_set(disk_shadow_ps)) then $
   _shadow_ps = append_array(_shadow_ps, transpose_struct(disk_shadow_ps))

 n = n_elements(object_ps)
 shadow_ps = ptrarr(n)
 for i=0, n-1 do shadow_ps[i] = ps_compress(_shadow_ps[*,i])
  
 if(NOT keyword_set(nocull)) then shadow_ps = ps_cull(shadow_ps)

 return, shadow_ps
end
;=============================================================================
