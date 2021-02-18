;=============================================================================
;+
; NAME:
;	nv_reset
;
;
; PURPOSE:
;	Resets the NV state.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	nv_reset
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
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
pro nv_reset
@nv_block.common
@core.include

 *nv_state.ftp_detectors = 0
 *nv_state.ins_detectors = 0
 *nv_state.translators_filenames_p = 0
 *nv_state.transforms_filenames_p = 0
 *nv_state.io_filenames_p = 0

 *nv_state.trs_table_p = 0
 *nv_state.trf_table_p = 0
 *nv_state.io_table_p = 0
  
 dat_unload_data, /all

end
;===========================================================================
