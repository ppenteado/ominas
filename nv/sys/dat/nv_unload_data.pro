;=============================================================================
;+
; NAME:
;	nv_unload_data
;
;
; PURPOSE:
;	Unloads the dat descriptor data array and removes dd from the NV
;	state maintained list if present.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_unload_data, dd
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor to test.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	all:	If set, all maintained data descriptors are unloaded.
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
pro nv_unload_data, ddp, all=all
@nv_block.common
@nv.include

 if(keyword_set(all)) then ddp = *nv_state.dds_p
 if(NOT ptr_valid(ddp)) then return
 if(NOT keyword_set(*ddp[0])) then return

 nddp = n_elements(ddp)
 for i=0, nddp-1 do $
  begin
   dd = nv_dereference(ddp[i])

;print, 'unloading'
   data_archive_free, dd.data_dap

   dds =*nv_state.dds_p
   dds = rm_list_item(dds, 0, only=0)
   *nv_state.dds_p = dds
  end
end
;=============================================================================
