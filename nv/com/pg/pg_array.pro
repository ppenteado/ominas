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
;	array_ptd = pg_array(gd=gd)
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
;	gd:	Generic descriptor.  If given, the descriptor inputs 
;		are taken from this structure if not explicitly given.
;
;	dd:	Data descriptor containing a generic descriptor to use
;		if gd not given.
;
;	fov:	 If set points are computed only within this many camera
;		 fields of view.
;
;	cull:	 If set, POINT objects excluded by the fov keyword
;		 are not returned.  Normally, empty POINT objects
;		 are returned as placeholders.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects) of objects containing image points and
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
function pg_array, cd=cd, ard=ard, gbx=gbx, dkx=dkx, bx=bx, dd=dd, gd=gd, $
                                                        fov=fov, cull=cull
@pnt_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)
 if(NOT keyword_set(gbx)) then gbx = dat_gd(gd, dd=dd, /gbx)
 if(NOT keyword_set(dkx)) then dkx = dat_gd(gd, dd=dd, /dkx)

 if(keyword_set(gbx)) then if(NOT keyword_set(bx)) then bx = gbx
 if(keyword_set(dkx)) then if(NOT keyword_set(bx)) then bx = dkx

 if(keyword_set(fov)) then slop = (image_size(cd[0]))[0]*(fov-1) > 1

 cor_count_descriptors, ard, nd=n_objects, nt=nt


 ;-----------------------------------
 ; compute points for each array
 ;-----------------------------------
 hide_flag = PTD_MASK_INVISIBLE

 array_ptd = objarr(n_objects, nt)

 for j=0, nt-1 do $
  begin
   for i=0, n_objects-1 do $
    begin
     gd_input = 0
     xd = 0
     if(keyword_set(bx)) then $
      begin
       w = where(arr_primary(ard[i,j]) EQ bx[*,j])

       if(w[0] NE -1) then $
        begin
;         xd = reform(bx[w[0],j], nt)
         xd = bx[w[0],j]
         gd_input = {bx:xd[0], cd:cd[0]}
        end
      end

     surf_pts = arr_surface_pts(ard[i,j])
     map_pts = surface_to_map(cd[j], xd, surf_pts)

     points = map_to_image(cd[j], cd[j], xd, map_pts, valid=valid, body=body_pts)
     inertial_pts = 0
     if(keyword_set(bx)) then $
      if(keyword_set(body_pts)) then $
       inertial_pts = bod_body_to_inertial_pos(xd, body_pts)

;     name = cor_name(xd) + ':' + cor_name(ard[i,j])
     name = cor_name(ard[i,j])

     ;-----------------------------------
     ; store grid
     ;-----------------------------------
     array_ptd[i,j] = pnt_create_descriptors(name = strupcase(name), $
		             desc = 'array', $
		             gd = gd_input, $
		             assoc_xd = xd, $
		             points = points, $
		             vectors = inertial_pts)
     cor_set_udata, array_ptd[i], 'SURFACE_PTS', surf_pts
     flags = pnt_flags(array_ptd[i,j])
     if(NOT keyword__set(valid)) then flags[*] = PTD_MASK_INVISIBLE
     pnt_set_flags, array_ptd[i,j], flags

     if(keyword_set(xd)) then $
       if(NOT bod_opaque(xd[0])) then pnt_set_flags, array_ptd[i,j], hide_flag
    end
  end


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, array_ptd, cd=cd[0], slop=slop
   if(keyword_set(cull)) then array_ptd = pnt_cull(array_ptd)
  end


 if(keyword_set(__lat)) then _lat = __lat
 if(keyword_set(__lon)) then _lon = __lon

 return, array_ptd
end
;=============================================================================
