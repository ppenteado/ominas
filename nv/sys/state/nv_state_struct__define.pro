;=============================================================================
;+
; NAME:
;	nv_state_struct__define
;
;
; PURPOSE:
;	Structure defining the NV state.
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
;	ndd:	Maximum number of data descriptors with maintain == 1 to 
;		keep in memory at any given time.
;
;	dds_p:	List of data descriptors kept in memory as a result of
;		maintain == 1.
;
;	translators_filenames_p:	Pointer to names of translators 
;					tables.
;
;	tr_table_p:	Pointer to loaded translators table.
;
;	transforms_filenames_p:	Pointer to names of transforms tables.
;
;	trf_table_p:	Pointer to loaded transforms table.
;
;	io_filenames_p:	Pointer to names of I/O tables.
;
;	io_table_p:	Pointer to loaded I/O table.
;
;	ftp_detectors_filenames_p:	Pointer to names of file types tables.
;
;	ftp_table_p:	Pointer to loaded s table.
;
;	ins_detectors_filenames_p:	Pointer to names of instruments 
;					tables.
;
;	ins_table_p:	Pointer to loaded instruments table.
;
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
pro nv_state_struct__define

; NOTE: nv_ptr_new not used here to avoid infinite recursion

 struct = $
    { nv_state_struct, $
	ndd:				0, $		; max # maintain=1 dds to
							;  keep in memory
							;  0 = no limit
	dds_p:				ptr_new(), $	; loaded maintain=1 dds

	translators_filenames_p:	ptr_new(), $	; translators filename
	tr_table_p:			ptr_new(), $	; Pointer to translators table
	transforms_filenames_p:		ptr_new(), $	; transforms filename
	trf_table_p:			ptr_new(), $	; Pointer to transforms table
	io_filenames_p:			ptr_new(), $	; I/O filename
	io_table_p:			ptr_new(), $	; Pointer to I/O table
	ftp_detectors_filenames_p:	ptr_new(), $	; File type detectors filename
	ftp_table_p:			ptr_new(), $	; Pointer to file types table
	ins_detectors_filenames_p:	ptr_new(), $	; Instrument detectors filename
	ins_table_p:			ptr_new(), $	; Pointer to instruments table

	;------debugging------
	ptr_list_p:			ptr_new(), $	; List of pointers
	ptr_tracking:			0b $		; Track mallocs?
    }


end
;===========================================================================
