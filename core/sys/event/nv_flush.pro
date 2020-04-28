;=============================================================================
;+
; NAME:
;	nv_flush
;
;
; PURPOSE:
;	Flushes the nv event buffer.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_flush
;
;
; ARGUMENTS: 
;  INPUT:
;	events:	If specified, these events are processed instead of those in 
;		the event buffer.
;
;
; KEYWORDS: NONE
;
;
; RETURN:
;	NONE
;
;
; PROCEDURE:
;	Events are compressed so that duplicate events are not reported.  Each
;	unique handler is called once with all of the relevant events given.
;
;
; COMMON BLOCKS:
;	nv_notify_block
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_notify
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
pro nv_flush, events, clear=clear
@nv_notify_block.common
@core.include

 global = 1

 if(NOT keyword_set(clear)) then $
  begin
   if(NOT keyword_set(events)) then events = nv_compress_events(buf) $
   else global = 0
   if(NOT keyword_set(events)) then return

   ;--------------------------------------------------------------------
   ; call each unique handler only once sending all relevant events
   ;--------------------------------------------------------------------
   ss = sort(events.handler)
   events = events[ss]
   uu = uniq(events.handler)

   nuu = n_elements(uu)
   repeat $
    begin
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; get all events for this handler
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     w = where(events.handler EQ events[uu[0]].handler)

     handler = events[uu[0]].handler
     event = events[w]

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; remove event from buffer before calling handler, in case
     ; the handler generates more events
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     events = rm_list_item(events, w, /scalar)
     if(global) then buf = events

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; call the handler
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     call_procedure, handler, event
    endrep until NOT keyword_set(events)
  end


 ;----------------------------
 ; clear the event buffer
 ;----------------------------
; buf = 0

end
;=============================================================================
