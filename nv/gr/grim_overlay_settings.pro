;=============================================================================
; gros_user_tag
;
;=============================================================================
function gros_user_tag, i, name
 return, strupcase('USER_' + name + '_' + strtrim(i, 2))
end
;=============================================================================



;=============================================================================
; gros_overlay_tag
;
;=============================================================================
function gros_overlay_tag, i, name
 return, strupcase('OVERLAY_' + name + '_' + strtrim(i, 2))
end
;=============================================================================



;=============================================================================
; gros_update_form
;
;=============================================================================
pro gros_update_form, grim_data, plane, base

 widget_control, base, get_uvalue=data

 data.grim_data = grim_data
 data.plane = plane



 ;-----------------------------------------------------
 ; record user base size
 ;-----------------------------------------------------
 if(data.user_exists) then $
  begin
   w_user_base_0 = (where(data.tags EQ 'USER_BASE_0'))[0]
   w_base = (where(data.tags EQ 'OVERLAY_BASE'))[0]
   w_scroll_label = (where(data.tags EQ 'SCROLL_LABEL'))[0]

   if(NOT keyword__set(data.scroll_base_xsize)) then $
    begin
     geom_user_base_0 = widget_info(data.ids[w_user_base_0], /geometry)
     data.scroll_base_xsize = geom_user_base_0.xsize

     geom_base = widget_info(data.ids[w_base], /geometry)
     geom_scroll_label = widget_info(data.ids[w_scroll_label], /geometry)

     data.scroll_base_ysize = geom_base.ysize - 2*geom_scroll_label.ysize
    end


   ;-----------------------------------------------------
   ; if no user overlays, unmap that section
   ;-----------------------------------------------------
   user_ptd = grim_get_user_ptd(plane=plane, $
                            utags, color=user_colors, psym=user_psyms, symsize=user_psizes)

   if(NOT keyword_set(user_ptd)) then $
    begin 
     w_user_base = (where(data.tags EQ 'USER_BASE'))[0]
     widget_control, data.ids[w_user_base], map=0

     w_scroll_base = (where(data.tags EQ 'SCROLL_BASE'))[0]
     widget_control, data.ids[w_scroll_base], xsize=1
    end $ 
   ;---------------------------------------------------------
   ; otherwise, fill in user info and map only used fields
   ;---------------------------------------------------------
   else $
    begin 
     w = (where(data.tags EQ 'USER_BASE'))[0]
     widget_control, data.ids[w[0]], map=1

     *data.utags_p = utags

     npad = max(strlen(utags))
     n_utags = n_elements(utags)
     for i=0, data.n_utags_max-1 do $
      begin
       base_tag = gros_user_tag(i, 'base')
       w_base = where(data.tags EQ base_tag)


       if(i LT n_utags) then $
        begin
