;=============================================================================
;+
; NAME:
;       ominas_value
;
; PURPOSE:
;       Returns the value associated with a specified keyword in an
;	argument list.  Either "=" or "==" my be used to denote a 
;	keyword/value pair.  The first instance of that delim is
;	taken as the delimiter. 
;
;	  
; CATEGORY:
;       BAT
;
;
; CALLING SEQUENCE:
;       value = ominas_value(keyword)
;
;
; ARGUMENTS:
;  INPUT: 
;	keyword:  
;		String array giving the name of the keyword for which a value 
;		is desired.  Keyword names may be abreviated as in IDL.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	set:	If set, the returned value is 0 unless the keyword exists and is
;		not '0'.
;
;	int:	If set, result is converted to int.
;
;	long:	If set, result is converted to long.
;
;	float:	If set, result is converted to float.
;
;	double:	If set, result is converted to double.
;
;
;  OUTPUT: NONE
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
function ominas_value, keyword, delim=delim, keywords=keys, $
          set=set, int=int, long=long, float=float, double=double

 if(NOT keyword_set(delim)) then delim = ['==', '=']

 argv = ominas_argv(/keyvals)
 if(NOT keyword_set(argv[0])) then vals = '' $ 
 else $
  begin
   for i=0, n_elements(delim)-1 do $
    begin
     val = bv_get(argv, keyword, delim[i], key=key)
     vals = append_array(vals, val)
     keys = append_array(keys, key)
    end
  end

 if(keyword_set(set)) then $
  begin
   if(NOT keyword_set(vals)) then return, 0
   if(n_elements(vals) GT 1) then return, 1
   if(vals[0] EQ '0') then return, 0
   return, 1
  end

 if(keyword_set(int)) then return, fix(vals)
 if(keyword_set(long)) then return, long(vals)
 if(keyword_set(float)) then return, float(vals)
 if(keyword_set(double)) then return, double(vals)

 return, vals
end
;===============================================================================
