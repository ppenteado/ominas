;=============================================================================
;+
; NAME:
;	core_descriptor__define
;
;
; PURPOSE:
;	Class structure for the CORE class.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	sn:	Unique serial number of descriptor.  Managed in NV/SYS.
;
;
;	idp:	Unique ID pointer for descriptor.  Managed in NV/SYS.
;
;
;	name:	Name of the object.
;
;		Methods: cor_name, cor_set_name
;
;
;	user:	Username.
;
;		Methods: cor_user
;
;
;	tasks_p:	Pointer to tasks list.
;
;			Methods: cor_tasks, cor_add_task
;
;
;	udata_tlp:	Tag list containing user data.
;
;			Methods: cor_set_udata, cor_test_udata, cor_udata
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
pro core_descriptor__define

 struct = $
    { core_descriptor, $
	class:		 '', $			; Name of descriptor class
        sn:              0l, $                  ; Descriptor serial number
	tasks_p:	 nv_ptr_new(), $	; pointer to task list 
	idp:		 nv_ptr_new(), $	; ID pointer.
	name:		 '', $			; Name of object
	udata_tlp:	 nv_ptr_new(), $	; pointer to user data
	abbrev:		 '', $			; Abbreviation of descriptor class
	user:		 '' $			; name of user
    }

end
;===========================================================================