;stop
         w = where(data.colors EQ user_colors[i])

         grim_set_form_entry, $
             data.ids, data.tags, gros_user_tag(i, 'label'), $
                                str_pad(utags[i], data.user_label_len-2) + ' :'
         grim_set_form_entry, $
             data.ids, data.tags, gros_user_tag(i, 'color'), w[0], /drop
         grim_set_form_entry, $
             data.ids, data.tags, gros_user_tag(i, 'psym'), user_psyms[i]
         grim_set_form_entry, $
             data.ids, data.tags, gros_user_tag(i, 'psize'), user_psizes[i]

         widget_control, data.ids[w_base[0]], map=1
        end $
       else widget_control, data.ids[w_base[0]], map=0
      end

     ;- - - - - - - - - - - - - - - - - - - - - -
     ; set width/height of user scroll base
     ;- - - - - - - - - - - - - - - - - - - - - -
     w_scroll_base = (where(data.tags EQ 'SCROLL_BASE'))[0]
     widget_control, data.ids[w_scroll_base], $
                   xsize=data.scroll_base_xsize, ysize=data.scroll_base_ysize
    end
  end


 ;-----------------------------------------------------
 ; set form entries
 ;-----------------------------------------------------
 if(keyword_set(utags)) then  $
  for i=0, n_utags-1 do $
   begin
    grim_set_form_entry, data.ids, data.tags, $
                                 gros_user_tag(i, 'psym'), user_psyms[i]
    grim_set_form_entry, data.ids, data.tags, $
                                 gros_user_tag(i, 'psize'), user_psizes[i]
   end

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; overlay colors
 ;- - - - - - - - - - - - - - - - - - - - - - -
 colors = *plane.overlay_color_p
 for i=0, n_elements(colors)-1 do $
  begin
   w = where(data.colors EQ colors[i])
   grim_set_form_entry, data.ids, data.tags, gros_overlay_tag(i,'color'), w[0], /drop
  end

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; overlay psyms
 ;- - - - - - - - - - - - - - - - - - - - - - -
 psyms = *plane.overlay_psym_p
 for i=0, n_elements(psyms)-1 do $
      grim_set_form_entry, data.ids, data.tags, $
                                 gros_overlay_tag(i,'psym'), strtrim(psyms[i], 2)

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; overlay symsizes
 ;- - - - - - - - - - - - - - - - - - - - - - -
 symsizes = *plane.overlay_symsize_p
 for i=0, n_elements(symsizes)-1 do $
      grim_set_form_entry, data.ids, data.tags, $
                                 gros_overlay_tag(i,'symsize'), strtrim(symsizes[i], 2)

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; overlay label toggles
 ;- - - - - - - - - - - - - - - - - - - - - - -
 tlabs = *plane.overlay_tlab_p NE 1
 for i=0, n_elements(tlabs)-1 do $
        grim_set_form_entry, data.ids, data.tags, $
                               gros_overlay_tag(i,'tlabels'), tlabs[i], /cwbutton

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; overlay shading toggles
 ;- - - - - - - - - - - - - - - - - - - - - - -
 tshades = *plane.overlay_tshade_p NE 1
 for i=0, n_elements(tshades)-1 do $
        grim_set_form_entry, data.ids, data.tags, $
                               gros_overlay_tag(i,'tshades'), tshades[i], /cwbutton

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; fov
 ;- - - - - - - - - - - - - - - - - - - - - - -
 fov = plane.fov
 grim_set_form_entry, data.ids, data.tags, 'FOV', strtrim(fov,2)


 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; max
 ;- - - - - - - - - - - - - - - - - - - - - - -
 max = plane.max
 grim_set_form_entry, data.ids, data.tags, 'MAX', strtrim(max,2)


 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; hide
 ;- - - - - - - - - - - - - - - - - - - - - - -
 hide = plane.hide EQ 0
 grim_set_form_entry, data.ids, data.tags, 'HIDE', hide, /cwbutton

 ;- - - - - - - - - - - - - - - - - - - - - - -
 ; translator args
 ;- - - - - - - - - - - - - - - - - - - - - - -
 grim_set_form_entry, data.ids, data.tags, 'TRS_CD', plane.trs_cd
 grim_set_form_entry, data.ids, data.tags, 'TRS_PD', plane.trs_pd
 grim_set_form_entry, data.ids, data.tags, 'TRS_RD', plane.trs_rd
 grim_set_form_entry, data.ids, data.tags, 'TRS_SD', plane.trs_sd
 grim_set_form_entry, data.ids, data.tags, 'TRS_STD', plane.trs_std
 grim_set_form_entry, data.ids, data.tags, 'TRS_STD', plane.trs_ard
 grim_set_form_entry, data.ids, data.tags, 'TRS_SUND', plane.trs_sund


 widget_control, base, set_uvalue=data
end
;=============================================================================



;=============================================================================
; gros_cleanup
;
;=============================================================================
pro gros_cleanup, base
common grim_overlay_settings_block, tops

 widget_control, base, get_uvalue=data

 w = where(tops EQ data.top)
 if(w[0] NE -1) then tops = rm_list_item(tops, w, only=-1)

end
;=============================================================================



