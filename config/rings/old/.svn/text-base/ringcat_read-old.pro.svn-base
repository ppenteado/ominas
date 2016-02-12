;=============================================================================;
; ringcat_read
;
;=============================================================================;
pro ringcat_read, filename, names=names, default=default, $
      fiducial=fiducial, opaque=opaque, sma=sma, ecc=ecc, lp=lp, dlpdt=dlpdt, $
      inc=inc, lan=lan, dlandt=dlandt, m=m, epoch=epoch, silent=silent

 ;----------------------------
 ; read file
 ;----------------------------
 if(NOT keyword_set(silent)) then print, 'Reading ring catalog ' + filename + '...'
 cat = read_txt_table(filename)

 ;----------------------------
 ; read columns
 ;----------------------------
 kk=0
 names = cat[*,kk]					 & kk=kk+1
 default = cat[*,kk] 					 & kk=kk+1
 fiducial = cat[*,kk]					 & kk=kk+1
 opaque = cat[*,kk]					 & kk=kk+1

 w = where(cat EQ '-')
 if(w[0] NE -1) then cat[w] = '0'

 sma = double(cat[*,kk])				 & kk=kk+1
 ecc = double(cat[*,kk])				 & kk=kk+1
 lp = double(cat[*,kk])		*!dpi/180d 		 & kk=kk+1
 dlpdt = double(cat[*,kk])	*!dpi/180d / 86400d	 & kk=kk+1
 inc = double(cat[*,kk])	*!dpi/180d		 & kk=kk+1
 lan = double(cat[*,kk])	*!dpi/180d		 & kk=kk+1
 dlandt = double(cat[*,kk])	*!dpi/180d / 86400d	 & kk=kk+1
 m = long(cat[*,kk])					 & kk=kk+1
 epoch = double(cat[*,kk])				 & kk=kk+1

 ;----------------------------
 ; consolidate features
 ;----------------------------
 w = where(names EQ '-')

 if(w[0] NE -1) then $
  begin
   ;- - - - - - - - - - - - - - - - - - - - -
   ; determine max # of modes
   ;- - - - - - - - - - - - - - - - - - - - -
   ww = w
   nn = 0
   repeat $
    begin
     ww = shift(ww,-1) - ww
     nn = nn + 1
    endrep until((where(ww EQ 1))[0] EQ -1)

   m = m#make_array(nn+1,val=1l) & m[*,1:*] = 0
   ecc = ecc#make_array(nn+1,val=1d) & ecc[*,1:*] = 0
   lp = lp#make_array(nn+1,val=1d) & lp[*,1:*] = 0
   dlpdt = dlpdt#make_array(nn+1,val=1d) & dlpdt[*,1:*] = 0

   ;- - - - - - - - - - - - - - - - - - - - -
   ; fill in modes
   ;- - - - - - - - - - - - - - - - - - - - -
   nw = n_elements(w)
   for i=0, nw-1 do $
    begin
     if(i EQ 0) then jj = 1 $
     else if(w[i] - w[i-1] NE 1) then jj = 1 $
     else jj = jj + 1

     m[w[i]-jj,jj] = m[w[i],0]
     ecc[w[i]-jj,jj] = ecc[w[i],0]
     lp[w[i]-jj,jj] = lp[w[i],0]
     dlpdt[w[i]-jj,jj] = dlpdt[w[i],0]
    end
  end

 w = where(names NE '-')
 names = names[w]
 default = default[w]
 fiducial = fiducial[w]
 opaque = opaque[w]
 sma = sma[w]
 ecc = ecc[w,*]
 lp = lp[w,*]
 dlpdt = dlpdt[w,*]
 inc = inc[w]
 lan = lan[w]
 dlandt = dlandt[w]
 m = m[w,*]
 epoch = epoch[w]

end
;=============================================================================;


pro test
 !quiet=1

dd = nv_read('~/casIss/1498/N1498386079_1.IMG')
cd = pg_get_cameras(dd)
pd = pg_get_planets(dd, od=cd)
rd = pg_get_rings(dd, od=cd, pd=pd, '/all')

; ringcat_read, '~/idl_pro/minas/config/rings/ringcat_saturn.txt', $
;                                         names=names, rad=rad, circ=circ



end

