;=============================================================================
;+
; NAME:
;	ps_threshold
;
;
; PURPOSE:
;	Flags points whose given indicator falls below or above a given 
;	threshold.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps_threshold, ps, indicators, threshold, /above
;	ps_threshold, ps, indicators, threshold, /below
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points structure.
;
;	indicators:	Values to be tested against the threshold.  One for 
;			each point in ps.
;
;	threshold:	Threshold value.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	above:	If set, values above the theshold are allowed.
;
;	below:	If set, values below the theshold are allowed.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_threshold
;	
;-
;=============================================================================
pro ps_threshold, ps, indicators, threshold, above=above, below=below
@ps_include.pro

 if(NOT keyword__set(ps)) then return

 ;-----------------------------
 ; apply threshold
 ;-----------------------------
 if(keyword_set(above)) then w = where(indicators LT threshold)
 else if(keyword_set(below)) then w = where(indicators GT threshold)

 if(w[0] EQ -1) then return

 ;-----------------------------
 ; set flags
 ;-----------------------------
 flags = ps_flags(ps)
 flags[w] = flags[w] AND PS_MASK_INVISIBLE
 ps_set_flags, ps, flags

end
;===========================================================================
