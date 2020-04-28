;==============================================================================
; spawn_function_unpack_args
;
;
;==============================================================================
function spawn_function_unpack_args, argv
 
 if(size(argv, /type) EQ 8) then $
  begin
   tags = tag_names(argv)
   for i=0, n_elements(Tags)-1 do $
            argvv = append_array(argvv, tags[i] + "='" + strtrim(argv.(i),2) + "'")
   argv = argvv
  end
 
 return, str_comma_list(argv)
end
;==============================================================================



;==============================================================================
; spawn_function
;
;==============================================================================
function spawn_function, fn, argv, callback=callback

 args = spawn_function_unpack_args(argv)

 fns = "'" + fn + "'"
 cbs = "'" + callback + "'"
 command = 'idl -quiet -e ' + $
           '"result=spawn_function_wrapper(' + fns + ',' + cbs + ',' + args + ')"'


 spawn, command + '&', pid=pid		; use /nowait for windows
 return, pid
end
;==============================================================================
