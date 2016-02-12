;=============================================================================
;+
; NAME:
;	vicsetpar
;
;
; PURPOSE:
;	Add, delete, or change a keyword/value pair in a VICAR label.
;
;
; CATEGORY:
;	UTIL/VIC
;
;
; CALLING SEQUENCE:
;	vicsetpar, label, keyword, value
;
;
; ARGUMENTS:
;  INPUT:
;	label:		String array giving the VICAR label.
;
;	keyword:	String giving the keyword whose value is to be set.
;			If the keyword is not found, it will be added.
;
;	value:		Value for the given keyword.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	delete:		If set, the keyword/value pair will be deleted from the
;			label, if found.
;
;	prepend:	If set, and if the keyword doesn't already exist, it
;			will be prepended instead of appended.
;
;	pad:		If set, spaces are added to the end of the keyword/value
;			pair to attain this length, not including the two
;			spaces before the following keyword.
;
;  OUTPUT:
;	pos:		Position at which the keyword was placed in the label.
;
;	status:		If no errors occur, status will be zero, otherwise
;			it will be a string giving an error message.
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
;	vicgetpar
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/1996
;	Spitale 2/2004:	Added /prepend
;	Spitale 6/2004:	Added pad keyword
;	
;-
;=============================================================================

;===========================================================================
; vicsetpar
;
;===========================================================================
pro vicsetpar, label, keyword, value, $
         status=status, pos=pos, delete=delete, prepend=prepend, pad=pad

 status=0


;-----------------build keyval string-----------------------

 if(keyword_set(delete)) then keyval='' $
 else $
  begin
   s=size(value)
   typecode=s(s(0)+1)

   if(typecode EQ 7) then value_s="'" + value + "'" $

   else if((typecode GT 0) AND (typecode LT 6)) then $
                                                   value_s=strtrim(value, 2) $

   else $
    begin
     status='Unsupported type.'
     return
    end


   keyval = keyword + "=" + value_s
   if(keyword__set(pad)) then keyval = str_pad(keyval, pad)
  end


;---------------check for keyword already in label-----------------

 current_value_s = vicgetpar(label, keyword, pos=pos, status=stat, /string)


;-----------if it is not found, then it will be added------------

 if(keyword_set(stat)) then $
  begin
   if(keyword_set(prepend)) then $
    begin
     pos = 0
     head = ''
     tail = label
    end $
   else $
    begin
     pos = strlen(label)
     if(pos NE 0) then head = label + ' ' else head = ''
     tail = ''
    end
  end $


;-------------otherwise it will replace the current value--------------

 else $
  begin
   len = strlen(keyword)+strlen(current_value_s)+2
   head = strmid(label, 0, pos)
   tail = strmid(label, pos+len, strlen(label)-pos-len)
  end



 label = strtrim(head,1) + keyval + '  ' + strtrim(tail,1)
end
;===========================================================================



