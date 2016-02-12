;===========================================================================
; pg_scan_data_struct__define
;
; This structure is intended to contain all of the fields of 
; pg_points_struct as well as some more specific fields.  Programs
; which operate on pg_points_struct should also be able to operate on this
; structure.
;
;===========================================================================
pro pg_scan_data_struct__define

 struct={pg_points_struct, $
		data_p:		ptr_new(), $
		flags_p:	ptr_new(), $
		points_p:	ptr_new(), $
		vectors_p:	ptr_new(), $
		cc_p:		ptr_new() $
	}


end
;===========================================================================



