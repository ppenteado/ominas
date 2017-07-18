;=============================================================================
;+-+
; NAME:
;	GRIM
;
;
; PURPOSE:
;	Graphical interface for oMINAS. 
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	
;	grim, arg
;
;
; ARGUMENTS:
;  INPUT:
;	arg:	The argument, if present, can be either a data descriptor or 
;		a grim image number.  If a data descriptor, then a new grim
;		instance will be created using that data descriptor and all
;		keyword arguments apply to the new instance.  If a grim image
;		number, then all keyword arguments apply to the grim instance
;		identified by that number.  If the argument is not present, 
;		then all keyword arguments apply to the most recently accessed
;		grim instance; a new grim instance is created if none exist.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Replaces grim's current camera descriptor.  This may also be 
;		a map descriptor, in which case, certain of grim's functions 
;		will not be available.  When using a map descriptor instead 
;		of a camera descriptor, you can specify a camera descriptor 
;		as the observer descriptor (see the 'od' keyword below) and 
;		some additional geometry functions will be available.
;
;	od:	Replaces grim's current observer descriptor.  The observer
;		descriptor is used to allow some geometry objects (limb,
;		terminator) to be computed when usign a map descriptor instead
;		of a camera descriptor.
;
;	pd:	Adds a new planet descriptor.
;
;	rd:	Adds a new ring descriptor.
;
;	sd:	Adds a new star descriptor.
;
;	sund:	Replaces grim's current sun descriptor.
;
;	gd:	Generic descriptor giving some or all of the above descriptors.
;
;     *	new:	If set, a new grim instance is created and all keywords apply
;		to that instance.
;
;     *	silent:	If set, many message are suppressed.
;
;     *	xsize:	Size of the graphics window in the x direction.  Defaults to
;		400 pixels.
;
;     *	ysize:	Size of the graphics window in the y direction.  Defaults to
;		400 pixels.
;
;     *	zoom:	Initial zoom to be applied to the image.  If not given, grim
;		computes an initial zoom such that the entire image fits on the
;		screen.
;
;     *	rotate:	Initial rotate value to be applied to the image (as in the IDL
;		ROTATE routine).  If not given, 0 is assumed.
;
;     *	order:	Initial display order to be applied to the image.
;
;     *	offset:	Initial offset (dx,dy) to be applied to the image.
;
;	erase:	If set, erase the current image before doing anything else.
;
;     *	filter:	Initial filter to use when loading or browsing files.
;
;     *	mode:	Initial cursor mode.  Choices are 'zoom', 'pan', 'tiepoint',
;		'activate', and 'readout'.  Defaults to 'activate'.
;
;     *	retain:	Retain settings for backing store (see "backing store" in 
;		the IDL reference guide).  Defaults to 2.
;
;     * menu_fname:	Name of a file containing additional menus to add to
;			the grim widget.  The syntax follows that for cw_pdmenu.
;
;     * fov:	Controls the number of camera fields of view to crop when
;		the 'FOV' overlay settings is on.  If set, the FOV overlay
;		settings is turned on.
;
;     * hide:	If set, overlays are hidden w.r.t shadoes and obstructions.
; 		Default is on. 
;
;     * overlays: List of overlays to compute on startup.  Each element
;                 is of the form:
;
;                          type[:name1,name2,...]
;
;                 where 'type' is one of {limbs, terminators, planet_centers, 
;                 stars, rings, planet_grids} and the names identify the
;                 name of the desired object.  Note that grim will load 
;                 more objects than named if required by another startup 
;                 startup overlay.  For example:
;
;                         overlays='rings:a_ring'
;
;                 will cause only one ring descriptor to load, whereas
;
;                         overlays=['limbs:saturn', 'rings:a_ring']
;
;                 will cause all of Saturn's rings to load because they are
;                 required in computing the limb points (for hiding).
;
;  OUTPUT: NONE
;
;
; RESOURCE FILE:
;	The keywords marked above with an asterisk may be overridden using 
;	the file $HOME/.grimrc.  Keyword=value pairs may be entered, one per
;	line, using the same syntax as if the keyword were entered on the IDL 
;	command line to invoke grim.  Lines beginning with '#' are ignored.
;	Keywords entered in the resource file override the default values, and
;	are themselves overridden by keywords entered on the command line.
;
;
; ENVIRONMENT VARIABLES:
;	Grim defines no environment variables of its own, but as it is an
;	interface to OMINAS, all OMINAS variables are relevant.
;
;
; COMMON BLOCKS:
;	grim_block:	Keeps track of most recent grim instance and which 
;			ones are selected.
;
;
; SIDE EFFECTS:
;	Grim operates directly on the memory images of the descriptors that 
;	it is given.  Therefore, those descriptors are modified during 
;	a session.  This architecture allows data to be operated on concurrently
;	through grim and from the command line; see ingrid.pro for details.
;
;
; LAYOUT:
;	The grim layout consists of the following items:
;
;	 Menu bar: Most of grim's functionality is accessed through the 
;	           system of pulldown menus at the top.  Individual menu
;	           items are described in their own sections below.
;
;	 Shortcut buttons: Some common-used menu options are duplicated as
;			   shortcut buttons, which are arranged horizontally 
;			   just beneath the menu bar.  The following shortcuts 
;			   are available, from left to right: 
;
;		Previous plane: Changes to the previous plane.
;
;		Next plane: Changes to the next plane.
;
;		Refresh: Redisplays the image and overlays.
;
;		Entire Image: Resets display parameters so that the enitre
;		              image is visible.
;
;		Previous view: Reverts to the previous view settings.
;
;		Hide/Unhide: Toggles overlays on/off.
;
;		Colors: Opens the color tool.
;
;		Tracking: Toggles cursor tracking on/off.
;
;		Grid: Toggles RA/DEC grid on/off.
;
;		Axes: Toggles axes on/off.
;
;		Activate all: Activates all overlays.
;
;		Deactivate all: Deactivates all overlays.
;
;		Header: Opens a window showing the image header.
;
;
;	 Modes buttons: Modes buttons are arranged vertically along the 
;	                left side.  The following modes are available, in order
;	                of their appearance in the grim widget:
;
;		Select: The top button toggles a given grim instance between
;		        selected and unselected states, for use with functions
;		        that require input from more than one grim instance. 
;		        When a given instance is selected, this button
;		        displays an asterisk.
;
;		Context: This button toggles the visibility of a small context
;			 window superimposed over the top-left corner of the
;			 main image.  The context window always displays the
;			 entire image and all of these modes except activation
;			 function in the same way in the context window as in
;			 the main window.
;
;		Activate: In activate mode, overlay objects may be activated
;			  or deactivated by clicking and/or dragging using the
;			  left or right mouse buttons respectively.  This
;			  activation mechanism allows the user to select which
;			  among a certain type of objects should be used in a
;			  given menu selection.  A left click on an overlay
;			  activates that overlay and a right click deactivates
;			  it.  A double click activates or deactivates all
;			  overlays associated with a given descriptor, or all
;			  stars.  Active overlays appear in the colors selected
;			  in the 'Overlay Settings' menu selection.  Inactive
;			  overlays appear in cyan.  A descriptor is active
;			  whenever any of its overlays are active.
;
;		Zoom: The zoom button puts grim in a zoom cursor mode, wherein
;		      the image zoom and offset are controlled by selecting
;		      a box in the image.  When the box is created using the
;		      left mouse button, zoom and offset are changed so that 
;		      the contents of the box best fill the current graphics
;		      window.  When the right button is used, the contents of
;		      the current graphics window are shrunken so as to best
;		      fill the box.  In other words, the left button zooms in
;		      and the right button zooms out.
;
;		Pan: The pan button puts grim in a pan cursor mode, wherein the 
;		     image offset is controlled by selecting an offset vector
;		     using the left mouse button.  The middle button may be
;		     used to center the image on a selected point.
;
;		Pixel Readout:	In pixel readout mode, a text window appears 
;				and displays data about the pixel selected 
;				using the left mouse button.  
;
;		Tiepoint: In tiepoint mode, tiepoints are added using the
;		          left mouse button and deleted using the right button.
;		          Tiepoints appear as crosses identified by numbers.
;			  The use of tiepoints is determined by the particular 
;			  option selected by the user.
;
;		Magnify: In magnify mode, image pixels in the graphics
;		         window may be magnifed using either the right or left
;		         mouse buttons.  The left button magnifies the displayed
;		         pixels, directly from the graphics window.  The right
;		         button magnifies the data itself, without the overlays.
;
;		XY Zoom: Same as 'zoom' above, except the aspect ratio is
;                        set by the proportions of the selected box.
;
;	 Graphics window: The graphics window displays the image associated 
;	                  with the given data descriptor using the current 
;	                  zoom, offset, and display order.  The edges of the
;	                  image are indicated by a dotted line.
;
;	 Pixel readout: The cursor position and corresponding data value are
;	                are displayed beneath the graphics window, next to the
;	                message line.
;
;	 Message line: The message line displays short messages pertaining
;	               grim's current state.
;
; RESOURCE NAMES
;	The following X-windows resource names apply to grim:
;	 grim_base:		top level base
;	 grim_mbar:		menu bar
;	 grim_shortcuts_base:	base containing shortcut buttons
;	 grim_modes_base:	base containing modes buttons
;	 grim_draw:		grim draw widget
;	 grim_label:		grim bottom label widget
;
;	To turn off the confusing higlight box around the modes buttons, 
;	put the following line in your ~/.Xdefaults file:
;
;	 Idl*grim_modes_base*highlightThickness:	0
;
;
; OPERATION:
;	Grim maintains any number of image planes as well as associated
;	geometric data (camera, planet, ring, star descriptors) for each of
;	those planes.  Image planes are completely independent unless the 
;	user chooses to display them simultaneously in separate red, green,
;	and blue display channels.
;
;	Each image plane also contains numerous overlay arrays for displaying
;	various geometric objects -- limbs, rings, stars, etc.  An array of 
;	user overlay points is maintained to be used for application-specific
;	purposes.  Generally, a set of overlay points or a descriptor must be
;	activated in order to be used as input to a menu item; see activate 
;	mode above.  
;
;	There are exclusive and non-exclusive mechanisms for selecting grim
;	windows.  Grim windows may be non-exclusively selected using the select
;	mode button mentioned above (upper-left corner).  The exclusive
;	selection mechanism consists of a 'primary' grim window, indicated by 
;	a red outline in the graphics window.  The primary selection is 
;	changed by pressing any mode or shortcut button, or by clicking in 
;	the graphics area of the desired grim window.
;
;
; EXAMPLES:
;	(1) To create a new grim instance with no data:
;
;		IDL> grim, /new
;
;	(2) To create a new grim instance with data from a file of name
;	    "filename":
;
;		IDL> dd = dat_read(filename)
;		IDL> grim, dd
;
;	(3) To give a grim instance a new camera descriptor:
;
;		IDL> grim, cd=cd
;
;
; STATUS:
;	Incomplete.
;
;
; SEE ALSO:
;	ingrid, gr_draw
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale 7/2002
;	
;-
;=============================================================================

@grim_bitmaps.include
@grim_util.include
@grim_planes.include
@grim_data.include
@grim_user.include
@grim_compute.include
@grim_overlays.include
@grim_descriptors.include
@grim_image.include


;=============================================================================
; grim_constants
;
;=============================================================================
pro grim_constants
@grim_constants.common

 MAG_SIZE_DEVICE = 101				; must be odd
 MAG_SIZE_DATA = 21				; must be odd

 MAG_SIZE_DEVICE = 201				; must be odd
 MAG_SIZE_DATA = 41				; must be odd


 CONTEXT_SIZE = 100
 AXES_SIZE = 125

 SCALE_WIDTH = 10

 MARK_FRESH = 1b
 MARK_STALE = 2b
end
;=============================================================================



;=============================================================================
; grim_resize
;
;=============================================================================
pro grim_resize, grim_data, base_xsize, base_ysize, init=init

 ;-------------------------
 ; get current info
 ;-------------------------
 base_geom = widget_info(grim_data.base, /geom) 
 sub_base_geom = widget_info(grim_data.sub_base, /geom) 
 modes_base_geom = widget_info(grim_data.modes_base, /geom) 
 draw_geom = widget_info(grim_data.draw, /geom) 
 shortcuts_base_geom = widget_info(grim_data.shortcuts_base, /geom) 
 label_geom = widget_info(grim_data.label, /geom) 
 xy_label_geom = widget_info(grim_data.xy_label, /geom) 
 mbar_geom = widget_info(grim_data.mbar, /geom) 

 mbar_height = widget_get_mbar_height()

 ;-------------------------
 ; set  sizes
 ;-------------------------
 if(NOT keyword_set(base_xsize)) then $
                  base_xsize = base_geom.xsize + 2*base_geom.margin
 if(NOT keyword_set(base_ysize)) then $
                  base_ysize = base_geom.ysize + 2*base_geom.margin

 sub_base_xsize = sub_base_geom.xsize + 2*sub_base_geom.margin
 sub_base_ysize = sub_base_geom.ysize + 2*sub_base_geom.margin

 modes_base_xsize = modes_base_geom.xsize + 2*modes_base_geom.margin
 modes_base_ysize = modes_base_geom.ysize + 2*modes_base_geom.margin

 shortcuts_base_ysize = shortcuts_base_geom.ysize + 2*shortcuts_base_geom.margin

 label_xsize = label_geom.xsize + 2*label_geom.margin
 label_ysize = label_geom.ysize + 2*label_geom.margin

 draw_xsize = base_xsize - modes_base_xsize
 draw_ysize = base_ysize - label_ysize - mbar_height - shortcuts_base_ysize

 widget_control, grim_data.draw_base, $
	scr_xsize=draw_xsize, scr_ysize=draw_ysize
 widget_control, grim_data.draw, $
	scr_xsize=draw_xsize, scr_ysize=draw_ysize
; widget_control, grim_data.modes_base, $
;	scr_xsize=modes_base_xsize
;	scr_ysize=base_ysize - label_ysize - mbar_height - shortcuts_base_ysize
 widget_control, grim_data.label, scr_xsize=base_xsize - xy_label_geom.xsize




; draw_geom = widget_info(grim_data.draw, /geom) 
; draw_xsize = draw_geom.xsize
; draw_ysize = draw_geom.ysize

 ;-------------------------
 ; modify pixmap
 ;-------------------------
 pixmap = grim_data.pixmap

 wnum = !d.window
 window, /free, /pixmap, xsize=draw_xsize, ysize=draw_ysize
 grim_data.pixmap = !d.window

 if(pixmap NE -1) then $
  begin
   device, copy=[0,0, draw_xsize-1,draw_ysize-1, 0,0, wnum]
   wdelete, pixmap
  end
 wset, wnum


 ;-------------------------
 ; modify redraw pixmap
 ;-------------------------
 redraw_pixmap = grim_data.redraw_pixmap

 wnum = !d.window
 window, /free, /pixmap, xsize=draw_xsize, ysize=draw_ysize
 grim_data.redraw_pixmap = !d.window

 if(redraw_pixmap NE -1) then $
  begin
   device, copy=[0,0, draw_xsize-1,draw_ysize-1, 0,0, wnum]
   wdelete, redraw_pixmap
  end
 wset, wnum


 ;-------------------------
 ; modify overlay pixmap
 ;-------------------------
 overlay_pixmap = grim_data.overlay_pixmap

 wnum = !d.window
 window, /free, /pixmap, xsize=draw_xsize, ysize=draw_ysize
 grim_data.overlay_pixmap = !d.window

 if(overlay_pixmap NE -1) then $
  begin
   device, copy=[0,0, draw_xsize-1,draw_ysize-1, 0,0, wnum]
   wdelete, overlay_pixmap
  end
 wset, wnum



 ;-------------------------
 ; modify guideline pixmap
 ;-------------------------
 if(keyword_set(grim_data.guideline_pixmaps[0])) then $
                                     wdelete, grim_data.guideline_pixmaps[0]
 window, /free, xsize=draw_xsize, ysize=1, /pixmap
 grim_data.guideline_pixmaps[0] = !d.window


 if(keyword_set(grim_data.guideline_pixmaps[1])) then $
                                     wdelete, grim_data.guideline_pixmaps[1]
 window, /free, xsize=1, ysize=draw_ysize, /pixmap
 grim_data.guideline_pixmaps[1] = !d.window
 wset, wnum


 grim_data.base_xsize = base_geom.xsize
 grim_data.base_ysize = base_geom.ysize


 grim_set_data, grim_data, grim_data.base
 if(NOT keyword_set(init)) then grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
; grim_set_tracking
;
;=============================================================================
pro grim_set_tracking, grim_data

 widget_control, grim_data.draw, draw_motion_events=grim_data.tracking
 widget_control, grim_data.context_draw, draw_motion_events=grim_data.tracking
 if(NOT grim_data.tracking) then $
       widget_control, grim_data.xy_label, set_value='Tracking off' $
 else widget_control, grim_data.xy_label, set_value='Tracking on'

end
;=============================================================================



;=============================================================================
; grim_test_motion_event
;
;=============================================================================
function grim_test_motion_event, event

 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then return, 1

 if(struct EQ 'WIDGET_DRAW') then if(event.type EQ 2) then return, 1

 return, 0
end
;=============================================================================



;=============================================================================
; grim_get_cmds
;
;=============================================================================
function grim_get_cmds, grim_data, all=all

 if(keyword_set(all)) then $
  begin
   planes = grim_get_plane(grim_data, /all)
   cmds = reform(planes.cmd)
   cmds.data = planes.pn
   return, cmds
  end

 plane = grim_get_plane(grim_data)
 return, plane.cmd
end
;=============================================================================



;=============================================================================
; grim_set_ct
;
;=============================================================================
pro grim_set_ct, grim_data
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

 tvlct, *grim_data.tv_rp, *grim_data.tv_gp, *grim_data.tv_bp
 r_curr = *grim_data.tv_rp
 g_curr = *grim_data.tv_gp
 b_curr = *grim_data.tv_bp
end
;=============================================================================



;=============================================================================
; grim_set_mode
;
;=============================================================================
pro grim_set_mode, grim_data, mode, new=new, init=init, data_p=data_p

 if(keyword_set(mode)) then grim_data.mode = mode $
 else mode = grim_data.mode

 if(keyword_set(new)) then grim_set_primary, grim_data.base

 if(keyword_set(new) OR keyword_set(init)) then $
  begin
   wid = grim_data.modes_base
   repeat $
    begin
     wid = widget_info(wid+1, find_by_uname='mode')
     if(keyword_set(wid)) then $
      begin
       widget_control, wid, get_uvalue=name
       if(size(name, /type) NE 7) then name = name.name
       if(name EQ mode) then widget_control, wid, sensitive=0 $
       else widget_control, wid, sensitive=1
      end
    endrep until(wid EQ 0)
  end

 if(keyword_set(data_p)) then grim_data.mode_data_p = data_p

 swap = grim_get_cursor_swap(grim_data)

 cursor_modes = *grim_data.cursor_modes_p
 data_p = 0
 if(keyword_set(cursor_modes)) then $
  begin
   names = cursor_modes.name
   w = where(names EQ mode)
   if(w[0] NE -1) then $
    begin
     data_p = cursor_modes[w].data_p
     grim_data.mode_data_p = data_p
    end
  end

 call_procedure, mode + '_mode', grim_data, data_p


end
;=============================================================================



;=============================================================================
; grim_write_ptd
;
;=============================================================================
pro grim_write_ptd, grim_data, filename

 xoff = 0.5
 yoff = 2.0
 bits_per_pixel = 8

 ;--------------------------------------------------------------
 ; set coord. sys and get clipped, scaled image
 ;--------------------------------------------------------------
 grim_wset, grim_data, grim_data.wnum, get_info=tvd
 grim_refresh, grim_data, tvimage=_tvimage, $
                                    /no_back, /no_context, /no_callback

 ;--------------------------------------------------------------
 ; find device coords of image corners
 ;--------------------------------------------------------------
 s = size(grim_image(grim_data, plane=plane))
 xsize = s[1]
 ysize = s[2]

 p = fix(convert_coord(0d,0d, /data, /to_device, /double))
 q = fix(convert_coord(double(xsize-1),double(ysize-1), /data, /to_device)) - 1

 x0 = min([p[0], q[0]])
 x1 = max([p[0], q[0]])
 y0 = min([p[1], q[1]])
 y1 = max([p[1], q[1]])

 if(tvd.order) then $
  begin
   yy0 = y0
   yy1 = y1
   y0 = !d.y_size-1 - yy1
   y1 = !d.y_size-1 - yy0
  end

 x0 = x0 > 0
 x1 = x1 < !d.x_size-1
 y0 = y0 > 0
 y1 = y1 < !d.y_size-1

 ;--------------------------------------------------------------
 ; trim image, allowing a bit of safety
 ;--------------------------------------------------------------
 xs = x1-x0-2
 ys = y1-y0-2
 _tvimage = _tvimage[0:xs, 0:ys]

 x1 = x0 + xs
 y1 = y0 + ys

 ;--------------------------------------------------------------
 ; insert into image to plot
 ;--------------------------------------------------------------
 type = size(_tvimage, /type)
 tvimage = make_array(!d.x_size, !d.y_size, type=type)
 tvimage[x0:x1, y0:y1] = _tvimage

 ;--------------------------------------------------------------
 ; determine aspect ratio --
 ;  Currently, the overlays are not properly drawn if any edge
 ;  of the image is visible in the graphics window.
 ;--------------------------------------------------------------
 aspect = double(!d.x_size)/double(!d.y_size)
 if(aspect GE 1.0) then $
  begin
   xsize = 7.5
   ysize = xsize / aspect
  end $
 else $
  begin
   ysize = 7.5
   xsize = ysize * aspect
  end

 ;--------------------------------------------------------------
 ; Without this step, the overlays may be drawn incorrectly
 ; the first time in a session.  I don't know why.
 ;--------------------------------------------------------------
 set_plot, 'PS'
 device, /color, filename=filename, bits_per_pixel=bits_per_pixel, $
         xsize=xsize, ysize=ysize, /inches, xoffset=xoff, yoffset=yoff
 device, /close
 set_plot, 'X'


 ;--------------------------------------------------------------
 ; write the PS file 
 ;--------------------------------------------------------------
 set_plot, 'PS'
 device, /color, filename=filename, bits_per_pixel=bits_per_pixel, $
         xsize=xsize, ysize=ysize, /inches, xoffset=xoff, yoffset=yoff

 ctmod, top=top
 tv, tvimage, order=tvd.order, top=top
 grim_refresh, grim_data, tvimage=tvimage, $
           /no_image, /no_callback, /no_wset, /no_coord, /no_context, /no_back

 device, /close
 set_plot, 'X'

