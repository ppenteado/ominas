; docformat = 'rst'
;=======================================================================
;+                           
; MOSAIC EXAMPLE
; --------------
;
;   This example requires the following kernel files, which are
;   included in the demo's data directory::
;     $CAS_SPICE_CK/001103_001105ra.bc
;     $CAS_SPICE_CK/001105_001108.bc
;     $CAS_SPICE_CK/001026_001029ra.bc
;     $CAS_SPICE_CK/001029_001031ra.bc
;
;   This example file demonstrates how to construct a mosaic using OMINAS.
;   This example file can be executed from the UNIX command line using::
;
;  	  idl mosaic_example
;
;   or from within IDL using::
;
;  	  @mosaic_example
;
;   After the example stops, later code samples in this file may be executed by
;   pasting them onto the IDL command line.
;-
;=======================================================================
!quiet = 1
zoom = 0.3

;-------------------------------
; load files
;-------------------------------
;files = ['./data/n1350122987.2', $
;         './data/n1351469359.2', $
;         './data/n1351523119.2', $
;         './data/n1352037683.2']
files = ['data/n1350122987.2', $
         'data/n1351469359.2']
n = n_elements(files)

dd = dat_read(files, input_transform='cas_delut')


;---------------------------------------
; get ancillary info for each image
;---------------------------------------
_gd = {cd:obj_new(), gbx:obj_new(), dkx:obj_new(), sund:obj_new()}
gd = replicate(_gd, n)

for i=0, n-1 do gd[i].cd = pg_get_cameras(dd[i])
for i=0, n-1 do $
       gd[i].gbx = pg_get_planets(dd[i], od=gd[i].cd, name='JUPITER')
for i=0, n-1 do gd[i].dkx = pg_get_rings(dd[i], pd=gd[i].gbx, od=gd[i].cd)
for i=0, n-1 do gd[i].sund = pg_get_stars(dd[i], od=gd[i].cd, name='SUN')


;---------------------------------------------------
; display images and keep track of window numbers
;---------------------------------------------------
for i=0, n-1 do tvim, dat_data(dd[i]), zoom=zoom, /order, /new
tvim, /list, wnum=ww


;-------------------------------
; compute initial limbs
;-------------------------------
limb_ptd = objarr(n)
for i=0, n-1 do limb_ptd[i] = pg_limb(gd=gd[i]) 


;-----------------------------------------------------------------------
;+
; Navigate on limbs automatically
; -------------------------------
;
;   pg_farfit finds the limb to within a few pixels.  In reality, you would 
;   want to refine the pointing by scanning for the limb and performing a
;   least-squares fit, but for the purposes of clarity in this example, the 
;   inital fit will do.  See jup_cassini.example and dione.example for examples 
;   of least-squares fits to image features.
;-
;-----------------------------------------------------------------------
edge_ptd = objarr(n)
for i=0, n-1 do edge_ptd[i] = pg_edges(dd[i], edge=10)

dxy = dblarr(2,n)
for i=0, n-1 do dxy[*,i] = pg_farfit(dd[i], edge_ptd[i], [limb_ptd[i]], ns=[5,5])
for i=0, n-1 do pg_repoint, dxy[*,i], 0d, gd=gd[i]


;--------------------------------------------------------
; recompute and redisplay limbs using corrected pointing
;--------------------------------------------------------
for i=0, n-1 do limb_ptd[i] = pg_limb(gd=gd[i]) 
for i=0, n-1 do  pg_draw, limb_ptd[i], wnum=ww[i]

;---------------------------------------------------------------------
;+
; Correct photometry
; ------------------
;
;   Here, a crude photometric correction is performed for the purposes 
;   of this example.
;
;   In addition to the corrected images, the output descriptors, dd_pht, 
;   will contain the photometric angles in their user data arrays with
;   the names 'EMM', 'INC' and 'PHASE'.
;-
;----------------------------------------------------------------------
dd_pht = objarr(n)
for i=0, n-1 do dd_pht[i] = pg_photom(dd[i], gd=gd[i], $
                               refl_fn='pht_refl_minneart', $
                                  refl_parm=[0.9d], outline=limb_ptd[i]) 

for i=0, n-1 do tvim, dat_data(dd_pht[i]), ww[i]



;------------------------------------------------------------------------------
;+
; Project maps
; ------------
;
;   Note that all map projections use the same map descriptor.
;
;   Also, aux=['EMM'] is used with pg_map to direct it to reproject
;   the emmision angle array that was produced and stored in the data descriptor
;   by pg_photom.  That array will be needed by pg_mosaic.
;-
;------------------------------------------------------------------------------
map_xsize = 800
map_ysize = 400


md = pg_get_maps(/over, gbx = pd1, $
	name='JUPITER',$
	type='RECTANGULAR', $
	fn_data=ptr_new(), $
	size=[map_xsize,map_ysize], $
	origin=[map_xsize,map_ysize]/2 $
	)

;md = pg_get_maps(/over, gbx=pd1, $
;	name='JUPITER',$
;	type='ORTHOGRAPHIC', $
;;	type='STEREOGRAPHIC', $
;	fn_data=ptr_new(), $
;;	center=[!dpi/2d,0], $	    ; polar
;	center=[!dpi/4d,0], $
;	size=[map_xsize,map_ysize], $
;	origin=[map_xsize,map_ysize]/2 $
;	)

;md = pg_get_maps(/over, gbx=pd1, $
;	name='JUPITER',$
;;	type='MOLLWEIDE', $
;	type='MERCATOR', $
;	fn_data=ptr_new(), $
;	size=[map_xsize,map_ysize], $
;	origin=[map_xsize,map_ysize]/2 $
;	)


dd_map = objarr(n)
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;+
; Introducing wind profiles
; -------------------------
;
; Use the commented commands instead to include a zonal wind profile in
; the projection.
;-
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for i=0, n-1 do dd_map[i] = pg_map(dd_pht[i], md=md, gd=gd[i], aux=['EMM'])

;for i=0, n-1 do $
;   dd_map[i] = pg_map(dd_pht[i], md=md, gd=gd[i], aux=['EMM'], $
;                   wind_fn='pm_wind_zonal', $
;                   wind_data={vel:cos((dindgen(181)-90)*!dpi/180d) * 100d, $
;                              dt:bod_time(gd[i].cd)-bod_time(gd[0].cd)})

for i=0, n-1 do tvim, dat_data(dd_map[i]), /new


;----------------------------------------------------------------------
;+
; Construct the mosaic
; --------------------
;
;   The combination function 'emm' combines the maps
;   using wighting proprtional to emm^x, where emm is the emmision 
;   cosine.  It also imposes a minimum emmision cosine, emm0.  Note 
;   that the emission angles were computed by pg_photom and 
;   reprojected by pg_map, as directed by the 'aux' keyword.
;-
;----------------------------------------------------------------------
dd_mosaic = pg_mosaic(dd_map, mosaic=mosaic, $
               wt='emm', comb='sum', data={x:5, emm0:cos(85d*!dpi/180d)})
tvim, mosaic, /new



stop, '=== Auto-example complete.  Use cut & paste to continue.'

;----------------------------------------------------------------------
;+
; Save the mosaic and map info
; ----------------------------
;
;   To read the mosaic and projection info::
;
;     dd = dat_read('./data/test.msc', mosaic, label)
;     md = pg_get_maps(dd)
;-
;----------------------------------------------------------------------
pg_put_maps, dd_mosaic, md=md
dat_write, './data/test.mos', dd_mosaic, filetype = 'VICAR'







