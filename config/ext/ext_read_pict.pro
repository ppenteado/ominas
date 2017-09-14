;=============================================================================
; ext_read_pict
;
;  NOT TESTED
;=============================================================================
function ext_read_pict, filename, dim=dim, nodata=nodata

 stat = query_pict(filename, info)
 if(NOT keyword_set(stat)) then nv_message, 'Not a PICT file: ' + filename
 dim = info.dimensions
 if(info.channels GT 1) then dim = [dim, info.channels] 
 type = info.pixel_type

 if(keyword_set(nodata)) then return, 0

 read_pict, filename, dat, r, g, b

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])

 return, dat
end
;=============================================================================
