;=============================================================================
; ext_read_tiff
;
;  NOT TESTED
;=============================================================================
function ext_read_tiff, filename, dim=dim

 dat = read_tiff(filename, r, g, b)

 dim = size(dat, /dim)
 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================
