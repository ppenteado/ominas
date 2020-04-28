;=============================================================================
;+
; NAME:
;	dh_put_value
;
;
; PURPOSE:
;	Sets the value of a specified keyword.
;
;
; CATEGORY:
;	UTIL/DH
;
;
; CALLING SEQUENCE:
;	dh_put_value, dh, keyword, value, $
;                         object_index=object_index, comment=comment
;
;
; ARGUMENTS:
;  INPUT:
;	dh:		String array giving the detached header.  If undefined,
;			a minimal detached header is first created.
;
;	keyword:	String giving the keyword whose value is to be updated.
;
;	value:		Value to associate with this keyword.  
;
;  OUTPUT:
;	dh:		The dh argument is modified on return.
;
;
; KEYWORDS:
;  INPUT:
;	object_index:	Object index to use for this update.  Default is 0.
;
;	comment:	String giving optional comment.
;
;	section:	Section in which to place the data.  If not specified,
;			the data is placed in the 'updates' section.  If
;			the specified section does not exist, it is created.
;
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	See procedure below; 'utime' and 'history' keywords are modified.
;
;
; PROCEDURE:
;	The data is appended to the top of the specified section of the detached
;	header using the given object index and a history index that is one
;	greater than the current value found in the detached header for this
;	keyword.  The value of the 'utime' keyword corresponding to this history
;	index is modified to reflect the current time.  If this history index is
;	greater than that given by the 'history' keyword, then that value is
;	modified as well.  
;
;	If 'value' is an array, then each element is written on a different line
;	using the keyword with the same object index, history index, and
;	comment, but whose element indices reflect the order that the data
;	appear in the array.
;
;	If 'value' is of string type, then each entry is enclosed in quotes.
;
;
; EXAMPLE:
;	The following commands:
;
;		IDL> val=[7,6,5,4,3] 
;		IDL> dh_put_value, dh, 'test_key', val
;
;	produce the following detached header:
;
;	 history = -1 / Current history value
;	 <updates>
;	 utime = 2451022.404086 / Julian day of update - Mon Jul 27 9:41:53 1998
;	 test_key(0) = 7
;	 test_key(1) = 6
;	 test_key(2) = 5
;	 test_key(3) = 4
;	 test_key(4) = 3
;
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dh_get_value, dh_rm_value
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1998
;	Added 'section' keyword: Spitale; 11/2001
;	
;-
;=============================================================================



;=============================================================================
; dhpv_put
;
;=============================================================================
pro dhpv_put, dh, line, keyword, value, elem, obj, hist, $
                                   comment=comment, array=array, format=format

 if(keyword_set(keyword)) then $
  begin
   ;-----------------------------
   ; convert the value to string
   ;-----------------------------
   s = size(value)
   type = s[s[0]+1]
   if(type EQ 7) then val_s = "'" + value + "'" $
   else $
    begin
     if(NOT keyword_set(format)) then $ 
      case type of
	1 :	format = '(i15)'		; byte
	2 :	format = '(i15)'		; int
	3 :	format = '(i15)'		; long
	4 :	format = '(g25.15)'		; float
	5 :	format = '(g25.15)'		; double
      endcase 

     val_s = strtrim(string(value, format=format),2)
    end


   ;----------------------------
   ; determine index strings
   ;----------------------------
   elem_s = ''
   obj_s =  ''
   hist_s = ''
   if(keyword_set(array)) then elem_s = '(' + strtrim(elem,2) + ')'
   if(obj GT 0) then obj_s =  '[' + strtrim(obj,2)  + ']'
   if(hist GT 0) then hist_s = '{' + strtrim(hist,2) + '}'  

   ;----------------------------
   ; assemble the line
   ;----------------------------
   dh[line] = keyword + elem_s + obj_s + hist_s + ' = ' + val_s
  end

 if(keyword_set(dh[line])) then dh[line] = dh[line] + ' '
 if(keyword_set(comment)) then dh[line] = dh[line] + '/ ' + comment

end
;=============================================================================



;=============================================================================
; dh_put_value
;
;=============================================================================
pro dh_put_value, dh, keyword, value, object_index=object_index, $
                  comment=comment, section=section

 if(NOT keyword_set(section)) then section = 'updates'


 ;-----------------------------------------------------------------
 ; if dh is undefined, then create a new detached header 
 ;-----------------------------------------------------------------
 if(NOT keyword_set(dh)) then dh = dh_create()


 ;-----------------------------------------------------------------
 ; extract the relevant section of the detached header 
 ;-----------------------------------------------------------------
 dh_section = dhh_extract(dh, section, dh_history=dh_history)


 ;-----------------------------------------------------------------
 ; if the section does not exist, then create a new one 
 ;-----------------------------------------------------------------
 if(NOT keyword_set(dh_section)) then dh_section = dh_create_section(section)


 ;--------------------------------------------
 ; allocate new preheader 
 ;--------------------------------------------
 nval = n_elements(value)
 new_dh = strarr(nval)


 ;--------------------------------------------
 ; determine next history index 
 ;--------------------------------------------
 v = dh_get_value(dh_section, keyword, /all_hist, $
                  object_index=object_index, match_hist=match_hist, count=count)
 if(count EQ 0) then next_hist = 0 $
 else next_hist = max(match_hist) + 1


 ;--------------------------------------------
 ; fill in preheader 
 ;--------------------------------------------
 for i=0, nval-1 do $
       dhpv_put, new_dh, i, keyword, value[i], $
                i, object_index, next_hist, comment=comment, array=(nval GT 1)


 ;-------------------------------------------------------------------------
 ; update history and utime fields and append the rest of the header
 ;-------------------------------------------------------------------------
 xx = dhh_search(dh_history, 'history', line=hist_ln)
 if(hist_ln[0] NE -1) then $
      dhpv_put, dh_history, hist_ln, 'history', next_hist, 0, 0, 0, $
                                              comment='Current history value'

  dhh_insert, dh, [dh_section, new_dh], dh_history=dh_history

end
;=============================================================================
