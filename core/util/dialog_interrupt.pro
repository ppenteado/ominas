;=============================================================================
;+
; dialog_interrupt
;
; PURPOSE
;   Pops up a widget with one button whose purpose is to immediately
;   call a given procedure when pressed, interrupting any current
;   processing.  After the callback procedure returns, a 'retall'
;   is performed.
;
;
; CALLING SEQUENCE :
;
;       base = dialog_interrupt(callback=callback)
;
;
; ARGUMENTS
;  INPUT : NONE
;
;  OUTPUT : NONE
;
;
;
; KEYWORDS 
;  INPUT : callback	Name of a procedure to be called when the
;			interrupt button is pressed,
;
;	   data		data to be passed as the argument to the callback 
;			procedure.
;
;	   text		Text displayed above the button.  Default is
;			'Processing'.
;
;	   label	Label for the interrupt button.  Default is
;			'Interrupt'.
;
;	   resource_name:
;			X resource name.
;
;  OUTPUT : NONE
;
;
;
; RETURN : Widget id of the dialog base, so that it may be destroyed
;	   when the task is complete.  If a dialog is already open,
;	   then -1 is returned.
;
;
; RESTRICTIONS :
;	Only one dialog_interrupt widget will run at any given time.
;
;
; MODIFICATION HISTORY :
;	Spitale; 7/2005
;
;
;-
;=============================================================================
pro dialog_interrupt_event, event

 ;-----------------------------------------
 ; reset timer
 ;-----------------------------------------
 if(event.id EQ event.top) then $
  begin
print, '!!!'
  widget_control, event.top, get_uvalue=interval
  widget_control, event.top, timer=interval
  return   
  end

 widget_control, event.id, get_uvalue=dat
 widget_control, /destroy, event.top
 
 call_procedure, dat.callback, dat.data
 retall
end
;----------------------------------------------------------------
function dialog_interrupt, callback=callback, data=data, label=label, $
  group_leader=group_leader, text=text, interval=interval, resource_name=resource_name

 if(xregistered('dialog_interrupt')) then return, -1

 if(NOT keyword_set(label)) then label = 'Interrupt'
 if(NOT keyword_set(text)) then text = 'Processing...'
 if(NOT keyword_set(data)) then data = 0
 if(NOT keyword_set(interval)) then interval = 1.

 base = widget_base(/col, uvalue=interval, resource_name=resource_name)
 lab = widget_label(base, value='   ' + text + '   ')
 button = widget_button(base, value=label, $
                      uvalue={callback:callback, data:data})

 widget_control, /realize, base
 widget_control, base, timer=interval


 xmanager, 'dialog_interrupt', base, group_leader=group_leader, /no_block

 return, base
end
;================================================================



