;=============================================================================
;+
; NAME:
;	nv_notify
;
;
; PURPOSE:
;	Notify nv system of an event on some set of descriptors.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_notify, xd, type=type
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	Descriptor for which an event has occurred.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	type:	Type of event:
;		 0 - set value
;		 1 - get value
;		This input can have only one element.  If not given, the 
;		event type is assumed to be 0.
;
;	flush:	Flush the write event buffer -- call the handlers for each
;		unique event only once and clear the buffer. 
;
;	noevent: If set, nothing is done.
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	NONE
;
;
; PROCEDURE:
;	By default, write events are buffered.  Handlers for write events are 
;	only called when /flush is specified.  For read events, all event 
;	handlers of the specified type are called as procedures with an
; 	nv_event_struct as the argument.
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
;	nv_notify_register, nv_notify_unregister
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2002
;	
;-
;=============================================================================
pro nv_notify, xd, type=type, desc=desc, flush=flush, noevent=noevent
@nv_notify_block.common
@core.include

 if(keyword_set(noevent)) then return
 if(keyword_set(suspended)) then return
 if(NOT keyword_set(desc)) then desc = ''

 ;------------------------------------------------
 ; if no handlers registered, stop here
 ;------------------------------------------------
 if(NOT keyword_set(list)) then return

 ;-------------------------------------------------------------------------
 ; clean up event registry
 ;-------------------------------------------------------------------------
 w = where(obj_valid(list.xd) EQ 0)
 if(w[0] NE -1) then list = rm_list_item(list, w)

 ;------------------------------------------------------------------
 ; if /flush, then compress events in the buffer, call handlers,
 ; then clear buffer
 ;------------------------------------------------------------------
 if(keyword_set(flush)) then $
  begin
   nv_flush
   return
  end

 ;------------------------------------------------
 ; select handlers with specified event type
 ;------------------------------------------------
 if(NOT keyword_set(type)) then llist = list $
 else $
  begin
   w = where(type[0] EQ list.type)
   if(w[0] EQ -1) then return
   llist = list[w]
  end

 ;------------------------------------------------
 ; buffer events for each matching handler 
 ; flush read events immediately
 ;------------------------------------------------
 idp = cor_idp(xd, /noevent)
 n = n_elements(idp)

 for i=0, n-1 do $
  begin
   ww = where(llist.idp EQ idp[i]) 

   if(ww[0] NE -1) then $
    begin
     nww = n_elements(ww)
     events = replicate({nv_event_struct}, nww)
     events.idp = llist[ww].idp
     events.type = llist[ww].type
     events.data = llist[ww].data
     events.data_p = llist[ww].data_p
     events.handler = llist[ww].handler
     events.xd = llist[ww].xd

     events.desc = desc

     compress = llist[ww].compress
     w = where(compress EQ 1)
     if(w[0] NE -1) then buf = append_array(buf, events[w])
     w = where(compress EQ 0)
     if(w[0] NE -1) then nv_flush, events[w]
    end

  end


end
;=============================================================================
