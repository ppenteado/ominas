; docformat = 'rst'
;==============================================================================
;+
;                            GRAFT EXAMPLE
;
;  Created by Joe Spitale
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
;  	ominas graft_example-batch
;
;  or from within IDL using
;
;  	@graft_example-batch
;
;  You can also just paste line-by-line if you want to inspect the variables
;  at each step.
;
;  After the example stops, later code samples in this file may be executed by
;  pasting them onto the IDL command line.
;-
;==============================================================================
!quiet = 1								; shush!

;------------------------------------------------------------------------------
;+
; READ AND DISPLAY IMAGE
;
;  Use GRIM to open and display an image::
;
;    grim, './data/n1350122987.2', zoom=0.75, /order
;-
;------------------------------------------------------------------------------
grim, './data/n1350122987.2', zoom=0.75, /order


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;+
; GRIFT
;
;  First, GRIFT the data descriptor out of poor old GRIM.  Note that the 
;  returned object is a reference to the same object as GRIM is using.  
;
;    grift, dd=dd				
;
;  Be warned that GRIM jealously watches over its objects and updates whenever 
;  it detects any changes, so you can simultaneously operate on objects from 
;  within GRIM and from the command line.  For example, try:
;
;	dat_set_data, dd, rotate(dat_data(dd),7)
;
;  GRIM resigns itself to having its data descriptor tampered with and
;  updates the display accordingly.  Run the same command again if you
;  want flip the image back.
;-
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
grift, dd=dd				


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;+
; OBTAIN GEOMETRY
;
;  Now compute geometry for this dd.  This is the same business you have
;  seen in all of the other demos, cd, pd, etc.  Of course, you could have 
;  just had GRIM do this::
;
;    cd = pg_get_cameras(dd, 'ck_in=auto')
;    pd = pg_get_planets(dd, od=cd, $
;           name=['JUPITER', 'IO', 'EUROPA', 'GANYMEDE', 'CALLISTO'])
;    rd = pg_get_rings(dd, pd=pd, od=cd)
;    sund = pg_get_stars(dd, od=cd, name='SUN')
;- 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd = pg_get_cameras(dd, 'ck_in=auto')
pd = pg_get_planets(dd, od=cd, $
       name=['JUPITER', 'IO', 'EUROPA', 'GANYMEDE', 'CALLISTO'])
rd = pg_get_rings(dd, pd=pd, od=cd)
sund = pg_get_stars(dd, od=cd, name='SUN')


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;+
; MAKE A GENERIC DESCRIPTOR
;
;  And of course we shove everything into a generic descriptor because it
;  makes everything so much easier::
;
;    gd = {cd:cd, gbx:pd, dkx:rd, sund:sund}
;-
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
gd = {cd:cd, gbx:pd, dkx:rd, sund:sund}


;-------------------------------------------------------------------------
;+
; COMPUTE OVERLAY ARRAYS
;
;  Same old story;  PG_LIMB, PG_DISK, PG_HIDE, etc., and then stick all
;  of the POINT objects in one array.  GRIM would have been happy to do
;  this for you::
;
;    limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, /rm, bx=rd
;              pg_hide, limb_ptd, /assoc, gd=gd, bx=pd, od=sund
;    ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
;    term_ptd = pg_limb(gd=gd, od=gd.sund) & pg_hide, term_ptd, gd=gd, bx=pd, /assoc
;
;    center_ptd = pg_center(gd=gd, bx=pd)
;    object_ptd = [center_ptd,limb_ptd,ring_ptd,term_ptd]

;-
;-------------------------------------------------------------------------
limb_ptd = pg_limb(gd=gd) & pg_hide, limb_ptd, gd=gd, /rm, bx=rd
          pg_hide, limb_ptd, /assoc, gd=gd, bx=pd, od=sund
ring_ptd = pg_disk(gd=gd) & pg_hide, ring_ptd, gd=gd, bx=pd
term_ptd = pg_limb(gd=gd, od=gd.sund) & pg_hide, term_ptd, gd=gd, bx=pd, /assoc

center_ptd = pg_center(gd=gd, bx=pd)
object_ptd = [center_ptd,limb_ptd,ring_ptd,term_ptd]


