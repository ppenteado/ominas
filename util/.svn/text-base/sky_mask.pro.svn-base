;=============================================================================
; sky_mask
;
;=============================================================================
function sky_mask, image, scale, extend=extend

 if(NOT keyword__set(scale)) then scale = 10

 ;-----------------------------------------------------------------------
 ; compute number of points above threshold as a fn of threshold
 ;-----------------------------------------------------------------------
 im = image
 smim = smooth(im, scale)

 n = 15
 nw = lonarr(n)
 bg = median(im)
 delta = (max(smim) - bg) / n
 thresh = dindgen(n)*delta + bg
 
 for i=0, n-1 do $
  begin
   w = where(smim GT thresh[i])
   nw[i] = n_elements(w)
  end

 ;-----------------------------------------------------------------------
 ; look at first and second derivatives of threshold curve;
 ; set threshold at point where the curve flattens out
 ;-----------------------------------------------------------------------
 d = shift(nw,1) - shift(nw,-1)
 d[0] = d[1] & d[n-1] = d[n-2]

 dd = shift(d,1) - shift(d,-1)
 dd[0:1] = dd[2] & dd[n-2:*] = dd[n-3]

 w = max(where(dd EQ max(dd))) - 1

 sky_sub = where(smim LE thresh[w])

 if(keyword__set(extend)) then $
  begin
   imm = image
   imm[*] = 255
   imm[sky_sub] = 0

   imm = smooth(imm, extend)
   sky_sub = where(imm EQ 0)
  end


 return, sky_sub
end
;=============================================================================
