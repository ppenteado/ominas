;===========================================================================
; dh_format_comment
;
;===========================================================================
function dh_format_comment, format, value
 name = strlowcase(format) + '_format_comment'
 return, call_function(name, value)
end
;===========================================================================
