function obj_hasmethod,obj,name
  print,'obj_hasmethod'
  help,obj,name
  return,1
end


function objarrw,arg1
return,objarrwrapper(arg1)
end


