;=============================================================================
;+
; NAME:
;	pg_array
;
;
; PURPOSE:
;	Computes image points for given array descriptors.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	array_ps = pg_array(gd=gd)
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
;	ard:	Array (n_objects, n_timesteps) of descriptors of objects 
;		that must be a subclass of array.
;
;	gbx:	Array (n_xd, n_timesteps) of descriptors of objects 
;		that must be a subclass of GLOBE.
;
;	dkx:	Array (n_xd, n_timesteps) of descriptors of objects 
;		that must be a subclass of DISK.
;
;	bx:	Array (n_xd, n_timesteps) of descriptors of objects 
;		that must be a subclass of BODY, instead of gbx or dkx.  
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One per bx.
;
;	gd:	Generic descriptor.  If given, the cd and gbx inputs 
;		are taken from the cd and gbx fields of this structure
;		instead of from those keywords.
;
;	fov:	 If set points are computed only within this many camera
;		 fields of view.
;
;	cull:	 If set, points structures excluded by the fov keyword
;		 are not returned.  Normally, empty points structures
;		 are returned as placeholders.
;
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
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
function pg_array, cd=cd, ard=ard, gbx=gbx, dkx=dkx, bx=bx, gd=gd, $
                               fov=fov, cull=cull, frame_bd=frame_bd
@ps_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, ard=ard, cd=cd, bx=bx, gbx=gbx, dkx=dkx, frame_bd=frame_bd
 if(NOT keyword_set(cd)) then cd = 0 
 if(keyword_set(gbx)) then if(NOT keyword_set(bx)) then bx = gbx
 if(keyword_set(dkx)) then if(NOT keyword_set(bx)) then bx = dkx

 if(keyword_set(fov)) then slop = (image_size(cd[0]))[0]*(fov-1) > 1

 pgs_count_descriptors, ard, nd=n_objects, nt=nt


 ;-----------------------------------
 ; compute points for each array
 ;-----------------------------------
 hide_flag = PS_MASK_INVISIBLE

 array_ps = ptrarr(n_objects, nt)

 for j=0, nt-1 do $
  begin
   for i=0, n_objects-1 do $
    begin
     input = 0
     idp = 0
     xd = 0
     if(keyword_set(bx)) then $
      begin
       w = where(arr_primary(ard[i,j]) EQ cor_name(bx[*,j]))

       if(w[0] NE -1) then $
        begin
;         xd = reform(bx[w[0],j], nt)
         xd = bx[w[0],j]
         input = pgs_desc_suffix(bx=xd[0], cd=cd[0])
         idp = cor_idp(xd)
        end
      end

     surf_pts = arr_surface_pts(ard[i,j])
     map_pts = surface_to_map(cd[j], xd, surf_pts)

     points = map_to_image(cd[j], cd[j], xd, map_pts, valid=valid, $
                                         body=body_pts, frame_bd=frame_bd)
     inertial_pts = 0
     if(keyword_set(bx)) then $
      if(keyword_set(body_pts)) then $
       inertial_pts = bod_body_to_inertial_pos(xd, body_pts)

     name = get_core_name(xd) + ':' + get_core_name(ard[i,j])

     ;-----------------------------------
     ; store grid
     ;-----------------------------------
     array_ps[i,j] = ps_init(name = strupcase(name), $
		             desc = 'array', $
		             input = input, $
		             assoc_idp = idp, $
		             points = points, $
		             vectors = inertial_pts)
   flags = ps_flags(array_ps[i,j])
   if(NOT keyword__set(valid)) then flags[*] = PS_MASK_INVISIBLE
   ps_set_flags, array_ps[i,j], flags

     if(keyword_set(xd)) then $
       if(NOT bod_opaque(xd[0])) then ps_set_flags, array_ps[i,j], hide_flag
    end
  end


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, array_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then array_ps = ps_cull(array_ps)
  end


 if(keyword_set(__lat)) then _lat = __lat
 if(keyword_set(__lon)) then _lon = __lon

 return, array_ps
end
;=============================================================================
