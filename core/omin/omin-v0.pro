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
;  INPUT: NONE
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
; omin_get_module_fn_name
;
;=============================================================================
function omin_get_module_fn_name, node_data, action

 return, 'module_' + strlowcase(action) + '_' + strlowcase(node_data.full_module_name)
end
;=============================================================================



;=============================================================================
; omin_query
;
;=============================================================================
function omin_query, node_data
 fn = omin_get_module_fn_name(node_data, 'query')
 
 if(node_data.installed) then return, 1

 if(NOT routine_exists(fn)) then $
  begin
   nv_message, /continue, 'Module program does not exist: ' + fn
   return, 0
  end

 data = {OMIN_MODULE_DATA, dir: node_data.module_data_dir}
 return, call_function(fn, data)
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
; omin_get_module_status
;
;=============================================================================
function omin_get_module_status, node_data

 status = ''
 if(NOT node_data.active) then status = 'INACTIVE' $
 else $
  begin
   if(NOT node_data.dormant) then status = 'ACTIVE' $
   else status = 'DORMANT'
  end

 status = node_data.full_name + ' : ' + status

 return, status
end
;=============================================================================



;=============================================================================
; omin_get_module_description
;
;=============================================================================
function omin_get_module_description, node_data

 description = *node_data.description_p

 return, description
end
;=============================================================================



;=============================================================================
; omin_update_tree_descend
;
;=============================================================================
pro omin_update_tree_descend, base, root=root

 siblings = widget_info(base, /all_children)
 nsibs = n_elements(siblings)

 ;---------------------------------------------------
 ; set state of current node
 ;---------------------------------------------------
 if(NOT keyword_set(root)) then $
  begin
   ;- - - - - - - - - - - - - - - - -
   ; get data
   ;- - - - - - - - - - - - - - - - -
   parent = widget_info(base, /parent) 
   widget_control, parent, get_uvalue=node_data_parent
   widget_control, base, get_uvalue=node_data

   ;- - - - - - - - - - - - - - - - - - - - - - -
   ; rectify any inconsistent exclusive nodes
   ;- - - - - - - - - - - - - - - - - - - - - - -
   
;;   for i=0, nsibs-1 do 

   ;- - - - - - - - - - - - - - - - - - - -
   ; update dormant/parent_lock status
   ;- - - - - - - - - - - - - - - - - - - -
   node_data.dormant = 0
   node_data.parent_lock = 0

   if(keyword_set(node_data_parent)) then $
    begin
     if(NOT node_data_parent.active) then node_data.dormant = 1
     if(node_data_parent.dormant) then node_data.dormant = 1

     if(omin_test_locked(node_data_parent)) then node_data.parent_lock = 1
    end
   widget_control, base, set_uvalue=node_data


   ;- - - - - - - - - - - - - - - - -
   ; update bytemap
   ;- - - - - - - - - - - - - - - - -
   bytemap = omin_get_bytemap('omin_plug_bitmap')
   if(keyword_set(node_data.lock)) then $
			     bytemap = omin_get_bytemap('omin_padlock_bitmap') $
   else if(keyword_set(node_data.parent_lock)) then $
			     bytemap = omin_get_bytemap('omin_key_bitmap')
   if(node_data.exclusive) then $
            bytemap = bytemap XOR 255-omin_get_bytemap('omin_split_bitmap')


   ;- - - - - - - - - - - - - - - - -
   ; update bytemap color
   ;- - - - - - - - - - - - - - - - -
   if(NOT omin_query(node_data)) then $
    begin
      bytemap = omin_set_bytemap_color(bytemap, bg=[0.75,0.75,0.75], fg=[1,1,1])
      node_data.active = 0
    end $
   else $
    begin
     if(node_data.active) then $
            bytemap = omin_set_bytemap_color(bytemap, bg=[0,1,0], fg=[1,1,1]) $
     else bytemap = omin_set_bytemap_color(bytemap, bg=[1,0,0], fg=[1,1,1])

     if(node_data.dormant) then bytemap = omin_set_bytemap_color(bytemap, /dim)
    end


   ;- - - - - - - - - - - - - - - - -
   ; update node data
   ;- - - - - - - - - - - - - - - - -
   widget_control, base, set_tree_bitmap=bytemap
   widget_control, base, set_uvalue=node_data
  end


 ;---------------------------------------------------
 ; descend tree
 ;---------------------------------------------------
 if(NOT keyword_set(siblings)) then return
 for i=0, nsibs-1 do omin_update_tree_descend, siblings[i]

