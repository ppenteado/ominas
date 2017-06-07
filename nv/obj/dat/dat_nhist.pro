;=============================================================================
;+
; NAME:
;	dat_nhist
;
;
; PURPOSE:
;	Returns the number of archived data states.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nhist = dat_nhist(dd)
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
;	Integer giving the number of past data states archived
;	in the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_nhist, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)
 return, n_elements(*(*_dd.data_struct_p).data_dap)
end
;===========================================================================



