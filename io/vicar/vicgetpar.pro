;=============================================================================
;+
; NAME:
;	vicgetpar
;
;
; PURPOSE:
;	Reads the value of a VICAR label keyword.
;
;
; CATEGORY:
;	UTIL/VIC
;
;
; CALLING SEQUENCE:
;	value = vicgetpar(label, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	label:		String array giving the VICAR label.
;
;	keyword:	String giving the keyword whose value is to be obtained.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	string:		If set, the value will be returned as the exact string
;			read from the label instead of converting it based
;			quotes.
;
;  OUTPUT:
;	pos:		Position of keyword in label.
;
;	status:		If no errors occur, status will be zero, otherwise
;			it will be a string giving an error message.  If the
;			keyword is not found, status will contain a message.
;
;
; RETURN:
;	The data array read from the file.
;
;
; STATUS:
;	Complete
;
;
; RESTRICTIONS:
;	Will not work for keyword values in which strings contain commas as
;	it is used as the delimiter.
;	
;
; SEE ALSO:
;	vicsetpar
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/1996
;	Modified by:	Haemmerle, 10/2000  (add arrays)
;	
;-
;=============================================================================

;===========================================================================
; vgp_get_lab_pair
;
;===========================================================================
function vgp_get_lab_pair, label, pos

 string=strmid(label, pos, strlen(label)-pos-1)

 s=strtrim(str_sep(string, '='),2)

; if(n_elements(s) LT 2) then something


 if(strmid(s(1), 0, 1) NE "'") then s1=str_sep(s(1), ' ') $

 else s1="'" + str_sep(strmid(s(1), 1, strlen(s(1))-1), "'") + "'"


 keyword=strtrim(s(0),2)
 value=strtrim(s1(0),2)


 return, [keyword,value]
end
;===========================================================================



;===========================================================================
; vicgetpar
;
;===========================================================================
function vicgetpar, label, keyword, status=status, pos=pos, string=string

 status=0


;--------------check for keyword at beginning of label-------------

 keyword_s=keyword+'='

 if(strmid(label, 0, strlen(keyword)) EQ keyword) then pos=0 $


;-----------------check for keyword in rest of label---------------

 else $
  begin
   keyword_s=' '+keyword+'='

   pos=strpos(label, keyword_s)
   if(pos EQ -1) then $
    begin
     status='Unable to find keyword ' + keyword_s + ' in Vicar label.'
     return, 0
    end $
   else pos=pos+1
  end


;---------------extract the keyword/value pair---------------

 pair=vgp_get_lab_pair(label, pos)
 if(pair(0) NE keyword) then $
  begin
   status='Unable to find keyword ' + keyword_s + ' in Vicar label.'
   return, 0
  end

 value_s=pair(1)

 if(NOT keyword_set(string) AND strmid(value_s,0,1) EQ '(' AND $
    strmid(value_s,strlen(value_s)-1,1) EQ ')' ) then goto, array


;--------------convert value string to appropriate type-----------

 if(NOT keyword_set(string)) then $
  begin
	;-------single quote indicates a string value--------

   if(strmid(value_s, 0, 1) EQ "'") then $
                                value=strmid(value_s, 1, strlen(value_s)-2) $


	;-------------otherwise, its numeric-------------

   else $
    begin
     value=double(value_s)

     if(value EQ float(value)) then value=float(value)
     if(value EQ long(value)) then value=long(value)
     if(value EQ fix(value)) then value=fix(value)
    end

  end $
 else value=value_s

 return, value

array:

 value_s = strmid(value_s, 1, strlen(value_s)-2)
 string_array = strpos(value_s, "'")
 values = str_sep(value_s,',')
 n_values = n_elements(values)

 if(string_array ne -1) then $
  for i=0,n_values-1 do $
   begin
    values[i] = strmid(values[i], 1, strlen(values[i])-2) 
    doublequote = strpos(values[i],"''")
    if(doublequote NE -1) then values[i] = $
      strmid(values[i],0,doublequote) + $
              strmid(values[i],doublequote+2,strlen(values[i])-doublequote-2)
   end $
 else $
  begin
     values=double(values)
     if(total(values EQ float(values)) EQ n_values) then values=float(values)
     if(total(values EQ long(values)) EQ n_values) then values=long(values)
     if(total(values EQ fix(values)) EQ n_values) then values=fix(values)
  end

 return, values

end
;===========================================================================