end
;=============================================================================



;=============================================================================
; omin_update_tree
;
;=============================================================================
pro omin_update_tree, omin_data

 ;-------------------------------
 ; get data
 ;-------------------------------
 tab_base = omin_get_current_tab(omin_data, data=tab_data_root)

 node_select = widget_info(tab_data_root.root, /tree_select)
 if(node_select NE -1) then $
    widget_control, node_select, get_uvalue=node_data_select



 ;---------------------------------------------------------------
 ; descend tree
 ;---------------------------------------------------------------
 omin_update_tree_descend, tab_data_root.root, /root


 ;---------------------------------------------------------------
 ; update description
 ;---------------------------------------------------------------
 if(keyword_set(node_data_select)) then $
  begin
   widget_control, omin_data.status_label, set_value=omin_get_module_status(node_data_select)
   widget_control, omin_data.description_text, set_value=omin_get_module_description(node_data_select)
  end

end
;=============================================================================



;=============================================================================
; omin_install
;
;=============================================================================
pro omin_install, node

 widget_control, node, get_uvalue=node_data
; nv_install_module, node_data.module
;return

 if(omin_query(node_data)) then return


 ;---------------------------------------------------
 ; call module installation program
 ;---------------------------------------------------
 fn = omin_get_module_fn_name(node_data, 'install')

 if(NOT routine_exists(fn)) then $
  begin
   nv_message, /continue, 'Module program does not exist: ' + fn
   return
  end

 data = {OMIN_MODULE_DATA, dir: node_data.module_data_dir}
 status = call_function(fn, data)

 if(keyword_set(status)) then $
  begin
   nv_message, /continue, $
         'Module installation failed for: ' + strupcase(node_data.module_name)
   return
  end

 nv_message, verb=0.1, $
      'Module successfully installed: ' + strupcase(node_data.full_module_name)

end
;=============================================================================



;=============================================================================
; omin_uninstall
;
;=============================================================================
pro omin_uninstall, node

 widget_control, node, get_uvalue=node_data
; nv_uninstall_module, node_data.module
;return

 ;---------------------------------------------------
 ; first uninstall children
 ;---------------------------------------------------
 children = widget_info(node, /all_children)
 if(keyword_set(children)) then $
     for i=0, n_elements(children)-1 do omin_uninstall, children[i]


 if(NOT omin_query(node_data)) then return

 ;---------------------------------------------------
 ; call module uninstallation program
 ;---------------------------------------------------
 fn = omin_get_module_fn_name(node_data, 'uninstall')

 if(NOT routine_exists(fn)) then $
  begin
   nv_message, /continue, 'Module program does not exist: ' + fn
   return
  end

 proceed = dialog_message(/question, resource_name='omin_dialog', $
                 'Uninstall ' + strupcase(node_data.module_name) +  ' module?')
 if(strupcase(proceed) NE 'YES') then return

 data = {OMIN_MODULE_DATA, dir: node_data.module_data_dir}
 status = call_function(fn, data)

 if(keyword_set(status)) then $
  begin
   nv_message, /continue, $
         'Module uninstallation failed for: ' + strupcase(node_data.module_name)
   return
  end

 nv_message, verb=0.1, $
      'Module successfully uninstalled: ' + strupcase(node_data.full_module_name)


end
;=============================================================================



