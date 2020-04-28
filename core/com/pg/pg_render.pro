;=============================================================================
;+
; NAME:
;	pg_render
;
;
; PURPOSE:
;	Performs rendering on an array of bodies.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_render(cd=cd, bx=bx, ltd=ltd, ddmap=dd_render, md=md)
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
;	cd:	      Camera descriptor.
;
;	bx:	      Array of object descriptors; must be a subclass of BODY.
;
;	ltd:         Star descriptor for the Sun.
;
;	md:           Array of map descriptors for each ddmap.  
;
;	gd:		Generic descriptor.  If given, the descriptor inputs 
;			are taken from this structure if not explicitly given.
;
;	dd:		Data descriptor containing a generic descriptor to use
;			if gd not given.
;
;	ddmap:        Array of data descriptors containing the body maps, 
;	              one for each body.  If not given, maps are loaded using
;		      pg_load_maps.
;
;	sample:       Amount by which to subsample pixels.
;
;	pc_size:      To save memory, the projection is performed in pieces
;	              of this size.  Default is 65536.
;
;	limit_source: If set, secondary vectors originating on a given
;	              body are not considered for targets that are the
;	              same body.  Default is on.
;
;	standoff:     If given, secondary vectors are advanced by this distance
;	              before tracing in order to avoid hitting target bodies
;	              through round-off error.
;
;	nodd:         If set, no data descrptor is produced.  The return value
;	              is zero and the rendering is returned via the IMAGE
;	              keyword.
;
;	psf:          If set, the rendering is convolved with a point-spread
;	              function.  If /psf, then the PSF is obtained via cd; if
;	              psf is a 2D array, then is is used as the PSF.
;
;	npsf:         Width of psf array to use if PSF is obtained via cd.
;	              Default is 10.
;
;	numbra:       Number of rays to trace to the secondary bodies.
;	              Default is 1.  The first ray is traced to the body
;	              center; wach additional ray is traced to a random point 
;	              within the body.
;
;	no_secondary: If set, no secondary ray tracing is performed,  
;	              resulting in no shadows.
;
;	image_ptd:    POINT or array with image points 
;	              specifying the grid to trace.  If not set, the entire 
;	              image described by cd is used.  The array can have
;	              dimensions of (2,np) or (2,nx,ny).  If the latter,
;	              the output map will have dimensions (nx,ny).  Note
;	              that a PSF cannot be applied if nx and ny are not known.
;
;	mask_width:   Width of trace mask.  Default is 512.  If set to zero, 
;	              no masking is performed.
;
;	no_mask:      If set, a mask is not used.
;
;	no_maps:      If set, maps are not loaded.
;
;	pht_min:      Minimum value to assign to photometric output.
;
;
;  OUTPUT: 
;	map:	       2-D array containing the rendered scene.
;
;
; RETURN: 
;	Data descriptor containing the rendered image.
;
;
; PROCEDURE:
;	
;
;
; EXAMPLE:
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pg_render, cd=cd, ltd=ltd, skd=skd, $
       bx=bx, ddmap=ddmap, md=md, dd=dd, gd=gd, sample=sample, pc_size=pc_size, $
       show=show, pht_min=pht_min, no_pht=no_pht, map=image, $
       standoff=standoff, limit_source=limit_source, nodd=nodd, $
       psf=psf, npsf=npsf, numbra=numbra, no_secondary=no_secondary, $
       image_ptd=_image_ptd, mask_width=mask_width, no_maps=no_maps, $
       no_mask=no_mask
 
 if(keyword_set(_image_ptd)) then image_ptd = _image_ptd
 if(NOT keyword_set(npsf)) then npsf = 10
 if(NOT defined(mask_width)) then mask_width = 512

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)
 if(NOT keyword_set(skd)) then skd = dat_gd(gd, dd=dd, /skd)
 if(NOT keyword_set(ltd)) then ltd = dat_gd(gd, dd=dd, /ltd)
 if(NOT keyword_set(md)) then md = dat_gd(gd, dd=dd, /md)


 ;---------------------------------------
 ; load maps
 ;---------------------------------------
 if(NOT keyword_set(no_maps)) then $
                if(NOT keyword_set(ddmap)) then ddmap = pg_load_maps(md=md)


 ;----------------------------------------
 ; set up grid if necessary
 ;----------------------------------------
 if(NOT keyword_set(image_ptd)) then $
                      image_pts = gridgen(cam_size(cd), /rectangular) $
 else if(size(image_ptd, /type) EQ 11) then image_pts = pnt_points(image_ptd) $
 else image_pts = image_ptd


 ;----------------------------------------
 ; determine dimensions of output map
 ;----------------------------------------
 dim = size(image_pts, /dim)
 if(total(dim) EQ 2) then nx = (ny = (nxy = 1)) $
 else if(n_elements(dim) EQ 3) then $
  begin
   nx = dim[1] & ny = dim[2]
   nxy = nx*ny
   image_pts = reform(image_pts, 2, nxy, /over)
  end
 ii = lindgen(n_elements(image_pts)/2)


 ;----------------------------------------
 ; mask rays
 ;----------------------------------------
 if(NOT keyword_set(no_mask)) then $
  if(keyword_set(mask_width)) then $
   begin
    ;- - - - - - - - - - - - - - - - -
    ; create mask
    ;- - - - - - - - - - - - - - - - -
    xmin = min(image_pts[0,*], max=xmax)
    ymin = min(image_pts[1,*], max=ymax)
    mask_cd = nv_clone(cd)
    cam_subimage, mask_cd, [xmin,ymin], [xmax-xmin+1, ymax-ymin+1]
    r = (mask_width/(cam_size(mask_cd))[0])[0]
    cam_resize, mask_cd, cam_size(mask_cd)*r
    result = pg_mask(/nodd, cd=mask_cd, bx=bx, mask=mask, pbx=2, np=100)

    ;- - - - - - - - - - - - - - - - -
    ; apply mask to ray grid
    ;- - - - - - - - - - - - - - - - -
    ray_mask_pts = inertial_to_image(mask_cd, $
                    image_to_inertial(cd, image_pts))
    ray_mask_pts = reform(ray_mask_pts, /over)

    ii = where(mask[ray_mask_pts[0,*],ray_mask_pts[1,*]] EQ 1)
    if(ii[0] NE -1) then image_pts = image_pts[*,ii]

    nv_free, mask_cd
   end



 ;---------------------------------------
 ; create the rendering
 ;---------------------------------------
 if(ii[0] NE -1) then $
   map = render(image_pts, cd=cd, ltd=ltd, skd=skd, $
              bx=bx, ddmap=ddmap, md=md, sample=sample, pc_size=pc_size, $
              show=show, pht_min=pht_min, no_pht=no_pht, $
              standoff=standoff, limit_source=limit_source, $
              numbra=numbra, no_secondary=no_secondary)
 dim = size(map, /dim)
 nz = 1
 if(n_elements(dim) EQ 2) then nz = dim[1]

 if(keyword_set(nx)) then $
  begin
   image = dblarr(nx*ny, nz)
   if(ii[0] NE -1) then image[ii,*] = map
   image = reform(image, nx, ny, nz)
   if(nz EQ 1) then image = reform(image, nx, ny)
  end

 

 ;---------------------------------------
 ; apply PSF
 ;---------------------------------------
 if(keyword_set(psf)) then $
  if(keyword_set(nx)) then $
   begin
    dim = size(psf, /dim)
    if(dim[0] EQ 0) then psf = cam_psf(cd, npsf)

    ;- - - - - - - - - - - - - - - - - -
    ; use generic psf if none found
    ;- - - - - - - - - - - - - - - - - -
    if(NOT keyword_set(psf)) then psf = gauss_2d(0,0, 1, 6,6)

    for i=0, nz-1 do image[*,*,i] = convol(image[*,*,i], psf, /center)
   end


 ;--------------------------------------------------------------------------
 ; store rendering new data descriptor
 ;--------------------------------------------------------------------------
 if(keyword_set(nodd)) then return, 0
 return, dat_create_descriptors(1, instrument=cor_name(cd), data=image)
end
;=============================================================================
