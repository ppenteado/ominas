;=============================================================================
; ext_read_tif
;
;  NOT TESTED
;=============================================================================
function ext_read_tif, filename, dim=dim, nodata=nodata

 stat = query_tiff(filename, info)
 if(NOT keyword_set(stat)) then nv_message, 'Not a TIFF file: ' + filename
 dim = info.dimensions
 if(info.channels GT 1) then dim = [dim, info.channels] 
 type = info.pixel_type

 dat = read_tiff(filename, r, g, b)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])

 return, dat
end
;=============================================================================
