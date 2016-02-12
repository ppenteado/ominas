;=============================================================================
;+
; NAME:
;	nv_set_nhist
;
;
; PURPOSE:
;	Changes the number of past states archived in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_nhist, dd, nhist
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	nhist:	New nhist value.
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro nv_set_nhist, ddp, nhist
@nv.include
 dd = nv_dereference(ddp)

 dap = dd.data_dap
 data_archive_set, dap, nhist=nhist
 dd.data_dap = dap

 dd.dap_index = dd.dap_index < (nhist-1) > 0

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================
