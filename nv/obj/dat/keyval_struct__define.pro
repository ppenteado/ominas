;=============================================================================
;+
; NAME:
;	keyval_struct__define
;
;
; PURPOSE:
;	Structure defining a keyword/value pair.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	keywords_p:	Pointer to list of keywords.
;
;	values_p:	Pointer to list of value strings.
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
pro keyval_struct__define

 struct = $
    { keyval_struct, $
	keywords_p:		nv_ptr_new(), $	; Pointer to keywords
	values_p:		nv_ptr_new() $	; Pointer to values
    }


end
;===========================================================================



