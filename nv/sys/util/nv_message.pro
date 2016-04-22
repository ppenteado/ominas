;=============================================================================
;+
; NAME:
;	nv_message
;
;
; PURPOSE:
;	Prints an error message and halts execution.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_message, string
;
;
; ARGUMENTS:
;  INPUT:
;	string:	Message to print.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	name:		Name of the calling routine.
;
;	continue:	If set, execution is not halted.
;
;	stop:		If set execturion is halted in nv_message.
;
;	get_message:	If set, the last message sent through nv_message
;			is returned in the _string keyword and no other
;			action is taken.
;
;	clear:		If set, the last message is cleared and no other action
;			is taken.
;
;	cb_tag:		If set, the callback procedure below is added to
;			the cllaback list under this tag name and no other
;			action is taken.
;
;	cb_data_p:	Pointer to data for the callback procedure.
;
;	callback:	Name of a callback procedure to add to the callback
;			list.  Callback procedures are sent two arguments:
;			cb_data_p (see above), and the message string.  
;
;	disconnect:	If set, the callback identified by the given cb_tag
;			is removed from the callback list and no other
;			action is taken.
;
;	silent:		If set, no message is printed.
;
;
;  OUTPUT: 
;	message:	If /get_message, this keyword will return the last
;			message sent through nv_message.
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro nv_message, string, name=name, continue=continue, $
             clear=clear, get_message=get_message, message=_string, $
             callback=callback, cb_data_p=cb_data_p, disconnect=disconnect, $
             cb_tag=cb_tag, silent=_silent, stop=stop
common nv_message_block, last_message, cb_tlp, silent
@nv.include

 silent = keyword_set(silent)

 if(defined(_silent)) then silent = _silent

 ;------------------------------------------------
 ; manage callbacks
 ;------------------------------------------------
 if(keyword_set(cb_tag)) then $
  begin
   if(keyword_set(disconnect)) then tag_list_rm, cb_tlp, cb_tag $
   else $
    begin
     data_p = nv_ptr_new()
     if(keyword_set(cb_data_p)) then data_p = cb_data_p
     data = {callback:callback, data_p:data_p}
     tag_list_set, cb_tlp, cb_tag, data
    end
   return
  end

 ;--------------------------------------------------
 ; make sure stored message has a defined value
 ;--------------------------------------------------
 if(NOT keyword_set(last_message)) then last_message = ''

 ;--------------------------------------------------
 ; if /clear, just discard last message
 ;--------------------------------------------------
 if(keyword_set(clear)) then $
  begin
   last_message = ''
   return
  end

 ;--------------------------------------------------
 ; if /get_message, just return with last message
 ;--------------------------------------------------
 if(keyword_set(get_message)) then $
  begin
   _string = last_message
   return
  end

 ;---------------------------------------------------------------
 ; otherwise, store last message and print to terminal
 ;---------------------------------------------------------------
 if(NOT keyword_set(string)) then return
 last_message = string
 if(keyword_set(name)) then string = strupcase(name)+': ' + string
 if((NOT silent) AND (NOT ptr_valid(cb_tlp))) then message, string, /continue, /noname
 if(keyword_set(stop)) then stop
 if(NOT keyword_set(continue)) then retall


 ;----------------------------------------------------
 ; call callbacks
 ;----------------------------------------------------
 if(ptr_valid(cb_tlp)) then $
  begin
   list = *cb_tlp
   n = n_elements(list)
   for i=0, n-1 do $
    begin
     data = tag_list_get(cb_tlp, index=i)
     call_procedure, data.callback, data.data_p, string
    end
  end


end
;===========================================================================
