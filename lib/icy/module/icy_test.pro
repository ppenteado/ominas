;=============================================================================
; icy_test
;
;=============================================================================
pro icy_test
 compile_opt idl2,logical_predicate

 catch,err
 if(err) then exit, status=1

 help, /dlm, output=o
 w = where(stregex(o, 'icy\.so$', /bool))
 output = CSPICE_TKVRSN( 'toolkit' ) + ', '+o[w[0]]
 output = (stregex(output,'Path:[[:blank:]]*(/.*)/lib/icy\.so$',/extract,/subexpr))[-1]
 print, output
 exit, status=0
end
;=============================================================================
