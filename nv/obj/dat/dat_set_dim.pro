;=============================================================================
;+
; NAME:
;	dat_set_dim
;
;
; PURPOSE:
;	Replaces the dim value in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_set_dim, dd, dim
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	dim:	New dim value.
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
pro dat_set_dim, dd, dim, noevent=noevent
@core.include
 _dd = cor_dereference(dd)

 *_dd.dim_p = dim

 cor_rereference, dd, _dd
 nv_notify, dd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
