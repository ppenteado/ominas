;===========================================================================
; spice_get_kpath
;
;===========================================================================
function spice_get_kpath, env, klist

 kpaths = str_nsplit(getenv(env), ':')
 n = n_elements(kpaths)

 for i=0, n-1 do $
  if(findfile(kpaths[i]+'/'+klist) NE '') then return, kpaths[i]


 return, ''
end
;===========================================================================
