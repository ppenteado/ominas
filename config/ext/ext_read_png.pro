;=============================================================================
; ext_read_png
;
;=============================================================================
function ext_read_png, filename, dim=dim, type=type, nodata=nodata

 stat = query_png(filename, info)
 if(NOT keyword_set(stat)) then nv_message, 'Not a PNG file: ' + filename
 dim = info.dimensions
 if(info.channels GT 1) then dim = [dim, info.channels] 
 type = info.pixel_type

 if(keyword_set(nodata)) then return, 0

 dat = read_png(filename, r, g, b)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================



;=============================================================================
; ext_read_png
;
;=============================================================================
function ext_read_png, filename, dim=dim, type=type, nodata=nodata

 if(keyword_set(nodata)) then $
               nv_message, /con, 'WARNING: /NO_DATA keyword ignored.


 dat = read_png(filename, r, g, b)

 dim = size(dat, /dim)
 type = size(dat, /type)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================
