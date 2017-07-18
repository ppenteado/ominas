;=============================================================================
;+
; NAME:
;	cor_class_info
;
;
; PURPOSE:
;	Returns information about OMINAS object classes.
;
;
; CATEGORY:
;	NV/OBJ/COR
;
;
; CALLING SEQUENCE:
;	cor_class_info, classes=classes, abbrev=abbrev, tags=tags
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	classes:	String array giving the names of all OMINAS classes. 
;
;	abbrev:		String array giving the abbreviations of OMINAS classes. 
;
;	tags:		String array giving the tag names of OMINAS classes. 
;
;
;
; RETURN: NONE
;
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro cor_class_info, classes=classes, abbrev=abbrev, tags=tags
common cor_class_info_block, _classes, _abbrev, _tags


 ;-------------------------------------------------------------
 ; determine OMINAS classes
 ;-------------------------------------------------------------
 if(NOT keyword_set(_classes)) then $
  begin
   ;--------------------------------------------
   ; get object info
   ;--------------------------------------------
   help, /objects, output=s

   ;----------------------------------------------
   ; parse output to deterine ominas class names
   ;----------------------------------------------
   p = strpos(s, '**')
   w = where(p EQ 0)
   s = s[w]

   p = strpos(s, 'OMINAS_')
   w = where(p NE -1)
   if(w[0] EQ -1) then return
   s = s[w]

   s = str_nnsplit(s, '_', rem=rem)
   _classes = strtrim(str_nnsplit(rem, ','), 2)
   nclasses = n_elements(_classes)

   ;-------------------------------------------------------------
   ; determine OMINAS abbreviations and tags
   ;-------------------------------------------------------------
   _abbrev = strarr(nclasses)
   _tags = strarr(nclasses)
   for i=0, nclasses-1 do $
    begin
     stat = execute('xd=ominas_' + strlowcase(_classes[i]) + '()')
     _abbrev[i] = cor_abbrev(xd)
     _tags[i] = cor_tag(xd)
    end
  end 


 classes = _classes
 abbrev = _abbrev
 tags = _tags


end
;===========================================================================
