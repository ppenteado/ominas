;==============================================================================
; spawn_function_wrapper
;
;==============================================================================
function spawn_function_wrapper, fn, callback, _extra=argv
 status = call_function(fn, argv)
 call_procedure, callback, argv, status=status
end
;==============================================================================