;-------------------------------------------------------------------------
;+
; DISPLAY OVERLAYS
;
;  Ok, now let's draw those overlays, just like in the PG example.  This
;  is going to be great::
;
;    pg_draw, object_ptd
;
;  I know we left out the nice colors, but you get the point.  Now 
;  let's zoom in and take a look at things.  You can use the mouse wheel 
;  with Ctrl depressed, or you can use one of the Zoom cursor modes, or you
;  can use the View->Zoom menu, or the associated keyboard shortcuts if 
;  have your Xdefaults-grim installed; basically just throw a flip-flop at 
;  your computer and you should be able to make this happen. 
;
;  But wait, where did my overlays go?  Did they ever even exist?  If you  
;  are older than two years of age and have mastered object permanence, 
;  then you probably have this one figured out.  We need a way to draw
;  these things permanently; some way of GRAFTing them into GRIM...
;-
;-------------------------------------------------------------------------
pg_draw, object_ptd


;-------------------------------------------------------------------------
;+
; GRAFT
;
;  GRAFT crams the POINT objects into GRIM.  Note that GRIM is no dummy
;  and can figure out what those things are all supposed to be, so limbs
;  are limbs, rings are rings, etc.  GRAFT also surreptitiously sneaks
;  in a new descriptor set (using a generic descriptor, no less).  GRIM
;  just can't catch a break.
;-
;-------------------------------------------------------------------------
graft, object_ptd
stop, '=== Auto-example complete.  Use cut & paste to continue.'


;-------------------------------------------------------------------------
;+
; PG_FARFIT and PG_REPOINT
;
;  Now let's do a farfit, even though GRIM could just do that from the menu.  
;  We start by doing an edge detection with PG_EDGES and we graft those 
;  points into GRIM just for fun.  GRIM has the last laugh, though, because
;  all those edge points make it hard to see anything.  If it really bothers
;  you, you can just blast those points out of GRIM using GRIM's "REMOVE
;  OVERLAYS" cursor mode on the left side of the tool.  Note that GRIM has
;  added the edge points as user points because they don't correspond to
;  any kind of geometric object, so you have to use the right button to 
;  get them.  
;
;  When you have had enough of grafting and blasting edge points, let's move 
;  on to the farfit.  PG_FARFIT is a quick-and-crappy  fit of the limb points 
;  (just the zero-th ones here) to the edge points, which may or may not be 
;  currently displayed by GRIM at this point. It returns an x/y offset that 
;  can be used to derive a correction to the orientation of the camera 
;  descriptor cd.  PG_REPOINT is used to apply the pointing correction.  Note 
;  that GRIM acknowledges this outrage by recomputing all of the overlay points 
;  based on the modified camera descriptor.
;-
;-------------------------------------------------------------------------
edge_ptd = pg_edges(dd, edge=10)
graft, edge_ptd, col=ctwhite()
; pg_draw, edge_ptd				; this would be a more sensible 
;						; thing to do
dxy = pg_farfit(dd, edge_ptd, [limb_ptd[0]])
pg_repoint, dxy, cd=cd



;-------------------------------------------------------------------------
;+
; CONCLUSION
;
;  Yes, GRIM could have done all of this nonsense for you, but that's
;  because it's simple point-and-click kids stuff.  The power of working
;  with a script is that you don't have to do all the pointing and clicking.
;  Everything can be non-interactive, or it can be a setup for an interactive
;  session using a GRIM tool with extensions for a specific project.  Oh,
;  you didn't know that GRIM could be extended?  If only there were a 
;  document somewhere that talked about that.  I wonder what it would be
;  Called..
;
;  Also, the point of this demo was to look at ways to interact with GRIM 
;  from the IDL command line, so hopefully the point got across.
;
;  Anyway, I do a lot of GRIFTing but very little GRAFTing.  I write
;  a lot of GRIM extensions and use batch files to set everything up.
;  And I never use GRIM's File menu to load files; I use a batch file
;  to open the files I need.  If that doesn't work for you, hopefully
;  OMINAS is flexible enough to let you do it your way.  That's why some 
;  of our demos are $MAIN$ programs instead of batch files.  Paulo prefers 
;  $MAIN$ programs, but I think it may be because he has brain damage.
;-
;-------------------------------------------------------------------------

