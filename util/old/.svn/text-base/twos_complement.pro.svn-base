;==============================================================================
; twos_complement
;
;==============================================================================
function twos_complement, x

 type = size(x, /type)

 ;------------------------------------------
 ; separate bytes
 ;------------------------------------------
 case type of
  1 :	b = x
  2 :	b = [ishft(ishft(x,8),-8), $
             ishft(x,-8)]
  3 :	b = [ishft(ishft(x,24),-24), $
             ishft(ishft(x,16),-24), $
             ishft(ishft(x,8),-24), $
             ishft(x,-24)]
  else:	message, 'Only integer types allowed.'
 endcase

 bb = ishft(b[0], indgen(8))

stop

end
;==============================================================================
