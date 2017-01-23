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
;	name:		Name to use for the calling routine instead of 
;			taking it from the traceback list.
;
;	anonymous:	If set, the traaceback list is not used to infer the
;			name of the calling routine.  In this case, a name
;			is printed nly if explicitly specified using the 'name'
;			keyword.
;
;	continue:	If set, execution is not halted.
;
;	stop:		If set, execution is halted in nv_message.
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
;	explanation:	String giving an extended explanation for the message.
;
;	verbose:	Floating value in the range 0 to 1 specifying the 
;			verbosity threshold.  If set, and no string is given, 
;			then the threshold is set to this value.  If a string
;			is given, then it will only be printed if this 
;			value is greater than or equal to current verbosity 
;			level.  Setting this keyword implies /continue.
;
;	silent:		Setting this keyword is equivalent to verbose=0.
;
;  OUTPUT: 
;	message:	If /get_message, this keyword will return the last
;			message sent through nv_message.
;
;
; ENVIRONMENT VARIABLES:
;	NV_VERBOSITY:	If set, this value overrides the stored verbosity
;			setting.
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
pro nv_message, string, name=name, anonymous=anonymous, continue=continue, $
             clear=clear, get_message=get_message, $
             message=_string, explanation=explanation, $
             callback=callback, cb_data_p=cb_data_p, disconnect=disconnect, $
             cb_tag=cb_tag, verbose=verbose, silent=silent, stop=stop
common nv_message_block, last_message, cb_tlp, verbosity
@core.include
@nv_block.common

 ;------------------------------------------------
 ; check environment for verbosity override
 ;------------------------------------------------
 nv_verbosity = getenv('NV_VERBOSITY')
 if(keyword_set(nv_verbosity)) then verbosity = double(nv_verbosity)


 if(keyword_set(silent)) then verbose = 0
 if(defined(verbose)) then continue = 1


 ;------------------------------------------------
 ; set verbosity if no string
 ;------------------------------------------------
 silence = 1
 if(NOT defined(string)) then $
  begin
   if(defined(verbose)) then verbosity = verbose
  end $
 ;---------------------------------------------------------------
 ; otherwise test verbosity state
 ;---------------------------------------------------------------
 else if(verbosity GT 0) then $
  begin
   if(NOT defined(verbose)) then silence = 0 $
   else if(verbose LE verbosity) then silence = 0
  end

 ;---------------------------------------------------------------
 ; always print message if execution is stopped
 ;---------------------------------------------------------------
 if(keyword_set(stop) OR (NOT keyword_set(continue))) then silence = 0


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
; last_message = string

 if(NOT keyword_set(anonymous)) then $
  if(NOT keyword_set(name)) then $
   begin
    help, /traceback, output=trace
    p = strpos(trace, '%')
    w = where(p EQ 0)
    line = strcompress(trace[w[1]])
    ss = parse_comma_list(line, delim=' ')
    name = ss[1]
   end

 if(keyword_set(name)) then string = strupcase(name)+': ' + string

 if((NOT silence) AND (NOT ptr_valid(cb_tlp))) then $
  begin
;   message, string, /continue, /noname
   print, string
   if(keyword_set(explanation)) then print, '	' + explanation
   last_message = string
  end
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
