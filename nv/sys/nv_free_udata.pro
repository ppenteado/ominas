;=============================================================================
;+
; NAME:
;	nv_free_udata
;
;
; PURPOSE:
;	Frees a user data array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_free_udata, dd, name
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	name:	String giving the name of the user data aray to free.  If the 
;		name exists, then the corresponding data array is replaced.  
;		Otherwise, a new array is created with this name. 
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro nv_free_udata, ddp, name
@nv.include
 dd = nv_dereference(ddp)

 tag_list_rm, dd.udata_tlp, name

end
;===========================================================================



