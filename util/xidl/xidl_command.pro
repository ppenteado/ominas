;=============================================================================
;+
; NAME:
;       xidl_command
;
; PURPOSE:
;       Produces an IDL command string to be called using EXECUTE.
;
;	  
; CATEGORY:
;       XIDL
;
;
; CALLING SEQUENCE:
;       command = xidl_command(basic_command, keys, val_ps)
;
;
; ARGUMENTS:
;  INPUT: 
;	basic_command:	Basic command string.
;
;	keys:	String array giving the names of keywords aruments.
;
;	val_ps:	Pointer array giving value for each keyword.  These values
;		are strings, or string arrays, but any value that appears
;		to be numeric is passed as a number.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
; RETURN:
;	String giving an IDL command to be called using EXECUTE.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function xidl_command, command, keys, val_ps

 nkey = 0
 if(keyword_set(keys)) then nkey = n_elements(keys)
 for i=0, nkey-1 do $
  begin
   val = *val_ps[i]
   nval = n_elements(val)

   string = 1

   ;------------
   ; int?
   ;------------
   w = str_isnum(val)
   if(w[0] NE -1) then if(n_elements(w) EQ nval) then string = 0

   ;------------
   ; float?
   ;------------
   w = str_isfloat(val)
   if(w[0] NE -1) then if(n_elements(w) EQ nval) then string = 0

   ;----------------
   ; must be string
   ;----------------
   if(string) then val = "'" + val + "'"

   if(nval GT 1) then val = '[' + str_comma_list(val) + ']' $
   else val = val

   command = command + ', ' + keys[i] + '=' + val
  end


 return, command[0]
end
;===============================================================================
