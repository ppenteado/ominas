;=============================================================================
;+
; NAME:
;       get_ring_profile_outline_oblique
;
;
; PURPOSE:
;       Generates an outline of an oblique ring sector.
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;	result = get_ring_profile_outline_oblique(cd, dkx, points, point)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	gbx:	Globe descriptor.
;
;	points:	Array (2,2) of image points defining corners at opposite ends
;		on one side of the sector.
;
;	point:	Image point defining and third corner.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nrad:	Number of points in the radial direction.
;
;	nlon:	Number of points in the longitudinal direction.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array of image points defining the outline of the sector.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 8/2006
;
;-
;=============================================================================
function get_ring_profile_outline_oblique, cd, dkx, points, point, $
       dir=dir, nrad=nrad, nlon=nlon

; see get_ring_profile_outline to solve wrap-around problem

 ;------------------------------------------------
 ; get coords of corners
 ;------------------------------------------------
 dsk_pts = image_to_disk(cd, dkx, points)
 dsk_pt0 = dsk_pts[0,*]
 dsk_pt1 = dsk_pts[1,*]

 dsk_pt = image_to_disk(cd, dkx, point)

 ;- - - - - - - - - - - - - - - - - - - -
 ; initial point
 ;- - - - - - - - - - - - - - - - - - - -
 base0 = points[*,0]
 dsk_pt_base0 = dsk_pt0
 lon_base0 = dsk_pt_base0[1]
 rad_base = dsk_pt_base0[0]		; = dsk_pt_base1[0]

 ;- - - - - - - - - - - - - - - - - - - -
 ; current point
 ;- - - - - - - - - - - - - - - - - - - -
 curr = point
 top1 = curr
 dsk_pt_top1 = dsk_pt
 lon_top1 = dsk_pt_top1[1]

 ;- - - - - - - - - - - - - - - - - - - -
 ; the point "radial" from base0
 ;- - - - - - - - - - - - - - - - - - - -
 top0 = points[*,1]
 dsk_pt_top0 = dsk_pt1
 lon_top0 = dsk_pt_top0[1]
 rad_top = dsk_pt_top0[0]			; = dsk_pt_top1[0]

 ;- - - - - - - - - - - - - - - - - - - -
 ; the point "azimuthal" from base0
 ;- - - - - - - - - - - - - - - - - - - -
 dlon = lon_top1 - lon_top0
 lon_base1 = lon_base0 + dlon
 dsk_pt_base1 = tr([rad_base, lon_base1, 0d])
 base1 = reform(disk_to_image(cd, dkx, dsk_pt_base1))

 ;------------------------------------------------
 ; generate sides of outline
 ;------------------------------------------------
 lon_pts_top = dindgen(nlon)/(nlon-1)*dlon + lon_top0
 lon_pts_base = dindgen(nlon)/(nlon-1)*dlon + lon_base0

 dsk_pts_top = tr([tr(make_array(nlon, val=rad_top)), $
                  tr(lon_pts_top), $
                  tr(make_array(nlon, val=0d))])

 dsk_pts_base = tr([tr(make_array(nlon, val=rad_base)), $
                     tr(lon_pts_base), $
                     tr(make_array(nlon, val=0d))])

 im_pts_lon_top = reform(disk_to_image(cd, dkx, dsk_pts_top))
 im_pts_lon_base = reform(disk_to_image(cd, dkx, dsk_pts_base))

 im_pts_rad_0 = [tr(dindgen(nrad)/(nrad-1)*(top0[0]-base0[0]) + base0[0]), $
                 tr(dindgen(nrad)/(nrad-1)*(top0[1]-base0[1]) + base0[1])]

 dsk_pts_rad_0 = image_to_disk(cd, dkx, im_pts_rad_0)
 lon_pts_rad_0 = dsk_pts_rad_0[*,1]
 rad_pts_rad_0 = dsk_pts_rad_0[*,0]
 lon_pts_rad_1 = lon_pts_rad_0 + (lon_base1 - lon_base0)
 dsk_pts_rad_1 = dblarr(nrad,3)
 dsk_pts_rad_1[*,0] = rad_pts_rad_0 
 dsk_pts_rad_1[*,1] = lon_pts_rad_1 
 im_pts_rad_1 = disk_to_image(cd, dkx, dsk_pts_rad_1)


 ;------------------------------------------------
 ; construct outline
 ;------------------------------------------------
 outline_pts = dblarr(2,2*(nlon+nrad))
 outline_pts[0,*] = [tr(im_pts_lon_base[0,*]), $
                     tr(im_pts_rad_1[0,*]), $
                     tr(rotate(im_pts_lon_top[0,*],2)), $
                     tr(rotate(im_pts_rad_0[0,*],2))]
 outline_pts[1,*] = [tr(im_pts_lon_base[1,*]), $
                     tr(im_pts_rad_1[1,*]), $
                     tr(rotate(im_pts_lon_top[1,*],2)), $
                     tr(rotate(im_pts_rad_0[1,*],2))]

 return, outline_pts
end
;===========================================================================



