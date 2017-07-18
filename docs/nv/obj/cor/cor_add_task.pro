;=============================================================================
;+
; NAME:
;	cor_add_task
;
;
; PURPOSE:
;	Adds a task to the descriptor task list.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	cor_add_task, crx, task
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Any subclass of CORE.  Only one descriptor may be provided.
;
;	task:	 String giving the name of a program that modified the 
;		 descriptor.
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
; RETURN: NONE
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
pro cor_add_task, crd, task, noevent=noevent
@core.include
 _crd = cor_dereference(crd)

 n_crd = n_elements(_crd)

 for i=0, n_crd-1 do $
  if(n_elements(*_crd[i].tasks_p) EQ 1 AND $
                   (*_crd[i].tasks_p)[0] EQ '') then *_crd[i].tasks_p = task $
  else *_crd[i].tasks_p = [*_crd[i].tasks_p,task]

 cor_rereference, crd, _crd
 nv_notify, crd, type=0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================



