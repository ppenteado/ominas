;==============================================================================
;                            GRAFT_EXAMPLE.PRO
;
;  This example file demonstrates the use the GRIM interface programs
;  GRIFT and GRAFT.  GRIFT swindles GRIM into giving up references to its
;  descriptor set, while GRAFT corruptly inserts (or grafts) data arrays
;  into a GRIM instance.  
;
;  The usage demonstrated here is a bit contrived, as one could accomplish
;  the same things by specifying the desired overlays in the call to GRIM,
;  as in grim_example, but let's live a little.
;
;  This example file can be executed from the UNIX command line using
;
;  	ominas graft_example.pro
;
;  or from within IDL using
;
;  	@graft_example
;
;  You can also just paste line-by-line if you want to inspect the variables
;  at each step.
;
;  After the example stops, later code samples in this file may be executed by
;  pasting them onto the IDL command line.
;
;==============================================================================
!quiet = 1
;-------------------------------------
; read a file using dat_read
;-------------------------------------
file = 'data/n1350122987.2'


;-------------------------------------
; display the image using grim
;-------------------------------------
grim, file, zoom=0.75, /order


;-------------------------------------
; Obtain descriptors
;-------------------------------------

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; GRIFT
;
;  First, grift the dd out of poor old GRIM.  Note that the returned
;  object is a reference to the same object as GRIM is using.  GRIM 
;  jealously watches over its objects and updates whenever it detects 
;  any changes, so you can simultaneously operate on objects from within 
;  GRIM and from the command line.  For example, try:
;
;	dat_set_data, dd, rotate(dat_data(dd),7)
;
;  GRIM resigns itself to having its data descriptor tampered with 
;  and updates the display accordingly.
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grift, dd=dd				


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Now compute geometry for this dd.  Of course, you could have just had
; GRIM do this.  
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd = pg_get_cameras(dd, 'ck_in=auto')
pd = pg_get_planets(dd, od=cd, $
       name=['JUPITER', 'IO', 'EUROPA', 'GANYMEDE', 'CALLISTO'])
rd = pg_get_rings(dd, pd=pd, od=cd)
sund = pg_get_stars(dd, od=cd, name='SUN')


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Stick everything in a generic descriptor to cut down on typing.
; All PG programs accept generic descriptors as a substitute for
; using explicit object keywords. 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gd = {cd:cd, gbx:pd, dkx:rd, sund:sund}


;-------------------------------------------------------------------------
; Compute some overlays.  Again GRIM would have been happy to do this
; for you.
;-------------------------------------------------------------------------
limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, /rm, bx=rd
          pg_hide, limb_ptd, /assoc, gd=gd, bx=pd, od=sund
ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
term_ptd = pg_limb(gd=gd, od=gd.sund) & pg_hide, term_ptd, gd=gd, bx=pd, /assoc

center_ptd = pg_center(gd=gd, bx=pd)
object_ptd = [center_ptd,limb_ptd,ring_ptd,term_ptd]


;-------------------------------------------------------------------------
; GRAFT
;
;  GRAFT crams the POINT objects into GRIM.  Note that GRIM is no dummy
;  and can figure out what those things are all supposed to be, so limbs
;  are limbs, rings are rings, etc.  GRAFT also surreptitiously sneaks
;  in a new descriptor set.  GRIM just can't catch a break.
;
;-------------------------------------------------------------------------
graft, object_ptd
stop, '=== Auto-example complete.  Use cut & paste to continue.'


;-------------------------------------------------------------------------
; PG_FARFIT and PG_REPOINT
;
;  Now let's do a farfit, even though GRIM could just do that from the menu.  
;  We start by doing an edge detection with PG_EDGES and we graft those 
;  points into GRIM just for fun.  GRIM has the last laugh, though, because
;  all those edge points make it hard to see anything.  If it relly bothers
;  you, you can just blast those points out of GRIM using GRIM's "REMOVE
;  OVERLAYS" cursor mode on the left side of the tool.  Note that GRIM has
;  added the edge points as user points because they don't correspond to
;  any kind of geometric object, so you have to use the right button to 
;  get them.  
;
;  When you have had enough of grafting and blasting edge points, let's move 
;  on to the farfit.  PG_FARFIT is a quick-and-crappy  fit of the limb points 
;  (just the zero-th ones) to the edge points, which may or may not be currently 
;  displayed by GRIM at this point. It returns an x/y offset that can be used 
;  to derive a correction to the orientation of the camera descriptor cd.  
;  PG_REPOINT is used to apply the pointing correction.  Note that GRIM 
;  acknowledges this outrage by recomputing all of the overlay points based 
;  on the modified camera descriptor.
;
;-------------------------------------------------------------------------
edge_ptd = pg_edges(dd, edge=10)
graft, edge_ptd, col=ctwhite()
; pg_draw, edge_ptd				; this would be a more sensible 
;						; thing to do
dxy = pg_farfit(dd, edge_ptd, [limb_ptd[0]])
pg_repoint, dxy, cd=cd



