;=============================================================================
;+
; NAME:
;       fill_array
;
;
; PURPOSE:
;       Like the idl function make_array, but more flexible.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = fill_array(n_elem, values=values, default=default)
;
;
; ARGUMENTS:
;  INPUT:
;       n_elem:     Number of elements in resultant array.
;
;  OUTPUT:
;       NONE
;
;  KEYWORDS:
;  INPUT:
;           values:     Values to fill array.
;
;          default:     Default value for array.
;
;           string:     If set, array is a string array.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array (n_elem) filled with values and/or default value.
;
;
; PROCEDURE:
;       An array of n_elem is created.  If values is not given, array is
;       filled with default value.  If values is given and the number of
;       values is less than n_elem, then the rest of array is filled
;       with the default value.  If the default value is not given, the
;       default is taken as the last element in the values array.
;
;
; SEE ALSO:
;	make_array
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
function fill_array, n_elem, values=values, default=default, string=string

 if(NOT keyword__set(values)) then $
  begin
   if(keyword__set(string)) then values='' $
   else values=0
  end

 nval=n_elements(values)

 if(n_elements(default) EQ 0) then default=values[nval-1]
 if(NOT keyword__set(values)) then values=default


 array=make_array( (n_elem>nval), value=default)
 array[0:nval-1]=values


 return, array
end
;=============================================================================
