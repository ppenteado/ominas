;===========================================================================
; grim_user_mode_struct__define
;
;
;===========================================================================
pro grim_user_mode_struct__define

 struct = $
    { grim_user_mode_struct, $
	name:		'', $		; Name of this cursor mode
	event_pro:	'', $		; Event procedure
	bitmap:		'', $		; Bitmap function
	menu:		'', $		; Name for Mode menu entry
	data_p:		nv_ptr_new() $	; Pointer to data
    }

end
;===========================================================================