;=============================================================================
; gros_apply_settings
;
;=============================================================================
pro gros_apply_settings, data
@grim_constants.common

 grim_data = data.grim_data
 if(NOT grim_exists(grim_data)) then return
 use_pixmap = 1

 ;--------------------
 ; all
 ;--------------------
 all = grim_parse_form_entry(data.ids, data.tags, 'all') NE 1

 planes = data.plane
 if(all) then planes = grim_get_plane(grim_data, /all)


 onoff = ['ON', 'OFF']

 nplanes = n_elements(planes)
 for i=0, nplanes-1 do $
  begin
   ;-----------------------
   ; fov
   ;-----------------------
   planes[i].fov = float(grim_parse_form_entry(data.ids, data.tags, 'FOV', /string))

   ;-----------------------
   ; max
   ;-----------------------
   newmax = float(grim_parse_form_entry(data.ids, data.tags, 'MAX', /string))
   if(newmax - planes[i].max GT 1d-3) then use_pixmap = 0
   planes[i].max = newmax

   ;-----------------------
   ; hide
   ;-----------------------
   planes[i].hide = byte(grim_parse_form_entry(data.ids, data.tags, 'HIDE') EQ 0)

   ;-----------------------
   ;  overlay colors
   ;-----------------------
   colors = *planes[i].overlay_color_p
   for j=0, n_elements(colors)-1 do $
     colors[j] = data.colors[grim_parse_form_entry(data.ids, data.tags, $
                                         gros_overlay_tag(j,'color'), /drop)]
   *planes[i].overlay_color_p = colors

   ;-----------------------
   ; overlay psyms
   ;-----------------------
   psyms = *planes[i].overlay_psym_p
   for j=0, n_elements(psyms)-1 do $
     psyms[j] = fix(grim_parse_form_entry(data.ids, data.tags, $
                                                  gros_overlay_tag(j,'psym')))
   *planes[i].overlay_psym_p = psyms
 
   ;-----------------------
   ; overlay symsizes
   ;-----------------------
   symsizes = *planes[i].overlay_symsize_p
   for j=0, n_elements(symsizes)-1 do $
     symsizes[j] = float(grim_parse_form_entry(data.ids, data.tags, $
                                                  gros_overlay_tag(j,'symsize')))
   *planes[i].overlay_symsize_p = symsizes

   ;-----------------------
   ; overlay label toggles
   ;-----------------------
   tlabs = *planes[i].overlay_tlab_p
   for j=0, n_elements(tlabs)-1 do $
     tlabs[j] = grim_parse_form_entry(data.ids, data.tags, $
                                        gros_overlay_tag(j,'tlabels')) NE 1
   *planes[i].overlay_tlab_p = tlabs

   ;-----------------------
   ; overlay shading
   ;-----------------------
   tshades = *planes[i].overlay_tshade_p
   for j=0, n_elements(tshades)-1 do $
     tshades[j] = grim_parse_form_entry(data.ids, data.tags, $
                                        gros_overlay_tag(j,'tshades')) NE 1
   *planes[i].overlay_tshade_p = tshades

   ;-----------------------
   ; descriptors
   ;-----------------------
   trs_cd = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_CD', /string), 2)
   trs_pd = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_PD', /string), 2)
   trs_rd = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_RD', /string), 2)
   trs_sd = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_SD', /string), 2)
   trs_std = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_STD', /string), 2)
   trs_ard = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_ARD', /string), 2)
   trs_sund = strtrim(grim_parse_form_entry($
                        data.ids, data.tags, 'TRS_SUND', /string), 2)

   if(trs_cd NE planes[i].trs_cd) then grim_mark_descriptors, grim_data, /cd, plane=planes[i], MARK_STALE
   if(trs_pd NE planes[i].trs_pd) then grim_mark_descriptors, grim_data, /pd, plane=planes[i], MARK_STALE
   if(trs_rd NE planes[i].trs_rd) then grim_mark_descriptors, grim_data, /rd, plane=planes[i], MARK_STALE
   if(trs_sd NE planes[i].trs_sd) then grim_mark_descriptors, grim_data, /sd, plane=planes[i], MARK_STALE
   if(trs_std NE planes[i].trs_std) then grim_mark_descriptors, grim_data, /std, plane=planes[i], MARK_STALE
   if(trs_ard NE planes[i].trs_ard) then grim_mark_descriptors, grim_data, /ard, plane=planes[i], MARK_STALE
   if(trs_sund NE planes[i].trs_sund) then grim_mark_descriptors, grim_data, /sund, plane=planes[i], MARK_STALE

   planes[i].trs_cd = trs_cd
   planes[i].trs_pd = trs_pd
   planes[i].trs_rd = trs_rd
   planes[i].trs_sd = trs_sd
   planes[i].trs_std = trs_std
   planes[i].trs_ard = trs_ard
   planes[i].trs_sund = trs_sund


   ;-----------------------
   ; user array settings
   ;-----------------------
   utags = *data.utags_p
   n_utags = n_elements(utags)
   if(keyword__set(utags)) then $
    for j=0, n_utags-1 do $
     begin
      user_ptd = grim_get_user_ptd(plane=planes[i], utags[j], shade_fn=shade_fn, $
                          graphics_fn=graphics_fn, xgraphics=xgraphics)

      psym = ''
      _psym = grim_parse_form_entry(data.ids, data.tags, $
                                               gros_user_tag(j, 'psym'), /num)
      if((_psym[0] GT -8) AND (_psym[0] LT 8)) then psym = _psym $
      else grim_message, 'Invalid psym for user overlay ' + utags[j] + '.'
  
      psize = ''
      _psize = grim_parse_form_entry(data.ids, data.tags, $
                                               gros_user_tag(j, 'psize'), /num)
      psize = _psize    

      col = data.colors[grim_parse_form_entry(data.ids, data.tags, $
                                       gros_user_tag(j, 'color'), /drop)]
      grim_add_user_points, /update, /nodraw, user_ptd, utags[j], plane=planes[i], $
         color=col, psym=psym, symsize=psize, shade_fn=shade_fn, graphics_fn=graphics_fn, xgraphics=xgraphics
     end


   grim_set_plane, grim_data, planes[i], pn=planes[i].pn
   grim_set_data, grim_data, grim_data.base

  end

 grim_refresh, grim_data, use_pixmap=use_pixmap
