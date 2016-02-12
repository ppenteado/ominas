pro memtest, dkds, dt

 while(1) do $
  begin
   tdkds = _dsk_evolve(dkds, dt)
   help, /mem
   nv_free, tdkds




;   cd = cam_init_descriptors(10)
;   help, /mem
;   nv_free, cd
  end

end
