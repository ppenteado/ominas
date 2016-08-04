;=============================================================================
; dat_transform_input
;
;=============================================================================
function dat_transform_input, _dd, data, header, silent=silent

 if(NOT ptr_valid(_dd.input_transforms_p)) then return, data

 transforms = *_dd.input_transforms_p
 n = n_elements(transforms)

 for i=0, n-1 do data = call_function(transforms[i], data, header, silent=silent)

 return, data
end
;=============================================================================
