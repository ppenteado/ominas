;=============================================================================
;+
; NAME:
;	pg_center
;
;
; PURPOSE:
;	Computes image coordinates of the center of each object.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	center_ps = pg_center(cd=cd, bx=bx)
;	center_ps = pg_center(gd=gd)
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
;	cd:	Array (n_timesteps) of camera descriptors.
;
;	bx:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.
;
;	gd:	Generic descriptor.  If given, the cd and bx inputs 
;		are taken from the cd and bx fields of this structure
;		instead of from those keywords.
;
;	fov:	 If set points are computed only within this many camera
;		 fields of view.
;
;	cull:	 If set, points structures excluded by the fov keyword
;		 are not returned.  Normally, empty points structures
;		 are returned as placeholders.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects) of points_struct containing image points and
;	the corresponding inertial vectors.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function pg_center, cd=cd, bx=bx, gd=gd, fov=fov, cull=cull

 if(keyword_set(fov)) then slop = (cam_size(cd[0]))[0]*(fov-1) > 1

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, bx=bx, dd=dd
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(bx)) then return, ptr_new()

 ;-----------------------------------------------
 ; determine points description
 ;-----------------------------------------------
 desc = class_get(bx) + '_center'

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 pgs_count_descriptors, bx, nd=n_objects, nt=nt1
 if(nt NE nt1) then nv_message, name='pg_center', 'Inconsistent timesteps.'


 ;-----------------------------------
 ; get center for each object
 ;-----------------------------------
 center_ps = ptrarr(n_objects)
 im_pts = dblarr(1, 2, n_objects)
 bds = class_extract(bx, 'BODY')
 inertial_pts = bod_pos(bds)

 cam_bd = cam_body(cd)

 for i=0, n_objects-1 do $
  begin
   xd = reform(bx[i,*], nt)
   bds=class_extract(xd, 'BODY')			; Object i for all t.
   inertial_pts = bod_pos(bds)

   center_ps[i] = $
        ps_init(name = get_core_name(bds), $
		desc = desc[i], $
		input = pgs_desc_suffix(bx=bx[i,0], cd=cd[0]), $
		assoc_idp = nv_extract_idp(xd), $
		points = inertial_to_image_pos(cd, inertial_pts), $
		vectors = inertial_pts)
  end


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, center_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then center_ps = ps_cull(center_ps)
  end


 return, center_ps
end
;=============================================================================
