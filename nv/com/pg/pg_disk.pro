;=============================================================================
;+
; NAME:
;	pg_disk
;
;
; PURPOSE:
;	Computes image points on the inner and outer edges of each given disk
;	object at all given time steps.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_disk(cd=cd, dkx=dkx)
;	result = pg_disk(gd=gd)
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
;	cd:	 Array (n_timesteps) of camera descriptors.
;
;	dkx:	 Array (n_objects, n_timesteps) of descriptors of objects 
;		 which must be a subclass of DISK.
;
;	gd:	 Generic descriptor.  If given, the descriptor inputs 
;		 are taken from the this structure.
;
;	inner/outer: If either of these keywords are set, then only
;	             that edge is computed.
;
;	npoints: Number of points to compute around each edge.  Default is
;		 1000.
;
;	reveal:	 Normally, points computed for objects whose opaque flag
;		 is set are made invisible.  /reveal suppresses this behavior.
;
;	fov:	 If set points are computed only within this many camera
;		 fields of view.
;
;	cull:	 If set, POINT objects excluded by the fov keyword
;		 are not returned.  Normally, empty POINT objects
;		 are returned as placeholders.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (2*n_objects) of POINT containing image points and
;	the corresponding inertial vectors.  The output array is arranged as
;	[inner, outer, inner, outer, ...] in the order that the disk
;	descriptors are given in the dkx argument.
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
function pg_disk, cd=cd, dkx=dkx, gd=gd, fov=fov, cull=cull, $
                  inner=inner, outer=outer, npoints=npoints, reveal=reveal
@pnt_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, dkx=dkx
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(dkx)) then return, obj_new()

 ;-----------------------------------
 ; default parameters
 ;-----------------------------------
 if(NOT keyword_set(npoints)) then npoints=1000
 both = (NOT keyword_set(inner) AND NOT keyword_set(outer))
 inner = keyword_set(inner) OR keyword_set(both)
 outer = keyword_set(outer) OR keyword_set(both)

 if(keyword_set(fov)) then slop = (cam_size(cd[0]))[0]*(fov-1) > 1

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 pgs_count_descriptors, dkx, nd=n_disks, nt=nt1
 if(nt NE nt1) then nv_message, 'Inconsistent timesteps.'


 hide_flags = make_array(npoints, val=PTD_MASK_INVISIBLE)


 ;-----------------------------------------------------------------------
 ; get all disk outer edges
 ;-----------------------------------------------------------------------
 if(keyword_set(outer)) then $
  begin
   outer_disk_ptd = objarr(n_disks)

   for i=0, n_disks-1 do $
    begin
     ii = dsk_valid_edges(dkx[i,*], /outer)
     if(ii[0] NE -1) then $
      begin
       xd = reform(dkx[i,ii], nt)

       ;- - - - - - - - - - - - - - - - -
       ; fov 
       ;- - - - - - - - - - - - - - - - -
       ta = 0
       continue = 1
       if(keyword_set(fov)) then $
        begin
         dsk_image_bounds, cd, xd, slop=slop, /plane, $
                 lonmin=lonmin, lonmax=lonmax, border_pts_im=border_pts_im
         if(NOT defined(lonmin)) then continue = 0 $
         else ta = dindgen(npoints)/double(npoints-1)*(lonmax-lonmin) + lonmin
        end

       ;- - - - - - - - - - - - - - - - -
       ; compute edge points
       ;- - - - - - - - - - - - - - - - -
       if(continue) then $
        begin
         disk_pts = dsk_get_outer_disk_points(xd, npoints, ta=ta)
         inertial_pts = bod_body_to_inertial_pos(xd, disk_pts)
         image_pts = cam_focal_to_image(cd, $
                       cam_body_to_focal(cd, $
                         bod_inertial_to_body_pos(cd, inertial_pts)))

         outer_disk_ptd[i] = $
            pnt_create_descriptors(name = cor_name(xd) + '-OUTER', $
		    desc = 'disk_outer', $
;		    input = pgs_desc_suffix(dkx=dkx[i,0], gbx=gbx[0], cd[0]), $
		    input = pgs_desc_suffix(dkx=dkx[i,0], cd[0]), $
		    assoc_xd = xd, $
		    points = image_pts, $
		    vectors = inertial_pts)

         if(NOT bod_opaque(dkx[i,0])) then $
                        pnt_set_flags, outer_disk_ptd[i], hide_flags
        end
      end
    end
  end


 ;--------------------------------------------------------------------------
 ; get all disk inner edges
 ;--------------------------------------------------------------------------
 if(keyword_set(inner)) then $
  begin
   inner_disk_ptd = objarr(n_disks)

   for i=0, n_disks-1 do $
    begin
     ii = dsk_valid_edges(dkx[i,*], /inner)
     if(ii[0] NE -1) then $
      begin
       xd = reform(dkx[i,ii], nt)

       ;- - - - - - - - - - - - - - - - -
       ; fov 
       ;- - - - - - - - - - - - - - - - -
       ta = 0
       continue = 1
       if(keyword_set(fov)) then $
        begin
         dsk_image_bounds, cd, xd, slop=slop, /plane, $
               lonmin=lonmin, lonmax=lonmax, border_pts_im=border_pts_im
         if(NOT defined(lonmin)) then continue = 0 $
         else ta = dindgen(npoints)/double(npoints-1)*(lonmax-lonmin) + lonmin
        end

       ;- - - - - - - - - - - - - - - - -
       ; compute edge points
       ;- - - - - - - - - - - - - - - - -
       if(continue) then $
        begin
         disk_pts = dsk_get_inner_disk_points(xd, npoints, ta=ta)
         inertial_pts = bod_body_to_inertial_pos(xd, disk_pts)
         image_pts = cam_focal_to_image(cd, $
                       cam_body_to_focal(cd, $
                         bod_inertial_to_body_pos(cd, inertial_pts)))

         inner_disk_ptd[i] = $
            pnt_create_descriptors(name = cor_name(xd) + '-INNER', $
		    desc = 'disk_inner', $
;		    input = pgs_desc_suffix(dkx=dkx[i,0], gbx=gbx[0], cd[0]), $
		    input = pgs_desc_suffix(dkx=dkx[i,0], cd[0]), $
		    assoc_xd = xd, $
		    points = image_pts, $
		    vectors = inertial_pts)
         if(NOT bod_opaque(dkx[i,0])) then $
                                 pnt_set_flags, inner_disk_ptd[i], hide_flags
        end
      end
    end
  end


 ;--------------------
 ; concatenate disks
 ;--------------------
 if(NOT keyword__set(inner)) then disk_ptd=outer_disk_ptd $
 else if(NOT keyword__set(outer)) then disk_ptd=inner_disk_ptd $
 else $
  begin
   ii = 2*lindgen(n_disks)
   disk_ptd = objarr(2*n_disks)
   disk_ptd[ii] = inner_disk_ptd
   disk_ptd[ii+1] = outer_disk_ptd
  end


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, disk_ptd, cd=cd[0], slop=slop
   if(keyword_set(cull)) then disk_ptd = pnt_cull(disk_ptd)
  end


 return, disk_ptd
end
;=============================================================================
