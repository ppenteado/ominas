; docformat = 'rst'
;=======================================================================
;+
; RADAR EXAMPLE
; -------------
; 
;   This script demonstrates reading a Cassini RADAR SAR image and projecting it
;   onto an orthographical map for display.
;   
;   The data file, `BIFQI22N068_D045_T003S01_V02.IMG`, must first be
;   `downloaded from PDS <http://pds-imaging.jpl.nasa.gov/data/cassini/cassini_orbiter/CORADR_0045/DATA/BIDR/BIFQI22N068_D045_T003S01_V02.ZIP>`,
;   then unzipped (the zip file is 202MB).
;
;   Setup: The instrument detectors, translators and transforms must contain the
;   RADAR definitions, as is included in `demo/data/instrument_detectors.tab`,
;   `demo/data/translators.tab`, and `demo/data/transforms.tab`. Since the RADAR
;   data is in PDS format, the PDS detector and io functions must also be set up
;   in the corresponding tables, as is in `config/tab/filetype_detectors.tab`
;   and `config/tab/io.tab`.
;
;   There is no need for SPICE/Icy for this example. It can be run just by doing::
;
;     img='~/radar/BIFQI22N068_D045_T003S01_V02.IMG'
;     @radar_example
;    
;   from the `demo` directory. Note that you have to set the variable `img` to the
;   location of your data file.
;
;-
;=======================================================================
compile_opt idl2,logical_predicate
;-------------------------------------------------------------------------
;+
; Read SAR file 
; -------------
; 
;   Cassini RADAR SAR image to read must be set in the variable img, otherwise
;   this default location is used::
;
;     img=n_elements(img) ? img : '~/radar/BIFQI22N068_D045_T003S01_V02.IMG'
;     ;Read the file
;     dd=dat_read(img)
;
;-
;-------------------------------------------------------------------------

img=n_elements(img) ? img : '~/radar/BIFQI22N068_D045_T003S01_V02.IMG'

;Read the file 
dd=dat_read(img)

;-------------------------------------------------------------------------
;+
; Display SAR file
; ----------------
;
;   Saturate the data to make the image better looking, since this is just for display
;   purposes::
;  
;     da=dat_data(dd)
;     dat_set_data,dd,da<4.5d0
;  
;   Show it a 1/20 resolution::
; 
;     tvim,da<4.5,zoom=0.05,/order,/new
;  
;   .. image:: sar_ex1.png
;
;-
;-------------------------------------------------------------------------


da=dat_data(dd)
dat_set_data,dd,da<4.5d0
tvim,da<4.5,zoom=0.05,/order,/new

;-------------------------------------------------------------------------
;+
; Map SAR file
; ------------
;
;   SAR data is provided in PDS as a map on the target, in an oblique rectangular projection, shown above. 
;   To use it, first we need to obtain the proper map descriptor from the data object::
;
;     mdr=pg_get_maps(dd)
;  
;   Now we will display it in an orthogonal projection. First we define it::
; 
;     map_xsize = 4000
;     map_ysize = 4000
;
;   Create the new map descriptor::
;     mdp= pg_get_maps(/over,  $
;       name='TITAN',$
;       type='ORTHOGRAPHIC', $
;       size=[map_xsize,map_ysize], $
;       origin=[map_xsize,map_ysize]/2, $
;       center=[0d0,-0.4d0*!dpi])
;
;   Now, do the projection::
; 
;     dd_map=pg_map(dd,md=mdp,cd=mdr,pc_xsize=800,pc_ysize=800)
;
;   Visualize the result, now with grim::
; 
;     grim,dd_map,cd=mdp,overlays=['planet_grid']
;   
;   .. image:: sar_ex2.png
;   
;-
;-------------------------------------------------------------------------


mdr=pg_get_maps(dd)

map_xsize = 4000
map_ysize = 4000
  
mdp= pg_get_maps(/over,  $
  name='TITAN',$
  type='ORTHOGRAPHIC', $
  size=[map_xsize,map_ysize], $
  origin=[map_xsize,map_ysize]/2, $
  center=[0d0,-0.4d0*!dpi])

dd_map=pg_map(dd,md=mdp,cd=mdr,pc_xsize=800,pc_ysize=800)

grim,dd_map,cd=mdp,overlays=['planet_grid']

;end
