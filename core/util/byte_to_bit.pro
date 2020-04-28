;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	xx
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
function byte_to_bit, _bytes

  _bytes = byte(_bytes)

  s = size(_bytes)
  nbits = s[1]
  nbytes = 1
  nwords = 1
  if(s[0] GT 1) then nbytes = s[2]
  if(s[0] GT 2) then nwords = s[3]

  _bits = bytarr(nbytes*nwords)
  bytes = reform(_bytes, nbits, nbytes*nwords)

  for i=0, nbits-1 do _bits = _bits + 2^i*bytes[i,*]
  _bits = reform(_bits, nbytes, nwords, /over)


  bits = intarr(nwords)
  for i=0, nbytes-1 do bits = bits + 256^i*_bits[i,*]

  
;bits = swap_endian(bits)

  return, bits
end
;=============================================================================
