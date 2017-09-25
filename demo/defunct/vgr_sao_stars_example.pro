; docformat = 'rst rst'
;+
;
; :Private:
;
;-

; docformat = 'rst'
;==============================================================================
;+
; Star fitting example
; ====================
;
; This example requires a star catalog. The options are: UCAC4, UCACT,
; TYCHO2, SAO, and GSC2. To learn more about where to obtain these
; catalogs, please see the documentation for the star catalog translators,
; `strcat_ucac4_input`, `strcat_ucact_input`, `strcat_tycho2_input`, 
; `strcat_sao_input`, and `strcat_gsc2_input`.
;
; In this script, the star fitting capabilities of OMINAS will be demonstrated.
;
; This example file can be executed from the UNIX command line using::
;
;  ominas vgr_sao_stars_example
;
; or from within an OMINAS IDL session using::
;
;  @vgr_sao_stars_example
;
; After the example stops, later code samples in this file may be executed by
; pasting them onto the IDL command line.
;-
;==============================================================================
!quiet = 1
;-------------------------------------------------------------------------
;+
; Image read and display
; ======================
;
; This first section uses `dat_read` to read in the image. Ther
; available image files to use for the preocessing:
;
; 	c1138223.gem: Voyager VICAR format file where the image has had
; 	the camera distortions removed with the VICAR program GEOMA.
; 
; `dat_read` reads the image portion (im) and the image label (label) and its
; output is a data descriptor (dd). tvim is called to display the image (im)
; at 3/4 size in a new window with the y coordinate as top-down.
;
; Note: Users with a 24-bit display, you may want to do the device command
; `'pseudo=8'` so that xloadct can be used to contrast enhance the image.
;
; Code::
;
;  dd = dat_read('data/c1138223.gem', im, label)           ; VICAR format file
;  tvim, im, zoom=0.75, /order
;
;-
;-------------------------------------------------------------------------
dd = dat_read(getenv('OMINAS_DIR')+'/demo/data/c1138223.gem', im, label)			; VICAR format file

tvim, im, zoom=0.75, /order

;-------------------------------------------------------------------------
;+
; Filling the descriptors
; =======================
;
; This section fills the camera descriptor (cd), the planet descriptor
; (pd) and the ring descriptor (rd) for use by the software.
; 
; Code::
;
;  cd = pg_get_cameras(dd)
;  pd = pg_get_planets(dd, od=cd, count=npd)
;  rd = pg_get_rings(dd, pd=pd, od=cd, count=nrd)
;
;-
;-------------------------------------------------------------------------
cd = pg_get_cameras(dd)
pd = pg_get_planets(dd, od=cd, count=npd)
rd = pg_get_rings(dd, pd=pd, od=cd, count=nrd)

;-------------------------------------------------------------------------
;+
; Filling the generic descriptor
; ==============================
;
; This line fills a "generic" descriptor, which is a standard IDL struct.
; Generic descriptors are a convenient notation for several descriptors to
; be grouped into a structure that can be passed to functions in one piece.
;
; The components of the generic descriptor are::
;
;  cd - camera descriptor part
;  gbx - globe descriptor part
;  dkx - disk descriptor part
; 
; Code::
;
;  gd = {cd:cd, gbx:pd, dkx:rd}
;-
;-------------------------------------------------------------------------
gd = {cd:cd, gbx:pd, dkx:rd}


;-------------------------------------------------------------------------
;+
; COMPUTE OVERLAY ARRAYS
;
;   These commands compute the center and limb of each planet, 
;   as well as the edges of the rings. 
;
;     limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, bx=rd, /rm
;               pg_hide, limb_ptd, /assoc, gd=gd, bx=pd,
;     ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
;     center_ptd = pg_center(gd=gd, bx=pd)
;-
;-------------------------------------------------------------------------
limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, bx=rd, /rm
          pg_hide, limb_ptd, /assoc, gd=gd, bx=pd
ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
center_ptd = pg_center(gd=gd, bx=pd)


