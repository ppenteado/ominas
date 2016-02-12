;==============================================================================
; lic_gethost; disguised as optimize_2d.pro
;
;
;==============================================================================
function optimize_2d, gg=gg

 on_error, 2

;lic_validate_pwd...
 tvhash, 4b, gg=gg
 gg = 0


 ; "IDL_DIR"
 env = string(byte([140,135,143,162,135,140,149]) - 67b)
 path = getenv(env)
 ; "/usr/local/rsi/idl/"
 if(NOT keyword__set(path)) then path = $   
        string(byte([90,160,158,157,90,151,154,142,140,151,90, $
                     157,158,148,90,148,143,151,90]) - 43b)

 ; "/bin/"
 bin = string(byte([102,153,160,165,102]) - 55b)
 path = path + bin
 
 ; "lmhostid"
 spawn, path + string(byte([207,208,203,210,214,215,204,199])-99b), result
 id = str_ext(result[1], '"', '"')


 return, id
end
;==============================================================================
