;========================================================================
;+
; NAME:
;	ctbrown
;
; PURPOSE:
;	To allocate/return the color brown.
;
;
; CATEGORY:
;       UTIL/CT
;
;
; CALLING SEQUENCE:
;	return = ctbrown()
;
; RETURN:
;	The lookup table or true color value for cyan
;
;-
;========================================================================
function ctbrown, frac
@ct_block.common
 if(_bw) then return, ctblack()
 if(keyword_set(_color)) then return, _color 

 if(NOT defined(frac)) then frac = 1.0

 ctmod, visual=visual

 case visual of
  1		 : return, 1
  8		 : return, !d.table_size - 3
  24		 : return, ctorange(frac*0.5)
  else		 : return, 0
 endcase
end
;========================================================================
