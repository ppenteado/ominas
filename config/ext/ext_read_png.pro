;=============================================================================
; ext_read_png
;
;=============================================================================
function ext_read_png, filename, dim=dim, type=type

 dat = read_png(filename, r, g, b)

 dim = size(dat, /dim)
 type = size(dat, /type)

 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])

 return, dat
end
;=============================================================================
