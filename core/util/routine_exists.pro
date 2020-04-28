;=============================================================================
; routine_exists
;
;  Returns 1 if the named procedure is found in the search path, 0 otherwise.
;
;=============================================================================
function routine_exists, name, compile=compile

 if(NOT keyword_set(compile)) then no_recompile = 1

 catch, stat
 if(stat NE 0) then return, 0

 resolve_routine, name, /either, no_recompile=no_recompile
 catch, /cancel

 return, 1
end
;=============================================================================
