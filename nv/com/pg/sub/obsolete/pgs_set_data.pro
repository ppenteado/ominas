;=============================================================================
;+
; NAME:
;	pgs_set_data
;
;
; PURPOSE:
;	Sets a data array in the data field from a points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_set_data, data, tags, tag, dat
;
;
; ARGUMENTS:
;  INPUT:
;	data:		Data array from a points structure.
;
;	tags:		Tags for each column in the data array.
;
;	tag:		Tag of data array to set.
;
;	dat:		Data to set.
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
pro pgs_set_data, data, tags, tag, dat
nv_message, /con, name='pgs_set_data', 'This routine is obsolete.'

 w = where(tags EQ tag)
 data[w[0],*] = dat
end
;=============================================================================
