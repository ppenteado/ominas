;==============================================================================
; lic_validate_pwd; disguised as tvhash
;
;==============================================================================
pro tvhash, flag, gg=gg
s_tree, gg=438309913l, Q=Q

 on_error, 2

 if(keyword__set(Q)) then $
             if(Q EQ (438309913l)) then return

                              ;lic_tamper
 if(NOT keyword__set(gg)) then it_solve, flag
                                  ;lic_tamper
 if(gg NE (438309913l)) then it_solve, flag

end
;==============================================================================
