;=============================================================================
;+
; NAME:
;	pg_linearize_image
;
;
; PURPOSE:
;	Reprojects an image onto a linear scale.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_linearize_image(dd, new_cd, cd=cd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor containing image to be reprojected.
;
;  OUTPUT:
;	new_cd:	Camera descriptor corresponding to the reprojected image.
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Camera descriptor describing the image to be reprojected.
;
;	gd:	Generic descriptor containing the above descriptor.
;
;	scale:	2-element array giving the camera scale (radians/pixel) 
;		in each direction for the reprojected image.  If not given, the
;		scale of the input image is used.
;
;	oaxis:	2-element array giving the image coordinates of the optic axis
;		in the reprojected image.  If not given, the center of
;		the reprojected image is used.
;
;	size:	2-element array giving the size of the reprojected image.  If
;		not given, the size of the input image is used.
;
;	pc_xsize: X-Size of each image piece.  Default is 200 pixels.
;
;	pc_xsize: Y-Size of each image piece.  Default is 200 pixels.
;
;	fcp:	Focal coordinates of known reseau locations.
;
;	scp:	Image coordinates in input image of detected reseau marks
;		corresponding to those given by nmp.
;
;	interp:	Type of interpolation to use.  Options are:
;		'nearest', 'mean', 'bilinear', 'cubic', 'sinc'.
;
;  OUTPUT:
;	image:	The output image, which is also placed in the data descriptor.
;
;
; RETURN:
;	Data descriptor containing the reprojected image.
;
;
; PROCEDURE:
;	The input image is divided into pieces and tranformed one piece at 
;	a time.  There are two modes of operation: If nmp and scp are
;	given, then the image is transformed using them as control points.
;	Otherwise, the image is transformed using whatever camera transformation
;	is specified in the camera descriptor.
;
;
; STATUS:
;	Control-point scheme not yet implemented.
;
;
; SEE ALSO:
;	pg_resfit, pg_resloc
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2002
;	
;-
;=============================================================================
function pg_linearize_image, dd, new_cd, cd=cd, gd=gd, $
                   fcp=fcp, scp=scp, $
                   scale=scale, oaxis=oaxis, $
                   size=size, pc_xsize=pc_xsize, pc_ysize=pc_ysize, $
                   image=new_image, interp=interp

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, dd=dd

 ;---------------------------------------
 ; dereference the data descriptor
 ;---------------------------------------
 image = dat_data(dd)
 s = size(image)

 ;---------------------------------------
 ; set default values
 ;---------------------------------------
 if(NOT keyword__set(scale)) then scale = cam_scale(cd)
 if(NOT keyword__set(size)) then size = s[1:2]
 if(NOT keyword__set(oaxis)) then oaxis = double(size)/2d
 if(NOT keyword__set(pc_xsize)) then pc_xsize = 200
 if(NOT keyword__set(pc_ysize)) then pc_ysize = 200

 ;---------------------------------------
 ; construct new camera descriptor
 ;---------------------------------------
 new_cd = nv_clone(cd)
 cam_set_scale, new_cd, scale
 cam_set_oaxis, new_cd, oaxis
 cam_set_fn_focal_to_image, new_cd, 'cam_focal_to_image_linear'
 cam_set_fn_image_to_focal, new_cd, 'cam_image_to_focal_linear'
 cor_add_task, new_cd, 'pg_linearize_image'



 ;---------------------------------------
 ; reproject image
 ;---------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; use camera transformation if no control points given
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if((NOT keyword__set(fcp)) OR (NOT keyword__set(scp))) then $
                 new_image = reproject_image(image, cd=cd, new_cd=new_cd, $
                                size=size, pc_xsize, pc_ysize, interp=interp) $
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; otherwise use control points
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - -
   ; get coords of known reseaus in output image
   ;- - - - - - - - - - - - - - - - - - - - - - -
   foc_pts_focal = pnt_points(fcp)
   nfp = n_elements(foc_pts_focal)/2
   foc_pts = cam_focal_to_image(new_cd, foc_pts_focal)
   foc_pts = reform(foc_pts, 2, nfp, /over)

   scan_pts = pnt_points(scp)

   ;- - - - - - - - - - - - - - 
   ; reproject
   ;- - - - - - - - - - - - - - 
;   new_image = warp_cp(image, foc_pts, scan_pts, size=size, /quad, interp=interp)
   new_image = warp_tri(foc_pts[0,*], foc_pts[1,*], $
                        scan_pts[0,*], scan_pts[1,*], image, out=size, /qu)

  end


 new_dd = nv_clone(dd)
 dat_set_data, new_dd, new_image

 return, new_dd
end
;=============================================================================
