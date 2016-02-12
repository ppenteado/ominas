;=============================================================================
;+
; NAME:
;       str_limit_mag
;
;
; PURPOSE:
;       Returns subscripts of stars with magnitudes within the min, max range.
;
;
; CATEGORY:
;       NV/LIB/STR
;
;
; CALLING SEQUENCE:
;       result = str_limit_mag(sd, min=min, max=max)
;
;
; ARGUMENTS:
;  INPUT:
;       sd:    Array of star descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;       min:    Minimum threshold for magnitude.
;
;       max:    Maximum threshold for magnitude.
;
;  OUTPUT:
;         NONE
;
; RETURN:
;       An array of subscripts into sd for stars fitting 
;	min <=  magnitude <= max.
;
;
; SEE ALSO:
;	pg_str_limit_mag
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 5/1998
;
;-
;=============================================================================
function str_limit_mag, sxp, min=min, max=max
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')

 if(NOT keyword__set(min) AND NOT keyword__set(max)) THEN $
         nv_message, name='str_limit_mag', 'No range or limits specified'
 if(NOT keyword__set(min)) then  $
   _min = -999. $
 else $
   _min = min
 if(NOT keyword__set(max)) then $
   _max = 999.  $
 else $
   _max = max
 mag = str_get_mag(sdp)
 sub = where( mag GE _min AND mag LE _max , count )

 if(count EQ 0) then $
        nv_message, name='str_limit_mag', 'No stars fit this criteria'

 return, sub
end
;===========================================================================