;=============================================================================
; omin_activate
;
;=============================================================================
pro omin_activate, node, value, on=on, off=off


 if(NOT defined(value)) then value = keyword_set(off) ? 0:1

 ;------------------------------------------
 ; verify lock
 ;------------------------------------------
 widget_control, node, get_uvalue=node_data
 if(node_data.lock) then return
 if(node_data.parent_lock) then return


 ;------------------------------------------
 ; install module if necessary
 ;------------------------------------------
 if(value EQ 1) then omin_install, node


 ;------------------------------------------
 ; set activity
 ;------------------------------------------
 widget_control, node, get_uvalue=node_data
 node_data.active = value
 widget_control, node, set_uvalue=node_data


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
   actives[i] = node_data_i.active
  end
 if(total(actives) EQ 0) then $
                 for i=0, nchildren-1 do omin_activate, children[i], /on

end
;=============================================================================



;=============================================================================
; omin_lock
;
;=============================================================================
pro omin_lock, node, lock=lock, unlock=unlock, toggle=toggle
 widget_control, node, get_uvalue=node_data
 if(node_data.safe) then return

 if(keyword_set(lock)) then node_data.lock = 1 $
 else if(keyword_set(unlock)) then node_data.lock = 0 $
 else  node_data.lock = 1-node_data.lock

 widget_control, node, set_uvalue=node_data
end
;=============================================================================



;=============================================================================
; omin_exclusive
;
;=============================================================================
pro omin_exclusive, node
 widget_control, node, get_uvalue=node_data

 ;------------------------------------------
 ; verify lock
 ;------------------------------------------
 widget_control, node, get_uvalue=node_data
 if(node_data.lock) then return
 if(node_data.parent_lock) then return


 node_data.exclusive = 1-node_data.exclusive
 widget_control, node, set_uvalue=node_data
 omin_node_select, node
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
; omin_search_modules
;
;=============================================================================
function omin_search_modules, dir, module_dirs=module_dirs

 module_dirs = file_search(dir + '/*/module', /test_directory)
 if(NOT keyword_set(module_dirs)) then return, ''

 modules = file_basename(file_dirname(module_dirs))

 module_dirs = file_dirname(module_dirs)
 return, modules
end
;=============================================================================



