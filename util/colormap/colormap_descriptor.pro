;=============================================================================
; colormap_descriptor
;
;
;=============================================================================
function colormap_descriptor, cmd0=cmd0, $
                      gamma=gamma, shade=shade, $
                      top=top, bottom=bottom, n_colors=n_colors, data=data

 if(keyword_set(cmd0)) then $
  begin
   shade = struct_get(cmd0, 'shade')
   gamma = struct_get(cmd0, 'gamma')
   n_colors = struct_get(cmd0, 'n_colors')
   top = struct_get(cmd0, 'top')
   bottom = struct_get(cmd0, 'bottom')
  end

 cmd = {colormap_descriptor}

 cmd.shade = 1.0
 cmd.gamma = 1.0
 cmd.n_colors = 255
 cmd.top = 255
 cmd.bottom = 0

 if(keyword_set(shade)) then cmd.shade = shade
 if(keyword_set(gamma)) then cmd.gamma = gamma
 if(keyword_set(n_colors)) then cmd.n_colors = n_colors
 if(keyword_set(top)) then cmd.top = top $ 
 else cmd.top = cmd.n_colors
 if(keyword_set(bottom)) then cmd.bottom = bottom
 if(keyword_set(data)) then cmd.data = data

 return, cmd
end
;=============================================================================



