;===========================================================================
; gff_struct__define
;
;
;===========================================================================
pro gff_struct__define

 struct = $
    { gff_struct, $
	filename:	'', $
	unit:		0l, $
	offset:		0l, $
	dim_p:		nv_ptr_new(), $


        idp :           nv_ptr_new(), $    ; id pointer.
        xd:             obj_new(), $    ; Affected descriptor.
        handler:        '', $           ; Event handler procedure.
        data_p :        nv_ptr_new(), $    ; Pointer to associated user data.
        data:           0d, $           ; Scalar user data.
        type :          0 $             ; Type of event:
                                        ;  0 - set value
                                        ;  1 - get value
    }


end
;===========================================================================
