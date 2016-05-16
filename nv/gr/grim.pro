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

 case mode of
  'zoom' : $
    begin
     device, cursor_standard = 144
     grim_print, grim_data, 'LEFT: Zoom; RIGHT: Unzoom'
    end
  'zoom_plot' : $
    begin
     device, cursor_standard = 144
     grim_print, grim_data, 'LEFT: Zoom; RIGHT: Unzoom'
    end
  'xyzoom' : $
    begin
     grim_xyzoom_cursor, swap=swap
     grim_print, grim_data, 'LEFT: Zoom; RIGHT: Unzoom'
    end
  'pan'  : $
    begin
     device, cursor_standard = 52
     grim_print, grim_data, 'LEFT: Pan; RIGHT: Recenter'
    end
  'pan_plot'  : $
    begin
     device, cursor_standard = 52
     grim_print, grim_data, 'LEFT: Pan; RIGHT: Recenter'
    end
  'tiepoints'  : $
    begin
     grim_tiepoints_cursor, swap=swap
     grim_print, grim_data, $
         'LEFT: Add tiepoint; RIGHT: Remove tiepoint'
    end
  'curves'  : $
    begin
     grim_curves_cursor, swap=swap
     grim_print, grim_data, $
         'LEFT: Add curve; RIGHT: Remove curve'
    end
  'activate'  : $
    begin
     device, cursor_standard = 60
     grim_print, grim_data, 'LEFT: Activate; RIGHT: Deactivate'
    end
  'readout'  : $
    begin
     grim_readout_cursor, swap=swap
     grim_print, grim_data, 'LEFT: Pixel readout; RIGHT: Measure'
    end
  'mask'  : $
    begin
     device, cursor_standard = 22
     grim_print, grim_data, 'LEFT: Add pixels; RIGHT: Remove pixels'
    end
  'mag'  : $
    begin
     grim_mag_cursor, swap=swap
     grim_print, grim_data, 'LEFT: Magnify display; RIGHT: Magnify data'
    end
  'remove'  : $
    begin
     grim_remove_cursor, swap=swap
     grim_print, grim_data, 'LEFT: Delete standard overlays; RIGHT: Delete user overlays'
    end
  'trim'  : $
    begin
     grim_trim_cursor, swap=swap
     grim_print, grim_data, 'LEFT: Trim standard overlays; RIGHT: Trim user overlays'
    end
  'select'  : $
    begin
     grim_select_cursor, swap=swap
     grim_print, grim_data, 'LEFT: Select overlay points; RIGHT: Deselect overlay points'
    end
  'region'  : $
    begin
