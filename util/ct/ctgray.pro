;========================================================================
;+
; NAME:	
;	ctgray
;
; PURPOSE:
;       Allocate/return a gray level.
;
;
; CATEGORY:
;       UTIL/CT
;
;
; CALLING SEQUENCE:
;       return = ctgray(frac)
;
; RETURN:
;       The lookup table or true color value for the specified gray level.
;
;-
;=======================================================================
function ctgray, frac
@ct_block.common
 if(_bw) then return, ctblack()
 if(keyword_set(_color)) then return, _color 

 if(NOT defined(frac)) then frac = 0.5

 ctmod, visual=visual

 ff = long(255.*frac)

 case visual of
  1		 : return, 1
  8		 : return, !d.n_colors * frac
  24		 : return, ff*65536 +ff*256 + ff
  else		 : return, 0
 endcase
end
;========================================================================
