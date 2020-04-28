;=============================================================================
;+
; NAME:
;	graphic_to_centric_lat
;
;
; PURPOSE:
;	Converts planetographic latitudes to planetocentric latitudes.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = graphic_to_centric_lat(a, b, lat0)
;
;
; ARGUMENTS:
;  INPUT:
;	a:	Polar radius.
;
;	b:	Equatorial radius.
;
;	lat0:	Planetocentric latitudes.
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
;
; RETURN:
;	Planetographic latitudes.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
function graphic_to_centric_lat, a, b, lat0 
 return, atan(a/b * tan(lat0))
end
;=============================================================================
