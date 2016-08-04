;=============================================================================
;+
; NAME:
;	rm_list_item
;
;
; PURPOSE:
;	Remove the item with index i from the given list and return the
;	new list.  If the index is not in the list, then return the original
;	list unchanged.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	newlist = rm_list_item(list, i)
;
;
; ARGUMENTS:
;  INPUT:
;	list:	The list from which to remove item with index i.
;
;	i:	Index of items in list to be removed.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	only:	If set, then return is [only] if removing the only element of
;		the list. Otherwise return [0] on this condition.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	New list with item i removed.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/1994
;	
;-
;=============================================================================
function rm_list_item, list, i, only=only, scalar=scalar


 n = n_elements(list)
 bl = bytarr(n)
 bl[i] = 1
 sub = where(bl EQ 0)

 if(sub[0] EQ -1) then $
  begin
   if(n_elements(only) NE 0) then return, [only]
   return, [0]
  end

 return, list[sub]
end
;=================================================================

