; docformat = 'rst'
;===============================================================================
;+
;                            GRIM EXAMPLE
;
;  Created by Joe Spitale
;
;  This example script demonstrates various basic ways to run GRIM, the
;  graphical interface to OMINAS.  GRIM is kind of like a fancier TVIM,
;  where you can do all the standard stuff like zooming, panning, and 
;  all manner of other acts that TVIM would never consent to.  You could 
;  just use it exactly like TVIM, using PG_DRAW/PLOTS to draw overlays, 
;  etc., but then none of your overlays would be permanent.  GRIM 
;  maintains arrays internally, so they hang around as you zoom and pan 
;  all over the place.  GRIM also maintains object descriptors and monitors 
;  them very closely; you can barely sneeze around a descriptor without 
;  GRIM refreshing itself several times.  See GRIM.PRO for information
;  on usage, or just play around with it.
;
;  This example file can be executed from the UNIX command line using
;
;  	ominas grim_example-batch
;
;  or from within IDL using
;
;  	@grim_example-batch
;-
;==============================================================================
!quiet = 1
file = 'data/n1350122987.2'
defsysv, '!grimrc',  ''				; disbable grim resource file


;------------------------------------------------------------------------------
;+
; EXAMPLE 1: 
;
;  Read a data descriptor and give it to GRIM.  Also specify some overlays.
;
;    dd = dat_read(file)
;    grim, dd, zoom=0.75, /order, $
;                  overlay=['planet_center', 'limb', 'terminator', 'ring']
;
;-
;------------------------------------------------------------------------------
dd = dat_read(file)
grim, dd, zoom=0.75, /order, $
                  overlay=['planet_center', 'limb', 'terminator', 'ring']


;------------------------------------------------------------------------------
;+
; EXAMPLE 2: 
;
;  Example 1 was kind of dumb, because you could have just done this.  Note
;  the /new.  Without it, GRIM will try to update the existing instance. 
;  If you zoom out, you may notice many objects far from the field of view.
;
;    grim, /new, file, zoom=0.75, /order, $
;                overlay=['planet_center', 'limb', 'terminator', 'ring']
;-
;------------------------------------------------------------------------------
grim, /new, file, zoom=0.75, /order, $
                overlay=['planet_center', 'limb', 'terminator', 'ring']


;------------------------------------------------------------------------------
;+
; EXAMPLE 3: 
;
;  Try specifying some explicit planet names.  This will likely be faster
;  because the above examples may have returned many more planets, depending
;  on your translator setup.
;
;    grim, /new, file, zoom=0.75, /order, $
;        overlay=['planet_center:JUPITER,IO,EUROPA,GANYMEDE,CALLISTO', $
;                                                'limb', 'terminator', 'ring']
;-
;------------------------------------------------------------------------------
grim, /new, file, zoom=0.75, /order, $
    overlay=['planet_center:JUPITER,IO,EUROPA,GANYMEDE,CALLISTO', $
                                              'limb', 'terminator', 'ring']


;------------------------------------------------------------------------------
;+
; EXAMPLE 4: 
;
;  Let's get rid of the explicit planet names and just select them based
;  on geometric criteria.  FOV=-1 selects overlays with 1 field of view
;  of the viewport.   
;
;    grim, /new, file, zoom=0.75, /order, $
;        overlay=['planet_center', 'limb', 'terminator', 'ring'], fov=-1
;-
;------------------------------------------------------------------------------
grim, /new, file, zoom=0.75, /order, $
    overlay=['planet_center', 'limb', 'terminator', 'ring'], fov=-1


;------------------------------------------------------------------------------
;+
; EXAMPLE 5: 
;
;  Same as above, except FOV=-1 selects overlays with 1 field of view
;  of the *image*.
;
;    grim, /new, file, zoom=0.75, /order, $
;        overlay=['planet_center', 'limb', 'terminator', 'ring'], fov=1
;-
;------------------------------------------------------------------------------
grim, /new, file, zoom=0.75, /order, $
    overlay=['planet_center', 'limb', 'terminator', 'ring'], fov=1



stop, '=== Auto-example complete.  Use cut & paste to continue.'



;------------------------------------------------------------------------------
; +
;  You have too many GRIM windows open.  Let's take care of that...
;
;   grim, /exit, grn=lindgen(100)
;-
;------------------------------------------------------------------------------
grim, /exit, grn=lindgen(100)		; I'm assuming you haven't opened more
					; than 100 GRIMs here.  I've never tried
					; that, but it's probably not a good
					; idea.



;------------------------------------------------------------------------------
; +
;  Speaking of way too many GRIMs, let's just open a bunch of images in
;  *one* GRIM.  Each image is opened in a separate plane.  You can change 
;  planes using the left/right arrows in the top left corner.  If you have
;  Xdefaults-grim set up, you can use the left / right arrow keys.
;
;    grim, /new, './data/n*.2', /order, overlay='planet_center'
;-
;------------------------------------------------------------------------------
grim, /new, './data/n*.2', /order, overlay='planet_center'



;------------------------------------------------------------------------------
; 
;  Did you know GRIM also handles plots?  Well it does!
;
;    grim, /new, './data/GamAra037_2_bin50_031108.vic'
;-
;------------------------------------------------------------------------------
grim, /new, './data/GamAra037_2_bin50_031108.vic'



;------------------------------------------------------------------------------
;+
; 
;  And cubes!  Here's an rgb image cube with some overlays...
;
;    grim, /new, './data/' + ['N1460072434_1.IMG', $
;                             'N1460072401_1.IMG', $
;                             'N1460072467_1.IMG'], $
;          ext='.cal', visibility=1, channel=[1b,2b,4b], $
;          over=['planet_center', $
;                'limb:SATURN', $
;                'terminator:SATURN', $
;                'planet_grid:SATURN', $
;                'ring']
;-
;------------------------------------------------------------------------------
grim, /new, './data/' + ['N1460072434_1.IMG', $
                         'N1460072401_1.IMG', $
                         'N1460072467_1.IMG'], $
      ext='.cal', visibility=1, channel=[1b,2b,4b], $
      over=['planet_center', $
           'limb:SATURN', $
           'terminator:SATURN', $
           'planet_grid:SATURN', $
           'ring']


;------------------------------------------------------------------------------
;+
; 
;  Here's a spectral cube.  You'll need to stretch the levels to see 
;  anything...
;
;    grim, /new, './data/CM_1503358311_1_ir_eg.cub'
;-
;------------------------------------------------------------------------------
grim, /new, './data/CM_1503358311_1_ir_eg.cub'



