;==============================================================================
; cbgw_execute
;
;==============================================================================
function cbgw_execute, fn, _extra=argv
 return, call_function(fn, argv)
end
;==============================================================================



;==============================================================================
; call_function_bg_wrapper
;
;==============================================================================
pro call_function_bg_wrapper, fn, args, callback=callback, udata=udata
 command = 'status = cbgw_execute(fn, ' + args + ')'
 result = execute(command)
 if(keyword_set(callback)) then $
                  call_procedure, callback, status+2, '', obj_new(), udata
end
;==============================================================================
