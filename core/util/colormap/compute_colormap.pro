;=============================================================================
; compute_colormap
;
;
;=============================================================================
function compute_colormap, cmd

 n_colors = cmd.n_colors
 _top = cmd.top
 _bottom = cmd.bottom

 if(cmd.top EQ cmd.bottom) then $
  begin
   _bottom = cmd.bottom
   _top = cmd.bottom + 1  
  end

 range = abs(_top - _bottom)

 bottom = min([_top, _bottom])
 top = max([_top, _bottom])

 colormap = lonarr(n_colors)
 if(top GT 0) then colormap[top-1:*] = n_colors-1

 colormap[bottom:top-1] = $
	 	    (lindgen(range)/double(range))^cmd.gamma * double(n_colors)

 return, colormap*cmd.shade
end
;=============================================================================



