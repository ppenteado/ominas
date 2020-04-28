;=============================================================================
;+
; dialog_input
;
; PURPOSE
;   Pops up a widget displaying the string msg, with a text widget
;   for keyboard entry of data.  The input box is always modal.
;
;
; CALLING SEQUENCE :
;
;       result = dialog_input(msg, [title, no_beep])
;
;
; ARGUMENTS
;  INPUT : msg - String array containing the message to be displayed.
;                 Each element of the array will be separated by a
;                 carriage return.
;
;  OUTPUT : NONE
;
;
;
; KEYWORDS 
;  INPUT : fname - Name of file to read message from instead of using
;                  'msg' argument.
;
;          max_ysize - Maximum size for message window before adding
;                      a scroll bar.
;
;          title - The title for the widget, default is 'Question'
;
;          beep -    If set, the appearance of the widget
;                    will be accompanied by a beep.
;
;          init_text - initial text for the input text widget, 
;                      default is ''.
;
;          xoffset, yoffset - Coordinates of the upper left corner of the
;                             box relative to the root window..
;
;          no_cancel - do not include the cancel button.  Since the
;                      cancel button causes '' to be returned, it is
;                      equivalent to hitting enter with nothing in the
;                      input text widget.  Thus is many cases, the cancel
;                      button is redundant.  It would not be redundant,
;                      however, when you use inital input text and
;                      you do not want the user to have to destroy
;                      it to cancel the action.
;
;  OUTPUT : cancelled - 1 for cancel pressed, 0 for cancel not pressed.
;
;
;
; RETURN : The string in the input text widget when the user presses
;          return.  If Cancel is pressed, then the null string '' is
;          returned.
;
;
;
; EXAMPLE :
;
;  ans = dialog_input( ['Please enter your hat size : '])
;
;
; KNOWN BUGS : NONE
;
;
;
; MODIFICATION HISTORY :
;	J. Spitale ; 6/94	(drm_input_box)
;	Spitale 5/2005; renamed dialog_input,
;	                added 'Ok' button 
;			removed drm calls
;
;
;-
;=============================================================================
pro dialog_input_event, event
common inbox_block, value, cancel_event, input_box

 widget_control, event.id, get_uvalue=type

 case type of
  'TEXT' :  widget_control, input_box, get_value=value

  'OK' :  widget_control, input_box, get_value=value

  'CANCEL' : $
      begin
       cancel_event=1
       value=''
      end
 endcase

 widget_control, /destroy, event.top
 
end
;----------------------------------------------------------------

function dialog_input, msg, title=title, beep=beep, $
  group_leader=group_leader, init_text=init_text, no_cancel=no_cancel, $
  cancelled=cancelled, fname=fname, max_ysize=max_ysize, $
  mac_overwrite=mac_overwrite, mac_append=mac_append, $
  xoffset=xoffset, yoffset=yoffset, resource_name=resource_name

common inbox_block, value, cancel_event, input_box

 cancel_event=0

 if(NOT keyword_set(xoffset)) then xoffset=400
 if(NOT keyword_set(yoffset)) then yoffset=400

 if(keyword_set(fname)) then msg=read_txt_file(fname, status=status)
 if(NOT keyword_set(max_ysize)) then max_ysize=25

 if(NOT keyword_set(init_text)) then init_text=''
 if(keyword_set(beep)) then print, string([7b])     ; bell

;-----------compute size of text widget-----------
 
 xs=max(strlen(msg))
 ys=n_elements(msg)<max_ysize
 if(ys LT n_elements(msg)) then scroll=1 else scroll=0

;----------------draw message box------------------

 if(NOT keyword_set(title)) then title='Question'
 base = widget_base(Title = title, resource_name=resource_name, $
                     xoffset=xoffset, yoffset=yoffset, /column)
 message = widget_text(base, value = msg,ysize=ys, xsize=xs, scroll=scroll)

 input_box = widget_text(base, value=init_text, ysize=1, xsize=xs, /editable, $
   /frame, uvalue='TEXT')

 button_base = widget_base(base, /row, /grid)
 if(NOT keyword_set(no_cancel)) then $
  cancel_button = widget_button(button_base, value= 'Cancel', uvalue='CANCEL')
 ok_button = widget_button(button_base, value= 'Ok', uvalue='OK')

 widget_control, /realize, base
 widget_control, input_box, /input_focus

 xmanager, 'dialog_input', base, group_leader = group_leader, /modal

 cancelled = keyword_set(cancel_event)

 return, value(0)
end
;================================================================



