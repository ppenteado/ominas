;===========================================================================
; dh_put_matrix
;
;
;===========================================================================
pro dh_put_matrix, dh, keyword, value, section=section, comment=comment

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj=1
 s=size(value)
 if(s[0] EQ 3) then n_obj=s[3]

 ;------------------------------------------
 ; write each matrix to the detached header
 ;------------------------------------------
 for i=0, n_obj-1 do $
          dh_put_value, dh, keyword, value[*,*,i], obj=i, section=section, $
                                                                comment=comment

end
;===========================================================================
