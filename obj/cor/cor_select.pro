;=============================================================================
;+
; NAME:
;	cor_select
;
;
; PURPOSE:
;	Selects descriptors based on given criteria.
;
;
; CATEGORY:
;	NV/SYS/COR
;
;
; CALLING SEQUENCE:
;	xd = cor_select(crx, key)
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Array of descriptors of any subclass of CORE.
;
;	key:	 Array of keys to select.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	name:	Match by descriptor name.  This is the default.
;
;	class:	Match by descriptor class.
;
;	exclude_name:
;		List of names to exclude from result.
;
;	exclude_class:
;		List of classes to exclude from result.
;
;	rm:	If set, the selected descriptors are removed from the 
;	        input array.
;
;
;  OUTPUT: 
;	indices:
;		Indices of matched results in crx.
;
;
; RETURN:
;	All descriptors in crx whose parameters match the given key.  
;	0 if no matches found.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Rewritten by:	Spitale, 4/2016
;	
;-
;=============================================================================
function cor_select, crx, key, indices=ii, rm=rm, noevent=noevent, $
           name=name, class=class, exclude_name=exclude_name, exclude_class=exclude_class
 nv_notify, crx, type = 1, noevent=noevent

 if(NOT keyword_set(crx)) then return, 0

 ;-----------------------------------
 ; find matches
 ;-----------------------------------
 if(keyword_set(class)) then ii = where(cor_isa(crx, key)) $
 else ii = nwhere(cor_name(crx), key)
 if(ii[0] EQ -1) then return, 0
 result = crx[ii]

 ;-----------------------------------
 ; exclusions
 ;-----------------------------------
 if(keyword_set(exclude_name)) then $
  begin
   w = nwhere(cor_name(result), exclude_name)
   if(w[0] NE -1) then $
    begin
     ww = complement(result, w)
     result = result[ww]
     ii = ii[ww]
    end
  end
 if(keyword_set(exclude_class)) then $
  begin
   w = nwhere(cor_class(result), exclude_class)
   if(w[0] NE -1) then $
    begin
     ww = complement(result, w)
     result = result[ww]
     ii = ii[ww]
    end
  end

 ;----------------------------------------
 ; remove matches from list if desired
 ;----------------------------------------
 if(keyword_set(rm)) then crx = rm_list_item(crx, ii, only=0)


 return, result
end
;===============================================================================
