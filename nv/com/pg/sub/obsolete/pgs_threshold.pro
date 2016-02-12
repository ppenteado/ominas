;=============================================================================
;+
; NAME:
;	pgs_threshold
;
;
; PURPOSE:
;	Flags points whose given indicator falls below or above a given 
;	threshold.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_threshold, pp, indicators, threshold, /above
;	pgs_threshold, pp, indicators, threshold, /below
;
;
; ARGUMENTS:
;  INPUT:
;	pp:		Points structure.
;
;	indicators:	Values to be tested against the threshold.  One for 
;			point in pp.
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
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro pgs_threshold, pp, indicators, threshold, above=above, below=below
@pgs_include.pro
nv_message, /con, name='pgs_threshold', 'This routine is obsolete.'

 if(NOT keyword__set(pp)) then return

 ;-----------------------------
 ; apply threshold
 ;-----------------------------
 if(keyword_set(above)) then w = where(indicators LT threshold)
 else if(keyword_set(below)) then w = where(indicators GT threshold)

 if(w[0] EQ -1) then return

 ;-----------------------------
 ; set flags
 ;-----------------------------
 pgs_points, pp, flags=flags
 flags[w] = flags[w] & PGS_INVISIBLE_FLAG
 pp = pgs_set_points(pp, flags=flags)

end
;===========================================================================
