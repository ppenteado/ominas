;=============================================================================
;+
; NAME:
;	pg_reflection
;
;
; PURPOSE:
;	Computes image coordinates of given inertial vectors projected onto
;	surface of the given disks and globes with respect to the given
;	observer.  Returns only the closest reflection point for each objoect 
;	point.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_reflection, object_ptd, cd=cd, ods=ods, dkx=dkx, gbx=gbx
;
;
; ARGUMENTS:
;  INPUT:
;	object_ptd:	Array of POINT containing inertial vectors.
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
;	  All other keywords are passed directly to pg_reflection_globe
;	  and pg_reflection_disk and are documented with those programs.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (n_disks,n_objects) of POINT containing image 
;	points and the corresponding inertial vectors.
;
;
; STATUS:
;	
;
;
; SEE ALSO:
;	pg_reflection_disk, pg_reflection_globe, pg_reflection_points
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2016
;	
;-
;=============================================================================
function pg_reflection, cd=cd, od=od, dkx=dkx, gbx=gbx, bx=bx, gd=gd, object_ptd, $
              reveal=reveal, fov=fov, nocull=nocull, all=all

 pgs_gd, bx=bx

 ;----------------------------------
 ; extract objects from bx
 ;----------------------------------
 if(keyword_set(bx)) then $
  begin
   gbx = append_array(gbx, cor_select(bx, 'GLOBE', /class))
   dkx = append_array(dkx, cor_select(bx, 'DISK', /class))
  end

 ;----------------------------------
 ; project onto all globes
 ;----------------------------------
 if(keyword_set(gbx)) then $
   globe_reflection_ptd = $
       pg_reflection_globe(object_ptd, cd=cd, od=od, gbx=gbx, gd=gd, $
               /nocull, reveal=reveal, fov=fov)

 ;----------------------------------
 ; project onto all disks
 ;----------------------------------
;; if(keyword_set(dkx)) then $
;;   disk_reflection_ptd = $
;;       pg_reflection_disk(object_ptd, cd=cd, od=od, dkx=dkx, gd=gd, $
;;               /nocull, reveal=reveal, fov=fov)


 ;----------------------------------
 ; combine results
 ;----------------------------------
 if(keyword_set(globe_reflection_ptd)) then $
   _reflection_ptd = append_array(_reflection_ptd, transpose_struct(globe_reflection_ptd))
 if(keyword_set(disk_reflection_ptd)) then $
   _reflection_ptd = append_array(_reflection_ptd, transpose_struct(disk_reflection_ptd))

 n = n_elements(object_ptd)
 reflection_ptd = objarr(n)
 for i=0, n-1 do reflection_ptd[i] = pnt_compress(_reflection_ptd[*,i])
  
 if(NOT keyword_set(nocull)) then reflection_ptd = pnt_cull(reflection_ptd)

 return, reflection_ptd
end
;=============================================================================
