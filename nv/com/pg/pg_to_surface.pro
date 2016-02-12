;=============================================================================
;+
; NAME:
;	pg_to_surface
;
;
; PURPOSE:
;       Converts image coordinates to surface coordinates.  Input
;       array can be array of image points or a points_struct.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;       result = pg_to_surface(image_points, cd=cd, gbx=gbx) 
;       result = pg_to_surface(image_points, gd=gd)
;
;
; ARGUMENTS:
;  INPUT:
;        image_points:     Array (n_points) of image points (x,y) or
;                          array of type points_struct.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;                  cd:     Array (n_timesteps) of camera descriptors.
;
;                 gbx:     Array (n_objects, n_timesteps) of descriptors of
;                          objects that must be a subclass of GLOBE.
;
;                  gd:     Generic descriptor.  If given, the cd and gbx
;                          inputs are taken from the cd and gbx fields of 
;                          this structure instead of from those keywords.
;
;                  ps:     If set, image_points is treated as a structure
;                          of type points_struct.
;
;  OUTPUT:
;        NONE
;
;
; RETURN:
;	Array (n_points) of surface points.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_to_disk
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function pg_to_surface, image_points, cd=cd, gbx=gbx, gd=gd, ps=ps


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx
; if(keyword__set(gd)) then $
;  begin
;   if(NOT keyword__set(cd)) then cd=gd.cd
;   if(NOT keyword__set(gbx)) then gbx=gd.gbx
;  end


 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 pgs_count_descriptors, gbx, nd=n_objects, nt=nt1
 if(nt NE nt1) then nv_message, name='pg_to_surface', 'Inconsistent timesteps.'
 if(n_objects GT 1) then nv_message, $
           name='pg_to_surface', 'Only one globe descriptor allowed.'

 ;----------------------------------------------------------
 ; compute surface points for all image points at all times
 ;----------------------------------------------------------
 if(keyword__set(ps)) then image_pts = ps_points(image_points, /visible) $
 else image_pts = image_points


 surface_pts = image_to_surface(cd, gbx, image_pts)


 ;----------------------------------------------------------
 ; return only near points
 ;----------------------------------------------------------
 nv = n_elements(image_pts)/2

 return, surface_pts[0:nv-1,*,*]
end
;=============================================================================
