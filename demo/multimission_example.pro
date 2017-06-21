; docformat = 'rst'
;=======================================================================
;+
; MULTI-MISSION EXAMPLE
; ---------------------
;
;   Created by Joe Spitale
;   
;   Feb 2017
;
;    This example file loads images from various missions onto planes of a 
;    GRIM window and computes the centers of all available planets for each
;    image to demonstrates OMINAS' multi-mission capabilities.  
;
;    This example file can be executed from the UNIX command line using::
;
;     ominas multimission_example.pro
;
;    or from within an OMINAS IDL session using::
;
;     @multimission_example.pro
;     
;   Load the 3 images into grim, with planet centers as overlays::
;   
;     grim, over='planet_center', dat_read(getenv('OMINAS_DIR')+'/demo/data/'+ $
;     ['N1350122987_2.IMG','2100r.img','c3440346.gem'])
;     
;   The Jupiter observation (from Cassini) looks like:
;   
;   .. image:: multimiss_ex_1.png
;   
;   And the Ganymede observation (from Galileo) looks like:
;   
;   .. image:: multimiss_ex_2.png
;   
;   
;-
;-------------------------------------------------------------------------
grim, over='planet_center', dat_read(getenv('OMINAS_DIR')+'/demo/data/'+ $
                  ['N1350122987_2.IMG','2100r.img','c3440346.gem'])
                   
