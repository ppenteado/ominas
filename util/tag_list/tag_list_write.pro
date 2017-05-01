;===========================================================================
; tag_list_write
;
;===========================================================================
pro tag_list_write, tlp, filename, unit=unit, bin=bin

 if(NOT keyword_set(unit)) then openw, unit, filename, /get_lun


 list = *tlp
 n = n_elements(list)
 printf, unit, string(n)

 for i=0, n-1 do $
  begin
   data = [*list[i].data_p]

   type = size(data, /type)
   if(type EQ 11) then data = intarr(n_elements(data))	; write zeroes instead of object

   printf, unit, list[i].name
   s = size(data)
   printf, unit, string(s)
   dim = s[1:s[0]]
   if(keyword_set(bin)) then writeu, unit, data $
   else printf, unit, transpose(reform(string(data), product(dim)))
  end


 if(keyword_set(filename)) then $
  begin
   close, unit
   free_lun, unit
  end

end
;===========================================================================




;===========================================================================
; tag_list_write
;
;===========================================================================
pro _tag_list_write, tlp, filename, unit=unit, bin=bin

 if(NOT keyword_set(unit)) then openw, unit, filename, /get_lun


 list = *tlp
 n = n_elements(list)
 printf, unit, string(n)

 for i=0, n-1 do $
  begin
   printf, unit, list[i].name
   data = [*list[i].data_p]
   s = size(data)
   printf, unit, string(s)
   dim = s[1:s[0]]
   data = reform(string(data), product(dim))
   if(keyword_set(bin)) then writeu, unit, data $
   else printf, unit, tr(data)
  end



 if(keyword_set(filename)) then $
  begin
   close, unit
   free_lun, unit
  end

end
;===========================================================================
