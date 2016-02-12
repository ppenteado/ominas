;===========================================================================
; spice_daf_comment
;
;
;===========================================================================
function spice_daf_comment, fname

 cspice_dafopr, fname, handle
 cspice_dafec, handle, 1024, 2048, n, comment, done
 cspice_dafcls, handle

 if(n_elements(comment) EQ 1) then comment = comment[0]

 return, comment
end
;===========================================================================
