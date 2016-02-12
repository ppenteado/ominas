;==============================================================================
; tvxmap
;
;==============================================================================
pro tvxmap, _xmap, _ps, color=color, fn=fn, data=data, max=max, min=min, $
            radius=radius, weight=weight, bin=bin, offset=offset

 ps = nv_clone(_ps)
 if(keyword_set(offset)) then ps_offset, ps, offset*bin

 xmap = _xmap

 dim = size(xmap, /dim)
 nx = dim[0]
 ny = dim[1]

 np = n_elements(ps)


 for i=0, np-1 do $
  begin
   p = pg_points(ps[i])
   if(keyword_set(p)) then $
    begin
     if(keyword_set(fn)) then shade = call_function(fn, ps[i], data)
     shade = xshade(p, shade, map=xmap, color=color, radius=radius, weight=weight, /getmap)
    end
  end


 xmap = bytscl(xmap, max=max)

device, set_graphics=7
 if(keyword_set(bin)) then xmap = rebin(xmap, nx/bin, ny/bin, 3)
 for j=1, 3 do tvim, offset=offset, /no_scale, xmap[*,*,j-1], channel=j
device, set_graphics=3

 nv_free, ps
end
;==============================================================================




