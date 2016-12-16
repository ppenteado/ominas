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
;	pg_hide_disk, object_ptd, cd=cd, od=od, dkx=dkx, gbx=gbx
;	pg_hide_disk, object_ptd, gd=gd, od=od
;
;
; ARGUMENTS:
;  INPUT:
;	object_ptd:	Array of POINT containing inertial vectors.
;
;	hide_ptd:	Array (n_disks, n_timesteps) of POINT 
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
;	cat:	If set, the hide_ptd points are concatentated into a single
;		POINT.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	The flags arrays in object_ptd are modified.
;
;
; PROCEDURE:
;	For each object in object_ptd, hidden points are computed and
;	PTD_MASK_INVISIBLE in the POINT is set.  No points are
;	removed from the array.
;
;
; EXAMPLE:
;	The following command hides all points which are behind the rings as
;	seen by the camera:
;
;	pg_hide_disk, object_ptd, cd=cd, dkx=rd
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
pro pg_hide_disk, cd=cd, od=od, dkx=dkx, gbx=_gbx, gd=gd, object_ptd, hide_ptd, $
              reveal=reveal, cat=cat
@pnt_include.pro

 hide = keyword_set(hide_ptd)
 if(NOT keyword_set(object_ptd)) then return

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, dkx=dkx, od=od, gbx=_gbx
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(dkx)) then return

 if(NOT keyword_set(_gbx)) then nv_message, 'Globe descriptor required.'
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
 if(nt NE nt1) then nv_message, 'Inconsistent timesteps.'

 ;------------------------------------
 ; hide object points for each ring
 ;------------------------------------
 n_objects = n_elements(object_ptd)
 if(hide) then hide_ptd = objarr(n_objects, n_disks)

 obs_pos = bod_pos(od)
 for j=0, n_objects-1 do if(obj_valid(object_ptd[j])) then $
  for i=0, n_disks-1 do $
   if((bod_opaque(dkx[i,0])) OR (keyword_set(reveal))) then $
    begin
     ii = dsk_valid_edges(dkx[i,*], /all)
     if(ii[0] NE -1) then $
      begin
       xd = reform(dkx[i,ii], nt)

       Rs = bod_inertial_to_body_pos(xd, obs_pos)

       pnt_get, object_ptd[j], p=p, vectors=vectors, flags=flags
       object_pts = bod_inertial_to_body_pos(xd, vectors)

       w = dsk_hide_points(xd, Rs, object_pts)

      if(w[0] NE -1) then $
       begin
        _flags = flags
        _flags[w] = _flags[w] OR PTD_MASK_INVISIBLE
        pnt_set_flags, object_ptd[j], _flags
       end

      if(hide) then $
       begin
        hide_ptd[j,i] = nv_clone(object_ptd[j])

        pnt_get, object_ptd[j], desc=desc, inp=inp

        ww = complement(flags, w)
        _flags = flags
        if(ww[0] NE -1) then _flags[ww] = _flags[ww] OR PTD_MASK_INVISIBLE

        pnt_set, hide_ptd[j,i], desc=desc+'-hide_disk', $
             input=inp+pgs_desc_suffix(dkx=dkx[i,0], gbx=gbx[0], od=od[0], cd[0]), flags=_flags
       end
      end
    end


 ;---------------------------------------------------------
 ; if desired, concatenate all hide_ptd for each object
 ;---------------------------------------------------------
 if(hide AND keyword_set(cat)) then $
  begin
   for j=0, n_objects-1 do hide_ptd[j,0] = pnt_compress(hide_ptd[j,*])
   if(n_disks GT 1) then $
    begin
     nv_free, hide_ptd[*,1:*]
     hide_ptd = hide_ptd[*,0]
    end
  end

end
;=============================================================================