;-------------------------------------------------------------------------
;+
; SET UP FOR PLOTTING
;
;  This just makes the calls to PG_DRAW a little easier, since they will 
;  need to be repeated every time we change things and recompute.  We put
;  all of the POINT descriptors in one array and then make corresponding 
;  arrays for the plot parameters::
;
;    object_ptd = [center_ptd,limb_ptd,ring_ptd]
;    colors=[make_array(npd,value=!p.color), $
;            make_array(npd,value=ctyellow()), $
;            make_array(2*nrd,value=ctred())],
;    psyms=[make_array(npd,value=1), $
;           make_array(npd,value=3), $
;           make_array(2*nrd,value=3)]
;    psizes=1.0
;    csizes=1.0
;    plabels=[cor_name(pd), $
;            make_array(npd,value=''), $
;            make_array(2*nrd,value=''), $
;            make_array(npd,value='')]
;-
;-------------------------------------------------------------------------
object_ptd = [center_ptd,limb_ptd,ring_ptd]
colors=[make_array(npd,value=!p.color), $
        make_array(npd,value=ctyellow()), $
        make_array(2*nrd,value=ctred())]
psyms=[make_array(npd,value=1), $
       make_array(npd,value=3), $
       make_array(2*nrd,value=3)]
psizes=1.0
csizes=1.0
plabels=[cor_name(pd), $
        make_array(npd,value=''), $
        make_array(2*nrd,value='')]

;-------------------------------------------------------------------------
;+
; DRAW EVERYTHING
;
; Now we can do a nice simple call to PG_DRAW to draw everything::
;
;     pg_draw, object_ptd, $
;               col=colors, psy=psyms, psi=psizes, csi=csizes, pl=plabels
;
;-
;-------------------------------------------------------------------------
pg_draw, object_ptd, col=colors, psy=psyms, psi=psizes, csi=csizes, pl=plabels


;-------------------------------------------------------------------------
;+
; Filling the star descriptor
; ===========================
;
; This line fills a star descriptor by reading the star catalog using
; `pg_get_stars`. `pg_get_stars` calls back-end functions to read the
; translator table. Therefore, for a specific instrument (for instance,
; both ISS-NA and ISS-WA), the star catalog should be specified. The
; translators.tab for this demo (in data/translators.tab) should contain
; a line with the star catalog to be used::
;
;   -   strcat_sao_input     -       /j2000    # or /b1950 if desired
;
; This line specifies that the tycho2 catalog should be used, and all
; coordinates should be for the j2000 epoch. Likewise, such a line should
; be included in the translator for any mission to be processed. 
; 
; NOTES:
;  If the keyword 'tr_override' is specified, only the specified 
;  translator is called instead of whatever star catalog
;  translators are listed in the translators table.
;
;  The translator keyword 'faint' selects only stars with magnitudes
;  brighter than 11.  The keyword, 'bright' may be used place an upper
;  bound on the brightness.
;
;  /no_sort suppresses the default behavior of returning only
;  the first object found with any given name.  That operation can be
;  very time consuming when a large number of objects are returned
;  by the translators.  In the first case, we have specified that only one
;  translator will be called, and we know that it will not return 
;  duplicate objects.
;
; Code::
;
;  ;sd = pg_get_stars(dd, od=cd, /no_sort, tr_ov='strcat_gsc2_input', 'faint=8')
;  sd = pg_get_stars(dd, od=cd, 'faint=8')
;-
;-------------------------------------------------------------------------
;sd = pg_get_stars(dd, od=cd, /no_sort, tr_ov='strcat_gsc2_input', 'faint=8')
sd = pg_get_stars(dd, od=cd, 'faint=8')