end
;=============================================================================



;=============================================================================
; gros_ok
;
;=============================================================================
pro gros_ok, data, base

 gros_apply_settings, data
 widget_control, base, /destroy

end
;=============================================================================



;=============================================================================
; grim_overlay_settings_event
;
;=============================================================================
pro grim_overlay_settings_event, event

 ;-----------------------------------------------
 ; get form base and data
 ;-----------------------------------------------
 base = event.top
 widget_control, base, get_uvalue=data

 ;-----------------------------------------------
 ; get form value structure
 ;-----------------------------------------------
 widget_control, event.id, get_value=value


 ;-----------------------------------------------
 ; switch on item tag
 ;-----------------------------------------------
 if(size(value, /type) EQ 7) then $
  case strupcase(value) of
   ;---------------------------------------------------------
   ; 'Cancel' button --
   ;  Just destroy the form and forget about it
   ;---------------------------------------------------------
   'CANCEL' :  widget_control, base, /destroy

   ;---------------------------------------------------------
   ; 'Apply' button --
   ;  Apply the current settings.
   ;---------------------------------------------------------
   'APPLY' : gros_apply_settings, data

   ;---------------------------------------------------------
   ; 'Ok' button --
   ;  Apply the current settings and destroy the form.
   ;---------------------------------------------------------
   'OK' : gros_ok, data, base

   else: if(size(event.value, /type) EQ 7) then gros_ok, data, base
  endcase


end
;=============================================================================



