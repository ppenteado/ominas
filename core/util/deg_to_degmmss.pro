;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	xx
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
function deg_to_degmmss, _deg, deg=deg, min=min, sec=sec

 ddeg = abs(_deg)
 deg = strtrim(fix(ddeg),2)

 dhs = ddeg/24d

 dhours = fix(dhs)

 dmin = fix((dhs-dhours)*60d)
 min = strtrim(dmin,2)
 if(strlen(min) EQ 1) then min = '0' + min

 sec = (dhs-dhours-(dmin/60d))*3600d
 if(sec LT 10d) then sec = '0' + strtrim(sec,2) $
 else sec = strtrim(sec,2)

 if(_deg LT 0) then deg = '-' + deg

 return, deg+':'+min+':'+sec
end
;=============================================================================
