;=============================================================================
;+
; NAME:
;	pg_mask
;
;
; PURPOSE:
;	Uses the given geometry to compute an image mask for all objects
;	in a scene.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	mask = pg_mask(cd=cd, gbx=gbx, dkx=dkx, bx=bx, ltd=ltd)
;	mask = pg_mask(gd=gd)
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
;	cd:	Camera descriptor.
;
;	gbx:	Globe descriptors.
;
;	dkx:	Disk descriptors.
;
;	bx:	Body descriptors (i.e. point sources).
;
;	ltd:	Body descriptor giving the light source.
;
;	gd:	Generic descriptor.  If given, the descriptor inputs 
;		are taken from this structure if not explicitly given.
;
;	dd:	Data descriptor containing a generic descriptor to use
;		if gd not given.
;
;	fgbx,fdkx,fbx:	Fractonal amount to increase the radii of each
;			descriptor type.
;
;	dgbx,ddkx,dbx:	Absolute amount, in physical units (e.g. meters), to 
;			increase the radii of each descriptor type.
;
;	pgbx,pdkx,pbx:	Absolute amount, in mask pixels, to increase the radii 
;			of each descriptor type.
;
;	nodd;    If set, no data descriptor is created.
;
;	np:      Number of points to use in computing curves.  Default is 1000.
;
;  OUTPUT:
;	limb_ptd:	POINT giving the computed limb points.
;
;	term_ptd:	POINT giving the computed terminator points.
;
;	disk_ptd:	POINT giving the computed disk points.
;
;	body_ptd:	POINT giving the computed body points.
;
;
; RETURN:
;	Data descriptor containing a byte image in which pixels corresponding 
;	to objects are set to 1.
;
;
; STATUS:
;	Complete.
;
;
; SEE ALSO:
;	pg_spikes
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 4/2004
;	
;-
;=============================================================================



;=============================================================================
; pgmsk_grow
;
;=============================================================================
function pgmsk_grow, mask, dr

 dim = size(mask, /dim)

 smask = fltarr(dim+[dr,dr]*2)
 smask[dr:dr+dim[0]-1, dr:dr+dim[1]-1] = mask
 smask = smooth(smask,dr) 
 w = where(smask GT 0)
 smask[w] = 1

 mask = smask[dr:dr+dim[0]-1, dr:dr+dim[1]-1]
 return, mask
end
;=============================================================================