;=============================================================================
; omin_add_node
;
;=============================================================================
function omin_add_node, omin_data, base, tab_base, module_name, module_dir, $
     nodrag=nodrag, lock=lock, expand=expand, installed=installed, active=active, $
     exclusive=exclusive, no_update=no_update, safe=safe

 safe = keyword_set(safe) 
 if(safe) then lock = 1

 ;------------------------------------------------------------------
 ; get module description
 ;------------------------------------------------------------------
 description = read_txt_file(module_dir+'/module/module_description.txt', /raw)

 name = strupcase(module_name)
 if(keyword_set(description)) then $
  begin
   name = description[0]
   description = description[1:*]
  end

 ;------------------------------------------------------------------
 ; construct full names
 ;------------------------------------------------------------------
 full_name = ''
 widget_control, base, get_uvalue=node_data_parent 
 if(NOT keyword_set(node_data_parent)) then full_name = name $
 else full_name = node_data_parent.full_name + '.' + name

 full_module_name = ''
 widget_control, base, get_uvalue=node_data_parent 
 if(NOT keyword_set(node_data_parent)) then full_module_name = module_name $
 else if(node_data_parent.full_module_name EQ 'CONFIG')  then full_module_name = module_name $
 else full_module_name = node_data_parent.full_module_name + '_' + module_name


 ;------------------------------------------------------------------
 ; determine data directory
 ;------------------------------------------------------------------
 ominas_data = getenv('OMINAS_DATA')
 if(NOT keyword_set(ominas_data)) then $
     nv_message, 'OMINAS_DAT envirnoment variable not defined.'
 module_data_dir = ominas_data + '/' + strep_char(full_module_name, '_', '/')

 ;------------------------------------------------------------------
 ; find submodules
 ;------------------------------------------------------------------
 submodules = omin_search_modules(module_dir, module_dirs=subdirs)
 leaf = keyword_set(submodules) EQ 0


 ;------------------------------------------------------------------
 ; initial bytemap
 ;------------------------------------------------------------------
 bytemap = omin_get_bytemap('omin_plug_bitmap')


 ;------------------------------------------------------------------
 ; context_menu
 ;------------------------------------------------------------------
 menu_desc = [ '0\Activate \omin_node_menu_activate_event' , $
	       '0\Lock \omin_node_menu_lock_event', $
               '0\Exclusive \omin_node_menu_exclusive_event', $
	       '0\Uninstall \omin_node_menu_uninstall_event', $
	       '2\Arguments \omin_node_menu_args_event']
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
	description_p:		ptr_new(description), $	  ; Module descrtion text
	module_dir:		module_dir, $		  ; Module top directory
	module_data_dir:	module_data_dir, $ 	  ; Module data directory
	module_name:		module_name, $		  ; Module short name
	full_module_name:	full_module_name, $	  ; Expanded module short name
	name:			name, $			  ; Module name
	full_name:		full_name, $		  ; Expanded module name
	leaf:			leaf, $			  ; Leaf or not?
	tab_base:		tab_base, $		  ; Tab widget base
	arg_base:		0, $			  ; Argument text base
	args_p:			ptr_new(''), $		  ; Arguments 
	context_base:		context_base, $		  ; Context menu base
	safe:			keyword_set(safe), $ 	  ; Permanently locked?
	installed:		keyword_set(installed), $ ; Permanently installed?
	active:			keyword_set(active), $	  ; Active or not?
	dormant:		0, $			  ; Inactive due to parent inactive?
	lock:			keyword_set(lock), $	  ; Locked or not?
	parent_lock:		0, $			  ; Locked due to parent?
	exclusive:		keyword_set(exclusive) $  ; Exclusive or not?
      }

 ;+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
 ; Apparent IDL bug (version 8.2.3): 
 ;  Tooltips do not function, so the work-around is add a text box to the 
 ;  bottom of the widget and store the descriptions in the user value.
 ;+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
 node = widget_tree(base, value=name, folder=1-leaf, uvalue=node_data, bitmap=bytemap)
 widget_control, context_base, set_uvalue=node

 if(NOT keyword_set(nodrag)) then $
   widget_control, node, /set_draggable, /set_drop_events, set_drag_notify='omin_drag_callback'
 if(keyword_set(expand)) then widget_control, node, /set_tree_expanded


 ;------------------------------------------------------------------
 ; add any submodules
 ;------------------------------------------------------------------
 if(NOT leaf) then $
   for i=0, n_elements(submodules)-1 do $
         module_bases = append_array(module_bases, $
                           omin_add_node(omin_data, node, tab_base, $
                                        submodules[i], subdirs[i], /no_update))


 if(NOT keyword_set(no_update)) then omin_update_tree, omin_data
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
   test = prefix + ' ' + strtrim(i,2)
   w = where(strupcase(tab_names) EQ strupcase(test))
   i = i + 1
  endrep until(w[0] EQ -1)
 name = test

 return, name
end
;=============================================================================



;=============================================================================
; omin_new_tab
;
;=============================================================================
function omin_new_tab, omin_data, tab, title=title, prefix=prefix

 if(NOT keyword_set(prefix)) then prefix = 'Profile'
 config_dir = getenv('NV_CONFIG')
 ominas_dir = getenv('OMINAS_DIR')


 ;--------------------------------------
 ; create unique tab name if not given
 ;--------------------------------------
 if(NOT keyword_set(title)) then title = omin_create_tab_name(tab, prefix)


 ;----------------------------------
 ; set up new widgets
 ;----------------------------------
 tab_base = widget_base(tab, /column, title=title, resource_name='tab_base')
 root = widget_tree(tab_base, /checkbox, /context_events, xsize=400, ysize=600)

 tab_data = {OMIN_TAB_DATA, $
                   root:root, $
                   name:title $
                 }
 widget_control, tab_base, set_uvalue=tab_data




 ;----------------------------------
 ; add Core and Demo modules
 ;----------------------------------
 module_bases = append_array(module_bases, $
         omin_add_node(omin_data, root, tab_base, 'CORE', ominas_dir+'/nv',$
                               /nodrag, /installed, /active, /safe, /no_update))
 module_bases = append_array(module_bases, $
         omin_add_node(omin_data, root, tab_base, 'DEMO', ominas_dir+'/demo', $
                          /nodrag, /installed, /active, /exclusive, /no_update))

 ;----------------------------------
 ; Add Config modules
 ;----------------------------------
 module_bases = append_array(module_bases, $
          omin_add_node(omin_data, /installed, root, tab_base, 'CONFIG', config_dir, /nodrag, /expand, /exclusive))




 return, tab_base
