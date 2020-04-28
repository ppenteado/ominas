/******************************************************************************
* vgr_cd_input.c
*
*
*******************************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <float.h>



#define RECORD_BYTES        836
#define TRUE                  1
#define FALSE                 0
#define O_RDONLY         0x0000     /* open for reading only        */
#define O_BINARY         0x8000     /* file mode is binary          */



/***************************************************************************
* subroutine get_files - get input filenames and open               
*                                                                   
****************************************************************************/
int get_files(filename, host, fileno_p)
 char *filename;
 int host;
 int *fileno_p;
 {
  short   shortint;
  int fileno;

  if (host == 1 | host == 2)
    {
     if ((fileno = open(filename, O_RDONLY|O_BINARY)) <= 0)
       {
        printf("\ncan't open input file: %s\n",filename);
        exit(1);
       }
    }
  else if (host == 3 | host == 5)
    {
     if ((fileno = open(filename, O_RDONLY)) <= 0)
       {
        printf("\ncan't open input file: %s\n",filename);
        exit(1);
       }

  /****************************************************************/
  /* If we are on a vax see if the file is in var length format.  */
  /* This logic is in here in case the vax file has been stored   */
  /* in fixed or undefined format.  This might be necessary since */
  /* vax variable length files can't be moved to other computer   */
  /* systems with standard comm programs (kermit, for example).   */
  /****************************************************************/

     if (host == 3)
       {
        read(fileno,&shortint,2);
        if (shortint > 0 && shortint < 80)
          {
           host = 4;              /* change host to 4                */
           printf("This is not a VAX variable length file.\n");
          }
        else printf("This is a VAX variable length file.\n");
        lseek(fileno,0,0);        /* reposition to beginning of file */
       }
    }


  *fileno_p = fileno;
  return(host);  /* In case its been updated */
 }
/**************************************************************************/



/***************************************************************************
* subroutine check_host - find out what kind of machine we are on  
*                                                                   
****************************************************************************/
int check_host()
 {
  char hostname[80];

  int swap, host, bits, var;
  union
    {
     char  ichar[2];
     short ilen;
    } onion;

  if (sizeof(var) == 4) bits = 32;
  else bits = 16;

  onion.ichar[0] = 1;
  onion.ichar[1] = 0;

  if (onion.ilen == 1) swap = TRUE;
  else                 swap = FALSE;

  if (bits == 16 && swap == TRUE)
    {
     host = 1; /* IBM PC host  */
     strcpy(hostname,
            "Host 1 - 16 bit integers with swapping, no var len support.");
    }

  if (bits == 16 && swap == FALSE)
    {
     host = 2; /* Non byte swapped 16 bit host  */
     strcpy(hostname,
          "Host 2 - 16 bit integers without swapping, no var len support.");
    }

  if (bits == 32 && swap == TRUE)
   { host = 3; /* VAX host with var length support */
     strcpy(hostname,
            "Host 3,4 - 32 bit integers with swapping.");
   }

  if (bits == 32 && swap == FALSE)
    {
     host = 5; /* OTHER 32-bit host  */
     strcpy(hostname,
            "Host 5 - 32 bit integers without swapping, no var len support.");
    }

  printf("%s\n",hostname);
  return(host);
 }
/**************************************************************************/



