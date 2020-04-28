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
function deg_to_hhmmss, deg, hours=hours, min=min, sec=sec

 dhs = deg/360d * 24d

 dhours = fix(dhs)
 hours = strtrim(dhours,2)
 if(strlen(hours) EQ 1) then hours = '0' + hours

 dmin = fix((dhs-dhours)*60d)
 min = strtrim(dmin,2)
 if(strlen(min) EQ 1) then min = '0' + min

 sec = (dhs-dhours-(dmin/60d))*3600d
 if(sec LT 10d) then sec = '0' + strtrim(sec,2) $
 else sec = strtrim(sec,2)

 return, hours+':'+min+':'+sec
end
;=============================================================================
