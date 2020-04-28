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
;	gd:	Generic descriptor.  If given, the descriptor inputs 
;		are taken from this structure if not explicitly given.
;
;	dd:	Data descriptor containing a generic descriptor to use
;		if gd not given.
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
function pg_sub_body, gbx=gbx, bx=bx, dd=dd, gd=gd


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)
 if(NOT keyword_set(gbx)) then gbx = dat_gd(gd, dd=dd, /gbx)

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 cor_count_descriptors, gbx, nd=n_globe, nt=nt1
 cor_count_descriptors, bx, nd=n_body, nt=nt2
 if((nt1 NE nt2) OR (n_globe NE n_body)) then nv_message, 'Inconsistent descriptors.'

 nt = nt1
 n = n_body

 ;-----------------------------------
 ; get centers
 ;-----------------------------------
 gb_centers = bod_pos(gbx)
 bd_centers = bod_pos(bx)

 ;-------------------------------------------------------
 ; form ray and find intersection with globe surface
 ;-------------------------------------------------------
 v = bod_inertial_to_body_pos(gbx, bd_centers)
 r = bod_inertial_to_body(gbx, gb_centers - bd_centers)

 surface_pts = glb_body_to_globe(gbx, glb_intersect(gbx, v, r))


 ;----------------------------------------------------------
 ; return only near points
 ;----------------------------------------------------------

 return, surface_pts
end
;=============================================================================
