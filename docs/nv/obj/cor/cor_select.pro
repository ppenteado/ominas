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
;	key:	 Array of key to select.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	name:	Match by descriptor name.
;
;	class:	Match by descriptor class.
;
;	rm:	If set, the selected descriptors are removed from the 
;	        input array.
;
;
;  OUTPUT: NONE
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
           name=name, class=class
 nv_notify, crx, type = 1, noevent=noevent

 if(NOT keyword_set(crx)) then return, 0

 ;-----------------------------------
 ; find matches
 ;-----------------------------------
 if(keyword_set(class)) then ii = where(cor_isa(crx, key)) $
 else ii = nwhere(cor_name(crx), key)
 if(ii[0] EQ -1) then return, 0
 result = crx[ii]


 ;----------------------------------------
 ; remove matches from list if desired
 ;----------------------------------------
 if(keyword_set(rm)) then crx = rm_list_item(crx, ii, only=0)


 return, result
end
;===============================================================================
