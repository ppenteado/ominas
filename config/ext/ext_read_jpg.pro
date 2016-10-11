;=============================================================================
; ext_read_jpg
;
;  NOT TESTED
;=============================================================================
function ext_read_jpg, filename, dim=dim, type=type

 read_jpeg, filename, dat

 dim = size(dat, /dim)
 type = size(dat, /type)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================
