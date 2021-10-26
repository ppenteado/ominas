;=============================================================================
;+-+
; NAME:
;	OMIN --  OMINAS Installer
;
;
; PURPOSE:
;	Graphical installer and configuration tool for OMINAS.
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	omin
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	new:	If set, OMIN assumes this is a new installation.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	NONE
;
;
;
; STATUS:
;	Incomplete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2017
;	
;-
;=============================================================================



;=============================================================================
; omin_question_bitmap
;
;=============================================================================
function omin_question_bitmap

 return, [                               $
                [255B, 255B],                   $
                [031B, 252B],                   $
                [015B, 248B],                   $
                [231B, 243B],                   $
                [231B, 243B],                   $
                [255B, 243B],                   $
                [255B, 249B],                   $
                [255B, 252B],                   $
                [127B, 254B],                   $
                [063B, 255B],                   $
                [063B, 255B],                   $
                [063B, 255B],                   $
                [255B, 255B],                   $
                [063B, 255B],                   $
                [063B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_skull_bitmap
;
;=============================================================================
function omin_skull_bitmap

 return, [                               $
                [255B, 255B],                   $
                [063B, 248B],                   $
                [031B, 240B],                   $
                [223B, 246B],                   $
                [223B, 246B],                   $
                [031B, 241B],                   $
                [063B, 248B],                   $
                [183B, 218B],                   $
                [195B, 135B],                   $
                [031B, 241B],                   $
                [127B, 252B],                   $
                [031B, 241B],                   $
                [195B, 135B],                   $
                [247B, 223B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_hourglass_bitmap
;
;=============================================================================
function omin_hourglass_bitmap

 return, [                               $
                [255B, 255B],                   $
                [003B, 128B],                   $
                [247B, 223B],                   $
                [239B, 239B],                   $
                [031B, 240B],                   $
                [063B, 248B],                   $
                [127B, 252B],                   $
                [255B, 254B],                   $
                [127B, 253B],                   $
                [191B, 250B],                   $
                [223B, 247B],                   $
                [239B, 238B],                   $
                [007B, 192B],                   $
                [003B, 128B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_crack_bitmap
;
;=============================================================================
function omin_crack_bitmap

 return, [                               $
                [191B, 255B],                   $
                [063B, 255B],                   $
                [127B, 254B],                   $
                [255B, 252B],                   $
                [255B, 252B],                   $
                [127B, 254B],                   $
                [063B, 255B],                   $
                [063B, 255B],                   $
                [127B, 254B],                   $
                [255B, 252B],                   $
                [255B, 252B],                   $
                [127B, 254B],                   $
                [063B, 255B],                   $
                [063B, 255B],                   $
                [127B, 254B],                   $
                [255B, 252B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_web_bitmap
;
;=============================================================================
function omin_web_bitmap

 return, [                               $
                [126B, 191B],                   $
                [125B, 223B],                   $
                [059B, 238B],                   $
                [071B, 241B],                   $
                [103B, 243B],                   $
                [087B, 245B],                   $
                [059B, 238B],                   $
                [000B, 000B],                   $
                [059B, 238B],                   $
                [087B, 245B],                   $
                [103B, 243B],                   $
                [071B, 241B],                   $
                [059B, 238B],                   $
                [125B, 223B],                   $
                [126B, 191B],                   $
                [127B, 127B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_frame_bitmap
;
;=============================================================================
function omin_frame_bitmap

 return, [                               $
                [248B, 031B],                   $
                [254B, 127B],                   $
                [254B, 127B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [254B, 127B],                   $
                [254B, 127B],                   $
                [248B, 031B]                    $
             ]


end
;=============================================================================



;=============================================================================
; omin_split_bitmap
;
;=============================================================================
function omin_split_bitmap

 return, [                               $
                [255B, 255B],                   $
                [254B, 255B],                   $
                [252B, 255B],                   $
                [248B, 255B],                   $
                [240B, 255B],                   $
                [224B, 255B],                   $
                [192B, 255B],                   $
                [128B, 255B],                   $
                [000B, 255B],                   $
                [000B, 254B],                   $
                [000B, 252B],                   $
                [000B, 248B],                   $
                [000B, 240B],                   $
                [000B, 224B],                   $
                [000B, 192B],                   $
                [000B, 128B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_safe_bitmap
;
;=============================================================================
function omin_safe_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [007B, 192B],                   $
                [247B, 223B],                   $
                [247B, 207B],                   $
                [247B, 223B],                   $
                [119B, 220B],                   $
                [119B, 221B],                   $
                [119B, 220B],                   $
                [247B, 223B],                   $
                [247B, 207B],                   $
                [247B, 223B],                   $
                [007B, 192B],                   $
                [239B, 239B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_asleep_bitmap
;
;=============================================================================
function omin_asleep_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 225B],                   $
                [255B, 247B],                   $
                [255B, 251B],                   $
                [255B, 225B],                   $
                [255B, 255B],                   $
                [031B, 254B],                   $
                [127B, 255B],                   $
                [191B, 255B],                   $
                [031B, 254B],                   $
                [255B, 255B],                   $
                [195B, 255B],                   $
                [239B, 255B],                   $
                [247B, 255B],                   $
                [195B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_key_bitmap
;
;=============================================================================
function omin_key_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 207B],                   $
                [255B, 183B],                   $
                [255B, 183B],                   $
                [001B, 176B],                   $
                [245B, 183B],                   $
                [245B, 183B],                   $
                [255B, 207B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_padlock_bitmap
;
;=============================================================================
function omin_padlock_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [127B, 252B],                   $
                [191B, 251B],                   $
                [191B, 251B],                   $
                [191B, 251B],                   $
                [031B, 240B],                   $
                [223B, 247B],                   $
                [223B, 247B],                   $
                [223B, 247B],                   $
                [223B, 247B],                   $
                [031B, 240B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_plug_bitmap
;
;=============================================================================
function omin_plug_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [031B, 248B],                   $
                [223B, 247B],                   $
                [195B, 239B],                   $
                [223B, 239B],                   $
                [223B, 239B],                   $
                [223B, 239B],                   $
                [195B, 239B],                   $
                [223B, 247B],                   $
                [031B, 248B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_slash_bitmap
;
;=============================================================================
function omin_slash_bitmap

 return, [                               $
                [255B, 063B],                   $
                [255B, 031B],                   $
                [255B, 143B],                   $
                [255B, 199B],                   $
                [255B, 227B],                   $
                [255B, 241B],                   $
                [255B, 248B],                   $
                [127B, 252B],                   $
                [063B, 254B],                   $
                [031B, 255B],                   $
                [143B, 255B],                   $
                [199B, 255B],                   $
                [227B, 255B],                   $
                [241B, 255B],                   $
                [248B, 255B],                   $
                [252B, 255B]                    $
                ]


end
;=============================================================================



;=============================================================================
; omin_set_menu_string
;
;=============================================================================
pro omin_set_menu_string, base, name, string

 children = widget_info(base, /all_children)
 for i=0, n_elements(children)-1 do $
  if(keyword_set(children[i])) then $
   begin
    widget_control, children[i], get_uvalue=uvalue
    uvalue = strtrim(uvalue,2)
    if(uvalue EQ name) then $
     begin
      widget_control, children[i], set_value=string
      return
     end
    omin_set_menu_string, children[i], name, string
   end

end
;=============================================================================



;=============================================================================
; omin_set_menu_sensitivity
;
;=============================================================================
pro omin_set_menu_sensitivity, base, name, sensitivity

 children = widget_info(base, /all_children)
 for i=0, n_elements(children)-1 do $
  if(keyword_set(children[i])) then $
   begin
    widget_control, children[i], get_uvalue=uvalue
    uvalue = strtrim(uvalue,2)
    if(uvalue EQ name) then $
     begin
      widget_control, children[i], sensitive=sensitivity
      return
     end
    omin_set_menu_sensitivity, children[i], name, sensitivity
   end

end
;=============================================================================



;=============================================================================
; omin_get_current_tab
;
;=============================================================================
function omin_get_current_tab, omin_data, data=data

 tab_bases = widget_info(omin_data.tab, /all_children)
 ii = widget_info(omin_data.tab, /tab_current)
 tab_base = tab_bases[ii]

 widget_control, tab_base, get_uvalue=data
 return, tab_base
end
;=============================================================================



;=============================================================================
; omin_get_directory
;
;=============================================================================
function omin_get_directory, node_data
 profile_dir = nv_module_get_profile_dir(module)
 return,   profile_dir + '/' + node_data.module.profile_dir + '/omin'
end
;=============================================================================



;=============================================================================
; omin_create_profile
;
;=============================================================================
pro omin_create_profile, omin_data, title, clone=clone
 nv_module_create_profile, title;, clone=clone
end
;=============================================================================



;=============================================================================
; omin_set_property
;
;=============================================================================
pro omin_set_property, node_data, keyword, value
  
 module = 0
 if(keyword_set(node_data)) then module = node_data.module
 nv_module_set_property, module, 'OMIN_' + keyword, value

end
;=============================================================================



;=============================================================================
; omin_query
;
;=============================================================================
function omin_query, node_data, condition=condition, $
      installed=installed, active=active, locked=locked, protected=protected, $
      broken=broken, installing=installing, $
      exclusive=exclusive, fixed=fixed, profile_lock=profile_lock


 ;---------------------------------------------------
 ; resolve condition
 ;---------------------------------------------------
 if(keyword_set(condition)) then $
  case strupcase(condition) of
   'ACTIVE' : active = 1 
   'INSTALLED' : installed = 1 
   'LOCKED' : locked = 1 
   'PROTECTED' : protected = 1 
   'EXCLUSIVE' : exclusive = 1
   else:
  endcase  

 ;---------------------------------------------------
 ; handle omin-specific conditions
 ;---------------------------------------------------
 if(keyword_set(exclusive)) then property='OMIN_EXCLUSIVE'
 if(keyword_set(fixed)) then property='OMIN_FIXED'
 if(keyword_set(profile_lock)) then property='OMIN_PROFILE_LOCK'

 ;---------------------------------------------------
 ; get status
 ;---------------------------------------------------
 module = 0
 if(keyword_set(node_data)) then module = node_data.module
 return, nv_module_query(module, property=property, $
      installed=installed, active=active, locked=locked, protected=protected, $
      broken=broken, installing=installing)

end
;=============================================================================



;=============================================================================
; omin_test_locked
;
;=============================================================================
function omin_test_locked, arg

 if(typename(arg) EQ 'OMIN_NODE_DATA') then node_data = arg $
 else widget_control, arg, get_uvalue=node_data

 val = 0
 if(node_data.lock) then val = val + 1
 if(node_data.parent_lock) then val = val + 2
 return, val
end
;=============================================================================



;=============================================================================
; omin_set_bytemap_color
;
;=============================================================================
function omin_set_bytemap_color, bytemap, bg=bg, fg=fg, dim=dim

 fgmax = 255
 bgmax = 175
 dimx = 0.65

 if(keyword_set(dim)) then return, bytemap*dimx

 new_bytemap = bytemap

 wfg = where(bytemap[*,*,0] EQ 0)
 wbg = where(bytemap[*,*,0] NE 0)

 for i=0,2 do $
  begin
   bmi = bytemap[*,*,i]
   if(keyword_set(fg)) then bmi[wfg] = fg[i]*fgmax
   if(keyword_set(bg)) then bmi[wbg] = bg[i]*bgmax
   new_bytemap[*,*,i] = bmi
  end
 
 return, new_bytemap
end
;=============================================================================



;=============================================================================
; omin_get_bytemap
;
;=============================================================================
function omin_get_bytemap, fn
 return, bitmap_to_bytemap(rotate(call_function(fn), 7))
end
;=============================================================================



;=============================================================================
; omin_get_module_status
;
;=============================================================================
function omin_get_module_status, node_data

 status = ''
 if(NOT omin_query(node_data, /active)) then status = 'INACTIVE' $
 else $
  begin
   if(NOT node_data.suppressed) then status = 'ACTIVE' $
   else status = 'SUPPRESSED'
  end

 status = strupcase(node_data.module.apiname) + ' : ' + status

 return, status
end
;=============================================================================



;=============================================================================
; omin_get_module_description
;
;=============================================================================
function omin_get_module_description, node_data

 description = *node_data.module.description_p

 return, description
end
;=============================================================================



;=============================================================================
; omin_get_node
;
;=============================================================================
function omin_get_node, qname
 module = nv_get_module(qname)
 node = nv_module_get_udata(module, 'OMIN_NODE')
 return, node
end
;=============================================================================



;=============================================================================
; omin_add_node
;
;=============================================================================
function omin_add_node, omin_data, parent, tab_base, module, no_update=no_update


 submodules = nv_get_submodules(module)
 leaf = keyword_set(submodules) EQ 0


 ;------------------------------------------------------------------
 ; initial bytemap
 ;------------------------------------------------------------------
 bytemap = omin_get_bytemap('omin_plug_bitmap')


 ;------------------------------------------------------------------
 ; context_menu
 ;------------------------------------------------------------------
 menu_desc = [ '0\Activate\omin_node_menu_activate_event' , $
	       '0\Lock\omin_node_menu_lock_event', $
	       '0\Fix\omin_node_menu_fix_event', $
               '0\Exclusive\omin_node_menu_exclusive_event', $
	       '0\Update\omin_node_menu_update_event', $
	       '0\Install\omin_node_menu_install_event', $
	       '2\Arguments\omin_node_menu_args_event']
 mbase = widget_base(uvalue=omin_data)
 context_base = cw__pdmenu(mbase, /context_menu, menu_desc, $
                                ids=menu_ids, resource_name='omin_node_menu')
 for i=0, n_elements(menu_ids)-1 do $
  begin
   widget_control, menu_ids[i], get_value=value
   widget_control, menu_ids[i], set_uvalue=value
  end


 ;------------------------------------------------------------------
 ; save settings
 ;------------------------------------------------------------------
 node_data = $
     {OMIN_NODE_DATA, $
	module:			module, $	 ; Module structure
	label:			strupcase(module.name), $
	leaf:			leaf, $		 ; Leaf or not?
	tab_base:		tab_base, $	 ; Tab widget base
	arg_base:		0, $		 ; Argument text base
	args_p:			ptr_new(''), $	 ; Arguments 
	context_base:		context_base, $	 ; Context menu base
	suppressed:		0, $		 ; Inactive due to parent inactive?
	lock:			0, $	 	 ; Locked or not?
	parent_lock:		0 $		 ; Locked due to parent?
      }

 ;+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
 ; Apparent IDL bug (version 8.2.3): 
 ;  Tooltips do not function, so the work-around is add a text box to the 
 ;  bottom of the widget and store the descriptions in the user value.
 ;+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
 node = widget_tree(parent, value=node_data.label, folder=1-leaf, uvalue=node_data, bitmap=bytemap)
 widget_control, context_base, set_uvalue=node
 nv_module_set_udata, module, 'OMIN_NODE', node


 ;------------------------------------------------------------------
 ; add any submodules
 ;------------------------------------------------------------------
 if(NOT leaf) then $
   for i=0, n_elements(submodules)-1 do $
         module_bases = append_array(module_bases, $
                           omin_add_node(omin_data, node, tab_base, $
                                                  submodules[i], /no_update))

 return, node
end
;=============================================================================



;=============================================================================
; omin_create_tab_name
;
;=============================================================================
function omin_create_tab_name, tab, prefix

 sibs = widget_info(tab, /all_children)

 ntabs = n_elements(sibs)
 tab_names = strarr(ntabs)
 if(sibs[0] NE 0) then $
  for i=0, ntabs-1 do $
   begin
    widget_control, sibs[i], get_uvalue=tab_data_i
    tab_names[i] = tab_data_i.name
   end   

 i = 0
 repeat $
  begin
   test = prefix + '-' + strtrim(i,2)
   w = where(strupcase(tab_names) EQ strupcase(test))
   i = i + 1
  endrep until(w[0] EQ -1)
 name = test

 return, name
end
;=============================================================================



;=============================================================================
; omin_delete_tab
;
;=============================================================================
pro omin_delete_tab, omin_data, tab_base

 widget_control, tab_base, /destroy

end
;=============================================================================



;=============================================================================
; omin_new_tab
;
;=============================================================================
function omin_new_tab, omin_data, tab, title=title


 ;----------------------------------
 ; set up new widgets
 ;----------------------------------
 tab_base = widget_base(tab, /column, title=title, resource_name='omin_tab_base')
 root = widget_tree(tab_base, /checkbox, /context_events, xsize=400, ysize=600)

 tab_data = {OMIN_TAB_DATA, $
                   root:root, $
                   lock:0, $
                   name:title $
                 }
 widget_control, tab_base, set_uvalue=tab_data


 ;----------------------------------
 ; set up tree
 ;----------------------------------
 ominas = nv_get_module()
 base = omin_add_node(omin_data, root, tab_base, ominas)


 ;----------------------------------
 ; switch to new tab
 ;----------------------------------
 widget_control, omin_data.tab, $
        set_tab_current = widget_info(omin_data.tab, /tab_number) - 1

 return, tab_base
end
;=============================================================================



;=============================================================================
; omin_update_exclusive
;
;=============================================================================
pro omin_update_exclusive, omin_data, parent, select=_select

 if(keyword_set(_select)) then select = _select

 nodes = widget_info(parent, /all_children)
 if(NOT keyword_set(nodes)) then return
 n = n_elements(nodes)

 ;-------------------------------------------------
 ; get node data
 ;-------------------------------------------------
 nodes_data = replicate({OMIN_NODE_DATA}, n)
 active = bytarr(n)
 exclusive = bytarr(n)
 installed = bytarr(n)
 for i=0, n-1 do $
  begin
   widget_control, nodes[i], get_uvalue=node_data
   nodes_data[i] = node_data
   installed[i] = omin_query(node_data, /installed)
   active[i] = omin_query(nodes_data[i], /active)
   exclusive[i] = keyword_set(omin_query(nodes_data[i], /exclusive))
  end
 lock = nodes_data.lock

 ;-------------------------------------------------
 ; exclude silent nodes; abort if no live nodes
 ;-------------------------------------------------
 xx = where(installed NE 2)
 if(xx[0] EQ -1) then return
 nodes = nodes[xx]
 nodes_data = nodes_data[xx]
 n = n_elements(nodes)
 active = active[xx]
 exclusive = exclusive[xx]
 lock = lock[xx]

 ;-------------------------------------------------
 ; retain exclusive nodes; abort if none
 ;-------------------------------------------------
 xx = where(exclusive)
 if(xx[0] EQ -1) then return
 nodes = nodes[xx]
 nodes_data = nodes_data[xx]
 n = n_elements(nodes)
 active = active[xx]
 exclusive = exclusive[xx]
 lock = lock[xx]

 ;-------------------------------------------------------------------------
 ; verify whether selection, if any, is within this level
 ;-------------------------------------------------------------------------
 if(keyword_set(select)) then $
  begin
   w = where(nodes EQ select)
   if(w[0] EQ -1) then select = 0
  end

 ;-------------------------------------------------------------------------
 ; if no selection on this level, then return if current configuration 
 ; is already valid
 ;-------------------------------------------------------------------------
 if(NOT keyword_set(select)) then $
  begin
   if(total(active) EQ 1) then return
   select = nodes[0]
  end

 ;-------------------------------------------------
 ; abort if any locked nodes are active
 ;-------------------------------------------------
 w = where(lock, complement=xx)
 if(w[0] NE -1) then $
    if(total(active[w]) GT 0) then return

 ;-------------------------------------------------
 ; retain unlocked nodes; abort if none
 ;-------------------------------------------------
 if(xx[0] EQ -1) then return
 nodes = nodes[xx]
 nodes_data = nodes_data[xx]
 n = n_elements(nodes)
 active = active[xx]
 exclusive = exclusive[xx]

 ;---------------------------------------------------------------
 ; select first exclusive node if selected node is not exclusive
 ;---------------------------------------------------------------
 ii = (where(nodes EQ select))[0]
 if(ii[0] EQ -1) then ii = 0

 ;---------------------------------------------------------------
 ; deactivate all remaining nodes except the selected one
 ;---------------------------------------------------------------
 for i=0, n-1 do omin_activate, omin_data, nodes[i], /off
 omin_activate, omin_data, nodes[ii], /on

end
;=============================================================================



;=============================================================================
; omin_update_tree_descend
;
;=============================================================================
pro omin_update_tree_descend, omin_data, node, root=root, exclusive=exclusive, checks=checks

 children = widget_info(node, /all_children)
 nchildren = n_elements(children)


 ;---------------------------------------------------
 ; set state of current node
 ;---------------------------------------------------
 if(NOT keyword_set(root)) then $
  begin
   ;- - - - - - - - - - - - - - - - -
   ; get data
   ;- - - - - - - - - - - - - - - - -
   parent = widget_info(node, /parent) 
   widget_control, parent, get_uvalue=node_data_parent
   widget_control, node, get_uvalue=node_data

   ;- - - - - - - - - - - - - - - - - - - - - -
   ; make sure trunk nodes stay expanded
   ;- - - - - - - - - - - - - - - - - - - - - -
   checks = checks + widget_info(node, /tree_checked)

   ;- - - - - - - - - - - - - - - - - - - - - -
   ; make sure trunk nodes stay expanded
   ;- - - - - - - - - - - - - - - - - - - - - -
   if(node_data.module.name EQ 'ominas') then $
                                    widget_control, node, /set_tree_expanded
   if(node_data.module.qname EQ 'ominas.config') then $
                                    widget_control, node, /set_tree_expanded

   ;- - - - - - - - - - - - - - - - - - - -
   ; implement fixed status
   ;- - - - - - - - - - - - - - - - - - - -
   widget_control, node, /set_drop_events, $
		   set_draggable=1-keyword_set(omin_query(node_data, /fixed)), $
		   set_drag_notify='omin_drag_callback'

   ;- - - - - - - - - - - - - - - - - - - -
   ; update suppressed/parent_lock status
   ;- - - - - - - - - - - - - - - - - - - -
   node_data.suppressed = 0
   node_data.parent_lock = 0

   if(keyword_set(node_data_parent)) then $
    begin
     if(NOT omin_query(node_data_parent, /active)) then node_data.suppressed = 1
     if(node_data_parent.suppressed) then node_data.suppressed = 1

     if(omin_test_locked(node_data_parent)) then node_data.parent_lock = 1
    end
   widget_control, node, set_uvalue=node_data

   ;- - - - - - - - - - - - - - - - -
   ; update bytemap
   ;- - - - - - - - - - - - - - - - -
   bytemap = omin_get_bytemap('omin_plug_bitmap')

   if(keyword_set(node_data.lock)) then $
			     bytemap = omin_get_bytemap('omin_padlock_bitmap') $
   else if(omin_query(node_data, /locked)) then $
			     bytemap = omin_get_bytemap('omin_safe_bitmap') $
   else if(keyword_set(node_data.parent_lock)) then $
			     bytemap = omin_get_bytemap('omin_key_bitmap')

   if(omin_query(node_data, /exclusive)) then $
            bytemap = bytemap XOR 255-omin_get_bytemap('omin_split_bitmap')
   if(omin_query(node_data, /fixed)) then $
            bytemap = bytemap XOR 255-omin_get_bytemap('omin_frame_bitmap')

   if(omin_query(node_data, /broken)) then $
                             bytemap = omin_get_bytemap('omin_skull_bitmap')
   if(omin_query(node_data, /installing)) then $
                             bytemap = omin_get_bytemap('omin_hourglass_bitmap')

   ;- - - - - - - - - - - - - - - - -
   ; update bytemap color
   ;- - - - - - - - - - - - - - - - -
   if(NOT (stat=omin_query(node_data, /installed))) then $
    begin
      if(stat EQ 2) then bytemap = omin_get_bytemap('omin_question_bitmap')
      bytemap = omin_set_bytemap_color(bytemap, bg=[0.75,0.75,0.75], fg=[1,1,1])
    end $
   else $
    begin
     if(omin_query(node_data, /active)) then $
            bytemap = omin_set_bytemap_color(bytemap, bg=[0,1,0], fg=[1,1,1]) $
     else bytemap = omin_set_bytemap_color(bytemap, bg=[1,0,0], fg=[1,1,1])

     if(node_data.suppressed) then bytemap = omin_set_bytemap_color(bytemap, /dim)
    end

   ;- - - - - - - - - - - - - - - - -
   ; update node data
   ;- - - - - - - - - - - - - - - - -
   widget_control, node, set_tree_bitmap=bytemap
   widget_control, node, set_uvalue=node_data

   ;- - - - - - - - - - - - - - - - -
   ; set tree index
   ;- - - - - - - - - - - - - - - - -
   modules = node_data.module
   if(keyword_set(node_data_parent)) then $
                           modules = nv_get_submodules(node_data_parent.module)
   w = where(modules.name EQ node_data.module.name)
   widget_control, node, set_tree_index=w[0]

   ;- - - - - - - - - - - - - - - - -
   ; children exclusivity
   ;- - - - - - - - - - - - - - - - -
   omin_update_exclusive, omin_data, node, select=exclusive
  end


 ;---------------------------------------------------
 ; descend tree
 ;---------------------------------------------------
 if(NOT keyword_set(children)) then return
 for i=0, nchildren-1 do $
   omin_update_tree_descend, omin_data, children[i], $
                                      exclusive=exclusive, checks=checks
end
;=============================================================================



;=============================================================================
; omin_update_tree
;
;=============================================================================
pro omin_update_tree, omin_data, exclusive=exclusive

 ;-----------------------------------------------
 ; get profiles and add/remove tabs as needed
 ;-----------------------------------------------
 profiles = nv_module_get_profiles()
 nprofiles = n_elements(profiles)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; get all tabbed profiles
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 tab_bases = widget_info(omin_data.tab, /all_children)
 ntabs = 0
 tab_profiles = ''
 if(keyword_set(tab_bases)) then $
  begin
   ntabs = n_elements(tab_bases)
   tab_profiles = strarr(ntabs)
   for i=0, ntabs-1 do $
    begin
     widget_control, tab_bases[i], get_uvalue=tab_data_i
     tab_profiles[i] = tab_data_i.name
    end
  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; add tabs
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 for i=0, nprofiles-1 do $
  begin
   w = where(strupcase(profiles[i]) EQ strupcase(tab_profiles))
   if(w[0] EQ -1) then $
       tab_base = omin_new_tab(omin_data, omin_data.tab, title=profiles[i])
  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; remove tabs
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 for i=0, ntabs-1 do $
  begin
   w = where(strupcase(tab_profiles[i]) EQ strupcase(profiles))
   if(w[0] EQ -1) then $
       omin_delete_tab, omin_data, tab_bases[i]
  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; select current profile
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 tab_bases = widget_info(omin_data.tab, /all_children)
 ntabs = n_elements(tab_bases)
 profile = nv_module_get_profiles(/current)
 for i=0, ntabs-1 do $
  begin
   widget_control, tab_bases[i], get_uvalue=tab_data_i
   if(tab_data_i.name EQ profile) then $
                             widget_control, omin_data.tab, set_tab_current=i
  end



 ;-------------------------------
 ; profile lock
 ;-------------------------------
 omin_set_menu_sensitivity, omin_data.mbar, 'Delete', 1
 omin_set_menu_sensitivity, omin_data.mbar, 'Rename', 1
 omin_set_menu_sensitivity, omin_data.mbar, 'Reset', 1
 omin_set_menu_string, omin_data.mbar, 'Lock', 'Lock'

; lock_button = widget_info(omin_data.mbar, find_by_uname='omin_mbar_BUTTON_Lock')
; widget_control, lock_button, set_value='Lock'

 tab_pad = ' '
 if(omin_query('', /profile_lock)) then $
  begin
   tab_pad = '-'
;   widget_control, lock_button, set_value='Unlock'
   omin_set_menu_string, omin_data.mbar, 'Lock', 'Unlock'

   omin_set_menu_sensitivity, omin_data.mbar, 'Delete', 0
   omin_set_menu_sensitivity, omin_data.mbar, 'Rename', 0
   omin_set_menu_sensitivity, omin_data.mbar, 'Reset', 0
  end


 ;-------------------------------
 ; highlight current tab
 ;-------------------------------
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 tab_bases = widget_info(omin_data.tab, /all_children)
 for i=0, n_elements(tab_bases)-1 do $
  begin
   pad = str_pad(tab_pad, 4, c=tab_pad)
   widget_control, tab_bases[i], get_uvalue=tab_data_i
   widget_control, tab_bases[i], base_set_title=tab_data_i.name
   if(tab_bases[i] EQ tab_base) then $
      widget_control, tab_bases[i], base_set_title=pad + tab_data_i.name + pad
  end


 ;---------------------------------------------------------------
 ; descend tree
 ;---------------------------------------------------------------
 checks = 0
 omin_update_tree_descend, $
            omin_data, tab_data.root, /root, exclusive=exclusive, checks=checks


 ;---------------------------------------------------------------
 ; update Module menu sensitivity
 ;---------------------------------------------------------------
 module_menu = widget_info(omin_data.mbar, find_by_uname='omin_mbar_BUTTON_Module')
 widget_control, module_menu, sensitive=keyword_set(checks)

 ;---------------------------------------------------------------
 ; update description
 ;---------------------------------------------------------------
 node_select = (widget_info(tab_data.root, /tree_select))[0]
 if(node_select NE -1) then $
    widget_control, node_select, get_uvalue=node_data_select
 if(keyword_set(node_data_select)) then $
  begin
   widget_control, omin_data.status_label, set_value=omin_get_module_status(node_data_select)
   widget_control, omin_data.description_text, set_value=omin_get_module_description(node_data_select)
  end

 ;---------------------------------------------------------------
 ; rebuild setup script
 ;---------------------------------------------------------------
 nv_module_build

end
;=============================================================================



;=============================================================================
; omin_install_callback
;
;=============================================================================
pro omin_install_callback, module, data

 if(data.restore) then omin_activate, data.omin_data, data.node, /on

 if(keyword_set(data.callback)) then $
             call_procedure, data.callback, data.omin_data, module, data.data
 omin_update_tree, data.omin_data
end
;=============================================================================



;=============================================================================
; omin_install
;
;=============================================================================
pro omin_install, omin_data, node, callback=callback, data=data, update=update

 if(NOT keyword_set(callback)) then callback = ''
 if(NOT keyword_set(data)) then data = 0
 update = keyword_set(update)

 widget_control, node, get_uvalue=node_data

 restore = omin_query(node_data, /active)
 if(update) then omin_activate, omin_data, node, /off

 nv_module_install, $
    node_data.module, fg=omin_data.fg, callback='omin_install_callback', $
       data={omin_data:omin_data, node:node, restore:restore, $
             callback:callback, data:data}

end
;=============================================================================



;=============================================================================
; omin_uninstall
;
;=============================================================================
pro omin_uninstall, omin_data, node
 widget_control, node, get_uvalue=node_data
 answer = dialog_message(/question, resource_name='omin_dialog', $
                     'Uninstall module ' + strupcase(node_data.module.name) + '?')
 if(answer NE 'Yes') then return

 nv_module_uninstall, node_data.module
end
;=============================================================================



;=============================================================================
; omin_activate_callback
;
;=============================================================================
pro omin_activate_callback, omin_data, module, node

 ;------------------------------------------
 ; set activity
 ;------------------------------------------
 nv_module_activate, module

 ;------------------------------------------
 ; if no children active, then activate all
 ;------------------------------------------
 children = widget_info(node, /all_children)
 if(NOT keyword_set(children)) then return

 nchildren = n_elements(children)
 actives = intarr(nchildren)
 for i=0, nchildren-1 do $
  begin
   widget_control, children[i], get_uvalue=node_data_i
   actives[i] = omin_query(node_data_i, /active) EQ 1
  end
 if(total(actives) EQ 0) then $
	for i=0, nchildren-1 do omin_activate, omin_data, children[i], /on

end
;=============================================================================



;=============================================================================
; omin_activate
;
;=============================================================================
pro omin_activate, omin_data, node, activate, on=on, off=off, toggle=toggle

 if(NOT defined(activate)) then activate = keyword_set(off) ? 0:1
 widget_control, node, get_uvalue=node_data

 ;------------------------------------------
 ; verify ominas lock
 ;------------------------------------------
 if(omin_query(node_data, /locked)) then return

 ;------------------------------------------
 ; verify omin lock
 ;------------------------------------------
 if(node_data.lock) then return
 if(node_data.parent_lock) then return

 ;------------------------------------------
 ; implement toggle
 ;------------------------------------------
 if(keyword_set(toggle)) then $
  begin
   active = omin_query(node_data, /active)
   activate = 1-active
  end

 ;------------------------------------------
 ; deactivate if not directed to activate
 ;------------------------------------------
 if(NOT activate) then $
  begin
   nv_module_deactivate, node_data.module
   return
  end

 ;------------------------------------------
 ; install module if necessary
 ;------------------------------------------
 omin_install, omin_data, node, callback='omin_activate_callback', data=node
end
;=============================================================================



;=============================================================================
; omin_lock
;
;=============================================================================
pro omin_lock, omin_data, node, lock=lock, unlock=unlock, toggle=toggle
 widget_control, node, get_uvalue=node_data

 if(keyword_set(lock)) then node_data.lock = 1 $
 else if(keyword_set(unlock)) then node_data.lock = 0 $
 else node_data.lock = 1-node_data.lock

 widget_control, node, set_uvalue=node_data
end
;=============================================================================



;=============================================================================
; omin_fix
;
;=============================================================================
pro omin_fix, omin_data, node, fix=fix, unfix=unfix, toggle=toggle
 widget_control, node, get_uvalue=node_data

 ;------------------------------------------
 ; verify lock
 ;------------------------------------------
 widget_control, node, get_uvalue=node_data
 if(omin_test_locked(node)) then return
 if(omin_query(node_data, /locked)) then return

 ;------------------------------------------
 ; set property
 ;------------------------------------------
 fixed = omin_query(node_data, /fixed)
 if(keyword_set(fix)) then omin_set_property, node_data, 'FIXED' $
 else if(keyword_set(unfix)) then omin_set_property, node_data, 'FIXED', 0 $
 else omin_set_property, node_data, 'FIXED', 1 - keyword_set(fixed)

end
;=============================================================================



;=============================================================================
; omin_exclusive
;
;=============================================================================
pro omin_exclusive, omin_data, node
 widget_control, node, get_uvalue=node_data

 ;------------------------------------------
 ; verify lock
 ;------------------------------------------
 widget_control, node, get_uvalue=node_data
 if(omin_test_locked(node)) then return
 if(omin_query(node_data, /locked)) then return

 ;------------------------------------------
 ; toggle exclusivity
 ;------------------------------------------
 exclusive = omin_query(node_data, /exclusive)
 omin_set_property, node_data, 'EXCLUSIVE', 1 - keyword_set(exclusive)
 omin_node_select, omin_data, node

end
;=============================================================================



;=============================================================================
; omin_drag_callback
;
;=============================================================================
function omin_drag_callback, dst, src, modifiers, def

; need to test lock

 return, 5
end
;=============================================================================



;=============================================================================
; omin_event_tab
;
;=============================================================================
pro omin_event_tab, omin_data, event

 tabs = widget_info(omin_data.tab, /all_children)
 tab = tabs[event.tab]
 widget_control, tab, get_uvalue=tab_data
 nv_module_select_profile, tab_data.name   ; not working

 omin_update_tree, omin_data

end
;=============================================================================



;=============================================================================
; omin_event_context
;
;=============================================================================
pro omin_event_context, omin_data, event

 node = (widget_info(event.id, /tree_select))[0]
 if(node EQ -1) then return

 widget_control, node, get_uvalue=node_data
 base = node_data.context_base

 buttons = widget_info(base, /all_children)
 for i=0, n_elements(buttons)-1 do widget_control, buttons[i], /sensitive

 if(NOT node_data.leaf) then omin_set_menu_sensitivity, base, 'Arguments', 0

 if(omin_query(node_data, /installed)) then $
                        omin_set_menu_string, base, 'Install', 'Uninstall' $
 else omin_set_menu_string, base, 'Install', 'Install'

 if(omin_query(node_data, /active)) then $
                        omin_set_menu_string, base, 'Activate', 'Deactivate' $
 else omin_set_menu_string, base, 'Activate', 'Activate'
 
 if(node_data.lock) then omin_set_menu_string, base, 'Lock', 'Unlock' $
 else omin_set_menu_string, base, 'Lock', 'Lock'

 if(NOT omin_query(node_data, /installed)) then $
                                 omin_set_menu_sensitivity, base, 'Update', 0

 ;--------------------------------------------------------------
 ; silent module
 ;--------------------------------------------------------------
 if(omin_query(node_data) EQ 2) then $
  begin
   omin_set_menu_sensitivity, base, 'Activate', 0
   omin_set_menu_sensitivity, base, 'Lock', 0
   omin_set_menu_sensitivity, base, 'Fix', 0
   omin_set_menu_sensitivity, base, 'Exclusive', 0
   omin_set_menu_sensitivity, base, 'Install', 0
   omin_set_menu_sensitivity, base, 'Update', 0
   omin_set_menu_sensitivity, base, 'Arguments', 0
  end
  
 ;--------------------------------------------------------------
 ; broken module
 ;--------------------------------------------------------------
 if(omin_query(node_data, /broken)) then $
  begin
   omin_set_menu_sensitivity, base, 'Activate', 0
   omin_set_menu_sensitivity, base, 'Lock', 0
   omin_set_menu_sensitivity, base, 'Fix', 0
   omin_set_menu_sensitivity, base, 'Exclusive', 0
   omin_set_menu_sensitivity, base, 'Install', 0
   omin_set_menu_sensitivity, base, 'Update', 1
   omin_set_menu_sensitivity, base, 'Arguments', 0
  end
  
 ;--------------------------------------------------------------
 ; protected module
 ;--------------------------------------------------------------
 if(omin_query(node_data, /protected)) then $
  begin
   omin_set_menu_sensitivity, base, 'Install', 0
   omin_set_menu_sensitivity, base, 'Arguments', 0
  end

 ;--------------------------------------------------------------
 ; locked module
 ;--------------------------------------------------------------
 if(omin_test_locked(node)) then $
  begin
   omin_set_menu_sensitivity, base, 'Activate', 0
   omin_set_menu_sensitivity, base, 'Fix', 0
   omin_set_menu_sensitivity, base, 'Exclusive', 0
   omin_set_menu_sensitivity, base, 'Install', 0
   omin_set_menu_sensitivity, base, 'Update', 0
   omin_set_menu_sensitivity, base, 'Arguments', 0
  end

 ;--------------------------------------------------------------
 ; safe module
 ;--------------------------------------------------------------
 if(omin_query(node_data, /locked)) then $
  begin
   omin_set_menu_sensitivity, base, 'Activate', 0
   omin_set_menu_sensitivity, base, 'Lock', 0
   omin_set_menu_sensitivity, base, 'Fix', 0
   omin_set_menu_sensitivity, base, 'Exclusive', 0
   omin_set_menu_sensitivity, base, 'Install', 0
   omin_set_menu_sensitivity, base, 'Update', 0
   omin_set_menu_sensitivity, base, 'Arguments', 0
  end

 ;--------------------------------------------------------------
 ; installing
 ;--------------------------------------------------------------
 if(omin_query(node_data, /installing)) then $
  begin
   omin_set_menu_sensitivity, base, 'Lock', 0
   omin_set_menu_sensitivity, base, 'Fix', 0
   omin_set_menu_sensitivity, base, 'Exclusive', 0
   omin_set_menu_sensitivity, base, 'Install', 1
   omin_set_menu_sensitivity, base, 'Update', 0
   omin_set_menu_sensitivity, base, 'Arguments', 0
   omin_set_menu_string, base, 'Install', 'Abort'
  end

 ;--------------------------------------------------------------
 ; fixed module
 ;--------------------------------------------------------------
 if(omin_query(node_data, /fixed)) then $
                         omin_set_menu_string, base, 'Fix', 'Unfix' $
 else omin_set_menu_string, base, 'Fix', 'Fix'


 widget_displaycontextmenu, event.id, event.x, event.y, base
end
;=============================================================================



;=============================================================================
; omin_args_callback
;
;=============================================================================
pro omin_args_callback, id, node

 widget_control, id, get_value=text
 widget_control, node, get_uvalue=node_data

 *node_data.args_p = text
 widget_control, node, set_uvalue=node_data

end
;=============================================================================



;=============================================================================
; omin_edit_args
;
;=============================================================================
pro omin_edit_args, node

 widget_control, node, get_uvalue=node_data

 callback = 'omin_args_callback'
 if(omin_test_locked(node_data)) then callback = ''

 if(NOT widget_info(node_data.arg_base, /valid)) then $
  begin
   class = cor_class(xd)
   title='OMIN: ' + strupcase(node_data.module.apiname)
   if(NOT keyword_set(callback)) then title = title + ' [LOCKED]
   text = $
     textedit(*node_data.args_p, base=base, resource='omin_args', $
                      title=title, xsize=35, ysize=12, callback=callback, $
                                                 data=node, group_leader=node)
   node_data.arg_base = base
   widget_control, node, set_uvalue=node_data
  end $
 else widget_control, node_data.arg_base, /map

end
;=============================================================================



;=============================================================================
; omin_node_select
;
;=============================================================================
pro omin_node_select, omin_data, node

 widget_control, node, get_uvalue=node_data

 ;-----------------------------------------
 ; locked
 ;-----------------------------------------
 if(node_data.lock) then return
 if(node_data.parent_lock) then return

 ;-----------------------------------------
 ; exclusive
 ;-----------------------------------------
 if(omin_query(node_data, /exclusive)) then $
  begin
   omin_update_tree, omin_data, exclusive=node
   return
  end

 ;-----------------------------------------
 ; standard
 ;-----------------------------------------
 omin_activate, omin_data, node, /toggle
end
;=============================================================================



;=============================================================================
; omin_event_tree_select
;
;=============================================================================
pro omin_event_tree_select, omin_data, event, node_data

 ;--------------------------------------------------------------------------
 ; Cancel out double-click expansion
 ;  This code attempts to reverse the expansion operation before it appears 
 ;  on the screen.  It only works when OMIN is blocking.  If /no_block is 
 ;  used with xmanager, the widget be seen to jump.  This is apparently 
 ;  because, when not blocking, the collapse action requested  below is not 
 ;  executed until after the event handler returns.  It might work if the
 ;  event handler were faster.  Updating the tree via ominas_update
 ;  is apparently not fast enough.  One work-around would be to havethe
 ;  tree event handler set timer to trigger the actual event after the 
 ;  tree handler returns.
 ;--------------------------------------------------------------------------
 if(NOT node_data.leaf) then $
  begin
   expanded = widget_info(event.id, /tree_expanded)
   widget_control, event.id, set_tree_expanded = 1-expanded
  end

 ;-----------------------------------------
 ; modify activation state
 ;-----------------------------------------
 omin_node_select, omin_data, event.id
end
;=============================================================================



;=============================================================================
; omin_event_tree
;
;=============================================================================
pro omin_event_tree, omin_data, event

 if(typename(event) EQ 'WIDGET_TREE_EXPAND') then return

 ;-----------------------------------------------
 ; get data
 ;-----------------------------------------------
 widget_control, event.id, get_uvalue=node_data
 if(NOT keyword_set(node_data)) then return

 widget_control, node_data.tab_base, get_uvalue=tab_data


 ;---------------------------------------------------------------------------
 ; Select event -- display description(single) or toggle activation (double)
 ;---------------------------------------------------------------------------
 if(typename(event) EQ 'WIDGET_TREE_SEL') then $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; No action for one click
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(event.clicks EQ 1) then $
    begin
    end $
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; Modify activity if leaf node 
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   else omin_event_tree_select, omin_data, event, node_data
  end

 ;---------------------------------------------
 ; Drop events
 ;---------------------------------------------
 if(typename(event) EQ 'WIDGET_DROP') then $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   ; get source and destination widgets
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   dst = event.id

   ;+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
   ; Apparent IDL bug (version 8.2.3): 
   ;  drag_id is supposed to be the id of the source widget, but it comes 
   ;  back as the root widget instead.  The work-around here is to look at 
   ;  the selected node instead
   ;+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
   ;;;src = event.drag_id
   src = widget_info(tab_data.root, /tree_select)
   widget_control, src, get_uvalue=src_data

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   ; Reorder widgets
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   index = widget_info(dst, /tree_index)
   nv_module_set_position, src_data.module, index
  end

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_event_button
;
;=============================================================================
pro omin_event_button, omin_data, event
end
;=============================================================================



;=============================================================================
; omin_event_timer
;
;=============================================================================
pro omin_event_timer, omin_data, event
 omin_update_tree, omin_data
 widget_control, omin_data.base, timer=omin_data.poll
end
;=============================================================================



;=============================================================================
; omin_event
;
;=============================================================================
pro omin_event, event

 ;-----------------------------------------------
 ; get form base and data
 ;-----------------------------------------------
 base = event.top
 widget_control, event.top, get_uvalue=omin_data

 ;-----------------------------------------------
 ; determine event handler
 ;-----------------------------------------------
 if(str_match(typename(event), 'WIDGET_TREE')) then omin_event_tree, omin_data, event $
 else if(typename(event) EQ 'WIDGET_DROP') then omin_event_tree, omin_data, event $
 else if(typename(event) EQ 'WIDGET_TAB') then omin_event_tab, omin_data, event $
 else if(typename(event) EQ 'WIDGET_CONTEXT') then omin_event_context, omin_data, event $
 else if(typename(event) EQ 'WIDGET_TIMER') then omin_event_timer, omin_data, event $
 else if(typename(event) EQ 'WIDGET_BUTTON') then omin_event_button, omin_data, event $
 else if(typename(event) EQ 'WIDGET_TRACKING') then omin_update_tree, omin_data

end
;=============================================================================



;=============================================================================
; omin_node_menu_activate_event
;
;=============================================================================
pro omin_node_menu_activate_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 if(omin_test_locked(node)) then return

 omin_node_select, omin_data, node
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_node_menu_lock_event
;
;=============================================================================
pro omin_node_menu_lock_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 widget_control, node, get_uvalue=node_data

 omin_lock, omin_data, node, /toggle
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_node_menu_fix_event
;
;=============================================================================
pro omin_node_menu_fix_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 widget_control, node, get_uvalue=node_data

 omin_fix, omin_data, node
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_node_menu_exclusive_event
;
;=============================================================================
pro omin_node_menu_exclusive_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 widget_control, node, get_uvalue=node_data
 if(omin_test_locked(node_data)) then return

 omin_exclusive, omin_data, node 
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_node_menu_update_event
;
;=============================================================================
pro omin_node_menu_update_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 if(omin_test_locked(node)) then return

 omin_install, omin_data, node, /update
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_abort
;
;=============================================================================
pro omin_abort, node_data

 bridge = *node_data.module.bridge_p
 if(NOT keyword_set(bridge)) then return
 bridge->Abort

end
;=============================================================================


;=============================================================================
; omin_node_menu_install_event
;
;=============================================================================
pro omin_node_menu_install_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 widget_control, node, get_uvalue=node_data
 if(omin_test_locked(node)) then return

 if(omin_query(node_data, /installing)) then omin_abort, node_data $
 else if(NOT omin_query(node_data, /installed)) then $
                                         omin_install, omin_data, node $
 else omin_uninstall, omin_data, node

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_node_menu_args_event
;
;=============================================================================
pro omin_node_menu_args_event, event

 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 widget_control, node, get_uvalue=node_data

 omin_edit_args, node

end
;=============================================================================



;=============================================================================
; omin_mbar_exit_event
;
;=============================================================================
pro omin_mbar_exit_event, event
 widget_control, event.top, /destroy
 retall
end
;=============================================================================



;=============================================================================
; omin_mbar_profile_rename_event
;
;=============================================================================
pro omin_mbar_profile_rename_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)

 name = nv_module_get_profiles(/current)

 done = 0
 repeat $
  begin
   new_name = dialog_input('New profile name:', resource_name='omin_dialog')
   if(NOT keyword_set(strtrim(new_name,2))) then return
 
done=1  
;   if(NOT nv_module()) then done = 1
  endrep until(done)

 nv_module_rename_profile, name, new_name
 tab_data.name = new_name
 widget_control, tab_base, set_uvalue=tab_data

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_profile_reset_event
;
;=============================================================================
pro omin_mbar_profile_reset_event, event

 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)

 answer = dialog_message('Reset profile ' + tab_data.name + '?', /question, resource_name='omin_dialog')
 if(answer NE 'Yes') then return

 nv_module_reset_profile, tab_data.name

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_profile_new_event
;
;=============================================================================
pro omin_mbar_profile_new_event, event
 widget_control, event.top, get_uvalue=omin_data

 prefix = 'Profile'
 title = omin_create_tab_name(omin_data.tab, prefix)
 omin_create_profile, omin_data, title

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_profile_clone_event
;
;=============================================================================
pro omin_mbar_profile_clone_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)

 prefix = tab_data.name
 title = omin_create_tab_name(omin_data.tab, prefix)

 omin_create_profile, omin_data, title, clone=tab_data.name

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_profile_delete_event
;
;=============================================================================
pro omin_mbar_profile_delete_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 name = tab_data.name

 answer = dialog_message('Delete profile ' + name + '?', /question, resource_name='omin_dialog')
 if(answer NE 'Yes') then return

 nv_module_delete_profile, name
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_profile_lock_event
;
;=============================================================================
pro omin_mbar_profile_lock_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)

 lock = omin_query('', /profile_lock)
 omin_set_property, '', 'PROFILE_LOCK', 1 - keyword_set(lock)

 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_tree_descend
;
;=============================================================================
pro omin_tree_descend, omin_data, node, action, $
                                      condition=condition, result=result

 widget_control, node, get_uvalue=node_data

 comply = 1
 if(keyword_set(node_data)) then $
  if(keyword_set(condition)) then $
   if(NOT omin_query(node_data, condition=condition)) then comply = 0

 if(comply) then $
  case action of
   'EXPAND' : widget_control, node, /set_tree_expanded
   'COLLAPSE' : widget_control, node, set_tree_expanded=0
   'CHECK' : widget_control, node, /set_tree_checked
   'UNCHECK' : widget_control, node, set_tree_checked=0
   'ACTIVATE' : if(widget_info(node, /tree_checked)) then omin_activate, omin_data, node, /on
   'DEACTIVATE' : if(widget_info(node, /tree_checked)) then omin_activate, omin_data, node, /off
   'LOCK' : if(widget_info(node, /tree_checked)) then omin_lock, omin_data, node, /lock
   'UNLOCK' : if(widget_info(node, /tree_checked)) then omin_lock, omin_data, node, /unlock
   'FIX' : if(widget_info(node, /tree_checked)) then omin_fix, omin_data, node, /fix
   'UNFIX' : if(widget_info(node, /tree_checked)) then omin_fix, omin_data, node, /unfix
   'EXCLUSIVE' : if(widget_info(node, /tree_checked)) then omin_exclusive, omin_data, node
   'INSTALL' : if(widget_info(node, /tree_checked)) then omin_install, omin_data, node
   'UNINSTALL' : if(widget_info(node, /tree_checked)) then omin_uninstall, omin_data, node
   'UPDATE' : if(widget_info(node, /tree_checked)) then omin_install, omin_data, node, /update
   else:
  endcase


 children = widget_info(node, /all_children)
 if(NOT keyword_set(children)) then return

 for i=0, n_elements(children)-1 do $
               omin_tree_descend, omin_data, children[i], action, $
                                           condition=condition, result=result

end
;=============================================================================



;=============================================================================
; omin_mbar_tree_expand_event
;
;=============================================================================
pro omin_mbar_tree_expand_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'EXPAND'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_tree_collapse_event
;
;=============================================================================
pro omin_mbar_tree_collapse_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'COLLAPSE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_tree_expand_active_event
;
;=============================================================================
pro omin_mbar_tree_expand_active_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'COLLAPSE'
 omin_tree_descend, omin_data, tab_data.root, 'EXPAND', condition='active'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_tree_check_event
;
;=============================================================================
pro omin_mbar_tree_check_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'CHECK'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_tree_uncheck_event
;
;=============================================================================
pro omin_mbar_tree_uncheck_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'UNCHECK'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_activate_event
;
;=============================================================================
pro omin_mbar_module_activate_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'ACTIVATE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_deactivate_event
;
;=============================================================================
pro omin_mbar_module_deactivate_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'DEACTIVATE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_lock_event
;
;=============================================================================
pro omin_mbar_module_lock_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'LOCK'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_unlock_event
;
;=============================================================================
pro omin_mbar_module_unlock_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'UNLOCK'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_fix_event
;
;=============================================================================
pro omin_mbar_module_fix_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'FIX'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_unfix_event
;
;=============================================================================
pro omin_mbar_module_unfix_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'UNFIX'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_exclusive_event
;
;=============================================================================
pro omin_mbar_module_exclusive_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'EXCLUSIVE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_install_event
;
;=============================================================================
pro omin_mbar_module_install_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'INSTALL'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_uninstall_event
;
;=============================================================================
pro omin_mbar_module_uninstall_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'UNINSTALL'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_module_update_event
;
;=============================================================================
pro omin_mbar_module_update_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, omin_data, tab_data.root, 'UPDATE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_menu_delim_event
;
;=============================================================================
pro omin_menu_delim_event, event
end
;=============================================================================



;=============================================================================
; omin_menu_null_event
;
;=============================================================================
pro omin_menu_null_event, event
end
;=============================================================================



;=============================================================================
; omin_command_get_modules
;
;=============================================================================
function omin_command_get_modules, names

 for i=0, n_elements(names)-1 do $
     modules = append_array(modules, nv_get_module('ominas.' + names[i]))
  
 return, modules
end
;=============================================================================



;=============================================================================
; omin_command_activate
;
;=============================================================================
pro omin_command_activate, modules
 for i=0, n_elements(modules)-1 do nv_module_activate, modules[i]  
end
;=============================================================================



;=============================================================================
; omin_command_deactivate
;
;=============================================================================
pro omin_command_deactivate, modules
 for i=0, n_elements(modules)-1 do nv_module_deactivate, modules[i]  
end
;=============================================================================



;=============================================================================
; omin_command_install
;
;=============================================================================
pro omin_command_install, modules, fg=fg
 for i=0, n_elements(modules)-1 do nv_module_install, fg=fg, modules[i]
end
;=============================================================================



;=============================================================================
; omin_command_uninstall
;
;=============================================================================
pro omin_command_uninstall, modules
 for i=0, n_elements(modules)-1 do nv_module_uninstall, modules[i]  
end
;=============================================================================



;=============================================================================
; omin_command_update
;
;=============================================================================
pro omin_command_update, modules, fg=fg
 for i=0, n_elements(modules)-1 do nv_module_install, /update, /fg, modules[i]  
end
;=============================================================================



;=============================================================================
; omin_command_toggle
;
;=============================================================================
pro omin_command_toggle, modules
 for i=0, n_elements(modules)-1 do nv_module_toggle, modules[i]  
end
;=============================================================================



;=============================================================================
; omin_command_reset
;
;=============================================================================
pro omin_command_reset, reset
 if(reset NE '0') then if(reset NE '1') then name = reset
 nv_module_reset_profile, name
end
;=============================================================================



;=============================================================================
; omin_command
;
;=============================================================================
pro omin_command, fg=fg, $
             reset=reset, $
             activate=activate, $
             deactivate=deactivate, $
             install=install, $
             uninstall=uninstall, $
             update=update, $
             toggle=toggle, $
             profile=profile, $
             list=list

 ;-----------------------------------------------------------------
 ; activation
 ;-----------------------------------------------------------------
 if(keyword_set(activate)) then $
                  omin_command_activate, omin_command_get_modules(activate)
 if(keyword_set(deactivate)) then $
                  omin_command_deactivate, omin_command_get_modules(deactivate)
 if(keyword_set(toggle)) then $
                  omin_command_toggle, omin_command_get_modules(toggle)

 ;-----------------------------------------------------------------
 ; installation
 ;-----------------------------------------------------------------
 if(keyword_set(install)) then $
                  omin_command_install, fg=fg, omin_command_get_modules(install)
 if(keyword_set(uninstall)) then $
                  omin_command_uninstall, omin_command_get_modules(uninstall)
 if(keyword_set(update)) then $
                  omin_command_update, fg=fg, omin_command_get_modules(update)


 ;-----------------------------------------------------------------
 ; set or display profile
 ;-----------------------------------------------------------------
 if(keyword_set(profile)) then nv_module_select_profile, profile

 ;-----------------------------------------------------------------
 ; list modules
 ;-----------------------------------------------------------------
 if(keyword_set(list)) then nv_module_list


 ;-----------------------------------------------------------------
 ; reset to default configuration
 ;-----------------------------------------------------------------
 if(keyword_set(reset)) then omin_command_reset, reset


end
;=============================================================================



;=============================================================================
; omin_get_dependencies
;
;=============================================================================
function omin_get_dependencies, name

   ;----------------------------------------------------
   ; get modules
   ;----------------------------------------------------
   module = nv_get_module(name)
   modules = nv_get_module(name, /children)
   modules = append_array(module, modules)


   ;----------------------------------------------------
   ; get dependencies
   ;----------------------------------------------------
  for i=0, n_elements(modules)-1 do $
    begin
     tab =  file_search(modules[i].method_dir + '/*' + '_detectors.tab')
if(keyword_set(tab)) then print, modules[i].qname
    end

return, ''
 return, nodes
end
;=============================================================================



;=============================================================================
; omin_intro_install
;
;=============================================================================
pro omin_intro_install, options

 ;--------------------------------------------------------
 ; set variables corresponding to each returned option
 ;--------------------------------------------------------
 for i=0, n_elements(options)-1 do junk = execute(options[i] + '=1')


 ;--------------------------------------------------------
 ; install according to specified options
 ;--------------------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 ; default
 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(default)) then $
  begin
   print, 'Installing referenced modules...'
   nodes = omin_get_dependencies('ominas')
  end $

 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 ; full
 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 else if(keyword_set(full)) then $
  begin
   print, 'Installing all modules...'
  end $

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; demo -- do nothing because demo is setup by default 
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 else if(keyword_set(demo)) then $
  begin
   return
  end 



 junk = dialog_message(title='OMINAS Installation Underway', $
         ['Your modules are being installed.  Once the installation', $
          'is complete, you may exit OMIN and begin using OMINAS.', $
          'Use OMIN (this program) to modify your configuration in', $
          'the future.'], $
          /info, resource_name='omin_intro')


;;;; dialog with info about testing demos once installation is complete

end
;=============================================================================



;=============================================================================
; omin_intro
;
;=============================================================================
pro omin_intro, base

 widget_control, base, sensitive=0

 options = omin_dialog_intro()

 if(keyword_set(options)) then omin_intro_install, options; $
; else junk = dialog_message(title='Manual OMINAS Configuration', $
;         'You may now use the OMIN interface manually install modules.', $
;          /info, resource_name='omin_intro')

 widget_control, base, sensitive=1

end
;=============================================================================



;=============================================================================
; omin
;
;=============================================================================
pro omin, block=block, fg=fg, bat=bat, _extra=ex, new=new
@nv_block.common

 if(keyword_set(new)) then new = fix(new)
 if(NOT keyword_set(new)) then new = nv_state.new

 ;---------------------------------------------------------------------
 ; if any shell arguments, execute those and exit IDL without starting
 ; any widgets
 ;---------------------------------------------------------------------
 if(keyword_set(ex)) then $
  begin
   omin_command, fg=keyword_set(bat), _extra=ex
   return
  end

 ;----------------------------------
 ; widgets
 ;----------------------------------
 title = 'OMIN -- OMINAS Install/Config'

 base = widget_base(title=title, /column, mbar=mbar, /tracking_events, $
            rname_mbar='omin_mbar', resource_name='omin_base');, /tlb_size_events)
 tab = widget_tab(base)

 description_text = widget_text(base, ysize=10, /scroll, /wrap, resource_name='omin_description_text')
 status_label = widget_text(base, resource_name='status_label')


 ;----------------------------------
 ; menu bar
 ;----------------------------------
 menu_desc = [ $
    '1\File', $
         '0\Exit\omin_mbar_exit_event', $
         '2\<null>\omin_menu_null_event', $
    '1\Profile', $
         '0\New\omin_mbar_profile_new_event', $
         '0\Clone\omin_mbar_profile_clone_event', $
         '0\Delete\omin_mbar_profile_delete_event', $
         '0\Rename\omin_mbar_profile_rename_event', $
         '0\Reset\omin_mbar_profile_reset_event', $
         '0\Lock\omin_mbar_profile_lock_event', $
         '2\<null>\omin_menu_null_event', $
    '1\Module', $
         '0\Activate\omin_mbar_module_activate_event', $
         '0\Deactivate\omin_mbar_module_deactivate_event', $
         '0\Lock\omin_mbar_module_lock_event', $
         '0\Unlock\omin_mbar_module_unlock_event', $
         '0\Fix\omin_mbar_module_fix_event', $
         '0\Unfix\omin_mbar_module_unfix_event', $
         '0\Exclusive\omin_mbar_module_exclusive_event', $
         '0\Update\omin_mbar_module_update_event', $
         '0\Install\omin_mbar_module_install_event', $
         '2\Uninstall\omin_mbar_module_uninstall_event', $
    '1\Tree', $
         '0\Expand\omin_mbar_tree_expand_event', $
         '0\Collapse\omin_mbar_tree_collapse_event', $
         '0\Expand Active\omin_mbar_tree_expand_active_event', $
         '0\Check\omin_mbar_tree_check_event', $
         '0\Uncheck\omin_mbar_tree_uncheck_event', $
         '2\<null>\omin_menu_null_event']
 menu_base = cw__pdmenu(/mbar, mbar, menu_desc, ids=menu_ids, uname='omin_mbar')
 for i=0, n_elements(menu_ids)-1 do $
  begin
   widget_control, menu_ids[i], get_value=value
   widget_control, menu_ids[i], set_uvalue=value
  end


 ;----------------------------------
 ; data structure
 ;----------------------------------
 omin_data = {OMIN_DATA, $
		base			:	base, $
		mbar			:	mbar, $
		menu_ids		:	menu_ids, $
		tab			:	tab, $
		status_label		:	status_label, $
		description_text	:	description_text, $
		menu_base		:	menu_base, $
		fg			:	keyword_set(fg), $
		poll			:	1. $
	}
 widget_control, base, set_uvalue=omin_data

 ;----------------------------------
 ; set up tree
 ;----------------------------------
 omin_update_tree, omin_data


 ;----------------------------------
 ; set poll timer
 ;----------------------------------
 widget_control, /realize, base
; widget_control, base, timer=omin_data.poll
  ;; try folderwatch instead
  ;; folderwatch introduced in IDL 8.7.2


 ;---------------------------------------------------------------------
 ; Do initial module install if new OMINAS installation
 ;---------------------------------------------------------------------
new=1
 if(new) then omin_intro, base


 xmanager, 'omin', base;, /no_block



end
;=============================================================================

