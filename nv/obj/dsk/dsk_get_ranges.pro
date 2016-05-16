;=============================================================================
;+
; NAME:
;	dsk_get_ranges
;
;
; PURPOSE:
;	Returns ranges of valid coordinates for the given DISK object.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	ranges = dsk_get_ranges(dkd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Any subclass of DISK.  One descriptor only.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (2 x 3) giving the ranges in radius, longitude and altitude.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_get_ranges, dkd

 sma = (dsk_sma(dkd[0]))[0,*]


; shouldn't altitudes go from -1d10000 to +1d10000?...

 return, [transpose([sma[0], 0d,      0d]), $
          transpose([sma[1], 2d*!dpi, 1d10000])]
end
;===========================================================================
