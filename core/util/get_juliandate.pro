;=============================================================================
;+
; NAME:
;       get_juliandate
;
;
; PURPOSE:
;       To obtain the Julian Date
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = get_juliandate(stime=stime, string=string, format=format)
;
;
; ARGUMENTS:
;  INPUT:
;       NONE
;
;  OUTPUT:
;	NONE
;
; KEYWORDS:
;  INPUT:
;         string:       If set, time is output as a string.
;
;         format:       Format to use if output is string.  Default is
;                       (d14.6)
;
;  OUTPUT:
;          stime:       System time
;
; RETURN:
;       Julian date in floating point or a string if /string used.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_juliandate, stime=stime, string=string, format=format

 btime = bin_date((stime=systime()))
 jd = julday(btime[1], btime[2], btime[0]) + $
                                (btime[3] + btime[4]/60d + btime[5]/3600d)/24d

 if(NOT keyword__set(format)) then format='(d14.6)'
 if(keyword__set(string)) then jd = string(jd, format=format)

 return, jd
end
;=============================================================================
