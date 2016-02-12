;===========================================================================
; dh_put_scalar
;
;
;===========================================================================
pro dh_put_scalar, dh, keyword, value, section=section, comment=comment

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj=n_elements(value)

 ;------------------------------------------
 ; write each object to the detached header
 ;------------------------------------------
 for i=0, n_obj-1 do $
         dh_put_value, dh, keyword, value[i], obj=i, section=section, $
                                                                comment=comment

end
;===========================================================================
