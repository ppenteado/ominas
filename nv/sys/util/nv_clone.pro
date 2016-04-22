;==============================================================================
;+
; NAME:
;	nv_clone
;
;
; PURPOSE:
;       Allocates a new object as a copy of the given (existing) 
;	object.  All pointers in the new object are newly allocated.  
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	new_xd = nv_clone(xd)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	 Object to clone.  May be any pointer or structure.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;       Newly created object with all fields identical to
;       the input object, and new pointers.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;==============================================================================



;=============================================================================
; nv_clone_recurse
;
;=============================================================================
pro nv_clone_recurse, xd

 type = size(xd, /type)
 n = n_elements(xd)

 ;----------------------------------------------
 ; pointer 
 ;----------------------------------------------
 if(type EQ 10) then $
  begin
   for i=0, n-1 do if(ptr_valid(xd[i])) then $
    begin
     xd[i] = nv_ptr_new(*xd[i]) 
     nv_clone_recurse, *xd[i]
    end
  end $
 ;----------------------------------------------
 ; structure 
 ;----------------------------------------------
 else if(type EQ 8) then $
  begin
   for i=0, n-1 do $
    begin
;;     if(nv_get_directive(xd[i]) EQ 'NV_STOP') then return

     ntags = n_tags(xd[i])
     for j=0, ntags-1 do $
      begin
       val = xd[i].(j)
       nv_clone_recurse, val
       xd[i].(j) = val
      end
    end
  end

end
;=============================================================================



;=============================================================================
; nv_clone
;
;=============================================================================
function nv_clone, _xd, noevent=noevent
@nv_lib.include
 nv_notify, _xd, type = 1, noevent=noevent

 xd = _xd
 nv_clone_recurse, xd
 return, xd
end
;=============================================================================
