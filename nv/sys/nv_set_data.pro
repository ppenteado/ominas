;=============================================================================
;+
; NAME:
;	nv_set_data
;
;
; PURPOSE:
;	Replaces the data array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_data, dd, data
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	data:	New data array.
;
;  OUTPUT:
;	dd:	Modified data descriptor.
;
;
; KEYWORDS:
;  INPUT: 
;	update:	Update mode flag.  If not given, it will be taken from dd.
;
;	silent:	If set, messages are suppressed.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro nv_set_data, ddp, _data, silent=silent, update=update
@nv.include
 dd = nv_dereference(ddp)

 if(NOT defined(update)) then update = dd.update
 if(update EQ -1) then return

 if((NOT keyword_set(silent)) and (dd.maintain GT 0)) then $
  nv_message, /con, name='nv_set_data', $
   'WARNING: Changes to data array may be lost due to the maintainance level.'


 ;--------------------------------------------
 ; compress data if necessary
 ;--------------------------------------------
 if(keyword_set(dd.compress)) then $
     data = call_function('nv_compress_data_' + dd.compress, dd, _data) $
 else data = _data

 ;--------------------------------------------
 ; modify data array if update = 0
 ;--------------------------------------------
 if(NOT keyword_set(update)) then $
  begin
   if(keyword_set(dd.data_dap)) then dap = dd.data_dap
   data_archive_set, dap, data, index=dd.dap_index
   dd.data_dap = dap
   dd.dap_index = 0

   if(NOT ptr_valid(dd.dim_p)) then dd.dim_p = nv_ptr_new(0)
   if(keyword_set(_data)) then *dd.dim_p = size(_data, /dim)
  end


 ;-----------------------------------------------------------------------------
 ; if update = 1, put the new data on a new descriptor; output the new pointer
 ;-----------------------------------------------------------------------------
 if(update EQ 1) then $
  begin
   ddp_new = nv_clone(ddp)
   nv_set_sibling, ddp, ddp_new
   nv_set_data, ddp_new, data, update=0
   ddp = ddp_new
  end


 ;----------------------------------------------
 ; update type code
 ;----------------------------------------------
 dd.type = size(data, /type)
 dd.min = min(data)
 dd.max = max(data)

 ;----------------------------------------------
 ; generate write event on original descriptor
 ;----------------------------------------------
 nv_rereference, ddp, dd
 nv_notify, ddp, type=0, desc='DATA'
 nv_notify, /flush

 
end
;===========================================================================



