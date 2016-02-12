;=============================================================================
;+
; NAME:
;	pgs_data
;
;
; PURPOSE:
;	Retrieves a data array from the data field from a points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	result = pgs_data(data, tags, tag)
;
;
; ARGUMENTS:
;  INPUT:
;	data:		Data array from a points structure.
;
;	tags:		Tags for each column in the data array.
;
;	tag:		Tag of data array to return.
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
;
;
; RETURN: NONE
;
;
; SEE ALSO:
;	pgs_points
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function pgs_data, data, tags, tag
nv_message, /con, name='pgs_data', 'This routine is obsolete.'
 w = where(tags EQ tag)
 return, reform(data[w[0], *])
end
;=============================================================================
