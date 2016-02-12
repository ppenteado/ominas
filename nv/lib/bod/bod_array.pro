;===========================================================================
;+
; NAME:
;	bod_array
;
;
; PURPOSE:
;	Returns the array filename for each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	array = bod_array(bx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	array filename associated with each given body descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2012
;	
;-
;===========================================================================
function bod_array, bxp, name, index=index, get_names=get_names
 bdp = class_extract(bxp, 'BODY')
 nv_notify, bdp, type = 1
 bd = nv_dereference(bdp)

 if(keyword_set(get_names)) then return, tag_list_names(bd.arrays_tlp)
 
 return, tag_list_get(bd.arrays_tlp, name, index=index)
end
;===========================================================================



