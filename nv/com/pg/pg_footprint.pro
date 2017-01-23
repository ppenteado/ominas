;=============================================================================
;+
; NAME:
;	pg_footprint
;
;
; PURPOSE:
;	Computes the footprint of a camera on a given body.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;       footprint_ptd = footprint(cd=cd, bx=bx)
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
;	gd:	Generic descriptor.  If given, the cd, od, and bx inputs 
;		are taken from this structure instead of from those keywords.
;
;	fov:	 If set, points are computed only within this many camera
;		 fields of view.
;
;	sample:	 Sampling rate; default is 1 pixel.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects) of POINT containing image points and
;	the corresponding inertial vectors.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2014
;	
;-
;=============================================================================
function pg_footprint, cd=cd, bx=bx, gd=gd, fov=fov, $
    sample=sample
@pnt_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, bx=bx, od=od
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(bx)) then return, obj_new()

 ;-----------------------------
 ; default observer is camera
 ;-----------------------------
 if(NOT keyword_set(od)) then od=cd

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 nt1 = n_elements(od)
 pgs_count_descriptors, bx, nd=n_objects, nt=nt2
 if(nt NE nt1 OR nt1 NE nt2) then nv_message, 'Inconsistent timesteps.'

 ;-----------------------------------------------
 ; determine points description
 ;-----------------------------------------------


 ;-----------------------------------
 ; get footprints
 ;-----------------------------------

 inertial_p = footprint(cd, bx, sample=sample, body_p=body_p, hit=ii)
 if(keyword_set(inertial_p)) then $
  begin 
   nhit = n_elements(inertial_p)
   footprint_ptd = objarr(nhit)

   for i=0, nhit-1 do $
    begin
     bx0 = bx[ii[i]]
     inertial_pts = *inertial_p[i]
     body_pts = *body_p[i]
     np = n_elements(inertial_pts)/3

     points = body_to_image_pos(cd, bx0, body_pts)

     footprint_ptd[i] = $
        pnt_create_descriptors(name = cor_name(bx0), $
              desc = cor_class(bx0) + '_footprint', $
              input = pgs_desc_suffix(bx=bx0, cd[0]), $
              assoc_xd = bx0, $
              vectors = inertial_pts, $
              points = points)

     cor_set_udata, footprint_ptd[i], 'BODY_PTS', body_pts
    end
  end 


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, footprint_ptd, cd=cd[0], slop=slop
   if(keyword_set(cull)) then footprint_ptd = pnt_cull(footprint_ptd)
  end


 return, footprint_ptd
end
;=============================================================================
