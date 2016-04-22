;=============================================================================
;+
; NAME:
;	nv_event_struct__define
;
;
; PURPOSE:
;	Structure defining the NV data event.
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
;	xd:		Descriptor affected by  this event.
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
pro nv_event_struct__define

 struct = $
    { nv_event_struct, $
	idp :		nv_ptr_new(), $	; id pointer.
	xd:		nv_ptr_new(), $	; Affected descriptor.
	handler:	'', $		; Event handler procedure.
	data_p :	nv_ptr_new(), $	; Pointer to associated user data.
	data:		0d, $		; Scalar user data.
	desc :		'', $		; Event description
	type :		0 $		; Type of event:
					;  0 - set value
					;  1 - get value
    }


end
;===========================================================================



