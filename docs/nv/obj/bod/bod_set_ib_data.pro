;=============================================================================
;+
; NAME:
;	bod_set_ib_data
;
;
; PURPOSE:
;	Replaces the function data for a body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_ib_data, bd, data
;
;
; ARGUMENTS:
;  INPUT: 
;	bd:	 Body descriptor.
;
;	data:	 New function data.
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
; MODIFICATION HISTORY:
; 	Adapted by:	Spitale, 7/2016
;	
;-
;=============================================================================
pro bod_set_ib_data, bd, data, noevent=noevent
@core.include
 cor_set_udata, bd, 'BOD_IB_DATA', data, noevent=noevent
end
;===========================================================================
