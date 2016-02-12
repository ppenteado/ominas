;=============================================================================
;+
; NAME:
;	pg_str_limit_mag
;
;
; PURPOSE:
;	Removes stars whose visual magnitude falls outside the given minimum
;	and maximum values.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_str_limit_mag(sd, max=max, min=min)
;
;
; ARGUMENTS:
;  INPUT:
;	sd:	Array of star descriptors.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	max:	Maximum visual magnitude.
;
;	min:	Minimum visual magnitude.
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	Array of star descriptors whose visual magnitudes fall within the
;	specified range.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 1998
;	
;-
;=============================================================================
function pg_str_limit_mag, sds, max=max, min=min

 if(NOT keyword__set(min) AND NOT keyword__set(max)) THEN $
         nv_message, name='pg_str_limit_mag', 'No range or limits specified'
 if(NOT keyword__set(min)) then  subs=str_limit_mag(sds, max=max)
 if(NOT keyword__set(max)) then  subs=str_limit_mag(sds, min=min)
 if(keyword__set(min) AND keyword__set(max)) then $
  subs=str_limit_mag(sds, max=max, min=min)

 return, sds[subs]
end
;===========================================================================



