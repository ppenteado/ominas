;=============================================================================
;+-+
; NAME:
;	brim
;
;
; PURPOSE:
;	Image browser.
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	brim, files
;
;
; ARGUMENTS:
;  INPUT:
;	files:	List of filenames and file specifications.  Only files whose
;		filetypes can be detected are loaded.  If this argument is not
;		given, the user is prompted for a list of files.  An array of
;		data descriptors may also be specified.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	thumbsize:	Size of the thumbnal images.  Default is 100 pixels.
;			Thumbnail images are alwasy square.
;
;	labels:		Labels to use for each thumbnail.  If none given, the
;			filename is used, is one exists.
;
;	ids:		Array to identify each thumbnail.  If none given, the
;			labels are used, if they exist.
;
;	select_ids:	Ids of Initial thumbnail(s) to appear selected.
;
;	left_fn:	Name of a procedure to call when the left mouse button
;			is clicked on a thumbnail.  Default procedure selects
;			that image and opens it in a new grim window.  The
;			user procedure is called as follows: 
;
;				left_fn, fn_data, i, id, status=status
;
;			fn_data is supplied by the caller through the fn_data
;			keyword, i is the index of the thumbnail, id is the
;			thumbnail id as given by the ids keyword,
;			and status should return 0 if successful and nonzero
;			otherwise.
;
;	middle_fn:	Name of a procedure to call when the middle mouse button
;			is clicked on a thumbnail.  There is no default.
;
;	right_fn:	Name of a procedure to call when the right mouse button
;			is clicked on a thumbnail.  There is no default.
;
;	fn_data:	Data to be supplied to the above user procedures.
;
;	exclusive_selection:	
;			If set, only one image may be selected at once.  
;			(Currently multiple image selection is not supported.)
;
;	path:		Initial path to use for the file selection widget, 
;			which appears only if the file argument is not given. 
;
;	modal:		If set, only the brim widget may be used until it
;			is closed.
;
;	title:		Title to use for the brim widget instead of 'brim'.
;
;	order:		Display order for thumbnails.  Default is 0.
;
;	filter:		Initial filter to use when loading files.
;
;  OUTPUT:
;	get_path:	Final path selected in the file selection widget.
;
;	select_ids:	On return, select_ids contains the ids of the selected
;			images.  If there are no selections, its value will be
;			the null string: ''.
;
;
; RETURN:
;	NONE
;
;
; PROCEDURE:
;	brim may be run standalone or from within grim.  If no files or data
;	descriptors are given, brim first prompts the user to select a list of
;	files.  brim then displays thumbnails of all valid files.  Files may be
;	selected by clicking with the left mouse button.  By default, the image
;	is opened in a new grim window.  Alternate actions may be defined
;	through procedures supplied by the caller.
;
;
; EXAMPLES:
;	To load files into brim using a file-selection widget:
;
;	 IDL> brim
;
;
;	To load all recognizeable images in the current directory into brim:
;
;	 IDL> brim, '*'
;
;
;	To browse a set of data descriptors:
;
;	 IDL> dd = dat_read('*')
;	 IDL> brim, dd
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================



;=============================================================================
; brim_display_image
;
;
;=============================================================================
pro brim_display_image, brim_data, _i, image

 i = _i[0]

 if(NOT keyword_set(image)) then image = (*brim_data.images_p)[*,*,i]

 wset, brim_data.wnums[i]
 tvscl, image, order=brim_data.order

 if(keyword_set(brim_data.labels)) then $
    widget_control, brim_data.label_widgets[i], set_value=brim_data.labels[i]


end
;=============================================================================



;=============================================================================
; brim_resolve_ids
;
;
;=============================================================================
function brim_resolve_ids, brim_data, ids

 n = n_elements(ids)
 i = lonarr(n)
 for j=0, n-1 do $
  begin
   w = where(ids[j] EQ brim_data.ids)   
   if(w[0] NE -1) then i[j] = w[0]
  end

 return, i
end
;=============================================================================



