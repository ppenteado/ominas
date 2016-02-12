;=============================================================================
;+
; NAME:
;	nv_parse_transient_keyvals
;
;
; PURPOSE:
;	Parses a comma-delimited transient argument string into an of array 
;	of strings containing keyword=value pairs.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	keyvals = nv_parse_transient_keyvals(trs)
;
;
; ARGUMENTS:
;  INPUT:
;	trs:	Transient argument string.
;
;  OUTPUT:
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array of strings containing keyword=value pairs.
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
function nv_parse_transient_keyvals, trs
@nv.include

 return, str_nsplit(trs, ',')

end
;===========================================================================
