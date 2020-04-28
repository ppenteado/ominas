;============================================================================
; divisors
;
;
;============================================================================
function divisors, x, max_denom, tol=tol

 if(NOT keyword_set(max_denom)) then max_denom = 50.
 if(NOT keyword_set(tol)) then tol = 1d-2

 found = 0
 denom = 0d
 repeat $
  begin
   denom = denom + 1
   y = x*denom
   if(y - fix(y) LE tol) then found = 1
  endrep until((found) OR (denom GT max_denom))

 if(found) then return, [fix(y), denom]

 return, 0
end
;============================================================================
