;===========================================================================
; dh_put_array
;
;
;===========================================================================
pro dh_put_array, dh, keyword, value, section=section, comment=comment

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj=n_elements(value)

 ;------------------------------------------
 ; write each array to the detached header
 ;------------------------------------------
 for i=0, n_obj-1 do if(ptr_valid(value[i])) then $
         dh_put_value, dh, keyword, *value[i], obj=i, section=section, $
                                                                comment=comment

end
;===========================================================================
