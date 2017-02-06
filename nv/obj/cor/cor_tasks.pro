;=============================================================================
;+
; NAME:
;	cor_tasks
;
;
; PURPOSE:
;	Returns the descriptor task list.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	tasks = cor_tasks(crx)
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Any subclass of CORE.  Only one descriptor may be provided.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	String array containing the list of all programs that have modified
;	the given descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cor_tasks, crd, noevent=noevent
@core.include
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)
 return, *_crd.tasks_p
end
;===========================================================================



