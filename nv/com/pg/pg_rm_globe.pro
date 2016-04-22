;=============================================================================
;+
; NAME:
;	pg_rm_globe
;
;
; PURPOSE:
;	Hides the given points with respect to each given globe and observer
;	at all given time steps.  Points are hidden whether the lie in front 
;	of or behind the globe.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_rm_globe, object_ps, cd=cd, od=od, gbx=gbx
;	pg_rm_globe, object_ps, gd=gd, od=od
;
;
; ARGUMENTS:
;  INPUT:
;	object_ps:	Array of points_struct containing inertial vectors.
;
;	hide_ps:	Array (n_disks, n_timesteps) of points_struct 
;			containing the hidden points.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Array (n_timesteps) of camera descriptors.
;
;	gbx:	Array (n_timesteps) of descriptors of objects 
;		which must be a subclass of GLOBE.
;
;	od:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.  These objects are used
;		as the observer from which points are hidden.  If no observer
;		descriptor is given, the camera descriptor is used.
;
;	gd:	Generic descriptor.  If given, the cd and gbx inputs 
;		are taken from the cd and gbx fields of this structure
;		instead of from those keywords.
;
;	reveal:	 Normally, objects whose opaque flag is set are ignored.  
;		 /reveal suppresses this behavior.
;
;	cat:	If set, the hide_ps points are concatentated into a single
;		points_struct.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	The flags arrays in object_ps are modified.
;
;
; PROCEDURE:
;	For each object in object_ps, hidden points are computed and
;	PS_MASK_INVISIBLE in the points_struct is set.  No points are
;	removed from the array.
;
;
; EXAMPLE:
;	The following command hides all points which are directly in front 
;	of or behind the planet as seen by the camera:
;
;	pg_rm_globe, object_ps, cd=cd, gbx=pd
;
;	In this call, pd is a planet descriptor, and cd is a camera descriptor.
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
pro pg_rm_globe, cd=cd, od=od, gbx=gbx, gd=gd, point_ps, hide_ps, $
              reveal=reveal, cat=cat
@ps_include.pro

 hide = keyword_set(hide_ps)
 if(NOT keyword_set(point_ps)) then return

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx, od=od
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(gbx)) then return

 ;-----------------------------
 ; default observer is camera
 ;-----------------------------
 if(NOT keyword_set(od)) then od=cd

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(od)
 pgs_count_descriptors, gbx, nd=n_objects, nt=nt1
 if(nt NE nt1) then nv_message, name='pg_rm_globe', 'Inconsistent timesteps.'


 ;------------------------------------
 ; hide object points for each planet
 ;------------------------------------
 n_points = n_elements(point_ps)
 if(hide) then hide_ps = ptrarr(n_points, n_objects)

 obs_bds = class_extract(od, 'BODY')
 obs_pos = bod_pos(obs_bds)
 for j=0, n_points-1 do $
  for i=0, n_objects-1 do $
   if((bod_opaque(gbx[i,0])) OR (keyword_set(reveal))) then $
    begin
     xd = reform(gbx[i,*], nt)
     obj_bds=class_extract(xd, 'BODY')			; Object i for all t.
     obj_gbds=class_extract(xd, 'GLOBE')

     Rs = bod_inertial_to_body_pos(obj_bds, obs_pos)

     ps_get, point_ps[j], p=p, vectors=vectors, flags=flags
     point_pts = bod_inertial_to_body_pos(obj_bds, vectors)

     w = glb_rm_points(obj_gbds, Rs, point_pts)

     if(hide) then $
      begin
       ps_get, point_ps[j], desc=desc, inp=inp
       hide_ps[j] = $
           ps_init(desc=desc+'-rm_globe', $
                   input=inp+pgs_desc_suffix(gbx=gbx[i,0], od=od[0], cd=cd[0]))
      end

     if(w[0] NE -1) then $
      begin
       if(hide) then $
          hide_ps[j,i] = ps_init(points=p[*,w], flags=flags[w], vectors=vectors[w,*])
       flags[w]=flags[w] OR PS_MASK_INVISIBLE
       ps_set_flags, point_ps[j], flags
      end
    end


 ;---------------------------------------------------------
 ; if desired, concatenate all hide_ps for each object
 ;---------------------------------------------------------
 if(hide AND keyword_set(cat)) then $
  begin
   for j=0, n_objects-1 do hide_ps[j,0] = ps_compress(hide_ps[j,*])
   if(n_globes GT 1) then $
    begin
     nv_free, hide_ps[*,1:*]
     hide_ps = hide_ps[*,0]
    end
  end

end
;=============================================================================