;=============================================================================
; brim_load
;
;
;=============================================================================
pro brim_load, brim_data, files, display=display

 if(ptr_valid(brim_data.images_p)) then nv_ptr_free, brim_data.images_p


 n = n_elements(files)

 images = dblarr(brim_data.thumbsize, brim_data.thumbsize, n)

 for i=0, n-1 do $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if files is a string, then assume it gives filenames.
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(size(files, /type) EQ 7) then $
    begin
     _im = 0
     dd = dat_read(files[i], _im);, maintain=2)
     if(obj_valid(dd[0])) then nv_free, dd
    end $
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; otherwise, assume it gives data descriptors.
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   else  _im = dat_data(files[i])
; need to sample images with dat_data instead of congrid

   if(keyword_set(_im)) then $
    if((size(_im))[0] EQ 2) then $
     begin
      images[*,*,i] = congrid(_im, brim_data.thumbsize, brim_data.thumbsize)

      if(keyword_set(display)) then $
                  brim_display_image, brim_data, i, images[*,*,i]
     end
  end


 brim_data.images_p = nv_ptr_new(images)


 widget_control, brim_data.base, set_uvalue=brim_data
end
;=============================================================================



;=============================================================================
; brim_configure
;
;=============================================================================
function brim_configure, brim_data, n, files=files, base=base, $
     thumbsize=thumbsize, labels=labels, $
     select_ids=select_ids, $
     left_fn=left_fn, right_fn=right_fn, middle_fn=middle_fn, fn_data=fn_data, $
     exclusive_selection=exclusive_selection, path=path, get_path=get_path, $
     modal=modal, title=title, ids=ids, order=order, filter=filter, $
     enable_selection=enable_selection

 label_ysize = 30
; label_ysize = 22
 nmore = 0

 if(keyword_set(brim_data)) then $
  begin
   if(NOT defined(enable_selection)) then $
                           enable_selection = brim_data.enable_selection
   if(NOT defined(order)) then order = brim_data.order
   if(NOT defined(exclusive_selection)) then $
                           exclusive_selection = brim_data.exclusive_selection
   if(NOT defined(fn_data)) then fn_data = brim_data.fn_data
   if(NOT defined(middle_fn)) then middle_fn = brim_data.middle_fn  
   if(NOT defined(right_fn)) then right_fn = brim_data.right_fn
   if(NOT defined(left_fn)) then left_fn = brim_data.left_fn  
   if(NOT defined(thumbsize)) then thumbsize = brim_data.thumbsize

   draw_bases = brim_data.draw_bases
   scroll_base = brim_data.scroll_base
   draw_widgets = brim_data.draw_widgets
   label_widgets = brim_data.label_widgets
   wnums = brim_data.wnums

   if(ptr_valid(brim_data.select_ids_p)) then nv_ptr_free, brim_data.select_ids_p
   if(ptr_valid(brim_data.images_p)) then nv_ptr_free, brim_data.images_p

   n = n_elements(brim_data.draw_bases)
   nmore = n_elements(files) - n
   if(nmore NE 0) then base = brim_data.base
  end 

 ;------------------------------------
 ; widgets
 ;------------------------------------
 if(nmore LT 0) then $
  begin
   widget_control, /destroy, brim_data.draw_bases[n-1]
   draw_bases = brim_data.draw_bases[0:n-2]
   draw_widgets = brim_data.draw_widgets[0:n-2]
   label_widgets = brim_data.label_widgets[0:n-2]
   wnums = brim_data.wnums[0:n-2]
  end

 if(keyword_set(base) OR (nmore GT 0)) then $
  begin
;   done_button = widget_button(base, value='Done')

   scroll_base = widget_info(base, /child)
   widget_control, scroll_base, get_uvalue=nx

   nn = n + nmore
   ny = nn/nx + (nn mod nx NE 0)

   xsize = 600 < nx*thumbsize * 1.1
   ysize = 800 < (ny*(thumbsize + label_ysize) * 1.1)

   widget_control, scroll_base, scr_xsize=xsize, scr_ysize=ysize
