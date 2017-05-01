;=============================================================================
;+
; NAME:
;       xidl_parse_argv
;
; PURPOSE:
;       Parses a given xidl argument list.
;
;	  
; CATEGORY:
;       XIDL
;
;
; CALLING SEQUENCE:
;       argv = xidl_parse_argv(argv, keys, val_ps)
;
;
; ARGUMENTS:
;  INPUT: 
;	argv:	xidl argument list.
;
;  OUTPUT: 
;	keys:	String array giving the names of keywords from any
;		keyword=value pairs.  Also, any argument containing a single
;		'/' as its first character is considered to be a keyword
;		whose value is set to '1'.
;
;	val_ps:	Array of pointers, one for each keyword, giving the values
;		from each keyword=value pair.  Array values are delimited
;		by commas.
;
;
; KEYWORDS: 
;	special_args:	Returns the names of any arguments ending with '@'.
;			Those arguments are reomved from the argument list.
;
; RETURN:
;	The trimmed argument list, with all keywords=value pairs and 
;	special argument removed.
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
function xidl_parse_argv, argv, keys, val_ps, special_args=special_args

 if(NOT keyword_set(argv[0])) then return, ''

 ;---------------------------------------------
 ; Special args end with '@' and are removed 
 ; from argv and returned via the special_args 
 ; output
 ;---------------------------------------------
 stoken = '@'
 test = str_flip(argv)
 w = where(strmid(test, 0, 1) EQ stoken)
 if(w[0] NE -1) then $
  begin
   xx = str_nnsplit(test[w], stoken, rem=rem)
   special_args = str_flip(rem)

   argv = rm_list_item(argv, w, only='')
   if(NOT keyword_set(argv[0])) then return, ''
  end

 ;--------------------------------------------
 ; Anything with '=' is a keyword argument
 ; array inputs are delineated using ','
 ;--------------------------------------------
 nkey = 0 
 p = strpos(argv, '=') 
 w = where(p NE -1) 
 if(w[0] NE -1) then $
  begin 
   raw_keyvals = argv[w] 
   nkey = n_elements(raw_keyvals) 
   val_ps = ptrarr(nkey) 
   keys = strarr(nkey) 
   for i=0, nkey-1 do $
    begin 
     s = str_split(raw_keyvals[i], '=') 
     keys[i] = s[0] 
     val_ps[i] = ptr_new(str_nsplit(s[1], ','))  
    end 

   argv = rm_list_item(argv, w, only='')
   if(NOT keyword_set(argv[0])) then return, ''
  end 

 ;--------------------------------------------
 ; Anything containing only one '/', as the
 ; first character, is also a keyword.
 ;--------------------------------------------
; removed because this is handled in xidl_argv() now...
; w = where(strmid(argv, 0, 1) EQ '/')
; if(w[0] NE -1) then $
;  begin
;   nw = n_elements(w)
;   for i=0, nw-1 do $
;    begin
;     s = argv[w[i]]

;     p = strnpos(s, '/')
;     if(p[0] NE -1) then $
;      if(n_elements(p) EQ 1) then $
;       begin
;        keys = append_array(keys, strmid(s, 1, strlen(s)-1))
;        val_ps = append_array(val_ps, ptr_new('1'))
;        argv = rm_list_item(argv, w[i], only='')
;       end
;    end

;   if(NOT keyword_set(argv[0])) then return, ''
;  end


 ;-----------------------------
 ; the rest are regular args
 ;-----------------------------
 return, argv
end
;===============================================================================
