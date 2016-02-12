;============================================================================
; get_mem
;
;============================================================================
function get_mem, change=change
common get_mem_block, _smem
 if(NOT defined(_smem)) then _smem = 0

 help, /mem, out=s

 smem = long(strmid(s[0], 17, 11))

 if(NOT keyword_set(change)) then result = smem $
 else result = smem - _smem

 _smem = smem

 return, result
end
;============================================================================
