;===========================================================================
; source_descriptor__define
;
;
;===========================================================================
pro source_descriptor__define

 struct = $
    { source_descriptor, $
	bd:		 ptr_new(), $		; ptr to body descriptor
	class:		 '' $			; Name of descriptor class
	_:		 0b, $			; Place holder
	src_bd:		 ptr_new(), $		; ptr to source body descriptor
    }

end
;===========================================================================



