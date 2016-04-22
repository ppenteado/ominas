;=============================================================================
;+
; NAME:
;	nv_notify_unregister
;
;
; PURPOSE:
;	Unregister a descriptor event handler.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_notify_unregister, xd, handler
;
;
; ARGUMENTS:
;  INPUT:
;	xd:		Descriptors for which to discontinue notification.
;
;	handler:	If given, names of event handler functions to remove
;			for each given descriptor.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	all:		If set, all handlers are unregistered.	
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	NONE
;
;
; COMMON BLOCKS:
;	nv_notify_block
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_notify_register
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2002
;	
;-
;=============================================================================
pro nv_notify_unregister, xd, handler, all=all
@nv_notify_block.common
@nv.include

 if(NOT keyword_set(list)) then return
 nlist = n_elements(list)
 nsn = n_elements(xd)
 
 ;------------------------------------------------------------------
 ; first flush event buffer to ensure that the outgoing handler 
 ; receives events that occurred before it was unregistered
 ;------------------------------------------------------------------
 nv_flush


 if(keyword_set(all)) then list = 0

 if(n_elements(handler) EQ 1) then handler = make_array(nsn, val=handler)

 ;--------------------------------------------------------------------
 ; select descriptors to remove
 ;--------------------------------------------------------------------
 idp = cor_idp(xd)

 ii = [0l]
 for i=0, nsn-1 do $
  begin
   if(NOT keyword_set(handler)) then w = where(list.idp EQ idp[i]) $
   else w = where((list.idp EQ idp[i]) AND (list.handler EQ handler[i]))
   if(w[0] NE -1) then ii = [ii, w]
  end
 if(n_elements(ii) EQ 1) then return

 ii = ii[1:*]


 ;---------------------------------
 ; free any allocated pointers
 ;---------------------------------
 nii = n_elements(ii)
 for i=0, nii-1 do if(list[ii[i]].dynamic) then nv_ptr_free, list[ii[i]].xd
; for i=0, nii-1 do if(list[i].dynamic) then nv_ptr_free, list[i].xd


 ;-------------------------------------------------------------------------
 ; remove selected elements
 ;-------------------------------------------------------------------------
 list = rm_list_item(list, ii, only=0)
 if(size(list, /type) NE 8) then list = 0

end
;=============================================================================
