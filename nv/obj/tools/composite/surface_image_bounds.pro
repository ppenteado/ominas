;=============================================================================
;+
; NAME:
;       surface_image_bounds
;
;
; PURPOSE:
;	Computes latitude / longitude ranges visible in an image.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       surface_image_bounds, cd, bx, $
;	            latmin=latmin, latmax=latmax, lonmin=lonmin, lonmax=lonmax
;
;
; ARGUMENTS:
;  INPUT:
;	cd:      Camera descriptor
;
;	bx:      Object descriptor (subclass of BODY)
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;   INPUT:
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One per bx.
;
;	slop:	Amount, in pixels, by which to expand the image size
;		considered in the calcultaion.
;
;   OUTPUT:
;	border_pts_im:	Image points on the border of the image defined by cd.
;
;	latmin:	Minimum latitude covered in image
;
;	latmax:	Maximum latitude covered in image
;
;	lonmin:	Minimum longitude covered in image
;
;	lonmax:	Maximum longitude covered in image
;
;
; RETURN: NONE
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
pro surface_image_bounds, cd, bx, frame_bd=frame_bd, slop=slop, $
       border_pts_im=border_pts_im, $
       latmin=latmin, latmax=latmax, lonmin=lonmin, lonmax=lonmax, status=status

 gbx = cor_select(bx, 'GLOBE', /class)
 dkx = cor_select(bx, 'DISK', /class)

 if(keyword_set(gbx)) then $
   glb_image_bounds, cd, gbx, slop=slop, border_pts_im=border_pts_im, $
        latmin=latmin, latmax=latmax, lonmin=lonmin, lonmax=lonmax, status=status $
 else if(keyword_set(dkx)) then $
   dsk_image_bounds, cd, dkx, frame_bd, slop=slop, border_pts_im=border_pts_im, $
      radmin=latmin, radmax=latmax, lonmin=lonmin, lonmax=lonmax, status=status $
 else $
   radec_image_bounds, cd, slop=slop, border_pts_im=border_pts_im, $
      decmin=latmin, decmax=latmax, ramin=lonmin, ramax=lonmax, status=status

end
;===================================================================================
