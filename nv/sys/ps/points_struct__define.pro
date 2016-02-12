;=============================================================================
;+
; NAME:
;	points_struct__define
;
;
; PURPOSE:
;	Structure for managing points.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	name:		Data set name.
;
;	desc:		Data set description.
;
;	idp:		ID pointer.  Uniquely identifies this data object.
;
;	points_p:	Pointer to image points.
;
;	vectors_p:	Pointer to inertial vectors.
;
;	assoc_idp:	IDP of an associated descriptor, if applicable.
;
;	udata_tlp:	Pointer to a tag list containing generic user data.
;
;	data_p:		Pointer to a point-by-point user data array.
;
;	tags_p:		Tags for point-by-point user data.
;
;	flags_p:	Pointer to point-by-point flag array.
;
;	input:		Description of input data used to produce these
;			points.
;
;	nv:		Number of elements in the nv direction.
;
;	nt:		Number of elements in the nt direction.
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pg_points_struct__define
;	
;-
;=============================================================================
pro points_struct__define

 struct={points_struct, $
		name:		'', $		; data set name
		desc:		'', $		; data set description
		idp:		ptr_new(), $	; ID pointer
		points_p:	ptr_new(), $	; image points
		vectors_p:	ptr_new(), $	; inertial vectors
		flags_p:	ptr_new(), $	; flags
		data_p:		ptr_new(), $	; point-by-point user data
		tags_p:		ptr_new(), $	; tags for p-b-p user data
		udata_tlp:	ptr_new(), $	; ptr to generic user data
		input:		'', $		; description of input data
		nv:		0l, $
		nt:		0l, $

		dst: 		{nv_directive_stop}, $	; Protect subsequent pointers
		assoc_idp:	ptr_new() $	; idp of associated descriptor
	}

end
;===========================================================================