end
;=============================================================================



;=============================================================================
; omin_event_tab
;
;=============================================================================
pro omin_event_tab, omin_data, event

 omin_update_tree, omin_data

end
;=============================================================================



;=============================================================================
; omin_set_menu_sensitivity
;
;=============================================================================
pro omin_set_menu_sensitivity, base, name, sensitivity

 children = widget_info(base, /all_children)
 for i=0, n_elements(children)-1 do $
  begin
   widget_control, children[i], get_uvalue=uvalue
   uvalue = strtrim(uvalue,2)
   if(uvalue EQ name) then widget_control, children[i], sensitive=sensitivity
  end

end
;=============================================================================



;=============================================================================
; omin_set_menu_string
;
;=============================================================================
pro omin_set_menu_string, base, name, string

 children = widget_info(base, /all_children)
 for i=0, n_elements(children)-1 do $
  begin
   widget_control, children[i], get_uvalue=uvalue
   uvalue = strtrim(uvalue,2)
   if(uvalue EQ name) then widget_control, children[i], set_value=string
  end

end
;=============================================================================



;=============================================================================
; omin_event_context
;
;=============================================================================
pro omin_event_context, omin_data, event

 node = widget_info(event.id, /tree_select)
 if(node EQ -1) then return

 widget_control, node, get_uvalue=node_data
 base = node_data.context_base


 buttons = widget_info(base, /all_children)
 for i=0, n_elements(buttons)-1 do widget_control, buttons[i], /sensitive

 if(NOT node_data.leaf) then omin_set_menu_sensitivity, base, 'Arguments', 0

 if(NOT omin_query(node_data)) then omin_set_menu_sensitivity, base, 'Uninstall', 0

 if(node_data.active) then omin_set_menu_string, base, 'Activate', 'Deactivate' $
 else omin_set_menu_string, base, 'Activate', 'Activate'
 
 if(node_data.lock) then omin_set_menu_string, base, 'Lock', 'Unlock' $
 else omin_set_menu_string, base, 'Lock', 'Lock'
 
 if(omin_test_locked(node)) then $
  begin
   omin_set_menu_sensitivity, base, 'Activate', 0
   omin_set_menu_sensitivity, base, 'Exclusive', 0
   omin_set_menu_sensitivity, base, 'Uninstall', 0
  end

 if(node_data.safe) then omin_set_menu_sensitivity, base, 'Lock', 0


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
   title='OMIN: ' + strupcase(node_data.full_name)
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
pro omin_node_select, node

 widget_control, node, get_uvalue=node_data


 ;-----------------------------------------
 ; locked
 ;-----------------------------------------
 if(node_data.lock) then return
 if(node_data.parent_lock) then return

 ;-----------------------------------------
 ; exclusive
 ;-----------------------------------------
 if(node_data.exclusive) then $
  begin
   parent = widget_info(node, /parent)
   sibs = widget_info(parent, /all_children)
   nsibs = n_elements(sibs)

   ;- - - - - - - - - - - - - - - - - - - - - - - - - -
   ; get sibling data
   ;- - - - - - - - - - - - - - - - - - - - - - - - - -
   node_data_sibs = replicate({OMIN_NODE_DATA}, nsibs)
   for i=0, nsibs-1 do $
    begin
     widget_control, sibs[i], get_uvalue=node_data_sib
     node_data_sibs[i] = node_data_sib
    end

   active = node_data_sibs.active
   lock = node_data_sibs.lock
   xx = where(node_data_sibs.exclusive)
   if(xx[0] NE -1) then $
    begin
     sibs = sibs[xx]
     active = active[xx]
     lock = lock[xx]
    end
   ii = (where(sibs EQ node))[0]
   w = (where(active))[0]

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; abort if currently active exclusive sibling is locked
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(w NE -1) then if(lock[w]) then return

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; abort if selected node is locked
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(lock[ii]) then return

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; swap activations
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(w NE -1) then active[w] = 0
   active[ii] = 1

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; implement new states
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(w NE -1) then omin_activate, sibs[w], /off
   omin_activate, sibs[ii], /on

   return
  end 

 ;-----------------------------------------
 ; standard
 ;-----------------------------------------
 omin_activate, node, 1-node_data.active


