function BTABVECT, table, start, bytes, type, elements
;+
; NAME:
;       BTABVECT        (binary - table - to - vector)
; PURPOSE:
;       Extract the desired column vector from a binary table saved in a
;       2 dimensional IDL byte array
;
; CALLING SEQUENCE:
;       Result=BTABVECT(table, start, bytes, type [,elements])
;
; INPUTS:
;       table = a 2 dimensional byte array containing the unconverted 'raw'
;       data from a binary table.
;
;       start = the starting byte of the desired column vector 
;
;       bytes = the number of bytes in the desired column vector
;
;       type = the data type (BYTE,INTEGER,UNSIGNED_INTEGER,REAL,FLOAT,
;       DOUBLE,BOOLEAN,TIME,DATE or CHARACTER) of the desired column vector
;
; OPTIONAL INPUT:
;	ELEMENTS - number of elements across if column to be extracted is
;		a 2 dimensional array. Defaults to 1. 
;
; OUTPUTS:
;       Result = column vector of type defined by the particular column header,
;       extracted from the binary table.
;
; EXAMPLE:
;       Extract the column vector that starts at byte 0, is 2 bytes long, 
;       and is of type 'INTEGER' from a PDS binary table saved in the variable
;       table, and return it as an integer array, named vect. 
;
;               IDL> vect = BTABVECT(table,0,2,'INTEGER')
; WARNINGS:
;       This version of BTABVECT does not handle COMPLEX numbers yet. That
;       capability will be added later.
;
; HISTORY:
;       Written by John D. Koch, January,1995
;-

  ;On_error,2                    ;Return to user      got      

;       Check for filename input

 params = N_params()
 if params LT 4 then begin
    print,'Syntax - result = BTABVECT(table, start, bytes, type [,elements])'
    return, -1
 endif

; 	If optional input 'elements' not given; set number of sub-columns to 1

 if params LT 5 then elem = 1 else elem = elements(0)
 t_bytes = long(bytes)*elem  		

;       Extract necessary information about the table to be used

 tabsize = size(table)
 if tabsize(0) GT 2 then message,$
	'ERROR - Table must be 2 dimensional' else begin $
    x = tabsize(1)
    y = tabsize(2)
    if y EQ 1 then a = x  else  a = tabsize(4)-1 

;       Determine the vector type

    CASE type(0) OF
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
 	                'ERROR - '+type(0)+' not a recognized data type!'    
    ENDCASE

;       Make the column vector from the byte table

    CASE vt(0) OF
        'i': begin
                vect = intarr(elem,Y)
                j = long(0)
                for i = long(start),a-1,x do begin
                   vect(*,j)=fix(table(i:i+t_bytes(0)-1),0,elem)
                   j = j + 1
                endfor
             end
        'l': begin
                vect = lonarr(elem,Y)
                j = long(0)
                for i = long(start),a-1,x do begin
                   vect(*,j)=long(table(i:i+t_bytes(0)-1),0,elem)
                   j = j + 1
                endfor
             end
        'f': begin
                vect = fltarr(elem,Y)
                j = long(0)
                for i = long(start),a-1,x do begin
                   vect(*,j)=float(table(i:i+t_bytes(0)-1),0,elem)
                   j = j + 1
                endfor
             end
        'b': begin
                vect = bytarr(elem,Y)
                j = long(0)
                for i = long(start),a-1,x do begin
                   vect(*,j)=byte(table(i:i+t_bytes(0)-1),0,elem)
                   j = j + 1
                endfor
             end
        'd': begin
                vect = dblarr(elem,Y)
                j = long(0)
                for i = long(start),a-1,x do begin
                   vect(*,j)=double(table(i:i+t_bytes(0)-1),0,elem)
                   j = j + 1
                endfor
             end
      else: begin
                vect = strarr(Y)
                j = long(0)
                for i = long(start),a-1,x do begin
                   vect(j) = string(table(i:i+t_bytes(0)-1))
                   j = j + 1
                endfor
            end
    ENDCASE 
 endelse

;       Return the vector extracted from the table

 return,vect
 
 end
