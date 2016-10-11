;=============================================================================
; ext_read_bmp
;
;  NOT TESTED
;=============================================================================
function ext_read_bmp, filename, dim=dim

 dat = read_bmp(filename, r, g, b)

 dim = size(dat, /dim)
 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================
