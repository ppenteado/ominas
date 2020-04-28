;=============================================================================
;+
; NAME:
;	fixed_array
;
;
; PURPOSE:
;	Creates and array of fixed length by either truncating the given array
;	or padding it with zeroes or null characters.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = fixed_array(array, len)
;
;
; ARGUMENTS:
;  INPUT:
;	array:	Array to fix.
;
;	len:	Length of output array.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS: NONE
;
;
; RETURN:
;	Array with len elements.  If input array contains more than len 
;	elements, it is truncated, if it contains fewer, then int is padded
;	with zeroes or null characters.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
function fixed_array, array, len

 n = n_elements(array)
 if(n EQ len) then return, array

 ;---------------------------
 ; truncate if necessary
 ;---------------------------
 if(n GT len) then return, array[0:len-1]

 ;---------------------------------
 ; otherwise pad output array
 ;---------------------------------
 pad = 0
 type = size(array, /type)
 if(type EQ 7) then pad = ''

 result = make_array(len, type=type)
 result[0:n-1] = array

 return, result
end
;=============================================================================
