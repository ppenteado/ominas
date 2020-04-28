;=============================================================================
;+
; NAME:
;	cor_create_descriptors
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
;	crd = cor_create_descriptors(n)
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cor_create_descriptors, n, crd=_crd0, $
@cor__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1

 crd = objarr(n)
 for i=0, n-1 do $
  begin
   if(keyword_set(_crd0)) then crd0 = _crd0[i]

   crd[i] = ominas_core(i, crd=crd0, $
@cor__keywords.include
end_keywords)

  end
 

 return, crd
end
;===========================================================================