end
;=============================================================================



;=============================================================================
; grim_write
;
;=============================================================================
pro grim_write, grim_data

 widget_control, /hourglass
 plane = grim_get_plane(grim_data)
 grim_suspend_events

 ;---------------------------------------------
 ; output descriptors
 ;---------------------------------------------
 if(keyword_set(*plane.cd_p)) then $
  case grim_test_map(grim_data) of
    0 : $
	begin
	 pg_put_cameras, plane.dd, cd=*plane.cd_p
	 od = *plane.cd_p
	end
    1 : $
	begin
	 pg_put_maps, plane.dd, md=*plane.cd_p
	 od = *plane.od_p
	end
  endcase

 if(keyword_set(*plane.pd_p)) then $
            pg_put_planets, plane.dd, pd=*plane.pd_p, od=od

 if(keyword_set(*plane.rd_p)) then $
              pg_put_rings, plane.dd, rd=*plane.rd_p, od=od

 if(keyword_set(*plane.sd_p)) then $
              pg_put_stars, plane.dd, sd=*plane.sd_p, od=od

; if(keyword_set(*plane.std_p)) then $ 
 ;             pg_put_stations, plane.dd, std=*plane.std_p, od=od ;no such function

 if(keyword_set(*plane.ard_p)) then $
              pg_put_stations, plane.dd, ard=*plane.ard_p, od=od

 if(keyword_set(*plane.sund_p)) then $
              pg_put_stars, plane.dd, sd=*plane.sund_p, od=od

 grim_resume_events

 ;---------------------------------------------
 ; write data
 ;---------------------------------------------
 dat_write, plane.filename, plane.dd, filetype=plane.filetype

end
;=============================================================================



;=============================================================================
; grim_get_save_filename
;
;=============================================================================
function grim_get_save_filename, grim_data

 plane = grim_get_plane(grim_data)

 if(keyword_set(plane.save_path)) then path = plane.save_path $
 else if(keyword_set(plane.load_path)) then path = plane.load_path

 types = strupcase(dat_detect_filetype(/all))
 w = where(strupcase(plane.filetype) EQ types)

 if(w[0] NE -1) then $
   types = [types[w[0]], rm_list_item(types, w[0], only='')]

 filename = pickfiles(get_path=get_path, $
                   title='Select filename for saving', path=path, /one, $
       options=['Filetype:',types], sel=filetype)

 if(NOT keyword_set(filename)) then return, -1

 plane.filename = filename
 plane.save_path = get_path
 plane.filetype = filetype

 grim_set_plane, grim_data, plane

 return, 0
end
;=============================================================================



;=============================================================================
; grim_kill_notify
;
;=============================================================================
pro grim_kill_notify, top
@grim_block.include

 grim_data = grim_get_data(top, /dead)

 if(grim_data.pixmap NE -1) then wdelete, grim_data.pixmap
 if(grim_data.redraw_pixmap NE -1) then wdelete, grim_data.redraw_pixmap
 if(grim_data.overlay_pixmap NE -1) then wdelete, grim_data.overlay_pixmap

 for i=0, grim_data.n_planes-1 do $
  begin
   plane = grim_get_plane(grim_data, pn=i)

   nv_notify_unregister, plane.dd, 'grim_descriptor_notify'
   if(keyword_set(*plane.cd_p)) then nv_notify_unregister, *plane.cd_p, 'grim_descriptor_notify'
   if(keyword_set(*plane.pd_p)) then nv_notify_unregister, *plane.pd_p, 'grim_descriptor_notify'
   if(keyword_set(*plane.rd_p)) then nv_notify_unregister, *plane.rd_p, 'grim_descriptor_notify'
   if(keyword_set(*plane.sd_p)) then nv_notify_unregister, *plane.sd_p, 'grim_descriptor_notify'
   if(keyword_set(*plane.std_p)) then nv_notify_unregister, *plane.std_p, 'grim_descriptor_notify'
   if(keyword_set(*plane.ard_p)) then nv_notify_unregister, *plane.ard_p, 'grim_descriptor_notify'
   if(keyword_set(*plane.sund_p)) then nv_notify_unregister, *plane.sund_p, 'grim_descriptor_notify'

   nv_ptr_free, [plane.cd_p, plane.pd_p, plane.rd_p, plane.sd_p, plane.std_p, plane.ard_p, plane.sund_p, $
             plane.od_p, plane.active_xd_p, plane.active_overlays_ptdp,$
             grim_get_overlay_ptdp(grim_data, plane=plane, 'limb'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'ring'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'terminator'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'star'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'station'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'array'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'planet_grid'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'ring_grid'), $
             grim_get_overlay_ptdp(grim_data, plane=plane, 'planet_center'), $
             plane.user_ptd_tlp]
  end

 nv_ptr_free, [grim_data.rf_callbacks_p, grim_data.rf_callbacks_data_pp, $
           grim_data.planes_p, grim_data.pl_flags_p, $
           grim_data.menu_ids_p, grim_data.menu_desc_p]

 grim_grnum_destroy, grim_data.grnum

 w = where(_all_tops EQ top)
 _all_tops = rm_list_item(_all_tops, w[0], only=0)
 if(keyword_set(_all_tops[0])) then $
                    grim_set_primary, _all_tops[n_elements(_all_tops)-1]

end
;=============================================================================



;=============================================================================
; grim_load_files
;
;=============================================================================
pro grim_load_files, grim_data, filenames, load_path=load_path

 plane = grim_get_plane(grim_data)
 filter = plane.filter

 ;------------------------------------
 ; load each file onto a new plane
 ;------------------------------------
 nfiles = n_elements(filenames)

 first = 1
 for i=0, nfiles-1 do $
  begin
   dd = dat_read(filenames[i], /silent, nhist=grim_data.nhist, $
            maintain=grim_data.maintain, compress=grim_data.compress, extensions=grim_data.extensions)
   if(keyword_set(dd)) then $
    begin
     grim_add_planes, grim_data, dd, pn=pn, filter=filter

     if(first) then $
      begin
       first = 0
       grim_data.pn = pn[0]
      end

     plane = grim_get_plane(grim_data, pn=pn)
     plane.filename = filenames[i]
     plane.load_path = load_path

     grim_set_plane, grim_data, plane, pn=pn

     nv_notify_register, dd, 'grim_descriptor_notify', scalar_data=grim_data.base
   end
  end


 grim_set_data, grim_data, grim_data.base

 ;------------------------------------
 ; set initial zoom and display image
 ;------------------------------------
 dim = dat_dim(dd)
 geom = widget_info(grim_data.draw, /geom)

 zoom = double(geom.xsize) / double(dim[0])
 offset = [0d,0d]

 grim_wset, grim_data, grim_data.wnum, get_info=tvd
 grim_refresh, grim_data, zoom=zoom, offset=offset, order=tvd.order
 grim_wset, grim_data, /save

end
;=============================================================================



;=============================================================================
; grim_deactivate_all
;
;=============================================================================
pro grim_deactivate_all, plane

 grim_deactivate_all_overlays, plane
 grim_deactivate_all_xds, plane

end
;=============================================================================



;=============================================================================
; grim_activate_all
;
;=============================================================================
pro grim_activate_all, plane

 grim_activate_all_overlays, plane
 grim_activate_all_xds, plane

end
;=============================================================================



;=============================================================================
; grim_modify_colors
;
;=============================================================================
pro grim_modify_colors_callback, cmd, cb_data, all=all

 grim_data = grim_get_data(/primary)
 if(NOT keyword_set(grim_data)) then return

 ctmod, visual=visual

 ;--------------------------------------
 ; detect color table change
 ;--------------------------------------
 tvlct, r, g, b, /get
 w = where([r, g, b] - $
           [*grim_data.tv_rp, *grim_data.tv_gp, *grim_data.tv_bp] NE 0)
 if((w[0] NE -1) AND (visual NE 24)) then $
  begin
   *grim_data.tv_rp = r
   *grim_data.tv_gp = g
   *grim_data.tv_bp = b
   return
  end

 ;--------------------------------------
 ; update cmd
 ;--------------------------------------
 if(keyword_set(all)) then $
  begin
   _cmds = grim_get_cmds(grim_data, /all)
   n = n_elements(_cmds)
   for i=0, n-1 do $
    begin
     pn = _cmds[i].data
     plane = grim_get_plane(grim_data, pn=pn)
     plane.cmd = cmd
     plane.cmd.data = pn
     grim_set_plane, grim_data, plane, pn=pn
    end
  end $
 else $
  begin
   pn = cmd.data
   plane = grim_get_plane(grim_data, pn=pn)
   plane.cmd = cmd
   grim_set_plane, grim_data, plane, pn=pn
  end

 grim_set_data, grim_data, grim_data.base
 grim_refresh, grim_data, /no_erase
end
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
pro grim_modify_colors, grim_data

 ctmod, top=top

 plane = grim_get_plane(grim_data)

 cmds = grim_get_cmds(grim_data)
 grim_colortool, cmds, plane.dd, callback='grim_modify_colors_callback', cb_data=0


end
;=============================================================================



;=============================================================================
; grim_edit_header
;
;=============================================================================
pro grim_edit_header, grim_data

 plane = grim_get_plane(grim_data)
 widget_control, grim_data.draw, /hourglass

 if(NOT widget_info(grim_data.header_text, /valid)) then $
  begin
   header = dat_header(plane.dd)   
   grim_data.header_text = $
               textedit(header, base=base, resource='grim_header', ysize=40)
   grim_data.header_base = base
   grim_set_data, grim_data
   grim_refresh, grim_data, /no_image, /no_objects
  end $
 else widget_control, grim_data.header_base, /map

; hide button

end
;=============================================================================



;=============================================================================
; grim_edit_notes
;
;=============================================================================
pro grim_edit_notes, grim_data, plane=plane

 widget_control, grim_data.draw, /hourglass

 if(NOT widget_info(grim_data.notes_text, /valid)) then $
  begin
   grim_data.notes_text = $
          textedit(*plane.notes_p, base=base, /editable, resource='grim_notes')
   grim_data.notes_base = base
   grim_set_data, grim_data
   grim_refresh, grim_data, /no_image, /no_objects
  end $
 else widget_control, grim_data.notes_base, /map

; hide button

end
;=============================================================================



;=============================================================================
; grim_user_ptd_fname
;
;=============================================================================
function grim_user_ptd_fname, grim_data, plane, basename=basename

 if(NOT keyword_set(basename)) then $
  begin
   basename = cor_name(plane.dd)
   if(NOT keyword_set(basename)) then basename = 'grim-' + strtrim(plane.pn,2)
  end

 return, grim_data.workdir + '/' + basename + '.user_ptd'
end
;=============================================================================



;=============================================================================
; grim_write_user_points
;
;=============================================================================
pro grim_write_user_points, grim_data, plane, fname=_fname

 if(NOT keyword_set(_fname)) then $
             fname = grim_user_ptd_fname(grim_data, plane) $
 else fname = _fname

 user_ptd = grim_get_user_ptd(plane=plane)

 w = where(pnt_valid(user_ptd))
 if(w[0] NE -1) then pnt_write, fname, user_ptd $
 else $
  begin
   ff = file_search(fname)
   if(keyword_set(ff)) then spawn, 'rm -f ' + fname
  end

end
;=============================================================================



;=============================================================================
; grim_mask_fname
;
;=============================================================================
function grim_mask_fname, grim_data, plane, basename=basename
 if(NOT keyword_set(basename)) then basename = cor_name(plane.dd)
 return, grim_data.workdir + '/' + basename + '.mask'
end
;=============================================================================



;=============================================================================
; grim_write_mask
;
;=============================================================================
pro grim_write_mask, grim_data, plane, fname=fname

 if(NOT keyword_set(fname)) then $
                fname = grim_mask_fname(grim_data, plane)

 mask = *plane.mask_p
 if(mask[0] EQ -1) then return

 if(mask[0] NE -1) then write_mask, fname, mask, dim=dat_dim(plane.dd) $
 else $
  begin
   ff = file_search(fname)
   if(keyword_set(ff)) then spawn, 'rm -f ' + fname
  end

end
;=============================================================================



;=============================================================================
; grim_read_user_points
;
;=============================================================================
pro grim_read_user_points, grim_data, plane

 fname = grim_user_ptd_fname(grim_data, plane)

 ff = (file_search(fname))[0]
 if(keyword_set(ff)) then user_ptd = pnt_read(ff) $
 else user_ptd = 0

 w = where(pnt_valid(user_ptd))
 if(w[0] NE -1) then $
  begin
   n = n_elements(user_ptd)
   tags = strarr(n)

   for i=0, n-1 do $
    begin
     tag = cor_name(user_ptd[i])
     tags[i] = tag
    end

   for i=0, n-1 do $
    begin
     w = where(tags EQ tags[i])
     if(w[0] NE -1) then $
      begin
       grim_add_user_points, user_ptd[w], [tags[i]], plane=plane, /no_refresh
       tags[w] = ''
      end
    end


  end

end
;=============================================================================



;=============================================================================
; grim_read_mask
;
;=============================================================================
pro grim_read_mask, grim_data, plane, fname=fname

 if(NOT keyword_set(fname)) then fname = grim_mask_fname(grim_data, plane)

 ff = (file_search(fname))[0]
 if(keyword_set(ff)) then mask = read_mask(ff, sub=sub) $
 else mask = -1

 if(mask[0] NE -1) then grim_add_mask, grim_data, sub, plane=plane, /replace, /sub

end
;=============================================================================



;=============================================================================
; grim_jumpto
;
;=============================================================================
function grim_jumpto, grim_data, id

 if(keyword_set(id)) then $
  begin
   widget_control, id, get_value=pns
   if(pns[0] EQ '') then return, 0
   widget_control, grim_data.jumpto_text, set_value=''
   w = str_isnum(pns)
   if(w[0] EQ -1) then return, 0
  end $
 else $
  begin
   done = 0
   repeat $
    begin
     pns = dialog_input('Plane number:')
     if(NOT keyword_set(pns)) then return, 0
     w = str_isnum(pns)
     if(w[0] NE -1) then done = 1
    endrep until(done)
  end

 pn = (long(pns))[0]
 grim_jump_to_plane, grim_data, pn, valid=valid

 return, valid
end
;=============================================================================



;=============================================================================
; grim_recenter
;
;=============================================================================
pro grim_recenter, grim_data, p

 cx = !d.x_size/2
 cy = !d.y_size/2
 q = convert_coord(double(cx), double(cy), /device, /to_data)

 grim_refresh, grim_data, doffset=(p-q)[0:1]

end
;=============================================================================



;=============================================================================
; grim_zoom
;
;=============================================================================
function grim_zoom, grim_data

 done = 0
 repeat $
  begin
   zs = dialog_input('New zoom:')
   if(NOT keyword_set(zs)) then return, 0
   w = str_isfloat(zs)
   if(w[0] NE -1) then done = 1
  endrep until(done)

 zoom = double(zs)
 return, zoom
end
;=============================================================================



;=============================================================================
; grim_zoom_to_cursor
;
;=============================================================================
function grim_zoom_to_cursor, zz, relative=relative, zoom=zoom

 tvim, get_info=tvd, /silent
 if(keyword_set(relative)) then zoom = tvd.zoom*zz $
 else zoom = zz

 zf = zoom / tvd.zoom

 cursor, x, y, /nowait, /data
 device_cc = transpose([transpose([0,0]), transpose([!d.x_size-1, !d.y_size-1])])
 data_cc = (convert_coord(double(device_cc[0,*]), double(device_cc[1,*]), /device, /to_data))[0:1,*]
 data_size = abs(data_cc[*,0] - data_cc[*,1])

 new_data_size = data_size/zf

 ff = [(x-tvd.offset[0])/(data_size[0]-1), (y-tvd.offset[1])/(data_size[1]-1)]
 offset = [x-new_data_size[0]*ff[0], y-new_data_size[1]*ff[1]] + 1

 return, offset
end
;=============================================================================



;=============================================================================
; grim_modes_list
;
;=============================================================================
function grim_modes_list, grim_data

 base = grim_data.modes_base
 repeat $
  begin
   id = widget_info(base, /child)
   repeat $
    begin
     widget_control, id, get_uvalue=name
     if(size(name, /type) EQ 8) then name = name.name
     modes = append_array(modes, name)
     id = widget_info(id, /sibling)
    endrep until(id EQ 0)
   base = widget_info(base, /sibling)
  endrep until(base EQ 0)

 return, modes
end
;=============================================================================



;=============================================================================
; grim_interrupt_begin
;
;=============================================================================
pro grim_interrupt_begin, grim_data, plane=plane
common grim_interrupt_block, base

 if(NOT keyword__set(plane)) then plane = grim_get_plane(grim_data)

 ;------------------------------------------
 ; save the current state
 ;------------------------------------------
; data = ...

 ;------------------------------------------
 ; open the interrupt dialog
 ;------------------------------------------
 _base = dialog_interrupt(callback='grim_interrupt_callback', data=data)
 if(_base NE -1) then base = _base

end
;=============================================================================



;=============================================================================
; grim_interrupt_end
;
;=============================================================================
pro grim_interrupt_end, grim_data, plane=plane
common grim_interrupt_block, base

 if(NOT keyword__set(plane)) then plane = grim_get_plane(grim_data)

 ;------------------------------------------
 ; destroy the interrupt dialog
 ;------------------------------------------
 widget_control, base, /destroy


end
;=============================================================================



;=============================================================================
; grim_toggle_context
;
;=============================================================================
pro grim_toggle_context, grim_data

 ;----------------------------
 ; toggle the mapping state
 ;----------------------------
 if(grim_data.context_mapped) then grim_data.context_mapped = 0 $
 else grim_data.context_mapped = 1
 grim_set_data, grim_data, grim_data.base

 ;------------------------------------------------------
 ; if mapped, copy the image onto the window
 ;------------------------------------------------------
 if(grim_data.context_mapped) then $
  begin
   grim_refresh, grim_data, /no_main
   grim_show_context_image, grim_data
  end

 ;----------------------------
 ; set the new mapping state
 ;----------------------------
 widget_control, grim_data.context_base, map=grim_data.context_mapped

end
;=============================================================================



;=============================================================================
; grim_toggle_axes
;
;=============================================================================
pro grim_toggle_axes, grim_data

 ;---------------------------------------------------------
 ; toggle axes flag
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_data.axes_flag = NOT grim_data.axes_flag

 ;----------------------------
 ; set the new mapping state
 ;----------------------------
 widget_control, grim_data.axes_base, map=grim_data.axes_flag

 grim_set_data, grim_data, grim_data.base

 ;------------------------------------------------------
 ; if mapped, copy the image onto the window
 ;------------------------------------------------------
 if(grim_data.axes_flag) then grim_show_axes, grim_data

end
;=============================================================================



;=============================================================================
; grim_render
;
;=============================================================================
pro grim_render, grim_data, plane=plane

 if(grim_data.type EQ 'plot') then return

 ;---------------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;---------------------------------------------------------
; grim_load_descriptors, grim_data, name, plane=plane, $
;       cd=cd, pd=pd, rd=rd, sund=sund, sd=sd, ard=ard, std=std, od=od, $
;       replace=replace, gd=gd
 grim_load_descriptors, grim_data, 'limb', plane=plane


 ;---------------------------------------------------------
 ; render
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, /hourglass


 ;---------------------------------------------------------
 ; Create new plane unless the current one is a rendering
 ;  The new plane will include a transformation that allows
 ;  the rendering to appear in the correct location in the
 ;  display relative to the data coordinate system.
 ;---------------------------------------------------------
 if(NOT plane.rendering) then $
  begin
   new_plane = grim_clone_plane(grim_data, plane=plane)
   new_plane.rendering = 1
   new_plane.dd = nv_clone(plane.dd)

   dat_set_sampling_fn, new_plane.dd, 'grim_render_sampling_fn'

   dat_set_dim_fn, new_plane.dd, 'grim_render_dim_fn'
   dat_set_dim_data, new_plane.dd, dat_dim(plane.dd)

   nv_notify_register, new_plane.dd, 'grim_descriptor_notify', scalar_data=grim_data.base

   grim_set_plane, grim_data, new_plane

   grim_jump_to_plane, grim_data, new_plane.pn
   grim_refresh, grim_data, /no_image
  end $
 else new_plane = plane


 ;---------------------------------------------------------
 ; set up grid
 ;---------------------------------------------------------
 nv_suspend_events

 device_pts = gridgen([!d.x_size,!d.y_size])
 image_pts = (convert_coord(device_pts, /device, /to_data))[0:1,*]
 image_pts = reform(image_pts, 2, !d.x_size,!d.y_size, /over)

 dat_set_sampling_data, new_plane.dd, image_pts
 grim_set_plane, grim_data, new_plane
 grim_set_data, grim_data, grim_data.base


 ;---------------------------------------------------------
 ; perform rendering
 ;---------------------------------------------------------
 grim_render_image, grim_data, plane=new_plane, image_pts=image_pts

 nv_resume_events

 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
