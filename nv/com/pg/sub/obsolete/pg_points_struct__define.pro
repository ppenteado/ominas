;=============================================================================
;+
; NAME:
;	pg_points_struct__define
;
;
; PURPOSE:
;	Structure for managing points in the PG command interface.
;
;
; CATEGORY:
;	NV/COM/PG/SUB
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	name:	Data set name.
;
;	desc:	Data set description.
;
;	idp:	ID pointer.  Uniquely identifies this data object.
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
pro pg_points_struct__define

 struct={pg_points_struct, $
		name:		'', $		; data set name
		desc:		'', $		; data set description
		idp:		nv_ptr_new(), $	; ID pointer
		points_p:	nv_ptr_new(), $	; image points
		udata_tlp:	nv_ptr_new(), $	; ptr to generic user data
		data_p:		nv_ptr_new(), $	; point-by-point user data
		tags_p:		nv_ptr_new(), $	; tags for p-b-p user data
		flags_p:	nv_ptr_new(), $	; flags
		input:		'', $		; description of input data
		vectors_p:	nv_ptr_new(), $	; inertial vectors
		npoints:	0l, $		; Number of points

		dst: 		{nv_directive_stop}, $	; Protect subsequent pointers
		assoc_idp:	nv_ptr_new() $	; idp of associated descriptor
	}

end
;===========================================================================