;   widget_control, base, scr_xsize=xsize, scr_ysize=ysize

   nnn = nn
   if(keyword_set(brim_data)) then nnn = nmore
   for i=0, nnn-1 do $
    begin
     draw_base = widget_base(scroll_base, xpad=0, ypad=0, $
                     xsize=thumbsize, ysize=thumbsize+label_ysize, /frame, /col)
     draw_bases = append_array(draw_bases, draw_base)

     draw_widget = $
         widget_draw(draw_base, xsize=thumbsize, ysize=thumbsize, $
                 /button_events, event_pro='brim_draw_event', /motion_events,  $
                 retain=2, /tracking_events)
     draw_widgets = append_array(draw_widgets, draw_widget)

     label_widget = $
;          widget_label(draw_base, /align_left, xsize=thumbsize, value=' ')
          widget_text(draw_base, /align_left, xsize=thumbsize, value=' ')
     label_widgets = append_array(label_widgets, label_widget)
    end


   widget_control, /realize, base
   wnums = lonarr(nn)
   for i=0, nn-1 do $
    begin
     widget_control, draw_widgets[i], get_value=wnum
     wnums[i] = wnum
    end

  end


 ;----------------------------------
 ; data structure
 ;----------------------------------
 if(NOT keyword_set(base)) then base = brim_data.base

 if(NOT keyword_set(labels)) then $
  begin
   fnames = cor_name(files)
   split_filename, fnames, dirs, labels
  end
 if(keyword_set(ids)) then $
  begin
   w = str_isnum(strtrim(ids,2))
   if( (w[0] NE -1) AND $
           (n_elements(w) EQ n_elements(labels)) ) then $
                               labels = strtrim(ids,2) + ':' + labels
  end

 if(NOT keyword_set(ids)) then ids = labels

 if(exclusive_selection) then $
          if(NOT defined(select_ids)) then select_ids = ids[0]
 if(NOT exclusive_selection) then $
          if(NOT defined(select_ids)) then select_ids = ''

 brim_data = { $
		base			:	base, $
		select_ids_p		:	nv_ptr_new(select_ids), $
		enable_selection	:	enable_selection, $
		left_fn			:	left_fn, $
		middle_fn		:	middle_fn, $
		right_fn		:	right_fn, $
		fn_data			:	fn_data, $
		images_p		:	nv_ptr_new(), $
		wnums			:	wnums, $
		draw_bases		:	draw_bases, $
		scroll_base		:	scroll_base, $
		draw_widgets		:	draw_widgets, $
		label_widgets		:	label_widgets, $
		labels			:	labels, $
		ids			:	ids, $
		exclusive_selection	:	exclusive_selection, $
		files			:	files, $
		order			:	order, $
		base_xsize		:	0l, $
		base_ysize		:	0l, $
		scroll_xsize		:	0l, $
		scroll_ysize		:	0l, $
		thumbsize		:	thumbsize $
	}

 geom = widget_info(base, /geom)
 brim_data.base_xsize = geom.xsize
 brim_data.base_ysize = geom.ysize

 geom = widget_info(scroll_base, /geom)
 brim_data.scroll_xsize = geom.scr_xsize
 brim_data.scroll_ysize = geom.scr_ysize

 widget_control, base, set_uvalue=brim_data

 ;----------------------------------
 ; load and display images
 ;----------------------------------
 widget_control, /hourglass
 brim_load, brim_data, files, /display

 return, brim_data
end
;=============================================================================



;=============================================================================
; brim_select
;
;
;=============================================================================
pro brim_select, brim_data, _i, id=id, dd=dd

