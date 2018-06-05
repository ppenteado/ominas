;=============================================================================
;+
; NAME:
;       bat_parse_argv
;
; PURPOSE:
;       Parses a given idl argument list.
;
;	  
; CATEGORY:
;       BAT
;
;
; CALLING SEQUENCE:
;       argv = bat_parse_argv(argv, keys, val_ps)
;
;
; ARGUMENTS:
;  INPUT: 
;	argv:	idl argument list.
;
;  OUTPUT: 
;	keys:	String array giving the names of keywords from any
;		keyword=value pairs.  Also, any argument containing a single
;		'-' as its first character is considered to be a keyword
;		whose value is set to '1'.
;
;	val_ps:	Array of pointers, one for each keyword, giving the values
;		from each keyword=value pair.  Array values are delimited
;		by commas.
;
;
; KEYWORDS: 
;  INPUT: NONE
;
;  OUTPUT: 
;	special_args:	Returns the names of any arguments ending with '@'.
;			Those arguments are removed from the argument list.
;
;	sample:		Returns the file_sample value (see below).
;
;	select:		Returns the file_select value (see below).
;
;
; GLOBAL SHELL KEYWORDS: 
;	file_sample:
;		Sets file list sampling; see read_txt_file.
;
;	file_select:
;		Sets file selection criterion; see read_txt_file.
;
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
;       Adapted from xidl_parse_argv by:     Spitale 6/2017
;
;-
;=============================================================================
function bat_parse_argv, keys, val_ps, $
           special_args=special_args, sample=file_sample, select=file_select

; if(NOT keyword_set(argv[0])) then return, ''

 ;---------------------------------------------
 ; Special args end with '@' and are removed 
 ; from argv and returned via the special_args 
 ; output
 ;---------------------------------------------
 special_args = ominas_value(delim='@')


 ;----------------------------------------------------------------
 ; get global keyword/value pairs
 ;----------------------------------------------------------------
 file_sample = ominas_value('file_sample')
 file_select = ominas_value('file_select')


 ;--------------------------------------------
 ; get keywords / values
 ;--------------------------------------------
 values = ominas_value(key=keywords)
 if(keyword_set(keywords)) then $
  for i=0, n_elements(keywords)-1 do $
   begin
    keys = append_array(keys, keywords[i])
    val_ps = append_array(val_ps, ptr_new(str_nsplit(values[i], ',')))
   end


 ;--------------------------------------
 ; return positional args
 ;--------------------------------------
  return, ominas_argv()
end
;===============================================================================
