;===============================================================================
; caller
;
; This is a risky implementation.  Should find a way to do it without using
; the help procedure.
;
;===============================================================================
function caller, n, all=all, parent=parent

 if(NOT keyword_set(n)) then n = 0

 help, /tr, out=s

 s = strcompress(s[1:*])
 w = where(strmid(s, 0, 1) EQ '%')
 if(w[0] EQ -1) then return, ''
 s = s[w]

 void = str_nnsplit(s, ' ', rem=rem)
 callers = str_nnsplit(rem, ' ', rem=rem)
 w = where(callers EQ '')
 if(w[0] NE -1) then callers[w] = rem[w]

 void = str_nnsplit(rem, '/', rem=paths)
 paths = '/' + paths
 parent = strupcase(file_basename(paths))

 w = where(strmid(str_flip(parent),0,4) EQ str_flip('.PRO'))
 if(w[0] NE -1) then parent[w] = str_nnsplit(parent[w], '.')

 w = where(parent EQ callers)
 if(w[0] NE -1) then parent[w] = ''

 if(keyword_set(all)) then return, str_cull(callers)

 n = n + 1
 if(n GE n_elements(callers)) then return, ''
 parent = parent[n]
 return, callers[n]
end
;===============================================================================



;===============================================================================
; caller
;
; This is a risky implementation.  Should find a way to do it without using
; the help procedure.
;
;===============================================================================
function _caller, n, all=all

 if(NOT keyword_set(n)) then n = 0

 help, /tr, out=s

 s = strcompress(s[1:*])
 w = where(strmid(s, 0, 1) EQ '%')
 if(w[0] EQ -1) then return, ''
 s = s[w]

 void = str_nnsplit(s, ' ', rem=rem)
 callers = str_nnsplit(rem, ' ')
 w = where(callers EQ '')
 if(w[0] NE -1) then callers[w] = rem[w]
 if(keyword_set(all)) then return, str_cull(callers)

 n = n + 1
 if(n GE n_elements(callers)) then return, ''
 return, callers[n]
end
;===============================================================================




;===============================================================================
; caller
;
;
;===============================================================================
function __caller, n, all=all

 if(NOT keyword_set(n)) then n = 0

 help, /tr, out=s

 w = where(strmid(s, 0, 1) EQ '%')
 s = strcompress(s[w])
 void = str_nnsplit(s, ' ', rem=rem)
 callers = str_nnsplit(rem, ' ')
 if(keyword_set(all)) then return, str_cull(callers)

 return, callers[n+2]
end
;===============================================================================
