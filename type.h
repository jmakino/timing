#ifdef CRAY
#define REAL real
#define TIMEARG real
#else /*CRAY*/
#ifdef CYBER
#define REAL real
#define TIMEARG real
#else /*CYBER*/ 
#ifndef SHORTREAL
#define REAL real * 8
#endif
#ifdef SHORTREAL
#define REAL real * 4
#endif
#define TIMEARG real * 8
#endif/*CYBER*/
#endif/*CRAY*/
