#include "type.h"
#ifdef CRAY
CDIR\ LIST
#endif
c----------------------------------------------------------------------
c      timing.f : vector-pipeline benchmark program
c      version 0.1 : produce correct MFLOPS for short loops
c      88-11-25
c----------------------------------------------------------------------
c
c     timer routines (machine specific)
c

#ifdef CRAY
      subroutine tminit
      end
#endif
#ifdef CYBER
      subroutine tminit
      end
      subroutine getsec(t)
      real t
      t=second()
      end
#endif      
#ifdef VOS3
      subroutine tminit
      call clock
      end
      subroutine getsec(t)
      real * 8 t
      real t4
      call clock(t4,5)
      t = t4
      end
#endif
#ifdef MSP
      subroutine tminit
      end
      subroutine getsec(t)
      real * 8 t
      call clock(t, 0, 2)
      end
#endif

#ifdef HAS_ETIME
      subroutine tminit
      real * 4 dtime, delta, tarray(2)
      delta = dtime(tarray)
      end
      subroutine getsec(t)
      real * 8 t
      real * 4 dtime, delta, tarray(2)
      delta = dtime(tarray)
      t = delta
      end
#endif

      subroutine lsq(x, y, n, a, b)
      integer n
      REAL x(n), y(n), a, b
      REAL sx, sy, sxx, syy, sxy
      integer i
      sx = 0
      sy = 0
      sxx = 0
      syy = 0
      sxy = 0
      do 10 i = 1, n
         sx = sx + x(i)
         sy = sy + y(i)
         sxx = sxx + x(i)*x(i)
         sxy = sxy + x(i)*y(i)
         syy = syy + y(i)*y(i)
10    continue
      b = (sy*sxx/sx-sxy) / ( sxx*n/sx + sx)
      a = (sy - n*b)/sx
      end
      subroutine timing(action, factor,name, ntmax)
      external action
#include "timing.h"
      character * 30 name

#define time ttttt

      integer factor,ntest,  maxtst
      INT ntmax
      parameter (ntest = 11)
      integer vlen(ntest), count(ntest)
      TIMEARG time(0:ntest), tstart, tend, vlr(ntest)
      integer i, j
      TIMEARG av, bv, nhalf, rinf
#if 1
      data vlen/0,3,10,30,100,300,1000,3000,30000,300000,3000000/
      data count/3000000,3000000,3000000,3000000,900000,90000,30000,
     $    9000,900,90,9/
#else
#ifdef MINI
      data vlen/0,3,10,30,100,300,1000,3000,10000,30000/
      data count/10000,10000,10000,3000,1000,300,100,30,10,3/
#else
      data vlen/0,3,10,30,100,300,1000,3000,10000,30000/
      data count/10000,10000,10000,10000,3000,
     $            3000,1000,1000,300,100/
#endif
#endif
      write(6,603) name
603   format(/,' ',a30,/)
      do 50 i = 1, ntest
         if(vlen(i) .le. ntmax) maxtst = i
50    continue
      i = 1
      call getsec(tstart)
      do 40 j = 1, count(i)
         call dummy(vlen(i))
40    continue
      call getsec(tend)
      time(0) = (tend - tstart) / count(i)
      do 10 i = 1, maxtst
         vlr(i) = vlen(i)
         call getsec(tstart)
         do 20 j = 1, count(i)
            call action(vlen(i))
20       continue
         call getsec(tend)
         time(i) = (tend - tstart) / count(i)
         write(6,600) vlen(i), tend-tstart,
     $        vlen(i)*1e-6/(time(i)-time(0))*factor
600      format(' vlen=',i7, ' dt=', e12.4,' Mflops=', f12.5)
10    continue
      write(6,601) time(0), time(1) - time(0)
601   format(' calling overhead = ', e12.4,
     $ ' Loop overhead ? =',e12.4)
      do 30 i = 2, maxtst
         time(i) = time(i) - time(0)
30    continue
      bv = (time(maxtst-1) -time(2))/(vlen(maxtst-1) - vlen(2))
      av = time(2) - bv * vlen(2)
      nhalf = av/bv
      rinf = 1.0d0/bv*factor
      write(6,602) '2-p  ',av*1e6, bv*1e9, nhalf, rinf/1e6
602   format(' ', a5,' a =',f8.3,' micros b=',f8.2,'ns Nhalf=',f5.1,
     $ ' Rinf=', e12.5,' Mflops')
      call lsq(vlr(2), time(2), maxtst-1, bv, av)
      nhalf = av/bv
      rinf = 1.0d0/bv*factor
      write(6,602) 'lsq  ',av*1e6, bv*1e9, nhalf, rinf/1e6
      end
 
      subroutine init
#include "timing.h"
      integer i, j
      REAL jreal
      jreal = 58427
      do 10 i = 1, nmax
         jreal = mod(jreal * 48828125.0d0,2147483648.0d0)
         j = int(jreal/2147483648.0d0*nmax) + 1
c         write(6,*) i, j
         ind(i) = j
         ind2(i) = i
         b(i) = i
         ib(i) = i
         ic(i) = -i*20
         c(i) = 1.0 - (2.0*i)/nmax
         d(i) = b(i)
         b1(i) = mod(i,2) - 0.5
         b2(i) = mod(i,10) - 0.5
         bbig(i) = c(i)
10    continue
      scalar = 199d0
      end
 
      subroutine dummy(n)
#include "timing.h"
      integer n, i
      i = n
      end

      subroutine itor(n)
