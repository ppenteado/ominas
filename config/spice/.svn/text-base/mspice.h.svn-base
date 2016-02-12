/*****************************************************************************
* mspice.h
*
*
******************************************************************************/
#ifndef _mspice_h
#define _mspice_h


#include <stdlib.h>
#include <stdio.h>

#include <SpiceUsr.h>
#include "SpiceZfc.h"
#include "SpiceZmc.h"

#include <export.h>



#define LENOUT	512
#define NAMELEN	512
#define NKVAR	128



#define	E_TMPNAM	-100
#define	E_OPNKFILE	-101
#define	E_OPNKLIST	-102
#define	E_GETENV	-103
#define	E_UNLOAD	-104
#define	E_LOAD		-105



#define error_return(errno, string) \
	{ \
	  if(string != NULL) strcpy(err_st, string);			\
	  return(errno);						\
	}

char err_st[128];


#define spice_fail(status) \
	{ \
	  SpiceChar msg[LENOUT];					\
	  getmsg_c("LONG", LENOUT, msg);				\
	  fprintf(stderr, "SPICE error:\n\n%s\n\n", msg);		\
	  return(status);						\
	}


#endif /* _mspice_h */ 