;=============================================================================
; grim_overlay_settings
;
;=============================================================================
pro grim_overlay_settings, grim_data, plane
common grim_overlay_settings_block, tops

 if(NOT keyword_set(tops)) then tops = -1

 ;------------------------------------------------------------
 ; only one overlay settings widget allowed per grim window
 ;------------------------------------------------------------
 top = grim_data.base
 if(tops[0] EQ -1) then tops = top $
 else $
  begin
   w = where(tops EQ top)
   if(w[0] NE -1) then return
   tops = [tops, top]
  end



 ;-----------------------------------------------
 ; settings form widget
 ;-----------------------------------------------
 base = widget_base(/column, $
       title = 'Overlay Settings - grim ' + strtrim(grim_data.grnum,2));, /tlb_size_events)

 blank = '0'
 colors = ['red', $
           'brown', $
           'orange', $
           'yellow', $
           'green', $
           'blue', $
           'cyan', $
           'pink', $
           'purple', $
           'white', $
           'hidden']
 ncolors = n_elements(colors)
 dl_colors = colors[0]
 for i=1, ncolors-1 do dl_colors = dl_colors + '|' + colors[i]

 hide_modes = ['Obscured', 'Shadowed']
 nhide = n_elements(hide_modes)
 dl_hide = hide_modes[0]
 for i=1, nhide-1 do dl_hide = dl_hide + '|' + hide_modes[i]


 ;- - - - - - - - - - - - - - - - - - - - - -
 ; settings for standard overlays
 ;- - - - - - - - - - - - - - - - - - - - - -
 desc = [ $
	'1, TAB,, TAG=tab', $

	'1, BASE,, COLUMN, FRAME, TITLE=Standard Overlays, TAG=overlay_base', $
	  '1, BASE,, ROW, FRAME, TAG=fov_base', $
	    '0, BUTTON, On|Off, EXCLUSIVE, ROW, LABEL_LEFT=All: , SET_VALUE=1, TAG=all', $
	    '0, BUTTON, On|Off, EXCLUSIVE, ROW, LABEL_LEFT= Hide: , SET_VALUE=1, TAG=hide', $
	    '0, TEXT,, LABEL_LEFT=  Max :, WIDTH=5, TAG=max', $
	    '2, TEXT,, LABEL_LEFT=  FOV :, WIDTH=5, TAG=fov']

; desc = [desc, $
;	'1, BASE,, ROW, FRAME, TAG=hide_base', $
;	  '0, BUTTON, ' + dl_hide + ', COLUMN, LABEL_LEFT= Hide:, SET_VALUE=0, TAG=_hide', $
;	  '2, BUTTON, On|Off, EXCLUSIVE, COLUMN, LABEL_LEFT= Invert:, SET_VALUE=0, TAG=invert']

   desc = [desc, $
	'1, BASE,, ROW, TAG=overlay_label_base', $
	  '2, LABEL, Overlay                Color    Psym   Size       Labels         Shading, CENTER']

 overlay_label_len = 15
 ptdps = grim_get_overlay_ptdp(grim_data, plane=plane, 'all')
 nptdps = n_elements(ptdps)

 for i=0, nptdps-1 do $
  begin
   name = ''
   ptdp = grim_get_overlay_ptdp(grim_data, name, plane=plane, ii=i)
   label =  str_pad(name, overlay_label_len) + ':'

   desc = [desc, $
	'1, BASE,, ROW, TAG=overlay_base_' + strtrim(i,2), $
	  '0, LABEL, ' + label + ', LEFT, TAG=' + gros_overlay_tag(i,'label'), $
	  '0, DROPLIST,' + dl_colors + ', TAG=' + gros_overlay_tag(i,'color') + $
	       ',SET_VALUE=', $
	  '0, TEXT,, WIDTH=2, TAG=' + gros_overlay_tag(i,'psym'), $
	  '0, TEXT,, WIDTH=5, TAG=' + gros_overlay_tag(i,'symsize'), $
	  '0, BUTTON, On|Off, EXCLUSIVE, ROW, SET_VALUE=' + blank + $
	           ', TAG=' + gros_overlay_tag(i,'tlabels'), $
	  '2, BUTTON, On|Off, EXCLUSIVE, ROW, SET_VALUE=' + blank + $
	           ', TAG=' + gros_overlay_tag(i,'tshades')]
