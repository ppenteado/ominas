;=======================================================================
;                            VOYAGER-PN_EXAMPLE.PRO
;
;  The example requires the voyager SEDR files, which are not supplied 
;  in the default OMINAS installation.
;
;  This example file demonstrates the use of OMINAS for Voyager image 
;  geometric corrections using a polynomial camera transformation.  Compared
;  with the control-point approach, this method has the advantage that
;  the derived camera transformation can be used directly with the
;  raw image without the need for a geometric correction.  The disadvantage
;  is that it may not be as precise as the control-point approach.
;
;  This example file can be executed from the UNIX command line using
;
;  	ominas voyager-pn_example.pro
;
;  or from within IDL using
;
;  	@voyager_pn_example
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
; Because the image has not yet been corrected, the SEDR translator 
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
; scan for reseau marks
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
; Fit a polynomial camera transformation
;
; This call uses the known focal positions and the scanned image
; coordinates to fit forward and inverse polynomial camera transformations.
; A new camera descriptor is generated describing the derived 
; transformation.
;
; Note that res_ptd outputs the nominal image coordinates under the new
; transformation.
;
;--------------------------------------------------------------------------
pg_resfit, scan_ptd, foc_ptd, 4, nom_ptd=nom_ptd, cd=cd, res_ptd=res_ptd
pg_draw, res_ptd, psym=7


;============================================================================
; Remove reseau marks
;
; Reseaus are 'removed' by interpolating over circular regions centered
; at each reseau.  In this example, reseaus are first removed using the 
; scanned coordinates (which are precise, but not necessarily complete) 
; and then using the nominal positions in the new image coordinate system 
; (which are more scattered, but complete).
;
;============================================================================
dd1 = pg_blemish(dd, [scan_ptd,res_ptd], im=im1)
tvim, im1, /order, /new, z=zoom


;============================================================================
; Remove fiducial marks
;
; Fiducial marks are 'removed' in the same way as reseaus, except that 
; an elliptical model (with semimajor axis fa, semiminor axis fb, and
; orientation fh) is used instead of a circular one.  In this example,
; the locations and orientations of the fiducial marks are made up to 
; work for this particular image, but there ought to be a file somewhere
; that gives the correct positions for the camera of interest.  
;
;============================================================================
fp = [[755,10], $
      [10,747], $
      [755,790], $
      [795,753], $
      [55,791], $
      [55,7], $
      [10,46]]
fa = 32 & fb = 7
fh = [2d, 88d, -2d, -87d, 2d, -1d, -85d]*!dpi/180d
nf = n_elements(fh)

dd2 = nv_clone(dd1)
for i=0, nf-1 do dd2 = pg_blemish(dd2, fp[*,i], im=im2, a=fa, b=fb, h=fh[i])
tvim, im2


;============================================================================
; reproject image on linear scale
;
; Using the new camera transformation, a new image is projected with a 
; linear scale and a corresponding camera descriptor is created.
;
;============================================================================
dd3 = pg_linearize_image(dd2, cd_new, cd=cd, im=im3, size=[1000,1000], $
                 oaxis=[499.,499.], scale=[7.8586540e-06,7.8586540e-06])

tvim, im3, /order, /new, z=zoom
; foc_pts = pnt_points(foc_ptd)
; foc_pts_image = cam_focal_to_image(cd_new, foc_pts)
; plots, foc_pts_image[*,*,0], psym=6



stop
dd1 = dat_read('./data/c3440346.gem', _im3, label)
tvim, _im3
grim, dd3, dd1