; ;------------------------------------------
; ; if dd given, then need to reload images
; ;------------------------------------------
; if(keyword__set(dd)) then $
;  begin
;   brim_data = brim_configure(brim_data, files=dd, id=id)
;  end


 if(NOT brim_data.enable_selection) then return

 ;-------------------------------------
 ; resolve ids if necessary
 ;-------------------------------------
 if(keyword__set(id)) then i = brim_resolve_ids(brim_data, _i) $
 else i = _i

 new_selection = 1
 ;------------------------------------------
 ; exclusive selection
 ;------------------------------------------
 if(brim_data.exclusive_selection) then $
  begin 
   ;- - - - - - - - - - - - - - - -
   ; erase current selection
   ;- - - - - - - - - - - - - - - -
   ii = brim_resolve_ids(brim_data, *brim_data.select_ids_p)
   brim_display_image, brim_data, ii

   ;- - - - - - - - - - - - - - - -
   ; set new selection
   ;- - - - - - - - - - - - - - - -
   *brim_data.select_ids_p = brim_data.ids[i]
  end $
 ;------------------------------------------
 ; general selection
 ;------------------------------------------
 else $
  begin
   if((*brim_data.select_ids_p)[0] EQ '') then $
                                  *brim_data.select_ids_p = brim_data.ids[i] $
   else $
    begin
     w = where(*brim_data.select_ids_p EQ brim_data.ids[i])

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; add selection if not already selected, otherwise delete selection
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if(w[0] EQ -1) then $
       *brim_data.select_ids_p = [*brim_data.select_ids_p, brim_data.ids[i]] $
     else $
      begin
       *brim_data.select_ids_p = $
                           rm_list_item(*brim_data.select_ids_p, w[0], only='')
       brim_display_image, brim_data, i
       new_selection = 0
      end
    end
  end

 ;------------------------------------------
 ; highlight new selection
 ;------------------------------------------
 if(new_selection) then $
  begin
   wset, brim_data.wnums[i]

   xs = !d.x_size-3
   ys = !d.y_size-3
   plots, [1,xs,xs,1,1], [1,1,ys,ys,1], /device, col=ctred(), th=2
  end


 widget_control, brim_data.base, set_uvalue=brim_data
end
;=============================================================================



;=============================================================================
; brim_fn_grim
;
;=============================================================================
pro brim_fn_grim, brim_data, i, label, status=status

 status = 0

 if(size(brim_data.files, /type) EQ 7) then dd = dat_read(brim_data.files[i]) $
 else dd = brim_data.files[i]

 widget_control, /hourglass

 if(brim_data.order NE -1) then order = brim_data.order
 grim, /new, dd, order=order

end
;=============================================================================



;=============================================================================
; brim_event
;
;=============================================================================
pro brim_event, event

 base = event.top
 widget_control, base, get_uvalue=brim_data 
 struct = tag_names(event, /struct)

 ;-----------------------------------------------
 ; adjust base size
 ;-----------------------------------------------
 if(struct EQ 'WIDGET_BASE') then $
  begin
   dx = event.x - brim_data.base_xsize
   dy = event.y - brim_data.base_ysize

   widget_control, brim_data.scroll_base, $
         scr_xsize=brim_data.scroll_xsize+dx, scr_ysize=brim_data.scroll_ysize+dy

   geom = widget_info(base, /geom)
   brim_data.base_xsize = geom.xsize
   brim_data.base_ysize = geom.ysize

   geom = widget_info(brim_data.scroll_base, /geom)
   brim_data.scroll_xsize = geom.scr_xsize
   brim_data.scroll_ysize = geom.scr_ysize

   widget_control, base, set_uvalue=brim_data
   return
  end


 widget_control, brim_data.base, /destroy

end
;=============================================================================



;=============================================================================
; brim_draw_event
;
;=============================================================================
pro brim_draw_event, event


 widget_control, event.top, get_uvalue=brim_data 

 i = where(event.id EQ brim_data.draw_widgets)

 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then return

 ;--------------------------
 ; motion events
 ;--------------------------
 if(event.type EQ 2) then $
  begin
   wset, brim_data.wnums[i]
   device, cursor_standard=60
  end

 ;--------------------------
 ; button-press events
 ;--------------------------
 if(event.type NE 0) then return 

 fn_data = brim_data.fn_data
 if(NOT keyword_set(fn_data)) then fn_data = brim_data

 case event.press of
  1 : $
   begin
    status = 0
    if(keyword__set(brim_data.left_fn)) then $
           call_procedure, brim_data.left_fn, fn_data, i, $
                                          brim_data.ids[i], status=status
    if(status EQ 0) then brim_select, brim_data, i
   end
  2 : if(keyword__set(brim_data.middle_fn)) then $
           call_procedure, brim_data.middle_fn, fn_data, i, $
                                          brim_data.ids[i], status=status
  4 : if(keyword__set(brim_data.right_fn)) then $
           call_procedure, brim_data.right_fn, fn_data, i, $
                                          brim_data.ids[i], status=status
  else:
 endcase


