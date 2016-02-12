;=============================================================================
;+
; NAME:
;	nv_sibling
;
;
; PURPOSE:
;	Returns the sibling data descriptor associated with a data 
;	descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	sibling_dd = nv_sibling(dd)
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
;	Data descriptor of the sibling.
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
function nv_sibling, ddp
@nv.include
 nv_notify, ddp, type = 1
 dd = nv_dereference(ddp)

 handle_value, dd.sibling_dd_h, sibling_ddp
 return, sibling_ddp
end
;=============================================================================