;=============================================================================
; pg_mask
;
;=============================================================================
function pg_mask, mask=mask, dd=dd, gd=gd, cd=cd, gbx=gbx, dkx=dkx, bx=_bx, ltd=ltd, $
                                    fgbx=fgbx, fdkx=fdkx, fbx=fbx, $
                                    dgbx=dgbx, ddkx=ddkx, dbx=dbx, $
                                    pgbx=pgbx, pdkx=pdkx, pbx=pbx, $
      limb_ptd=limb_ptd, term_ptd=term_ptd, body_ptd=body_ptd, disk_ptd=ring_ptd, $
      nodd=nodd, np=np

 if(keyword_set(_bx)) then bx = _bx

 if(NOT keyword_set(fbx)) then fbx = 1d
 if(NOT keyword_set(fgbx)) then fgbx = fbx
 if(NOT keyword_set(fdkx)) then fdkx = fbx

 if(NOT keyword_set(dbx)) then dbx = 0d
 if(NOT keyword_set(dgbx)) then dgbx = dbx
 if(NOT keyword_set(ddkx)) then ddkx = dbx

 if(NOT keyword_set(pbx)) then pbx = 0d
 if(NOT keyword_set(pgbx)) then pgbx = pbx
 if(NOT keyword_set(pdkx)) then pdkx = pbx

 if(NOT keyword_set(np)) then np = 1000

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)
 if(NOT keyword_set(gbx)) then gbx = dat_gd(gd, dd=dd, /gbx)
 if(NOT keyword_set(dkx)) then dkx = dat_gd(gd, dd=dd, /dkx)
 if(NOT keyword_set(ltd)) then ltd = dat_gd(gd, dd=dd, /ltd)

 if(NOT keyword_set(gbx)) then gbx = cor_select(bx, 'GLOBE', /rm, /class)
 if(NOT keyword_set(dkx)) then dkx = cor_select(bx, 'DISK', /rm, /class)
 if(NOT keyword_set(bx)) then bx = 0

 scale = mean(cam_scale(cd))
 dim = cam_size(cd)


 ;-----------------------------------------------
 ; disks
 ;-----------------------------------------------
 dsk_mask = bytarr(dim)
 if(keyword_set(dkx)) then $
  begin
   dkd = nv_clone(dkx)
   ndkd = n_elements(dkd)

   ;- - - - - - - - - - - - - - - - - - - - -
   ; apply radius changes
   ;- - - - - - - - - - - - - - - - - - - - -
   v = bod_pos(dkd) - bod_pos(make_array(ndkd, val=cd))
   dist = v_mag(v)
   cos_theta = v_inner((bod_orient(dkd))[2,*,*], v_unit(v))

   sma = dsk_sma(dkd)
   sma[0,0,*] = sma[0,0,*] / fdkx
   sma[0,0,*] = sma[0,0,*] - ddkx

   sma[0,1,*] = sma[0,1,*] * fdkx
   sma[0,1,*] = sma[0,1,*] + ddkx
   
   dsk_set_sma, dkd, sma


   ;- - - - - - - - - - - - - - - - - - - - -
   ; compute mask
   ;- - - - - - - - - - - - - - - - - - - - -
   sma = (dsk_sma(dkd))[0,0,*]
   ii = rotate(sort(sma), 2)
   dkd = dkd[ii]

   ring_ptd = pg_disk(cd=cd, dkx=dkd, np=np)
   for i=0, ndkd-1 do $
    begin
     inner_pp = pnt_points(/cat, /vis, ring_ptd[2*i])
     outer_pp = pnt_points(/cat, /vis, ring_ptd[2*i+1])

     if(keyword_set(outer_pp)) then $
      begin
         ii_outer = polyfillv(outer_pp[0,*], outer_pp[1,*], dim[0], dim[1])
         if(ii_outer[0] NE -1) then dsk_mask[ii_outer] = 1
      end

     if(keyword_set(inner_pp)) then $
      begin
         ii_inner = polyfillv(inner_pp[0,*], inner_pp[1,*], dim[0], dim[1])
         if(ii_inner[0] NE -1) then dsk_mask[ii_inner] = 0
      end
    end

   dsk_mask = pgmsk_grow(dsk_mask, pdkx)

   nv_free, dkd
  end


 ;-----------------------------------------------
 ; globes
 ;-----------------------------------------------
 glb_mask = bytarr(dim)
 if(keyword_set(gbx)) then $
  begin
   gbd = nv_clone(gbx)
   ngbd = n_elements(gbd)

   ;- - - - - - - - - - - - - - - - - - - - -
   ; apply radius changes
   ;- - - - - - - - - - - - - - - - - - - - -
   dist = v_mag(bod_pos(gbd) - bod_pos(make_array(ngbd, val=cd)))

   radii = glb_radii(gbd)
   radii = radii * fgbx
   radii[*] = radii[*] + dgbx
   
   glb_set_radii, gbd, radii

   ;- - - - - - - - - - - - - - - - - - - - -
   ; compute mask
   ;- - - - - - - - - - - - - - - - - - - - -
   center_ptd = pg_center(cd=cd, bx=gbd)
   center_pts = pnt_points(/cat, /vis, center_ptd)
   cam_pos = bod_pos(cd)##make_array(ngbd, val=1d)
   rad_pix = (glb_radii(gbd))[2,*] / v_mag(cam_pos - tr(bod_pos(gbd))) $
                                                        / (cam_scale(cd))[0]

   w = where((center_pts[0,*]-rad_pix LT dim[0]) $
            AND (center_pts[0,*]+rad_pix GT 0) $
            AND (center_pts[1,*]-rad_pix LT dim[1]) $
            AND (center_pts[1,*]+rad_pix GT 0))
   nw = n_elements(w)

   if(w[0] NE -1) then $
    begin
     limb_ptd = pg_limb(cd=cd, gbx=gbd[w], np=np) 
   
     for i=0, nw-1 do $
      begin
       pp = pnt_points(limb_ptd[i], /vis)
       ii = polyfillv(pp[0,*], pp[1,*], dim[0], dim[1])
       if(ii[0] NE -1) then glb_mask[ii] = 1
      end

     if(keyword_set(ltd)) then $
      begin
       pg_hide, /assoc, limb_ptd, bx=gbd[w], od=ltd

       term_ptd = pg_limb(cd=cd, od=ltd, gbx=gbd[w])
       pg_hide, /assoc, term_ptd, bx=gbd[w], cd=cd

       for i=0, nw-1 do $
        begin
         p = pnt_points([limb_ptd[i], term_ptd[i]], /vis)
         pp = poly_rectify(p)
         ii = polyfillv(pp[0,*], pp[1,*], dim[0], dim[1])
         if(ii[0] NE -1) then glb_mask[ii] = 1
        end
      end
    end

   glb_mask = pgmsk_grow(glb_mask, pgbx)

   nv_free, gbd

   ;-----------------------------------------------
   ; add any sub-pixel objects back to the bx list
   ;-----------------------------------------------
   w = where(rad_pix LT 1)
   if(w[0] NE -1) then bx = append_array(bx, gbx[w])
  end


 ;-----------------------------------------------
 ; point sources
 ;-----------------------------------------------
 bx_mask = bytarr(dim)
 if(keyword_set(bx)) then $
  begin
   bd = nv_clone(bx)
   nbd = n_elements(bd)

   ;- - - - - - - - - - - - - - - - - - - - -
   ; apply radius changes
   ;- - - - - - - - - - - - - - - - - - - - -
   dist = v_mag(bod_pos(bd) - bod_pos(make_array(nbd, val=cd)))

   radii = dblarr(nbd)
   radii[*] = pbx
   
   ;- - - - - - - - - - - - - - - - - - - - -
   ; compute mask
   ;- - - - - - - - - - - - - - - - - - - - -
   body_ptd = pg_center(cd=cd, bx=bd)
   body_pts = pnt_points(/cat, /vis, body_ptd)

   w = in_image(cd, body_pts, slop=1)
   nw = n_elements(w)

   if(w[0] NE -1) then $
    for i=0, nw-1 do $
     begin
      pp = circle(body_pts[*,w[i]], radii[w[i]])
      ii = polyfillv(pp[0,*], pp[1,*], dim[0], dim[1])
      if(ii[0] NE -1) then bx_mask[ii] = 1
     end

   nv_free, bd
  end


 ;-----------------------------------------------
 ; consolidate masks
 ;-----------------------------------------------
 mask = (dsk_mask + glb_mask + bx_mask)<1



 ;-----------------------------------------------
 ; set up data descriptor
 ;-----------------------------------------------
 if(keyword_set(nodd)) then return, mask

 dd_mask = dat_create_descriptors(1, data=mask)
 return, dd_mask
end
;=============================================================================
