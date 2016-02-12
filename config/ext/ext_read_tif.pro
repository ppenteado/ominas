;=============================================================================
; ext_read_tif
;
;  NOT TESTED
;=============================================================================
function ext_read_tif, filename, dim=dim

 dat = read_tiff(filename, r, g, b)

 dim = size(dat, /dim)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])

 return, dat
end
;=============================================================================
