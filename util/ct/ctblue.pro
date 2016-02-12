;========================================================================
;+
; NAME:
;       ctblue
;
; PURPOSE:
;       To allocate/return the color blue.
;
;
; CATEGORY:
;       UTIL/CT
;
;
; CALLING SEQUENCE:
;       return = ctblue()
;
; RETURN:
;       The lookup table or true color value for blue
;
;-
;=======================================================================
function ctblue, frac
@ct_block.common
 if(_bw) then return, ctblack()
 if(keyword_set(_color)) then return, _color 

 if(NOT defined(frac)) then frac = 1.0

 ctmod, visual=visual

 ff = long(255.*frac)

 case visual of
  1		 : return, 1
  8		 : return, !d.table_size - 4
  24		 : return, ff*65536
  else		 : return, 0
 endcase
end
;========================================================================
