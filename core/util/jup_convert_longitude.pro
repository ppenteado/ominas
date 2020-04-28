;=============================================================================
;+
; NAME:
;	jup_convert_longitude
;
;
; PURPOSE:
;	Convert among Jupiter's I, II, and III longitude systems.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = jup_convert_longitude(lon, jd, from=from, to=to)
;
;
; ARGUMENTS:
;  INPUT:
;	lon:	Longitude to be converted; radians.
;
;	jd:	Julian date.
;
;
; KEYWORDS:
;  INPUT:
;	from:	String specifying the input longitude system 
;		-- 'I', 'II', or 'III'.
;
;	to:	String specifying the output longitude system 
;		-- 'I', 'II', or 'III'.
;
; RETURN:
;	Converted longitude; radians.
;
;
; PROCEDURE:
;	Conversions are based on the physical ephemeris parameters
;	given in table 7.44.1 of the explanatory supplement to the
;	astronomical almanac.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/17/2001
;	
;-
;=============================================================================
function jup_convert_longitude, lon, jd, from=from, to=to


 n = n_elements(from)
 result = dblarr(n)

 jd2000 = 2452545d

 ;------------------------------------------
 ; from system I 
 ;------------------------------------------
 w = where((from EQ 'I') AND (to EQ 'I'))
 if(w[0] NE -1) then result[w] = lon

 w = where((from EQ 'I') AND (to EQ 'II'))
 if(w[0] NE -1) then result[w] = lon - 0.4154 - 0.1332*(jd-jd2000)

 w = where((from EQ 'I') AND (to EQ 'III'))
 if(w[0] NE -1) then result[w] = lon + 3.8022 - 0.12853*(jd-jd2000)

 ;------------------------------------------
 ; from system II 
 ;------------------------------------------
 w = where((from EQ 'II') AND (to EQ 'I'))
 if(w[0] NE -1) then result[w] = lon + 0.4154 + 0.1332*(jd-jd2000)

 w = where((from EQ 'II') AND (to EQ 'II'))
 if(w[0] NE -1) then result[w] = lon

 w = where((from EQ 'II') AND (to EQ 'III'))
 if(w[0] NE -1) then result[w] = lon + 4.21759 + 0.004643*(jd-jd2000)

 ;------------------------------------------
 ; from system III 
 ;------------------------------------------
 w = where((from EQ 'III') AND (to EQ 'I'))
 if(w[0] NE -1) then result[w] = lon - 3.8022 + 0.12853*(jd-jd2000)

 w = where((from EQ 'III') AND (to EQ 'II'))
 if(w[0] NE -1) then result[w] = lon - 4.21759 - 0.004643*(jd-jd2000)

 w = where((from EQ 'III') AND (to EQ 'III'))
 if(w[0] NE -1) then result[w] = lon


 return, result
end
;=============================================================================
