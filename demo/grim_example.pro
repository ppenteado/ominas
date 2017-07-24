;=======================================================================
;                            GRIM_EXAMPLE.PRO
;
;  This example file demonstrates one way to use the graphical
;  interface to ominas.  Here, we use grim in a manner very similar 
;  to the use of tvim, but the grim interface is somewhat more 
;  convenient because the viewing parameters may be changed without 
;  using tvzoom and tvmove and overlay points are automatically
;  recomputed and redrawn whenever descriptors are modified
;
;  This example file can be executed from the UNIX command line using
;
;  	ominas grim_example.pro
;
;  or from within IDL using
;
;  	@grim_example
;
;  After the example stops, later code samples in this file may be executed by
;  pasting them onto the IDL command line.
;
;
; A similar result can be obtained using the following command:
;
;  grim, 'data/n1350122987.2', z=0.5, over=['planet_center','ring','limb','terminator']
;
;=======================================================================
!quiet = 1
;-------------------------------------
; read a file using dat_read
;-------------------------------------
file = 'data/n1350122987.2'


;--------------------------------------------
; display the image with overlays using grim
;--------------------------------------------
grim, file, zoom=0.75, /order, $
    over=['planet_center:JUPITER,IO,EUROPA,GANYMEDE,CALLISTO', $
          'limb', 'terminator', 'ring']


stop, '=== Auto-example complete.  Use cut & paste to continue.'


