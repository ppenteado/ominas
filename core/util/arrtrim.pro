;=============================================================================
;+
; NAME:
;	arrtrim
;
;
; PURPOSE:
;	Trims all elements matching the given item from an array.  Options 
;	are to trim all matching elements, just leading elements, just
;	trailing elements, or both leading and trailing elements.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = arrtrim(arr, code, match)
;
;
; ARGUMENTS:
;  INPUT:
;	arr:		Array to be trimmed.
;
;	code:		Option code, 0 = trailing, 1=leading, 2=both, 3=all.
;			(See above).
;
;	match:		Object to be trimmed out of the array.  If not defined,
;			the null string '' will be matched.
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
;	The updated array.  If there is only one item in the array,
;	it wil be returned unchanged.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/1995
;	
;-
;=============================================================================



;=============================================================================
; tr_leading
;
;=============================================================================
pro tr_leading, array, match, blanks=blanks

 i=0
 while(i NE -1) do $
  begin

   if(keyword__set(blanks)) then $
    begin
     if(strtrim(array(0),2) EQ '') then array = rm_list_item(array,0) $
     else i=-1
    end $

   else $
    begin
     if(array(0) EQ match) then array = rm_list_item(array,0) $
     else i=-1
    end
  end

end
;=============================================================================



;=============================================================================
; tr_trailing
;
;=============================================================================
pro tr_trailing, array, match, blanks=blanks

 i=0
 while(i NE -1) do $
  begin
   i=n_elements(array)-1

   if(keyword__set(blanks)) then $
    begin
     if(strtrim(array(i),2) EQ '') then array = rm_list_item(array,i) $
     else i=-1
    end $

   else $
    begin
     if(array(i) EQ match) then array = rm_list_item(array,i) $
     else i=-1
    end
  end

end
;=============================================================================



;=============================================================================
; tr_both
;
;=============================================================================
pro tr_both, array, match, blanks=blanks
 tr_leading, array, match, blanks=blanks
 tr_trailing, array, match, blanks=blanks
end
;=============================================================================



;=============================================================================
; tr_all
;
;=============================================================================
pro tr_all, array, match, blanks=blanks

 i=0
 while(i LT n_elements(array)) do $
  begin

   if(keyword__set(blanks)) then $
    begin
     if(strtrim(array(i),2) EQ '') then array = rm_list_item(array,i) $
     else i=i+1
    end $

   else $
    begin
     if(array(i) EQ match) then array = rm_list_item(array,i) $
     else i=i+1
    end
  end

end
;=============================================================================



;=============================================================================
; arrtrim
;
;=============================================================================
function arrtrim, arr, code, match

 if(n_elements(arr) EQ 1) then return, arr

 blanks = NOT keyword__set(match)

 array=arr

 case code of

  0 : tr_trailing, array, match, blanks=blanks

  1 : tr_leading, array, match, blanks=blanks

  2 : tr_both, array, match, blanks=blanks

  3 : tr_all, array, match, blanks=blanks

 endcase

 return, array
end
;=============================================================================
