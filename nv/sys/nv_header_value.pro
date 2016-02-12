;=============================================================================
;+
; NAME:
;	nv_header_value
;
;
; PURPOSE:
;	Reads and write header keyword values.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_header_value, dd, keyword, get=get, set=set
;
;
; ARGUMENTS:
;  INPUT: 
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the keyword to get or set.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	set:	New value to write to the specified keyword.
;
;
;  OUTPUT: NONE
;	get:	Value of the specified keyword read from the header.
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/2013
;	
;-
;=============================================================================
pro nv_header_value, ddp, keyword, get=get, set=set
@nv.include
 if(arg_present(get)) then nv_notify, ddp, type = 1

 dd = nv_dereference(ddp)

 nv_suspend_events
 header = nv_header(ddp)
 nv_resume_events


 ;--------------------------------------------
 ; read
 ;--------------------------------------------
 if(arg_present(get)) then call_procedure, dd.keyword_fn, header, keyword, get=get


 ;--------------------------------------------
 ; write
 ;--------------------------------------------
 if(arg_present(set)) then $
  begin
   call_procedure, dd.keyword_fn, header, keyword, set=set
   nv_set_header, dd, header		; this generates the write event
  end

end
;===========================================================================