; grim_erase_guideline
;
;=============================================================================
pro grim_erase_guideline, grim_data

 x = grim_data.guideline_save_xy[0]
 y = grim_data.guideline_save_xy[1]

 if(x LT 0) then return

 device, copy=[0,0, !d.x_size,1, 0,y, grim_data.guideline_pixmaps[0]]
 device, copy=[0,0, 1,!d.y_size, x,0, grim_data.guideline_pixmaps[1]]

end
;=============================================================================



;=============================================================================
; grim_draw_guideline
;
;=============================================================================
pro grim_draw_guideline, grim_data, x, y

 ;--------------------------------------
 ; save window regions
 ;--------------------------------------
 wnum = !d.window
 wset, grim_data.guideline_pixmaps[0]
 device, copy=[0,y, !d.x_size,1, 0,0, wnum]
 wset, grim_data.guideline_pixmaps[1]
 device, copy=[x,0, 1,!d.y_size, 0,0, wnum]
 wset, wnum
 grim_data.guideline_save_xy = [x,y]

 ;--------------------------------------
 ; draw guidelines
 ;--------------------------------------
 line = 0
 color = ctred()
 plots, [0,!d.x_size], [y, y], line=line, /device, col=color
 plots, [x, x], [0,!d.y_size], line=line, /device, col=color

 grim_set_data, grim_data, grim_data.base
end
;=============================================================================



;=============================================================================
; grim_repeat
;
;=============================================================================
pro grim_repeat, grim_data

 if(keyword_set(grim_data.repeat_fn)) then $
             call_procedure, grim_data.repeat_fn, *grim_data.repeat_event_p

end
;=============================================================================



;=============================================================================
; grim_exit
;
;=============================================================================
pro grim_exit, grim_data

  if(NOT keyword_set(grim_data)) then grim_data = grim_get_data()
  if(NOT keyword_set(grim_data)) then return
  widget_control, grim_data.base, /destroy

end
;=============================================================================



;=============================================================================
; grim_undo
;
;=============================================================================
pro grim_undo, grim_data, plane

 dat_undo, plane.dd

end
;=============================================================================



;=============================================================================
; grim_redo
;
;=============================================================================
pro grim_redo, grim_data, plane

 dat_redo, plane.dd

end
;=============================================================================



;=============================================================================
; grim_interrupt_callback
;
;=============================================================================
pro grim_interrupt_callback, data
 if(NOT keyword__set(plane)) then plane = grim_get_plane(grim_data)

 ;------------------------------------------
 ; restore the old state
 ;------------------------------------------
;...

end
;=============================================================================



;=============================================================================
; grim_render_dim_fn
;
;
;=============================================================================
function grim_render_dim_fn, dd, dim_orig
 return, dim_orig
end
;=============================================================================



;=============================================================================
; grim_render_sampling_fn
;
;
;=============================================================================
function grim_render_sampling_fn, dd, source_image_pts_sample, source_image_pts_grid

 rdim = dat_dim(dd, /true)
 xdim = dat_dim(dd)

 dim = size(source_image_pts_sample, /dim)
 n = n_elements(source_image_pts_sample)

 if(dim[0] NE 2) then $
         source_image_pts_sample = w_to_xy(xdim, source_image_pts_sample)
 n = n_elements(source_image_pts_sample)/2

 render_image_pts_grid = gridgen(rdim, /rec, /double)

 xx = interpol(render_image_pts_grid[0,*,0], source_image_pts_grid[0,*,0], source_image_pts_sample[0,*])
 yy = interpol(render_image_pts_grid[1,0,*], source_image_pts_grid[1,0,*], source_image_pts_sample[1,*])

 render_image_pts_sample = round([xx,yy])
 w = where((render_image_pts_sample[0,*] LT 0) $
              OR render_image_pts_sample[0,*] GE rdim[0] $)
              OR render_image_pts_sample[1,*] LT 0 $
              OR render_image_pts_sample[1,*] GE rdim[1])

 samples = xy_to_w(rdim, render_image_pts_sample)

; w = where((samples LT 0) OR (samples GT n))

 if(w[0] NE -1) then samples[w] = -1

 return, samples
end
;=============================================================================



;=============================================================================
; grim_draw_vectors
;
;=============================================================================
pro grim_draw_vectors, cd, curves_ptd, points_ptd

 if(obj_valid(curves_ptd)) then $
  begin
   p = inertial_to_image_pos(cd, pnt_vectors(curves_ptd, /visible))
   pg_draw, reform(p), psym=3, col=ctgreen()
  end

 if(obj_valid(points_ptd)) then $
  begin
   p = inertial_to_image_pos(cd, pnt_vectors(points_ptd, /visible))
   pg_draw, reform(p), psym=1, col=ctgreen()
  end

end
;=============================================================================



;=============================================================================
; grim_increment_mode
;
;=============================================================================
pro grim_increment_mode, grim_data, dm

 modes = grim_modes_list(grim_data)
 nmodes = n_elements(modes)
 w = where(modes EQ grim_data.mode)
 ww = (w + dm)
 if(ww[0] LT 0) then ww = ww + nmodes 
 ww = ww mod nmodes
 grim_set_mode, grim_data, modes[ww[0]], /new

end
;=============================================================================



;=============================================================================
; grim_event
;
;=============================================================================
pro grim_event, event

 grim_data = grim_get_data(event.top)

 ;-----------------------------------
 ; for now, assume a resize event
 ;-----------------------------------
 grim_resize, grim_data, event.x, event.y

end
;=============================================================================



;=============================================================================
; grim_update_guideline
;
;=============================================================================
pro grim_update_guideline, grim_data, plane, x, y

 if(grim_data.guideline_flag) then $
  begin
   grim_erase_guideline, grim_data
   grim_draw_guideline, grim_data, x, y
  end

end
;=============================================================================



;=============================================================================
; grim_update_xy_label
;
;=============================================================================
pro grim_update_xy_label, grim_data, plane, x, y

 p = (convert_coord(double(x), double(y), /device, /to_data))[0:1]
 xx = str_pad(strtrim(p[0],2), 6)
 yy = str_pad(strtrim(p[1],2), 6)

 dn = ''
 dim = dat_dim(plane.dd)
 if(n_elements(dim) EQ 1) then dim = [dim, 1]

 ;- - - - - - - - - -  - - - 
 ; plot
 ;- - - - - - - - - -  - - - 
 if(grim_data.type EQ 'plot') then $
  begin
   if((p[0] GE 0) AND (p[0] LT dim[1])) then $
 			     dn = dat_data(plane.dd, sample=[1,p[0]], /nd)
  end $
 ;- - - - - - - - - -  - - - 
 ; image
 ;- - - - - - - - - -  - - - 
 else $
  begin
   p = round(p)
   if((p[0] GE 0) AND (p[0] LT dim[0]) AND $
      (p[1] GE 0) AND (p[1] LT dim[1])) then $
 				 dn = dat_data(plane.dd, sample=p, /nd)
  end

 if(size(dn, /type) EQ 1) then dn = fix(dn)
 dn = strtrim(string(dn, format='(g10.4)'),2)
 widget_control, grim_data.xy_label, $
 			     set_value='(' + xx + ',' + yy + '): ' + dn

end
;=============================================================================



;=============================================================================
; grim_scroll
;
;=============================================================================
pro grim_scroll, grim_data, plane, clicks, modifiers

 ;- - - - - - - - - - - - - - - - -
 ; No modifier -- change mde 
 ;- - - - - - - - - - - - - - - - -
 if(NOT keyword_set(modifiers)) then $
  begin
   dm = - clicks
   grim_increment_mode, grim_data, dm
   grim_set_data, grim_data;, event.top
  end $
 ;- - - - - - - - - - - - - - - - -
 ; Ctrl -- change zoom 
 ;- - - - - - - - - - - - - - - - -
 else if(modifiers EQ 2) then $
  begin
   dm = double(clicks)
   factor = 2d^dm
   offset = grim_zoom_to_cursor(factor, /relative, zoom=zoom)
   grim_refresh, grim_data, zoom=zoom, offset=offset
  end 

end
;=============================================================================



;=============================================================================
; grim_middle
;
;=============================================================================
pro grim_middle, grim_data, plane, id, x, y, press, clicks, modifiers, output_wnum

 if(press NE 2) then return

 if(grim_data.type EQ 'plot') then $
  begin
   xx = convert_coord(/data, /to_device,$
              [transpose(double(plane.xrange)), transpose(double(plane.yrange))])
   edge = [xx[0]+2, !d.x_size-xx[3]-1, xx[1]+2, !d.y_size-xx[4]-1]
   tvpan, wnum=input_wnum, /notvim, edge=edge, $
        	    p0=[x,y], cursor=60, hour=id, $
        	    output=output_wnum, col=ctred(), doffset=doffset
   grim_wset, grim_data, output_wnum
   grim_refresh, grim_data, doffset=doffset
  end $
 else $
  begin
   stat = grim_activate_by_point(/invert, plane, [x,y], clicks=clicks)
   if(stat NE -1) then grim_refresh, grim_data, /noglass, /no_image $
   else $
    begin
     tvpan, wnum=input_wnum, /noplot, edge=3, $
        	    p0=[x,y], cursor=60, hour=id, $
        	    output=output_wnum, col=ctred()
     grim_wset, grim_data, output_wnum
     grim_refresh, grim_data
    end
  end 
 grim_set_mode, grim_data

end
;=============================================================================



;=============================================================================
; grim_draw_event
;
;=============================================================================
pro grim_draw_event, event

 widget_control, event.id, get_value=value
 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, event.id, get_value=input_wnum
 output_wnum = grim_data.wnum

 struct = tag_names(event, /struct)
 
 if(NOT grim_test_motion_event(event)) then grim_set_primary, grim_data.base


 ;======================================
 ; motion event 
 ;======================================
 if(struct EQ 'WIDGET_DRAW') then if(event.type EQ 2) then $
  begin
   grim_update_xy_label, grim_data, plane, event.x, event.y
   grim_update_guideline, grim_data, plane, event.x, event.y
  end


 ;===================================
 ; middle button and scroll wheel
 ;===================================
 case struct of
  'WIDGET_DRAW' : $
   case event.type of
    ;- - - - - - - - - - - - - - - - -
    ; scroll wheel -- zoom / mode
    ;- - - - - - - - - - - - - - - - -
    7 : grim_scroll, grim_data, plane, event.clicks, event.modifiers

    ;- - - - - - - - - - - - - - - - -
    ; middle button -- pan / activate
    ;- - - - - - - - - - - - - - - - -
    0 : grim_middle, grim_data, plane, $
           event.id, event.x, event.y, $
           event.press, event.clicks, event.modifiers, output_wnum

    else : 
   endcase

  else : 
 endcase


 ;===================================
 ; cursor modes
 ;===================================
 data = 0
 if(keyword_set(grim_data.mode_data_p)) then data = *grim_data.mode_data_p
 call_procedure, grim_data.mode + '_mouse_event', event, data
 *grim_data.mode_data_p = data


 grim_wset, grim_data, grim_data.wnum
 grim_set_mode, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_event
;
;
; PURPOSE:
;	Allows user to load images into new image planes.  The user is 
;	prompted for filenames and dat_read is used to read each image.
;	Multiple images may be selected and a new plane is created for
;	each image.  On X-windows systems, multiple files may be selected 
;	either by dragging across the filenames or by holding down the 
;	control key to toggle the selected files.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_file_load_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_message, /clear
 
 widget_control, grim_data.base, /hourglass

 ;--------------------------
 ; select file
 ;--------------------------
 if(keyword__set(plane.load_path)) then path = plane.load_path
 filenames = pickfiles(get_path=get_path, path=path, $
                        filter=plane.filter, title='Select images to load')
 if(NOT keyword__set(filenames[0])) then return

 ;----------------------------------
 ; load each file into a new plane
 ;----------------------------------
 widget_control, grim_data.base, /hourglass
 grim_load_files, grim_data, filenames, load_path=get_path

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_browse_event
;
;
; PURPOSE:
;	Allows user to load images into new image planes using the brim 
;	browser.  Images are selected using the left mouse button and
;	each image is loaded on a new plane.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================
pro grim_menu_file_browse_help_event, event
 text = ''
 nv_help, 'grim_menu_file_browse_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_browse_file_left_event, base, i, id, status=status

 status = -1
 grim_data = grim_get_data(base)


 status = 0
end
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pro grim_menu_file_browse_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 widget_control, grim_data.base, /hourglass

 ;----------------------------------
 ; load images into brim
 ;----------------------------------
 if(keyword__set(plane.load_path)) then path = plane.load_path
 grim_wset, grim_data, grim_data.wnum, get_info=tvd

 brim, filenames, path=plane.load_path, get_path=get_path, ids=filenames, $
      left_fn='grim_browse_file_left_event', fn_data=event.top, /modal, $
      select=select, title='Select images to load', order=tvd.order, $
      filter=plane.filter, /enable
 if(NOT keyword__set(select)) then return
 if(select[0] EQ '') then return

 ;----------------------------------
 ; load each file into a new plane
 ;----------------------------------
 widget_control, grim_data.base, /hourglass
 grim_load_files, grim_data, select, load_path=get_path

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_event
;
;
; PURPOSE:
;	Allows user to save the current image plane and geometry.  If there 
;	is no current filename for the current plane, then the user is 
;	prompted for one.  All descriptors are written through the translators
;	and then dat_write is used to write the data file.  Specific behavior 
;	is governed by OMINAS' configuration.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_file_save_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 ;------------------------------------------------------
 ; prompt for filename if necessary
 ;------------------------------------------------------
 if(NOT keyword__set(plane.filename)) then $
  begin
   status = grim_get_save_filename(grim_data)
   if(keyword__set(status)) then return
  end

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_write, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_as_event
;
;
; PURPOSE:
;	Same as 'Save' above, except always prompts for a filename. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_file_save_as_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_as_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_as_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 ;------------------------------------------------------
 ; prompt for filename 
 ;------------------------------------------------------
 status = grim_get_save_filename(grim_data)
 if(keyword__set(status)) then return

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_write, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_user_ptd_event
;
;
; PURPOSE:
;	Writes user points for the current plane to a file called
;	[image name].user_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_save_user_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_user_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_user_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 ;------------------------------------------------------
 ; get filename
 ;------------------------------------------------------
 fname = pickfiles(default=grim_user_ptd_fname(grim_data, plane), $
                            title='Select filename for saving', /one)

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_write_user_points, grim_data, plane, fname=fname
 grim_print, grim_data, 'User points saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_all_user_ptd_event
;
;
; PURPOSE:
;	Writes user points for all planes to files called
;	[image name].user_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_save_all_user_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_all_user_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_all_user_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_write_user_points, grim_data, planes[i], fname=fname
 grim_print, grim_data, 'All user points saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_user_ptd_event
;
;
; PURPOSE:
;	loads user points for the current plane from a file called
;	[image name].user_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_load_user_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_user_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_user_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_read_user_points, grim_data, plane
 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_all_user_ptd_event
;
;
; PURPOSE:
;	Loads user points for all planes from files called
;	[image name].user_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_load_all_user_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_all_user_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_all_user_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; read data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_read_user_points, grim_data, planes[i]
 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_tie_ptd_event
;
;
; PURPOSE:
;	Writes tie points for the current plane to a file called
;	[image name].tie_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_save_tie_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_tie_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_tie_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear


 ;------------------------------------------------------
 ; get filename
 ;------------------------------------------------------
 fname = pickfiles(default=grim_indexed_array_fname(grim_data, plane, 'TIE'), $
                                       title='Select filename for saving', /one)

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_write_indexed_arrays, grim_data, plane, 'TIEPOINT', fname=fname
 grim_print, grim_data, 'Tie points saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_all_tie_ptd_event
;
;
; PURPOSE:
;	Writes tie points for all planes to files called
;	[image name].tie_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_save_all_tie_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_all_tie_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_all_tie_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_write_indexed_arrays, grim_data, planes[i], 'TIE'
 grim_print, grim_data, 'All tie points saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_tie_ptd_event
;
;
; PURPOSE:
;	loads tie points for the current plane from a file called
;	[image name].tie_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_load_tie_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_tie_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_tie_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 ;------------------------------------------------------
 ; get filename
 ;------------------------------------------------------
 fname = pickfiles(default=grim_indexed_array_fname(grim_data, plane, 'TIE'), $
                                         title='Select filename to load', /one)

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_read_indexed_arrays, grim_data, plane, 'TIE', fname=fname
 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_all_tie_ptd_event
;
;
; PURPOSE:
;	Loads tie points for all planes from files called
;	[image name].tie_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_file_load_all_tie_ptd_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_all_tie_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_all_tie_ptd_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; read data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_read_indexed_arrays, grim_data, planes[i], 'TIE'
 grim_refresh, grim_data

end
;=============================================================================







;=============================================================================
;+
; NAME:
;	grim_menu_file_save_curves_event
;
;
; PURPOSE:
;	Writes curves for the current plane to a file called
;	[image name].curve_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2015
;	
;-
;=============================================================================
pro grim_menu_file_save_curves_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_curves_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_curves_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear


 ;------------------------------------------------------
 ; get filename
 ;------------------------------------------------------
 fname = pickfiles(default=grim_indexed_array_fname(grim_data, plane, 'CURVE'), $
                                         title='Select filename for saving', /one)

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_write_indexed_arrays, grim_data, plane, 'CURVE', fname=fname
 grim_print, grim_data, 'Curves saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_all_curves_event
;
;
; PURPOSE:
;	Writes curves for all planes to files called
;	[image name].curve_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2015
;	
;-
;=============================================================================
pro grim_menu_file_save_all_curves_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_all_curves_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_all_curves_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_write_indexed_arrays, grim_data, planes[i], 'CURVE'
 grim_print, grim_data, 'All curves saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_curves_event
;
;
; PURPOSE:
;	loads curves for the current plane from a file called
;	[image name].curve_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2015
;	
;-
;=============================================================================
pro grim_menu_file_load_curves_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_curves_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_curves_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear

 ;------------------------------------------------------
 ; get filename
 ;------------------------------------------------------
 fname = pickfiles(default=grim_indexed_array_fname(grim_data, plane, 'CURVE'), $
                                            title='Select filename to load', /one)

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_read_indexed_arrays, grim_data, plane, 'CURVE', fname=fname
 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_all_curves_event
;
;
; PURPOSE:
;	Loads curves for all planes from files called
;	[image name].curve_ptd 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2015
;	
;-
;=============================================================================
pro grim_menu_file_load_all_curves_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_all_curves_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_all_curves_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; read data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_read_indexed_arrays, grim_data, planes[i], 'CURVE'
 grim_refresh, grim_data

end
;=============================================================================











;=============================================================================
;+
; NAME:
;	grim_menu_file_save_mask_event
;
;
; PURPOSE:
;	Writes mask points for the current plane to a file called
;	[image name].mask 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_menu_file_save_mask_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_mask_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_mask_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear


 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_write_mask, grim_data, plane
 grim_print, grim_data, 'Mask saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_save_all_masks_event
;
;
; PURPOSE:
;	Writes mask points for all planes to files called
;	[image name].mask 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_menu_file_save_all_masks_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_all_masks_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_all_masks_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_write_mask, grim_data, planes[i]
 grim_print, grim_data, 'All masks saved.'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_mask_event
;
;
; PURPOSE:
;	loads mask points for the current plane from a file called
;	[image name].mask 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_menu_file_load_mask_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_mask_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_mask_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 plane = grim_get_plane(grim_data)
 grim_message, /clear


 ;------------------------------------------------------
 ; write data
 ;------------------------------------------------------
 grim_read_mask, grim_data, plane
 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_load_all_masks_event
;
;
; PURPOSE:
;	Loads mask points for all planes from files called
;	[image name].mask 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_menu_file_load_all_masks_help_event, event
 text = ''
 nv_help, 'grim_menu_file_load_all_masks_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_load_all_masks_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 planes = grim_get_plane(grim_data, /all)
 grim_message, /clear

 ;------------------------------------------------------
 ; read data
 ;------------------------------------------------------
 for i=0, n_elements(planes)-1 do $
                          grim_read_mask, grim_data, planes[i]
 grim_refresh, grim_data

end
;=============================================================================











;=============================================================================
;+
; NAME:
;	grim_menu_file_save_ps_event
;
;
; PURPOSE:
;	Saves the current view as a postscript file. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2002
;	
;-
;=============================================================================
pro grim_menu_file_save_ps_help_event, event
 text = ''
 nv_help, 'grim_menu_file_save_ptd_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_save_ps_event, event



 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base

 ;------------------------------------------------------
 ; prompt for filename 
 ;------------------------------------------------------
 filename = pickfiles(get_path=get_path, $
                         title='Select filename for saving', path=path, /one)
 if(NOT keyword__set(filename)) then return

 ;------------------------------------------------------
 ; write postscript file
 ;------------------------------------------------------
 widget_control, grim_data.draw, /hourglass
 grim_write_ptd, grim_data, filename[0]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_repeat_event
