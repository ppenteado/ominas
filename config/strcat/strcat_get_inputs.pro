; docformat = 'rst'
;+
; Obtains scene data to be used by star catalog translator.
; 
; Notes
; =====
;	Assumes star positions are wrt SSB, not sun
;	
;	Assumes camera coordinate system is Earth equatorial
;	
;	:Private:
;-

;+
; :Hidden:
;-
pro strcat_get_inputs, dd, env, key, $
	b1950=b1950, j2000=j2000, time=time, jtime=jtime, cam_vel=cam_vel, $
	path=path, names=names, noaberr=noaberr, $
	ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
	faint=faint, bright=bright, nbright=nbright, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 status = -1

 ;---------------------------------------------------------
 ; Translator keywords
 ;---------------------------------------------------------
 all = tr_keyword_value(dd, 'all')
 b1950 = tr_keyword_value(dd, 'b1950')
 jtime = double(tr_keyword_value(dd, 'jtime'))
 j2000 = tr_keyword_value(dd, 'j2000')
 noaberr = tr_keyword_value(dd, 'noaberr')
 _faint = tr_keyword_value(dd, 'faint')
 if(_faint NE '') then faint = double(_faint)
 _bright = tr_keyword_value(dd, 'bright')
 if(_bright NE '') then bright = double(_bright)
 nbright = long(tr_keyword_value(dd, 'nbright'))

 ;---------------------------------------------------------
 ; Star catalog path
 ;---------------------------------------------------------
 path = tr_keyword_value(dd, key)
 if(NOT keyword_set(path)) then path = getenv(env);
 if(NOT keyword_set(path)) then $
  begin
   nv_message, /cont, name='strcat_get_inputs', $
                   'Warning: ' + env + ' not defined.  No star catalog.'
   return
  end
   

 ;---------------------------------------------------------
 ; Observer descriptor passed as key1
 ;---------------------------------------------------------
 if(keyword_set(key1)) then ods = key1 
 if(NOT cor_isa(ods[0], 'BODY')) then ods = 0
 if(NOT keyword_set(ods)) then return

 ;---------------------------------------------------------
 ; Sun descriptor passed as key2
 ;---------------------------------------------------------
; if(keyword_set(key2)) then sund = key2

 ;---------------------------------------------------------
 ; Image corners passed as key5
 ;---------------------------------------------------------
 if(keyword_set(key5)) then _corners = key5


 ;---------------------------------------------------------
 ; ra/dec corners passed as key6
 ;---------------------------------------------------------
 if(keyword_set(key6)) then _radec = key6

 ;---------------------------------------------------------
 ; Names passed as key8
 ;---------------------------------------------------------
 if(keyword_set(key8)) then names = key8

 ;---------------------------------------------------------
 ; Get jtime 
 ;---------------------------------------------------------
 time = bod_time(ods[0])
 if(NOT keyword_set(jtime)) then $
  begin
   jtime = time/(365.25d*86400d)      ; assuming camtime is secs past 2000
   if(keyword__set(b1950)) then jtime = jtime + 50.
  end


 ;---------------------------------------------------------
 ; Get ra/dec limits 
 ;---------------------------------------------------------
 if(keyword_set(all)) then $
  begin
   ra1 = 0d & ra2 = 2d*!dpi * 0.999
   dec1 = -!dpi/2d * 0.999 & dec2 = -dec1 * 0.999
  end $
 else $
  begin
   if(keyword_set(_corners)) then corners = _corners $
   else if(keyword_set(_radec)) then corners = radec_to_image(ods[0], _radec) $
   else $
    begin
     slop = 1.5
     nx = (cam_size(ods[0]))[0]
     ny = (cam_size(ods[0]))[0]
     xslop = (slop-1d) * nx
     yslop = (slop-1d) * ny

     x0 = -xslop & x1 = nx + xslop
     y0 = -yslop & y1 = ny + yslop

     corners = [ [x0, y0],$
                 [x0, y1], $
                 [x1, y0], $
                 [x1, y1] ]

    end

   radec_image_bounds, ods[0], slop=slop, corners=corners, $
               ramin=ra1, ramax=ra2, decmin=dec1, decmax=dec2
  end


 ;-------------------------------------------------------------------
 ; Get camera velocity for stellar aberration 
 ;-------------------------------------------------------------------
 cam_vel = (bod_vel(ods[0]))[0,*]

; if(keyword__set(sund)) then $
;  begin
;   vel = (bod_vel(ods[0]))[0,*]
;   sun_vel = (bod_vel(sund))[0,*]
;   cam_vel = vel - sun_vel
;  end $
; else nv_message, name='strcat_get_inputs', /continue, $
;        'Observer velocity unknown.  Will not correct for stellar aberration.'


 status = 0

end
;=============================================================================
