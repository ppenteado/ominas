;=============================================================================
;+
; NAME:
;	dat_load_data
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
;	data = dat_load_data(dd)
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_load_data, dd, sample=sample
@nv_block.common
@core.include
 _dd = cor_dereference(dd)

 if(_dd.maintain EQ 1) then dat_manage_dd, dd

 if(NOT keyword_set(_dd.input_fn)) then return

 data = call_function(_dd.input_fn, _dd.filename, /silent, header, udata, sample=sample)

 if(_dd.maintain LT 2) then $
  begin
   nv_suspend_events
   dat_set_data, dd, data, /silent
   if(keyword_set(udata)) then cor_set_udata, dd, '', udata;, /silent
   if(keyword_set(header)) then dat_set_header, dd, header, /silent
   nv_resume_events
  end

end
;=============================================================================