;
;
; PURPOSE:
;	Repeats the last menu option.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2006
;	
;-
;=============================================================================
pro grim_menu_repeat_help_event, event
 text = ''
 nv_help, 'grim_menu_file_repeat_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_repeat_event, event

 grim_data = grim_get_data(event.top)
 grim_repeat, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_undo_event
;
;
; PURPOSE:
;	Undoes the last data modification.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2006
;	
;-
;=============================================================================
pro grim_menu_undo_help_event, event
 text = ''
 nv_help, 'grim_menu_file_undo_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_undo_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_undo, grim_data, plane
 
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_redo_event
;
;
; PURPOSE:
;	Redoes the last data modification.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2006
;	
;-
;=============================================================================
pro grim_menu_redo_help_event, event
 text = ''
 nv_help, 'grim_menu_file_redo_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_redo_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_redo, grim_data, plane

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_file_close_event
;
;
; PURPOSE:
;	Closes the current image plane.  All other image plane numbers 
;	remain the same.  If there is only one image plane, the grim exits. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_file_close_help_event, event
 text = ''
 nv_help, 'grim_menu_file_close_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_file_close_event, event

 grim_data = grim_get_data(event.top)
 grim_rm_plane, grim_data, grim_data.pn

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_next_event
;
;
; PURPOSE:
;	Changes to the next-numbered image plane. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_plane_next_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_next_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_next_event, event

 grim_data = grim_get_data(event.top)

 grim_next_plane, grim_data
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_previous_event
;
;
; PURPOSE:
;	Changes to the previous-numbered image plane. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_plane_previous_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_previous_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_previous_event, event

 grim_data = grim_get_data(event.top)

 grim_previous_plane, grim_data
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_jump_event
;
;
; PURPOSE:
;	Prompts the user and jumps to a new plane. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2005
;	
;-
;=============================================================================
pro grim_menu_plane_jump_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_jump_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_jump_event, event

 grim_data = grim_get_data(event.top)

 valid = grim_jumpto(grim_data)
 if(valid) then grim_refresh, grim_data, /no_erase

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_open_event
;
;
; PURPOSE:
;	Opens the image of the current plane in a new grim window.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
pro grim_menu_plane_open_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_open_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_open_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, /hourglass
 grim_wset, grim_data, grim_data.wnum, get_info=tvd
 grim, /new, plane.dd, order=tvd.order, zoom=tvd.zoom[0], offset=tvd.offset, $
       xsize=!d.x_size, ysize=!d.y_size

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_open_as_rgb_event
;
;
; PURPOSE:
;	Opens a new grim window with the current channal configuration 
;	reduced to a 3-channel RGB cube.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2016
;	
;-
;=============================================================================
pro grim_menu_open_as_rgb_help_event, event
 text = ''
 nv_help, 'grim_menu_open_as_rgb_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_open_as_rgb_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, /hourglass
 grim_wset, grim_data, grim_data.wnum, get_info=tvd

 dim = dat_dim(plane.dd)
 cube = grim_scale_image(grim_data, r, g, b, plane=plane, $
                                 xrange=[0,dim[0]-1], yrange=[0,dim[1]-1])

; look at render event to transfer overlays, etc
; dd = nv_clone(plane.dd)
; dat_set_data, dd, cube
; dat_set_data_offset, dd, 0
 dd = dat_create_descriptors(1, data=cube)

 grim, /new, /rgb, dd, order=tvd.order, zoom=tvd.zoom[0], offset=tvd.offset, $
       xsize=!d.x_size, ysize=!d.y_size

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_evolve_event
;
;
; PURPOSE:
;	Evolves the selected objects onto all other planes.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_plane_evolve_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_evolve_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_evolve_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, /hourglass

grim_print, grim_data, 'Not implemented!'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_crop_event
;
;
; PURPOSE:
;	Crops the data to the current viewing parameters. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2013
;	
;-
;=============================================================================
pro grim_menu_plane_crop_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_crop_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_crop_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_crop_plane, grim_data, plane
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_reorder_time_event
;
;
; PURPOSE:
;	Rearranges all planes in time order.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
pro grim_menu_plane_reorder_time_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_reorder_time_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_reorder_time_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 planes = grim_get_plane(grim_data, /all)

 n = n_elements(planes)
 times = dblarr(n)
 for i=0, n-1 do $
  begin
   cd = *planes[i].cd_p
   if(NOT keyword__set(cd)) then grim_message, $
                   'You must first load camera descriptors for each plane.'
   times[i] = bod_time(cd)
  end

 s = sort(times)

 planes = planes[s]
 for i=0, n-1 do $
  begin
   planes[i].pn = i
   grim_set_plane, grim_data, planes[i], pn=i
  end

 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_browse_event
;
;
; PURPOSE:
;	Opens a brim browser showing all planes.  The left mouse button 
;	may be used to jump among planes.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================
pro grim_menu_plane_browse_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_browse_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_browse_plane_left_event, base, i, id, status=status

 status = -1
 grim_data = grim_get_data(base)
 if(NOT grim_exists(grim_data)) then return

 pn = id[0]

 grim_jump_to_plane, grim_data, pn, valid=valid
 if(valid) then $
  begin
   grim_refresh, grim_data, /no_erase
   status = 1
  end

end
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pro grim_browse_refresh_event, data_p

 base = *data_p
 if(NOT widget_info(base, /valid_id)) then $
  begin
   grim_rm_refresh_callback, data_p
   return
  end

 grim_data = grim_get_data()
 plane = grim_get_plane(grim_data)

 widget_control, base, get_uvalue=brim_data

 planes = grim_get_plane(grim_data, /all)
 brim_select, brim_data, plane.pn, dd=planes.dd, id=planes.pn


end
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pro grim_menu_plane_browse_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all, pn=pns)

 grim_wset, grim_data, grim_data.wnum, get_info=tvd
 brim, planes.dd, ids=pns, $
      left_fn='grim_browse_plane_left_event', fn_data=event.top, $
      select=grim_data.pn, /exclusive, order=tvd.order, /enable, base=base

 grim_add_refresh_callback, 'grim_browse_refresh_event', nv_ptr_new(base)

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_sequence_event
;
;
; PURPOSE:
;	Displays all planes in sequence using xinteranimate1.  This option is
;	useful or blinking as well.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_plane_sequence_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_sequence_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_sequence_event, event

 grim_data = grim_get_data(event.top)

 ;--------------------------------------------
 ; get valid planes
 ;--------------------------------------------
 planes = grim_get_plane(grim_data, /all)
 n = n_elements(planes)
 if(n LE 1) then return
 
 ;--------------------------------------------
 ; set up images
 ;--------------------------------------------
 widget_control, /hourglass

 geom = widget_info(grim_data.draw, /geom)
 xinteranimate1, set=[geom.xsize, geom.ysize, n]
 tvim, /noplot, /silent, $
           /new, /inherit, xsize=geom.xsize, ysize=geom.ysize, /pixmap
 pixmap = !d.window

; for i=0, n-1 do $
;  begin
;grim_refresh, grim_data, plane=planes[i], wnum=pixmap, /no_title
;im = tvrd()
;write_gif, /mult, '~/test.gif', im
;  end
;write_gif, /close
;stop

 for i=0, n-1 do $
  begin
   grim_print, grim_data, $
     'Loading plane ' + strtrim(i,2) + ' of ' + strtrim(n,2) + '...'

   wset, pixmap & erase & wset, grim_data.wnum

   grim_refresh, grim_data, plane=planes[i], wnum=pixmap, /no_title

   xinteranimate1, frame=i, window=pixmap, /show
  end

 grim_print, grim_data, ''

 ;--------------------------------------------
 ; run the movie
 ;--------------------------------------------
 wdelete, pixmap
 grim_wset, grim_data, grim_data.wnum

 xinteranimate1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_dump_event
;
;
; PURPOSE:
;	Dumps all planes to png files entitled [filename].png.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2004
;	
;-
;=============================================================================
pro grim_menu_plane_dump_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_dump_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_dump_event, event

 grim_data = grim_get_data(event.top)

 ;--------------------------------------------
 ; get valid planes
 ;--------------------------------------------
 planes = grim_get_plane(grim_data, /all)
 n = n_elements(planes)
 if(n LE 1) then return
 
 ;--------------------------------------------
 ; set up images
 ;--------------------------------------------
 widget_control, /hourglass

 geom = widget_info(grim_data.draw, /geom)
 xinteranimate1, set=[geom.xsize, geom.ysize, n]
 tvim, /noplot, /silent, $
           /new, /inherit, xsize=geom.xsize, ysize=geom.ysize, /pixmap
 pixmap = !d.window


 for i=0, n-1 do $
  begin
   filename = cor_name(planes[i].dd)
   grim_refresh, grim_data, plane=planes[i], wnum=pixmap, /no_title
   wset, pixmap
   write_png, filename + '.png', tvrd()
  end

 wdelete, pixmap
 grim_wset, grim_data, grim_data.wnum

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_coregister_event 
;
;
; PURPOSE:
;	Shifts the images on each plane so as to center the active object 
;	at the same pixel on each plane. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
pro grim_menu_plane_coregister_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_coregister_event ', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_coregister_event, event

 grim_data = grim_get_data(event.top)
 planes = grim_get_plane(grim_data, /all)
 widget_control, grim_data.draw, /hourglass


 ;------------------------------------------------
 ; make sure relevant descriptors are loaded
 ;------------------------------------------------
 grim_load_descriptors, grim_data, class='camera', plane=plane, cd=cd
 if(NOT keyword_set(cd[0])) then return 


 ;------------------------------------------------
 ; build descriptor arrays
 ;------------------------------------------------
 n = n_elements(planes)
 cd = objarr(n)
 bx = objarr(n)
 dd = objarr(n)

 for i=0, n-1 do $
  if(keyword_set(*planes[i].active_xd_p)) then $
   begin
    dd[i] = planes[i].dd
    cd[i] = *planes[i].cd_p
    bx[i] = (*planes[i].active_xd_p)[0]
   end

 w = where(obj_valid(dd))
 if(w[0] EQ -1)then $
  begin
   grim_message, 'There are no active overlays.'
   return
  end

 dd = dd[w]
 cd = cd[w]
 bx = bx[w]

 ;------------------------------------------------
 ; recenter image
 ;------------------------------------------------
 nv_suspend_events
 pg_coregister, dd, cd=cd, bx=bx
 nv_resume_events

 grim_refresh, grim_data
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_coadd_event 
;
;
; PURPOSE:
;	Averages all planes.  Not implemented.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2004
;	
;-
;=============================================================================
pro grim_menu_plane_coadd_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_coadd_event ', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_coadd_event, event

 grim_data = grim_get_data(event.top)
 planes = grim_get_plane(grim_data, /all)
 widget_control, grim_data.draw, /hourglass

 
; grim_refresh, grim_data
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_highlight_event 
;
;
; PURPOSE:
;	Toggles highlighting of the current plane image.  Useful when 
;	multiple planes are visible simultaneously.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2008
;	
;-
;=============================================================================
pro grim_menu_plane_highlight_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_highlight_event ', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_highlight_event, event

 grim_data = grim_get_data(event.top)
 grim_data.highlight = 1 - grim_data.highlight
 grim_set_data, grim_data, event.top

; widget_control, grim_data.draw, /hourglass
 
 grim_refresh, grim_data
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_settings_event
;
;
; PURPOSE:
;	Allows the user modify settings for the loaded image planes.  
;	Each plane may displayed in any combination of the three color
;	channels.  Also, a plane may be made visible even when it is not
;	the current plane, instead of the default behavior, which is to 
;	display the plane only whenit is current.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2002
;	
;-
;=============================================================================
pro grim_menu_plane_settings_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_settings_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_settings_event, event

 grim_data = grim_get_data(event.top)
 grim_plane_settings, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_copy_curves_event
;
;
; PURPOSE:
;	Copies all curves from the current plane to all other planes.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2004
;	
;-
;=============================================================================
pro grim_menu_plane_copy_curves_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_copy_curves_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_copy_curves_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all)

 n = n_elements(planes)
 pn = plane.pn

 for i=0, n-1 do if(i NE pn) then grim_copy_curve, grim_data, plane, planes[i]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_copy_tiepoints_event
;
;
; PURPOSE:
;	Copies all tieppoints from the current plane to all other planes.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2004
;	
;-
;=============================================================================
pro grim_menu_plane_copy_tiepoints_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_copy_tiepoints_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_copy_tiepoints_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all)

 n = n_elements(planes)
 pn = plane.pn

 for i=0, n-1 do if(i NE pn) then $
                        grim_copy_tiepoint, grim_data, plane, planes[i]

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_copy_mask_event
;
;
; PURPOSE:
;	Copies mask from the current plane to all other planes.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_menu_plane_copy_mask_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_copy_mask_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_copy_mask_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all)

 n = n_elements(planes)
 pn = plane.pn

; for i=0, n-1 do if(i NE pn) then $
       ;grim_copy_mask, grim_data, plane, planes[i] ;no such function

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_clear_curves_event
;
;
; PURPOSE:
;	Clears all curves from the current plane.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2004
;	
;-
;=============================================================================
pro grim_menu_plane_clear_curves_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_clear_curves_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_clear_curves_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_rm_curve, grim_data, plane=plane, /all
 grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_clear_tiepoints_event
;
;
; PURPOSE:
;	Clears all tiepoints from the current plane.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2004
;	
;-
;=============================================================================
pro grim_menu_plane_clear_tiepoints_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_clear_tiepoints_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_clear_tiepoints_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_rm_tiepoint, grim_data, plane=plane, /all
 grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_clear_mask_event
;
;
; PURPOSE:
;	Clears the mask from the current plane.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_menu_plane_clear_mask_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_clear_mask_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_clear_mask_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_rm_mask, grim_data, plane=plane, /all
 grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_toggle_curve_syncing_event
;
;
; PURPOSE:
;	Toggles curve syncing on/off.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
pro grim_menu_plane_toggle_curve_syncing_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_toggle_curve_syncing_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_toggle_curve_syncing_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)


 grim_data = grim_get_data(event.top)
 grim_data.curve_syncing = 1 - grim_data.curve_syncing
 grim_set_data, grim_data, event.top
 
; grim_sync_curves, grim_data
; grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_toggle_tiepoint_syncing_event
;
;
; PURPOSE:
;	Toggles tiepoint syncing on/off.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
pro grim_menu_plane_toggle_tiepoint_syncing_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_toggle_tiepoint_syncing_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_toggle_tiepoint_syncing_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)


 grim_data = grim_get_data(event.top)
 grim_data.tiepoint_syncing = 1 - grim_data.tiepoint_syncing
 grim_set_data, grim_data, event.top
 
; grim_sync_tiepoints, grim_data
; grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_toggle_plane_syncing_event
;
;
; PURPOSE:
;	Toggles plane syncing on/off.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2016
;	
;-
;=============================================================================
pro grim_menu_plane_toggle_plane_syncing_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_toggle_plane_syncing_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_toggle_plane_syncing_event, event

 widget_control, /hourglass

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)


 grim_data = grim_get_data(event.top)
 grim_data.plane_syncing = 1 - grim_data.plane_syncing
 grim_set_data, grim_data, event.top
 
; grim_sync_planes, grim_data
; grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_plane_propagate_tiepoints_event
;
;
; PURPOSE:
;	Copies all tieppoints from the current plane to all other planes.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2004
;	
;-
;=============================================================================
pro grim_menu_plane_propagate_tiepoints_help_event, event
 text = ''
 nv_help, 'grim_menu_plane_propagate_tiepoints_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_plane_propagate_tiepoints_event, event
@mks.include

 widget_control, /hourglass


 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all)

 nplanes = n_elements(planes)
 pn = plane.pn


 tie_pts = pnt_points(plane.tiepoints_ptd)
 if(NOT keyword_set(tie_pts)) then return
 npts = n_elements(tie_pts)/2
 ii = grim_get_tiepoint_indices(grim_data, plane=plane)

 grim_load_descriptors, grim_data, class='camera', plane=plane, cd=cd
 if(NOT keyword_set(cd[0])) then $ 
  begin
   grim_message, 'No camera descriptor!'
   return
  end
 grim_load_descriptors, grim_data, class='planet', plane=plane, pd=pd
 if(NOT keyword_set(pd[0])) then return

 cd = cd[0]

 pd0 = get_primary(cd, pd)
 name = cor_name(pd0)

 tie_pts = reform(tie_pts, 2, 1, npts, /over)

 dkd = make_array(npts, $
           val=orb_construct_descriptor(pd0, sma=1d8, GG=const_G))
 for i=0, npts-1 do $ 
   dkd[i] = image_to_orbit(cd, pd0, dkd[i], tie_pts[*,0,i], GG=const_G)
;orb_set_ma, dkd, orb_anom_to_lon(dkd, orb_get_ma(dkd), pd0)
; for i=0, npts-1 do orb_print_elements_mks, dkd[i], pd0

 for i=0, nplanes-1 do $
  if(planes[i].pn NE pn) then $
   begin
    grim_load_descriptors, grim_data, class='camera', plane=planes[i]
    cdi = (*planes[i].cd_p)[0]
    if(keyword_set(cdi)) then $
     begin
      grim_load_descriptors, grim_data, class='planet', plane=planes[i]
      w = where(cor_name(pd) EQ name)
      if(w[0] NE -1) then $
       begin
        pdi = (pd)[w[0]]

        dt = bod_time(pdi) - bod_time(pd0)
        dkdt = objarr(npts)
        r = dblarr(1,3,npts)
        for j=0, npts-1 do $
         begin
          dkdt[j] = orb_evolve(dkd[j], dt)
          bod_set_pos, dkdt[j], bod_pos(pdi)
          r[*,*,j] = orb_to_cartesian(dkdt[j], v=_v)
;          r[*,*,j] = orb_to_cartesian_lt(cdi, dkdt[j], c=const_c, v=_v)
         end

        if(npts GT 1) then r = transpose(r)
        p = reform(inertial_to_image_pos(cdi, r))
plots, p, psym=1, col=ctgreen()

        grim_copy_tiepoint, grim_data, plane, planes[i]
        planes[i] = grim_get_plane(grim_data, pn=planes[i].pn) 

        grim_replace_tiepoints, grim_data, ii, p, plane=planes[i]

        nv_free, dkdt
       end
     end

   end

 nv_free, dkd

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_data_adjust_event
;
;
; PURPOSE:
;	This option allows the user to adjust data values.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2014
;	
;-
;=============================================================================
pro grim_menu_data_adjust_help_event, event
 text = ''
 nv_help, 'grim_menu_data_adjust_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_data_adjust_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;------------------------------------------------
 ; get data array
 ;------------------------------------------------
 data = dat_data(plane.dd)

 ;------------------------------------------------
 ; adjust the data
 ;------------------------------------------------
 grim_logging, grim_data, /start
 pg_data_adjust, plane.dd
 grim_logging, grim_data, /stop

 ;------------------------------------------------
 ; save modified data array
 ;------------------------------------------------
; dat_set_data, plane.dd, data

 
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_recenter_event
;
;
; PURPOSE:
;	Recenters the view at the cursor position. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_recenter_help_event, event
 text = ''
 nv_help, 'grim_menu_view_home_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_recenter_event, event

 grim_data = grim_get_data(event.top)

 cursor, x, y, /device, /nowait

 p = convert_coord(double(x), double(y), /device, /to_data)
 grim_recenter, grim_data, p

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_home_event
;
;
; PURPOSE:
;	Sets the tvim home view settings. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2005
;	
;-
;=============================================================================
pro grim_menu_view_home_help_event, event
 text = ''
 nv_help, 'grim_menu_view_home_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_home_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /home

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_previous_event
;
;
; PURPOSE:
;	Restores the previous view settings. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_previous_help_event, event
 text = ''
 nv_help, 'grim_menu_view_previous_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_previous_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /previous

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_refresh_event
;
;
; PURPOSE:
;	Redraws the overlays on the graphics display. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_refresh_help_event, event
 text = ''
 nv_help, 'grim_menu_view_refresh_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_refresh_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_event
