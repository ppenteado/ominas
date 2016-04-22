;=============================================================================
;+
; NAME:
;	nv_notify_list_struct__define
;
;
; PURPOSE:
;	Structure defining an entry in the NV event registry.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	idp:		ID pointer identifying the descriptor affected by 
;			this event.
;
;	xd:		Descriptor affected by this event.
;
;	handler:	Name of event handler procedure, which should accept
;			an array of events as its only argument.
;
;	data_p:		Pointer to associated user data.
;
;	data:		Scalar user data.
;
;	desc:		String giving a description of the event.
;
;	type:		Event type: 0 = set value, 1 = get_value.
;
;	compress:	If 1, compress events.
;
;	dynamic:	1 if a pointer was allocated for the descriptor
;			in this entry.
;
;
;
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
;=============================================================================
pro nv_notify_list_struct__define

 struct = $
    { nv_notify_list_struct, $
	idp :		nv_ptr_new(), $	; id pointer.
	xd:		nv_ptr_new(), $	; Pointer to top of object tree.
	handler :	'', $		; Event handler routine.
	compress :	0b, $		; If 1, compress events.
	data_p:		nv_ptr_new(), $	; Pointer to user data.
	data:		0d, $		; Scalar user data.
	dynamic:	0b, $		; 1 if pointer allocated for this item.
	type :		0 $		; Type of event:
					;  0 - set value
					;  1 - get value
    }

end
;===========================================================================



