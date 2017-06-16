function ARBINPDS, input_name, label, KEYWDS = keywds, INFO = info, $
                   SILENT = silent
;+
; NAME:
;	ARBINPDS (array - binary - pds)
; PURPOSE:
;	Read a PDS binary array into IDL array or an IDL structure array.
;
; CALLING SEQUENCE:
;	Result=ARBINPDS (Input_name, Label, [KEYWDS = keywds, INFO = info,
;                        /SILENT] )
;
; INPUTS:
;	INPUT_NAME = Either a scalar string containing the name of the PDS file
;         to be read or a byte array to be converted into the appropriate
;         PDS data array.  The latter input would normally be used only
;         when ARBINPDS is called by COLBIPDS or to read an array collection
;         object.
;                
;	LABEL = String array containing the "header" from the PDS file,
;         or selected lines of the header if input is a byte array.
;
;
; OUTPUTS:
;	Result = PDS array or structure array constructed from designated input.
;         Will be an IDL array if the data is a simple array or an array of 
;         arrays; will be an IDL structure array if the data is an array of
;         collections.
;
; OPTIONAL INPUT KEYWORDS:
;
;	SILENT - Normally, ARBINPDS will display the size of the array at 
;		the terminal.  The SILENT keyword will suppress this
;
;       KEYWDS - Required if and only if the input type is a byte array.
;                Supplies the label keywords which tells COLBIPDS.PRO how to 
;                interpret the data array. It is an nx9-element string array
;                which must conform to a (9,n), i.e. transposed, format, where
;                n = the total number of objects in the sub-array being
;                extracted (including the array itself as the first
;                object). The 9 columns must contain the following keywords
;                from the PDS label:
;                1. OBJECT
;                2. the index of the 'ENDOBJECT' corrsponding to each
;                   OBJECT.  Note that it will NOT be monotonically 
;                   increasing since there are embedded OBJECTS, e.g.
;                   the 0th index will always be the highest number since
;                   the 0th OBJECT will be the array itself. 
;                3. The START_BYTE corrsponding to OBJECT.
;                4. The NAME of the OBJECT.
;                5. BYTES used by the OBJECT.  If the OBJECT has no BYTES
;                   keyword, set to -1.
;                6. DATA_TYPE of the OBJECT.  If the OBJECT has no DATA_TYPE
;                   keyword, set to ' ' (whitespace).
;                7. AXES if the OBJECT is an array. IF not an array, set = 0.
;                8. AXIS_ITEMS if the OBJECT is an array. IF not an array, set
;                   to ' ' (whitespace).
;                9. Architecture, either 'MSB' or 'LSB', for each OBJECT.
;                Note that all numerical values must be converted to string
;                before concatanating the KEYWDS array.
;                
; OPTIONAL OUTPUT KEYWORDS:
;
;       INFO - A string array giving information about the name and size
;              of the output and any sub-arrays contained in the output,
;              with number of elements = the number of arrays created.
;              Especially useful in the case of nested arrays (array of arrays),
;              see example. A nested bracket notation is used, see example.
;              You should rename this variable if doing multiple reads as it is
;              passed as both input and output and any new info will be
;              concatanated on top of the old info.
;
; EXAMPLE:
;	Read a PDS file BINAR.PDS, containing a (5,5,2) array (named ARRAY1)
;       of (3,4) arrays (named ARRAY2) into an IDL (3,4,5,5,2) array.
;
;		IDL> array = ARBINPDS( 'BINAR.PDS', lbl, info=info)
;
;       The string info will = '[ARRAY1[ARRAY2(3,4)](5,5,2)]'
;       Note that info might help to interpret the result if an array of
;       arrays, as it makes explicit the nesting of dimensions and shows
;       the dimensions in the order they appear in the header, whereas IDL
;       reverses the order.
;
;       If you want to read only a sub-array (e.g. an array which is an element 
;       a collection):  
;
;               IDL> array  = ARBINDS( test_data,keywds=keywds,info=info)
;       where test_data is a byte array extracted from the data read from 
;       the file BINCOL.PDS.  The extraction goes from the START_BYTE of
;       the sub-array being extracted to the end of the data.
;
; WARNINGS:
;	This version of ARBINPDS is intended to be used only on MSB 
;	architectures ('big-endian') or if the file being read was written
;	in IEEE standard; it has no conversion from MSB to other 
;	architectures, yet.
;
; PROCEDURES USED:
;	Functions: PDSPAR, STR2NUM
;
; MODIFICATION HISTORY:
;       Written by Michael E. Haken, April-May 1996
;       Some sections adapted from TBINPDS and BTABVECT by John D. Koch
;       Feb 25, 2004, Puneet Khetarpal       Edited portions of the code
;                                            to meet readability of the
;                                            Keck data, and other array
;                                            object files with other non-
;                                            array objects.
;------------------------------------------------------------------------------

  ;On_error,2                    ;Return to user            

