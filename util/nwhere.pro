;=============================================================================
;+
; NAME:
;       nwhere
;
;
; PURPOSE:
;       Finds subscripts of elements in the first input array that match
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
;       reverse_indices:
;              Reverse subscripts for each returned subscript. One per returned
;              subscript.
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
;       Completed, but not as efficient as desired.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function nwhere, ref, list, reverse_indices=reverse_indices

 for i=0l, n_elements(list)-1 do $
  begin
   ww = where(ref EQ list[i])
   if(ww[0] NE -1) then $
    begin
     w = append_array(w, ww)
     if(arg_present(reverse_indices)) then $
                   ii = append_array(ii, make_array(n_elements(ww), val=i))
    end
  end

 if(NOT defined(w)) then w = (ii = -1)

 if(defined(ii)) then reverse_indices = ii
 return, w
end
;===========================================================================



;=============================================================================
function __nwhere, ref, list, reverse_indices=reverse_indices

 n = n_elements(list)

 i=0l
 while(i LT n) do $
  begin
   ww = where(ref EQ list[i])
   w = append_array(w, ww)
   if(arg_present(reverse_indices)) then $
        if(ww[0] NE -1) then $
                   ii = append_array(ii, make_array(n_elements(ww), val=i))
   i = i + 1
  end

; for i=0, n-1 do w[i] = (where(ref EQ list[i]))[0]

 ww = where(w NE -1)
 if(arg_present(reverse_indices)) then $
  begin
   if(keyword__set(ii)) then reverse_indices = unique(ii) $
   else reverse_indices = -1
  end

 if(ww[0] EQ -1) then return, -1
 return, unique(w[ww])
; return, w[ww]
end
;===========================================================================



;=============================================================================
function _nwhere, ref, list

 nrr = n_elements(ref)
 nll = n_elements(list)

 rr = lindgen(nrr) # make_array(nll, val=1l)
 ll = lindgen(nll) ## make_array(nrr, val=1l)

 rr = (rr+ll) mod nrr

 w = where(ref[rr] EQ list[ll])

 return, rr[w]
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
