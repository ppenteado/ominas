;===============================================================================
; spice_test
;
;===============================================================================
function spice_test

 ;-----------------------------------------------------
 ; check icy dlm
 ;-----------------------------------------------------
 help, 'icy', /dlm, output=s
 if(n_elements(s) EQ 1) then $
  begin
   nv_message, name='spice_test', $
     'ICY DLM not installed properly.', /con, $
       exp=['Attempt to verify ICY DLM status returned the following message:', $
            s]
   return, 0
  end


 ;-----------------------------------------------------
 ; check toolkit version
 ;-----------------------------------------------------
 ver = cspice_tkvrsn('TOOLKIT')
 if(NOT keyword_set(ver)) then $
  begin
   nv_message, name='spice_test', $
     'ICY DLM not installed properly.', /con, $
       exp=['Attempt to verify ICY toolkit version returned a null string.']
   return, 0
  end



 return, 1
end
;===============================================================================
