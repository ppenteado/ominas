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
;	
;-
;=============================================================================
function cor_tasks, crxp
@nv_lib.include
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1
 crd = nv_dereference(crdp)
 return, *crd.tasks_p
end
;===========================================================================



