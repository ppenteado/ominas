;===========================================================================
; reduce_range
;
;===========================================================================
function reduce_range, _x, _min, _max, inclusive=inclusive

 x = _x - _min
 max = _max - _min

 y = x mod max

 if(keyword_set(inclusive)) then $
  begin
   w = where(x EQ max)
   if(w[0] NE-1) then y[w] = max
  end

 if(keyword_set(inclusive)) then w = where(y LT 0) $
 else w = where(y LE 0)
 if(w[0] NE -1) then y[w] = y[w] + max

 if(keyword_set(inclusive)) then w = where(y GT max) $
 else w = where(y GE max)
 if(w[0] NE -1) then y[w] = y[w] - max

 return, y + _min
end
;===========================================================================
