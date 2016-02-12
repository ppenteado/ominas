;=============================================================================
;+
; NAME:
;	nv_ptr_free_recurse
;
;
; PURPOSE:
;	Frees the given pointer and all pointers pointed to by it.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	nv_ptr_free_recurse, p
;
;
; ARGUMENTS:
;  INPUT:
;	p:	Pointer to be freed.
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
; STATUS:
;	Not complete, currently just frees the given pointer.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale,  5/2002
;	
;-
;=============================================================================

;=============================================================================
; pfr_recurse
;=============================================================================
pro pfr_recurse, p

 type = size(p, /type)

 if(type EQ 10) then $
  begin
   n = n_elements(p)
   for i=0, n-1 do if(ptr_valid(p[i])) then pfr_recurse, *p[i]
   nv_ptr_free, p
  end

end
;=============================================================================



;=============================================================================
; nv_ptr_free_recurse
;
;=============================================================================
pro nv_ptr_free_recurse, p
 pfr_recurse, p
end
;=============================================================================
