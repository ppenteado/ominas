;=============================================================================
;+
; NAME:
;	nv_get_directive
;
;
; PURPOSE:
;	Extracts the directive string from a directive struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dir = nv_get_directive(dst)
;
;
; ARGUMENTS:
;  INPUT:
;	dst:		Structure to test.
;
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
;	Value of the directive string.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2015
;	
;-
;=============================================================================
function nv_get_directive, dst
 tags = tag_names(dst)

 if(n_elements(tags) EQ 1) then return, ''
 if(tags[0] NE 'DIRECTIVE') then return, ''

 return, tags[1]
end
;===========================================================================



