;===============================================================================
; keyword__set
;
;  This routine imitates the original (pre-6.0, before the idiots changed it) 
;  behavior of keyword_set.  x == [0] returns 1, not 0.
;
;===============================================================================
function keyword__set, x

 if(n_elements(x) EQ 1) then $
  if((size(x))[0] EQ 1) then return, 1

 return, keyword_set(x) 
end
;===============================================================================
