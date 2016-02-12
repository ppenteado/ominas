;==============================================================================
;+
; NAME:
;	nv_clone_descriptor
;
;
; PURPOSE:
;       Allocates a new data descriptor as a copy of the given
;       (existing) data descriptors.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	new_dd = nv_clone_descriptor(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	 Existing data descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;       Newly created data descriptors with all fields identical to
;       the input data descriptor.
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
function nv_clone_descriptor, ddp
nv_message, /con, name='nv_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv.include
 nv_notify, ddp, type=1, desc='ALL'
 dd = nv_dereference(ddp)

 new_dd = dd
 new_dd.idp = nv_ptr_new(0)

 if(ptr_valid(dd.data_dap)) then $
                            new_dd.data_dap = data_archive_clone(dd.data_dap)
 if(ptr_valid(dd.header_dap)) then $
                          new_dd.header_dap = data_archive_clone(dd.header_dap)

 if(ptr_valid(dd.dim_p)) then $
               new_dd.dim_p = nv_ptr_new(*dd.dim_p)
 if(ptr_valid(dd.compress_data_p)) then $
               new_dd.compress_data_p = nv_ptr_new(*dd.compress_data_p)
 if(ptr_valid(dd.input_translators_p)) then $
               new_dd.input_translators_p = nv_ptr_new(*dd.input_translators_p)
 if(ptr_valid(dd.output_translators_p)) then $
               new_dd.output_translators_p = nv_ptr_new(*dd.output_translators_p)
 if(ptr_valid(dd.input_translators_p)) then $
               new_dd.input_translators_p = nv_ptr_new(*dd.input_translators_p)
 if(ptr_valid(dd.output_translators_p)) then $
               new_dd.output_translators_p = nv_ptr_new(*dd.output_translators_p)
 if(ptr_valid(dd.input_keyvals_p)) then $
               new_dd.input_keyvals_p = nv_ptr_new(*dd.input_keyvals_p)
 if(ptr_valid(dd.output_keyvals_p)) then $
               new_dd.output_keyvals_p = nv_ptr_new(*dd.output_keyvals_p)
 if(ptr_valid(dd.transient_keyvals_p)) then $
               new_dd.transient_keyvals_p = nv_ptr_new(*dd.transient_keyvals_p)
 if(ptr_valid(dd.udata_tlp)) then new_dd.udata_tlp = $
                                                ptr_copy_recurse(dd.udata_tlp)

 new_dd.sn = nv_get_sn(1)
 new_dd.sibling_dd_h = handle_create()

 new_ddp = nv_ptr_new(new_dd)

 return, new_ddp
end
;===========================================================================
