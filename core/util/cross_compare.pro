;=============================================================================
;+
; NAME:
;       cross_compare
;
;
; PURPOSE:
;       To cross compare two lists generating two sets of indicies which
;       cross compare their elements.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       cross_compare, list1, list2, indices1=indices1, indices2=indices2
;
;
; ARGUMENTS:
;  INPUT:
;       list1:  First list.
;
;       list2:  Second list.
;
;  OUTPUT:
;	NONE
;
; KEYWORDS:
;  INPUT:
;	NONE
;
;  OUTPUT:
;    indices1:  Each element of indices1 gives the index of the list2
;               element which matches that element of list1, or -1.
;
;    indices2:  visa verse as above but with list1
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
pro cross_compare, list1, list2, $
                   indices1=indices1, indices2=indices2

 n1=n_elements(list1)
 n2=n_elements(list2)

 indices1=intarr(n1)
 indices2=intarr(n2)

 for i=0, n1-1 do indices1[i]=where(list1[i] EQ list2)
 for i=0, n2-1 do indices2[i]=where(list2[i] EQ list1)

end
;===========================================================================
