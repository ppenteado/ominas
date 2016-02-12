;=============================================================================
;+
; NAME:
;	ps_apply_condition
;
;
; PURPOSE:
;	Selects point in points structures based on a given condition structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	indices = ps_apply_condition(ps, condition)
;
;
; ARGUMENTS:
;  INPUT: 
;	ps:		Points structure.
;
;	condition:	Condition structure to compare against the flags
;			contained in ps.  
;
;			The condition structure is organized as follows:
;			  field	   values
;			  -----------------------------------------------------
;			  mask:	   PS_MASK_INVISIBLE, etc. (see ps_include.pro)
;			  state:   PS_TRUE, PS_FALSE
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
function ps_apply_condition, ps, condition
@ps_include.pro

 flags = *ps.flags_p

 test = flags AND condition.mask

 if(condition.state EQ PS_FALSE) then return, where(test EQ 0)
 return, where(test EQ condition.mask)
end
;===============================================================================
