;============================================================================
; counter
;
;
;============================================================================
function counter, reset=reset, print=print
common counter_block, count
 if(NOT defined(count)) then count = 0 $
 else count = count + 1
 if(keyword_set(reset)) then count = -1
 if(keyword_set(print)) then print, count
 return, count
end
;============================================================================
