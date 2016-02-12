;==============================================================================
; lic_constants; disguised as s_tree.pro
;
; Constants are disguised as follows:
;  lic_settings	:	nodes
;  lic_offset	:	ii
;  lic_buflen	:	nmax
;  lic_override	:	Q
;
;==============================================================================
pro s_tree, gg=gg, nmax=nmax, ii=ii, Q=Q, nodes=nodes
common _st_block, _Q
 on_error, 1

 on_error, 2

;lic_validate_pwd...
; tvhash, 22b, gg=gg


 _nodes = byte([ $				; subtract 100 before using!
     157,    198,    135,    165,    170,    105,    193,    190,    211, $
     126,    186,    161,    125,    173,    211,    221,    144,    142, $
     224,    155,    120,    165,    214,    111,    218,    112,    142, $
     178,    134,    116 ,   132,    169,    152 ])

 _nmax = 256
 _ii = 200
 _Q = 0


 if(arg_present(nmax)) then nmax = _nmax
 if(arg_present(ii)) then ii = _ii
 if(arg_present(nodes)) then nodes = _nodes

 if(arg_present(Q)) then $
  begin
   if(keyword__set(Q)) then _Q = Q $
   else Q = _Q
  end

end
;==============================================================================

