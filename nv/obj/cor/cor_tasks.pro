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
;  INPUT:  
;	first:	If set, only the first task is returned.
;
;	latest:	If set, only the most recent task is returned.
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
function cor_tasks, crd, first=first, latest=latest, noevent=noevent
@core.include
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)

 tasks = *_crd.tasks_p
 if(keyword_set(first)) then tasks = tasks[0]
 if(keyword_set(latest)) then tasks = tasks[n_elements(tasks)-1]

 return, tasks
end
;===========================================================================



