;=============================================================================
;+
; NAME:
;       nwhere
;
;
; PURPOSE:
;       Finds subscripts where an element in the first array matches
;       elements in the second input array.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = nwhere(ref, list)
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
;       An array of subscripts in ref that match something in list.
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
function nwhere, ref, list

 n = n_elements(list)

 i=0l
 while(i LT n) do $
  begin
   w = append_array(w, where(ref EQ list[i]))
   i = i + 1
  end

; for i=0, n-1 do w[i] = (where(ref EQ list[i]))[0]

 ww = where(w NE -1)

 if(ww[0] EQ -1) then return, -1
 return, w[ww]
end
;===========================================================================




;=============================================================================
function ___nwhere, ref, list

 n = n_elements(list)
 w = lonarr(n)

 i=0l
 while(i LT n) do $
  begin
   w[i] = (where(ref EQ list[i]))[0]
   i = i + 1
  end

; for i=0, n-1 do w[i] = (where(ref EQ list[i]))[0]

 ww = where(w NE -1)

 if(ww[0] EQ -1) then return, -1
 return, w[ww]
end
;===========================================================================
