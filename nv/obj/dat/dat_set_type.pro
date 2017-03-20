;=============================================================================
;+
; NAME:
;	dat_set_type
;
;
; PURPOSE:
;	Replaces the type value in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_set_type, dd, type
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	type:	New type value.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_set_type, dd, type, noevent=noevent
@core.include
 _dd = cor_dereference(dd)

 _dd.type = type

 cor_rereference, dd, _dd
 nv_notify, dd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
