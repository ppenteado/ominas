;===========================================================================
; spice_get_kpath
;
;===========================================================================
function spice_get_kpath, env, klist

 kpaths = str_nsplit(getenv(env), ':')
 if(NOT keyword_set(kpaths)) then $
  begin
   nv_message, name='spice_get_kpath', /con, $
     'Unable to obtain ' + env +' from the environment.', $                         
       exp=[env + ' is a colon-separated list of directories in which to search', $
            'for kernel list files.']
   return, ''
  end


 n = n_elements(kpaths)

 for i=0, n-1 do $
  if(file_test(kpaths[i]+'/'+klist)) then return, kpaths[i]

 return, ''
end
;===========================================================================
