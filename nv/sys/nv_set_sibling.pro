;=============================================================================
;+
; NAME:
;	nv_set_sibling
;
;
; PURPOSE:
;	Changes the sibling in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_sibling, dd, dd_sibling
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	dd_sibling:	Data descriptor of new sibling.
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
pro nv_set_sibling, ddp, ddp_sibling
@nv.include
 dd = nv_dereference(ddp)

 handle_value, dd.sibling_dd_h, ddp_sibling, /set

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================
