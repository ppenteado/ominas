;=============================================================================
;+
; NAME:
;	pnt_condition
;
;
; PURPOSE:
;	Returns predefined condition structures for various common situations.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	condition = pnt_condition(</visible | /invisible | /select|...>)
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	condition:	If a condition structure is given as in input, it
;			is returned.
;
;   *** The following keywords are defined in pnt_condition_keywords.include ***
;	
;	visible:	Returns a condition structure corresponding to 
;			points whose visible flag is not set.
;
;	invisible:	Returns a condition structure corresponding to 
;			points whose visible flag is set.
;
;	select:		Returns a condition structure corresponding to 
;			points whose select flag is set.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Condition structure corresponding to the given keyword.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO: pnt_points, pnt_vectors, pnt_data
;
;
; MODIFICATION HISTORY:
;  	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_condition, condition=condition, $
@pnt_condition_keywords.include
end_keywords
@pnt_include.pro

;;;; need to be able to combine these; i.e., /visible, /active

 if(keyword_set(condition)) then return, condition

 if(keyword_set(visible)) then return, {mask:PTD_MASK_INVISIBLE, state: PTD_FALSE}
 if(keyword_set(invisible)) then return, {mask:PTD_MASK_INVISIBLE, state: PTD_TRUE}
 if(keyword_set(select)) then return, {mask:PTD_MASK_SELECT, state: PTD_TRUE}

 return, 0
end
;===============================================================================
