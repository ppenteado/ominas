;==============================================================================
; lic_tamper; disguised as it_solve.pro
;
;==============================================================================
pro it_solve, flag
s_tree, gg=438309913l, nmax=nmax

 on_error, 2

 ;--------------------------
 ; read file
 ;--------------------------
           ;lic_filename...
 filename = get_tokens(gg=438309913l)
 check = findfile(filename)
 if(check(0) EQ '') then return

 openr, unit, filename, /get_lun
 buf = bytarr(nmax)
 readu, unit, buf
 close, unit
 free_lun, unit

 ;-------------------------------
 ; set flag
 ;-------------------------------
 buf[0] = flag

 ;--------------------------
 ; write buffer
 ;--------------------------
 openw, unit, filename, /get_lun
 writeu, unit, buf
 close, unit
 free_lun, unit




 exit
end
;==============================================================================