;-------------------------------------------------------------------------
;+
; Calculating the star centers
; ============================
;
; The star centers are calculated using `pg_center`. bx is an output
; keyword which contains the body descriptor, in this case it is an
; array of star descriptors. Each star descriptor describes the
; data for one star. 
;
; `pg_hide` is called to remove (/rm) any star points covered by the 
; planet (/globe). Although there is no planet in the Cassini image,
; this technique should be used to hide star points in general, were
; there to be a `limb_ptd`.
; 
; Determining the plot characteristics
; ====================================
;
; The star elements are chosen to be red, with a symbol type of * 
; (code 2), a font size of 2, and labels corresponding to the name of
; each star. Stars can have either catalog names or common names.
;
; Code::
;
;  star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, bx=pd, /rm
;  n_stars=n_elements(sd)
;  color = ctred()
;  psym = 6
;  csizes = 1.5
;  plabels = cor_name(sd)
;-
;-------------------------------------------------------------------------
star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, bx=pd, /rm
n_stars=n_elements(sd)

scolor = ctred()
spsym = 6
scsizes = 1.5
splabels = cor_name(sd)

;-------------------------------------------------------------------------
;+
; Drawing the star centers
; ========================
;
; This section draws the stars in the star_ptd with the colors, plot 
; symbols, font size, and labels defined earlier.
; 
; In this particular example, the planet does not appear in the image.
;
; Code::
; 
;  pg_draw, star_ptd, color=scolor, psym=spsym, plabel=splabels, csi=scsizes
;-
;-------------------------------------------------------------------------
pg_draw, star_ptd, color=scolor, psym=spsym, plabel=splabels, csi=scsizes
stop, '=== Auto-test complete.  Use multi-window cut & paste to continue.'





;-------------------------------------------------------------------------
;+
; Drawing the stellar spectral types
; ==================================
;
; This pasteable section uses the stellar library function str_sp to return
; spectral types of the stars and uses them instead of the star names. If
; the spectral type is not available for the catalog, then no information
; will be plotted in the labels.
;
; Note: Of the currently supported star catalogs, only SAO contains spectral
;       types.
;
; Code::
;
;  tvim, im
;  spt=str_sp(sd)
;  pg_draw, star_ptd, color=scolor, psym=spsym, plabel=spt, csi=scsizes
;-
;-------------------------------------------------------------------------
tvim, im
spt=str_sp(sd)
pg_draw, star_ptd, color=scolor, psym=spsym, plabel=spt, csi=scsizes

;-------------------------------------------------------------------------
;+
; Drawing stellar magnitudes
; ==========================
;
; This pasteable section uses the stellar library function str_get_mag to get
; visual magnitudes of the stars and uses them instead of the star names.
;
; Code::
;
;  tvim, im
;  sm = str_get_mag(sd)
;  smag = string(sm, format='(f4.1)')
;  pg_draw, star_ptd, color=scolor, psym=spsym, plabel=smag, csi=csizes
;-
;-------------------------------------------------------------------------
tvim, im
sm = str_get_mag(sd)
smag = string(sm, format='(f4.1)')
pg_draw, star_ptd, color=color, psym=psym, plabel=smag, csi=csizes

