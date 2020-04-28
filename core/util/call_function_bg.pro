;==============================================================================
; call_function_bg_args
;
;
;==============================================================================
function call_function_bg_args, bridge, argv
 
 if(size(argv, /type) EQ 8) then $
  begin
   tags = tag_names(argv)
   for i=0, n_elements(tags)-1 do $
    begin
     args = append_array(args, tags[i] + "='" + strtrim(argv.(i),2) + "'")
     bridge->SetVar, tags[i], argv.(i)
    end
  end
 
 return, str_comma_list(args[[0,1,2,3,4,5]])
end
;==============================================================================



;==============================================================================
; call_function_bg
;
;==============================================================================
function call_function_bg, fn, argv, udata=udata, $
                        callback=callback, fg=fg, bridge=bridge

 if(NOT keyword_set(bridge)) then bridge = obj_new('IDL_IDLBridge')

 args = call_function_bg_args(bridge, argv)

 bridge->SetVar, 'fn', fn
 bridge->SetVar, 'args', args
 bridge->SetProperty, callback=callback
 bridge->SetProperty, userdata=udata
;;; bridge->SetProperty, output=''  ; not supported in IDL 8.2

 command = 'call_function_bg_wrapper, fn, args'
 if(keyword_set(fg)) then $
              result = execute(command + ', callback=callback, udata=udata') $
 else bridge->Execute, command, /nowait

 return, bridge
end
;==============================================================================
