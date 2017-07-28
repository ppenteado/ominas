;=======================================================================
;                            VOYAGER_CP_EXAMPLE.PRO
;  
;  This example file demonstrates the use of OMINAS for Voyager image 
;  geometric corrections using control points.  Compared with the 
;  polynomial approach, this method is probably more precise (it forces 
;  the control points to match exactly), but it requires the image to be
;  geometrically corrected.
;
;  This example file can be executed from the UNIX command line using
;
;  	ominas voyager-cp_example.pro
;
;  or from within IDL using
;
;  	@voyager_cp_example
;
;=======================================================================
!quiet = 1
;=======================================
; read and display a voyager image
;=======================================
zoom = 0.75

dd = dat_read('./data/c3440346.img', im, label)

ctmod
tvim, im, zoom=zoom, /order, /new

;========================================================================
; Get a camera descriptor.  
;
; Because the image has not yet been corrected, the translator 
; returns a camera descriptor that approximates the camera transformation 
; using a linear scale.
; 
;========================================================================
cd = pg_get_cameras(dd)


;============================================================================
; Determine more precise camera transformation  
;
;============================================================================

;--------------------------------------------------------------------------
; Scan for reseau marks
;
; The image is scanned for features matching a gaussian reseau model 
; (other models may be input to pg_resloc if desired).  
;
;--------------------------------------------------------------------------
scan_ptd = pg_resloc(dd)
pg_draw, scan_ptd, psym=1, col=ctyellow()

;--------------------------------------------------------------------------
; Read known focal coords and nominal image coords.
;
; Note that the known reseau positions are given in the FOCAL 
; coordinate system because it is linear and not affected by the
; camera transformation that we are trying to derive.  
;
; The nominal will be used with pg_resfit to substitute for reseau that 
; cannot be found in the image.
;
;--------------------------------------------------------------------------
foc_ptd = readrob('data/vgr1na.rob')
nom_ptd = readres('data/vgr1na.res')

;--------------------------------------------------------------------------
; Associate known reseau marks with scanned locations
;
; /assoc causes pg_resfit to return before performing the polynomial fit, 
; which will not be needed here.  Instead, we will use the output arrays
; fcp and scp, which give the associated known reseaus and scanned 
; locations.
;
;--------------------------------------------------------------------------
pg_resfit, scan_ptd, foc_ptd, nom_ptd=nom_ptd, cd=cd, fcp=fcp, scp=scp, /assoc

;============================================================================
; reproject image on linear scale
;
; Using the new camera transformation, a new image is projected with a 
; linear scale and a corresponding camera descriptor is created.
;
;============================================================================
dd3 = pg_linearize_image(dd, cd_new, cd=cd, fcp=fcp, scp=scp, im=im3, $
                 size=[1000,1000], $
                 oaxis=[499.,499.], scale=[7.8586540e-06,7.8586540e-06])

tvim, im3, /order, /new, z=zoom
; foc_pts = pnt_points(foc_ptd)
; foc_pts_image = cam_focal_to_image(cd_new, foc_pts)
; plots, foc_pts_image[*,*,0], psym=6



stop
dd1 = dat_read('./data/c3440346.gem', _im3, label)
tvim, _im3
grim, dd3, dd1