;-------------------------------------------------------------------------
;+
; Manually repointing the geometry
; ================================
;
; This pasteable section first clears the screen of the plotted points
; by redisplaying the image with `tvim`.  It then calls `pg_drag` to allow
; the user to use the cursor to drag the pointing, and with it the stars.
; To move the pointing with `pg_drag`, use the left mouse button and
; translate the pointing in x,y.  Use the middle mouse button to rotate
; the pointing about an axis (in this case, the axis of rotation is set
; as the optic axis of the image (star_ptd) which is defined using the
; routine `pnt_create_descrptors` with the points being the camera optic
; axis as returned by the camera library routine cam_oaxis.  When the
; desired pointing is set, the right mouse button accepts it.  pg_drag
; returns the delta x,y amount dragged (dxy) as well as the rotation
; angle (dtheta).  `pg_repoint` uses the dxy and dtheta to update the
; camera descriptor (cd, passed by gd).  The limb, ring and star points
; are then recalculated, the image redisplayed to clear the objects drawn,
; and then `pg_draw` is called to replot.
;
; Code::
;
;  optic_ptd = pnt_create_descriptors(points=cam_oaxis(cd))
;  tvim, im
;  dxy = pg_drag(star_ptd, dtheta=dtheta, axis=optic_ptd, symbol=6)  ; square
;  pg_repoint, dxy, dtheta, axis=optic_ptd, gd=gd
;  limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, bx=rd, /rm
;            pg_hide, limb_ptd, /assoc, gd=gd, bx=pd
;  ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
;  center_ptd = pg_center(gd=gd, bx=pd)
;  object_ptd = [center_ptd,limb_ptd,ring_ptd]
;  star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, bx=pd, /rm
;  tvim, im
;  pg_draw, object_ptd, col=colors, psy=psyms, psi=psizes, csi=csizes, pl=plabels
;  pg_draw, star_ptd, color=scolor, psym=spsym, plabel=splabels
;-
;-------------------------------------------------------------------------
optic_ptd = pnt_create_descriptors(points=cam_oaxis(cd))
tvim, im
dxy = pg_drag(star_ptd, dtheta=dtheta, axis=optic_ptd, symbol=6)  ; square
pg_repoint, dxy, dtheta, axis=optic_ptd, gd=gd
limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, bx=rd, /rm
          pg_hide, limb_ptd, /assoc, gd=gd, bx=pd
ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
center_ptd = pg_center(gd=gd, bx=pd)
object_ptd = [center_ptd,limb_ptd,ring_ptd]
star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, bx=pd, /rm

tvim, im
pg_draw, object_ptd, col=colors, psy=psyms, psi=psizes, csi=csizes, pl=plabels
pg_draw, star_ptd, color=scolor, psym=spsym, plabel=splabels

;-------------------------------------------------------------------------
;+
; Scanning to find the stars and using it to calculate the pointing
; =================================================================
;
; This section calls `pg_ptscan` to scan the image around the predicted
; star positions (within width of 40 pixels) and find the pixels with 
; the highest correlation with a given edge model (example uses the
; default gaussian) for each star.  These points are then plotted.
;
; Code::
;
;  ptscan_ptd = pg_ptscan(dd, star_ptd, edge=30, width=40)
;  pg_draw, ptscan_ptd, psym=1, col=ctyellow() 
;-
;-------------------------------------------------------------------------
ptscan_ptd = pg_ptscan(dd, star_ptd, edge=30, width=40)
pg_draw, ptscan_ptd, psym=1, col=ctyellow()

;-------------------------------------------------------------------------
;+
; Thresholding using correlation coefficient
; ==========================================
;
; This section (optional) calls `pg_threshold` to remove points with lower
; correlation coefficients.  This example only keeps stars with a 
; correlation coefficient above 0.6.  Notice that each object can have
; its own min and max value.
;
; Code::
;
;  pg_threshold, ptscan_ptd, min=make_array(n_stars,val=0.6), $
;                            max=make_array(n_stars,val=1.0)
;  tvim, im
;  pg_draw, ptscan_ptd, psym=1, col=ctyellow()
;-
;-------------------------------------------------------------------------
pg_threshold, ptscan_ptd, min=make_array(n_stars,val=0.6), $
                         max=make_array(n_stars,val=1.0)

tvim, im
pg_draw, ptscan_ptd, psym=1, col=ctyellow()

;-------------------------------------------------------------------------
;+
; Removing regions of bad points
; ==============================
;
; This section (optional) calls `pg_select` to remove points within a
; polygonal region as defined by the cursor.  Click the left mouse
; button to mark a point and move the mouse to the next point and
; click.  Use the middle mouse button to erase a point and the right
; mouse button to end the region.  `pg_trim` removes the points in the
; just defined region.  The scan points are then replotted.
; Repeat these statements for each region a user wants to remove.
;
; Code::
;
;  region=pg_select(dd)
;  pg_trim, dd, ptscan_ptd, region
;  tvim, im
;  pg_draw, ptscan_ptd, psym=1, col=ctyellow()
;-
;-------------------------------------------------------------------------
region=pg_select(dd)
pg_trim, dd, ptscan_ptd, region

tvim, im
pg_draw, ptscan_ptd, psym=1, col=ctyellow()

;-------------------------------------------------------------------------
;+
; Fitting the pointing to the found stars
; =======================================
;
; This section calls `pg_ptscan_coeff` to determine the linear 
; least-squares coefficients for a fit to the image coordinate translation
; and rotation which matches the computed positions to the scanned
; positions. It then calls `pg_fit` to do the fit with the calculated
; coefficients to calculate the correction in translation (dxy) and
; rotation (dtheta).  It calls `pg_ptchisq` to get the chi square of the
; fit.  It then calls `pg_repoint` to update the pointing.  Recalculates
; the limb, rings and stars and replots.
;
; Code::
;
;  optic_ptd = pnt_create_descriptors(points=cam_oaxis(cd))
;  ptscan_cf = pg_ptscan_coeff(ptscan_ptd, axis=optic_ptd)
;  dxy = pg_fit([ptscan_cf], dtheta=dtheta)
;  chisq = pg_chisq(dxy, dtheta, ptscan_ptd, axis=optic_ptd[0])
;  covar = pg_covariance([ptscan_cf])
;  print, dxy, dtheta*180./!pi, chisq, covar
;  pg_repoint, dxy, dtheta, axis=optic_ptd, gd=gd
;  limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, bx=rd, /rm
;            pg_hide, limb_ptd, /assoc, gd=gd, bx=pd
;  ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
;  center_ptd = pg_center(gd=gd, bx=pd)
;  object_ptd = [center_ptd,limb_ptd,ring_ptd]
;  star_ptd = pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, bx=pd, /rm
;  tvim, im
;  pg_draw, object_ptd, col=colors, psy=psyms, psi=psizes, csi=csizes, pl=plabels
;  pg_draw, star_ptd, color=scolor, psym=spsym, plabel=splabels
;-
;-------------------------------------------------------------------------
optic_ptd = pnt_create_descriptors(points=cam_oaxis(cd))
ptscan_cf = pg_ptscan_coeff(ptscan_ptd, axis=optic_ptd)
dxy = pg_fit([ptscan_cf], dtheta=dtheta)
chisq = pg_chisq(dxy, dtheta, ptscan_ptd, axis=optic_ptd[0])
covar = pg_covariance([ptscan_cf])
print, dxy, dtheta*180./!pi, chisq, covar
pg_repoint, dxy, dtheta, axis=optic_ptd, gd=gd

limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, bx=rd, /rm
          pg_hide, limb_ptd, /assoc, gd=gd, bx=pd
ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
center_ptd = pg_center(gd=gd, bx=pd)
object_ptd = [center_ptd,limb_ptd,ring_ptd]
star_ptd = pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, bx=pd, /rm

tvim, im
pg_draw, object_ptd, col=colors, psy=psyms, psi=psizes, csi=csizes, pl=plabels
pg_draw, star_ptd, color=scolor, psym=spsym, plabel=splabels



;-------------------------------------------------------------------------
;+
; Output the new state
; ====================
;
; This section (optional) shows how you can save your output: any changes
; to the image data into a new file and the new pointing into a detached
; header.
;
; Code::
;
;  pg_put_cameras, dd, gd=gd
;  dat_write, getenv('OMINAS_DIR')+'/demo/data/c1138223_nv.gem', dd
;  
;-
;-------------------------------------------------------------------------
;pg_put_cameras, dd, gd=gd
dat_write, getenv('OMINAS_DIR')+'/demo/data/c1138223_nv.gem', dd
end
