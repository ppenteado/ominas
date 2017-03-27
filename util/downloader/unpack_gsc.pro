pro unpack_gsc
compile_opt idl2,logical_predicate
a=pp_command_line_args_parse()
path=a.arguments[0]
print,'GSC files unpacked'
end
