;===========================================================================
;+
; NAME:
;       sedr_time
;
;
; PURPOSE:
;	Find seconds past 1950 from sedr.
;
;
; CATEGORY:
;       UTIL/SEDR
;
;
; CALLING SEQUENCE:
;       result = sedr_time(sedr)
;
;
; ARGUMENTS:
;  INPUT:
;
;	sedr:		A sedr2 type structure.
;
;
;  OUTPUT: NONE
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
;	Written by:     Haemmerle, 1/1999
;
;-
;===========================================================================
function sedr_time, sedr

 sec = (julday(1,0,sedr.year)-julday(1,0,1950)+sedr.day)*86400d + $
       sedr.hour*3600d + sedr.minute*60d + sedr.second + sedr.msec/1000d

 return, sec
end
