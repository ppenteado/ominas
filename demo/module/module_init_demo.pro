;=============================================================================
; module_init_demo
;
;=============================================================================
function module_init_demo, arg

 nv_message, /warning, /anon, /frame, $
             'THE OMINAS DEMO MODULE IS ACTIVE.', $
                    expl=read_txt_file(arg.method_dir + '/message.txt', /raw)
 return, 0
end
;=============================================================================
