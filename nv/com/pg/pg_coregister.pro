;=============================================================================
;+
; NAME:
;	pg_coregister
;
;
; PURPOSE:
;	Using the given geometry information, shifts the given images so as 
;	to center the given bodies at the same pixel in each image, or aligns
;	images based on pointing.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_coregister, dd, cd=cd, bx=bx
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Array of data descriptors giving images to shift.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Array of camera descripors, one for each input image.
;
;	bx:	Array of descriptors of any superclass of BODY, one for each
;		input image.
;
;	gd:	Generic descriptor containing the camera and body
;		descriptors or an array of generic descriptors, one for each
;		input image.
;
;	center: Image coordinates at which to center each body.  By default, 
;		the average center among all the bodies is used.  If this input
;		contains a single element, it is taken as the index of the 
;		input image to use as the reference.
;
;	p:	Array (1,3) giving surface coordinates at which to center 
;		each body.
;
;	xshift:	Additional image offset by which to shift each image.
;
;	wrap:	If set shifted pixels are wrapped to the opposite side
;		of the image.
;
;	subpixel: By default, each image is shifted by an integer number of
;		  pixels in each direction. If this keyword is set, the 
;		  image is interpolated onto a new pixel grid such that the 
;		  sub-pixel shift is obtained.  (Not currently implemented)
;
;  OUTPUT:
;	shift:	Offset applied to each image.
;
;
; SIDE EFFECTS:
;	The given data and camera descriptors are modified: the images are
;	shifted and the camera descriptor optic axes are changed accordingly.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
pro pg_coregister, dd, cd=cd, bx=bx, gd=gd, shift=shift, center=center, p=p, $
   xshift=xshift, wrap=wrap, subpixel=subpixel, no_shift=no_shift

 n = n_elements(dd)


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(dd)) then dd = dat_gd(gd, /dd)
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)


 ;-----------------------------------------------
 ; compute centers
 ;-----------------------------------------------
 if(keyword_set(p)) then $
     centers = reform(surface_to_image(cd, bx, p[linegen3z(1,3,n)]), 2,n) $
 else $
  begin
   centers = dblarr(2,n)
   for i=0, n-1 do $
    begin
     center_ptd = pg_center(cd=cd[i], bx=bx[i])
     centers[*,i] = pnt_points(center_ptd)
    end
  end


 ;-----------------------------------------------
 ; compute new center to use for each image
 ;-----------------------------------------------
 if(n_elements(center) EQ 1) then center=centers[*,center] 
 if(NOT keyword_set(center)) then center = total(centers,2)/n
 center = center#make_array(n, val=1d)


 ;-----------------------------------------------
 ; compute shifts for each image
 ;-----------------------------------------------
 if(NOT keyword_set(shift_centers)) then shift_centers = centers

 shift = center - shift_centers
 if(keyword_set(xshift)) then shift = shift + xshift
 if(NOT keyword_set(subpixel)) then shift = round(shift)


 ;--------------------------------------------------------------
 ; shift each image and change the cd accordingly
 ;--------------------------------------------------------------
; this should be redone to use image_shift for a sub-pixel shift
 fn = 'shift_image'
 if(keyword_set(wrap)) then fn = 'shift'

 for i=0, n-1 do $
  begin
   if(NOT keyword_set(no_shift)) then $
    begin
     image = call_function(fn, dat_data(dd[i]), shift[0,i], shift[1,i])
     dat_set_data, dd[i], image
    end

   cam_set_oaxis, cd[i], cam_oaxis(cd[i]) + double(shift[*,i])

   cor_add_task, cd[i], 'pg_coregister' 
  end



end
;=============================================================================
