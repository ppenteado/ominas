;=============================================================================
;+
; vectors:
;	pnt_template
;
;
; PURPOSE:
;	Creates a new POINT using an existing one as a template.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ptd = pnt_template(ptd0)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd0:		POINT object.
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
;	New POINT with array fields left blank.
;
;
; STATUS:
;	Complete
;
;
;
;
; MODIFICATION HISTORY:
; 	Written:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_template, ptd0

 pnt_get, ptd0, name=name, desc=desc, input=input, assoc_idp=assoc_idp, tags=tags
 ptd = pnt_create_descriptors(tags=tags, name=name, desc=desc, input=input, assoc_idp=assoc_idp)

 return, ptd
end
;==============================================================================
