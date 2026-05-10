C ********************************************************************
C ORGN: CSUB - CMPS 3500
C FILE: spaghetti.f
C DATE: 09/10/2021
C ********************************************************************
      PROGRAM QUADSPAG
      DOUBLE PRECISION A,B,C,D,RT,RE,IM,DISC
      INTEGER J

      WRITE(*,*) 'Enter a, b, c:'
      READ(*,*) A,B,C

      IF (A) 50,900,50

   50 CONTINUE
      DISC = B*B - 4.0D0*A*C

      IF (DISC) 40,30,20

   20 CONTINUE

      ASSIGN 120 TO J
      GOTO 60

   30 CONTINUE

      ASSIGN 110 TO J
      GOTO 60

   40 CONTINUE

      ASSIGN 100 TO J
      GOTO 60

   60 CONTINUE
      GOTO J


  100 CONTINUE
      D = -DISC
      RE = -B / (2.0D0*A)
      IM = DSQRT(D) / (2.0D0*A)
      WRITE(*,*) 'Complex roots: x = ', RE, ' +/- i*', IM
      GOTO 800

  110 CONTINUE
      RT = -B / (2.0D0*A)
      WRITE(*,*) 'Repeated real root: x = ', RT
      GOTO 800

  120 CONTINUE
      D = DSQRT(DISC)
      RE = (-B + D) / (2.0D0*A)
      IM = (-B - D) / (2.0D0*A)
      WRITE(*,*) 'Real roots: x1 = ', RE, ' , x2 = ', IM
      GOTO 800

  900 CONTINUE

      IF (B) 910,920,910

  910 CONTINUE
      RT = -C / B
      WRITE(*,*) 'Linear case (a=0): x = ', RT
      GOTO 800

  920 CONTINUE
      IF (C) 930,940,930

  930 CONTINUE
      WRITE(*,*) 'No solution (a=b=0, c<>0).'
      GOTO 800

  940 CONTINUE
      WRITE(*,*) 'Infinitely many solutions (a=b=c=0).'
      GOTO 800

  800 CONTINUE
      STOP
      END
