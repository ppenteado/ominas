;==============================================================================
;+
; NAME:
;	nv_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source data descriptor into the
;       destination data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_copy_descriptor, dd_dst, dd_src
;
;
; ARGUMENTS:
;  INPUT:
;	dd_dst:	        Data descriptor to copy to.
;
;	dd_src:	        Data descriptor to copy from.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	silent:	If set, messages are suppressed.
;
;	update:	Data update mode to use instead of the current
;		setting in dd_src: (shouldn't this be dd_dst?)
;		 -1: Locked;	Nothing copied.
;		  0: Normal:	Copy src to dst.
;		  1: Clone:	Clone a new decriptor leaving dd_dst
;				unchanged.  The value of the dd_dst 
;				argument is modifed to point o the 
;				cloned descriptor.
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
;==============================================================================
pro nv_copy_descriptor, ddp_dst, ddp_src, silent=silent, update=update
@nv.include
 nv_notify, ddp_src, typ=1, desc='ALL'
 dd = nv_dereference(ddp_src)

; shouldn't this be checking update on the destination descriptor?
 if(NOT defined(update)) then update = dd.update
 if(update EQ -1) then return

 if((NOT keyword_set(silent)) and (dd.maintain GT 0)) then $
  nv_message, /con, name='nv_copy_descriptor', $
   'WARNING: Changes to data descriptor may be lost due to the maintainance level.'


 new_dd = dd


 ;--------------------------------------------
 ; copy descriptor normally if update = 0
 ;--------------------------------------------
 if(NOT keyword_set(update)) then $
  begin
   new_dd.idp = nv_extract_idp(ddp_dst)
 

;   nv_ptr_free, new_dd.dim_p
   if(ptr_valid(dd.dim_p)) then $
               new_dd.dim_p = nv_ptr_new(*dd.dim_p)

;   nv_ptr_free, new_dd.compress_data_p
   if(ptr_valid(dd.compress_data_p)) then $
               new_dd.compress_data_p = nv_ptr_new(*dd.compress_data_p)

;   nv_ptr_free, new_dd.input_transforms_p
   if(ptr_valid(dd.input_transforms_p)) then $
               new_dd.input_transforms_p = nv_ptr_new(*dd.input_transforms_p)

;   nv_ptr_free, new_dd.output_transforms_p
   if(ptr_valid(dd.output_transforms_p)) then $
               new_dd.output_transforms_p = nv_ptr_new(*dd.output_transforms_p)

;   nv_ptr_free, new_dd.input_translators_p
   if(ptr_valid(dd.input_translators_p)) then $
               new_dd.input_translators_p = nv_ptr_new(*dd.input_translators_p)

;   nv_ptr_free, new_dd.output_translators_p
   if(ptr_valid(dd.output_translators_p)) then $
               new_dd.output_translators_p = nv_ptr_new(*dd.output_translators_p)

;   nv_ptr_free, new_dd.input_keyvals_p
   if(ptr_valid(dd.input_keyvals_p)) then $
               new_dd.input_keyvals_p = nv_ptr_new(*dd.input_keyvals_p)

;   nv_ptr_free, new_dd.output_keyvals_p
   if(ptr_valid(dd.output_keyvals_p)) then $
               new_dd.output_keyvals_p = nv_ptr_new(*dd.output_keyvals_p)

;   nv_ptr_free, new_dd.transient_keyvals_p
   if(ptr_valid(dd.transient_keyvals_p)) then $
               new_dd.transient_keyvals_p = nv_ptr_new(*dd.transient_keyvals_p)

   if(ptr_valid(dd.udata_tlp)) then new_dd.udata_tlp = $
                                              ptr_copy_recurse(dd.udata_tlp)
   if(ptr_valid(dd.header_dap)) then $
                          new_dd.header_dap = data_archive_clone(dd.header_dap)


   if(ptr_valid(dd.data_dap)) then $
                            new_dd.data_dap = data_archive_clone(dd.data_dap)

   nv_rereference, ddp_dst, new_dd
  end


 ;-----------------------------------------------------------------------------
 ; if update = 1, spawn a new descriptor; output the new pointer
 ;-----------------------------------------------------------------------------
 ddp_old = ddp_dst
 if(update EQ 1) then $
  begin
   ddp_new = nv_clone(ddp_src)
   nv_set_sibling, ddp_dst, ddp_new
   ddp_dst = ddp_new
  end


 ;---------------------------------------------------------
 ; generate write event on original destination descriptor
 ;---------------------------------------------------------
 nv_notify, ddp_old, type=0, desc='ALL'
 nv_notify, /flush


end
;===========================================================================
