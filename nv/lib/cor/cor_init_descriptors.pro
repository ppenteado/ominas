;=============================================================================
;+
; NAME:
;	cor_init_descriptors
;
;
; PURPOSE:
;	Init method for the CORE class.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	crd = cor_init_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	 Number of descriptors to create.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	crd:	Core descriptor(s) to initialize, instead of creating a new one.
;
;	name:	 String giving the name of the descriptor.
;
;	user:	 String giving the username for the descriptor.
;
;	tasks:	 String array giving the initial task list.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created or or freshly initialized core descriptors depending
;	on the presence of the crd keyword.
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
function cor_init_descriptors, n, crd=crd, $
@cor__keywords.include
end_keywords
@nv_lib.include

 if(NOT keyword_set(n)) then n = n_elements(crd)

 if(NOT keyword_set(crd)) then crd=replicate({core_descriptor}, n)
 crd.class=decrapify(make_array(n, val='CORE'))
 crd.abbrev=decrapify(make_array(n, val='COR'))

 for i=0, n-1 do $
  begin
   if(keyword_set(tasks)) then crd[i].tasks_p=nv_ptr_new(tasks[*,i]) $
   else crd[i].tasks_p=nv_ptr_new([''])
   crd[i].idp = nv_ptr_new(1)
  end

 if(keyword_set(name)) then crd.name=decrapify(name)

 if(NOT keyword_set(user)) then user=make_array(n, val=get_username())
 crd.user=decrapify(user)

 crdp = ptrarr(n)
 nv_rereference, crdp, crd

 return, crdp
end
;===========================================================================



