;===========================================================================
; tag_list_read
;
;===========================================================================
function tag_list_read, filename, unit=unit, bin=bin

 if(NOT keyword_set(unit)) then openr, unit, filename, /get_lun


 ns = ''
 readf, unit, ns
 n = long(ns)

 list = replicate({tag_list_struct}, n)

 for i=0, n-1 do $
  begin
   name = ''
   readf, unit, name

   ss = ''
   readf, unit, ss
   ss = strtrim(strcompress(ss), 2)
   s = long(str_nsplit(ss, ' '))
   dim = s[1:s[0]]
   type = s[s[0]+1]

   line = ''
   nn = product(dim)
   data = make_array(nn, type=type)

   if(keyword_set(bin)) then readu, unit, data $
   else $
    for j=0, nn-1 do $
     begin
      readf, unit, line
      data[j] = str_convert(strtrim(line,2), type)
     end

   data = reform(data, dim)

   list[i].name = name
   list[i].data_p = nv_ptr_new(data)
  end




 if(keyword_set(filename)) then $
  begin
   close, unit
   free_lun, unit
  end


 return, nv_ptr_new(list)
end
;===========================================================================