end
;=============================================================================



;=============================================================================
; brim
;
;=============================================================================
pro brim, files, thumbsize=thumbsize, labels=labels, select_ids=select_ids, $
     left_fn=left_fn, right_fn=right_fn, middle_fn=middle_fn, fn_data=fn_data, $
     exclusive_selection=exclusive_selection, path=path, get_path=get_path, $
     modal=modal, title=title, ids=ids, order=order, filter=filter, $
     enable_selection=enable_selection, base=base

 if(NOT defined(left_fn)) then left_fn = 'brim_fn_grim'

 if(NOT defined(middle_fn)) then middle_fn = ''
 if(NOT defined(right_fn)) then right_fn = ''
 if(NOT keyword_set(fn_data)) then fn_data = ''
 if(NOT keyword_set(exclusive_selection)) then exclusive_selection = 0
 if(NOT keyword_set(order)) then order = -1
 enable_selection = keyword_set(enable_selection)
 if(NOT keyword_set(thumbsize)) then thumbsize = 100

 ;----------------------------------
 ; select files if none given
 ;----------------------------------
 if(NOT keyword_set(files)) then $
  begin
   files = $
    pickfiles(get_path=get_path, title='Select files to load', $
                                               path=path, filter=filter)
   if(NOT keyword_set(files[0])) then return
  end 
 
 ;---------------------------------------------------------
 ; resolve any file specifications and determine filetypes
 ;---------------------------------------------------------
 if(size(files, /type) EQ 7) then $
  begin
   for i=0, n_elements(files)-1 do $
    begin
     if(strpos(files[i], '/') EQ -1) then files[i] = pwd() + '/' + files[i]
     ff = file_search(files[i])
     if(keyword_set(ff)) then _files = append_array(_files, ff)
    end
   if(NOT keyword_set(_files)) then return
   files = _files

   w = where(files NE '')
   if(w[0] EQ -1) then return
   files = files[w]

   w = where(strpos(files,':') EQ -1)
   if(w[0] EQ -1) then return
   files = files[w]

   w = where(strpos(files,'/') NE -1)
   if(w[0] EQ -1) then return
   files = files[w]

   if(NOT keyword_set(files)) then return

   split_filename, files, dirs, names
   labels = names  
  end

 ;----------------------------------
 ; geometry
 ;----------------------------------
 n = n_elements(files) 

 nx = sqrt(n)
 if((nx mod 1) NE 0) then nx = fix(nx) + 1

 ;----------------------------------
 ; widgets
 ;----------------------------------
 if(NOT keyword_set(title)) then title = 'BRIM'

; base = widget_base(title=title, /column, /tlb_size_events)
 base = widget_base(title=title, /tlb_size_events)

 scroll_base = widget_base(base, xpad=0, ypad=0, /scroll, col=nx, space=0)
 widget_control, scroll_base, set_uvalue=nx

 brim_data = brim_configure(0, n, files=files, base=base, $
     thumbsize=thumbsize, labels=labels, $
     select_ids=select_ids, $
     left_fn=left_fn, right_fn=right_fn, middle_fn=middle_fn, fn_data=fn_data, $
     exclusive_selection=exclusive_selection, path=path, get_path=get_path, $
     modal=modal, title=title, ids=ids, order=order, filter=filter, $
     enable_selection=enable_selection)



 ;----------------------------------
 ; show initial selections
 ;----------------------------------
 if(keyword_set(select_ids)) then brim_select, brim_data, select_ids, /id


 no_block = 1
 if(keyword_set(modal)) then no_block = 0
 xmanager, 'brim', base, no_block=no_block


 select_ids = *brim_data.select_ids_p
end
;=============================================================================
