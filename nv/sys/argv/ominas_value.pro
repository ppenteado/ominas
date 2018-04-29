;=============================================================================
;+
; NAME:
;       ominas_value
;
; PURPOSE:
;       Returns the value associated with a specified keyword in an
;	argument list, and removes that keyword/value pair from
;	the argument list.  "-" is used instead of "/" to set
;	a keyword to one.  Either "=" or "==" my be used to denote a 
;	keyword/value pair.  The first instance of that delim is
;	taken as the delineator. 
;
;	  
; CATEGORY:
;       BAT
;
;
; CALLING SEQUENCE:
;       value = ominas_value(argv, keyword)
;
;
; ARGUMENTS:
;  INPUT: 
;	argv:	xidl argument list.
;
;	keyword:  
;		String array giving the name of the keyword for which a value 
;		is desired.  Keyword names may be abreviated as in IDL.
;
;
; RETURN:
;	Value associated with the specified keyword, or ''.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Adapted from xidl_value by:     Spitale 6/2017
;
;-
;=============================================================================



;=============================================================================
; bv_get
;
;=============================================================================
function bv_get, argv, keyword, delim, key=key

 for i=0, n_elements(argv)-1 do $
  begin
   key = (val = '')
   keyval = str_split(argv[i], delim)
   if(n_elements(keyval) EQ 2) then $
    begin
     jj = append_array(jj, i, /def)
     keys = append_array(keys, keyval[0])
     vals = append_array(vals, keyval[1])
    end
  end

 if(NOT keyword_set(keys)) then return, ''
 if(NOT keyword_set(vals)) then vals = keys
 n = n_elements(keys)

 if(NOT keyword_set(keyword)) then ii = lindgen(n) $
 else ii = nwhere(keys, keyword)
 if(ii[0] EQ -1) then return, ''


 argv = rm_list_item(argv, jj[ii])
 key = keys[ii]
 return, decrapify(vals[ii])
end
;=============================================================================



;=============================================================================
; ominas_value
;
;=============================================================================
function ominas_value, argv, keyword, delim=delim, keywords=keys

 if(NOT keyword_set(argv[0])) then return, ''
 if(NOT keyword_set(delim)) then delim = ['==', '=']

 for i=0, n_elements(delim)-1 do $
  begin
   val = bv_get(argv, keyword, delim[i], key=key)
   vals = append_array(vals, val)
   keys = append_array(keys, key)
  end

 return, vals
end
;===============================================================================
