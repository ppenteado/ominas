;================================================================
;+
; settings_box
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
;  status = settings_box(setup, new_settings=new_settings)
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
;  status=settings_box( $
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
pro settings_box_event, event
 common settings_box_block, settings, status, input_widgets
 widget_control, event.id, get_uvalue=uvalue

 status=0
 case uvalue(0) of
  'INPUT' : 

  'SLIDER' :

  'DROPLIST' :

  'TOGGLE' : 

  'Done' : $
    begin
     settings=strarr(1)
     for i=0, n_elements(input_widgets)-1 do $
      begin
       widget_control, input_widgets(i), get_value=setting
       widget_control, input_widgets(i), get_uvalue=uval
       if(uval(0) EQ 'TOGGLE') then setting=strupcase(setting)
       if(uval(0) EQ 'DROPLIST') then setting=uval(fix(setting)+1)
       if(uval(0) NE 'NOTHING') then $
            settings=[settings, strtrim(setting, 2)]
      end

     settings=settings(1:*)
     widget_control, /destroy, event.top
    end

  'Cancel' : $
    begin
     status=-1
     widget_control, /destroy, event.top
    end

  else :
 endcase

end
;===========================================================================



;===========================================================================
; settings_box
;
;===========================================================================
function settings_box, setup, new_settings=new_settings, $
   title=title, group_leader=group_leader, desensitize=desensitize, $
   message=message, resource_name=resource_name, $
   done_label=done_label, cancel_label=cancel_label
 common settings_box_block, settings, status, input_widgets

 if(NOT keyword_set(done_label)) then done_label = 'Done'
 if(NOT keyword_set(cancel_label)) then cancel_label = 'Cancel'


 DEFAULT_XSIZE=20
 DEFAULT_YSIZE=1


 if(NOT keyword__set(title)) then title='Settings'

;----------------draw settings box------------------

 base = widget_base(title = title, /column, group_leader=group_leader, $
                    resource_name=resource_name)


;----------------message label------------------

 if(keyword_set(message)) then $
  begin
   message_base = widget_base(base, /col)
   message_label = widget_text(message_base, value=message, ysize=n_elements(message))
  end


 non_base=widget_base()

 sub_base=widget_base(base, /row)




;-------------set up user defined fields-----------------

 input_widgets=lonarr(n_elements(setup(0,*)))

 column_base=widget_base(sub_base, /column)
 frame_base=column_base

 for i=0, n_elements(setup(0,*))-1 do $
  begin
   settings_base=widget_base(frame_base, /row)

   case strupcase(setup(1,i)) of
;------------------------------------------------------
    'INPUT' : $
      begin
       label=widget_label(settings_base, value=setup(0,i) )
       if(strtrim(setup(3,i),2) EQ '') then xsize=DEFAULT_XSIZE $
       else xsize=fix(setup(3,i))
       if(strtrim(setup(4,i),2) EQ '') then ysize=DEFAULT_YSIZE $
       else ysize=fix(setup(4,i))

       input_widgets(i)=widget_text(settings_base, value=setup(2,i), $
               /editable, uvalue='INPUT', xsize=xsize, ysize=ysize)
      end

;------------------------------------------------------
    'SLIDER' : $
      begin
       label=widget_label(settings_base, value=setup(0,i) )
       input_widgets(i)=widget_slider(settings_base, value=setup(2,i), $
               minimum=long(setup(3,i)), maximum=long(setup(4,i)),  $
               uvalue='SLIDER' )
      end

;------------------------------------------------------
    'TOGGLE' : $
      begin
       label=widget_label(settings_base, value=setup(0,i) )
       toggle_base=widget_base(settings_base, /nonexclusive)
       input_widgets(i)=widget_button(toggle_base, value='',  $
              uvalue='TOGGLE')
       case strupcase(setup(2,i)) of
        'ON' : widget_control, input_widgets(i), set_value=' ', $
                  /set_button
        'OFF' : widget_control, input_widgets(i), set_value=' ', $
                  set_button=0
       endcase
       if(keyword_set(setup(3,i))) then $
                 widget_control, toggle_base, set_uvalue='EXCLUSIVE'

      end

;------------------------------------------------------
    'DROPLIST' : $
      begin
       h=fix(setup(3,i))
       handle_value, h, list
       init=setup(2,i)
       w=where(list EQ init)
       if(w(0) EQ -1) then index=0 else index=w(0)
       input_widgets(i)=cw_bselector(settings_base, list, $
                uvalue=['DROPLIST',list], $
                /return_name, label_left=setup(0,i))
       widget_control, input_widgets(i), set_value=index
      end
      
;------------------------------------------------------
    'NEW_BASE' : $
      begin
       type=strupcase(setup(2,i))
       row=0
       if(type EQ 'ROW') then row=1
       column=row EQ 0

       frame_base=widget_base(column_base, column=column, row=row, /frame)
       b=frame_base
       if(setup(0,i) EQ '') then b=non_base
       input_widgets(i)=widget_label(b, value=setup(0,i), uvalue='NOTHING')
      end


;------------------------------------------------------
    'NEW_COLUMN' : $
      begin
       column_base=widget_base(sub_base, /column)
       input_widgets(i)=widget_label(non_base, value='', uvalue='NOTHING')
       frame_base=column_base
      end

   endcase

  end

 button_base=widget_base(base, /row)
 done_button=widget_button(button_base, value=done_label, uvalue='Done')
 cancel_button = widget_button(button_base, value=cancel_label, uvalue='Cancel')

 widget_control, /realize, base

 for i=0, n_elements(desensitize)-1 do $
  widget_control, input_widgets(desensitize(i)), sensitive=0

 xmanager, 'settings_box', base

 if(status NE -1) then new_settings=settings

 return, status
end
;================================================================



