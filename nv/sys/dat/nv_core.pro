;=============================================================================
;+
; NAME:
;	nv_core
;
;
; PURPOSE:
;	Returns the core descriptor for each given data descriptor.
;
;
; CATEGORY:
;	NV/SYS/DAT
;
;
; CALLING SEQUENCE:
;	crd = nv_core(dd)
;
;
; ARGUMENTS:
;  INPUT: 
;	dd:	 Data descriptor.
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
;	Core descriptor associated with each given data descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2016
;	
;-
;=============================================================================
function nv_core, ddp, noevent=noevent
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)
 return, dd.crd
end
;===========================================================================