#include "timing.h"
      integer n, i
      i = n
      do 10 i = 1, n
         a(i) = ib(i)
10    continue
      end
 
      subroutine rtoi(n)
#include "timing.h"
      integer n, i
      i = n
      do 10 i = 1, n
         ia(i) = b(i)
10    continue
      end
 
      subroutine iadd(n)
#include "timing.h"
      integer n, i
      i = n
      do 10 i = 1, n
         ia(i) = ib(i)+ic(i)
10    continue
      end
 
      subroutine add2(n)
#include "timing.h"
      integer n, i
      i = n
      do 10 i = 1, n
         a(i) = b(i)+c(i)
10    continue
      end
 
      subroutine add1(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = b(i)+scalar
10    continue
      end
 
      subroutine mul1(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = b(i)*scalar
10    continue
      end
 
      subroutine mul2(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = b(i)*c(i)
10    continue
      end
 
      subroutine div(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = c(i)/b(i)
10    continue
      end
 
      subroutine sqrtv(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = sqrt(b(i))
10    continue
      end
 
      subroutine absv(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = abs(c(i))
10    continue
      end
 
      subroutine sinv(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = sin(c(i))
10    continue
      end
 
      subroutine expv(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = exp(c(i))
10    continue
      end
 
      subroutine move(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = b(i)
10    continue
      end

#define send sndxxx
      subroutine send(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(ind(i)) = b(i)
10    continue
      end
 
      subroutine send2(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(ind2(i)) = b(i)
10    continue
      end
 
      subroutine get(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = b(ind(i))
10    continue
      end
 
      subroutine get2(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = b(ind2(i))
10    continue
      end
 
      subroutine stp2(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = bbig(i*2)
10    continue
      end
 
      subroutine stp23(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = bbig(i*23)
10    continue
      end
 
      subroutine stp64(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         a(i) = bbig(i*64)
10    continue
      end
 
      subroutine sum(n)
#include "timing.h"
      integer n,i
      scalar = 0.0
      do 10 i = 1, n
         scalar=scalar + c(i)
10    continue
      end
#ifdef UNIX 
      subroutine csum(n)
#include "timing.h"
      integer n,i
      call csumc(n,scalar,c)
      end
#endif 
 
      subroutine ip(n)
#include "timing.h"
      integer n,i
      scalar = 0.0
      do 10 i = 1, n
         scalar = scalar + b(i)*c(i)
10    continue
      end
 
      subroutine if1(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         if(b1(i) .gt. 0.0) a(i) = b1(i)
10    continue
      end

      subroutine cmp1(n)
#include "timing.h"
      integer n,i,j
      j=0
      do 10 i = 1, n
         if(b1(i) .gt. 0.0) then
            j=j+1
            a(j) = b1(i)
         endif
10    continue
      end
 
      subroutine if2(n)
#include "timing.h"
      integer n,i
      do 10 i = 1, n
         if(b2(i) .gt. 0.0) a(i) = b2(i)
10    continue
      end
 
      subroutine cmp2(n)
#include "timing.h"
      integer n,i,j
      j=0
      do 10 i = 1, n
         if(b2(i) .gt. 0.0) then
            j=j+1
            a(j) = b2(i)
         endif
10    continue
      end
 
 
      program time
      external add1, add2, move, sum, ip, mul1, mul2, div, csum
      external sqrtv, absv, sinv, expv
      external send, get, send2, get2
      external stp2, stp23, stp64, if1, if2, cmp1, cmp2
      external itor, rtoi, iadd
#include "timing.h"
      call init
      call tminit
      call timing(iadd,1,' V = V +V(int)                  ', nmax)
      call timing(itor,1,' VR = VI                      ', nmax)
      call timing(rtoi,1,' VI = VR                    ', nmax)
      call timing(move,1,' V = V                        ', nmax)
      call timing(add1,1,' V = V + S                    ', nmax)
      call timing(add2,1,' V = V + V                    ', nmax)
      call timing(mul1,1,' V = V * S                    ', nmax)
      call timing(mul2,1,' V = V * V                    ', nmax)
      call timing(div, 1,' V = V / V                    ', nmax)
      call timing(sum, 1,' S = S + V                    ', nmax)
#ifdef UNIX      
      call timing(csum, 1,' S = S + V (C)               ', nmax)
#endif      
      call timing(ip,  2,' S = S + V*V                  ', nmax)
      call timing(sqrtv, 1,' V = SQRT(V)                ', nmax)
      call timing(absv, 1,' V = ABS(V)                  ', nmax)
      call timing(sinv, 1,' V = SIN(V)                  ', nmax)
      call timing(expv, 1,' V = EXP(V)                  ', nmax)
      call timing(send,1,' V(IND) = V                   ', nmax)
      call timing(get, 1,' V = V(IND)                   ', nmax)
      call timing(send2,1,' V(IND) = V ,regular         ', nmax)
      call timing(get2, 1,' V = V(IND) ,regular         ', nmax)
      call timing(stp2,1,' V = V(2*I)                   ', nmax)
      call timing(stp23,1,' V = V(23*I)               ', arymax  /23)
      call timing(stp64,1,' V = V(64*I)               ', arymax  /64)
      call timing(if1,  1,' V = V (0.5 true)            ', nmax)
      call timing(if2,  1,' V = V (0.1 true)            ', nmax)
      call timing(cmp1,  1,' V = V(cmp) (0.5 true)       ', nmax)
      call timing(cmp2,  1,' V = V(cmp) (0.1 true)       ', nmax)
      end