;
;
; PURPOSE:
;	Prompts the user for a new zoom factor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2005
;	
;-
;=============================================================================
pro grim_menu_view_zoom_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_event, event

 grim_data = grim_get_data(event.top)
 zoom = grim_zoom(grim_data)
 if(zoom NE 0) then grim_refresh, grim_data, zoom=zoom

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_double_event
;
;
; PURPOSE:
;	Doubles the current zoom, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_double_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_double_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(2d, /relative, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_half_event
;
;
; PURPOSE:
;	Halves the current zoom, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_half_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_half_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(0.5d, /relative, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================






;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_0_event
;
;
; PURPOSE:
;	Sets the current rotate to 0, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_0_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_0_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=0

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_1_event
;
;
; PURPOSE:
;	Sets the current rotate to 1, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_1_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_1_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=1

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_2_event
;
;
; PURPOSE:
;	Sets the current rotate to 2, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_2_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_2_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=2

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_3_event
;
;
; PURPOSE:
;	Sets the current rotate to 3, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_3_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_3_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=3

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_4_event
;
;
; PURPOSE:
;	Sets the current rotate to 4, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_4_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_4_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=4

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_5_event
;
;
; PURPOSE:
;	Sets the current rotate to 5, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_5_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_5_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=5

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_6_event
;
;
; PURPOSE:
;	Sets the current rotate to 6, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_6_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_6_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=6

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_rotate_7_event
;
;
; PURPOSE:
;	Sets the current rotate to 7, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2013
;	
;-
;=============================================================================
pro grim_menu_view_rotate_7_help_event, event
 text = ''
 nv_help, 'grim_menu_view_rotate_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_rotate_7_event, event

 grim_data = grim_get_data(event.top)
 grim_refresh, grim_data, rotate=7

end
;=============================================================================








;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_event
;
;
; PURPOSE:
;	Sets the current zoom to 1, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_2_event
;
;
; PURPOSE:
;	Sets the current zoom to 2, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_2_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_2_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(2d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_3_event
;
;
; PURPOSE:
;	Sets the current zoom to 3, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_3_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_3_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(3d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_4_event
;
;
; PURPOSE:
;	Sets the current zoom to 4, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_4_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_4_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(4d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_5_event
;
;
; PURPOSE:
;	Sets the current zoom to 5, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_5_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_5_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(5d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_6_event
;
;
; PURPOSE:
;	Sets the current zoom to 6, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_6_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_6_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(6d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_7_event
;
;
; PURPOSE:
;	Sets the current zoom to 7, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_7_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_7_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(7d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_8_event
;
;
; PURPOSE:
;	Sets the current zoom to 8, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_8_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_8_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(8d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_9_event
;
;
; PURPOSE:
;	Sets the current zoom to 9, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_9_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_9_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(9d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_10_event
;
;
; PURPOSE:
;	Sets the current zoom to 10, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_10_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_10_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(10d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_2_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/2, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_2_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_2_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/2d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_3_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/3, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_3_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_3_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/3d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_4_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/4, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_4_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_4_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/4d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_5_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/5, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_5_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_5_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/5d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_5_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/5, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_5_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_5_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/5d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_6_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/6, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_6_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_6_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/6d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_7_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/7, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_7_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_7_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/7d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_8_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/8, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_8_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_8_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/8d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_9_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/9, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_9_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_9_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/9d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_zoom_1_10_event
;
;
; PURPOSE:
;	Sets the current zoom to 1/10, centered at the mouse cursor. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2008
;	
;-
;=============================================================================
pro grim_menu_view_zoom_1_10_help_event, event
 text = ''
 nv_help, 'grim_menu_view_zoom_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_zoom_1_10_event, event

 grim_data = grim_get_data(event.top)
 offset = grim_zoom_to_cursor(1d/10d, zoom=zoom)
 grim_refresh, grim_data, zoom=zoom, offset=offset

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_save_event
;
;
; PURPOSE:
;	Saves the current view settings. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_save_help_event, event
 text = ''
 nv_help, 'grim_menu_view_save_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_save_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_wset, grim_data, /noplot, /save, /silent

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_restore_event
;
;
; PURPOSE:
;	Restores the last-saved view settings. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_restore_help_event, event
 text = ''
 nv_help, 'grim_menu_view_restore_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_restore_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /restore

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_entire_event
;
;
; PURPOSE:
;	Applies the 'entire' display parameters, as given in tvim. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_entire_help_event, event
 text = ''
 nv_help, 'grim_menu_view_entire_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_entire_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /entire

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_initial_event
;
;
; PURPOSE:
;	Reverts to the initial view parameters for this grim widget. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2007
;	
;-
;=============================================================================
pro grim_menu_view_initial_help_event, event
 text = ''
 nv_help, 'grim_menu_view_entire_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_initial_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 tvd = *grim_data.tvd_init_p
 tvim, /inherit, /silent, zoom=tvd.zoom, order=tvd.order, offset=tvd.offset

 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_flip_event
;
;
; PURPOSE:
;	Reverses the curent display order. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_flip_help_event, event
 text = ''
 nv_help, 'grim_menu_view_flip_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_flip_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /flip

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_frame_event
;
;
; PURPOSE:
;	Modifies view settings so as to display the either all overlays
;	or those that are active. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2007
;	
;-
;=============================================================================
pro grim_menu_view_frame_help_event, event
 text = ''
 nv_help, 'grim_menu_view_frame_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_frame_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, grim_data.draw, /hourglass

 ptd = grim_get_all_active_overlays(grim_data, plane=plane)
 if(NOT keyword_set(ptd)) then $
   ptd = grim_get_all_overlays(grim_data, plane=plane)
 if(NOT keyword_set(ptd)) then return

 grim_frame_overlays, grim_data, plane, ptd

 grim_refresh, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_header_event
;
;
; PURPOSE:
;	Opens a text window showing the image header. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2003
;	
;-
;=============================================================================
pro grim_menu_view_header_help_event, event
 text = ''
 nv_help, 'grim_menu_view_header_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_header_event, event

 grim_data = grim_get_data(event.top)
 grim_edit_header, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_notes_event
;
;
; PURPOSE:
;	Opens a text window allowing the user to enter notes for each plane. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2003
;	
;-
;=============================================================================
pro grim_menu_notes_help_event, event
 text = ''
 nv_help, 'grim_menu_notes_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_notes_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_edit_notes, grim_data, plane=plane

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_context_event
;
;
; PURPOSE:
;	Toggles the ontext window On/Off. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2005
;	
;-
;=============================================================================
pro grim_menu_context_help_event, event
 text = ''
 nv_help, 'grim_menu_context_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_context_event, event

 grim_data = grim_get_data(event.top)
 grim_toggle_context, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_toggle_image_event
;
;
; PURPOSE:
;	Toggles the image On/Off. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2012
;	
;-
;=============================================================================
pro grim_menu_image_help_event, event
 text = ''
 nv_help, 'grim_menu_toggle_image_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_toggle_image_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_toggle_image, grim_data, plane

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_toggle_image_overlays_event
;
;
; PURPOSE:
;	Toggles the image and overlays On/Off. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2012
;	
;-
;=============================================================================
pro grim_menu_image_overlays_help_event, event
 text = ''
 nv_help, 'grim_menu_toggle_image_overlays_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_toggle_image_overlays_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_toggle_image_overlays, grim_data, plane

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_render_event
;
;
; PURPOSE:
;	Renders the visible scene and places it in a new plane unless
;	the current plane is already rendering. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
pro grim_menu_render_help_event, event
 text = ''
 nv_help, 'grim_menu_render_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_render_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)
 grim_render, grim_data, plane=plane
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_axes_event
;
;
; PURPOSE:
;	Toggles the axes window On/Off.  The colors are as follows:
;
;	 Blue	- Inertial axes.
;	 Red	- Camera axes.
;	 Green	- Direction to primary planet, not foreshortened.
;	 Yellow	- Direction to Sun, not foreshortened.
;
;	Vectors pointing away from the camera are dotted.  The vectors are 
;	rooted at a point 1d5 distance units in front of the camera .  
;	In the direction corresponding to the image position of the drawn 
;	axes.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2005
;	
;-
;=============================================================================
pro grim_menu_axes_help_event, event
 text = ''
 nv_help, 'grim_menu_axes_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_axes_event, event

 grim_data = grim_get_data(event.top)
 grim_toggle_axes, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_view_colors_event
;
;
; PURPOSE:
;	Reverses the current display order. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_view_colors_help_event, event
 text = ''
 nv_help, 'grim_menu_view_colors_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_colors_event, event

 grim_data = grim_get_data(event.top)
 grim_set_primary, grim_data.base
 grim_modify_colors, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_limbs_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	limbs using pg_limbs for all active objects.  If no active objects, 
;	then all limbs are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_limbs_help_event, event
 text = ''
 nv_help, 'grim_menu_points_limbs_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_limbs_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute limbs
 ;------------------------------------------------
 grim_overlay, grim_data, 'limb'
; grim_limbs, grim_data

 ;------------------------------------------------
 ; draw limbs
 ;------------------------------------------------
; grim_draw, grim_data, /limb
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_planet_grids_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	planet grids using pg_grid for all active objects.  If no active
;	objects, then all grids are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_planet_grids_help_event, event
 text = ''
 nv_help, 'grim_menu_points_planet_grids_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_planet_grids_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute planet grids
 ;------------------------------------------------
 grim_overlay, grim_data, 'planet_grid'
; grim_planet_grids, grim_data

 ;------------------------------------------------
 ; draw planet grids
 ;------------------------------------------------
; grim_draw, grim_data, /plgrid
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_stations_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	planet stations for all active objects.  If no active objects, then 
;	all stations are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2009
;	
;-
;=============================================================================
pro grim_menu_points_stations_help_event, event
 text = ''
 nv_help, 'grim_menu_points_stations_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_stations_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute planet grids
 ;------------------------------------------------
 grim_overlay, grim_data, 'station'

 ;------------------------------------------------
 ; draw stations
 ;------------------------------------------------
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_arrays_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	arrays for all active objects.  If no active objects, then 
;	all arrays are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2012
;	
;-
;=============================================================================
pro grim_menu_points_arrays_help_event, event
 text = ''
 nv_help, 'grim_menu_points_arrays_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_arrays_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute planet grids
 ;------------------------------------------------
 grim_overlay, grim_data, 'array'

 ;------------------------------------------------
 ; draw arrays
 ;------------------------------------------------
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_ring_grids_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	ring grids using pg_grid for all active objects.  If no active
;	objects, then all grids are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2004
;	
;-
;=============================================================================
pro grim_menu_points_ring_grids_help_event, event
 text = ''
 nv_help, 'grim_menu_points_ring_grids_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_ring_grids_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

; grim_interrupt_begin, grim_data

 ;------------------------------------------------
 ; load descriptors and compute planet grids
 ;------------------------------------------------
 grim_overlay, grim_data, 'ring_grid'

 ;------------------------------------------------
 ; draw planet grids
 ;------------------------------------------------
 grim_refresh, grim_data, /use_pixmap

; grim_interrupt_end, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_terminators_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	terminators using pg_limb with the sun as the observer for all active
;	objects.  If no active objects, then all terminators are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_terminators_help_event, event
 text = ''
 nv_help, 'grim_menu_points_terminators_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_terminators_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute terminators
 ;------------------------------------------------
 grim_overlay, grim_data, 'terminator'
; grim_terminators, grim_data

 ;------------------------------------------------
 ; draw terminators
 ;------------------------------------------------
; grim_draw, grim_data, /term
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_rings_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	ring outlines using pg_disk. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_rings_help_event, event
 text = ''
 nv_help, 'grim_menu_points_rings_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_rings_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute rings
 ;------------------------------------------------
 grim_overlay, grim_data, 'ring'
;grim_rings, grim_data

 ;------------------------------------------------
 ; draw rings
 ;------------------------------------------------
; grim_draw, grim_data, /ring
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_stars_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	star positions using pg_center. 
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_stars_help_event, event
 text = ''
 nv_help, 'grim_menu_points_stars_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_stars_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute stars
 ;------------------------------------------------
 grim_overlay, grim_data, 'star', /replace
; grim_stars, grim_data

 ;------------------------------------------------
 ; draw stars
 ;------------------------------------------------
; grim_draw, grim_data, /star, /label
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_reflections_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	reflections of the currently active overlay points on all other objects. 
;	Note that you may have to disable overlay hiding in order to compute
;	and activate all of the appropriate source points for the reflections
;	since many point that are not visible to the observer may still have
;	a line of sight to the sun.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2003
;	
;-
;=============================================================================
pro grim_menu_points_reflections_help_event, event
 text = ''
 nv_help, 'grim_menu_points_reflections_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_reflections_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute reflections
 ;------------------------------------------------
 grim_overlay, grim_data, 'reflection'
;grim_reflections, grim_data

 ;------------------------------------------------
 ; draw reflection
 ;------------------------------------------------
; grim_draw, grim_data, /reflection
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================






;=============================================================================
;+
; NAME:
;	grim_menu_points_shadows_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	shadows of the currently active overlay points on all other objects. 
;	Note that you may have to disable overlay hiding in order to compute
;	and activate all of the appropriate source points for the shadows
;	since many point that are not visible to the observer may still have
;	a line of sight to the sun.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2003
;	
;-
;=============================================================================
pro grim_menu_points_shadows_help_event, event
 text = ''
 nv_help, 'grim_menu_points_shadows_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_shadows_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute shadows
 ;------------------------------------------------
 grim_overlay, grim_data, 'shadow'
;grim_shadows, grim_data

 ;------------------------------------------------
 ; draw shadow
 ;------------------------------------------------
; grim_draw, grim_data, /shadow
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_planet_centers_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	planet center positions using pg_center for all active objects.  If no
;	active objects, then all centers are computed.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_planet_centers_help_event, event
 text = ''
 nv_help, 'grim_menu_points_planet_centers_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_planet_centers_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute centers
 ;------------------------------------------------
 grim_overlay, grim_data, 'planet_center'
; grim_planet_centers, grim_data

 ;------------------------------------------------
 ; draw centers
 ;------------------------------------------------
; grim_draw, grim_data, /center, /label
 grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_hide_all_event
;
;
; PURPOSE:
;	 Hides/unhides all overlay objects.
;
;
; CATEGORY:
;	NV/GR
;	 
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2003
;	
;-
;=============================================================================
pro grim_menu_hide_all_help_event, event
 text = ''
 nv_help, 'grim_menu_hide_all_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_hide_all_event, event

 grim_data = grim_get_data(event.top)

 grim_set_primary, grim_data.base
 grim_hide_overlays, grim_data

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_clear_all_event
;
;
; PURPOSE:
;	 Clears all objects.
;
;
; CATEGORY:
;	NV/GR
;	 
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2002
;	
;-
;=============================================================================
pro grim_menu_clear_all_help_event, event
 text = ''
 nv_help, 'grim_menu_clear_all_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_clear_all_event, event

 grim_message, /question, result=result, $
           ['Are you sure you want to clear all overlays?']
 if(result NE 'Yes') then return


 grim_data = grim_get_data(event.top)
 grim_clear_objects, grim_data, /all

 grim_refresh, grim_data, /use_pixmap
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_clear_active_event
;
;
; PURPOSE:
;	 Clears all active objects.
;
;
; CATEGORY:
;	NV/GR
;	 
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2002
;	
;-
;=============================================================================
pro grim_menu_clear_active_help_event, event
 text = ''
 nv_help, 'grim_menu_clear_active_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_clear_active_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_clear_active_overlays, plane
 grim_clear_active_user_overlays, plane


 grim_refresh, grim_data, /use_pixmap
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_activate_all_event
;
;
; PURPOSE:
;	 Activates all objects.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2002
;	
;-
;=============================================================================
pro grim_menu_activate_all_help_event, event
 text = ''
 nv_help, 'grim_menu_activate_all_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_activate_all_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_activate_all, plane
 grim_refresh, grim_data, /no_image

 return
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_deactivate_all_event
;
;
; PURPOSE:
;	 Deactivates all objects.
;
;
; CATEGORY:
;	NV/GR
;	 
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2002
;	
;-
;=============================================================================
pro grim_menu_deactivate_all_help_event, event
 text = ''
 nv_help, 'grim_menu_deactivate_all_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_deactivate_all_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_deactivate_all, plane
 grim_refresh, grim_data, /no_image

 return
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_invert_all_event
;
;
; PURPOSE:
;	 Inverts current overlay activations.  Desccriptor activations are
;	 determined by the resulting overlay activations. 
;
;
; CATEGORY:
;	NV/GR
;	 
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
pro grim_menu_invert_all_help_event, event
 text = ''
 nv_help, 'grim_menu_invert_all_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_invert_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_invert_all_overlays, plane

 grim_refresh, grim_data, /no_image
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_settings_event
;
;
; PURPOSE:
;	Allows the user modify settings relevant to the overlay points.  
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_menu_points_settings_help_event, event
 text = ''
 nv_help, 'grim_menu_points_settings_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_settings_event, event
@grim_block.include

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 grim_overlay_settings, grim_data, plane

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_select_event
;
;
; PURPOSE:
;	Selects or unselects a grim window.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	This option toggles a given grim instance between selected 
;	and unselected states, for use with functions that require 
;	input from more than one grim instance.  When a given instance 
;	is selected, this button displays an asterisk.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_select_help_event, event
 text = ''
 nv_help, 'grim_select_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_select_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
       grim_print, grim_data, 'Select/Deselect this grim window'
   return
  end $
 else if(NOT grim_test_motion_event(event)) then $
                                               grim_set_primary, grim_data.base

 grim_select, grim_data
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_identify_event
;
;
; PURPOSE:
;	Causes grim to identify itself on the IDL command line.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	This option causes grim to print a message on the IDL command line.
;	It is useful in cases where multiple grim instances are running in
;	multiple IDL sessions.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2009
;	
;-
;=============================================================================
pro grim_identify_help_event, event
 text = ''
 nv_help, 'grim_identify_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_identify_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
       grim_print, grim_data, 'Identify this grim window'
   return
  end $
 else if(NOT grim_test_motion_event(event)) then $
                                               grim_set_primary, grim_data.base

 grim_identify, grim_data

end
;=============================================================================



;=============================================================================
; grim_previous_event
;
;=============================================================================
pro grim_previous_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Previous plane'
   return
  end


 ;---------------------------------------------------------
 ; switch to previous plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_previous_plane, grim_data

end
;=============================================================================



;=============================================================================
; grim_jumpto_event
;
;=============================================================================
pro grim_jumpto_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Jump to plane'
   return
  end


 ;---------------------------------------------------------
 ; jump to new plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 valid = grim_jumpto(grim_data, grim_data.jumpto_text)
 if(valid) then grim_refresh, grim_data, /no_erase

end
;=============================================================================



;=============================================================================
; grim_next_event
;
;=============================================================================
pro grim_next_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Next plane'
   return
  end


 ;---------------------------------------------------------
 ; switch to next plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_next_plane, grim_data

end
;=============================================================================



;=============================================================================
; grim_crop_event
;
;=============================================================================
pro grim_crop_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'crop data to view'
   return
  end


 ;---------------------------------------------------------
 ; crop data
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_crop_plane, grim_data, plane

end
;=============================================================================



;=============================================================================
; grim_refresh_event
;
;=============================================================================
pro grim_refresh_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Refresh'
   return
  end


 ;---------------------------------------------------------
 ; switch to next plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_refresh, grim_data


end
;=============================================================================



;=============================================================================
; grim_entire_event
;
;=============================================================================
pro grim_entire_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'View entire image'
   return
  end


 ;---------------------------------------------------------
 ; switch to next plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /entire


end
;=============================================================================



;=============================================================================
; grim_view_previous_event
;
;=============================================================================
pro grim_view_previous_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Previous view'
   return
  end


 ;---------------------------------------------------------
 ; switch to next plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_refresh, grim_data, /previous


end
;=============================================================================



;=============================================================================
; grim_colors_event
;
;=============================================================================
pro grim_colors_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Modify color tables'
   return
  end


 ;---------------------------------------------------------
 ; open color tool
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_modify_colors, grim_data


end
;=============================================================================



;=============================================================================
; grim_settings_event
;
;=============================================================================
pro grim_settings_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Overlay settings'
   return
  end


 ;---------------------------------------------------------
 ; open settings dialog
 ;---------------------------------------------------------
 grim_overlay_settings, grim_data, plane


end
;=============================================================================



;=============================================================================
; grim_header_event
;
;=============================================================================
pro grim_header_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Edit image header'
   return
  end


 ;---------------------------------------------------------
 ; open header editor
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_edit_header, grim_data


end
;=============================================================================



;=============================================================================
; grim_notes_event
;
;=============================================================================
pro grim_notes_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Edit image notes'
   return
  end


 ;---------------------------------------------------------
 ; open header editor
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_edit_notes, grim_data, plane=plane


end
;=============================================================================



;=============================================================================
; grim_undo_event
;
;=============================================================================
pro grim_undo_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
    begin
     grim_print, grim_data, 'Undo last data edit.'
    end
   return
  end


 ;---------------------------------------------------------
 ; undo last edit
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_undo, grim_data, plane



end
;=============================================================================



;=============================================================================
; grim_redo_event
;
;=============================================================================
pro grim_redo_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
    begin
     grim_print, grim_data, 'Redo last data edit.'
    end
   return
  end


 ;---------------------------------------------------------
 ; undo last edit
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_redo, grim_data, plane



end
;=============================================================================



;=============================================================================
; grim_toggle_image_event
;
;=============================================================================
pro grim_toggle_image_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
    begin
     if(NOT plane.image_visible) then grim_print, grim_data, 'Unhide image' $
     else grim_print, grim_data, 'Hide image'
    end
   return
  end


 ;---------------------------------------------------------
 ; toggle image
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_toggle_image, grim_data, plane



end
;=============================================================================



;=============================================================================
; grim_toggle_image_overlays_event
;
;=============================================================================
pro grim_toggle_image_overlays_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
    begin
     if(NOT plane.image_visible) then s = 'Unhide image' $
     else s = 'Hide image'

     if(grim_data.hidden) then s = s + ' and unhide all overlays' $
     else s = s + ' and hide all overlays'

     grim_print, grim_data, s
    end
   return
  end


 ;---------------------------------------------------------
 ; toggle image
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_toggle_image_overlays, grim_data, plane



end
;=============================================================================



;=============================================================================
; grim_hide_event
;
;=============================================================================
pro grim_hide_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
    begin
     if(grim_data.hidden) then grim_print, grim_data, 'Unhide all overlays' $
     else grim_print, grim_data, 'Hide all overlays'
    end
   return
  end


 ;---------------------------------------------------------
 ; hide all overlays
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, grim_data.draw, /hourglass
 grim_hide_overlays, grim_data



end
;=============================================================================



;=============================================================================
; grim_tracking_event
;
;=============================================================================
pro grim_tracking_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Toggle cursor tracking on/off'
   return
  end


 ;---------------------------------------------------------
 ; toggle tracking flag
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 if(grim_data.tracking EQ 0) then grim_data.tracking = 1 $
 else grim_data.tracking = 0

 grim_set_data, grim_data, event.top

 grim_set_tracking, grim_data
end
;=============================================================================



;=============================================================================
; grim_grid_event
;
;=============================================================================
pro grim_grid_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Toggle RA/DEC grid on/off'
   return
  end


 ;---------------------------------------------------------
 ; toggle grid flag
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_data.grid_flag = NOT grim_data.grid_flag

 grim_set_data, grim_data, event.top
 if(grim_data.grid_flag) then grim_refresh, grim_data, /no_image $
 else grim_refresh, grim_data, /use_pixmap

end
;=============================================================================



;=============================================================================
; grim_pixel_grid_event
;
;=============================================================================
pro grim_pixel_grid_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Toggle Pixel grid on/off'
   return
  end


 ;---------------------------------------------------------
 ; toggle grid flag
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_data.pixel_grid_flag = NOT grim_data.pixel_grid_flag

 grim_set_data, grim_data, event.top
 if(grim_data.pixel_grid_flag) then grim_refresh, grim_data, /no_image $
 else grim_refresh, grim_data, /use_pixmap
end
;=============================================================================



;=============================================================================
; grim_guideline_event
;
;=============================================================================
pro grim_guideline_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Toggle guidelines on/off'
   return
  end


 ;---------------------------------------------------------
 ; toggle grid flag
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_data.guideline_flag = NOT grim_data.guideline_flag

 if(NOT grim_data.guideline_flag) then grim_erase_guideline, grim_data

 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
; grim_context_event
;
;=============================================================================
pro grim_context_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
       grim_print, grim_data, 'Open/Close image context window'
   return
  end $
 else if(NOT grim_test_motion_event(event)) then $
                                               grim_set_primary, grim_data.base

 ;----------------------------
 ; toggle the mapping state
 ;----------------------------
 grim_toggle_context, grim_data

end
;=============================================================================



;=============================================================================
; grim_axes_event
;
;=============================================================================
pro grim_axes_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Toggle axes on/off'
   return
  end


 ;---------------------------------------------------------
 ; toggle axes state
 ;---------------------------------------------------------
 grim_toggle_axes, grim_data

end
;=============================================================================



;=============================================================================
; grim_render_event
;
;=============================================================================
pro grim_render_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Generate new rendering'
   return
  end


 ;---------------------------------------------------------
 ; render
 ;---------------------------------------------------------
 grim_render, grim_data, plane=plane


end
;=============================================================================



;=============================================================================
; grim_activate_all_event
;
;=============================================================================
pro grim_activate_all_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Activate all overlays'
   return
  end


 ;---------------------------------------------------------
 ; switch to next plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_activate_all, plane
 grim_refresh, grim_data, /no_image

end
;=============================================================================



;=============================================================================
; grim_deactivate_all_event
;
;=============================================================================
pro grim_deactivate_all_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Deactivate all overlays'
   return
  end


 ;---------------------------------------------------------
 ; switch to next plane
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 grim_deactivate_all, plane
 grim_refresh, grim_data, /no_image


end
;=============================================================================



;=============================================================================
; grim_repeat_event
;
;=============================================================================
pro grim_repeat_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Repeat last menu item.'
   return
  end


 ;---------------------------------------------------------
 ; repeat last option
 ;---------------------------------------------------------
 grim_repeat, grim_data


end
;=============================================================================



;=============================================================================
; grim_help
;
;=============================================================================
pro grim_help, grim_data, text

 plane = grim_get_plane(grim_data)
 widget_control, grim_data.draw, /hourglass

 if(NOT widget_info(grim_data.help_text, /valid)) then $
  begin
   grim_data.help_text = textedit(text, base=base, xs=80, resource_prefix='grim_help')
   widget_control, base, tlb_set_title='GRIM Help'
   grim_data.help_base = base
   grim_set_data, grim_data
   grim_refresh, grim_data, /no_image, /no_objects
  end $
 else $
  begin
   widget_control, grim_data.help_text, set_value=text
   widget_control, grim_data.help_base, /map
  end

; hide button

end
;=============================================================================



;=============================================================================
; grim_create_help_menu
;
;=============================================================================
function grim_create_help_menu, _menu_desc

 menu_desc = _menu_desc

 help_desc = strep_s(menu_desc, '_event', '_help_event')
 menu_desc = ['1\Help', help_desc]

 return, menu_desc
end
;=============================================================================



;=============================================================================
; grim_cull_menu_desc
;
;=============================================================================
function grim_cull_menu_desc, _menu_desc, plot, map, beta, $
            map_items=map_items, $
            map_indices=map_indices, $
            od_map_items=od_map_items, $
            od_map_indices=od_map_indices, $
            plot_items=plot_items, $
            plot_indices=plot_indices, $
            plot_only_items=plot_only_items, $
            plot_only_indices=plot_only_indices, $
            beta_only_indices=beta_only_indices

 menu_desc = _menu_desc

 ;-------------------------------------------
 ; mark items to cull
 ;-------------------------------------------
 if(plot) then mark = complement(menu_desc, [plot_indices, plot_only_indices]) $
 else mark = plot_only_indices

 if(map) then $
   mark = append_array(mark, complement(menu_desc, [map_indices, od_map_indices]))

 if(NOT beta) then mark = append_array(mark, beta_only_indices)

 ii = complement(menu_desc, mark)
 if(ii[0] EQ -1) then return, ''
 menu_desc = menu_desc[ii]


 ;-------------------------------------------
 ; remove consecutive duplicate items
 ;-------------------------------------------
 mark = 0
 for i=1, n_elements(menu_desc)-1 do $
       if(menu_desc[i] EQ menu_desc[i-1]) then mark = append_array(mark, [i])
 if(keyword_set(mark)) then menu_desc = rm_list_item(menu_desc, mark)


 ;-------------------------------------------
 ; remove null menus
 ;-------------------------------------------
 mark = 0
 for i=1, n_elements(menu_desc)-1 do $
       if(strmid(menu_desc[i],0,1) EQ '2') then $
             if(strmid(menu_desc[i-1],0,1) EQ '1') then mark = append_array(mark, [i])
 if(keyword_set(mark)) then menu_desc = rm_list_item(menu_desc, mark)


 return, menu_desc
end
;=============================================================================



;=============================================================================
; grim_parse_menu_desc
;
;=============================================================================
function grim_parse_menu_desc, _menu_desc, $
            map_items=map_items, $
            map_indices=map_indices, $
            od_map_items=od_map_items, $
            od_map_indices=od_map_indices, $
            plot_items=plot_items, $
            plot_indices=plot_indices, $
            plot_only_items=plot_only_items, $
            plot_only_indices=plot_only_indices, $
            beta_only_indices=beta_only_indices

 map_token = '*'
 od_token = '#'
 plot_token = '+'
 plot_only_token = '%'
 beta_only_token = '?'

 map_items = ''
 od_map_items = ''
 plot_items = ''
 menu_desc = _menu_desc

 p = strpos(menu_desc, map_token)
 w = where(p NE -1)
 if(w[0] NE -1) then $
  begin
   ss = str_nnsplit(menu_desc[w], map_token, rem=map_items)
   menu_desc[w] = ss + map_items
   map_indices = w
  end

 p = strpos(menu_desc, od_token)
 w = where(p NE -1)
 if(w[0] NE -1) then $
  begin
   ss = str_nnsplit(menu_desc[w], od_token, rem=od_map_items)
   menu_desc[w] = ss + od_map_items
   od_map_indices = w
  end

 p = strpos(menu_desc, plot_token)
 w = where(p NE -1)
 if(w[0] NE -1) then $
  begin
   ss = str_nnsplit(menu_desc[w], plot_token, rem=plot_items)
   menu_desc[w] = ss + plot_items
   plot_indices = w
  end

 p = strpos(menu_desc, plot_only_token)
 w = where(p NE -1)
 if(w[0] NE -1) then $
  begin
   ss = str_nnsplit(menu_desc[w], plot_only_token, rem=plot_only_items)
   menu_desc[w] = ss + plot_only_items
   plot_only_indices = w
  end

 p = strpos(menu_desc, beta_only_token)
 w = where(p NE -1)
 if(w[0] NE -1) then $
  begin
   ss = str_nnsplit(menu_desc[w], beta_only_token, rem=beta_only_items)
   menu_desc[w] = ss + beta_only_items
   beta_only_indices = w
  end

 return, menu_desc
end
;=============================================================================



;=============================================================================
; grim_menu_desc
;
;  Items containing '*' work for maps as well.
;  Items containing '#' work for maps with observer descriptors.
;  Items containing '+' work for plots as well.
;  Items containing '%' work only for plots.
;  Items containing '?' work only for the beta version.
;
;=============================================================================
function grim_menu_desc, cursor_modes=cursor_modes

 desc = [ '+*1\File' , $
           '0\Load                \+*grim_menu_file_load_event', $
           '0\Browse              \*grim_menu_file_browse_event', $
           '0\Save                \+*grim_menu_file_save_event', $
           '0\Save As             \+*grim_menu_file_save_as_event', $
           '0\Open As RGB          \+*grim_menu_open_as_rgb_event', $
           '0\--------------------\+grim_menu_delim_event', $ 
           '0\Save User Points    \+*grim_menu_file_save_user_ptd_event', $
           '0\Save All User Points\+*grim_menu_file_save_all_user_ptd_event', $
           '0\Load User Points    \+*grim_menu_file_load_user_ptd_event', $
           '0\Load All User Points\+*grim_menu_file_load_all_user_ptd_event', $
           '0\--------------------\grim_menu_delim_event', $ 
           '0\Save Tie Points     \*grim_menu_file_save_tie_ptd_event', $
           '0\Save All Tie Points \*grim_menu_file_save_all_tie_ptd_event', $
           '0\Load Tie Points     \*grim_menu_file_load_tie_ptd_event', $
           '0\Load All Tie Points \*grim_menu_file_load_all_tie_ptd_event', $
           '0\--------------------\grim_menu_delim_event', $ 
           '0\Save Curves         \*grim_menu_file_save_curves_event', $
           '0\Save All Curves     \*grim_menu_file_save_all_curves_event', $
           '0\Load Curves         \*grim_menu_file_load_curves_event', $
           '0\Load All Curves     \*grim_menu_file_load_all_curves_event', $
           '0\--------------------\grim_menu_delim_event', $ 
           '0\Save Mask           \*grim_menu_file_save_mask_event', $
           '0\Save All Masks      \*grim_menu_file_save_all_masks_event', $
           '0\Load Mask           \*grim_menu_file_load_mask_event', $
           '0\Load All Masks      \*grim_menu_file_load_all_masks_event', $
           '0\--------------------\+grim_menu_delim_event', $ 
           '0\Save Postscript     \+*grim_menu_file_save_ps_event', $
           '0\--------------------\+grim_menu_delim_event', $ 
           '0\Repeat              \+*grim_menu_repeat_event', $
           '0\Undo                \+*grim_menu_undo_event', $
           '0\Redo                \+*grim_menu_redo_event', $
           '0\--------------------\+grim_menu_delim_event', $ 
           '0\Select              \+*grim_select_event', $
           '0\Identify            \+*grim_identify_event', $
           '0\Close               \+*grim_menu_file_close_event', $
           '2\<null>               \+*grim_menu_delim_event', $

          '+*1\Mode' , $

          '+*1\Plane' , $
           '0\Next               \+*grim_menu_plane_next_event' , $
           '0\Previous           \+*grim_menu_plane_previous_event', $
           '0\Jump               \+*grim_menu_plane_jump_event' , $
           '0\Browse             \*grim_menu_plane_browse_event', $
           '0\Open in new window \*grim_menu_plane_open_event', $
           '0\Crop               \+*grim_menu_plane_crop_event' , $
           '0\Reorder by time    \grim_menu_plane_reorder_time_event', $
           '0\Sequence           \*grim_menu_plane_sequence_event', $
           '0\Dump               \*grim_menu_plane_dump_event', $
           '0\Coregister         \grim_menu_plane_coregister_event', $
           '0\Coadd              \grim_menu_plane_coadd_event', $
           '0\Toggle Syncing   \*grim_menu_plane_toggle_plane_syncing_event', $
           '0\Toggle Highlight   \*grim_menu_plane_highlight_event', $
           '0\-------------------\*grim_menu_delim_event', $ 
           '0\Copy tie points     \*grim_menu_plane_copy_tiepoints_event', $
;           '0\Propagate tie points\*grim_menu_plane_propagate_tiepoints_event', $
           '0\Toggle tie point syncing\*grim_menu_plane_toggle_tiepoint_syncing_event', $
           '0\Clear tie points    \*grim_menu_plane_clear_tiepoints_event', $
           '0\-------------------\*grim_menu_delim_event', $ 
           '0\Copy curves        \*grim_menu_plane_copy_curves_event', $
;           '0\Propagate curves    \*grim_menu_plane_propagate_curves_event', $
           '0\Toggle curves syncing\*grim_menu_plane_toggle_curve_syncing_event', $
           '0\Clear curves        \*grim_menu_plane_clear_curves_event', $
           '0\-------------------\*grim_menu_delim_event', $ 
           '0\Copy mask          \*grim_menu_plane_copy_mask_event', $
           '0\Clear mask         \*grim_menu_plane_clear_mask_event', $
           '0\-------------------\*grim_menu_delim_event', $ 
           '0\Settings           \+*grim_menu_plane_settings_event', $
           '2\<null>               \+*grim_menu_delim_event', $

          '+*1\Data' , $
           '0\Adjust values        \+*grim_menu_data_adjust_event' , $
           '2\<null>               \+*grim_menu_delim_event', $

          '+*1\View' , $
           '0\Refresh              \+*grim_menu_view_refresh_event' , $
           '+*1\Zoom' , $
             '0\Specify           \+*grim_menu_view_zoom_event' , $
             '0\Double            \+*grim_menu_view_zoom_double_event' , $
             '0\Half              \+*grim_menu_view_zoom_half_event' , $
             '0\1                 \+*grim_menu_view_zoom_1_event' , $
             '0\2                 \+*grim_menu_view_zoom_2_event' , $
             '0\3                 \+*grim_menu_view_zoom_3_event' , $
             '0\4                 \+*grim_menu_view_zoom_4_event' , $
             '0\5                 \+*grim_menu_view_zoom_5_event' , $
             '0\6                 \+*grim_menu_view_zoom_6_event' , $
             '0\7                 \+*grim_menu_view_zoom_7_event' , $
             '0\8                 \+*grim_menu_view_zoom_8_event' , $
             '0\9                 \+*grim_menu_view_zoom_9_event' , $
             '0\10                 \+*grim_menu_view_zoom_10_event' , $
             '0\1/2                 \+*grim_menu_view_zoom_1_2_event' , $
             '0\1/3                 \+*grim_menu_view_zoom_1_3_event' , $
             '0\1/4                 \+*grim_menu_view_zoom_1_4_event' , $
             '0\1/5                 \+*grim_menu_view_zoom_1_5_event' , $
             '0\1/6                 \+*grim_menu_view_zoom_1_6_event' , $
             '0\1/7                 \+*grim_menu_view_zoom_1_7_event' , $
             '0\1/8                 \+*grim_menu_view_zoom_1_8_event' , $
             '0\1/9                 \+*grim_menu_view_zoom_1_9_event' , $
             '0\1/10                 \+*grim_menu_view_zoom_1_10_event' , $
             '2\<null>               \+*grim_menu_delim_event', $
           '+*1\Rotate' , $
             '0\0                 \+*grim_menu_view_rotate_0_event' , $
             '0\1                 \+*grim_menu_view_rotate_1_event' , $
             '0\2                 \+*grim_menu_view_rotate_2_event' , $
             '0\3                 \+*grim_menu_view_rotate_3_event' , $
             '0\4                 \+*grim_menu_view_rotate_4_event' , $
             '0\5                 \+*grim_menu_view_rotate_5_event' , $
             '0\6                 \+*grim_menu_view_rotate_6_event' , $
             '0\7                 \+*grim_menu_view_rotate_7_event' , $
             '2\<null>               \+*grim_menu_delim_event', $
           '0\Recenter             \+*grim_menu_view_recenter_event' , $
           '0\Home                 \+*grim_menu_view_home_event' , $
           '0\Save                 \+*grim_menu_view_save_event' , $
           '0\Restore              \+*grim_menu_view_restore_event', $
           '0\Previous             \+*grim_menu_view_previous_event', $
           '0\Entire               \+*grim_menu_view_entire_event', $
           '0\Initial              \+*grim_menu_view_initial_event', $
           '0\Reverse Order        \*grim_menu_view_flip_event', $ 
           '0\Frame Overlays\*grim_menu_view_frame_event', $ 
           '0\---------------------\*grim_menu_delim_event', $ 
           '0\Header               \grim_menu_view_header_event', $
           '0\Notes                \grim_menu_notes_event', $
           '0\---------------------\*grim_menu_delim_event', $ 
           '0\Toggle Image         \+*grim_menu_toggle_image_event' , $
           '0\Toggle Image/Overlays \+*grim_menu_toggle_image_overlays_event' , $
           '0\Toggle Context       \+*grim_menu_context_event' , $
           '0\Toggle Axes          \*grim_menu_axes_event' , $
           '0\---------------------\*grim_menu_delim_event', $ 
           '0\Render               \grim_menu_render_event' , $
           '0\---------------------\*grim_menu_delim_event', $ 
           '0\Colors               \*grim_menu_view_colors_event', $ 
           '2\<null>               \+*grim_menu_delim_event', $

          '+*1\Overlays' ,$
           '0\Compute planet centers \grim_menu_points_planet_centers_event', $ 
           '0\Compute limbs          \#grim_menu_points_limbs_event', $        
           '0\Compute terminators    \#grim_menu_points_terminators_event', $
           '0\Compute planet grids   \*grim_menu_points_planet_grids_event', $ 
           '0\Compute rings          \grim_menu_points_rings_event', $
           '0\Compute ring grids     \grim_menu_points_ring_grids_event', $ 
           '0\Compute stars          \grim_menu_points_stars_event', $ 
           '0\Compute shadows        \grim_menu_points_shadows_event', $ 
           '0\Compute reflections    \?grim_menu_points_reflections_event', $ 
           '0\Compute stations       \*grim_menu_points_stations_event', $ 
           '0\Compute arrays         \*grim_menu_points_arrays_event', $ 
           '0\-------------------------\*grim_menu_delim_event', $ 
           '0\Hide/Unhide all        \+*grim_menu_hide_all_event', $ 
           '0\Clear all              \*grim_menu_clear_all_event', $ 
           '0\Clear active           \*grim_menu_clear_active_event', $ 
           '0\Activate all           \*grim_menu_activate_all_event', $ 
           '0\Deactivate all         \*grim_menu_deactivate_all_event', $ 
           '0\Invert activations     \*grim_menu_invert_event', $ 
           '0\-------------------------\*grim_menu_delim_event', $ 
           '0\Overlay Settings       \+*grim_menu_points_settings_event', $
           '2\<null>               \+*grim_menu_delim_event']

 ;----------------------------------------------
 ; Insert cursor mode menu items
 ;----------------------------------------------
 if(keyword_set(cursor_modes)) then $
  begin
   p = strpos(desc, '1\Mode')
   w = (where(p NE -1))[0]

   nn = max([strlen(cursor_modes.menu), 8])

   items = '0\' + cursor_modes.menu + '  \' + cursor_modes.event_pro
   n = n_elements(items)
;   items[n-1] = strep(items[n-1], '2', 0)
   items = append_array(items, '2\<null>               \+*grim_menu_delim_event')

   desc = [desc[0:w], items, desc[w+1:*]]
   cursor_modes.event_pro = grim_parse_menu_desc(cursor_modes.event_pro)
  end

 return, desc
end
;=============================================================================



;=============================================================================
; grim_get_window_size
;
;=============================================================================
pro grim_get_window_size, grim_data, xsize=xsize, ysize=ysize

 _xsize = 0
 _ysize = 0

 plane = grim_get_plane(grim_data)

 dim = dat_dim(plane.dd)
 if(n_elements(dim) EQ 2) then $
  begin
   xs = double(dim[0])*grim_data.zoom
   ys = double(dim[1])*grim_data.zoom

   if(xs GT _xsize) then _xsize = xs
   if(ys GT _ysize) then _ysize = ys
  end

 if(NOT keyword_set(xsize)) then xsize = _xsize
 if(NOT keyword_set(ysize)) then ysize = _ysize
end
;=============================================================================



;=============================================================================
; grim_menu_capture
;
;=============================================================================
pro grim_menu_capture, fn, event
 grim_data = grim_get_data(event.top)
 if(NOT keyword_set(grim_data)) then return

 if(fn EQ 'grim_menu_repeat_event') then return

 grim_data.repeat_fn = fn
 *grim_data.repeat_event_p = event

 grim_set_data, grim_data, grim_data.base
end
;=============================================================================



;=============================================================================
; grim_widgets
;
;=============================================================================
pro grim_widgets, grim_data, xsize=xsize, ysize=ysize, cursor_modes=cursor_modes, $
   menu_fname=menu_fname, menu_extensions=menu_extensions
@grim_constants.common

 if(grim_data.retain GT 0) then retain = grim_data.retain

 map = grim_test_map(grim_data)
 plot = grim_data.type EQ 'plot'
 beta = grim_data.beta

 ;-----------------------------------------
 ; base, menu bar
 ;-----------------------------------------
 grim_data.base = widget_base(mbar=mbar, /col, /tlb_size_events, $
                          resource_name='grim_base', rname_mbar='grim_mbar')
 grim_data.mbar = mbar
 grim_data.grnum = grim_top_to_grnum(grim_data.base, /new)

 menu_desc = grim_menu_desc(cursor_modes=cursor_modes)
 for i=0, n_elements(menu_extensions)-1 do $
                   menu_desc = [menu_desc, call_function(menu_extensions[i])]

 if(keyword_set(menu_fname)) then $
  begin
   user_menu_desc = strtrim(strip_comment(read_txt_file(menu_fname)), 2)
   if(keyword_set(user_menu_desc)) then menu_desc = [menu_desc, user_menu_desc]
  end


 ;-----------------------------------------
 ; setup menus
 ;-----------------------------------------
 menu_desc = grim_parse_menu_desc(menu_desc, $
     map_items=map_items, map_indices=map_indices, $
     od_map_items=od_map_items, od_map_indices=od_map_indices, $
     plot_items=plot_items, plot_indices=plot_indices, $
     plot_only_items=plot_only_items, plot_only_indices=plot_only_indices, $
     beta_only_indices=beta_only_indices)


;;;;; problem is consecutive 2/<null> lines....
 menu_desc = grim_cull_menu_desc(menu_desc, plot, map, beta, $
     map_items=map_items, map_indices=map_indices, $
     od_map_items=od_map_items, od_map_indices=od_map_indices, $
     plot_items=plot_items, plot_indices=plot_indices, $
     plot_only_items=plot_only_items, plot_only_indices=plot_only_indices, $
     beta_only_indices=beta_only_indices)

 grim_data.menu_desc_p = nv_ptr_new(menu_desc)
 grim_data.map_items_p = nv_ptr_new(map_items)
 grim_data.od_map_items_p = nv_ptr_new(od_map_items)

 grim_data.menu = $
          cw__pdmenu(grim_data.mbar, menu_desc, /mbar, ids=menu_ids, $
                                                  capture='grim_menu_capture')
 grim_data.menu_ids_p = nv_ptr_new(menu_ids)
 help_menu_desc = grim_create_help_menu(menu_desc)
 grim_data.help_menu = cw__pdmenu(grim_data.mbar, help_menu_desc, /mbar)


 ;-----------------------------------------
 ; shortcut buttons
 ;-----------------------------------------
 grim_data.shortcuts_base = $
        widget_base(grim_data.base, /row, space=0, xpad=0, ypad=0, $
                                      resource_name='grim_shortcuts_base')

 grim_data.shortcuts_base1 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=0, ypad=0)

 grim_data.select_button = widget_button(grim_data.shortcuts_base1, $
             resource_name='grim_select_button', $
             value=grim_unselect_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_select_event')

 gm = widget_info(grim_data.shortcuts_base1, /geom)
 ys = gm.ysize
 grim_data.shortcuts_base2 = $
           widget_base(grim_data.shortcuts_base, /row, $
                                       space=0, xpad=4, ypad=0, ysize=ys)

 grim_data.previous_button = widget_button(grim_data.shortcuts_base2, $
             resource_name='grim_previous_button', $
             value=grim_previous_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_previous_event')

 grim_data.jumpto_text = widget_text(grim_data.shortcuts_base2, $
                     resource_name='grim_jumpto_text', xsize=3, $
                               value='', /tracking_events, /editable, $
                                              event_pro='grim_jumpto_event')

 grim_data.next_button = widget_button(grim_data.shortcuts_base2, $
             resource_name='grim_next_button', $
             value=grim_next_bitmap(), /bitmap, /tracking_events, $
                                                  event_pro='grim_next_event')


 grim_data.shortcuts_base3 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=0, ypad=0)

 grim_data.crop_button = widget_button(grim_data.shortcuts_base3, $
             resource_name='grim_crop_button', $
             value=grim_crop_bitmap(), /bitmap, /tracking_events, $
                                                  event_pro='grim_crop_event')

 grim_data.refresh_button = widget_button(grim_data.shortcuts_base3, $
              resource_name='grim_refresh_button', $
              value=grim_refresh_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_refresh_event')

 grim_data.entire_button = widget_button(grim_data.shortcuts_base3, $
              resource_name='grim_entire_button', $
              value=grim_entire_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_entire_event')

 grim_data.view_previous_button = widget_button(grim_data.shortcuts_base3, $
              resource_name='grim_view_previous_button', $
              value=grim_view_previous_bitmap(), /bitmap, /tracking_events, $
                                          event_pro='grim_view_previous_event')


 grim_data.shortcuts_base4 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=4, ypad=0)

 grim_data.hide_button = widget_button(grim_data.shortcuts_base4, $
              resource_name='grim_hide_button', $
              value=grim_hide_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_hide_event')

 grim_data.toggle_image_button = widget_button(grim_data.shortcuts_base4, $
              resource_name='grim_toggle_image_button', $
              value=grim_hide_image_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_toggle_image_event')

 grim_data.toggle_image_overlays_button = widget_button(grim_data.shortcuts_base4, $
              resource_name='grim_toggle_image_overlays_button', $
              value=grim_hide_image_bitmap() AND grim_hide_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_toggle_image_overlays_event')

 if((NOT plot) AND (NOT map)) then $
   grim_data.render_button = widget_button(grim_data.shortcuts_base4, $
              resource_name='grim_render_button', $
              value=grim_render_bitmap(), /bitmap, /tracking_events, $
                                                 event_pro='grim_render_event')



 grim_data.shortcuts_base5 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=0, ypad=0)

 if(NOT plot) then $
   grim_data.color_button = widget_button(grim_data.shortcuts_base5, $
              resource_name='grim_color_button', $
              value=grim_colors_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_colors_event')

 grim_data.settings_button = widget_button(grim_data.shortcuts_base5, $
              resource_name='grim_settings_button', $
              value=grim_settings_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_settings_event')


 grim_data.shortcuts_base6 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=4, ypad=0)

 grim_data.tracking_button = widget_button(grim_data.shortcuts_base6, $
              resource_name='grim_tracking_button', $
              value=grim_tracking_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_tracking_event')

  grim_data.guideline_button = widget_button(grim_data.shortcuts_base6, $
              resource_name='grim_guideline_button', $
              value=grim_guideline_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_guideline_event')

 if(NOT plot) then $
   grim_data.grid_button = widget_button(grim_data.shortcuts_base6, $
              resource_name='grim_grid_button', $
              value=grim_grid_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_grid_event')

 if(NOT plot) then $
   grim_data.pixel_grid_button = widget_button(grim_data.shortcuts_base6, $
              resource_name='grim_pixel_grid_button', $
              value=grim_pixel_grid_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_pixel_grid_event')



 grim_data.shortcuts_base9 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=0, ypad=0)

 grim_data.context_button = widget_button(grim_data.shortcuts_base9, $
              resource_name='grim_context_button', $
              value=grim_context_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_context_event')

 if(NOT plot) then $
   grim_data.axes_button = widget_button(grim_data.shortcuts_base9, $
              resource_name='grim_axes_button', $
              value=grim_axes_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_axes_event')


 grim_data.shortcuts_base7 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=4, ypad=0)

 if(NOT plot) then $
   grim_data.activate_all_button = widget_button(grim_data.shortcuts_base7, $
         resource_name='grim_activate_all_button', $
         value=grim_activate_all_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_activate_all_event')

 if(NOT plot) then $
   grim_data.deactivate_all_button = widget_button(grim_data.shortcuts_base7, $
         resource_name='grim_deactivate_all_button', $
         value=grim_deactivate_all_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_deactivate_all_event')


 grim_data.shortcuts_base8 = $
        widget_base(grim_data.shortcuts_base, /row, space=0, xpad=0, ypad=0)

 grim_data.header_button = widget_button(grim_data.shortcuts_base8, $
         resource_name='grim_header_button', $
         value=grim_header_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_header_event')

 grim_data.notes_button = widget_button(grim_data.shortcuts_base8, $
         resource_name='grim_notes_button', $
         value=grim_notes_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_notes_event')

 grim_data.repeat_button = widget_button(grim_data.shortcuts_base8, $
         resource_name='grim_repeat_button', $
         value=grim_repeat_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_repeat_event')

 grim_data.undo_button = widget_button(grim_data.shortcuts_base8, $
         resource_name='grim_undo_button', $
         value=grim_undo_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_undo_event')
 w = where(strpos(menu_desc, 'grim_menu_undo_event') NE -1)
 grim_data.undo_menu_id = menu_ids[w[0]]

 grim_data.redo_button = widget_button(grim_data.shortcuts_base8, $
         resource_name='grim_redo_button', $
         value=grim_redo_bitmap(), /bitmap, /tracking_events, $
                                     event_pro='grim_redo_event')
 w = where(strpos(menu_desc, 'grim_menu_redo_event') NE -1)
 grim_data.redo_menu_id = menu_ids[w[0]]


 grim_data.identify_button = widget_button(grim_data.shortcuts_base8, $
             resource_name='grim_identify_button', $
             value=grim_identify_bitmap(), /bitmap, /tracking_events, $
                                              event_pro='grim_identify_event')



 grim_data.sub_base = widget_base(grim_data.base, /row, xpad=0, space=2)



 ;-----------------------------------------
 ; mode buttons
 ;-----------------------------------------
 grim_data.modes_base = $
        widget_base(grim_data.sub_base, /col, space=0, xpad=0, ypad=0, $
                                             resource_name='grim_modes_base')


 ;-----------------------------------------
 ; cursor modes
 ;-----------------------------------------
 nmodes = n_elements(cursor_modes)
 if(nmodes GT 0) then $
  begin
   for i=0, nmodes-1 do $
    begin
     event_pro = grim_parse_menu_desc(cursor_modes[i].event_pro)
     w = where(strpos(menu_desc, event_pro) NE -1)

     if(w[0] NE -1) then $
      begin
       ii = w[0]
       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       ; Because we override the event_pro here, the user modes do not
       ; participate in grim's capture mechanism, so the 'repeat'
       ; command does not apply.  This is necessary because the user
       ; modes store their data in their button's uvalue, which would
       ; otherwise be used by the capture mechanism.
       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       button = widget_button(grim_data.modes_base, $
                   value=cursor_modes[i].bitmap, /bitmap, /tracking_events, $
                              event_pro=event_pro, uname='mode', $
                                                   uvalue=cursor_modes[i].name)
       widget_control, button, set_uvalue=cursor_modes[i]

       widget_control, menu_ids[ii], set_uvalue=cursor_modes[i], $
                                        event_pro=cursor_modes[i].event_pro
      end
    end
   end


 window, /free, /pixmap, xsize=MAG_SIZE_DEVICE, ysize=MAG_SIZE_DEVICE
 grim_data.mag_pixmap = !d.window
 window, /free, /pixmap, xsize=MAG_SIZE_DEVICE, ysize=MAG_SIZE_DEVICE
 grim_data.mag_redraw_pixmap = !d.window


 ;-----------------------------------------
 ; main draw window
 ;-----------------------------------------
 grim_data.draw_base = widget_base(grim_data.sub_base, $
                      xsize=xsize, ysize=ysize, space=0, xpad=0, ypad=0)

; grim_data.scale_draw = $
;      widget_draw(grim_data.main_draw_base, $
;            xsize=xsize+SCALE_WIDTH*2, ysize=ysize+SCALE_WIDTH*2, retain=retain)


; grim_data.draw_base = widget_base(grim_data.main_draw_base, $
;                                xsize=xsize, ysize=ysize, space=0, xoff=0, yoff=0)
 grim_data.draw = $
     widget_draw(grim_data.draw_base, $
                /button_events, /tracking_events, /motion_events, $
                event_pro='grim_draw_event', resource_name='grim_draw', $
                retain=retain)
 if(idl_v_chrono(!version.release) GE idl_v_chrono('6.4')) then $
                             widget_control, grim_data.draw, /draw_wheel_events
; widget_control, grim_data.draw_base, map=0


 ;-----------------------------------------
 ; message line
 ;-----------------------------------------
 grim_data.message_base = $
        widget_base(grim_data.base, /row, space=0, xpad=0, ypad=0, $
                                      resource_name='grim_message_base')

 grim_data.xy_label = $
       widget_label(grim_data.message_base, val='(----,----): ----------------', $
                       frame=1, /align_left, resource_name='grim_xy_label')

 grim_data.label = $
       widget_label(grim_data.message_base, val=' ', frame=1, /align_left, $
                                                    resource_name='grim_label')

 widget_control, grim_data.base, map=0
 widget_control, /realize, grim_data.base


 widget_control, grim_data.draw, get_value=wnum
 grim_data.wnum = wnum

; widget_control, grim_data.scale_draw, get_value=scale_wnum
; grim_data.scale_wnum = scale_wnum


 ;-----------------------------------------
 ; context draw window
 ;-----------------------------------------
 context_xsize = (context_ysize = CONTEXT_SIZE)
 grim_data.context_base = $
              widget_base(grim_data.draw_base, xs=context_xsize, $
                                           ys=context_ysize, xoff=0, yoff=0)
 grim_data.context_draw = widget_draw(grim_data.context_base, $
                /button_events, /motion_events, /tracking_events, $
                 event_pro='grim_draw_event', retain=retain)
 widget_control, grim_data.context_draw, get_value=context_wnum
 grim_data.context_wnum = context_wnum
 widget_control, grim_data.context_base, map=0

 window, /free, /pixmap, xsize=context_xsize, ysize=context_ysize
 grim_data.context_pixmap = !d.window

 wset, wnum

 ;-----------------------------------------
 ; axes draw window
 ;-----------------------------------------
 axes_xsize = (axes_ysize = AXES_SIZE)
 geom = widget_info(grim_data.draw_base, /geom)
 grim_data.axes_base = $
                widget_base(grim_data.draw_base, $
                xs=axes_xsize, ys=axes_ysize)
 grim_data.axes_draw = widget_draw(grim_data.axes_base, $
                /button_events, /motion_events, /tracking_events, $
                 event_pro='grim_draw_event', retain=retain, $
                 xs=axes_xsize, ys=axes_ysize)
 widget_control, grim_data.axes_draw, get_value=axes_wnum
 grim_data.axes_wnum = axes_wnum
 widget_control, grim_data.axes_base, map=0


 wset, wnum

end
;=============================================================================



;=============================================================================
; grim_get_default_zoom
;
;=============================================================================
function grim_get_default_zoom, dd
ratio = 0.75

 device, get_screen_size=screen_size
 
 xsize_max = screen_size[0] * ratio
 ysize_max = screen_size[1] * ratio

 dim = dat_dim(dd)
 if(n_elements(dim) EQ 1) then dim = [dim, 1]

 sx = double(dim[0])
 sy = double(dim[1])

 im = 0

 Rx = xsize_max / sx
 Ry = ysize_max / sy

 if(Rx LT Ry) then return, Rx $
 else return, Ry

end
;=============================================================================



;=============================================================================
; grim_save_initial_view
;
;=============================================================================
pro grim_save_initial_view, grim_data

 tvim, get_info=tvd, /inherit, /silent, /no_coord
 *grim_data.tvd_init_p = tvd

end
;=============================================================================



;=============================================================================
; grim_initial_framing
;
;=============================================================================
pro grim_initial_framing, grim_data, frame

 z = 1d100

 planes = grim_get_plane(grim_data, /all)
 for i=0, n_elements(planes)-1 do $
  begin
   name = grim_parse_overlay(frame[0], obj_name)
   ptd = grim_get_all_overlays(grim_data, plane=planes[i], name=name)
   if(NOT keyword_set(ptd)) then $
        grim_initial_overlays, grim_data, plane=planes[i], frame[0], /temp, ptd=ptd

   if(keyword_set(obj_name)) then $
    begin
     obj_names = cor_name(ptd)
     w = where(obj_names[0,*] EQ obj_name[0])
     if(w[0] EQ -1) then return
     ptd = ptd[*,w]
    end

   if(keyword_set(ptd)) then grim_frame_overlays, grim_data, planes[i], ptd
   tvim, get_info=tvd, /inherit, /silent
   if(min(tvd.zoom) LT z) then $
    begin
     z = min(tvd.zoom)
     off = tvd.offset
    end
  end

 tvim, zoom=z, offset=off, /inherit, /silent

end
;=============================================================================



;=============================================================================
; grim_initial_overlays
;
;=============================================================================
pro grim_initial_overlays, grim_data, plane=plane, _overlays, exclude=exclude, $
    only=only, temp=temp, ptd=ptd

 widget_control, /hourglass

 overlays = _overlays

 if(keyword_set(exclude)) then $
  begin
   for i=0, n_elements(exclude)-1 do $
    begin
     w = where(overlays EQ exclude[i])
     if(w[0] NE -1) then overlays = rm_list_item(overlays, w[0])
    end
  end

 if(keyword_set(only)) then $
  begin
   overlays = ''
   for i=0, n_elements(only)-1 do $
    begin
     w = where(_overlays EQ only[i])
     if(w[0] NE -1) then overlays = append_array(overlays, only[i])
    end 
  end

 if(NOT keyword_set(overlays)) then return

 if(keyword_set(plane)) then planes = plane $
 else planes = grim_get_plane(grim_data, /all)
 nplanes = n_elements(planes)

 n_overlays = n_elements(overlays)
 if(grim_data.slave_overlays) then nplanes = 1

 for j=0, nplanes-1 do $
  begin
   for i=0, n_overlays-1 do $
    begin
     name = grim_parse_overlay(overlays[i], obj_name)
     grim_print, grim_data, 'Plane ' + strtrim(j,1) + ': ' + name
     grim_overlay, grim_data, name, plane=planes[j], obj_name=obj_name, temp=temp, ptd=_ptd
     if(keyword_set(_ptd)) then ptd = append_array(ptd, _ptd[*])
    end
  end


end
;=============================================================================



;=============================================================================
; grim_cube_dim_fn
;
;
;=============================================================================
function grim_cube_dim_fn, dd, dat
 return, (dat_dim(dd, /true))[0:1]
end
;=============================================================================



;=============================================================================
; grim_get_arg
;
;=============================================================================
pro grim_get_arg, arg, dd=dd, grnum=grnum, extensions=extensions

 if(NOT keyword_set(arg)) then return

 type = size(arg, /type)
 dim = size(arg, /dim) 
 ndim = n_elements(dim)

 ;---------------------------------------------------
 ; object -- assume data descriptor 
 ;---------------------------------------------------
 if(type EQ 11) then $
  begin
   dd = append_array(dd, arg)
   return
  end

 ;---------------------------------------------------
 ; string -- assume file name(s); read descriptors 
 ;---------------------------------------------------
 if(type EQ 7) then $
  begin
   dd = dat_read(arg, extensions=extensions)
   return
  end

 ;------------------------------------------------
 ; scalar arg is grnum
 ;------------------------------------------------
 if((ndim EQ 1) AND (dim[0] EQ 0)) then $
  begin
   grnum = arg
   return
  end

 ;------------------------------------------------
 ; 1-D, 2-D or 3-D arg: just make dd
 ;------------------------------------------------
 if(ndim LE 3) then $
  begin
   _dd = dat_create_descriptors(1, data=arg)
   dd = append_array(dd, _dd)
   return
  end


 ;------------------------------------------------
 ; other inputs are invalid
 ;------------------------------------------------
 grim_message, 'Invalid argument.'
end
;=============================================================================



;=============================================================================
; grim_get_args
;
; Possible arguments to GRIM:
; 	dd (object)
; 	filename (string)
; 	grnum (scalar)
; 	image (2d array)
; 	plot (1d array)
; 	cube (3d array)
;
;=============================================================================
pro grim_get_args, arg1, arg2, dd=dd, grnum=grnum, type=type, xzero=xzero, nhist=nhist, $
               maintain=maintain, compress=compress, extensions=extensions, rgb=rgb, offsets=offsets

 ;--------------------------------------------
 ; build data descriptors list 
 ;--------------------------------------------
 grim_get_arg, arg1, dd=_dd, grnum=grnum, extensions=extensions
 grim_get_arg, arg2, dd=_dd, grnum=grnum, extensions=extensions


 ;--------------------------------------------
 ; process data descriptors 
 ;--------------------------------------------
 n_dd = n_elements(_dd)

 for i=0, n_dd-1 do $
  begin
   dim = dat_dim(_dd[i])
   ndim = n_elements(dim)

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; set dd controls
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(nhist)) then dat_set_nhist, _dd[i], nhist[0]
   if(keyword_set(maintain)) then dat_set_maintain, _dd[i], maintain[0]
   if(keyword_set(compress)) then dat_set_compress, _dd[i], compress[0]

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; non-3-D arrays get a plane and a zero offset
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if((ndim LT 3) OR keyword_set(rgb)) then $
    begin
     dd = append_array(dd, _dd[i])
     offsets = append_array(offsets, [0])

if(keyword_set(rgb)) then dat_set_dim_fn, dd, 'grim_cube_dim_fn'
    end $ 
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; 3-D arrays are either rgb or multi-plane
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   else $
    begin
     dd = append_array(dd, make_array(dim[2], val=_dd[i]))
     offsets = append_array(offsets, lindgen(dim[2])*dim[0]*dim[1])
dat_set_dim_fn, dd, 'grim_cube_dim_fn'
    end 
  end


 ;-------------------------------------------------------------------
 ; all dd assumed to have same type as first one; default is image
 ;-------------------------------------------------------------------
 type = 'image'
 if(keyword_set(dd)) then $
  begin 
   dim = dat_dim(dd[0])
   if(n_elements(dim) EQ 1) then type = 'plot'
   if(dim[0] EQ 2) then type = 'plot'
  end


end
;=============================================================================



;=============================================================================
; grim_create_cursor_mode
;
;=============================================================================
function grim_create_cursor_mode, name, arg, cursor_modes
 cursor_mode = call_function(name, arg)
 return, append_array(cursor_modes, cursor_mode)
end
;=============================================================================



;=============================================================================
; grim
;
;=============================================================================
pro grim, arg1, arg2, gd=gd, cd=cd, pd=pd, rd=rd, sd=sd, std=std, ard=ard, sund=sund, od=od, $
	silent=silent, new=new, inherit=inherit, xsize=xsize, ysize=ysize, $
	default=default, previous=previous, restore=restore, activate=activate, $
	doffset=doffset, no_erase=no_erase, filter=filter, rgb=rgb, visibility=visibility, channel=channel, exit=exit, $
	zoom=zoom, rotate=rotate, order=order, offset=offset, retain=retain, maintain=maintain, $
	set_info=set_info, mode=mode, modal=modal, xzero=xzero, frame=frame, $
	refresh_callbacks=refresh_callbacks, refresh_callback_data_ps=refresh_callback_data_ps, $
	plane_callbacks=plane_callbacks, plane_callback_data_ps=plane_callback_data_ps, $
	nhist=nhist, compress=compress, path=path, symsize=symsize, $
	cursor_modes=cursor_modes, user_psym=user_psym, ups=ups, workdir=workdir, $
        save_path=save_path, load_path=load_path, overlays=overlays, pn=pn, $
	faint=faint, menu_fname=menu_fname, cursor_swap=cursor_swap, fov=fov, hide=hide, $
	menu_extensions=menu_extensions, button_extensions=button_extensions, $
	arg_extensions=arg_extensions, loadct=loadct, max=max, grnum=grnum, $
	extensions=extensions, beta=beta, rendering=rendering, npoints=npoints, $
	trs_cd=trs_cd, trs_pd=trs_pd, trs_rd=trs_rd, trs_sd=trs_sd, $
        trs_sund=trs_sund, trs_std=trs_std, trs_ard=trs_ard, assoc_xd=assoc_xd, $
        readout_fns=readout_fns, plane_syncing=plane_syncing, tiepoint_syncing=tiepoint_syncing, $
	curve_syncing=curve_syncing, render_sample=render_sample, $
	render_pht_min=render_pht_min, slave_overlays=slave_overlays, $
     ;----- extra keywords for plotting only ----------
	color=color, xrange=xrange, yrange=yrange, thick=thick, nsum=nsum, ndd=ndd, $
        xtitle=xtitle, ytitle=ytitle, psym=psym, title=title
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
@grim_block.include
@grim_constants.common

 if(keyword_set(exit)) then $
  begin
   grim_exit
   return
  end


 grim_constants

 grim_rc_settings, rcfile='.grimrc', $
	silent=silent, new=new, xsize=xsize, ysize=ysize, mode=mode, $
	zoom=zoom, rotate=rotate, order=order, offset=offset, filter=filter, retain=retain, $
	path=path, save_path=save_path, load_path=load_path, symsize=symsize, $
        overlays=overlays, menu_fname=menu_fname, cursor_swap=cursor_swap, $
	fov=fov, menu_extensions=menu_extensions, button_extensions=button_extensions, arg_extensions=arg_extensions, $
	trs_cd=trs_cd, trs_pd=trs_pd, trs_rd=trs_rd, trs_sd=trs_sd, trs_sund=trs_sund, trs_std=trs_std, trs_ard=trs_ard, $
	filetype=filetype, hide=hide, readout_fns=readout_fns, xzero=xzero, $
        psym=psym, nhist=nhist, maintain=maintain, ndd=ndd, workdir=workdir, $
        activate=activate, frame=frame, compress=compress, loadct=loadct, max=max, $
	extensions=extensions, beta=beta, rendering=rendering, npoints=npoints, $
        plane_syncing=plane_syncing, tiepoint_syncing=tiepoint_syncing, curve_syncing=curve_syncing, $
	visibility=visibility, channel=channel, render_sample=render_sample, $
	render_pht_min=render_pht_min, slave_overlays=slave_overlays, rgb=rgb

 if(keyword_set(ndd)) then dat_set_ndd, ndd

 if(NOT keyword_set(menu_extensions)) then $
                                     menu_extensions = 'grim_default_menus' $
 else if(strmid(menu_extensions[0],0,1) EQ '+') then $
  begin
   menu_extensions[0] = strmid(menu_extensions[0], 1, strlen(menu_extensions[0])-1)
   menu_extensions = ['grim_default_menus', menu_extensions]
  end


 ;=========================================================
 ; cursor modes
 ;=========================================================
 cursor_modes = grim_create_cursor_mode('grim_mode_activate', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_zoom_plot', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_zoom', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_pan_plot', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_pan', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_readout', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_tiepoints', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_curves', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_mask', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_magnify', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_xyzoom', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_remove', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_trim', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_select', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_region', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_smooth', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_plane', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_drag', 0, cursor_modes)
 cursor_modes = grim_create_cursor_mode('grim_mode_navigate', 0, cursor_modes)

 ;-------------------------------------------
 ; cursor mode extensions
 ;-------------------------------------------
 n_ext = n_elements(button_extensions)
 if(n_ext GT 0) then $
  begin
   if(NOT keyword_set(arg_extensions)) then arg_extensions = lonarr(n_ext)
   for i=0, n_ext-1 do $
    begin
     if(size(arg_extensions, /type) EQ 10) then arg_extension = *arg_extensions[i] $
     else arg_extension = arg_extensions[i]
    
     cursor_modes = append_array(cursor_modes, $
                   grim_create_cursor_mode(button_extensions[i], arg_extension))
    end
  end


 ;=========================================================
 ; input defaults
 ;=========================================================
 new = keyword_set(new)
 if(NOT keyword_set(fov)) then fov = 0
 if(NOT defined(hide)) then hide = 1
 if(n_elements(retain) EQ 0) then retain = 2
 if(n_elements(maintain) EQ 0) then maintain = 1
 if(NOT keyword_set(compress)) then compress = ''
 if(NOT keyword_set(extensions)) then extensions = ''
 if(NOT keyword_set(trs)) then trs = ''
 if(NOT keyword_set(trs_cd)) then trs_cd = ''
 if(NOT keyword_set(trs_pd)) then trs_pd = ''
 if(NOT keyword_set(trs_rd)) then trs_rd = ''
 if(NOT keyword_set(trs_sd)) then trs_sd = ''
 if(NOT keyword_set(trs_std)) then trs_std = ''
 if(NOT keyword_set(trs_ard)) then trs_ard = ''
 if(NOT keyword_set(trs_sund)) then trs_sund = ''
 
 if(NOT keyword_set(title)) then title = ''
 if(NOT keyword_set(xtitle)) then xtitle = ''
 if(NOT keyword_set(ytitle)) then ytitle = ''

 ;=========================================================
 ; resolve arguments
 ;=========================================================
 grim_get_args, arg1, arg2, dd=dd, offsets=data_offsets, grnum=grnum, type=type, $
             nhist=nhist, maintain=maintain, compress=compress, $
             extensions=extensions, rgb=rgb

; if(keyword_set(rendering)) then ....

 if(NOT keyword_set(grim_get_data())) then new = 1

 if(NOT keyword_set(mode)) then $
  begin
   if(type EQ 'plot') then mode = 'grim_mode_zoom_plot' $
   else mode = 'grim_mode_activate'
  end


 if(type EQ 'plot') then $
  begin
   if(NOT keyword_set(xsize)) then xsize = 500
   if(NOT keyword_set(ysize)) then ysize = 500
  end

 ;=========================================================
 ; if new instance, set up widgets and data structures
 ;=========================================================
 if(new) then $
  begin
   ;-----------------------------
   ; defaults
   ;-----------------------------
   if(NOT keyword_set(dd)) then $
    begin
     if(NOT keyword_set(xsize)) then xsize = 512
     if(NOT keyword_set(ysize)) then ysize = 512
     dd = dat_create_descriptors(1, data=grim_blank(xsize, ysize), $
          name='BLANK', nhist=nhist, maintain=maintain, compress=compress)
    end $
   else $
    for i=0, n_elements(dd)-1 do $
     if(NOT keyword_set(dat_dim(dd[i]))) then $
      begin
       if(NOT keyword_set(xsize)) then xsize = 512
       if(NOT keyword_set(ysize)) then ysize = 512
       dat_set_maintain, dd[i], 0
       dat_set_compress, dd[i], compress
       dat_set_data, dd[i], grim_blank(xsize, ysize) 
      end

   if(NOT keyword_set(zoom)) then zoom = grim_get_default_zoom(dd[0])

   ;----------------------------------------------
   ; initialize data structure and common block
   ;----------------------------------------------
   grim_data = grim_init(dd, dd0=dd0, zoom=zoom, wnum=wnum, grnum=grnum, type=type, $
       filter=filter, retain=retain, user_callbacks=user_callbacks, $
       user_psym=user_psym, path=path, save_path=save_path, load_path=load_path, $
       faint=faint, cursor_swap=cursor_swap, fov=fov, hide=hide, filetype=filetype, $
       trs_cd=trs_cd, trs_pd=trs_pd, trs_rd=trs_rd, trs_sd=trs_sd, trs_std=trs_std, trs_sund=trs_sund, trs_ard=trs_ard, $
       color=color, xrange=xrange, yrange=yrange, thick=thick, nsum=nsum, $
       psym=psym, xtitle=xtitle, ytitle=ytitle, cursor_modes=cursor_modes, workdir=workdir, $
       readout_fns=readout_fns, symsize=symsize, nhist=nhist, maintain=maintain, $
       compress=compress, extensions=extensions, max=max, beta=beta, npoints=npoints, $
       plane_syncing=plane_syncing, tiepoint_syncing=tiepoint_syncing, curve_syncing=curve_syncing, $
       visibility=visibility, channel=channel, data_offsets=data_offsets, $
       title=title, render_sample=render_sample, slave_overlays=slave_overlays, $
       render_pht_min=render_pht_min)


   ;----------------------------------------------
   ; initialize colors common block
   ;----------------------------------------------
   if(NOT defined(loadct)) then loadct = 0
   if(NOT keyword_set(r_curr)) then loadct, loadct
   ctmod


   ;-----------------------------
   ; widgets
   ;-----------------------------
   if(type NE 'plot') then grim_get_window_size, grim_data, xsize=xsize, ysize=ysize
   grim_widgets, grim_data, xsize=xsize, ysize=ysize, cursor_modes=cursor_modes, $
         menu_fname=menu_fname, menu_extensions=menu_extensions

   grnum = grim_data.grnum 

   planes = grim_get_plane(grim_data, /all)
   for i=0, n_elements(planes)-1 do planes[i].grnum = grnum
   grim_set_plane, grim_data, planes

   grim_set_mode, grim_data, mode, /init
   grim_set_data, grim_data, grim_data.base

   grim_resize, grim_data, /init
   widget_control, grim_data.base, map=1
   widget_control, grim_data.draw_base, map=1;, $
             ; xsize=xsize, ysize=ysize;, xoff=SCALE_WIDTH, yoff=SCALE_WIDTH


   geom = widget_info(grim_data.base, /geom)
   grim_data.base_xsize = geom.xsize
   grim_data.base_ysize = geom.ysize

   ;----------------------------------------------
   ; store initial tvim settings
   ;----------------------------------------------
   grim_wset, grim_data, /save

   grim_set_primary, grim_data.base

   ;----------------------------------------------
   ; register data descriptor events
   ;----------------------------------------------
   nv_notify_register, dd, 'grim_descriptor_notify', scalar_data=grim_data.base

   xmanager, 'grim', grim_data.base, $
                 /no_block, modal=modal, cleanup='grim_kill_notify'
   if(keyword_set(modal)) then return


   ;----------------------------------------------
   ; initialize extensions
   ;----------------------------------------------
;   if(keyword_set(button_extensions)) then $
;    begin
;     for i=0, n_elements(button_extensions)-1 do $
;                    call_procedure, button_extensions[i]+'_init', grim_data, cursor_modes[i].data_p
;    end

  end


 ;======================================================================
 ; change to new window if specified
 ;======================================================================
 if(defined(grnum)) then $
  begin
   grim_data = grim_get_data(grnum=grnum)
   grim_wset, grim_data, /silent
  end




 ;======================================================================
 ; update descriptors if any given
 ;  If one plane, then descriptors all go to that plane; in that case
 ;   only one cd, od, sund are allowed
 ;  If mutiple planes, descriptors are sorted using assoc_xd
 ;  If assoc_xd given as argument, use those instead.  
 ;   In that case, if a map descriptor given, associate cd with dd
 ;   instead of assoc_xd since dd will be the corresponding map.
 ;======================================================================
 pgs_gd, gd, cd=cd, pd=pd, rd=rd, sd=sd, std=std, ard=ard, sund=sund, od=od

 grim_data = grim_get_data()
 planes = grim_get_plane(grim_data, /all)
 nplanes = n_elements(planes)
;ncd = n_elements(cd)

 for i=0, nplanes-1 do $
  begin
   _assoc_xd = 0
   if(nplanes NE 1) then _assoc_xd = planes[i].dd
   if(keyword_set(assoc_xd)) then _assoc_xd = assoc_xd[i]

   if(keyword_set(pd)) then $
	 grim_add_descriptor, grim_data, planes[i].pd_p, pd, assoc_xd=_assoc_xd
   if(keyword_set(rd)) then $
	 grim_add_descriptor, grim_data, planes[i].rd_p, rd, assoc_xd=_assoc_xd
   if(keyword_set(std)) then $
	 grim_add_descriptor, grim_data, planes[i].std_p, std, assoc_xd=_assoc_xd
   if(keyword_set(ard)) then $
	 grim_add_descriptor, grim_data, planes[i].ard_p, ard, assoc_xd=_assoc_xd
   if(keyword_set(sd)) then $
	 grim_add_descriptor, grim_data, planes[i].sd_p, sd, assoc_xd=_assoc_xd
   if(keyword_set(sund)) then $
	 grim_add_descriptor, grim_data, planes[i].sund_p, sund[i], /one, assoc_xd=_assoc_xd
   if(keyword_set(od)) then $
     grim_add_descriptor, grim_data, planes[i].od_p, od[i], /one, /noregister, assoc_xd=_assoc_xd

   if(keyword_set(cd)) then $
    begin
     if(keyword_set(_assoc_xd)) then $
       if(cor_class(cd[i]) EQ 'MAP') then _assoc_xd = planes[i].dd
     grim_add_descriptor, grim_data, planes[i].cd_p, cd, /one, assoc_xd=_assoc_xd
    end
  end



;;----------------------------------------------------------------------
;; if one cd, just use current plane
;;----------------------------------------------------------------------
;if(ncd EQ 1) then planes = grim_get_plane(grim_data) $
;;----------------------------------------------------------------------
;; if more than one cd, then one for each plane
;;----------------------------------------------------------------------
;else if(ncd GT 1) then $
; begin
;  planes = grim_get_plane(grim_data, /all)
;  if(n_elements(planes) NE ncd) then $
;               nv_message, name='grim', $
;                    'There must be one camera descriptor for each plane.'
; end $
;;----------------------------------------------------------------------
;; if no camera descriptors given, then you can still give other
;; descriptors to use for the current plane
;;----------------------------------------------------------------------
;else $
; begin
;  plane = grim_get_plane(grim_data, pn=pn)
;  if(keyword_set(pd)) then grim_add_descriptor, grim_data, plane.pd_p, pd
;  if(keyword_set(rd)) then grim_add_descriptor, grim_data, plane.rd_p, rd
;  if(keyword_set(sd)) then grim_add_descriptor, grim_data, plane.sd_p, sd
;  if(keyword_set(std)) then grim_add_descriptor, grim_data, plane.std_p, std
;  if(keyword_set(ard)) then grim_add_descriptor, grim_data, plane.ard_p, std
;  if(keyword_set(sund)) then $
;            grim_add_descriptor, grim_data, plane.sund_p, sund, /one
;  if(keyword_set(od)) then $
;            grim_add_descriptor, grim_data, plane.od_p, od, /one, /noregister
; end

;;----------------------------------------------------------------------
;; if descriptors given, then the descriptors must be arrays 
;; with the following dimensions:
;;
;;  cd -- nplanes
;;  pd -- [npd, nplanes]
;;  rd -- [nrd, nplanes]
;;  sd -- [nsd, nplanes]
;;  std -- [nstd, nplanes]
;;  ard -- [nstd, nplanes]
;;  ard -- [nard, nplanes]
;;  sund -- nplanes
;;  od -- nplanes
;;
;;----------------------------------------------------------------------
;for i=0, ncd-1 do $
; begin
;  grim_add_descriptor, grim_data, planes[i].cd_p, cd[i], /one
;  if(keyword_set(pd)) then $
;               grim_add_descriptor, grim_data, planes[i].pd_p, pd[*,i]
;  if(keyword_set(rd)) then $
;               grim_add_descriptor, grim_data, planes[i].rd_p, rd[*,i]
;  if(keyword_set(std)) then $
;               grim_add_descriptor, grim_data, planes[i].std_p, std[*,i]
;  if(keyword_set(ard)) then $
;               grim_add_descriptor, grim_data, planes[i].ard_p, ard[*,i]
;  if(keyword_set(sd)) then $
;               grim_add_descriptor, grim_data, planes[i].sd_p, sd[*,i]
;  if(keyword_set(sund)) then $
;               grim_add_descriptor, grim_data, planes[i].sund_p, sund[i], /one
;  if(keyword_set(od)) then $
;      grim_add_descriptor, grim_data, planes[i].od_p, od[i], /one, /noregister
; end





 ;=========================================================
 ; if new instance, setup initial view
 ;=========================================================
 if(new) then $
  begin
   ;----------------------------------------------
   ; initial settings
   ;----------------------------------------------
   widget_control, grim_data.draw, /hourglass
   grim_refresh, grim_data, /default, $
	xsize=xsize, ysize=ysize, $
	xrange=planes[0].xrange, yrange=planes[0].yrange, $
	zoom=zoom, $
	rotate=rotate, $
	order=order, $
	offset=offset, /no_plot
  end $
 ;=========================================================
 ; if not new instance, just tvim with new settings
 ;=========================================================
 else $
  begin
   grim_data = grim_get_data()

   widget_control, grim_data.draw, /hourglass
   grim_refresh, grim_data, $
	default=default, previous=previous, restore=restore, $
	doffset=doffset, $
	zoom=zoom, $
	rotate=rotate, $
	order=order, $
	offset=offset, no_erase=no_erase
  end


 ;----------------------------------------------
 ; add any callbacks
 ;----------------------------------------------
 if(keyword_set(refresh_callbacks)) then $
        grim_add_refresh_callback, refresh_callbacks, refresh_callback_data_ps

 if(keyword_set(plane_callbacks)) then $
        grim_add_plane_callback, plane_callbacks, plane_callback_data_ps


 ;----------------------------------------------
 ; compute any initial overlays, except stars
 ;----------------------------------------------
 if(keyword_set(overlays)) then $
    grim_initial_overlays, grim_data, overlays, exclude='star'


 ;----------------------------------------------
 ; initial framing
 ;----------------------------------------------
 if(keyword_set(frame)) then grim_initial_framing, grim_data, frame


 ;---------------------------------------------------
 ; compute initial stars, now that framing is done
 ;---------------------------------------------------
 if(keyword_set(overlays)) then $
       grim_initial_overlays, grim_data, overlays, only='star'


 ;-------------------------
 ; save initial view
 ;-------------------------
 grim_save_initial_view, grim_data
 

 ;----------------------------------------------
 ; initial activations
 ;----------------------------------------------
 if(keyword_set(activate)) then $
  begin
   planes = grim_get_plane(grim_data, /all)
   for i=0, n_elements(planes)-1 do grim_activate_all, planes[i]
  end


 ;=========================================================
 ; if new instance, initialize cursor modes
 ;=========================================================
; if(new) then $
;  begin
;   if(keyword_set(button_extensions)) then $
;    begin
;     for i=0, n_elements(button_extensions)-1 do $
;        call_procedure, button_extensions[i]+'_init', grim_data, cursor_modes[i].data_p
;    end
;  end

 if(new) then $
     for i=0, n_elements(cursor_modes)-1 do $
        call_procedure, cursor_modes[i].name+'_init', grim_data, cursor_modes[i].data_p


 ;-------------------------
 ; draw initial image
 ;-------------------------
 grim_refresh, grim_data, no_erase=no_erase;, /no_image

end
;=============================================================================
