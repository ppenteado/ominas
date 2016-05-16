;=============================================================================
;+
; NAME:
;	dsk_get_nm
;
;
; PURPOSE:
;	Obtains the nm (number of radial harmonics) value from the enironment.
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
;	Value for nm obtained from the DSK_NM environmet variable.  Default
;	is 4.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_get_nm
@core.include

 nm_string = getenv('DSK_NM')
 if(keyword__set(nm_string)) then nm = strtrim(nm_string, 2) else nm = 4

 return, nm
end
;===========================================================================
