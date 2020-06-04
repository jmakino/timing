#define MAXVECTOR 5000000
#define MAXARRAY  5000000
#ifdef LONGINT
#define  INT integer * 8
#else
#define INT integer
#endif
      INT nmax, arymax, na
      parameter(nmax=MAXVECTOR, arymax=MAXARRAY)
      parameter(na=nmax + 1)
      REAL a(na), b(nmax), c(nmax), d(nmax), bbig(arymax)
      INT ia(na), ib(na), ic(na)
      REAL b1(nmax), b2(nmax)
      INT ind(nmax), ind2(nmax)
      common /vects/ a, b, c, d, b1, b2, ind, ind2
      common /vect2/bbig
      common /ivects/ ia, ib, ic
      REAL scalar
      common/scals/scalar
