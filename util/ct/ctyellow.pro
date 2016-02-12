;========================================================================
;+
; NAME:
;       ctyellow
;
; PURPOSE:
;       To allocate/return the color yellow.
;
;
; CATEGORY:
;       UTIL/CT
;
;
; CALLING SEQUENCE:
;       return = ctyellow()
;
; RETURN:
;       The lookup table or true color value for yellow
;
;-
;========================================================================
function ctyellow, frac
@ct_block.common
 if(_bw) then return, ctblack()
 if(keyword_set(_color)) then return, _color 

 if(NOT defined(frac)) then frac = 1.0

 ctmod, visual=visual

 case visual of
  1		 : return, 1
  8		 : return, !d.table_size - 3
  24		 : return, ctred(frac) + ctgreen(frac)
  else		 : return, 0
 endcase
end
;========================================================================
