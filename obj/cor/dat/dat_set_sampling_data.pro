;=============================================================================
;+
; NAME:
;	dat_set_sampling_data
;
;
; PURPOSE:
;	Replaces the sampling function data associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_set_sampling_data, dd, sampling_data
;
;
; ARGUMENTS:
;  INPUT:
;	dd:			Data descriptor.
;
;	sampling_data:	New sampling function data.
;
;  OUTPUT:
;	dd:	Modified data descriptor.
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
; SEE ALSO:
;	dat_sampling_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_set_sampling_data, dd, data, noevent=noevent
@core.include
 cor_set_udata, dd, 'DAT_SAMPLING_DATA', data, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
