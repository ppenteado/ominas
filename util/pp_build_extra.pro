function pp_build_extra,keys,vals
compile_opt idl2,logical_predicate
ret=hash()
foreach key,keys,ik do ret[key]=*(vals[ik])
return,ret.tostruct()
end