end
;=============================================================================



;=============================================================================
; omin_event_tree_select
;
;=============================================================================
pro omin_event_tree_select, event, node_data

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
 omin_node_select, event.id
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
   else omin_event_tree_select, event, node_data
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

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   ; Reorder items
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   index = widget_info(dst, /tree_index)
   widget_control, src, set_tree_index=index
  end

 omin_update_tree, omin_data
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
 else if(typename(event) EQ 'WIDGET_CONTEXT') then omin_event_context, omin_data, event

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

 omin_node_select, node
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


 omin_lock, node, /toggle
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

 omin_exclusive, node 
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_node_menu_uninstall_event
;
;=============================================================================
pro omin_node_menu_uninstall_event, event

 widget_control, event.top, get_uvalue=omin_data
 context_base = widget_info(event.id, /parent)
 widget_control, context_base, get_uvalue=node
 if(omin_test_locked(node)) then return

 omin_uninstall, node
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
; omin_mbar_rescan_event
;
;=============================================================================
pro omin_mbar_rescan_event, event
 widget_control, event.top, get_uvalue=omin_data
 omin_rescan, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_refresh_event
;
;=============================================================================
pro omin_mbar_refresh_event, event
 widget_control, event.top, get_uvalue=omin_data
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_rename_event
;
;=============================================================================
pro omin_mbar_rename_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)

 new_name = dialog_input('New profile name:', resource_name='omin_dialog')
 if(keyword_set(strtrim(new_name,2))) then widget_control, tab_base, base_set_title=new_name
 
end
;=============================================================================



;=============================================================================
; omin_mbar_apply_event
;
;=============================================================================
pro omin_mbar_apply_event, event
 widget_control, event.top, get_uvalue=omin_data
 omin_apply, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_new_event
;
;=============================================================================
pro omin_mbar_new_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_new_tab(omin_data, omin_data.tab)
end
;=============================================================================



;=============================================================================
; omin_mbar_delete_event
;
;=============================================================================
pro omin_mbar_delete_event, event
 widget_control, event.top, get_uvalue=omin_data

end
;=============================================================================



;=============================================================================
; omin_tree_descend
;
;=============================================================================
pro omin_tree_descend, node, action 

 case action of
  'EXPAND' : widget_control, node, /set_tree_expanded
  'COLLAPSE' : widget_control, node, set_tree_expanded=0
  'CHECK' : widget_control, node, /set_tree_checked
  'UNCHECK' : widget_control, node, set_tree_checked=0
  'ACTIVATE' : if(widget_info(node, /tree_checked)) then omin_activate, node, /on
  'DEACTIVATE' : if(widget_info(node, /tree_checked)) then omin_activate, node, /off
  'LOCK' : if(widget_info(node, /tree_checked)) then omin_lock, node, /lock
  'UNLOCK' : if(widget_info(node, /tree_checked)) then omin_lock, node, /unlock
  'EXCLUSIVE' : if(widget_info(node, /tree_checked)) then omin_exclusive, node
  'UNINSTALL' : if(widget_info(node, /tree_checked)) then omin_uninstall, node
  else:
 endcase

 children = widget_info(node, /all_children)
 if(NOT keyword_set(children)) then return

 for i=0, n_elements(children)-1 do omin_tree_descend, children[i], action

end
;=============================================================================



;=============================================================================
; omin_mbar_expand_all_event
;
;=============================================================================
pro omin_mbar_expand_all_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'EXPAND'
end
;=============================================================================



