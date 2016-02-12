;=============================================================================
;+
; NAME:
;	bod_get_radec_ranges
;
;
; PURPOSE:
;	Returns ranges of valid  radec coordinates for the given BODY object.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	ranges = bod_get_radec_ranges(bx)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:	 Any subclass of BODY.  One descriptor only.
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
;	Array (2 x 3) giving the ranges in radius, RA and DEC.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function bod_get_radec_ranges, bx
 return, [transpose([-!dpi/2d, 0d,      0d]), $
          transpose([!dpi/2d,  2d*!dpi, 1d10000])]
end
;===========================================================================