/***************************************************************************
* read_var - read variable length records from input file
*                                                                   
****************************************************************************/
read_var(fileno, ibuf, host)
 char *fileno, *ibuf;
 int host;
 {
  int length, result, nlen;
  char temp;
  union /* this union is used to swap 16 and 32 bit integers          */
   {
    char  ichar[4];
    short slen;
    long  llen;
   } onion;

  switch(host)
    {
     case 1: /*******************************************************/
             /* IBM PC host                                         */
             /*******************************************************/
       length = 0;
       result = read(fileno, &length, 2);
       nlen =   read(fileno, ibuf, length+(length%2));
       return(length);
       break;

     case 2: /*******************************************************/
             /* Macintosh host                                      */
             /*******************************************************/
       length = 0;
       result = read(fileno,onion.ichar,2);
       /*     byte swap the length field                            */
       temp   = onion.ichar[0];
       onion.ichar[0]=onion.ichar[1];
       onion.ichar[1]=temp;
       length = onion.slen;       /* left out of earlier versions   */
       nlen =   read(fileno, ibuf, length+(length%2));
       return(length);
       break;

     case 3: /*******************************************************/
             /* VAX host with variable length support               */
             /*******************************************************/
       length = read(fileno, ibuf, RECORD_BYTES);
       return(length);

     case 4: /*******************************************************/
             /* VAX host, but not a variable length file            */
             /*******************************************************/
       length = 0;
       result = read(fileno, &length, 2);
       nlen =   read(fileno, ibuf, length+(length%2));

       /* check to see if we crossed a vax record boundary          */
       while (nlen < length)
         nlen += read(fileno, ibuf+nlen, length+(length%2)-nlen);
       return(length);
       break;

     case 5: /*******************************************************/
             /* Unix workstation host (non-byte-swapped 32 bit host)*/
             /*******************************************************/
       length = 0;
       result = read(fileno, onion.ichar,2);
       /*     byte swap the length field                            */
       temp   = onion.ichar[0];
       onion.ichar[0]=onion.ichar[1];
       onion.ichar[1]=temp;
       length = onion.slen;
       nlen =   read(fileno, ibuf, length+(length%2));
       return(length);
       break;
    }
}
/***************************************************************************/



/***************************************************************************
* vicar_labels       
*
*
****************************************************************************/
void vicar_labels(fileno, host)
 int fileno, host;
 {
  char ibuf[2048], outstring[80];
  unsigned char cr=13, lf=10, blank=32;
  short length, nlen, line, i;

 /*--------------------------------------*
  * skip to end of pds label
  *--------------------------------------*/
  do
    {
     length = read_var(fileno, ibuf, host);
     if ((i = strncmp(ibuf,"END",3)) == 0 && length == 3) break;
    } while(length > 0);


}
/**************************************************************************/



/***************************************************************************
* read_image
*
*
****************************************************************************/
int read_image(argc, argv)
 int argc;
 char *argv[];
 {
  int nn = 0;
  char *filename = (char *)argv[nn++]; 
  char *image = (char *)argv[nn++];

  register int i;
  extern void decmpinit(); /* decmpinit is void function*/
  extern void decompress();/* decompress is void fuction*/
  long nsi, nso, nl, il;
  long hist[511];
  char ibuf[RECORD_BYTES], obuf[RECORD_BYTES];
  short host, length;
  long long_length;
  int fileno;



 /*------------------------------------*
  * determine host type
  *------------------------------------*/
  host = check_host();
  host = get_files(filename, host, &fileno); /* may change host if VAX */


 /*------------------------------------*
  * get the label
  *------------------------------------*/
  vicar_labels(fileno, host);


 /*------------------------------------*
  * skip some stuff
  *------------------------------------*/
  length = read_var(fileno, (char *)hist, host);
  length = read_var(fileno, (char *)hist+RECORD_BYTES, host);


 /*------------------------------------*
  * get the hist thingy
  *------------------------------------*/
  length = read_var(fileno, (char *)hist, host);
  length = read_var(fileno, (char *)hist+RECORD_BYTES, host);
  length = read_var(fileno, (char *)hist+1672, host);


 /*------------------------------------*
  * skip something else
  *------------------------------------*/
  length = read_var(fileno, ibuf, host);


 /*------------------------------------*
  * decompress
  *------------------------------------*/
  decmpinit(hist);

  nl  = 800;
  nso = RECORD_BYTES;
  for (i=0; i<nl; i++)
   {
    length = read_var(fileno, ibuf, host);
    long_length = (long)length;
    decompress(ibuf, obuf, &long_length, &nso);
    memcpy((char *)(image+i*nl), (char *)obuf, nl);
   }


  return(0);
 }
/***************************************************************************/