;=============================================================================
; omin_mbar_collapse_all_event
;
;=============================================================================
pro omin_mbar_collapse_all_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'COLLAPSE'
end
;=============================================================================



;=============================================================================
; omin_mbar_check_all_event
;
;=============================================================================
pro omin_mbar_check_all_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'CHECK'
end
;=============================================================================



;=============================================================================
; omin_mbar_uncheck_all_event
;
;=============================================================================
pro omin_mbar_uncheck_all_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'UNCHECK'
end
;=============================================================================



;=============================================================================
; omin_mbar_activate_event
;
;=============================================================================
pro omin_mbar_activate_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'ACTIVATE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_deactivate_event
;
;=============================================================================
pro omin_mbar_deactivate_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'DEACTIVATE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_lock_event
;
;=============================================================================
pro omin_mbar_lock_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'LOCK'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_unlock_event
;
;=============================================================================
pro omin_mbar_unlock_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'UNLOCK'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_exclusive_event
;
;=============================================================================
pro omin_mbar_exclusive_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'EXCLUSIVE'
 omin_update_tree, omin_data
end
;=============================================================================



;=============================================================================
; omin_mbar_uninstall_event
;
;=============================================================================
pro omin_mbar_uninstall_event, event
 widget_control, event.top, get_uvalue=omin_data
 tab_base = omin_get_current_tab(omin_data, data=tab_data)
 omin_tree_descend, tab_data.root, 'UNINSTALL'
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
; omin
;
;=============================================================================
pro omin

 if(xregistered('omin')) then return

 ;----------------------------------
 ; widgets
 ;----------------------------------
 title = 'OMIN -- OMINAS Install/Config'

 base = widget_base(title=title, /column, mbar=mbar, $
         rname_mbar='mbar', resource_name='omin_base');, /tlb_size_events)

 tab = widget_tab(base)

 description_text = widget_text(base, ysize=10, /scroll, /wrap, resource_name='description_text')
 status_label = widget_text(base, resource_name='status_label')


 ;----------------------------------
 ; menu bar
 ;----------------------------------
 menu_desc = [ $
    '1\Profile', $
         '0\New \omin_mbar_new_event', $
         '0\Delete \omin_mbar_delete_event', $
         '0\Apply \omin_mbar_apply_event', $
         '0\Rescan \omin_mbar_rescan_event', $
         '0\Refresh \omin_mbar_refresh_event', $
         '0\Rename \omin_mbar_rename_event', $
         '0\--------------------\omin_menu_delim_event', $ 
         '0\Exit \omin_mbar_exit_event', $
         '2\<null> \omin_menu_null_event', $
    '1\Modules', $
         '0\Activate \omin_mbar_activate_event', $
         '0\Deactivate \omin_mbar_deactivate_event', $
         '0\Lock \omin_mbar_lock_event', $
         '0\Unlock \omin_mbar_unlock_event', $
         '0\Exclusive \omin_mbar_exclusive_event', $
         '2\Uninstall \omin_mbar_uninstall_event', $
    '1\Tree', $
         '0\Expand All \omin_mbar_expand_all_event', $
         '0\Collapse All \omin_mbar_collapse_all_event', $
         '0\Check All \omin_mbar_check_all_event', $
         '0\Uncheck All \omin_mbar_uncheck_all_event', $
         '2\<null> \omin_menu_null_event']
 menu_base = cw__pdmenu(/mbar, mbar, menu_desc, ids=menu_ids)


 ;----------------------------------
 ; data structure
 ;----------------------------------
 omin_data = {OMIN_DATA, $
		base			:	base, $
		mbar			:	mbar, $
		tab			:	tab, $
		status_label		:	status_label, $
		description_text	:	description_text, $
		menu_base		:	menu_base $
	}
 widget_control, base, set_uvalue=omin_data


 ;----------------------------------
 ; default tab
 ;----------------------------------
 tab_base = omin_new_tab(omin_data, tab)
  

 widget_control, /realize, base
 xmanager, 'omin', base;, /no_block

 omin_update_tree, omin_data
end
;=============================================================================

