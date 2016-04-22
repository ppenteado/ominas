;=============================================================================
;+
; NAME:
;	nv_set_compress
;
;
; PURPOSE:
;	Replaces the name of the compression function in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_compress, dd, compress
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	compress:	String giving the name of a new compression function.
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
pro nv_set_compress, ddp, compress
@nv.include
 data = nv_data(ddp)

 dd = nv_dereference(ddp)
 dd.compress = compress
 nv_rereference, ddp, dd

 nv_set_data, ddp, data, /silent	; this will trigger the data event
end
;===========================================================================
