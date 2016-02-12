;=============================================================================
;+
; NAME:
;	ps_condition
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
;	condition = ps_condition(</visible | /invisible | /select|...>)
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
;   *** The following keywords are defined in ps_condition_keywords.include ***
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
; SEE ALSO: ps_points, ps_vectors, ps_data
;
;
; MODIFICATION HISTORY:
;  	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_condition, condition=condition, $
@ps_condition_keywords.include
end_keywords
@ps_include.pro

;;;; need to be able to combine these; i.e., /visible, /active

 if(keyword_set(condition)) then return, condition

 if(keyword_set(visible)) then return, {mask:PS_MASK_INVISIBLE, state: PS_FALSE}
 if(keyword_set(invisible)) then return, {mask:PS_MASK_INVISIBLE, state: PS_TRUE}
 if(keyword_set(select)) then return, {mask:PS_MASK_SELECT, state: PS_TRUE}

 return, 0
end
;===============================================================================
