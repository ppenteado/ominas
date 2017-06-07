;=============================================================================
; dat_data_struct__define
;
;=============================================================================
pro dat_data_struct__define


 struct = $
    { dat_data_struct, $
	data_dap:		nv_ptr_new(), $	; Pointer to the data archive
	abscissa_dap:		nv_ptr_new(), $	; Pointer to the abscissa archive
	header_dap:		nv_ptr_new(), $	; Pointer to the generic header archive
        dap_index:		0, $		; data archive index
	dhp:			nv_ptr_new(), $	; Pointer to detached header.

	sample_p:		nv_ptr_new(), $	; Pointer to the array of loaded samples
	order_p:		nv_ptr_new() $	; Pointer to the sample load order array
    }


end
;===========================================================================