; Check for filename or byte array input

 if keyword_set(keywds) then begin
   if N_params() LT 1 then begin
     print,'Syntax - result = ARBINPDS( input_name, KEYWDS= keywds '+ $
	   '[INFO=info, ,/SILENT])'
     return, -1
   endif 
 endif else begin
   if N_params() LT 2 then begin
     print,'Syntax - result = ARBINPDS( input_name, lbl[,INFO=info, /SILENT])'
     return, -1
   endif
 endelse

 silent = keyword_set( SILENT )
 fname = input_name 
 sinput=size(fname)
 type_input=sinput(sinput(0)+1)

 if  (type_input ne 1 and type_input ne 7) or $
     (type_input eq 7 and sinput(0) ne 0) then message, $
      'Input must be either scalar string (filename) or byte array'

 if type_input eq 1 then begin
   if not (keyword_set(keywds)) then message, $
    'Must input KEYWDS if input is a byte array' $
   else keywds_tmp=keywds
 endif

 txt=fname
 addtxt=''

;	Read object to determine type of data in file

 if type_input eq 7 then begin


   object = pdspar(label,'OBJECT',COUNT=objects,INDEX=obj_ind)
   if !ERR EQ -1 then message, $
        'ERROR - '+txt+addtxt+': missing required OBJECT keywords'
   object=strlowcase(object)

   tempposition = where(object EQ 'array' OR object EQ 'element' OR $
                        object EQ 'collection')
   if (tempposition[0] NE -1) then begin
      object = object[tempposition]
      objects = n_elements(object)
      obj_ind = obj_ind[tempposition]
   endif

   inform = pdspar( label, 'INTERCHANGE_FORMAT', COUNT=informcount )     
   if !ERR EQ -1 then begin
     message,'ERROR - '+txt+': missing required INTERCHANGE_FORMAT keyword'
   endif else begin
     binform=byte(inform)                           
     exchr=where(binform eq 39b or binform eq 34b) ; remove characters
     if exchr(0) ne -1 then binform(exchr)=32b      ;"(34b) and '(39b)
     inform=strtrim(binform,2)                      ; from inform
     if n_elements(inform) gt 1 then begin      
       message, txt+': '+strcompress(informcount)+' entries found for ' + $
           'INTERCHANGE_FORMAT keyword. Attempting to proceed.', /INFORM
       if n_elements(uniq(inform)) gt 1 then message, $
        'ERROR - '+txt+': conflicting values of INTERCHANGE_FORMAT keyword.'
     endif
     inform = inform(0)
     if inform EQ "ASCII" then message, $
	'ERROR- Data for'+txt+' is an ASCII array; try ARASCPDS.'
   endelse

   name = pdspar(label,'NAME', COUNT=ncount,INDEX=nam_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required NAME keywords'

   data_type = pdspar(label,'DATA_TYPE',COUNT= dcount,INDEX=typ_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required DATA_TYPE keyword'

   length = pdspar(label,'BYTES',COUNT=bcount,INDEX=len_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required BYTES keyword' 

   start_byte = pdspar(label,'START_BYTE',COUNT=starts,INDEX=st_ind) - 1

   axes = fix(pdspar(label,'AXES',COUNT=axcount,INDEX=axes_ind))
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required AXES keyword'

   axis_items = pdspar(label,'AXIS_ITEMS',COUNT=axitcount,INDEX=axit_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required AXIS_ITEMS keyword'

;   endobj_ind=where(strpos(label,'END_OBJECT') ne -1, $
;                  endobjects)
;   if objects ne endobjects then message, $
;   txt+addtxt+ $
;    ': discrepancy in number of OBJECT keywords/END_OBJECT keywords. '+ $
;    'Attempting to proceed.',/INFORM

; edited by Puneet Khetarpal using GET_INDEX:
    endobj_ind = 0
    for tempcount = objects-1, 0, -1 do begin
       tempindex = GET_INDEX(label,obj_ind[tempcount])
       endobj_ind = [endobj_ind,tempindex]
    endfor
    endobjects = n_elements(endobj_ind)-1
    endobj_ind = endobj_ind[1:endobjects]
;------------------------------------------
   start_byte_tmp=start_byte
   name_tmp=name
   len_tmp=length    
   typ_tmp=data_type
   axes_tmp=axes
   axis_items_tmp=axis_items

   start_byte=lonarr(objects)
   name=strarr(objects)+' '
   length=lonarr(objects)-1
   data_type=strarr(objects)+' '
   axes=lonarr(objects)
   axis_items=strarr(objects)+' '

   for i=0,objects-1 do begin
     ind_lo = obj_ind(i)
     if i lt objects -1 then $
      ind_hi = obj_ind(i+1) else ind_hi = n_elements(label)
     for j=0,starts-1 do $       
       if st_ind(j) gt ind_lo and st_ind(j) lt ind_hi then $
        start_byte(i)=start_byte_tmp(j)
     for j=0,ncount-1 do $
       if nam_ind(j) gt ind_lo and nam_ind(j) lt ind_hi then $
        name(i)=name_tmp(j)
     for j=0,bcount-1 do $
       if len_ind(j) gt ind_lo and len_ind(j) lt ind_hi then $
        length(i)=len_tmp(j)
     for j=0,dcount-1 do $
       if typ_ind(j) gt ind_lo and typ_ind(j) lt ind_hi then $
        data_type(i)=typ_tmp(j)
     for j=0,axcount-1 do begin        
       if axes_ind(j) gt ind_lo and axes_ind(j) lt ind_hi then $
        axes(i)=axes_tmp(j)
       if axit_ind(j) gt ind_lo and axit_ind(j) lt ind_hi then $
        axis_items(i)=axis_items_tmp(j)
     endfor
   endfor


;       Trim extraneous characters from column names and data_types

   bname=byte(name)
   exchr=where(bname eq 10b or bname eq 13b or bname eq 34b $
     or bname eq 39b or bname eq 40b or bname eq 41b)
   if exchr(0) ne -1 then bname(exchr)=32b

   bdata_type=byte(data_type)
   exchr=where(bdata_type eq 10b or bdata_type eq 13b or bdata_type eq 34b $
    or bdata_type eq 39b or bdata_type eq 40b or bdata_type eq 41b)
   if exchr(0) ne -1 then bdata_type(exchr)=32b


   name = strtrim(bname,2)
   data_type = strtrim(bdata_type,2)
   arch=strarr(objects)
   for j = 0,objects-1 do begin
     spot = strpos(data_type(j),'_')+1
     if spot GT 0 then begin
       arch(j)=strmid(data_type(j),0,spot(0)-1)
       data_type(j)=strmid(data_type(j),spot,strlen(data_type(j))-spot+1)
     endif
   endfor

  
; 	Read pointer to find location of the array data  

;   pointer = pdspar(label,'ARRAY')
;   if !ERR EQ -1 then message, $
;     'ERROR- '+fname+': missing valid file pointer'
;   point = pointer(0)		
;   skip=0
;   temp = str2num(point,TYPE=t)
;   if t GT 6 then begin
;     l = strlen(point)
;     p = strpos(point,'"')
;     p2 = strpos(point,'"',p+1)
;     if p LT 0 then begin
;       p = strpos(point,"'")
;       p2 =  strpos(point,"'",p+1)
;     endif
;     c = strpos(point,',')
;     if (c GT -1) then skip = str2num(strtrim(strmid(point,c+1,L-c-1),2))-1
;     if (p GT -1) then point=strmid(point,p+1,p2-p-1)
;     d = strpos(fname,'/')		
;     tail = d					
;     dir = ''
;     while d GT -1 do begin		; extract the path to the directory,
;      	tail = d + 1
;       d = strpos(fname,'/',tail)
;     endwhile
;     dir = strmid(fname,0,tail)	
;     fname = dir + strupcase(point)
;     openr, unit, fname, ERROR = err, /GET_LUN, /BLOCK
;     if err LT 0 then fname = dir + strlowcase(point)
;     openr, unit, fname, ERROR = err, /GET_LUN, /BLOCK
;     if err LT 0 then begin
;       fname = dir + (point)
;       openr, unit, fname, ERROR = err, /GET_LUN, /BLOCK
;     endif
;     if err LT 0 then message,'Error opening file ' + ' ' + fname
;   endif else $     
;    skip = temp -1 

;-----------edited by Puneet Khetarpal using pointpds:
pointer = POINTPDS (label,fname,'ARRAY')
fname = pointer.datafile
skip = pointer.skip
openr, unit, fname, /GET_LUN
;------------------------------------------------------

; 	Inform user of program status if /SILENT not set

   if not (SILENT) then $       
    message,'Now reading array from ' +fname,/INFORM 
 
;	Read data into a 1-dimensional byte array

   filestat=fstat(unit)
   XY = filestat.size
   file = assoc(unit,bytarr(XY,/NOZERO),skip)
   filedata = file(0)
   free_lun, unit
   eo=obj_ind
   e=[[endobj_ind],[replicate(-1,objects)]]
   oi=[[obj_ind],[replicate(1,objects)]]
   oi=[oi,e]
   oi=oi(sort(oi(*,0)),*)
   ind=where(oi(*,1) eq 1)
   for j=0,objects-1 do begin
     t=0
     for i=ind(j),n_elements(oi)/2-1 do begin
       t=t+oi(i,1)
       if t(0) eq 0 then begin
         if oi(i,1) eq -1 then eo(j)=oi(i,0) 
         goto, continue
       endif
     endfor
  continue:
   endfor
   endobj_order=sort(sort(eo))

 endif else begin 
   XY = n_elements(fname)
   filedata = fname
   start_byte=long(reform(keywds(2,*)))
   start_byte(0)=0
   object=reform(keywds(0,*))
   objects=n_elements(object)
   eo=long(reform(keywds(1,*)))
   name=reform(keywds(3,*))
   length=long(reform(keywds(4,*)))
   data_type=reform(keywds(5,*))
   axes=long(reform(keywds(6,*)))
   axis_items=reform(keywds(7,*))
   arch=reform(keywds(8,*))
 endelse

 endobj_order=sort(sort(eo))
 if total(strpos(object(0:endobj_order(0)),'collection')) $
   eq -1*objects then begin
   if endobj_order(0) gt endobj_order(objects-1) then begin

;	Read the dimensions

     taxes=total(axes)
     dimensions=lonarr(taxes)
     bai=byte(reverse(axis_items))
     reads,string(((bai gt 57) or (bai lt 48))*32b $
                +(bai ge 48)*(bai le 57)*bai),dimensions
     nvalues=1L
     for i=0,taxes-1 do nvalues=nvalues*dimensions(i)

     arch=arch(where(object eq 'element'))
     typ=data_type(where(object eq 'element'))
     bytes=length(where(object eq 'element'))
     bytes=bytes(0)
     if total(start_byte+1) eq n_elements(start_byte) then $     
      ind=start_byte(0)+lindgen(nvalues*bytes) $
     else begin

       n=objects-1
       ind=lindgen(bytes)+start_byte(n) 
       for i=n-1,0,-1 do begin
         ibai=byte((axis_items(i)))
         idimensions=lonarr(axes(i))
         reads,string(((ibai gt 57) or (ibai lt 48))*32b+ $
           (ibai ge 48)*(ibai le 57)*ibai), idimensions
         invalues=1L
         for j=0,axes(i)-1 do invalues=invalues*idimensions(j)
         newind=start_byte(i)+ind
         nbytes=max(ind)+1
         for j=1L,invalues-1 do $     
           newind=[newind,ind+start_byte(i)+j*(nbytes)]
         ind=newind
       endfor
     endelse
     CASE arch(0) OF
                '': arch(0) = 'MSB'
             'MSB':
            'IEEE': arch(0) = 'MSB'
        'UNSIGNED': begin
                        arch(0) = 'MSB'
                        data_type(0) = 'UNSIGNED_INTEGER'
                    end
             'VAX': arch(0) = 'LSB'
            'VAXG': arch(0) = 'LSB'
             'LSB': arch(0) = 'LSB'
             'MAC': arch(0) = 'MSB'
             'SUN': arch(0) = 'MSB'
              'PC': if strpos(typ(0),'INTEGER') then arch(0) = 'LSB'
           'ASCII': begin
                        typ(0) = 'CHARACTER'
                        arch(0) = 'MSB'
                    end
              else: begin
                        message,$
        arch(0)+' not a recognized architecture! MSB assumed.',/INFORM
                        arch(0) = 'MSB'
                    end
     ENDCASE
     CASE typ(0) OF
                   'BYTE': vt ='b'
                'INTEGER': if bytes GT 2 then vt='l' else $
                           if bytes EQ 2 then vt='i' else vt ='b'
       'UNSIGNED_INTEGER': if bytes GT 2 then vt='l' else $
                           if bytes EQ 2 then vt='i' else vt ='b'
                   'REAL': if bytes LT 8 then vt ='f' else vt = 'd'
                  'FLOAT': if bytes LT 8 then vt ='f' else vt ='d'
              'CHARACTER': begin
                             vt ='s'
                             elem = 1
                           end
                 'DOUBLE': vt ='d'
                   'TIME': begin
                             vt ='s'
                             elem = 1
                           end
                'BOOLEAN': vt ='b'
                   'DATE': begin
                             vt ='s'
                             elem = 1
                           end
                'COMPLEX': message,$
                        'ERROR - COMPLEX numbers not yet handled by BTABVECT.'
                     else: message,$
                        'ERROR - '+typ(0)+' not a recognized data type!'

     ENDCASE
     CASE vt(0) OF
        'i': arr = reform(fix(filedata(ind),0,nvalues),dimensions)
        'l': arr = reform(long(filedata(ind),0,nvalues),dimensions)
        'f': arr = reform(float(filedata(ind),0,nvalues),dimensions)
        'b': arr = reform(filedata(ind),dimensions)
        'd': arr = reform(double(filedata(ind),0,nvalues),dimensions)
       else: arr = string(reform(filedata(ind),[1,dimensions]))
     ENDCASE
   
   endif else message, $
    txt+addtxt+':Improper nesting of ARRAY and ELEMENT objects in label. ' 
   j=min(where(object eq 'element'))

;	Convert to host byte order, if necessary

   if arch(0) EQ 'MSB' then ieee_to_host,arr else $
   if arch(0) EQ 'LSB' then arr = conv_vax_unix(arr) else $ 
   if arch(0) EQ 'PC' then message,$
    'PC_REAL data type not yet supported by ARBINPDS. No conversion',/INFORM

;	Check that data type is of the right sign

   if strpos(typ(0),'UNSIGNED') GT -1 then arr = abs(arr)

 endif else begin


   j=min(where(object eq 'collection'))
help, j
print, object
   if j gt 0 then begin
     taxes=total(axes(0:j-1))
     dimensions=lonarr(taxes)
     bai=byte(reverse(axis_items(0:j-1)))
     reads,string(((bai gt 57) or (bai lt 48))*32b $
       +(bai ge 48)*(bai le 57)*bai),dimensions
     com='arr = replicate(collection'
     nvalues=1L
     for i=0,taxes-1 do begin
       nvalues=nvalues*dimensions(i)
       com=com+','+strcompress(dimensions(i))
     endfor
 

     com=com+')'
     bytes=length(j)
     start=long(start_byte(j))
     fin=start+bytes-1
     eo_order=sort(sort(eo(j:*)))
     last=eo_order(0)
     keywds=[transpose(object(j:*)),string([transpose(eo(j:*)), $
            transpose(start_byte(j:*))]),transpose(name(j:*)), $
            string(transpose(length(j:*))),transpose(data_type(j:*)), $
            string(transpose(axes(j:*))),transpose(axis_items(j:*)), $
            transpose(strarr(objects-j))+arch]
     keywds=keywds(*,0:last)
     collection=colbipds(bytarr(bytes),keywds=keywds,info=info,silent=silent)
     mkarray=execute(com)
     if not (SILENT) then begin
       if mkarray eq 1 then print, $
        'Creating ('+strtrim(axis_items(0),2)+') collection array '+name(j) $
       else message, 'ERROR creating ('+dimensions+') structure'
     endif
     for k=0,nvalues-1 do begin
       addarray=colbipds(filedata(start:*),keywds=keywds,silent=silent)
       arr(k)=addarray
       start=fin+1
       fin=start+bytes-1
     endfor
   endif else message, $
    "Array object must be either 'ELEMENT' or 'COLLECTION'"
 endelse

 newinfo=''
 arraynames=where(object(0:j) eq 'array')
 bai=byte(axis_items(arraynames))
 arraynames=name(arraynames)
 nnames=n_elements(arraynames)
 axit_label= $
  '('+strcompress(((bai gt 57) or ((bai lt 48) and (bai ne 44b))*32b $
     +(bai ge 48)*(bai le 57)*bai+(bai eq 44b)*bai),/re)+')'
 for i=nnames-1,0,-1 do begin
   newinfo='['+arraynames(i)+newinfo+axit_label(i)+']'
 endfor
 newinfo=''
 arraynames=where(object(0:j) eq 'array')
 bai=byte(axis_items(arraynames))
 arraynames=name(arraynames)
 nnames=n_elements(arraynames)
 axit_label= $
  '('+strcompress(((bai gt 57) or ((bai lt 48) and (bai ne 44b))*32b $
     +(bai ge 48)*(bai le 57)*bai+(bai eq 44b)*bai),/re)+')'
 for i=nnames-1,0,-1 do begin
   newinfo='['+arraynames(i)+newinfo+axit_label(i)+']'
 endfor
 if keyword_set(info) then info=[info,newinfo] else info=newinfo

; 	Return data in IDL array or IDL structure array form

 if type_input eq 1 then keywds=keywds_tmp
 return, arr 

end
