;=============================================================================
;+
; NAME:
;	bod_ib_data
;
;
; PURPOSE:
;	Returns the function data for a body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	data = bod_ib_data(bd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	bd:	 Body descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Function data associated with the given body descriptor.
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
function bod_ib_data, bd, noevent=noevent
@core.include
 return, cor_udata(bd, 'BOD_IB_DATA', noevent=noevent)
end
;===========================================================================
