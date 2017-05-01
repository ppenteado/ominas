;=============================================================================
;+
; NAME:
;	nv_compress_events
;
;
; PURPOSE:
;	Returns only unique events from the given buffer.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	events = nv_compress_events(buf)
;
;
; ARGUMENTS:
;  INPUT:
;	buf:	Array of nv_event_struct.
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
;	All events in buf that are unique.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function nv_compress_events, buf
@core.include

 if(NOT keyword_set(buf)) then return, 0

 n = n_elements(buf)
 mark = bytarr(n)

 ;------------------------------------------
 ; mark events to remove
 ;------------------------------------------
 for i=0, n-1 do $
  begin
   event = buf[i]
   w = where((buf.type EQ event.type) AND $
             (buf.handler EQ event.handler) AND $
             (buf.data EQ event.data) AND $
             (buf.data_p EQ event.data_p) AND $
             (buf.xd EQ event.xd))
   if(n_elements(w) GT 1) then mark[w[1:*]] = 1 
  end

 ;-------------------------------------------------------------------------
 ; remove marked events
 ;-------------------------------------------------------------------------
 w = where(mark EQ 1)
 if(w[0] NE -1) then events = rm_list_item(buf, w) $
 else events = buf


 return, events
end
;=============================================================================
