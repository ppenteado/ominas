;=============================================================================
;+
; NAME:
;	_pnt_points
;
;
; PURPOSE:
;	Returns the points associated with a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	points = _pnt_points(_ptd)
;
;
; ARGUMENTS:
;	_ptd:	POINT structure.  If multiple POINT structures are given, 
;		and /cat is not speciied, only pointers to the arrays are 
;		returned, and conditions and tags are not applied.
;
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
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The points associated with the POINT structure, or zero.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	_pnt_set_points
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function _pnt_points, _ptd, condition=condition, ii=ii


 if(n_elements(_ptd) GT 1) then result = _ptd.points_p $
 else $
  begin
   result = 0
   if(ptr_valid(_ptd.points_p)) then $
    begin
     result = *_ptd.points_p
     result = reform(result, 2,n_elements(result)/2)

     if((keyword_set(condition)) AND (ptr_valid(_ptd.flags_p))) then $
      begin
       ii = _pnt_apply_condition(_ptd, condition)
       if(ii[0] NE -1) then result = result[*,ii] $
       else result = 0
      end
    end
  end


 return, result
end
;===========================================================================



