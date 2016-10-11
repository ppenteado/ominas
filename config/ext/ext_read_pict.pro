;=============================================================================
; ext_read_pict
;
;  NOT TESTED
;=============================================================================
function ext_read_pict, filename, dim=dim

 read_pict, filename, dat, r, g, b

 dim = size(dat, /dim)
 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================
