;=============================================================================
; ext_read_xwd
;
;  NOT TESTED
;=============================================================================
function ext_read_xwd, filename, dim=dim, nodata=nodata

 if(keyword_set(nodata)) then $
               nv_message, /con, 'WARNING: /NO_DATA keyword ignored.


 dat = read_xwd(filename, r, g, b)

 dim = size(dat, /dim)
 if(n_elements(dim) EQ 3) then dat = transpose(dat, [1,2,0])
 dim = size(dat, /dim)

 return, dat
end
;=============================================================================
