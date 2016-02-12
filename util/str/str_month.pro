;=============================================================================
; str_month
;
;
;=============================================================================
function str_month, mm

 case mm of 
	1:  return, 'January'
	2:  return, 'February'
	3:  return, 'March'
	4:  return, 'April'
	5:  return, 'May'
	6:  return, 'June'
	7:  return, 'July'
	8:  return, 'August'
	9:  return, 'September'
	10: return, 'October'
	11: return, 'November'
	12: return, 'December'
	else: message, 'Invalid month.'
 endcase

 return, ''
end
;=============================================================================
