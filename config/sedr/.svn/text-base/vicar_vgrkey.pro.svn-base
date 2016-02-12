;=============================================================================
;+
; NAME:
;	vicar_vgrkey
;
;
; PURPOSE:
;	Return keyword values from a Voyager vicar label.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = vicar_vgrkey(label, keyword) 
;
;
; ARGUMENTS:
;  INPUT:
;
;	label:		A label/header from a Voyager VICAR image
;
;	keyword:	A string array of one or more supported keywords:
;			SCNUM : Spacecraft number (1 or 2) 
;			FDS   : Flight Data Subsystem count (hhhhh.mm)
;			SCTIME: FDS x 100 (no decimal)
;			PICNO : Picture number (nnnnPm+ddd) 
;			PLANET: Planet of encounter (from PICNO)
;			SCET  : Spacecraft Event Time (yy.ddd hh:mm:ss)
;			ERT   : Earth Receive Time (yy.ddd hh:mm:ss) 
;			CAMERA: Image camera (NA or WA) 
;			EXP   : Exposure in milliseconds 
;			FILNUM: Filter wheel position number 
;			FILTER: Filter 
;			SCAN  : Scan rate (1, 3, 5, or 10) 
;			MODE  : Camera mode (NAONLY, WAONLY or BOTSIM) 
;			GAIN  : Camera gain (LO or HI) 
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;	Searchs a Voyager VICAR label for supported input keyword values
;	and returns them as an array of strings.  If the number of values
;	is one, then a scalar is returned rather than an array of dim =[1]
;
;
; RESTRICTIONS:
;	NONE.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
;	Written by:    Haemmerle, 1/1999
;	               using ideas from S. Ewald 10/98
;	               and the VICAR routine ABLE77V2
;	
;-
;=============================================================================
function vicar_vgrkey, label, keyword

 n_keys = n_elements(keyword)
 value = strarr(n_keys)


 ;-----------------------
 ; Get VGR labels
 ;-----------------------
 lab02 = vicgetpar(label, 'LAB02')
 lab03 = vicgetpar(label, 'LAB03')
 lab04 = vicgetpar(label, 'LAB04')
 lab07 = vicgetpar(label, 'LAB07')

 s = size(lab02)
 if(s[1] EQ 2) then $
  begin
   nv_message, name='vicar_vgrkey', 'No Voyager VICAR label found.', /continue
   return, replicate('',n_keys)
  end

 planet = ['jupiter','saturn','uranus','neptune']
 plani = ['J','S','U','N']


 ;-----------------------
 ; Match keywords
 ;-----------------------
 for i=0, n_keys-1 do $
  begin

   case keyword(i) of $

     'SCNUM' :  if(strpos(lab02, 'VGR-1') NE -1) then value[i] = '1' $
                else if(strpos(lab02, 'VGR-2') NE -1) then value[i] = '2' $
                else value[i] = ''

     'FDS'   :  value[i] = strmid(lab02, strpos(lab02,' FDS ')+5, 8)

     'SCTIME':  value[i] = strmid(lab02, strpos(lab02,' FDS ')+5, 5) + $
                           strmid(lab02, strpos(lab02,' FDS ')+11, 2)

     'PICNO' :  value[i] = strmid(lab02, strpos(lab02,' PICNO ')+7, 10)

     'PLANET':  value[i] = planet( $
                             where( $
                              strmid(lab02, strpos(lab02,' PICNO ')+11, 1) $
                              EQ $
                              plani $
                             ) $
                           )

     'SCET'  :  value[i] = strmid(lab02, strpos(lab02,' SCET ')+6, 15)

     'ERT'   :  value[i] = strmid(lab04, strpos(lab04,'ERT')+4, 15)

     'CAMERA':   if(strpos(lab03, 'NA CAMERA') NE -1) then value[i]='NA' $
                 else if(strpos(lab03, 'WA CAMERA') NE -1) then value[i]='WA' $
                 else if(strpos(lab07, 'NAONLY') NE -1) then value[i]='NA' $
                 else if(strpos(lab07, 'WAONLY') NE -1) then value[i]='WA' $
                 else value[i] =  ''

     'EXP'   :  value[i] = strmid(lab03, strpos(lab03,' EXP ')+5, 9)

     'FILNUM':  value[i] = strmid(lab03, strpos(lab03,' FILT ')+6, 1)

     'FILTER':  value[i] = strmid(lab03, strpos(lab03,' FILT ')+8, 6)

     'SCAN'  :  value[i] = strmid(lab03, strpos(lab03,'  SCAN RATE')+12, 2)

     'MODE'  :  value[i] = strmid(lab07, strpos(lab07,' MODE ')+8, 6)

     'GAIN'  :  if(strpos(lab03, 'LO GAIN') NE -1) then value[i]='LO' $
                else if(strpos(lab03, 'HI GAIN') NE -1) then value[i]='HI' $
                else value[i] = ''

     else    :  value[i] = '' 
   end
  end 

 return, decrapify(value)
end
