;=============================================================================
;+
; NAME:
;	dat_header
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
;	header = dat_header(dd)
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
;	dat_set_header
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_header, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent

 _dd = cor_dereference(dd)

; if(NOT ptr_valid(_dd.data_dap)) then return, 0
; if(NOT data_archive_defined(_dd.data_dap, _dd.dap_index)) then dat_load_data, dd

 return, data_archive_get(_dd.header_dap, _dd.dap_index)
end
;===========================================================================



