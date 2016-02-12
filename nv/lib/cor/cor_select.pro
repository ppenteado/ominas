;=============================================================================
;+
; NAME:
;	cor_select
;
;
; PURPOSE:
;	Selects descriptors based on their names.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	xd = cor_select(crx, names)
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Array of descriptors of any subclass of CORE.
;
;	names:	 Array of names to select.
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
;	All descriptors in crx whose CORE names match strings in the input
;	name list.  0 if no mathces found.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function cor_select, crxs, names

 w = nwhere(cor_name(crxs), names)
 if(w[0] EQ -1) then return, 0

 return, crxs[w]
end
;===============================================================================
