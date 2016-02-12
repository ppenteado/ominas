;=============================================================================
;+
; NAME:
;	pg_hide_disk
;
;
; PURPOSE:
;	Hides the given points with respect to each given disk and observer.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_hide_disk, object_ps, cd=cd, od=od, dkx=dkx, gbx=gbx
;	pg_hide_disk, object_ps, gd=gd, od=od
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
;	dkx:	Array (n_disks, n_timesteps) of descriptors of objects 
;		which must be a subclass of DISK.
;
;	gbx:	Array  of descriptors of objects which must be a subclass 
;		of GLOBE, describing the primary body for dkx.  For each
;		timestep, only the first descriptor is used.
;
;	od:	Array (n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.  These objects are used
;		as the observer from which points are hidden.  If no observer
;		descriptor is given, the camera descriptor is used.
;
;	gd:	Generic descriptor.  If given, the cd and dkx inputs 
;		are taken from the cd and dkx fields of this structure
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
;	The following command hides all points which are behind the rings as
;	seen by the camera:
;
;	pg_hide_disk, object_ps, cd=cd, dkx=rd
;
;	In this call, rd is a ring descriptor, and cd is a camera descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_hide, pg_hide_globe, pg_hide_limb
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	7/2004:		Added gbx input; Spitale
;	
;-
;=============================================================================
pro pg_hide_disk, cd=cd, od=od, dkx=dkx, gbx=_gbx, gd=gd, object_ps, hide_ps, $
              reveal=reveal, cat=cat
@ps_include.pro

 hide = keyword_set(hide_ps)
 if(NOT keyword_set(object_ps)) then return

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, dkx=dkx, od=od, gbx=_gbx
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(dkx)) then return

 if(NOT keyword_set(_gbx)) then $
            nv_message, name='pg_hide_disk', 'Globe descriptor required.'
 __gbx = get_primary(cd, _gbx, rx=dkx)
 if(keyword_set(__gbx[0])) then gbx = __gbx $
 else gbx = _gbx[0,*]

 ;-----------------------------
 ; default observer is camera
 ;-----------------------------
 if(NOT keyword_set(od)) then od=cd

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(od)
 pgs_count_descriptors, dkx, nd=n_disks, nt=nt1
 if(nt NE nt1) then nv_message, name='pg_hide_disk', 'Inconsistent timesteps.'

 ;------------------------------------
 ; hide object points for each ring
 ;------------------------------------
 n_objects = n_elements(object_ps)
 if(hide) then hide_ps = ptrarr(n_objects, n_disks)

 obs_bds = class_extract(od, 'BODY')
 obs_pos = bod_pos(obs_bds)
 for j=0, n_objects-1 do $
  for i=0, n_disks-1 do $
   if((bod_opaque(dkx[i,0])) OR (keyword_set(reveal))) then $
    begin
     ii = dsk_valid_edges(dkx[i,*], /all)
     if(ii[0] NE -1) then $
      begin
       xd = reform(dkx[i,ii], nt)
       obj_bds=class_extract(xd, 'BODY')			; Object i for all t.
       obj_dkd=class_extract(xd, 'DISK')

       Rs = bod_inertial_to_body_pos(obj_bds, obs_pos)

       ps_get, object_ps[j], p=p, vectors=vectors, flags=flags
       object_pts = bod_inertial_to_body_pos(obj_bds, vectors)

       w = dsk_hide_points(obj_dkd, Rs, object_pts, frame_bd=gbx)

     if(hide) then $
      begin
       ps_get, object_ps[j], desc=desc, inp=inp
       hide_ps[j,i] = $
          ps_init(desc=desc+'-hide_disk', $
             input=inp+pgs_desc_suffix(dkx=dkx[i,0], gbx=gbx[0], od=od[0], cd=cd[0]))
      end

       if(w[0] NE -1) then $
        begin
         if(hide) then $
           ps_set, hide_ps[j,i], p=p[*,w], flags=flags[w], vectors=vectors[w,*]
         flags[w]=flags[w] OR PS_MASK_INVISIBLE
         ps_set_flags, object_ps[j], flags
        end
      end
    end


 ;---------------------------------------------------------
 ; if desired, concatenate all hide_ps for each object
 ;---------------------------------------------------------
 if(hide AND keyword_set(cat)) then $
  begin
   for j=0, n_objects-1 do hide_ps[j,0] = ps_compress(hide_ps[j,*])
   if(n_disks GT 1) then $
    begin
     nv_free, hide_ps[*,1:*]
     hide_ps = hide_ps[*,0]
    end
  end

end
;=============================================================================
