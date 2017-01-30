;=============================================================================
;+
; NAME:
;	_pnt_flags
;
;
; PURPOSE:
;	Returns the flags associated with a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	flags = _pnt_flags(_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	_ptd:	POINT structure.  If multiple POINT structures are given, 
;		and /cat is not speciied, only pointers to the arrays are 
;		returned, and conditions and tags are not applied.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	condition:	Structure specifing a mask and a condition with which to
;			match flag values.  The structure must contain the fields
;			MASK and STATE.  MASK is a bitmask to test against
;			the flags field of the POINT structure, and STATE
;			is either PS_TRUE and PS_FALSE.  Note that in this case, 
;			the values will be returned as a list, with no separation 
;			into nv and nt dimensions.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The flags associated with the POINT structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_flags
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _pnt_flags, _ptd, condition=condition, ii=ii


 if(n_elements(_ptd) GT 1) then result = _ptd.flags_p $
 else $
  begin
   result = 0
   if(ptr_valid(_ptd.flags_p)) then $
    begin
     result = *_ptd.flags_p
     result = reform(result, n_elements(result))

     if(keyword_set(condition)) then $
      begin
       ii = _pnt_apply_condition(_ptd, condition)
       if(ii[0] NE -1) then result = result[ii] $
       else result = 0
      end
    end
  end


 return, result
end
;===========================================================================
