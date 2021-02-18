;================================================================
;+
; omin_dialog_intro
;
; PURPOSE :
; 	Pops up a widget displaying user specified settings in
; 	various formats, allowing user to change them.  Returns -1
; 	if cancelled, 0 otherwise.  On return, unless cancelled,
; 	the string array new_settings will contain the new settings if it
; 	is set.  If change is set, then the init fields will be changed
; 	to reflect the new settings.
;
; CALLING SEQUENCE :
;
;  status = omin_dialog_intro(setup, new_settings=new_settings)
;
;
; ARGUMENTS
;  INPUT : setup - input string array defining the settings widget, defined
;                  as follows:
;
;                  [ [label, type, init, par1, par2], 
;                    [label, type, init, par1, par2],
;                                  .
;                                  .
;                                  .
;                    [label, type, init, par1, par2] ]
;
;             label : the label for setting field
;
;             type  : the type of setting widget to use, valid types are :
;
;                      INPUT   : input taken from a text widget with x and y
;                                sizes taken from par1 and par2.  Defaults
;                                are xsize=20 and ysize=1.
;
;                      SLIDER  : input taken from a slider widget with max
;                                 and min values par_1 and par_2, respectively.
;
;                      TOGGLE  : input taken from a toggle button with values
;                                 'On' and 'Off'.
;
;                      DROPLIST  : input taken from a drop list.  par1 is
;                                  a handle pointing to the list of possible
;                                  values.
;
;                      NEW_BASE : start a new base with the given label and
;                                 a frame.  Init can be either 'ROW' or
;                                 'COLUMN' for row or column base.  Default
;                                 is column base.
;
;                      NEW_COLUMN : start a new column
;
;             init  : the intial value for that field
;
;             par1, par2 : parameters where applicable
;
;
;  OUTPUT : NONE
;
;
;
; KEYWORDS 
;  INPUT : title - title for the base widget
;
;          group_leader - group leader for the base widget.
;
;          desensitize - array of indices of input widgets to be made
;                        insensitive.
;
;          message - Message to print above the settings widgets.
;
;          resource_name - X resource name.
;
;
;  OUTPUT : new_settings - array containing new settings in the same order
;                         in which they were specified.
;
;
;
;
; RETURN : -1 if cancel was pressed, 0 otherwise.
;
;
;
;
; EXAMPLE :
;
;  status=omin_dialog_intro( $
;          [ ['Volume : ', 'Slider', '3', '0', '10'], $
;            ['Dolby  : ', 'Toggle', 'on', '', ''], $
;            ['Name   : ', 'Input', 'Dan Danberry', '',''] ], $
;               new_settings=new_settings )
;
;
;
; NOTE: numeric data is input and output as a string.
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURES USED:
;
;
;
; KNOWN BUGS : NONE
;
;
;
; ORIGINAL AUTHOR : J. Spitale ; 8/94
;
; UPDATE HISTORY : 
;
;-
;===========================================================================



;===========================================================================
; omin_intro_get_options
;
;===========================================================================
function omin_intro_get_options, items, id_ps, exclusive

 for i=0, n_elements(items)-1 do $
  begin
   ids = *id_ps[i]
   widget_control, items[i], get_value=v
   if(NOT exclusive[i]) then v = where(v EQ 1)
   if(v[0] NE -1) then set_buttons = append_array(set_buttons, ids[v])
  end

 for i=0, n_elements(set_buttons)-1 do $
  begin
   widget_control, set_buttons[i], get_value=label
   option = (str_sep(strtrim(label,2), ' '))[0]
   options = append_array(options, strupcase(option))
  end


 return, options
end
;===========================================================================



;===========================================================================
; omin_dialog_intro_event
;
;===========================================================================
pro omin_dialog_intro_event, event
 common omin_dialog_intro_block, status, items, id_ps, exclusive, options

 if(tag_names(event, /struct) NE 'WIDGET_BUTTON') then return

 widget_control, event.id, get_uvalue=uvalue
 status=0
 case uvalue of
  'Done' : $
    begin
     status = 0
     options = omin_intro_get_options(items, id_ps, exclusive)
     widget_control, /destroy, event.top
    end

  'Cancel' : $
    begin
     status = -1
     widget_control, /destroy, event.top
    end

  else :
 endcase

end
;===========================================================================



;===========================================================================
; omin_dialog_intro
;
;===========================================================================
function omin_dialog_intro, group_leader=group_leader
 common omin_dialog_intro_block, status, items, id_ps, exclusive, options

 if(NOT keyword_set(done_label)) then done_label = 'Done'
 if(NOT keyword_set(cancel_label)) then cancel_label = 'Cancel'

 options = ''
 DEFAULT_XSIZE=20
 DEFAULT_YSIZE=1


 message = $
  ['Welcome to OMINAS.  OMIN (this program) can be used to install', $
   'and uninstall modules, and to manage their configuration.  ', $
   '', $
   'Please select your preferred initial installation parameters and ', $
   'click "Begin Installation."  If you would rather install modules ', $
   'manually, click "Continue With Manual Installation."' ]


 ;--------------------------------------------
 ; set up widgets
 ;--------------------------------------------
 base = widget_base(title='New OMINAS Installation', /column, group_leader=group_leader, $
                    resource_name='omin_intro')

 message_base = widget_base(base, /col, /frame)
 message_label = widget_text(message_base, value=message, ysize=n_elements(message))


 items_base1 = widget_base(base, /col, /frame)
 item = cw__bgroup(items_base1, /exclusive, ids=ids, $
       [' Default Install (install all referenced modules)', $
        ' Full Install (install all available modules)', $
        ' Demo Only (install only modules needed for demo)'], $
        button_uvalue=['DEFAULT', 'FULL', 'DEMO'])
 items = append_array(items, item)
 id_ps = append_array(id_ps, nv_ptr_new(ids))
 exclusive = append_array(exclusive, 1)

 items_base2 = widget_base(base, /col, /frame)
 item = cw__bgroup(items_base2, /nonexclusive, ids=ids, $
       [' Setting1', $
        ' Setting2'], $
        button_uvalue=['S1', 'S2'])
 items = append_array(items, item)
 id_ps = append_array(id_ps, nv_ptr_new(ids))
 exclusive = append_array(exclusive, [0])


 button_base = widget_base(base, /row)
 done_button = widget_button(button_base, value='Begin Installation', uvalue='Done')
 cancel_button = widget_button(button_base, value='Continue With Manual Installation', uvalue='Cancel')


 widget_control, /realize, base
 xmanager, 'omin_dialog_intro', base


 return, options
end
;================================================================



