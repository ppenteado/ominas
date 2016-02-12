;=============================================================================
;+
; NAME:
;	nv_header
;
;
; PURPOSE:
;	Returns the header array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	header = nv_header(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
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
;	The header array associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_header
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function nv_header, ddp
@nv.include
 nv_notify, ddp, type = 1

 dd = nv_dereference(ddp)

; if(NOT ptr_valid(dd.data_dap)) then return, 0
; if(NOT data_archive_defined(dd.data_dap, dd.dap_index)) then nv_load_data, ddp

 return, data_archive_get(dd.header_dap, dd.dap_index)
end
;===========================================================================



