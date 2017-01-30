;=============================================================================
;+
; NAME:
;	_cor_tasks
;
;
; PURPOSE:
;	Returns the task list.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	tasks = _cor_tasks(_crx)
;
;
; ARGUMENTS:
;  INPUT:
;	_crx:	 Any subclass of CORE.  Only one descriptor may be provided.
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
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _cor_tasks, _crd
 return, *_crd.tasks_p
end
;===========================================================================



