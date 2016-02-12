;=============================================================================
; getenvs
;
;=============================================================================
function getenvs, name, prefix=prefix, names=names

 if(NOT keyword_set(prefix)) then return, getenv(name)

 spawn, 'set', envs, /sh
; envs = getenv(/env)			; better, but doesn't work in IDL 5.3.


 names = str_nnsplit(envs, '=', rem=vals)

 l = strlen(name)
 w = where(strmid(names, 0, l) EQ name)

 if(w[0] EQ -1) then return, ''

 names = names[w]
 return, vals[w]
end
;=============================================================================
