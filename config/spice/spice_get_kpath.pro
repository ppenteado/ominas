;===========================================================================
; spice_get_kpath
;
;===========================================================================
function spice_get_kpath, env, klist

 kpaths = str_nsplit(getenv(env), ':')
 n = n_elements(kpaths)

 for i=0, n-1 do $
  if(file_test(kpaths[i]+'/'+klist)) then return, kpaths[i]


 return, ''
end
;===========================================================================
