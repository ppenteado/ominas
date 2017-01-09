;=============================================================================
;+
; NAME:
;	dh_get_value
;
;
; PURPOSE:
;	Gets the value of a specified keyword.
;
;
; CATEGORY:
;	UTIL/DH
;
;
; CALLING SEQUENCE:
;	result = dh_get_value(dh, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dh:		String giving the detached header.
;
;	keyword:	String giving the keyword whose value is to be obtained.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	n_match:	Maximum number of matches to return.  If not given,
;			all matches are returned.
;
;	all_match:	If set, match all occurrences.
;
;	all_object:	If set, match all object indices.  If not set, then 
;			match only object index 0.
;
;	all_history:	If set, match all history indices.  If not set, then
;			only the highest history index is matched.
;
;	object_index:	If given, then match only this object index.
;
;	history_index:	If given, then match only this history index.
;
;	prefix:		If set, then match any keyword that begins with the
;			given keyword string instead of requiring an exact
;			match.
;
;	section:	Name of detached header section from which to read the
;			data.  If not specified, the data is read from the
;			'updates' section.
;
;
;  OUTPUT:
;	count:		Integer giving the numebr of keywords matched.
;
;	match_keys:	String array giving the names of the keywords that were
;			matched.
;
;	match_objects:	Array giving the object index for each keyword returned
;			in match_keywords.
;
;	match_hist:	Array giving the history index for each keyword returned
;			in match_keywords.
;
;
; RETURN:
;	Array giving values for all matching keywords.  The type of array is
;	determined by the value found in the detached header.  Strings are
;	returned as strings, numeric values are converted to double.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dh_put_value, dh_rm_value
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1998
;	Added 'section' keyword: Spitale; 11/2001
;	
;-
;=============================================================================



;=============================================================================
; dhgv_convert_value
;
;=============================================================================
function dhgv_convert_value, val


 ;----------------------------------------------------------------
 ; if single quotes, then it's a string - just remove the quotes
 ;----------------------------------------------------------------
 if(strmid(val,0,1) EQ "'" AND $
    strmid(val,strlen(val)-1,1) EQ "'") then $
                                           return, strmid(val,1,strlen(val)-2) 


 ;----------------------------------------------------------------
 ; anything else is assumed numeric and converted to double
 ;----------------------------------------------------------------
; if(NOT keyword_set(val)) then return, 0d
 return, double(val)
end
;=============================================================================



;=============================================================================
; dh_get_value
;
;=============================================================================
function dh_get_value, _dh, keyword, n_match=n_match, $
                       all_match=all_match, $
                       all_object=all_object, all_history=all_history, $
                       match_keys=match_keys, count=count, $
                       match_objects=match_objects, $
                       match_histories=match_histories, $
                       object_index=object_index, history_index=history_index, $
                       prefix=prefix, section=section


 if(NOT keyword_set(section)) then section = 'updates'
 if(NOT keyword_set(n_match)) then n_match = -1
 if(n_elements(object_index) EQ 0) then object_index = 0
 if(n_elements(history_index) EQ 0) then history_index = -1
 prefix = keyword_set(prefix)
 all_object = keyword_set(all_object)
 all_history = keyword_set(all_history)
 all_match = keyword_set(all_match) OR $
                          all_object OR all_history OR NOT keyword__set(n_match)

 if(history_index LT 0) then all_history=1

 ;-----------------------------------------------------------------
 ; extract the relevant section of the detached header 
 ;-----------------------------------------------------------------
 dh = dhh_extract(_dh, section)

 ;-----------------------------------------------------
 ; identify candidate lines for further parsing
 ;-----------------------------------------------------
 clines = dhh_search(dh, keyword)
 nclines = n_elements(clines)

 ;--------------------------------
 ; parse candidate lines
 ;--------------------------------
 count = 0
 i = 0
 while(i LT nclines AND (count LT n_match OR all_match)) do $
  begin
   ;------------------------------------
   ; get raw keyword and value tokens
   ;------------------------------------
   dhh_parse_line, clines[i], rkw, val

   ;-------------------------
   ; get keyword and indices
   ;-------------------------
   dhh_parse_keyword, rkw, kw, elm_index, obj_index, hist_index

   ;---------------------------------------
   ; convert the value if this is a match
   ;---------------------------------------
   if( (prefix OR kw EQ keyword) AND $
       (obj_index EQ object_index OR all_object) AND $
       (hist_index EQ history_index OR all_history) ) then $
    begin
     value = dhgv_convert_value(val)

     if(n_elements(values) EQ 0) then $
      begin
       type=(size(value))[1]
       values = make_array(nclines, type=type)
       match_keys = strarr(nclines)
       match_objects = lonarr(nclines)
       match_histories = lonarr(nclines)
       match_elements = lonarr(nclines)
      end

     match_keys[count] = kw
     match_objects[count] = obj_index
     match_histories[count] = hist_index
     match_elements[count] = elm_index
     values[count] = value
     count=count+1
    end

   i=i+1
  end


 if(count EQ 0) then return, ''

 match_keys = match_keys[0:count-1]
 match_objects = match_objects[0:count-1]
 match_histories = match_histories[0:count-1]
 match_elements = match_elements[0:count-1]

 values=values[0:count-1]


 ;--------------------------------------------
 ; by default, select only latest history
 ;--------------------------------------------
 if(history_index LT 0) then $
  begin
   w=where(match_histories EQ max(match_histories))
   if(n_elements(w) NE n_elements(match_histories)) then $
    begin
     match_keys = match_keys[w]
     match_objects = match_objects[w]
     match_histories = match_histories[w]
     match_elements = match_elements[w]
     values=values[w]
    end
  end


 ;------------------------------
 ; sort values by element index
 ;------------------------------
 values=values[sort(match_elements)]

 ;-----------------------------------
 ; following three lines added by vrh
 ;-----------------------------------
 match_keys=match_keys[sort(match_elements)]
 match_objects=match_objects[sort(match_elements)]
 match_histories=match_histories[sort(match_elements)]

 return, values
end
;=============================================================================
