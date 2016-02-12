;=============================================================================
;+
; NAME:
;	dsk_get_nl
;
;
; PURPOSE:
;	Obtains the nl (number of vertical harmonics) value from the enironment.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	nm = dsk_get_nm()
;
;
; ARGUMENTS:
;  INPUT: NONE
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
; RETURN:
;	Value for nl obtained from the DSK_NL environmet variable.  Default
;	is 4.
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
function dsk_get_nl
@nv_lib.include

 nl_string = getenv('DSK_NL')
 if(keyword__set(nl_string)) then nl = strtrim(nl_string, 2) else nl = 4

 return, nl
end
;===========================================================================
