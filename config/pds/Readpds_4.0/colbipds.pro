function COLBIPDS,input_name, label, KEYWDS = keywds, INFO=info, $
                  SILENT = silent
;+
; NAME:
;	COLBIPDS (collection - binary - pds)
; PURPOSE:
;	Read a PDS binary collection into IDL structure containing the elements 
;	of the collection as elements.
;
; CALLING SEQUENCE:
;	Result=COLBIPDS (Input_name, Label, [KEYWDS=keywds, INFO=info, 
;                        /SILENT] )
;
; INPUTS:
;       INPUT_NAME = Either a scalar string containing the name of the PDS file
;         to be read or a byte array to be converted into the appropriate
;         PDS collection.  The latter input would normally be used only
;         when COLBIPDS is called by ARBINPDS to read a collection array
;         object or recursively by itself to read a collection collection
;         object.
;
;
;	LABEL = String array containing the "header" from the PDS file.
;
; OUTPUTS:
;       Result = PDS IDL structure constructed from designated input.
;
; OPTIONAL INPUT KEYWORDS:
;
;	SILENT - Normally, COLBIPDS will display the size of the array at 
;		the terminal.  The SILENT keyword will suppress this
;
;       KEYWDS - Required if and only if the input type is a byte array.
;                Supplies the label keywords which tells COLBIPDS.PRO how to 
;                interpret the data array. It is an nx9-element string array
;                which must conform to a (9,n), i.e. transposed, format, where
;                n = the total number of objects in the sub-collection being
;                extracted (including the coolection itself as the first
;                object). The 9 columns must contain the following keywords
;                from the PDS label:
;                1. OBJECT
;                2. the index of the 'ENDOBJECT' corrsponding to each
;                   OBJECT.  Note that it will NOT be monotonically 
;                   increasing since there are embedded OBJECTS, e.g.
;                   the 0th index will always be the highest number since
;                   the 0th OBJECT will be the collection itself. 
;                3. The START_BYTE corrsponding to OBJECT.
;                4. The NAME of the OBJECT.
;                5. BYTES used by the OBJECT.  If the OBJECT has no BYTES
;                   keyword, set to -1.
;                6. DATA_TYPE of the OBJECT.  If the OBJECT has no DATA_TYPE
;                   keyword, set to ' ' (whitespace).
;                7. AXES if the OBJECT is an array. IF not an array, set = 0.
;                8. AXIS_ITEMS if the OBJECT is an array. IF not an array, set
;                   to ' ' (whitespace).
;                9. Architecture, either 'MSB' or 'LSB' for each OBJECT.
;                Note that all numerical values must be converted to string
;                before concatanating the KEYWDS array.
;                
; OPTIONAL OUTPUT KEYWORDS:
;
;       INFO   - A string array giving the names and sizes of all arrays 
;                contained in the output, with number of elements = the number
;                of arrays created.  Especially useful in the case of nested
;                arrays (array of arrays), see example in header of 
;                ARBINPDS.PRO. A nested bracket notation is used, see same 
;                example.  You should rename this variable when doing 
;                multiple reads as it is passed as both input an output and any
;                new info will be concatanated on top of the old info.
;
; EXAMPLE:
;       Read a PDS collection file BINCOL.PDS into an IDL structure whose 
;	elements are the elemenst of the collection, and get info on any
;       arrays which are contained in the collection:
;
;		IDL> col = COLBIPDS( 'BINCOL.PDS', lbl, info=info)
;
;       If you want to read only a sub-collection (an element of the collection
;       which is itself a collection), and get info on arrays which are
;       contained in the sub-collection:
;
;               IDL> col = COLBIPDS( test_data,keywds=keywds,info=info)
;       where test_data is a byte array extracted from the data read from 
;       the file BINCOL.PDS.  The extraction goes from the START_BYTE of
;       the sub-collection being extracted to the end of the data.
;
; WARNINGS:
;	This version of COLBIPDS is intended to be used only on MSB 
;	architectures ('big-endian') or if the file being read was written
;	in IEEE standard; it has no conversion from MSB to other 
;	architectures, yet.
;
; PROCEDURES USED:
;	Functions: PDSPAR, STR2NUM, BTABVECT
;
; MODIFICATION HISTORY:
;	Written by Michael E. Haken, May-June 1996                          
;       Portions adapted from TBINPDS and BTABVECT by John D. Koch
;
;------------------------------------------------------------------------------

 ;On_error,2                    ;Return to user            
							
; Check for proper input

 if keyword_set(keywds) then begin
   if N_params() LT 1 then begin		
     print,'Syntax - result = COLBIPDS( input_name, KEYWDS=keywds '+ $
	   '[INFO=info,,/SILENT])'
     return, -1
   endif 
 endif else begin
   if N_params() LT 2 then begin		
     print,'Syntax - result = COLBIPDS( input_name, lbl[,INFO=info, /SILENT])'
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
     
 if type_input eq 7 then begin

