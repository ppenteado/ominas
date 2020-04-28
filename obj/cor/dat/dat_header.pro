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

 return, data_archive_get((*_dd.dd0p).header_dap, (*_dd.dd0p).dap_index)
end
;===========================================================================



