;+
; Create a 3-band mosaic
; ----------------------
;
;     Correct the illumination with a Lambertian function::
;     
;       dd_pht = objarr(n)
;       for i=0, n-1 do dd_pht[i] = pg_photom(dd[i], gd=gd[i],
;         refl_fn='pht_lamb', refl_parm=[0.9d], outline=limb_ps[i])
;       phtdata=list()
;       for i=0,n-1 do phtdata.add,(dat_data(dd_pht[i]))
;
;     Set up the mosaic::
;     
;       bands=[70,104,106]
;       map_xsize = 1600
;       map_ysize = 800
;       moslim=[[0d0,0.2d0],[0d0,0.1d0],[0d0,0.1d0]]
;       mosaics=list()
;    
;     Loop over bands, projecting and displaying each image::
;     
;       foreach band,bands,iband do begin
;         for i=0,n-1 do dat_set_data,dd_pht[i],phtdata[i,*,*,band]
;         md = pg_get_maps(/over, gbx = pd1, name='TITAN',$
;          type='RECTANGULAR',fn_data=ptr_new(),$
;          size=[map_xsize,map_ysize],origin=[map_xsize,map_ysize]/2)
;         dd_map = objarr(n)
;         for i=0, n-1 do begin
;          dd_map[i]=pg_map(dd_pht[i],md=md,gd=gd[i],aux=['EMM'])
;          tvim,dat_data(dd_map[i])<max((dat_data(dd[i]))[*,*,band]),/new
;         endfor
;         
;         ;Combine the images in a mosaic and display it
;     
;         dd_mosaic = pg_mosaic(dd_map, mosaic=mosaic, $
;           wt='emm', comb='sum', data={x:1, emm0:cos(89d*!dpi/180d)})
;         tvim,moslim[0,iband]>mosaic<moslim[1,iband],/new
;
;         ;Add a grid on top
;     
;         pd = pg_get_planets(dd[0], od=gd[0].cd)
;         gdm={cd:md,od:(gd[0].cd)[0],gbx:cor_select(pd,'TITAN'),$
;          dkx:gd[0].dkx}
;         map_grid_ps=pg_grid(gd=gdm, lat=lat, lon=lon)
;         plat_ps=pg_grid(gd=gdm, slon=!dpi/2d, lat=lat, nlon=0)
;         plon_ps=pg_grid(gd=gdm, slat=0d, lon=lon, nlat=0)
;         pg_draw, map_grid_ps, col=ctgreen()
;         pg_draw,plat_ps,psym=7,$
;          plabel=strmid(strtrim(lat*180d/!dpi,2),0,3),/label_p
;         pg_draw,plon_ps,psym=7,$
;           plabel=strmid(strtrim(lon*180d/!dpi,2),0,3),/label_p
;         mosaics.add,mosaic
;       endforeach
;       
;-
;-------------------------------------------------------------------------
;

