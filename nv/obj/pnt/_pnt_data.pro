;=============================================================================
;+
; NAME:
;	_pnt_data
;
;
; PURPOSE:
;	Returns the point-by-point data associated with a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	data = _pnt_data(_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	_ptd:	POINT structure.  If multiple POINT structure are given, 
;		and /cat is not specified, only pointers to the arrays are 
;		returned, and conditions and tags are not applied.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	tags:	If given, data arrays are returned only for these tags,
;		and are arranged in this order.
;
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
;	The point-by-point data associated with the POINT structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_data
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _pnt_data, _ptd, tags=select_tags, condition=condition, ii=ii


 if(n_elements(_ptd) GT 1) then result = _ptd.data_p $
 else $
  begin
   result = 0
   if(ptr_valid(_ptd.data_p)) then $
    begin
     data = *_ptd.data_p
     ntags = (size(data, /dim))[0]

     if(keyword_set(select_tags)) then $
      begin 
       if(ptr_valid(_ptd.tags_p)) then $
        begin
         tags = *_ptd.tags_p
         ntags = n_elements(tags)
         w = nwhere(tags, select_tags)
         if(w[0] NE -1) then ww = w
        end
      end $
     else ww = lindgen(ntags)

     if(defined(ww)) then $
      begin
       result = data[ww,*,*]
       ntags = (size(result, /dim))[0]
       result = reform(result, ntags,n_elements(result)/ntags)

       if((keyword_set(condition)) AND (ptr_valid(_ptd.flags_p))) then $
        begin
         ii = _pnt_apply_condition(_ptd, condition)
         if(ii[0] NE -1) then result = result[*,ii] $
         else result = 0
        end
      end
    end
  end


 return, result
end
;===========================================================================
