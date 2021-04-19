;=============================================================================
;+
; NAME:
;	dat_detect_instrument
;
;
; PURPOSE:
;	Attempts to detect the instrument for a data set by calling the 
;	detectors in the instrument detectors table.  Detectors that 
; 	crash are ignored and a warning is issued.  This behavior is disabled 
;	if $OMINAS_DEBUG is set.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	instrument = dat_detect_instrument(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	String giving the instrument, or 'DEFAULT' if none detected.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function dat_detect_instrument, dd
 dat_sort_detectors, instrument_detectors=instrument_detectors
 return, dat_detect(dd, instrument_detectors, null='DEFAULT')
end
;=============================================================================


