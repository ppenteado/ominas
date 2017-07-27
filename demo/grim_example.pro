;===============================================================================
;                            GRIM_EXAMPLE.PRO
;
;  This example script demonstrates various basic ways to use GRIM, the
;  graphical interface to OMINAS.  GRIM is kind of like a fancier TVIM,
;  where you can do all the standard stuff like zooming, panning, and 
;  all manner of other acts that TVIM would never consent to.  You could 
;  just use it exactly like TVIM, using PG_DRAW/PLOTS to draw overlays, 
;  etc.,  but then none of your overlays would be permanent.  GRIM 
;  maintains arrays internally, so they hang around as you zoom and pan 
;  all over the place.  GRIM also maintains object descriptors and monitors 
;  them very closely; you can barely sneeze around a descriptor without 
;  GRIM refreshing itself several times.  
;
;  This example file can be executed from the UNIX command line using
;
;  	ominas grim_example.pro
;
;  or from within IDL using
;
;  	@grim_example
;
;  However, there are various separate sections illustrating different ways
;  to run GRIM, so you really should just paste them into the terminal.
;
;  grim, 'data/n1350122987.2', z=0.5, over=['planet_center','ring','limb','terminator']
;
;==============================================================================
!quiet = 1
file = 'data/n1350122987.2'
defsysv, '!grimrc',  ''				; disbable grim resource file

stop, '=== Auto-example complete.  Use cut & paste to continue.'

;==============================================================================
; EXAMPLE 1: 
;
;  Read a data descriptor and give it to GRIM.  Also specify some overlays.
;
;==============================================================================
dd = dat_read(file)
grim, dd, zoom=0.75, /order, over=['planet_center', 'limb', 'terminator', 'ring']


;==============================================================================
; EXAMPLE 2: 
;
;  Example 1 was kind of dumb, because you could have just done this.  Note
;  the /new.  Without it, GRIM will try to update the existing instance. 
;  If you zoom out, you may notice many objects far from the field of view.
;
;==============================================================================
grim, /new, file, zoom=0.75, /order, over=['planet_center', 'limb', 'terminator', 'ring']


==============================================================================
; EXAMPLE 3: 
;
;  Try specifying some explicit planet names.  This will likely be faster
;  because the above examples may have returned many more planets, depending
;  on your translator setup.
;
;==============================================================================
grim, /new, file, zoom=0.75, /order, $
    over=['planet_center:JUPITER,IO,EUROPA,GANYMEDE,CALLISTO', $
          'limb', 'terminator', 'ring']


==============================================================================
; EXAMPLE 4: 
;
;  Let's get rid of the explicit planet names and just select them based
;  on geometric criteria.  FOV=-1 selects overlays with 1 field of view
;  of the viewport.   
;
;==============================================================================
grim, /new, file, zoom=0.75, /order, $
    over=['planet_center', 'limb', 'terminator', 'ring'], fov=-1


==============================================================================
; EXAMPLE 5: 
;
;  Same as above, except FOV=-1 selects overlays with 1 field of view
;  of the *image*.
;
;==============================================================================
grim, /new, file, zoom=0.75, /order, $
    over=['planet_center', 'limb', 'terminator', 'ring'], fov=1



==============================================================================
; 
;  You have too many GRIM windows open.  Let's take care of that.
;
;==============================================================================
grim, /exit, grn=lindgen(100)		; I'm assuming you haven't opened more
					; than 100 GRIMs here.  I've never tried
					; that, but it's probably not a good
					; idea.



;==============================================================================
; 
;  Speaking of way too many GRIMs, let's just open a bunch of images in
;  *one* GRIM.
;
;==============================================================================
; multiple planes




;==============================================================================
; 
;  Did you know GRIM also does plots?  Well it does!
;
;==============================================================================
; plots



;==============================================================================
; 
;  And cubes!  Here's an rgb image cube.
;
;==============================================================================
; cubes




;==============================================================================
; 
;  And no data at all....  Poor old lonely GRIM. 
;
;==============================================================================
;grim, /new, inst='CAS_ISS_NA', cam_trs='time=5*3.5d7', $
;         over=['planet_center', 'limb', 'terminator', 'ring']


cd=pg_get_cameras(inst='CAS_ISS_NA', time=5*3.5d7)
grim, /new, cd=cd, over=['planet_center', 'limb', 'terminator', 'ring']

