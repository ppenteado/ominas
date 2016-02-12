;=============================================================================
;+
; NAME:
;	pg_limb
;
;
; PURPOSE:
;	Computes image points on the limb of each given globe object.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	limb_ps = pg_limb(cd=cd, gbx=gbx, ods=ods)
;	limb_ps = pg_limb(gd=gd, od=od)
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
;	gbx:	 Array (n_objects, n_timesteps) of descriptors of objects 
;		 which must be a subclass of GLOBE.
;
;	od:	 Array (n_timesteps) of descriptors of objects 
;		 which must be a subclass of BODY.  These objects are used
;		 as the observer from which limb is computed.  If no observer
;		 descriptor is given, the camera descriptor is used.
;
;	gd:	 Generic descriptor.  If given, the cd and gbx inputs 
;		 are taken from the cd and gbx fields of this structure
;		 instead of from those keywords.
;
;	npoints: Number of points to compute.  Default is 1000.
;
;	epsilon: Maximum angular error in the result.  Default is 1e-3.
;
;	reveal:	 Normally, points computed for objects whose opaque flag
;		 is set are made invisible.  /reveal suppresses this behavior.
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
;	Array (n_objects) of points_struct containing image
;	points and the corresponding inertial vectors.
;
;
; PROCEDURE:
;	By definition, the surface normal at a point on the limb of a body is
;	perpendicular to a vector from the observer to that same point, so the
;	dot product of the two vectors is zero.  This program uses an iterative
;	scheme to find points onthe surface at which this dot product is less
;	than epsilon.
;
;
; EXAMPLE:
;	The following command computes points on the planet which lie on the
;	terminator:
;
;	term_ps = pg_limb,(cd=cd, gbx=pd, od=sd)
;
;	In this call, pd is a planet descriptor, cd is a camera descriptor, 
;	and sd is a star descriptor (i.e., the sun).
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function pg_limb, cd=cd, od=od, gbx=gbx, gd=gd, fov=fov, cull=cull, $
                        npoints=npoints, epsilon=epsilon, reveal=reveal
@ps_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx, od=od
 if(NOT keyword_set(cd)) then cd = 0 

 if(NOT keyword_set(gbx)) then return, ptr_new()

 if(keyword_set(fov)) then slop = (image_size(cd[0]))[0]*(fov-1) > 1

 ;-----------------------------
 ; default observer is camera
 ;-----------------------------
 if(NOT keyword_set(od)) then od=cd

 ;-----------------------------------
 ; default iteration parameters
 ;-----------------------------------
 if(NOT keyword_set(npoints)) then npoints=1000
 if(NOT keyword_set(epsilon)) then epsilon=1e-3


 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 nt1 = n_elements(od)
 pgs_count_descriptors, gbx, nd=n_objects, nt=nt2
 if(nt NE nt1 OR nt1 NE nt2) then nv_message, name='pg_limb', $
                                                      'Inconsistent timesteps.'


 ;-----------------------------------------------
 ; contruct data set description
 ;-----------------------------------------------
 desc = 'limb'
 if((class_get(od))[0] EQ 'STAR') then desc = 'terminator'


 hide_flags = make_array(npoints, val=PS_MASK_INVISIBLE)

 ;---------------------------------------------------------
 ; get limb for each object for all times
 ;---------------------------------------------------------
 limb_ps = ptrarr(n_objects)

 obs_bd = class_extract(od, 'BODY')
 obs_pos = bod_pos(obs_bd)
 for i=0, n_objects-1 do $
  begin
   xd = reform(gbx[i,*], nt)
   gbds=class_extract(xd, 'GLOBE')			; Object i for all t.
   bds=class_extract(xd, 'BODY')

   Rs = bod_inertial_to_body_pos(bds, obs_pos)		; Source position
							; in object i's body
							; frame for all t.
   ;- - - - - - - - - - - - - - - - -
   ; fov 
   ;- - - - - - - - - - - - - - - - -
   alpha = 0
   continue = 1
   if(keyword_set(fov)) then $
    begin
     test_pts_body = glb_get_limb_points(gbds, Rs, npoints, epsilon, 1, alpha=alpha)
     test_pts_image = body_to_image_pos(cd, gbds, test_pts_body)
     w = in_image(cd, test_pts_image, slop=slop)
     if(w[0] EQ -1) then continue = 0 $
     else alpha = alpha[w]
     a0 = alpha[0] & a1 = alpha[n_elements(w)-1]
     if(a1 LT a0) then a0 = a0 - 2d*!dpi
     alpha = dindgen(npoints)/npoints * (a1-a0) + a0 - !dpi
    end

   if(continue) then $
    begin
     limb_pts = glb_get_limb_points(alpha=alpha, $	; Limb pts for planet i
                           gbds, Rs, npoints, epsilon)	; for all t.

     flags = bytarr(n_elements(limb_pts[*,0]))
     points = body_to_image_pos(cd, xd, limb_pts, inertial=inertial_pts, valid=valid)

     if(keyword__set(valid)) then $
      begin
       invalid = complement(limb_pts[*,0], valid)
       if(invalid[0] NE -1) then flags[invalid] = PS_MASK_INVISIBLE
      end

     limb_ps[i] = ps_init(name = get_core_name(bds), $
                          desc=desc, $
                          input=pgs_desc_suffix(gbx=gbx[i,0], od=od[0], cd=cd[0]), $
                          assoc_idp = nv_extract_idp(xd), $
                          points = points, $
                          flags = flags, $
                          vectors = inertial_pts)
     if(NOT bod_opaque(gbx[i,0])) then ps_set_flags, limb_ps[i], flags
    end
  end


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, limb_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then limb_ps = ps_cull(limb_ps)
  end



 return, limb_ps
end
;=============================================================================
