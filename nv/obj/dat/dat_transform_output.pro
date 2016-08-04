;=============================================================================
; dat_transform_output
;
;=============================================================================
function dat_transform_output, _dd, data, header, silent=silent

 if(NOT ptr_valid(_dd.output_transforms_p)) then return, data

 transforms = *_dd.output_transforms_p
 n = n_elements(transforms)

 for i=0, n-1 do data = call_function(transforms[i], data, header, silent=silent)

 return, data
end
;=============================================================================
