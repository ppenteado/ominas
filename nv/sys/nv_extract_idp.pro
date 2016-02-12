;=============================================================================
;+
; NAME:
;	nv_extract_idp
;
;
; PURPOSE:
;	Extracts the id pointer for event handling from the given structures.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	result = nv_extract_idp(s)
;
;
; ARGUMENTS:
;  INPUT:
;	s:	Array of structures.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	NONE
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	Array of extracted id pointers; 0 if not found.
;
;
; PROCEDURE:
;	If the third field of the given descriptor is a pointer, then it is 
;	assumed to be the id pointer.  Otherwise, the first field is assumed
;	to be a descriptor pointer and that one is checked for a pointer
;	in the third position.  The process is repeated until an id pointer
;	is found or no sub-descriptor is found.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2003
;	
;-
;=============================================================================
function nv_extract_idp, _s
@nv.include

 if(NOT keyword_set(_s)) then return, 0

 type = size(_s, /type)
 if(type EQ 10) then s = nv_dereference(_s) $
 else s = _s

 n = n_elements(s)

 while(1) do $
  begin
   ;-------------------------------------------------------
   ; if third field is a pointer, then return it
   ;-------------------------------------------------------
;   tags = tag_names(s)
;   w = where(tags EQ 'IDP')
;   if(w[0] NE -1) then return, s.(w[0])

   if(n_tags(s) GE 3) then $
      if(size(s[0].(2), /type) EQ 10) then return, s.(2)

   ;-------------------------------------------------------------
   ; Otherwise, if first field is not a pointer, return 0
   ;-------------------------------------------------------------
   if(size(s[0].(0), /type) NE 10) then return, 0

   ;-------------------------------------------------------
   ; Otherwise, repeat using first field as descriptor
   ;-------------------------------------------------------
   s = nv_dereference(s.(0))
  end


 return, 0
end
;=============================================================================