;	Read object to determine type of data in file


   object = pdspar(label,'OBJECT',COUNT=objects,INDEX=obj_ind)
   if !ERR EQ -1 then message, $
        'ERROR - '+txt+addtxt+': missing required OBJECT keywords'
   object=strlowcase(object)

   inform = pdspar( label, 'INTERCHANGE_FORMAT', COUNT=informcount )     
   if !ERR EQ -1 then begin
     message,'ERROR - '+txt+': missing required INTERCHANGE_FORMAT keyword'
   endif else begin
     binform=byte(inform)                           
     exchr=where(binform eq 39b or binform eq 34b) ; remove characters
     if exchr(0) ne -1 then binform(exchr)=32b      ;"(34b) and '(39b)
     inform=strtrim(binform,2)                      ; from inform
     if n_elements(inform) gt 1 then begin
       message, txt+': '+strcompress(informcount)+' values found for ' +$
           'INTERCHANGE_FORMAT keyword. Attempting to proceed.', /INFORM
       if n_elements(uniq(inform)) gt 1 then message, $
         'ERROR - '+txt+': conflicting values of INTERCHANGE_FORMAT keyword.'
     endif
     inform = inform(0)
     if inform EQ "ASCII" then message, $
	'ERROR- '+txt+' is an ASCII collection file; try COLASCPDS.'
   endelse

   name = pdspar(label,'NAME', COUNT= ncount,INDEX=nam_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required NAME keywords'

   data_type = pdspar(label,'DATA_TYPE',COUNT= dcount,INDEX=typ_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required DATA_TYPE keywords'

   length = pdspar(label,'BYTES',COUNT=bcount,INDEX=len_ind)
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required BYTES keywords' 

   start_byte = pdspar(label,'START_BYTE',COUNT=starts,INDEX=st_ind) - 1
   if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required START_BYTE keywords' 

   end_object=pdspar(label,'END_OBJECT',COUNT=end_objects,INDEX=eobj_ind)
   endobj_ind=where(strpos(label,'END_OBJECT') ne -1,endobjects)
   if objects ne endobjects then message, $
      txt+addtxt+ $
      ': discrepancy in number of OBJECT keywords/END_OBJECT keywords. '+$
      'Attempting to proceed.',/INFORM

   if total(strpos(object,'ARRAY')) gt -1*objects then begin
     axes = fix(pdspar(label,'AXES',COUNT=axcount,INDEX=axes_ind))
     if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required AXES keyword'

     axis_items = pdspar(label,'AXIS_ITEMS',COUNT=axitcount,INDEX=axit_ind)
     if !ERR EQ -1 then message, $
       'ERROR - '+txt+addtxt+' missing required AXIS_ITEMS keyword'
     if axcount ne axitcount then message, $
    'ERROR - '+txt+' discrepency in number of AXES keywords/AXIS_ITEMS keywords'
   endif else axcount=0

   start_byte_tmp=start_byte
   name_tmp=name       
   len_tmp=length     
   typ_tmp=data_type
   if n_elements(axes) gt 0 then begin
     axes_tmp=axes        
     axis_items_tmp=axis_items 
   endif 

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
     if axcount gt 0 then begin
       for j=0,axcount-1 do begin
         if axes_ind(j) gt ind_lo and axes_ind(j) lt ind_hi then $
          axes(i)=axes_tmp(j)
         if axit_ind(j) gt ind_lo and axit_ind(j) lt ind_hi then $
          axis_items(i)=axis_items_tmp(j)
       endfor
     endif
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
   data_type=string(bdata_type)

   name = strtrim(bname,2)
   data_type = strtrim(bdata_type,2)
   arch = strarr(objects)
   for j = 0,objects-1 do begin
     spot = strpos(data_type(j),'_')+1
     if spot GT 0 then begin
       arch(j)=strmid(data_type(j),0,spot(0)-1)
       data_type(j)=strmid(data_type(j),spot,strlen(data_type(j))-spot+1)
     endif
   endfor


; 	Read pointer to find location of the collection data  

   pointer = pdspar(label,'COLLECTION')
   if !ERR EQ -1 then message, $
     'ERROR- '+txt+addtxt+': missing valid file pointer'
   point = pointer(0)		
   skip=0
   temp = str2num(point,TYPE=t)
   if t GT 6 then begin
     l = strlen(point)
     p = strpos(point,'"')
     p2 = strpos(point,'"',p+1)
     if p LT 0 then begin
       p = strpos(point,"'")
       p2 =  strpos(point,"'",p+1)
     endif
     c = strpos(point,',')
     if (c GT -1) then skip = str2num(strtrim(strmid(point,c+1,L-c-1),2))-1
     if (p GT -1) then point=strmid(point,p+1,p2-p-1)
     d = strpos(fname,'/')		
     tail = d					
     dir = ''
     while d GT -1 do begin		; extract the path to the directory,
     	tail = d + 1
       	d = strpos(fname,'/',tail)
     endwhile
     dir = strmid(fname,0,tail)	
     fname = dir + strupcase(point)
     openr, unit, fname, ERROR = err, /GET_LUN, /BLOCK
     if err LT 0 then fname = dir + strlowcase(point)
     openr, unit, fname, ERROR = err, /GET_LUN, /BLOCK
     if err LT 0 then begin
       fname = dir + (point)
       openr, unit, fname, ERROR = err, /GET_LUN, /BLOCK
     endif
     if err LT 0 then message,'Error opening file ' + ' ' + fname
   endif else begin 
     skip = temp -1 
   endelse

; 	Inform user of program status if /SILENT not set

 if not (SILENT) then $        
   message,'Now reading collection from ' +fname,/INFORM 
 
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

 object=strlowcase(object)
 endobj_order=sort(sort(eo))
 nestend=0
 for j=1,endobj_order(0) do begin
   if endobj_order(j) lt nestend then goto, nextj
   start=start_byte(j)
   bytes=length(j)
   if object(j) eq 'element' then begin 
     vect=filedata(start:start+bytes-1)
     CASE Arch(j) OF
                '': arch(j) = 'MSB'
             'MSB':
            'IEEE': arch(j) = 'MSB'
        'UNSIGNED': begin
                        arch(j) = 'MSB'
                        data_type(j) = 'UNSIGNED_INTEGER'
                    end
             'VAX': arch(j) = 'LSB'
            'VAXG': arch(j) = 'LSB'
             'LSB': arch(j) = 'LSB'
             'MAC': arch(j) = 'MSB'
             'SUN': arch(j) = 'MSB'
              'PC': if strpos(data_type(j),'INTEGER') then arch(j) = 'LSB'
           'ASCII': begin
                        data_type(j) = 'CHARACTER'
                        arch(j) = 'MSB'
                    end
              else: begin
                        message,$
        arch(j)+' not a recognized architecture! MSB assumed.',/INFORM
                        arch(j) = 'MSB'
                    end
     ENDCASE
     CASE data_type(j) OF
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
                        'ERROR - '+data_type(j)+' not a recognized data type!'

     ENDCASE


     CASE vt OF
        'i': vect = (fix(vect,0,1))
        'l': vect = (long(vect,0,1))
        'f': vect = (float(vect,0,1))
        'b': vect = (vect)
        'd': vect = (double(vect,0,1))
      else:  vect = string(vect)
     ENDCASE

;	Convert to host byte order, if necessary

     if arch(j) EQ 'MSB' then ieee_to_host,vect else $
     if arch(j) EQ 'LSB' then vect = conv_vax_unix(vect) else $ 
     if arch(j) EQ 'PC' then message,$
       'PC_REAL data type not yet supported by COLBIPDS. No conversion',/INFORM

;	Check that data type is of the right sign
     if strpos(data_type(j),'UNSIGNED') GT -1 then vect = abs(vect)

   endif


   if object(j) eq 'collection' then begin
     if bytes eq -1 then message, $
      'collection '+name(j)+'missing required BYTES keyword. '+ $
      'Attempting to proceed',/INFORM
     nestend=endobj_order(j)
     eo_order=sort(sort(eo(j:*)))
     last=eo_order(0)
     keywds=[transpose(object(j:*)),string([transpose(eo(j:*)), $
             transpose(start_byte(j:*))]), transpose(name(j:*)), $
             string(transpose(length(j:*))),transpose(data_type(j:*)), $
             string(transpose(axes(j:*))),transpose(axis_items(j:*)), $
             transpose(arch(j:*))]
     keywds=keywds(*,0:last)
     vect=colbipds(filedata(start:*),keywds=keywds,info=info,silent=silent)
   endif

   if object(j) eq 'array' then begin
     nestend=endobj_order(j)
     eo_order=sort(sort(eo(j:*)))
     last=eo_order(0)
     keywds=[transpose(object(j:*)),string([transpose(eo(j:*)), $
             transpose(start_byte(j:*))]), transpose(name(j:*)), $
             string(transpose(length(j:*))),transpose(data_type(j:*)), $
             string(transpose(axes(j:*))),transpose(axis_items(j:*)), $
             transpose(arch(j:*))]
     keywds=keywds(*,0:last)
     vect=arbinpds(filedata(start:*),keywds=keywds,info=info,silent=silent)
   endif

   if j eq 1 then collection=create_struct(name(j),vect) else $
    collection=create_struct(collection,name(j),vect)

   struct_name = name(0)         

nextj:
 endfor
 collection=create_struct(name=struct_name,collection)
    

; 	Return data table in IDL array form

 if type_input eq 1 then keywds=keywds_tmp
 return, collection

end
