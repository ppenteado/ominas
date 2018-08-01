;=============================================================================
; __dat_transform_input
;
;=============================================================================
function ___dat_transform_input, _dd, data, header

 if(NOT keyword_set(*_dd.input_transforms_p)) then return, data

 transforms = *_dd.input_transforms_p
 n = n_elements(transforms)

 for i=0, n-1 do data = call_function(transforms[i], data, header)

 return, data
end
;=============================================================================



;=============================================================================
; dat_transform_input
;
;=============================================================================
pro dat_transform_input, dd

 _dd = cor_dereference(dd)

 if(NOT keyword_set(*_dd.input_transforms_p)) then return

 transforms = *_dd.input_transforms_p
 for i=0, n_elements(transforms)-1 do call_procedure, transforms[i], dd

end
;=============================================================================
