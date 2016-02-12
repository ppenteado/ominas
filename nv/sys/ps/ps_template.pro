;=============================================================================
;+
; vectors:
;	ps_template
;
;
; PURPOSE:
;	Creates a new points_struct using an existing one as a template.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps = ps_template(ps0)
;
;
; ARGUMENTS:
;  INPUT:
;	ps0:		Points structure.
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
;	New points_struct with array fields left blank.
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
function ps_template, ps0

 ps_get, ps0, name=name, desc=desc, input=input, assoc_idp=assoc_idp, tags=tags
 ps = ps_init(tags=tags, name=name, desc=desc, input=input, assoc_idp=assoc_idp)

 return, ps
end
;==============================================================================
