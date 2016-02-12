;=============================================================================
;+
; NAME:
;       n_where
;
;
; PURPOSE:
;       Finds subscripts where an element in the first array matches
;       elements in the second input array.  This routine differs
;	from nwhere in that 1) it works as advertised, and 2) it uses
;	array operations for a faster search.  Also, this routine
;	works only for numeric types.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = n_where(ref, list)
;
;
; ARGUMENTS:
;  INPUT:
;        ref:  Reference array
;
;       list:  Comparison array.
;
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;       NONE
;
;
; RETURN:
;       An array of subscripts in list that match something in ref.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function n_where, ref, list

 nlist = n_elements(list)
 nref = n_elements(ref)

 rref = ref ## make_array(nlist, val=1d)
 llist = list # make_array(nref, val=1d)

 diff = (rref - llist) EQ 0
 if((size(diff))[0] EQ 2) then diff = total(diff, 2)

 return, where(diff NE 0)
end
;===========================================================================
