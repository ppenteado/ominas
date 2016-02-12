;=============================================================================
;+
; NAME:
;	nv_set_id_string
;
;
; PURPOSE:
;	Replaces the id string in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_id_string, dd, id_string
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	id_string:	New id string.
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
pro nv_set_id_string, ddp, id_string
@nv_block.common
 dd = nv_dereference(ddp)

 dd.id_string = id_string

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;=============================================================================