;	  '2, BUTTON, Labels|Shading, ROW, SET_VALUE=' + blank + $
;	           ', TAG=' + gros_overlay_tag(i,'tshades')]
  end

 desc = [desc, $
        '2, LABEL, , CENTER']

 ;- - - - - - - - - - - - - - - - - - - - - -
 ; settings for descriptors
 ;- - - - - - - - - - - - - - - - - - - - - -
 desc = [desc, $
	'1, BASE,, COLUMN, TITLE=Translator Arguments, FRAME, TAG=xd_base', $
	  '0, TEXT,, LABEL_LEFT= Camera :, WIDTH=60, TAG=trs_cd', $
	  '0, TEXT,, LABEL_LEFT= Planet :, WIDTH=60, TAG=trs_pd', $
	  '0, TEXT,, LABEL_LEFT= Ring   :, WIDTH=60, TAG=trs_rd', $
	  '0, TEXT,, LABEL_LEFT= Star   :, WIDTH=60, TAG=trs_sd', $
	  '0, TEXT,, LABEL_LEFT= Station:, WIDTH=60, TAG=trs_std', $
	  '0, TEXT,, LABEL_LEFT= Array  :, WIDTH=60, TAG=trs_ard', $
	  '2, TEXT,, LABEL_LEFT= Sun    :, WIDTH=60, TAG=trs_sund']

 ;- - - - - - - - - - - - - - - - - - - - - -
 ; settings for user overlays
 ;- - - - - - - - - - - - - - - - - - - - - -
 n_utags_max = 256
 user_label_len = 40
 user_ptd = grim_get_user_ptd(plane=plane)
 user_exists = keyword_set(user_ptd)
 if(user_exists) then $
  begin
   desc = [desc, $
	'1, BASE,, COLUMN, TITLE=User Overlays, FRAME, TAG=user_base', $
	  '0, LABEL, Name                                     Color    Psym   Size, TAG=scroll_label', $
	  '3, BASE,, COLUMN, FRAME, SCROLL, TAG=scroll_base']

   junk = str_pad('--------------------------------------------', user_label_len)

   for i=0, n_utags_max-1 do $
    begin
     desc = [desc, $
	'1, BASE,, ROW, TAG=user_base_' + strtrim(i,2), $
	  '0, LABEL, ' + junk + ', LEFT, TAG=' + gros_user_tag(i,'label'), $
	  '0, DROPLIST,' + dl_colors + ', TAG=' + gros_user_tag(i,'color') + $
	       ',SET_VALUE=', $
	  '0, TEXT,, WIDTH=2, TAG=' + gros_user_tag(i,'psym'), $
	  '2, TEXT,, WIDTH=5, TAG=' + gros_user_tag(i,'psize')]
    end
 
   desc = [desc, $
         '2, LABEL, , CENTER']
  end


 ;-----------------------------------------------------
 ; create the form widget
 ;-----------------------------------------------------
 form = cw__form(base, desc, ids=ids, tags=tags)
 widget_control, form, set_uvalue={ids:ids, tags:tags, colors:colors}

 button_base = widget_base(base, /row)
 ok_button = widget_button(button_base, value='Ok')
 apply_button = widget_button(button_base, value='Apply')
 cancel_button = widget_button(button_base, value='Cancel')


 ;-----------------------------------------------
 ; save data
 ;-----------------------------------------------
 data = { $
		base			:	base, $
		ids			:	ids, $
		tags			:	tags, $
		colors			:	colors, $
		top			:	top, $
		user_exists		:	user_exists, $
		utags_p			:	nv_ptr_new(0), $
		n_utags_max		:	n_utags_max, $
		user_label_len		:	user_label_len, $
		scroll_base_xsize	:	0, $
		scroll_base_ysize	:	0, $
		grim_data		:	grim_data, $
		data_p			:	nv_ptr_new(), $
		plane			:	plane $
	     }

 data.data_p = nv_ptr_new(data)
 widget_control, base, set_uvalue=data, map=0


 ;-----------------------------------------------------
 ; realize and register
 ;-----------------------------------------------------
 widget_control, base, /realize


 ;-----------------------------------------------------
 ; set initial form entries
 ;-----------------------------------------------------
 gros_update_form, grim_data, plane, base
 widget_control, base, /map


 xmanager, 'grim_overlay_settings', base, /no_block, cleanup='gros_cleanup'



end
;=============================================================================



