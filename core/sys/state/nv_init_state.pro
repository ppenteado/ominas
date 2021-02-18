;=============================================================================
;+
; NAME:
;	nv_init_state
;
;
; PURPOSE:
;	Initializes the NV state structure.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	state = nv_init_state()
;;;;	nv_init_state
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
;;;; RETURN: NONE
; RETURN: 
;	New nv_state structure.
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
pro nv_init_state
common nv_block, nv_state
 if(keyword_set(nv_state)) then return

 ;-------------------------------------------------------------------
 ; check for proper startup environment
 ;-------------------------------------------------------------------
 if(NOT keyword_set(getenv('OMINAS_DIR'))) then $
;   stop, 'OMINAS not configured; did you start IDL using the "ominas" command?'
  begin
   print, 'OMINAS not configured; did you start IDL using the "ominas" command?'
   ;This point is only reached if one tried to use OMINAS routines while the
   ;environment does not have a OMINAS_DIR variable set, which would prevent
   ;proper execution of most OMINAS code. So, we must exit
   if (fstat(-1)).isagui then stop else exit,status=1
  end


 ;-------------------------------------------------------------------
 ; initialize state structure
 ;-------------------------------------------------------------------
 nv_state = {nv_state_struct}
 

; NOTE: nv_ptr_new not used here to avoid infinite recursion

 nv_state.translators_filenames_p = ptr_new('')
 nv_state.trs_table_p = ptr_new(0)
 nv_state.transforms_filenames_p = ptr_new('')
 nv_state.trf_table_p = ptr_new(0)
 nv_state.io_filenames_p = ptr_new('')
 nv_state.io_table_p = ptr_new(0)
 nv_state.ftp_detectors_p = ptr_new('')
 nv_state.ins_detectors_p = ptr_new('')

 nv_state.modules_p = ptr_new(0)

 nv_state.dds_p = ptr_new(0)

 nv_state.ptr_list_p = ptr_new(0)

 setup_dir = getenv('OMINAS_SETUP_DIR')
 if(NOT keyword_set(setup_dir)) then setup_dir = '$HOME/.ominas/'
 nv_state.setup_dir = setup_dir


 ;-------------------------------------------------------------------
 ; initialize module API
 ;-------------------------------------------------------------------
 nv_module_api_init, new=new
 nv_state.new=new

end
;===========================================================================
