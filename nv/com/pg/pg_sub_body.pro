;=============================================================================
;+
; NAME:
;	pg_sub_body
;
;
; PURPOSE:
;	Computes surface coordinates of sub-body point.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	range = pg_sub_body(gbx=gbx, bx=bx, gd=gd)
;
;
; KEYWORD:
;  INPUT:
;	gbx:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of GLOBE.  
;
;	bx:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.
;
;	gd:	Generic descriptor.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects,3) of surface coordinate vectors.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2001
;	
;-
;=============================================================================
function pg_sub_body, gbx=gbx, bx=bx, gd=gd


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, bx=bx, gbx=gbx
; if(keyword__set(gd)) then $
;  begin
;   if(NOT keyword__set(gbx)) then gbx=gd.gbx
;   if(NOT keyword__set(bx)) then bx=gd.bx
;  end

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 pgs_count_descriptors, gbx, nd=n_globe, nt=nt1
 pgs_count_descriptors, bx, nd=n_body, nt=nt2
 if((nt1 NE nt2) OR (n_globe NE n_body)) then $
                   nv_message, name='pg_sub_body', 'Inconsistent descriptors.'

 nt = nt1
 n = n_body

 ;-----------------------------------
 ; get centers
 ;-----------------------------------
 gbds = class_extract(gbx, 'GLOBE')
 bd_globe = class_extract(gbx, 'BODY')
 bds = class_extract(bx, 'BODY')
 gb_centers = bod_pos(bd_globe)
 bd_centers = bod_pos(bds)

 ;-------------------------------------------------------
 ; form ray and find intersection with globe surface
 ;-------------------------------------------------------
 v = bod_inertial_to_body_pos(bd_globe, bd_centers)
 r = bod_inertial_to_body(bd_globe, gb_centers - bd_centers)

 surface_pts = glb_body_to_globe(gbds, glb_intersect(gbds, v, r))


 ;----------------------------------------------------------
 ; return only near points
 ;----------------------------------------------------------

 return, surface_pts[0:n-1,*,*]
end
;=============================================================================
