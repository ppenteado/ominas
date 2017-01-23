;=============================================================================
;+
; NAME:
;	pg_shadow_globe
;
;
; PURPOSE:
;	Computes image coordinates of the given inertial vectors projected onto
;	surface of the given globe with respect to the given observer.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_shadow_globe(object_ptd, cd=cd, od=od, gbx=gbx)
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
;	od:	Array (n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.  These objects are used
;		as the source from which points are projected.  If no observer
;		descriptor is given, then the sun descriptor in gd is used.
;		Only one observer is allowed.
;
;	gd:	Generic descriptor.  If given, the cd and gbx inputs 
;		are taken from the cd and gbx fields of this structure
;		instead of from those keywords.
;
;	reveal:	 Normally, disks whose opaque flag is set are ignored.  
;		 /reveal suppresses this behavior.
;
;	fov:	 If set shadow points are cropped to within this many camera
;		 fields of view.
;
;	cull:	 If set, POINT objects excluded by the fov keyword
;		 are not returned.  Normally, empty POINT objects
;		 are returned as placeholders.
;
;   backshadow:	 If set, only backshadows (shadows cast between the object and
; 		 observer) are returned.
;
;	both:	 If set, both shadows and backshadows are returned.
;
;	all:	 If set, all points are returned, even if invalid.
;
;	epsilon: If set, shadow points that are closer than this amount 
;		 to the source point will be excluded.
;
;	nosolve: If set, shadow points are not computed.  
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (n_globes,n_objects) of POINT containing image 
;	points and the corresponding inertial vectors.
;
;
; STATUS:
;	
;
;
; SEE ALSO:
;	pg_shadow, pg_shadow_disk, pg_shadow_points
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function pg_shadow_globe, cd=cd, od=od, gbx=gbx, gd=gd, object_ptd, $
                          nocull=nocull, both=both, reveal=reveal, $
                          fov=fov, cull=cull, backshadow=backshadow, all=all, $
                          epsilon=epsilon, nosolve=nosolve
@pnt_include.pro


 if(NOT keyword_set(dis_epsilon)) then dis_epsilon = 1d-16

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx, od=od, sund=sund
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(od)) then $
  if(keyword_set(sund)) then od = sund $
  else nv_message, 'No observer descriptor.'


 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 pgs_count_descriptors, od, nd=n_observers, nt=nt
 if(n_observers GT 1) then nv_message, 'Only one observer decsriptor allowed.'
 pgs_count_descriptors, gbx, nd=n_globes, nt=nt1
 if(nt NE nt1) then nv_message, 'Inconsistent timesteps.'


 ;------------------------------------------------
 ; compute shadows for each object on each globe
 ;------------------------------------------------
 n_objects = n_elements(object_ptd)
 shadow_ptd = objarr(n_globes, n_objects)
; shadow_ptd = objarr(n_objects)

 obs_pos = bod_pos(od)
 for j=0, n_objects-1 do if(obj_valid(object_ptd[j])) then  $
  begin
   for i=0, n_globes-1 do $
    if((bod_opaque(gbx[i,0])) OR (keyword_set(reveal))) then $
     begin
      xd = reform(gbx[i,*], nt)

      ;---------------------------
      ; get object vectors
      ;---------------------------
      pnt_get, object_ptd[j], vectors=vectors, assoc_xd=assoc_xd
      if(xd NE assoc_xd) then $
       begin
        n_vectors = (size(vectors))[1]

        ;---------------------------------------
        ; source and ray vectors in body frame
        ;---------------------------------------
        v_inertial= obs_pos##make_array(n_vectors, val=1d)
        rr = vectors - v_inertial
        r_inertial = v_unit(rr)

        r_body = bod_inertial_to_body(xd, r_inertial)
        v_body = bod_inertial_to_body_pos(xd, vectors)

        ;---------------------------------
        ; project shadows in body frame
        ;---------------------------------
        shadow_pts = $
           glb_intersect(/near, $
                       valid=val, nosolve=nosolve, xd, v_body, r_body, dis=dis)
        w = where(val)

        ;---------------------------------------------------------------
        ; Compute and store image coords of any valid intersections.
        ;---------------------------------------------------------------
        if(w[0] NE -1) then $
         begin
          flags = bytarr(n_elements(shadow_pts[*,0]))
          points = $
            degen(body_to_image_pos(cd, xd, shadow_pts, $
                                          inertial=inertial_pts, valid=valid))

  	  ;---------------------------------------------------------------
  	  ; remove points closer than epsilon to source
  	  ;---------------------------------------------------------------
  	  continue = 1
  	  if(keyword_set(epsilon)) then $
  	   begin
  	    dist = v_mag(inertial_pts - vectors)
  	    w = where(dist GT epsilon)
  	    if(w[0] EQ -1) then continue = 0 $
  	    else $
  	     begin
  	      points = points[*,w]
  	      inertial_pts = inertial_pts[w,*]
  	     end
  	   end

  	  if(continue) then $
  	   begin
            ;---------------------------------
            ; store points
            ;---------------------------------
            shadow_ptd[i,j] = $
                pnt_create_descriptors(points = points, $
                   name = 'shadow-' + cor_name(object_ptd[j]), $
                   assoc_xd = object_ptd[j], $
		   desc = 'globe_shadow', $
		   input = pgs_desc_suffix(gbx=gbx[i,0], od=od[0], srcd=object_ptd[j], cd[0]), $
		   vectors = inertial_pts)
 
            ;-----------------------------------------------
            ; flag points that miss the globe as invisible
            ;-----------------------------------------------
            flags = pnt_flags(shadow_ptd[i,j])
            flags[*] = flags[*] OR PTD_MASK_INVISIBLE
            flags[w] = 0

            ss = inertial_pts - v_inertial

            ;-----------------------------------------------------------
            ; flag backshadows as invisible unless /both or /backshadow
            ;-----------------------------------------------------------
            if((NOT keyword_set(backshadow)) AND (NOT keyword_set(both))) then $
             begin
              w = where(v_mag(ss) LE v_mag(rr))
              if(w[0] NE -1) then flags[w] = flags[w] OR PTD_MASK_INVISIBLE
             end

            ;-----------------------------------------------------------
            ; flag shadows as invisible if /backshadow
            ;-----------------------------------------------------------
            if(keyword_set(backshadow)) then $
             begin
              w = where(v_mag(ss) GE v_mag(rr))
              if(w[0] NE -1) then flags[w] = flags[w] OR PTD_MASK_INVISIBLE
             end

            ;-----------------------------------------------------------
            ; flag invalid image points as invisible
            ;-----------------------------------------------------------
            if(NOT keyword_set(all)) then $
             if(keyword_set(valid)) then $
              begin
               invalid = complement(shadow_pts[*,0], valid)
               if(invalid[0] NE -1) then flags[invalid] = PTD_MASK_INVISIBLE
              end

            ;---------------------------------
            ; store flags
            ;---------------------------------
            pnt_set_flags, shadow_ptd[i,j], flags
  	   end
         end
       end
     end
   end


 ;-------------------------------------------------------------------------
 ; by default, remove empty POINT objects and reform to one dimension 
 ;-------------------------------------------------------------------------
 shadow_ptd = reform(shadow_ptd, n_elements(shadow_ptd), /over)
 if(NOT keyword__set(nocull)) then shadow_ptd = pnt_cull(shadow_ptd)


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, shadow_ptd, cd=cd[0], slop=slop
   if(keyword_set(cull)) then shadow_ptd = pnt_cull(shadow_ptd)
  end


 return, shadow_ptd
end
;=============================================================================
