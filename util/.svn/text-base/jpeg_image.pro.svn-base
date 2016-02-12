;==============================================================================
; jpeg_image
;
;
;==============================================================================
pro jpeg_image, filename, wnum=wnum, mono=mono, order=order

 if(defined(wnum)) then wset, wnum

 if(NOT keyword_set(order)) then order = 1 $
 else order = 0

 if(keyword_set(mono)) then xx = tvrd(ch=1, order=order) $
 else $
  begin
   xx1 = tvrd(ch=1, order=order)
   xx2 = tvrd(ch=2, order=order)
   xx3 = tvrd(ch=3, order=order)
   true = 3
   s = size(xx1)
   xx = bytarr(s[1], s[2], 3)
   xx[*,*,0] = xx1
   xx[*,*,1] = xx2
   xx[*,*,2] = xx3
  end

 write_jpeg, filename, xx, true=true, /order


end
;==============================================================================
