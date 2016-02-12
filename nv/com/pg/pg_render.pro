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
;	result = pg_render(cd=cd, bx=bx, sund=sund, ddmap=dd_render, md=md)
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
;	sund:         Star descriptor for the Sun.
;
;	ddmap:        Array of data descriptors containing the body maps, 
;	              one for each body.  If not given, maps are loaded using
;		      pg_load_maps.
;
;	md:           Array of map descriptors for each ddmap.  
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
;	penumbra:     If set, lighting rays are traced to random points on 
;	              each secondary body rather then the center.
;
;	no_secondary: If set, no secondary ray tracing is performed,  
;	              resulting in no shadows.
;
;	image_ps:     points_struct or array with image points 
;	              specifying the grid to trace.  If not set, the entire 
;	              image described by cd is used.  The array can have
;	              dimensions of (2,np) or (2,nx,ny).  If the latter,
;	              the output map will have dimensions (nx,ny).  Note
;	              that a PSF cannot be applied if nx and ny are not known.
;
;	mask_width:   Width of trace mask.  Default is 512.  If set to zero, 
;	              no masking is performed.
;
;	no_maps:      If set, maps are not loaded.
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
function pg_render, cd=cd, sund=sund, $
       bx=bx, ddmap=ddmap, md=md, sample=sample, pc_size=pc_size, $
       show=show, pht_min=pht_min, no_pht=no_pht, map=image, $
       standoff=standoff, limit_source=limit_source, nodd=nodd, $
       psf=psf, npsf=npsf, penumbra=penumbra, no_secondary=no_secondary, $
       image_ps=_image_ps, mask_width=mask_width, no_maps=no_maps
 

 if(keyword_set(_image_ps)) then image_ps = _image_ps
 if(NOT keyword_set(npsf)) then npsf = 10
 if(NOT defined(mask_width)) then mask_width = 512

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, dd=dd, cd=cd, bx=bx, md=md, sund=sund


 ;---------------------------------------
 ; load maps
 ;---------------------------------------
 if(NOT keyword_set(no_maps)) then $
    if(NOT keyword_set(ddmap)) then ddmap = pg_load_maps(md=md)


 ;----------------------------------------
 ; set up grid if necessary
 ;----------------------------------------
 if(NOT keyword_set(image_ps)) then image_pts = gridgen(cam_size(cd), /rectangular) $
 else if(size(image_ps, /type) EQ 10) then image_pts = ps_points(image_ps) $
 else image_pts = image_ps


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
 if(keyword_set(mask_width)) then $
  begin
   ;- - - - - - - - - - - - - - - - -
   ; create mask
   ;- - - - - - - - - - - - - - - - -
   xmin = min(image_pts[0,*], max=xmax)
   ymin = min(image_pts[1,*], max=ymax)
   mask_cd = nv_clone(cd)
   cam_subimage, mask_cd, [xmin,ymin], [xmax-xmin+1, ymax-ymin+1]
   r = (mask_width/cam_nx(mask_cd))[0]
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
   map = render(image_pts, cd=cd, sund=sund, $
              bx=bx, ddmap=ddmap, md=md, sample=sample, pc_size=pc_size, $
              show=show, pht_min=pht_min, no_pht=no_pht, $
              standoff=standoff, limit_source=limit_source, $
              penumbra=penumbra, no_secondary=no_secondary)
 if(keyword_set(nx)) then $
  begin
   image = dblarr(nx, ny)
   if(ii[0] NE -1) then image[ii] = map
  end

 ;---------------------------------------
 ; apply PSF
 ;---------------------------------------
 if(keyword_set(psf)) then $
  if(keyword_set(nx)) then $
   begin
    dim = size(psf, /dim)
    if(dim[0] EQ 0) then psf = cam_psf(cd, npsf)

    image = convol(image, psf, /center)
   end


 ;--------------------------------------------------------------------------
 ; store rendering new data descriptor
 ;--------------------------------------------------------------------------
 if(keyword_set(nodd)) then return, 0
 return, nv_init_descriptor(instrument=cor_name(cd), data=image)
end
;=============================================================================
