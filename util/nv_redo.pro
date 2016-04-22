;=============================================================================
; nv_redo
;
;=============================================================================
pro nv_redo, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)

 nhist = n_elements(*dd.data_dap)
 ii = dd.dap_index
 if(ii EQ 0) then return

 dd.dap_index = dd.dap_index - 1

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
