;=============================================================================
;+
; NAME:
;	nv_load_data
;
;
; PURPOSE:
;	Loads the data array for a given data descriptor.  Adds to 
;	NV state maintained list if maintain == 1.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = nv_load_data(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor to test.
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
;	Loaded data array.
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
pro nv_load_data, ddp, sample=sample
@nv_block.common
@nv.include
 dd = nv_dereference(ddp)

 if(dd.maintain EQ 1) then nv_manage_dd, ddp

 if(NOT keyword_set(dd.input_fn)) then return

 data = call_function(dd.input_fn, dd.filename, /silent, header, udata, sample=sample)

 if(dd.maintain LT 2) then $
  begin
   nv_suspend_events
   nv_set_data, ddp, data, /silent
   if(keyword_set(udata)) then cor_set_udata, ddp, '', udata;, /silent
   if(keyword_set(header)) then nv_set_header, ddp, header, /silent
   nv_resume_events
  end

end
;=============================================================================
