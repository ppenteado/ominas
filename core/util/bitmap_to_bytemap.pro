;==============================================================================
; bitmap_to_bytemap
;
;
;==============================================================================
function bitmap_to_bytemap, bitmap

 bdim = size(bitmap, /dim)
 dim = bdim*[8,1]

 bytemap = bytarr(dim)
 mask = 2^bindgen(8) #make_array(dim[1],val=1b)

 for i=0, bdim[0]-1 do $
  begin
   bmi = bitmap[i,*] ## make_array(8,val=1b)
   bytemap[8*i:8*(i+1)-1,*] = ((bmi AND mask) GT 0) * 255
  end

 bytemap = bytemap[linegen3z(dim[0],dim[1],3)]

 return, bytemap
end
;==============================================================================
