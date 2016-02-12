;=============================================================================
; ext_read_x11
;
;  NOT TESTED
;=============================================================================
function ext_read_x11, filename, dim=dim

 read_x11_bitmap, filename, dat, /expand_to_bytes

 dim = size(dat, /dim)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])

 return, dat
end
;=============================================================================
