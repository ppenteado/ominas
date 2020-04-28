;==============================================================================
; mvbits
;
;==============================================================================
function mvbits, from, frompos, len, topos

 type = size(from, /type)
 case type of
  1: llen = 8
  2: llen = 16
  3: llen = 32
 endcase

 to = ishft(ishft(ishft(from, llen-len-frompos), -(llen-len)), topos)

 return, to
end
;==============================================================================
