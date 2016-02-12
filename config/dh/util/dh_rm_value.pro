;=============================================================================
;+
; NAME:
;	dh_rm_value
;
;
; PURPOSE:
;	Deletes a specified keyword/value pair.
;
;
; CATEGORY:
;	UTIL/DH
;
;
; CALLING SEQUENCE:
;	dh_rm_value, dh, keyword
;
;
; ARGUMENTS:
;  INPUT:
;	dh:		String giving the detached header.
;
;	keyword:	String giving the keyword to be deleted.
;
;  OUTPUT: 
;	dh:		dh is modified on return.
;
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
;	all_history:	If set, match all history indices.  If not set, 
;			then only the highest history index is matched.
;
;	object_index:	If given, then match only this object index.
;
;	history_index:	If given, then match only this history index.
;
;	prefix:		If set, then match any keyword which begins with the
;			given keyword string instead of requiring an exact
;			match.
;
;  OUTPUT:
;	count:		Integer giving the numebr of keywords matched.
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dh_get_value, dh_put_value
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1998
;	
;-
;=============================================================================
pro dh_rm_value, dh, keyword, n_match=n_match, $
                       all_match=all_match, $
                       all_object=all_object, all_history=all_history, $
                       count=count, $
                       object_index=object_index, history_index=history_index, $
                       prefix=prefix


 if(NOT keyword__set(n_match)) then n_match = -1
 if(NOT keyword__set(object_index)) then object_index = 0
 if(NOT keyword__set(history_index)) then history_index = -1
 prefix = keyword__set(prefix)
 all_object = keyword__set(all_object)
 all_history = keyword__set(all_history)
 all_match = keyword__set(all_match) OR $
                         all_object OR all_history OR NOT keyword__set(n_match)

 if(history_index LT 0) then all_history=1


 ;-----------------------------------------------------
 ; identify candidate lines for further parsing
 ;-----------------------------------------------------
 clines = dhh_search(dh, keyword, lines=ln)
 nclines = n_elements(clines)

 ;--------------------------------
 ; parse candidate lines
 ;--------------------------------
 count = 0
 i = 0
 while(i LT nclines AND (count LT n_match OR all_match NE 0)) do $
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
   ; mark the line if this is a match
   ;---------------------------------------
   if( (prefix OR kw EQ keyword) AND $
       (obj_index EQ object_index OR all_object) AND $
       (hist_index EQ history_index OR all_history) ) then $
    begin
     if(n_elements(match_indices) EQ 0) then $
      begin
       match_histories = lonarr(nclines)
       match_indices = lonarr(nclines)
      end

     match_indices[count] = i
     match_histories[count] = hist_index

     count=count+1
    end

   i=i+1
  end


 if(count EQ 0) then return

 match_histories = match_histories[0:count-1]
 match_indices = match_indices[0:count-1]

 ;--------------------------------------------
 ; by default, select only latest history
 ;--------------------------------------------
 if(history_index LT 0) then $
  begin
   w=where(match_histories EQ max(match_histories))
   if(n_elements(w) NE n_elements(match_histories)) then $
                                              match_indices = match_indices[w]
  end

 ;------------------------------
 ; mark and remove lines
 ;------------------------------
 dh[ln[match_indices]] = '*'
 dh=dh[where(dh NE '*')]

end
;=============================================================================
