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
;	result = pg_shadow_globe(object_ps, cd=cd, od=od, gbx=gbx)
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
;	cull:	 If set, points structures excluded by the fov keyword
;		 are not returned.  Normally, empty points structures
;		 are returned as placeholders.
;
;   backshadow:	 If set, only backshadows (shadows cast between the object and
; 		 observer) are returned.
;
;	both:	 If set, both shadows and backshadows are returned.
;
;	all:	 If set, all points are returned, even if invalid.
;
;	iterate: If set, the quadratic equation is solved by iteration 
;		 instead of direct evaluation of the quadratic formula.
;
;	nosolve: If set, shadow points are not computed.  
;
;	dbldbl:	 If set, double-double precision is used to compute the
;		 discriminant.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (n_globes,n_objects) of points_struct containing image 
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
function pg_shadow_globe, cd=cd, od=od, gbx=gbx, gd=gd, object_ps, $
                          nocull=nocull, both=both, reveal=reveal, $
                          fov=fov, cull=cull, backshadow=backshadow, all=all, $
                          iterate=iterate, nosolve=nosolve, dbldbl=dbldbl
@ps_include.pro


 if(NOT keyword_set(dis_epsilon)) then dis_epsilon = 1d-16

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx, od=od, sund=sund
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(od)) then $
  if(keyword_set(sund)) then od = sund $
  else nv_message, name='pg_shadow_globe', 'No observer descriptor.'


 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 pgs_count_descriptors, od, nd=n_observers, nt=nt
 if(n_observers GT 1) then $
    nv_message, name='pg_shadow_globe', 'Only one observer decsriptor allowed.'
 pgs_count_descriptors, gbx, nd=n_globes, nt=nt1
 if(nt NE nt1) then $
                 nv_message, name='pg_shadow_globe', 'Inconsistent timesteps.'


 ;------------------------------------------------
 ; compute shadows for each object on each globe
 ;------------------------------------------------
 n_objects=(size(object_ps))[1]
 _shadow_ps = ptrarr(n_globes, n_objects)
 shadow_ps = ptrarr(n_objects)

 obs_bd = class_extract(od, 'BODY')
 obs_pos = bod_pos(obs_bd)
 for j=0, n_objects-1 do $
  begin
   for i=0, n_globes-1 do $
    if((bod_opaque(gbx[i,0])) OR (keyword_set(reveal))) then $
     begin
      xd = reform(gbx[i,*], nt)
      idp = nv_extract_idp(xd)
      obj_bds = class_extract(xd, 'BODY')		; Globe i for all t.
      obj_gbds = class_extract(xd, 'GLOBE')

      ;---------------------------
      ; get object vectors
      ;---------------------------
      ps_get, object_ps[j], vectors=vectors, assoc_idp=assoc_idp
      if(idp NE assoc_idp) then $
       begin
        n_vectors = (size(vectors))[1]

        ;---------------------------------------
        ; source and ray vectors in body frame
        ;---------------------------------------
        v_inertial= obs_pos##make_array(n_vectors, val=1d)
        rr = vectors - v_inertial
        r_inertial = v_unit(rr)

        r_body = bod_inertial_to_body(obj_bds, r_inertial)
        v_body = bod_inertial_to_body_pos(obj_bds, vectors)

        ;---------------------------------
        ; project shadows in body frame
        ;---------------------------------
        shadow_pts = $
           (glb_intersect(dbldbl=dbldbl, iterate=iterate, $
                           valid=val, nosolve=nosolve, $
                            obj_gbds, v_body, r_body, dis=dis))[0:n_vectors-1,*,*]
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

          ;---------------------------------
          ; store points
          ;---------------------------------
          _shadow_ps[i,j] = $
              ps_init(points = points, $
		      desc = 'globe_shadow', $
		      input = pgs_desc_suffix(gbx=gbx[i,0], od=od[0], cd=cd[0]), $
		      vectors = inertial_pts)
 
          ;-----------------------------------------------
          ; flag points that miss the globe as invisible
          ;-----------------------------------------------
          flags = ps_flags(_shadow_ps[i,j])
          flags[*] = flags[*] OR PS_MASK_INVISIBLE
          flags[w] = 0

          ss = inertial_pts - v_inertial

          ;-----------------------------------------------------------
          ; flag backshadows as invisible unless /both or /backshadow
          ;-----------------------------------------------------------
          if((NOT keyword_set(backshadow)) AND (NOT keyword_set(both))) then $
           begin
            w = where(v_mag(ss) LE v_mag(rr))
            if(w[0] NE -1) then flags[w] = flags[w] OR PS_MASK_INVISIBLE
           end

          ;-----------------------------------------------------------
          ; flag shadows as invisible if /backshadow
          ;-----------------------------------------------------------
          if(keyword_set(backshadow)) then $
           begin
            w = where(v_mag(ss) GE v_mag(rr))
            if(w[0] NE -1) then flags[w] = flags[w] OR PS_MASK_INVISIBLE
           end

          ;-----------------------------------------------------------
          ; flag invalid image points as invisible
          ;-----------------------------------------------------------
          if(NOT keyword_set(all)) then $
           if(keyword_set(valid)) then $
            begin
             invalid = complement(shadow_pts[*,0], valid)
             if(invalid[0] NE -1) then flags[invalid] = PS_MASK_INVISIBLE
            end

          ;---------------------------------
          ; store flags
          ;---------------------------------
          ps_set_flags, _shadow_ps[i,j], flags
         end
       end
     end
 
   ;-----------------------------------------------------
   ; take only nearest shadow points for this object
   ;-----------------------------------------------------
   shadow_ps[j] = ps_compress(_shadow_ps[*,j])
   if(ptr_valid(shadow_ps[j])) then ps_set_desc, shadow_ps[j], 'globe_shadow'
;   if(NOT keyword__set(all)) then $
;    begin
;     sp = ps_cull(_shadow_ps[*,j])
;     if(keyword__set(sp)) then $
;      begin
;       if(n_elements(sp) EQ 1) then shadow_ps[j] = sp $
;       else shadow_ps[j] = pg_nearest_points(object_ps[j], sp) 
;      end
;    end
   end


 ;-------------------------------------------------------------------------
 ; by default, remove empty points structs and reform to one dimension 
 ;-------------------------------------------------------------------------
 if(NOT keyword__set(nocull)) then shadow_ps = ps_cull(shadow_ps)


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, shadow_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then shadow_ps = ps_cull(shadow_ps)
  end



 return, shadow_ps
end
;=============================================================================