;     grim_region_cursor, swap=swap
     device, cursor_standard = 32
     grim_print, grim_data, 'LEFT: Define rectangular region; RIGHT: Define irregular region'
    end
  'smooth'  : $
    begin
     device, cursor_standard = 64
     grim_print, grim_data, 'LEFT: Square kernel; RIGHT: Rectangular kernel'
    end
  'plane'  : $
    begin
     device, cursor_standard = 59
     grim_print, grim_data, 'LEFT: Select Plane by Data; RIGHT: Select Plane by Overlay'
    end
  'move'  : $
    begin
     device, cursor_standard = 59
     grim_print, grim_data, 'LEFT: Forward; RIGHT: Backward
    end
  'rotate'  : $
    begin
     device, cursor_standard = 59
     grim_print, grim_data, 'LEFT: Select new optic axis
    end
  'spin'  : $
    begin
     device, cursor_standard = 59
     grim_print, grim_data, 'LEFT: Spin left; RIGHT: Spin right
    end
   else : $
    begin
     user_modes = *grim_data.user_modes_p
     data_p = 0
     if(keyword_set(user_modes)) then $
      begin
       names = user_modes.name
       w = where(names EQ mode)
       if(w[0] NE -1) then $
        begin
         data_p = user_modes[w].data_p
         grim_data.mode_data_p = data_p
        end
      end

     call_procedure, mode + '_mode', grim_data, data_p
    end
 endcase


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

 if(keyword_set(*plane.std_p)) then $
              pg_put_stations, plane.dd, std=*plane.std_p, od=od

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
   if(keyword_set(*plane.sund_p)) then nv_notify_unregister, *plane.sund_p, 'grim_descriptor_notify'

   nv_ptr_free, [plane.cd_p, plane.pd_p, plane.rd_p, plane.sd_p, plane.std_p, plane.sund_p, $
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
; grim_mag_erase
;
;=============================================================================
pro grim_mag_erase, grim_data, wnum
@grim_constants.common

 size_device = MAG_SIZE_DEVICE
 half_size_device = size_device/2

; x0 = grim_data.mag_last[0] - half_size_device > 0
; y0 = grim_data.mag_last[1] - half_size_device > 0

 wset, wnum
; device, copy=[0,0, size_device,size_device, x0,y0, $
 device, copy=[0,0, size_device,size_device, $
                  grim_data.mag_last_x0,grim_data.mag_last_y0, $
                                                grim_data.mag_redraw_pixmap]

 grim_mag_cursor, swap=grim_get_cursor_swap(grim_data)
end
;=============================================================================



;=============================================================================
; grim_mag_frame
;
;=============================================================================
pro grim_mag_frame
@grim_constants.common

 size_device = MAG_SIZE_DEVICE

 plots, /device, [0,size_device-1,size_device-1,0,0], $
                 [0,0,size_device-1,size_device-1,0], color=ctgreen()


end
;=============================================================================



;=============================================================================
; grim_magnify
;
;=============================================================================
pro grim_magnify, grim_data, plane, p_device, data=data
@grim_constants.common

 size_data = MAG_SIZE_DATA
 half_size_data = fix(size_data/2)


 wnum = !d.window
 xmax = !d.x_size
 ymax = !d.y_size

 wset, grim_data.mag_pixmap
 size_device = MAG_SIZE_DEVICE
 half_size_device = fix(size_device/2)

 ;--------------------------------
 ; magnify current region
 ;--------------------------------
 x0 = p_device[0] - half_size_data
 y0 = p_device[1] - half_size_data

 x0 = x0 > 0 < (xmax - size_data)
 y0 = y0 > 0 < (ymax - size_data)

 pp = [x0 + half_size_data, y0 + half_size_data]

 ;- - - - - - - - - - - - - - - - - - - - -
 ; different behavior depending on mode
 ;- - - - - - - - - - - - - - - - - - - - -
 wset, wnum
 if(keyword_set(data)) then $
  begin
   dim = dat_dim(plane.dd)

   p_data = round(convert_coord(double(p_device[0]), double(p_device[1]), /device, /to_data))
   x0 = p_data[0] - half_size_data
   y0 = p_data[1] - half_size_data

   x0 = x0 > 0 < (dim[0]-1 - size_data - 1)
   y0 = y0 > 0 < (dim[1]-1 - size_data - 1)

   x1 = x0 + size_data - 1
   y1 = y0 + size_data - 1

   region = grim_scale_image(grim_data, $
        xrange=[x0,x1], yrange=[y0,y1], top=top, no_scale=no_scale, plane=plane)

   if(grim_data.mag_last_x0 GE 0) then grim_mag_erase, grim_data, wnum

   mag_region = congrid(region, size_device, size_device)

   grim_wset, grim_data, wnum, get_info=tvd
   wset, grim_data.mag_pixmap

   erase 
   tvscl, mag_region, order=tvd.order, top=top
  end $
 else $
  begin
   if(grim_data.mag_last_x0 GE 0) then grim_mag_erase, grim_data, wnum
   region1 = congrid(tvrd(x0, y0, size_data, size_data, channel=1), size_device, size_device)
   region2 = congrid(tvrd(x0, y0, size_data, size_data, channel=2), size_device, size_device)
   region3 = congrid(tvrd(x0, y0, size_data, size_data, channel=3), size_device, size_device)

   grim_wset, grim_data, wnum, get_info=tvd
   wset, grim_data.mag_pixmap

   erase 
   tv, region1, channel=1
   tv, region2, channel=2
   tv, region3, channel=3
  end

 grim_mag_frame


 ;- - - - - - - - - - - - - - -
 ; save current region
 ;- - - - - - - - - - - - - - -
 x0 = pp[0] - half_size_device
 y0 = pp[1] - half_size_device

 x0 = x0 > 0 < (xmax - size_device)
 y0 = y0 > 0 < (ymax - size_device)
 wset, grim_data.mag_redraw_pixmap
 device, copy=[x0,y0, size_device,size_device, 0,0, wnum]


 ;- - - - - - - - - - - - - - -
 ; overlay magnified region
 ;- - - - - - - - - - - - - - -
 wset, wnum
 device, copy=[0,0, size_device,size_device, x0,y0, grim_data.mag_pixmap]

 grim_data.mag_last_x0 = x0
 grim_data.mag_last_y0 = y0
 grim_set_data, grim_data, grim_data.base

 grim_no_cursor
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
   ff = findfile(fname)
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
   ff = findfile(fname)
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

 ff = (findfile(fname))[0]
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

 ff = (findfile(fname))[0]
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

 base = grim_data.modes_base2
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
 ; render
 ;---------------------------------------------------------
 grim_set_primary, grim_data.base
 widget_control, /hourglass


 ;---------------------------------------------------------
 ; Create new plane unless the current one is a rendering
 ;  The new plane will include a transformation that allows
 ;  the rendering to appear in the correct location in the
 ;  display relative to the dat coordinate system.
 ;---------------------------------------------------------
 if(NOT plane.rendering) then $
  begin
   new_plane = grim_clone_plane(grim_data, plane=plane)
   new_plane.rendering = 1
   new_plane.dd = nv_clone(plane.dd)

   dat_set_sampling_fn, new_plane.dd, 'grim_render_sampling_fn'

   dat_set_dim_fn, new_plane.dd, 'grim_render_dim_fn'
   dat_set_dim_fn_data, new_plane.dd, dat_dim(plane.dd)

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

 dat_set_sampling_fn_data, new_plane.dd, image_pts
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
; grim_smooth
;
;=============================================================================
pro grim_smooth, grim_data, plane=plane, box

 max = 30

 data = double(dat_data(plane.dd))

 if(grim_data.type EQ 'plot') then $
  begin
   xx = data[0,*] & xx = xx[sort(xx)]

   yy = data[1,*]
   x0 = min(where(xx GE min(box[0,*])))
   x1 = max(where(xx LE max(box[0,*])))

   n = x1-x0
   if(n LT 1) then return

   result = 'Yes'
   if(n GE max) then $
       grim_message, /question, result=result, $
           ['The smoothing kernel is rather large.  Continue anyway?']
   if(result NE 'Yes') then return

   yy = smooth(yy, n)
   data[1,*] = yy
  end $
 else $
  begin
   dx = max(box[0,*]) - min(box[0,*])
   dy = max(box[1,*]) - min(box[1,*])
   nx = fix(dx)
   ny = fix(dy)
   if((nx LT 1) OR (ny LT 1)) then return

   kernel = dblarr(nx, ny)
   kernel[*] = 1d/(double(nx)*double(ny))

   n = max([nx,ny])
   result = 'Yes'
   if(n GE max) then $
       grim_message, /question, result=result, $
           ['The smoothing kernel is rather large.  Continue anyway?']
   if(result NE 'Yes') then return

   data = convol(data, kernel, /center)
  end

 dat_set_data, plane.dd, data
 
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

 nv_redo, plane.dd

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
 render_image_pts_grid = gridgen(rdim, /rec, /double)

 xx = interpol(render_image_pts_grid[0,*,0], source_image_pts_grid[0,*,0], source_image_pts_sample[0,*])
 yy = interpol(render_image_pts_grid[1,0,*], source_image_pts_grid[1,0,*], source_image_pts_sample[1,*])

 render_image_pts_sample = round([xx,yy])
 w = where((render_image_pts_sample[0,*] LT 0) $
              OR render_image_pts_sample[0,*] GE rdim[0] $)
              OR render_image_pts_sample[1,*] LT 0 $
              OR render_image_pts_sample[1,*] GE rdim[1])

 samples = xy_to_w(rdim, render_image_pts_sample)
 if(w[0] NE -1) then samples[w] = -1

 return, samples
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

 widget_control, event.id, get_uvalue=pressed
 if(NOT keyword_set(pressed)) then pressed = 0
 
 if(NOT grim_test_motion_event(event)) then grim_set_primary, grim_data.base

 ;======================================
 ; motion event 
 ;======================================
 if(struct EQ 'WIDGET_DRAW') then if(event.type EQ 2) then $
  begin
   ;------------------------
   ; print x, y, dn
   ;------------------------
   p = (convert_coord(double(event.x), double(event.y), /device, /to_data))[0:1]
   xx = str_pad(strtrim(p[0],2), 6)
   yy = str_pad(strtrim(p[1],2), 6)

   dn = ''
   dim = dat_dim(plane.dd)
   if(n_elements(dim) EQ 1) then dim = [dim, 1]

   if(grim_data.type EQ 'plot') then $
    begin
     if((p[0] GE 0) AND (p[0] LT dim[1])) then $
                               dn = dat_data(plane.dd, sample=[1,p[0]], /nd)
    end $
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

   ;---------------------------------------------
   ; erase / redraw guidelines
   ;---------------------------------------------
   if(grim_data.guideline_flag) then $
    begin
     grim_erase_guideline, grim_data
     grim_draw_guideline, grim_data, event.x, event.y
    end
  end

 ;===================================
 ; switch on event structure type
 ;===================================
 case struct of
  ;-------------------------------------------------------
  ; draw widget event -- check which button pressed
  ;-------------------------------------------------------
  'WIDGET_DRAW' : $
   case event.type of
    ;- - - - - - - - -
    ; button release  
    ;- - - - - - - - -
    1 : $						; button released
      begin
       grim_set_tracking, grim_data
       pressed = 0
       case grim_data.mode of 
        ;- - - - - - - - 
        ; readout mode  
        ;- - - - - - - - 
        'readout' : $
           case event.release of
            1 : $
               begin
                grim_wset, grim_data, input_wnum
                p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                grim_wset, grim_data, output_wnum
                grim_place_readout_mark, grim_data, p[0:1]
                grim_draw, grim_data, /readout
               end
            else : 
           endcase
        ;- - - - - - - - 
        ; mag mode  
        ;- - - - - - - - 
        'mag' : $
	  begin
	    if((input_wnum EQ grim_data.wnum) AND $
                   (event.release EQ 1) OR (event.release EQ 4)) then $
	     begin
	      grim_mag_erase, grim_data, !d.window
	      grim_data.mag_last_x0 = -1
	      grim_set_data, grim_data, grim_data.base
	    end
	  end
        'zoom' : 	
        'zoom_plot' : 	
        'xyzoom' : 	
        'pan' : 	
        'pan_plot' : 	
        'tiepoints' : 	
        'mask' : 	
        'curves' : 	
        'activate' : 	
        'remove' : 	
        'trim' : 	
        'select' : 	
        'region' : 	
        'smooth' : 
	'plane' :	
	'move' :	
	'rotate' :	
	'spin' :	
       ;- - - - - - - - - - - - - - - - - - - - - -
       ; unrecognized mode, assume user-defined  
       ;- - - - - - - - - - - - - - - - - - - - - -
       else : $
	begin
	 data = 0
	 if(keyword_set(grim_data.mode_data_p)) then data = *grim_data.mode_data_p
	 call_procedure, grim_data.mode + '_mouse_event', event, data
	end
       endcase	
      end
    ;- - - - - - - - - - - - - - - - -
    ; scroll wheel -- 6.4 and later 
    ;- - - - - - - - - - - - - - - - -
    7 : $
      begin
       dm = - event.clicks
       grim_increment_mode, grim_data, dm
       grim_set_data, grim_data, event.top
      end

    ;- - - - - - - - 
    ; button press  
    ;- - - - - - - - 
    0 : $						; button pressed
      begin
       pressed = event.press
       ;- - - - - - - - - - - - - - - - - - - - - - 
       ; wheel cycles through modes -- pre-6.4
       ;- - - - - - - - - - - - - - - - - - - - - - 
       if(pressed EQ 16) then $
        begin
         grim_increment_mode, grim_data, 1

;         modes = grim_modes_list(grim_data)
;         nmodes = n_elements(modes)
;         w = where(modes EQ grim_data.mode)
;         ww = (w + 1) mod nmodes
;         grim_set_mode, grim_data, modes[ww[0]], /new
         grim_set_data, grim_data, event.top
        end $
       else if(pressed EQ 8) then $
        begin
         grim_increment_mode, grim_data, -1

;         modes = grim_modes_list(grim_data)
;         nmodes = n_elements(modes)
;         w = where(modes EQ grim_data.mode)
;         ww = (w - 1)
;         if(ww[0] LT 0) then ww = ww + nmodes 
;         ww = ww mod nmodes
;         grim_set_mode, grim_data, modes[ww[0]], /new
         grim_set_data, grim_data, event.top
        end $
       ;- - - - - - - - - - - - - - - - - - - - - - 
       ; middle button pans
       ;- - - - - - - - - - - - - - - - - - - - - - 
       else if(pressed EQ 2) then $
        begin
         if(grim_data.type EQ 'plot') then $
          begin
           xx = convert_coord(/data, /to_device,$
                      [transpose(double(plane.xrange)), transpose(double(plane.yrange))])
           edge = [xx[0]+2, !d.x_size-xx[3]-1, xx[1]+2, !d.y_size-xx[4]-1]
           tvpan, wnum=input_wnum, /notvim, edge=edge, $
                            p0=[event.x,event.y], cursor=60, hour=event.id, $
                            output=output_wnum, col=ctred(), doffset=doffset
           grim_wset, grim_data, output_wnum
           grim_refresh, grim_data, doffset=doffset
          end $
         else $
          begin
           tvpan, wnum=input_wnum, /noplot, edge=3, $
                            p0=[event.x,event.y], cursor=60, hour=event.id, $
                            output=output_wnum, col=ctred()
           grim_wset, grim_data, output_wnum
           grim_refresh, grim_data
          end 
         grim_set_mode, grim_data
         pressed = 0
        end $
       ;- - - - - - - - - - - - - - - - - - - - - - 
       ; right and left buttons depend on mode
       ;- - - - - - - - - - - - - - - - - - - - - - 
       else $
        case grim_data.mode of 
        ;- - - - - - - - 
        ; zoom mode  
        ;- - - - - - - - 
         'zoom' : $	
           begin
            minbox = 5
            aspect = double(!d.y_size)/double(!d.x_size)
            case event.press of
             1 : $
                begin
                 tvzoom, [1], input_wnum, /noplot, $
                          p0=[event.x,event.y], cursor=78, hour=event.id, $
                          output=output_wnum, minbox=minbox, aspect=aspect, $ 
                          color=ctred()
                 grim_wset, grim_data, output_wnum
                 grim_refresh, grim_data
                 grim_set_mode, grim_data, 'zoom'
                 pressed = 0
                end
             4 : $
                begin
                  tvunzoom, [1], input_wnum, /noplot, $
                             p0=[event.x,event.y], cursor=78, hour=event.id, $
                             output=output_wnum, minbox=minbox, aspect=aspect, $
	                     color=ctred()
                 grim_wset, grim_data, output_wnum
                 grim_refresh, grim_data
                 grim_set_mode, grim_data, 'zoom'
                 pressed = 0
                 end
	     else : 
            endcase
           end
        ;- - - - - - - - 
        ; zoom_plot mode  
        ;- - - - - - - - 
         'zoom_plot' : $	
           begin
            minbox = 5
            case event.press of
             1 : $
               begin
                tvgr, input_wnum
                box = tvrec(p0=[event.x, event.y], color=ctred())
                xx = box[0,*] & yy = box[1,*]
                pq = convert_coord(/device, /to_data, double(xx), double(yy))
                xrange = [min(pq[0,*]), max(pq[0,*])]
                yrange = [min(pq[1,*]), max(pq[1,*])]
                tvgr, output_wnum
                grim_refresh, grim_data, xrange=xrange, yrange=yrange
                grim_set_mode, grim_data, 'zoom_plot'
                pressed = 0
               end
             4 : $
               begin
                tvgr, input_wnum, get_info=tvd
                box = tvrec(p0=[event.x, event.y], color=ctred())
                xx = box[0,*] & yy = box[1,*]
                pq = convert_coord(/device, /to_data, double(xx), double(yy))

                box_xrange=[min(pq[0,*]), max(pq[0,*])]
                box_yrange=[min(pq[1,*]), max(pq[1,*])]

                imx = tvd.position[[0,2]]
                imy = tvd.position[[1,3]]
                corners = convert_coord(double(imx), double(imy), /norm, /to_data)
                old_xrange = corners[0,*] &  old_yrange = corners[1,*]            

                xratio = (old_xrange[1]-old_xrange[0]) / $
                                            (box_xrange[1]-box_xrange[0])
                yratio = (old_yrange[1]-old_yrange[0]) / $
                                            (box_yrange[1]-box_yrange[0])

                xrange = [old_xrange - (box_xrange-old_xrange)*xratio]
                yrange = [old_yrange - (box_yrange-old_yrange)*yratio]

                tvgr, output_wnum

                grim_refresh, grim_data, xrange=xrange, yrange=yrange
                grim_set_mode, grim_data, 'zoom_plot'
                pressed = 0
               end
	     else : 
            endcase
           end
        ;- - - - - - - - 
        ; xyzoom mode  
        ;- - - - - - - - 
         'xyzoom' : $	
           begin
            minbox = 5
            case event.press of
             1 : $
                begin
                 tvzoom, [1], input_wnum, /noplot, $
                          p0=[event.x,event.y], cursor=78, hour=event.id, $
                          output=output_wnum, minbox=minbox, $ 
                          color=ctred(), /xy
                 grim_wset, grim_data, output_wnum
                 grim_refresh, grim_data
                 grim_set_mode, grim_data, 'xyzoom'
                 pressed = 0
                end
             4 : $
                begin
                  tvunzoom, [1], input_wnum, /noplot, $
                             p0=[event.x,event.y], cursor=78, hour=event.id, $
                             output=output_wnum, minbox=minbox, $
	                     color=ctred(), /xy
                 grim_wset, grim_data, output_wnum
                 grim_refresh, grim_data
                 grim_set_mode, grim_data, 'xyzoom'
                 pressed = 0
                 end
	     else : 
            endcase
           end
        ;- - - - - - - - 
        ; pan mode  
        ;- - - - - - - - 
         'pan' : $	
            case event.press of
             1 : $
                begin
                 tvmove, [1], input_wnum, /noplot, $
                            p0=[event.x,event.y], cursor=60, hour=event.id, $
                            output=output_wnum, col=ctred()
                 grim_wset, grim_data, output_wnum
                 grim_refresh, grim_data
                 grim_set_mode, grim_data, 'pan'
                 pressed = 0
                end
             4 : $
                begin
                 grim_wset, grim_data, input_wnum
                 p = convert_coord(double(event.x), double(event.y), /device, /to_data)

                 grim_wset, grim_data, output_wnum
                 grim_recenter, grim_data, p

                 grim_set_mode, grim_data, 'pan'
                 pressed = 0
                end
	     else : 
            endcase
        ;- - - - - - - - 
        ; plane mode  
        ;- - - - - - - - 
         'plane' : $
            case event.press of
             1 : $
                begin
                 grim_wset, grim_data, input_wnum
		 if(grim_data.n_planes GT 1) then $
		  begin
                   xy = convert_coord(double(event.x), double(event.y), /device, /to_data)
                   grim_wset, grim_data, output_wnum
                   jplane = grim_get_plane_by_xy(grim_data, xy)
                   grim_jump_to_plane, grim_data, jplane.pn
                   grim_refresh, grim_data, /use_pixmap, /noglass
		  end
                 grim_set_mode, grim_data, 'plane'
                 pressed = 0
                end
             4 : $
                begin
;                 grim_set_mode, grim_data, 'plane'
;                 pressed = 0
               end
	     else : 
            endcase
        ;- - - - - - - - 
        ; readout mode  
        ;- - - - - - - - 
        'readout' : $
           case event.press of
            4 : $
               begin
                widget_control, grim_data.draw, draw_motion_events=1
                grim_wset, grim_data, input_wnum
                grim_data.readout_top = $
                  grim_pixel_readout(grim_data.readout_top, text=text, grnum=grim_data.grnum)
                grim_data.readout_text = text
                grim_set_data, grim_data, event.top

                p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                planes = grim_get_plane(grim_data);, /visible)
                pg_measure, planes.dd, xy=p[0:1], p=pp, /silent, fn=*grim_data.readout_fns_p, $
                  gd={cd:*plane.cd_p, gbx:*plane.pd_p, dkx:*plane.rd_p, $
                      sund:*plane.sund_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, string=string 
                sep = str_pad('', 80, c='-')
                widget_control, grim_data.readout_text, get_value=ss    
                widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
                grim_wset, grim_data, output_wnum



                grim_wset, grim_data, output_wnum
                grim_place_measure_mark, grim_data, pp
;                grim_draw, grim_data, /measure
                grim_refresh, grim_data, /use_pixmap
               end
            else : 
           endcase
        ;- - - - - - - - 
        ; move mode  
        ;- - - - - - - - 
         'move' : $
            case event.press of
             1 : $
                begin
                 xy = (convert_coord(double(event.x), double(event.y), /device, /to_data))[0:1]
		 v = image_to_inertial(*plane.cd_p, xy)
		 pg_repos, bx=*plane.cd_p, v*1d8		;; 1d8 temporary
                 grim_set_mode, grim_data, 'move'
                 pressed = 0
                end
             4 : $
                begin
                 xy = (convert_coord(double(event.x), double(event.y), /device, /to_data))[0:1]
		 v = image_to_inertial(*plane.cd_p, xy)
		 pg_repos, bx=*plane.cd_p, -v*1d8		;; 1d8 temporary
                 grim_set_mode, grim_data, 'move'
                 pressed = 0
               end
	     else : 
            endcase
        ;- - - - - - - - 
        ; rotate mode  
        ;- - - - - - - - 
         'rotate' : $
            case event.press of
             1 : $
                begin
                 xy = (convert_coord(double(event.x), double(event.y), /device, /to_data))[0:1]
		 v = image_to_inertial(*plane.cd_p, xy)
		 pg_retarg, cd=*plane.cd_p, v, /toward
                 grim_set_mode, grim_data, 'rotate'
                 pressed = 0
                end
             4 : $
                begin
;                 grim_set_mode, grim_data, 'rotate'
;                 pressed = 0
               end
	     else : 
            endcase
        ;- - - - - - - - 
        ; spin mode  
        ;- - - - - - - - 
         'spin' : $
            case event.press of
             1 : $
                begin
                 grim_set_mode, grim_data, 'spin'
                 pressed = 0
                end
             4 : $
                begin
;                 grim_set_mode, grim_data, 'spin'
;                 pressed = 0
               end
	     else : 
            endcase
        ;- - - - - - - - - -
        ; pan mode (plots) 
        ;- - - - - - - - - -
         'pan_plot' : $	
            case event.press of
             1 : $
               begin
                tvgr, input_wnum
                ln = tvline(p0=[event.x, event.y], col=ctred())
                line = convert_coord(double(ln[0,*]), double(ln[1,*]), /device, /to_data)
                dx = line[0,0]-line[0,1]
                dy = line[1,0]-line[1,1]

                tvgr, output_wnum
                grim_refresh, grim_data, dx=dx, dy=dy
                grim_set_mode, grim_data, 'pan_plot'
                pressed = 0
               end
             4 : $
               begin
                tvgr, input_wnum
                p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                tvgr, output_wnum
                cx = !d.x_size/2
                cy = !d.y_size/2
                q = convert_coord(double(cx), double(cy), /device, /to_data)
                grim_refresh, grim_data, dx=p[0]-q[0], dy=p[1]-q[1]
                grim_set_mode, grim_data, 'pan_plot'
                pressed = 0
               end
	     else : 
            endcase
        ;- - - - - - - - 
        ; tiepoint mode  
        ;- - - - - - - - 
         'tiepoints' : $	
            case event.press of
             1 : $
                begin
                 grim_wset, grim_data, input_wnum
	         p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                 grim_wset, grim_data, output_wnum
	         grim_add_tiepoint, grim_data, p[0:1]
                 grim_draw, grim_data, /tiepoints, /nopoints
                 pressed = 0
               end
             4 : $
                begin
                 grim_wset, grim_data, input_wnum
	         p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                 grim_wset, grim_data, output_wnum
                 grim_rm_tiepoint, grim_data, p[0:1];, pp=pp
;                 if(keyword_set(pp)) then $
;                  begin
; 	           pp = convert_coord(pp[0,*], pp[1,*], /data, /to_device)
;                   grim_display, grim_data, /use_pixmap, $
;		       pixmap_box_center=[pp[0],pp[1]], pixmap_box_side=30
;                   grim_draw, grim_data, /tiepoints, /nopoints
                   grim_refresh, grim_data, /use_pixmap
;                  end
                 pressed = 0
                end
             else : 
            endcase
        ;- - - - - - - - 
        ; mask mode  
        ;- - - - - - - - 
         'mask' : $	
            case event.press of
             1 : $
                begin
                 grim_wset, grim_data, input_wnum
	         p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                 grim_wset, grim_data, output_wnum
	         grim_add_mask, grim_data, p[0:1]
                 grim_draw, grim_data, /mask, /nopoints
                 pressed = 0
               end
             4 : $
                begin
                 grim_wset, grim_data, input_wnum
	         p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                 grim_wset, grim_data, output_wnum
                 grim_rm_mask, grim_data, p[0:1], pp=pp
;                 if(keyword_set(pp)) then $
;                  begin
; 	           pp = convert_coord(pp[0,*], pp[1,*], /data, /to_device)
;                   grim_display, grim_data, /use_pixmap, $
;		       pixmap_box_center=[pp[0],pp[1]], pixmap_box_side=30
;                   grim_draw, grim_data, /mask, /nopoints
                   grim_refresh, grim_data, /use_pixmap
;                  end
                 pressed = 0
                end
             else : 
            endcase
        ;- - - - - - - - 
        ; curve mode  
        ;- - - - - - - - 
         'curves' : $	
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
		 p = pg_select_region(0, /points, /data, $
                            p0=[event.x,event.y], $
	                    /autoclose, /noclose, /noverbose, color=ctgreen(), $
                            cancel_button=2, select_button=1)
               grim_add_curve, grim_data, p
               grim_draw, grim_data, /curves, /nopoints
                 pressed = 0
                end
              4 : $
                begin
                 grim_wset, grim_data, input_wnum
	         p = convert_coord(double(event.x), double(event.y), /device, /to_data)
                 grim_wset, grim_data, output_wnum
                 grim_rm_curve, grim_data, p[0:1]
                 grim_refresh, grim_data, /use_pixmap
                 pressed = 0
                end
	      else : 
             endcase
        ;- - - - - - - - - - - - - - - - 
        ; activate/deactivate mode  
        ;- - - - - - - - - - - - - - - -
         'activate' : $	
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
                 grim_activate_select, $
                     plane, [event.x, event.y], clicks=event.clicks, ptd=ptd
                 grim_refresh, grim_data, /noglass;, /no_image, /update
                 pressed = 0
                end
              4 : $
                begin
                 grim_activate_select, $
                    plane, [event.x, event.y], /deactivate, clicks=event.clicks, ptd=ptd
                 grim_refresh, grim_data, /noglass;, /no_image, /update
                 pressed = 0
                end
	      else : 
             endcase
        ;- - - - - - - - - - - - - - - - 
        ; remove mode  
        ;- - - - - - - - - - - - - - - -
         'remove' : $	
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
                 grim_flash, [event.x, event.y]
                 grim_remove_overlays, plane, [event.x, event.y], $
                                           clicks=event.clicks, stat=stat
                 if(stat NE -1) then grim_refresh, grim_data, /use_pixmap, /noglass
                 pressed = 0
                end
              4 : $
                begin
                 grim_flash, [event.x, event.y]
                 grim_remove_overlays, plane, /user, [event.x, event.y], $
                                               clicks=event.clicks, stat=stat
                 if(stat NE -1) then grim_refresh, grim_data, /use_pixmap, /noglass
                 pressed = 0
                end
	      else : 
             endcase
        ;- - - - - - - - - - - - - - - - 
        ; trim mode  
        ;- - - - - - - - - - - - - - - -
         'trim' : $	
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
		 region = pg_select_region(0, $
                            p0=[event.x,event.y], $
	                    /autoclose, /noverbose, color=ctred(), $
                            cancel_button=2, end_button=-1, select_button=1)
                 grim_trim_overlays, grim_data, plane=plane, region
                 grim_refresh, grim_data, /use_pixmap
                 pressed = 0
                end
              4 : $
                begin
		 region = pg_select_region(0, $
                            p0=[event.x,event.y], $
	                    /autoclose, /noverbose, color=ctpurple(), $
                            cancel_button=2, end_button=-1, select_button=4)
                 grim_trim_user_overlays, grim_data, plane=plane, region
                 grim_refresh, grim_data, /use_pixmap
                 pressed = 0
                end
	      else : 
             endcase
        ;- - - - - - - - - - - - - - - - 
        ; select mode  
        ;- - - - - - - - - - - - - - - -
         'select' : $	
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
		 region = pg_select_region(0, $
                            p0=[event.x,event.y], $
	                    /autoclose, /noverbose, color=ctred(), $
                            cancel_button=2, end_button=-1, select_button=1)
                 grim_select_overlay_points, grim_data, plane=plane, region
                 grim_refresh, grim_data, /use_pixmap
;                 grim_refresh, grim_data, /no_image
                 pressed = 0
                end
              4 : $
                begin
		 region = pg_select_region(0, $
                            p0=[event.x,event.y], $
	                    /autoclose, /noverbose, color=ctpurple(), $
                            cancel_button=2, end_button=-1, select_button=4)
                 grim_select_overlay_points, grim_data, plane=plane, region, /deselect
                 grim_refresh, grim_data, /use_pixmap
;                 grim_refresh, grim_data, /no_image
                 pressed = 0
                end
	      else : 
             endcase
        ;- - - - - - - - - - - - - - - - 
        ; region mode  
        ;- - - - - - - - - - - - - - - -
         'region' : $	
           begin
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
		 roi = pg_select_region(/box, 0, $
                            p0=[event.x,event.y], $
	                    /noverbose, color=ctblue(), image_pts=p)
                 xx = p[0,*] & yy = p[1,*]
                 pp = convert_coord(/device, /to_data, double(xx), double(yy))
                 grim_set_roi, grim_data, roi, pp[0:1,*]
                 grim_refresh, grim_data, /use_pixmap
                 pressed = 0
                end
              4 : $
                begin
		 roi = pg_select_region(0, $
                            p0=[event.x,event.y], $
	                    /autoclose, /noverbose, color=ctblue(), $
                            cancel_button=2, end_button=-1, select_button=4, $
                            image_pts=p)
                 xx = p[0,*] & yy = p[1,*]
                 pp = convert_coord(/device, /to_data, double(xx), double(yy))
                 grim_set_roi, grim_data, roi, pp[0:1,*]
                 grim_refresh, grim_data, /use_pixmap
                 pressed = 0
                end
	      else : 
             endcase
           end
        ;- - - - - - - - - - - - - - - - 
        ; smooth mode  
        ;- - - - - - - - - - - - - - - -
         'smooth' : $	
            if(input_wnum EQ grim_data.wnum) then $
             case event.press of
              1 : $
                begin
                 _box = tvrec(p0=[event.x, event.y], color=ctyellow(), aspect=1)
                 xx = _box[0,*] & yy = _box[1,*]
                 box = convert_coord(/device, /to_data, double(xx), double(yy))
		 widget_control, /hourglass
		 grim_smooth, grim_data, plane=plane, box
                 pressed = 0
                end
              4 : $
                begin
                 _box = tvrec(p0=[event.x, event.y], color=ctyellow())
                 xx = _box[0,*] & yy = _box[1,*]
                 box = convert_coord(/device, /to_data, double(xx), double(yy))
		 widget_control, /hourglass
		 grim_smooth, grim_data, plane=plane, box
                 pressed = 0
                end
	      else : 
             endcase
         'readout' : 
         'mask' : 
         'plane' : 
         'move' : 
         'rotate' : 
         'spin' : 
         'mag' : 
        ;- - - - - - - - - - - - - - - - - - - - - -
        ; unrecognized mode, assume user-defined  
        ;- - - - - - - - - - - - - - - - - - - - - -
         else : $
	  begin
	   data = 0
	   if(keyword_set(grim_data.mode_data_p)) then data = *grim_data.mode_data_p
	   call_procedure, grim_data.mode + '_mouse_event', event, data
	  end
        endcase 
      end
    else : 
   endcase

  ;--------------------------------------------------------------------------
  ; tracking event -- make sure cursor reflects correct mode for this window
  ;--------------------------------------------------------------------------
  'WIDGET_TRACKING': $
    if(event.enter) then $
     begin
      grim_set_mode, grim_data
     end
  else : 
 endcase


 ;======================
 ; motion modes 
 ;======================
 if((pressed NE 0) AND (struct NE 'WIDGET_TRACKING')) then $
  begin
   case grim_data.mode of 
    ;- - - - - - - - - - - - - - - - 
    ; pixel readout mode  
    ;- - - - - - - - - - - - - - - -
    'readout' : $	
       case pressed of
        1 : $
           begin
	    widget_control, grim_data.draw, draw_motion_events=1
            grim_wset, grim_data, input_wnum
	    grim_data.readout_top = $
	    grim_pixel_readout(grim_data.readout_top, text=text, grnum=grim_data.grnum)
	    grim_data.readout_text = text
	    grim_set_data, grim_data, event.top

            p = convert_coord(double(event.x), double(event.y), /device, /to_data)
	    planes = grim_get_plane(grim_data);, /visible)
            pg_cursor, planes.dd, xy=p[0:1], /silent, fn=*grim_data.readout_fns_p, $
              gd={cd:*plane.cd_p, gbx:*plane.pd_p, dkx:*plane.rd_p, $
                    sund:*plane.sund_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, /photom, string=string 
            sep = str_pad('', 80, c='-')
            widget_control, grim_data.readout_text, get_value=ss    
            widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
            grim_wset, grim_data, output_wnum
           end
        4 : $
           begin
            end
       else : 
       endcase
    ;- - - - - - - - - - - - - - - - 
    ; magnify mode  
    ;- - - - - - - - - - - - - - - -
    'mag' : $	
       case pressed of
        1 : $
           begin
	    widget_control, grim_data.draw, draw_motion_events=1
	    if(input_wnum EQ grim_data.wnum) then $
	     begin
              grim_wset, grim_data, input_wnum
	      grim_magnify, grim_data, plane, [event.x, event.y]
	     end
           end
        4 : $
           begin
	    widget_control, grim_data.draw, draw_motion_events=1
	    if(input_wnum EQ grim_data.wnum) then $
	     begin
              grim_wset, grim_data, input_wnum
	      grim_magnify, /data, grim_data, plane, [event.x, event.y]
 	     end
          end
        else : 
       endcase
    'mask' : 	
    'zoom' : 	
    'zoom_plot' : 	
    'xyzoom' : 	
    'pan' : 	
    'pan_plot' : 	
    'tiepoints' : 	
    'curves' : 	
    'activate' : 	
    'remove' : 	
    'trim' : 	
    'select' : 	
    'region' : 	
    'smooth' : 	
    'plane' :
    'move' :
    'rotate' :
    'spin' :
   ;- - - - - - - - - - - - - - - - - - - - - -
   ; unrecognized mode, assume user-defined  
   ;- - - - - - - - - - - - - - - - - - - - - -
    else : $
     begin
      data = 0
      if(keyword_set(grim_data.mode_data_p)) then data = *grim_data.mode_data_p
      call_procedure, grim_data.mode + '_mouse_event', event, data, /motion
     end
   endcase 
  end


 grim_wset, grim_data, grim_data.wnum
 widget_control, event.id, set_uvalue=pressed

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
 grim_write_indexed_arrays, grim_data, plane, 'TIE', fname=fname
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
 grim_load_descriptors, grim_data, class='camera', plane=plane, idp_cam=idp_cam
 if(NOT keyword_set(idp_cam[0])) then return 


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
 pg_coregister, dd, cd=cd, bx=bx



; grim_refresh, grim_data
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

 for i=0, n-1 do if(i NE pn) then $
       grim_copy_mask, grim_data, plane, planes[i]

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
 grim_data.tie_syncing = 1 - grim_data.tie_syncing
 grim_set_data, grim_data, event.top
 
; grim_sync_tiepoints, grim_data
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

 grim_load_descriptors, grim_data, class='camera', plane=plane, idp_cam=idp_cam
 if(NOT keyword_set(idp_cam[0])) then return 
 grim_load_descriptors, grim_data, class='planet', plane=plane, idp_plt=idp_plt
 if(NOT keyword_set(idp_plt[0])) then return

 cd = (*plane.cd_p)[0]
 if(NOT keyword_set(cd)) then $
  begin
   grim_message, 'No camera descriptor!'
   return
  end

 pd = get_primary(cd, *plane.pd_p)
 name = cor_name(pd)

 tie_pts = reform(tie_pts, 2, 1, npts, /over)

 dkd = make_array(npts, $
           val=orb_construct_descriptor(pd, sma=1d8, GG=const_G))
 for i=0, npts-1 do $ 
   dkd[i] = image_to_orbit(cd, pd, dkd[i], tie_pts[*,0,i], GG=const_G)
;orb_set_ma, dkd, orb_anom_to_lon(dkd, orb_get_ma(dkd), pd)
; for i=0, npts-1 do orb_print_elements_mks, dkd[i], pd

 for i=0, nplanes-1 do $
  if(planes[i].pn NE pn) then $
   begin
    grim_load_descriptors, grim_data, class='camera', plane=planes[i]
    cdi = (*planes[i].cd_p)[0]
    if(keyword_set(cdi)) then $
     begin
      grim_load_descriptors, grim_data, class='planet', plane=planes[i]
      w = where(cor_name(*planes[i].pd_p) EQ name)
      if(w[0] NE -1) then $
       begin
        pdi = (*planes[i].pd_p)[w[0]]

        dt = bod_time(pdi) - bod_time(pd)
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
;	grim_menu_view_frame_active_event
;
;
; PURPOSE:
;	Modifies view settings so as to display the active overlays. 
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
pro grim_menu_view_frame_active_help_event, event
 text = ''
 nv_help, 'grim_menu_view_frame_active_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_view_frame_active_event, event

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, grim_data.draw, /hourglass

 ptd = grim_get_all_active_overlays(grim_data, plane=plane)
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
;	grim_menu_points_shadows_event
;
;
; PURPOSE:
;	Obtains the necessary descriptors through the translators and computes
;	shadows of the currently active overlay points on all other objects. 
;	Note that you may have todisable overlay hiding in order to compute
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
;	grim_menu_points_fill_limbs_event
;
;
; PURPOSE:
;	Fills active planet disks with a translucent color.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2007
;	
;-
;=============================================================================
pro grim_menu_points_fill_limbs_help_event, event
 text = ''
 nv_help, 'grim_menu_points_limbs_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_fill_limbs_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute limbs
 ;------------------------------------------------
 grim_overlay, grim_data, 'limb_fill'

 ;------------------------------------------------
 ; draw fills
 ;------------------------------------------------
; grim_draw, grim_data, /limb
 grim_refresh, grim_data, /use_pixmap


end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_menu_points_fill_rings_event
;
;
; PURPOSE:
;	Fills active rings with a translucent color.
;
;
; CATEGORY:
;	NV/GR
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2007
;	
;-
;=============================================================================
pro grim_menu_points_fill_rings_help_event, event
 text = ''
 nv_help, 'grim_menu_points_rings_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_menu_points_fill_rings_event, event

 grim_data = grim_get_data(event.top)
 widget_control, grim_data.draw, /hourglass

 ;------------------------------------------------
 ; load descriptors and compute rings
 ;------------------------------------------------
 grim_overlay, grim_data, 'ring_fill'

 ;------------------------------------------------
 ; draw fills
 ;------------------------------------------------
; grim_draw, grim_data, /limb
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
;+
; NAME:
;	grim_zoom_mode_event
;
;
; PURPOSE:
;	Selects the zoom cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	The image zoom and offset are controlled by selecting
;	a box in the image.  When the box is created using the
;	left mouse button, zoom and offset are changed so that 
;	the contents of the box best fill the current graphics
;	window.  When the right button is used, the contents of
;	the current graphics window are shrunken so as to best
;	fill the box.  In other words, the left button zooms in
;	and the right button zooms out.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_zoom_mode_help_event, event
 text = ''
 nv_help, 'grim_zoom_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_zoom_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Zoom in/out'
   return
  end

 grim_set_mode, grim_data, 'zoom', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_zoom_plot_mode_event
;
;
; PURPOSE:
;	Selects the plot zoom cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	The image zoom and offset are controlled by selecting
;	a box in the image.  When the box is created using the
;	left mouse button, zoom and offset are changed so that 
;	the contents of the box best fill the current graphics
;	window.  When the right button is used, the contents of
;	the current graphics window are shrunken so as to best
;	fill the box.  In other words, the left button zooms in
;	and the right button zooms out.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_zoom_mode_plot_help_event, event
 text = ''
 nv_help, 'grim_zoom_plot_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_zoom_plot_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Zoom in/out'
   return
  end

 grim_set_mode, grim_data, 'zoom_plot', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_xyzoom_mode_event
;
;
; PURPOSE:
;	Selects the xy-zoom cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Same as 'zoom' mode, except the aspect ratio is set by the 
;	proportions of the selected box.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2005
;	
;-
;=============================================================================
pro grim_xyzoom_mode_help_event, event
 text = ''
 nv_help, 'grim_xyzoom_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_xyzoom_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'XY Zoom in/out'
   return
  end

 grim_set_mode, grim_data, 'xyzoom', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_pan_mode_event
;
;
; PURPOSE:
;	Selects the pan cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	The image offset is controlled by selecting an offset vector
;	using the left mouse button, or the middle button may be
;	used to center the image on a selected point.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_pan_mode_help_event, event
 text = ''
 nv_help, 'grim_pan_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_pan_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Recenter image'
   return
  end

 grim_set_mode, grim_data, 'pan', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_pan_plot_mode_event
;
;
; PURPOSE:
;	Selects the plot pan cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	The image offset is controlled by selecting an offset vector
;	using the left mouse button, or the middle button may be
;	used to center the image on a selected point.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_pan_plot_mode_help_event, event
 text = ''
 nv_help, 'grim_pan_plot_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_pan_plot_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Recenter plot'
   return
  end

 grim_set_mode, grim_data, 'pan_plot', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_tiepoints_mode_event
;
;
; PURPOSE:
;	Selects the tiepoints cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Tiepoints are added using the left mouse button and deleted 
;	using the right button.  Tiepoints appear as crosses labeled 
;	by numbers.  The use of tiepoints is determined by the 
;	particular option selected by the user.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_tiepoints_mode_help_event, event
 text = ''
 nv_help, 'grim_tiepoints_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_tiepoints_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Add/Delete tiepoints'
   return
  end

 grim_set_mode, grim_data, 'tiepoints', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_curves_mode_event
;
;
; PURPOSE:
;	Selects the curves cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	curves are added using the left mouse button and deleted 
;	using the right button.  
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
pro grim_curves_mode_help_event, event
 text = ''
 nv_help, 'grim_curves_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_curves_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Add/Delete curves'
   return
  end

 grim_set_mode, grim_data, 'curves', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_activate_mode_event
;
;
; PURPOSE:
;	Selects the activate cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
; 	Overlay objects may be activated or deactivated by clicking 
;	and/or dragging using the left or right mouse buttons 
;	respectively.  This activation mechanism allows the user to 
;	select which among a certain type of objects should be used 
;	in a given menu selection.  A left click on an overlay
;	activates that overlay and a right click deactivates it.  A 
;	double click activates or deactivates all overlays associated 
;	with a given descriptor, or all stars.  Active overlays appear 
;	in the colors selected in the 'Overlay Settings' menu selection.  
;	Inactive overlays appear in cyan.  A descriptor is active
;	whenever any of its overlays are active.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_activate_mode_help_event, event
 text = ''
 nv_help, 'grim_activate_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_activate_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then $
       grim_print, grim_data, 'Activate/Deactivate overlays and objects'
   return
  end

 grim_set_mode, grim_data, 'activate', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_readout_mode_event
;
;
; PURPOSE:
;	Selects the readout cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	A text window appears and displays data about the pixel selected 
;	using the left mouse button.  The amount and type of information
;	displayed depends on which descriptors are loaded.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_readout_mode_help_event, event
 text = ''
 nv_help, 'grim_readout_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_readout_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Display pixel data'
   return
  end

 grim_set_mode, grim_data, 'readout', /new

 grim_data.readout_top = $
   grim_pixel_readout(grim_data.readout_top, text=text, grnum=grim_data.grnum)
 grim_data.readout_text = text

 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_mask_mode_event
;
;
; PURPOSE:
;	Selects the mask cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Allowqs the user to select pixel to include in the mask.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro grim_mask_mode_help_event, event
 text = ''
 nv_help, 'grim_mask_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_mask_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Mask pixels'
   return
  end

 grim_set_mode, grim_data, 'mask', /new

 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_plane_mode_event
;
;
; PURPOSE:
;	Selects the plane cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Planes can be selected by clicking in the image window.  This option
;	is not useful unless planes other than the current plane are visible.
;	If more than one plane under the cursor contains data, the one with
;	the lowest plane number is selected, unless one of them is the current
;	plane.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2008
;	
;-
;=============================================================================
pro grim_plane_mode_help_event, event
 text = ''
 nv_help, 'grim_plane_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_plane_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Change plane'
   return
  end

 grim_set_mode, grim_data, 'plane', /new

 
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_move_mode_event
;
;
; PURPOSE:
;	Selects the move cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Translates the camera forward or backward along the optic axis 
;	direction.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2009
;	
;-
;=============================================================================
pro grim_move_mode_help_event, event
 text = ''
 nv_help, 'grim_move_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_move_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Move camera'
   return
  end

 grim_set_mode, grim_data, 'move', /new

 
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_rotate_mode_event
;
;
; PURPOSE:
;	Selects the rotate cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Rotates the camera to a new optic axis.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2009
;	
;-
;=============================================================================
pro grim_rotate_mode_help_event, event
 text = ''
 nv_help, 'grim_rotate_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_rotate_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Rotate camera'
   return
  end

 grim_set_mode, grim_data, 'rotate', /new

 
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_spin_mode_event
;
;
; PURPOSE:
;	Selects the spin cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Rotates the camera about the optic axis.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2009
;	
;-
;=============================================================================
pro grim_spin_mode_help_event, event
 text = ''
 nv_help, 'grim_spin_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_spin_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Spin camera'
   return
  end

 grim_set_mode, grim_data, 'spin', /new

 
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_mag_mode_event
;
;
; PURPOSE:
;	Selects the magnify cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Image pixels in the graphics window may be magnifed using 
;	either the left or right mouse buttons.  The left button 
;	magnifies the displayed pixels, directly from the graphics 
;	window.  The right button magnifies the data itself, without 
;	the overlays.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_mag_mode_help_event, event
 text = ''
 nv_help, 'grim_mag_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_mag_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Magnifying glass'
   return
  end

 grim_set_mode, grim_data, 'mag', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_remove_mode_event
;
;
; PURPOSE:
;	Selects the remove cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	A single click on an overlay causes it to be deleted.  A
;       double click causes the entire object to be deleted.  The left
;	button applies to standard overlays; the right button applies 
;	to user overlays.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2006
;	
;-
;=============================================================================
pro grim_remove_mode_help_event, event
 text = ''
 nv_help, 'grim_remove_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_remove_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Remove overlays/objects'
   return
  end

 grim_set_mode, grim_data, 'remove', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_smooth_mode_event
;
;
; PURPOSE:
;	Selects the smooth cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	The user selects a box, which is used to determine the kernel
;	size for smothing the data set.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2006
;	
;-
;=============================================================================
pro grim_smooth_mode_help_event, event
 text = ''
 nv_help, 'grim_remove_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_smooth_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Smooth data'
   return
  end

 grim_set_mode, grim_data, 'smooth', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_region_mode_event
;
;
; PURPOSE:
;	Selects the 'region' cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	An image region is defined by clicking and dragging a box or curve.  
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2014
;	
;-
;=============================================================================
pro grim_region_mode_help_event, event
 text = ''
 nv_help, 'grim_region_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_region_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Define region'
   return
  end

 grim_set_mode, grim_data, 'region', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_select_mode_event
;
;
; PURPOSE:
;	Selects the 'select' cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Overlay points are selected by clicking and dragging and curve around
;	the desired points.  The left button selects overlay points, the right 
;	deselects overlay points.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2014
;	
;-
;=============================================================================
pro grim_select_mode_help_event, event
 text = ''
 nv_help, 'grim_select_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_select_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Select overlay points'
   return
  end

 grim_set_mode, grim_data, 'select', /new
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_trim_mode_event
;
;
; PURPOSE:
;	Selects the trim cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	Overlay points are trimmed by clicking and dragging and curve around
;	the desired points.  The left button trims standard overlays, the right 
;	trims user overlay points.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2006
;	
;-
;=============================================================================
pro grim_trim_mode_help_event, event
 text = ''
 nv_help, 'grim_trim_mode_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_trim_mode_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Trim overlays'
   return
  end

 grim_set_mode, grim_data, 'trim', /new
 grim_set_data, grim_data, event.top

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
; grim_add_help_menu
;
;=============================================================================
function grim_add_help_menu, _menu_desc

 menu_desc = _menu_desc

 help_desc = strep_s(menu_desc, '_event', '_help_event')
 menu_desc = append_array(menu_desc, ['1\Help', help_desc])

 return, menu_desc
end
;=============================================================================



;=============================================================================
; grim_parse_menu_desc
;
;=============================================================================
function grim_parse_menu_desc, _menu_desc, map_items=map_items, $
                                           od_map_items=od_map_items, $
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
  end

 p = strpos(menu_desc, od_token)
 w = where(p NE -1)
 if(w[0] NE -1) then $
  begin
   ss = str_nnsplit(menu_desc[w], od_token, rem=od_map_items)
   menu_desc[w] = ss + od_map_items
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
function grim_menu_desc, user_modes=user_modes

 desc = [ '+*1\File' , $
           '0\Load                \+*grim_menu_file_load_event', $
           '0\Browse              \*grim_menu_file_browse_event', $
           '0\Save                \+*grim_menu_file_save_event', $
           '0\Save As             \+*grim_menu_file_save_as_event', $
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
           '2\Close               \+*grim_menu_file_close_event', $

          '+*1\Mode' , $
           '0\Activate \*grim_activate_mode_event' , $
           '0\Zoom     \*grim_zoom_mode_event' , $
           '0\Pan      \*grim_pan_mode_event' , $
           '0\Zoom     \%grim_zoom_plot_mode_event' , $
           '0\Pan      \%grim_pan_plot_mode_event' , $
           '0\Readout  \*grim_readout_mode_event' , $
           '0\Tiepoint \+*grim_tiepoints_mode_event' , $
           '0\Curve    \+*grim_curves_mode_event' , $
           '0\Mask     \*grim_mask_mode_event' , $
           '0\Magnify  \*grim_mag_mode_event', $
           '0\XY Zoom  \*grim_xyzoom_mode_event' , $
           '0\Remove   \*grim_rm_mode_event', $
           '0\Trim     \*grim_trim_mode_event', $
           '0\Select   \*grim_select_mode_event', $
           '0\Region   \+*grim_region_mode_event', $
           '0\Smooth   \*grim_smooth_mode_event', $
           '0\Move     \grim_move_mode_event', $
           '0\Rotate   \grim_rotate_mode_event', $
           '0\Spin     \grim_spin_mode_event', $
           '2\Plane    \*grim_plane_mode_event', $

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
           '0\Toggle Highlight   \*grim_menu_plane_highlight_event', $
           '0\-------------------\grim_menu_delim_event', $ 
           '0\Copy tie points     \*grim_menu_plane_copy_tiepoints_event', $
           '0\Propagate tie points\*grim_menu_plane_propagate_tiepoints_event', $
           '0\Toggle tie point syncing\*grim_menu_plane_toggle_tiepoint_syncing_event', $
           '0\Clear tie points    \*grim_menu_plane_clear_tiepoints_event', $
           '0\-------------------\grim_menu_delim_event', $ 
           '0\Copy curves        \*grim_menu_plane_copy_curves_event', $
;;;           '0\Propagate curves    \*grim_menu_plane_propagate_curves_event', $
           '0\Toggle curves syncing\*grim_menu_plane_toggle_curve_syncing_event', $
           '0\Clear curves        \*grim_menu_plane_clear_curves_event', $
           '0\-------------------\grim_menu_delim_event', $ 
           '0\Copy mask          \*grim_menu_plane_copy_mask_event', $
           '0\Clear mask         \*grim_menu_plane_clear_mask_event', $
           '0\-------------------\grim_menu_delim_event', $ 
           '0\Copy curves        \*grim_menu_plane_copy_curves_event', $
           '0\Toggle curve syncing\*grim_menu_plane_toggle_curve_syncing_event', $
           '0\Clear curves       \*grim_menu_plane_clear_curves_event', $
           '0\-------------------\grim_menu_delim_event', $ 
           '2\Settings           \+*grim_menu_plane_settings_event', $

          '+*1\Data' , $
           '2\Adjust values        \+*grim_menu_data_adjust_event' , $

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
             '2\1/10                 \+*grim_menu_view_zoom_1_10_event' , $
           '+*1\Rotate' , $
             '0\0                 \+*grim_menu_view_rotate_0_event' , $
             '0\1                 \+*grim_menu_view_rotate_1_event' , $
             '0\2                 \+*grim_menu_view_rotate_2_event' , $
             '0\3                 \+*grim_menu_view_rotate_3_event' , $
             '0\4                 \+*grim_menu_view_rotate_4_event' , $
             '0\5                 \+*grim_menu_view_rotate_5_event' , $
             '0\6                 \+*grim_menu_view_rotate_6_event' , $
             '2\7                 \+*grim_menu_view_rotate_7_event' , $
           '0\Recenter             \+*grim_menu_view_recenter_event' , $
           '0\Home                 \+*grim_menu_view_home_event' , $
           '0\Save                 \+*grim_menu_view_save_event' , $
           '0\Restore              \+*grim_menu_view_restore_event', $
           '0\Previous             \+*grim_menu_view_previous_event', $
           '0\Entire               \+*grim_menu_view_entire_event', $
           '0\Initial              \+*grim_menu_view_initial_event', $
           '0\Reverse Order        \*grim_menu_view_flip_event', $ 
           '0\Frame Active Overlays\*grim_menu_view_frame_active_event', $ 
           '0\---------------------\grim_menu_delim_event', $ 
           '0\Header               \grim_menu_view_header_event', $
           '0\Notes                \grim_menu_notes_event', $
           '0\--------------------+\grim_menu_delim_event', $ 
           '0\Toggle Image         \+*grim_menu_toggle_image_event' , $
           '0\Toggle Image/Overlays \+*grim_menu_toggle_image_overlays_event' , $
           '0\Toggle Context       \+*grim_menu_context_event' , $
           '0\Toggle Axes          \*grim_menu_axes_event' , $
           '0\---------------------\*?grim_delim_event', $ 
           '0\Render               \*?grim_menu_render_event' , $
           '0\---------------------\*grim_delim_event', $ 
           '2\Colors               \*grim_menu_view_colors_event', $ 

          '+*1\Overlays' ,$
           '0\Compute planet centers \grim_menu_points_planet_centers_event', $ 
           '0\Compute limbs          \#grim_menu_points_limbs_event', $        
           '0\Compute terminators    \#grim_menu_points_terminators_event', $
           '0\Compute planet grids   \*grim_menu_points_planet_grids_event', $ 
           '0\Compute rings          \grim_menu_points_rings_event', $
           '0\Compute ring grids     \grim_menu_points_ring_grids_event', $ 
           '0\Compute stars          \grim_menu_points_stars_event', $ 
           '0\Compute shadows        \grim_menu_points_shadows_event', $ 
           '0\Compute stations       \*grim_menu_points_stations_event', $ 
           '0\Compute arrays         \*grim_menu_points_arrays_event', $ 
;           '0\-------------------------\grim_menu_delim_event', $ 
;           '0\Fill limbs             \grim_menu_points_fill_limbs_event', $        
;           '0\Fill rings             \grim_menu_points_fill_rings_event', $        
           '0\-------------------------\grim_menu_delim_event', $ 
           '0\Hide/Unhide all        \+*grim_menu_hide_all_event', $ 
           '0\Clear all              \*grim_menu_clear_all_event', $ 
           '0\Clear active           \*grim_menu_clear_active_event', $ 
           '0\Activate all           \*grim_menu_activate_all_event', $ 
           '0\Deactivate all         \*grim_menu_deactivate_all_event', $ 
           '0\Invert activations     \*grim_menu_invert_event', $ 
           '0\-------------------------\grim_menu_delim_event', $ 
           '2\Overlay Settings       \+*grim_menu_points_settings_event' ]

 ;----------------------------------------------
 ; Insert user mode menu items
 ;----------------------------------------------
 if(keyword_set(user_modes)) then $
  begin
   p = strpos(desc, '2\Plane')
   w = (where(p EQ 0))[0]
   desc[w] = strep(desc[w], '0', 0)

   nn = max([strlen(user_modes.menu), 8])
   delim = '0\' + str_pad('-', nn, c='-') + '\grim_menu_delim_event'

   items = '0\' + user_modes.menu + '  \' + user_modes.event_pro
   n = n_elements(items)
   items[n-1] = strep(items[n-1], '2', 0)

   desc = [desc[0:w], delim, items, desc[w+1:*]]
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
; grim_rm_menu_items
;
;=============================================================================
function grim_rm_menu_items, menu_desc, ii

 if(NOT defined(ii)) then return, menu_desc

 iii = complement(menu_desc, ii)

 w = where(strmid(menu_desc[ii], 0, 1) EQ 2)
 if(w[0] NE -1) then $
  for i=0, n_elements(w)-1 do $
   begin
    dw = ii[w[i]] - iii
    dw = min(dw[where(dw GT 0)])
    menu_desc[ii[w[i]]-dw] = strep(menu_desc[ii[w[i]]-dw], '2', 0)
   end
 menu_desc = menu_desc[iii]

 return, menu_desc
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
pro grim_widgets, grim_data, xsize=xsize, ysize=ysize, user_modes=user_modes, $
   menu_fname=menu_fname, menu_extensions=menu_extensions
@grim_constants.common

 if(grim_data.retain GT 0) then retain = grim_data.retain

 plot = grim_data.type EQ 'plot'
 beta = grim_data.beta

 ;-----------------------------------------
 ; base, menu bar
 ;-----------------------------------------
 grim_data.base = widget_base(mbar=mbar, /col, /tlb_size_events, $
                          resource_name='grim_base', rname_mbar='grim_mbar')
 grim_data.mbar = mbar
 grim_data.grnum = grim_top_to_grnum(grim_data.base, /new)

 menu_desc = grim_menu_desc(user_modes=user_modes)
 for i=0, n_elements(menu_extensions)-1 do $
                   menu_desc = [menu_desc, call_function(menu_extensions[i])]

 if(keyword_set(menu_fname)) then $
  begin
   user_menu_desc = strtrim(strip_comment(read_txt_file(menu_fname)), 2)
   if(keyword_set(user_menu_desc)) then menu_desc = [menu_desc, user_menu_desc]
  end

 menu_desc = grim_parse_menu_desc(menu_desc, $
     map_items=map_items, od_map_items=od_map_items, plot_items=plot_items, $
     plot_indices=plot_indices, plot_only_items=plot_only_items, $
     plot_only_indices=plot_only_indices, beta_only_indices=beta_only_indices)

 if(plot) then $
     mark = append_array(mark, complement(menu_desc, [plot_indices, plot_only_indices])) $
 else mark = append_array(mark, plot_only_indices) 

 if(NOT beta) then mark = append_array(mark, beta_only_indices)

 if(keyword_set(mark)) then menu_desc = grim_rm_menu_items(menu_desc, mark)

 menu_desc = grim_add_help_menu(menu_desc)

 grim_data.menu_desc_p = nv_ptr_new(menu_desc)
 grim_data.map_items_p = nv_ptr_new(map_items)
 grim_data.od_map_items_p = nv_ptr_new(od_map_items)


 grim_data.menu = $
          cw__pdmenu(grim_data.mbar, menu_desc, /mbar, ids=menu_ids, $
                                               capture='grim_menu_capture')
 grim_data.menu_ids_p = nv_ptr_new(menu_ids)



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

 if(NOT plot) then $
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

; grim_data.modes_base1 = $
;       widget_base(grim_data.modes_base, /col, space=0, xpad=0, ypad=0)

 grim_data.modes_base2 = $
       widget_base(grim_data.modes_base, /col, space=0, xpad=0, ypad=4)

 if(NOT plot) then $
   grim_data.activate_button = widget_button(grim_data.modes_base2, $
              value=grim_activate_bitmap(), /bitmap, /tracking_events, $
       event_pro='grim_activate_mode_event', uname='mode', uvalue='activate')

 if(NOT plot) then $
  grim_data.zoom_button = widget_button(grim_data.modes_base2, $
              value=grim_zoom_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_zoom_mode_event', uname='mode', uvalue='zoom') $
 else $
  grim_data.zoom_button = widget_button(grim_data.modes_base2, $
              value=grim_zoom_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_zoom_plot_mode_event', uname='mode', uvalue='zoom_plot') 

 if(NOT plot) then $
  grim_data.pan_button = widget_button(grim_data.modes_base2, $
              value=grim_pan_bitmap(), /bitmap, /tracking_events, $
            event_pro='grim_pan_mode_event', uname='mode', uvalue='pan') $
 else $
  grim_data.pan_button = widget_button(grim_data.modes_base2, $
              value=grim_pan_bitmap(), /bitmap, /tracking_events, $
            event_pro='grim_pan_plot_mode_event', uname='mode', uvalue='pan_plot')

 if(NOT plot) then $
   grim_data.readout_button = widget_button(grim_data.modes_base2, $
              value=grim_readout_bitmap(), /bitmap, /tracking_events, $
         event_pro='grim_readout_mode_event', uname='mode', uvalue='readout')

 grim_data.tiepoints_button = widget_button(grim_data.modes_base2, $
              value=grim_tiepoints_bitmap(), /bitmap, /tracking_events, $
      event_pro='grim_tiepoints_mode_event', uname='mode', uvalue='tiepoints')

 grim_data.curves_button = widget_button(grim_data.modes_base2, $
              value=grim_curves_bitmap(), /bitmap, /tracking_events, $
      event_pro='grim_curves_mode_event', uname='mode', uvalue='curves')

 if(NOT plot) then $
   grim_data.mask_button = widget_button(grim_data.modes_base2, $
              value=grim_mask_bitmap(), /bitmap, /tracking_events, $
         event_pro='grim_mask_mode_event', uname='mode', uvalue='mask')

 if(NOT plot) then $
  grim_data.mag_button = widget_button(grim_data.modes_base2, $
              value=grim_mag_bitmap(), /bitmap, /tracking_events, $
          event_pro='grim_mag_mode_event', uname='mode', uvalue='mag')

 if(NOT plot) then $
   grim_data.xyzoom_button = widget_button(grim_data.modes_base2, $
              value=grim_xyzoom_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_xyzoom_mode_event', uname='mode', uvalue='xyzoom')

 if(NOT plot) then $
   grim_data.remove_button = widget_button(grim_data.modes_base2, $
              value=grim_remove_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_remove_mode_event', uname='mode', uvalue='remove')

 if(NOT plot) then $
   grim_data.trim_button = widget_button(grim_data.modes_base2, $
              value=grim_dagger_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_trim_mode_event', uname='mode', uvalue='trim')

 if(NOT plot) then $
   grim_data.select_mode_button = widget_button(grim_data.modes_base2, $
              value=grim_scalpel_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_select_mode_event', uname='mode', uvalue='select')

 grim_data.region_button = widget_button(grim_data.modes_base2, $
              value=grim_lasso_bitmap(), /bitmap, /tracking_events, $
           event_pro='grim_region_mode_event', uname='mode', uvalue='region')

; if(NOT plot) then $
;   grim_data.remove_xd_button = widget_button(grim_data.modes_base2, $
;              value=grim_mp40_bitmap(), /bitmap, /tracking_events, $
;           event_pro='grim_remove_xd_mode_event', uname='mode', uvalue='remove_xd')

 grim_data.smooth_button = widget_button(grim_data.modes_base2, $
              value=grim_smooth_bitmap(), /bitmap, /tracking_events, $
      event_pro='grim_smooth_mode_event', uname='mode', uvalue='smooth')

 if(NOT plot) then $
   grim_data.plane_button = widget_button(grim_data.modes_base2, $
              value=grim_plane_bitmap(), /bitmap, /tracking_events, $
         event_pro='grim_plane_mode_event', uname='mode', uvalue='plane')

if(beta) then begin
 if(NOT plot) then $
   grim_data.move_button = widget_button(grim_data.modes_base2, $
              value=grim_move_bitmap(), /bitmap, /tracking_events, $
         event_pro='grim_move_mode_event', uname='mode', uvalue='move')

 if(NOT plot) then $
   grim_data.rotate_button = widget_button(grim_data.modes_base2, $
              value=grim_rotate_bitmap(), /bitmap, /tracking_events, $
         event_pro='grim_rotate_mode_event', uname='mode', uvalue='rotate')

 if(NOT plot) then $
   grim_data.spin_button = widget_button(grim_data.modes_base2, $
              value=grim_spin_bitmap(), /bitmap, /tracking_events, $
         event_pro='grim_spin_mode_event', uname='mode', uvalue='spin')
end

 ;- - - - - - - - - - - - -
 ; user modes
 ;- - - - - - - - - - - - -
 nmodes = n_elements(user_modes)
 if(nmodes GT 0) then $
  begin
   grim_data.modes_base3 = $
       widget_base(grim_data.modes_base, /col, space=0, xpad=0, ypad=0)

   user_mode_buttons = lonarr(nmodes)
   for i=0, nmodes-1 do $
    begin
     user_mode_buttons[i] = widget_button(grim_data.modes_base3, $
              value=user_modes[i].bitmap, /bitmap, /tracking_events, $
                       event_pro=user_modes[i].event_pro, uname='mode', $
                                                   uvalue=user_modes[i].name)
     widget_control, user_mode_buttons[i], set_uvalue=user_modes[i]

     nid = n_elements(menu_ids)
     for ii=0, nid-1 do $
      begin
       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       ; Because we override the event_pro here, the user modes do not
       ; participate in grim's capture mechanism, so the 'repeat'
       ; command does not apply.  This is necessary because the user
       ; modes store their data in their button's uvalue, which would
       ; otherwise be used by the capture mechanism.
       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       widget_control, menu_ids[ii], get_value=v
       if(strtrim(v,2) EQ user_modes[i].menu) then $
            widget_control, menu_ids[ii], set_uvalue=user_modes[i], $
                                        event_pro=user_modes[i].event_pro
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
 grim_data.draw_base = widget_base(grim_data.sub_base, space=0, xpad=0, ypad=0)

 grim_data.draw = $
     widget_draw(grim_data.draw_base, xsize=xsize, ysize=ysize, $
                /button_events, /tracking_events, /motion_events, $
                 event_pro='grim_draw_event', resource_name='grim_draw', $
                 retain=retain)
 if(idl_v_chrono(!version.release) GE idl_v_chrono('6.4')) then $
                             widget_control, grim_data.draw, /draw_wheel_events

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

 for j=0, nplanes-1 do $
  for i=0, n_overlays-1 do $
   begin
    name = grim_parse_overlay(overlays[i], obj_name)

    grim_print, grim_data, 'Plane ' + strtrim(j,1) + ': ' + name

;print, i, j, ' ', name, ' ', obj_name
    grim_overlay, grim_data, name, plane=planes[j], obj_name=obj_name, temp=temp, ptd=_ptd
    if(keyword_set(_ptd)) then ptd = append_array(ptd, _ptd[*])
   end

end
;=============================================================================



;=============================================================================
; grim_get_args_recurse
;
;=============================================================================
pro grim_get_args_recurse, arg_ps, dd=dd, grnum=grnum, xarr, yarr, nhist=nhist, $
               maintain=maintain, compress=compress, extensions=extensions


 nargs = n_elements(arg_ps)


 ;-----------------------------------
 ; recurse until all args checked
 ;-----------------------------------
 while(1) do $
  begin
   if(dat_valid_descriptor(arg_ps[0])) then arg = arg_ps[0] $
   else arg = *arg_ps[0]

;   arg = *arg_ps[0]

   type = size(arg, /type)
   dim = size(arg, /dim) 
   ndim = n_elements(dim)

   ;- - - - - - - - - - - - - - - -
   ; filename(s)
   ;- - - - - - - - - - - - - - - -
   if(type EQ 7) then $
    begin
     _dd = dat_read(arg, maintain=maintain, compress=compress, extensions=extensions, nhist=nhist)

;     if(keyword_set(nhist)) then $
;             for i=0, n_elements(dd)-1 do dat_set_nhist, dd[i], nhist

    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; If any dd's don't have 2 dimensions, then they must be expanded
    ; recursively.  This has the side effect of forcing those types of 
    ; descriptors to be loaded regardless of the maintenence level.
    ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    n_dd = n_elements(_dd)
    for i=0, n_dd-1 do $
     begin
      __dd = _dd[i]
      if(n_elements(dat_dim(_dd[i])) NE 2) then $
       begin
        arg = dat_data(__dd)
        nv_free, __dd & __dd = obj_new()
        arg_ps = nv_ptr_new(arg)
        grim_get_args_recurse, arg_ps, dd=__dd, grnum=grnum, xarr, yarr
        nv_ptr_free, arg_ps
       end 

      dd = append_array(dd, __dd)
     end
   end $

   else if(type EQ 11) then $
    begin
     ;- - - - - - - - - - - - - - - -
     ; dd
     ;- - - - - - - - - - - - - - - -
     if(dat_valid_descriptor(arg)) then $
      begin
        _dd = arg
        n_dd = n_elements(_dd)
        for i=0, n_dd-1 do $
         begin
          arr = dat_data(_dd[i])

;          if(n_elements(size(arr, /dim)) EQ 1) then $
          if(n_elements(dat_dim(_dd[i])) EQ 1) then $
           begin
            grim_suspend_events
            yarr = arr
            xarr = dindgen(n_elements(yarr))
            dat_set_data, _dd[i], [transpose(xarr), transpose(yarr)]
            grim_resume_events
           end

          if(keyword_set(nhist)) then dat_set_nhist, _dd[i], nhist
          if(keyword_set(maintain)) then dat_set_maintain, _dd[i], maintain
          if(keyword_set(compress)) then dat_set_compress, _dd[i], compress
         end

        dd = append_array(dd, _dd)
      end $
     else $
     ;- - - - - - - - - - - - - - - -
     ; more arg_ps
     ;- - - - - - - - - - - - - - - -
      begin
        if(keyword_set(arg_ps[0])) then $
             grim_get_args_recurse, arg, dd=dd, grnum=grnum, xarr, yarr
      end
    end $

   ;- - - - - - - - - - - - - - - -
   ; grnum
   ;- - - - - - - - - - - - - - - -
   else if((ndim EQ 1) AND (dim[0] EQ 0)) then grnum = arg $

   ;- - - - - - - - - - - - - - - -
   ; full data array
   ;- - - - - - - - - - - - - - - -
   else if(ndim EQ 2) then $
    begin
     _dd = dat_create_descriptors(1, data=arg, nhist=nhist, maintain=maintain, compress=compress)
     dd = append_array(dd, _dd)
    end $

   ;- - - - - - - - - - - - - - - -
   ; multiple data arrays
   ;- - - - - - - - - - - - - - - -
   else if(ndim EQ 3) then $
    begin
     nn = dim[2]
     for i=0, nn-1 do $
      begin
       _dd = dat_create_descriptors(1, data=arg[*,*,i], nhist=nhist, maintain=maintain, compress=compress)
       dd = append_array(dd, _dd)
      end
    end $

   ;- - - - - - - - - - - - - - - -
   ; one axis
   ;- - - - - - - - - - - - - - - -
   else if(ndim EQ 1) then $
    begin
     yarr = arg
     xarr = dindgen(n_elements(yarr))
     _dd = dat_create_descriptors(1, data=[transpose(xarr), transpose(yarr)], nhist=nhist)
     dd = append_array(dd, _dd)
    end $
   else grim_message, 'Invalid argument.'

   arg_ps = rm_list_item(arg_ps, 0, only=nv_ptr_new())

   if(keyword_set(arg_ps[0])) then $
        grim_get_args_recurse, arg_ps, dd=dd, grnum=grnum, xarr, yarr

   return
  end



end
;=============================================================================



;=============================================================================
; grim_get_args
;
;=============================================================================
pro grim_get_args, arg1, arg2, dd=dd, grnum=grnum, type=type, xzero=xzero, nhist=nhist, $
               maintain=maintain, compress=compress, extensions=extensions

 ;--------------------------------
 ; recurse through args
 ;--------------------------------
 arg_ps = ptrarr(2)
 if(defined(arg1)) then arg_ps[0] = nv_ptr_new(arg1)
 if(defined(arg2)) then arg_ps[1] = nv_ptr_new(arg2)

 w = where(ptr_valid(arg_ps))
 if(w[0] NE -1) then $
         grim_get_args_recurse, arg_ps[w], dd=dd, grnum=grnum, xarr, yarr, nhist=nhist, $
                                maintain=maintain, compress=compress, extensions=extensions

 if(keyword_set(arg_ps[0])) then nv_ptr_free, arg_ps[0]
 if(keyword_set(arg_ps[1])) then nv_ptr_free, arg_ps[1]


 ;----------------------------
 ; determine type
 ;----------------------------
 type = 'image'
 if(keyword_set(dd)) then $
  begin 
   dim = dat_dim(dd[0])
   if(dim[0] EQ 2) then type = 'plot'
  end


 ;---------------------------------------------------
 ; shift x axis to zero if desired
 ;---------------------------------------------------
 if(keyword_set(plot) AND keyword_set(xzero)) then $
  begin
   data = dat_data(dd)
   data[0,*] = data[0,*] - data[0,0]
   dat_set_data, dd, data
  end

end
;=============================================================================



;=============================================================================
; grim
;
;=============================================================================
pro grim, arg1, arg2, gd=gd, cd=cd, pd=pd, rd=rd, sd=sd, std=std, sund=sund, od=od, $
	silent=silent, new=new, inherit=inherit, xsize=xsize, ysize=ysize, $
	default=default, previous=previous, restore=restore, activate=activate, $
	doffset=doffset, no_erase=no_erase, filter=filter, visibility=visibility, exit=exit, $
	zoom=zoom, rotate=rotate, order=order, offset=offset, retain=retain, maintain=maintain, $
	set_info=set_info, mode=mode, modal=modal, xzero=xzero, frame=frame, $
	refresh_callbacks=refresh_callbacks, refresh_callback_data_ps=refresh_callback_data_ps, $
	plane_callbacks=plane_callbacks, plane_callback_data_ps=plane_callback_data_ps, $
	nhist=nhist, compress=compress, path=path, symsize=symsize, $
	user_modes=user_modes, user_psym=user_psym, ups=ups, workdir=workdir, $
        save_path=save_path, load_path=load_path, overlays=overlays, pn=pn, $
	faint=faint, menu_fname=menu_fname, cursor_swap=cursor_swap, fov=fov, hide=hide, $
	menu_extensions=menu_extensions, button_extensions=button_extensions, $
	arg_extensions=arg_extensions, loadct=loadct, max=max, grnum=grnum, $
	extensions=extensions, beta=beta, rendering=rendering, npoints=npoints, $
	trs_cd=trs_cd, trs_pd=trs_pd, trs_rd=trs_rd, trs_sd=trs_sd, $
        trs_sund=trs_sund, trs_std=trs_std, trs_ard=trs_ard, $
        readout_fns=readout_fns, tiepoint_syncing=tiepoint_syncing, $
	curve_syncing=curve_syncing, render_sample=render_sample, $
	render_pht_min=render_pht_min, $
     ;----- extra keywords for plotting only ----------
	color=color, xrange=xrange, yrange=yrange, thick=thick, nsum=nsum, ndd=ndd, $
        xtitle=xtitle, ytitle=ytitle, psym=psym, title=title
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
@grim_block.include

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
        tiepoint_syncing=tiepoint_syncing, curve_syncing=curve_syncing, $
	visibility=visibility, render_sample=render_sample, $
	render_pht_min=render_pht_min

 if(keyword_set(ndd)) then dat_set_ndd, ndd

 if(NOT keyword_set(menu_extensions)) then $
                                     menu_extensions = 'grim_default_menus' $
 else if(strmid(menu_extensions[0],0,1) EQ '+') then $
  begin
   menu_extensions[0] = strmid(menu_extensions[0], 1, strlen(menu_extensions[0])-1)
   menu_extensions = ['grim_default_menus', menu_extensions]
  end

 if(keyword_set(button_extensions)) then $
  begin
   for i=0, n_elements(button_extensions)-1 do $
    begin

     if(keyword_set(arg_extensions)) then $
      begin
       if(size(arg_extensions, /type) EQ 10) then arg_extension = *arg_extensions[i] $
       else arg_extension = arg_extensions[i]
    
       user_modes = append_array(user_modes, $
                               call_function(button_extensions[i], arg_extension))
      end $
     else user_modes = append_array(user_modes, call_function(button_extensions[i]))
    end
  end

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
 ; arg is either image, data descriptor or grnum
 ;=========================================================
 grim_get_args, arg1, arg2, dd=dd, grnum=grnum, type=type, xzero=xzero, nhist=nhist, $
               maintain=maintain, compress=compress, extensions=extensions

; if(keyword_set(rendering)) then ....

 if(NOT keyword_set(grim_get_data())) then new = 1

 if(NOT keyword_set(mode)) then $
  begin
   if(type EQ 'plot') then mode = 'zoom_plot' $
   else mode = 'activate'
  end


 if(type EQ 'plot') then $
  begin
   if(NOT keyword_set(xsize)) then xsize = 400
   if(NOT keyword_set(ysize)) then ysize = 400
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
   grim_data = grim_init(dd, zoom=zoom, wnum=wnum, grnum=grnum, type=type, $
       filter=filter, retain=retain, user_callbacks=user_callbacks, $
       user_psym=user_psym, path=path, save_path=save_path, load_path=load_path, $
       faint=faint, cursor_swap=cursor_swap, fov=fov, hide=hide, filetype=filetype, $
       trs_cd=trs_cd, trs_pd=trs_pd, trs_rd=trs_rd, trs_sd=trs_sd, trs_std=trs_std, trs_sund=trs_sund, trs_ard=trs_ard, $
       color=color, xrange=xrange, yrange=yrange, thick=thick, nsum=nsum, $
       psym=psym, xtitle=xtitle, ytitle=ytitle, user_modes=user_modes, workdir=workdir, $
       readout_fns=readout_fns, symsize=symsize, nhist=nhist, maintain=maintain, $
       compress=compress, extensions=extensions, max=max, beta=beta, npoints=npoints, $
       tiepoint_syncing=tiepoint_syncing, curve_syncing=curve_syncing, visibility=visibility, $
       title=title, render_sample=render_sample, $
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
   grim_widgets, grim_data, xsize=xsize, ysize=ysize, user_modes=user_modes, $
         menu_fname=menu_fname, menu_extensions=menu_extensions

   grnum = grim_data.grnum 

   planes = grim_get_plane(grim_data, /all)
   for i=0, n_elements(planes)-1 do planes[i].grnum = grnum
   grim_set_plane, grim_data, planes

   grim_set_mode, grim_data, mode, /init
   grim_set_data, grim_data, grim_data.base

   grim_resize, grim_data, /init
   widget_control, grim_data.base, map=1

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
;                    call_procedure, button_extensions[i]+'_init', grim_data, user_modes[i].data_p
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
 ; regardless of new or existing, update descriptors if any given
 ;======================================================================
 pgs_gd, gd, cd=cd, pd=pd, rd=rd, sd=sd, std=std, sund=sund, od=od

 grim_data = grim_get_data()
 ncd = n_elements(cd)

 ;----------------------------------------------------------------------
 ; if one cd, just use current plane
 ;----------------------------------------------------------------------
 if(ncd EQ 1) then planes = grim_get_plane(grim_data) $
 ;----------------------------------------------------------------------
 ; if more than one cd, then one for each plane
 ;----------------------------------------------------------------------
 else if(ncd GT 1) then $
  begin
   planes = grim_get_plane(grim_data, /all)
   if(n_elements(planes) NE ncd) then $
                nv_message, name='grim', $
                     'There must be one camera descriptor for each plane.'
  end $
 ;----------------------------------------------------------------------
 ; if no camera descriptors given, then you can still give other
 ; descriptors to use for the current plane
 ;----------------------------------------------------------------------
 else $
  begin
   plane = grim_get_plane(grim_data, pn=pn)
   if(keyword_set(pd)) then grim_add_descriptor, grim_data, plane.pd_p, pd
   if(keyword_set(rd)) then grim_add_descriptor, grim_data, plane.rd_p, rd
   if(keyword_set(sd)) then grim_add_descriptor, grim_data, plane.sd_p, sd
   if(keyword_set(std)) then grim_add_descriptor, grim_data, plane.std_p, std
   if(keyword_set(sund)) then $
             grim_add_descriptor, grim_data, plane.sund_p, sund, /one
   if(keyword_set(od)) then $
             grim_add_descriptor, grim_data, plane.od_p, od, /one, /noregister
  end

 ;----------------------------------------------------------------------
 ; if descriptors given, then the descriptors must be arays 
 ; with the following dimensions:
 ;
 ;  cd -- nplanes
 ;  pd -- [npd, nplanes]
 ;  rd -- [nrd, nplanes]
 ;  sd -- [nsd, nplanes]
 ;  std -- [nstd, nplanes]
 ;  sund -- nplanes
 ;  od -- nplanes
 ;
 ;----------------------------------------------------------------------
 for i=0, ncd-1 do $
  begin
   grim_add_descriptor, grim_data, planes[i].cd_p, cd[i], /one
   if(keyword_set(pd)) then $
                grim_add_descriptor, grim_data, planes[i].pd_p, pd[*,i]
   if(keyword_set(rd)) then $
                grim_add_descriptor, grim_data, planes[i].rd_p, rd[*,i]
   if(keyword_set(std)) then $
                grim_add_descriptor, grim_data, planes[i].std_p, std[*,i]
   if(keyword_set(sd)) then $
                grim_add_descriptor, grim_data, planes[i].sd_p, sd[*,i]
   if(keyword_set(sund)) then $
                grim_add_descriptor, grim_data, planes[i].sund_p, sund[i], /one
   if(keyword_set(od)) then $
       grim_add_descriptor, grim_data, planes[i].od_p, od[i], /one, /noregister
  end



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
	xrange=xrange, yrange=yrange, $
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
 ; if new instance, initialize extensions
 ;=========================================================
 if(new) then $
  begin
   if(keyword_set(button_extensions)) then $
    begin
     for i=0, n_elements(button_extensions)-1 do $
                    call_procedure, button_extensions[i]+'_init', grim_data, user_modes[i].data_p
    end
  end



 ;-------------------------
 ; draw initial image
 ;-------------------------
 grim_refresh, grim_data, no_erase=no_erase;, /no_image

end
;=============================================================================
