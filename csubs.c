#ifdef SHORTREAL
#   define REAL float
#else
#   define REAL double
#endif
#include <math.h>

void csumc_(n,scalar,c)
    int * n;
    REAL * scalar;
    REAL * c;
{
    register int i;
    register REAL * pr;
    register REAL sum;
    int ndata;
    ndata = *n;
    sum = 0;
    for(i=0, pr=c; i<ndata; i++, pr++){
	sum+= *pr;
    }
    *scalar = sum;
}



void csumc(n,scalar,c)
    int * n;
    REAL * scalar;
    REAL * c;
{
    register int i;
    register REAL * pr;
    register REAL sum;
    int ndata;
    ndata = *n;
    sum = 0;
    for(i=0, pr=c; i<ndata; i++, pr++){
	sum+= *pr;
    }
    *scalar = sum;
}



