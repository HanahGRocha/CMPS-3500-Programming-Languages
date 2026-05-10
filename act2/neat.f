C ********************************************************************
C NAME: Hanah Rocha
C ASGT: Activity 2
C ORGN: CSUB - CMPS 3500
C FILE: copy of spaghetti.f, modified to neat.f
C DATE: 9/23/2025
C ********************************************************************
C   This code will perform:
C      - Computation for the quadratic equation
C      - Add, subtraction, and squaring
C ********************************************************************
      PROGRAM QUADNEAT
      DOUBLE PRECISION aCoeff,bCoeff,cCoeff,sqrtDisc
      DOUBLE PRECISION realRoot,realPart,imagPart,discriminant
C     INTEGER J Not needed for neat

      WRITE(*,*) 'Enter a, b, c:'
      READ(*,*) aCoeff, bCoeff, cCoeff
C     If a = 0 case
      IF(aCoeff .EQ. 0.0D0) THEN
C         If b = 0 case
          IF(bCoeff .EQ. 0.0D0) THEN
C             If c = 0 case
              IF(cCoeff .EQ. 0.0D0) THEN
                 write(*,*) 'Infinite Solutions as a=b=c=0'
              ELSE
                 write(*,*) 'No solution'
              END IF
          ELSE
            realRoot = -cCoeff / bCoeff
            write(*,*) 'Linear case for a=0, x = ', realRoot
          END IF
      ELSE
C     Discriminant
        discriminant = bCoeff*bCoeff - 4.0D0*aCoeff*cCoeff 
        
        IF (DISC .GT. 0.0D0) THEN
C       Two distinct real roots
            sqrtDisc = DSQRT(discriminant)
            realPart = (-bCoeff + sqrtDisc) / (2.0D0*aCoeff)
            imagPart = (-bCoeff - sqrtDisc) / (2.0D0*aCoeff)
            write(*,*) 'Real roots: x1 = ', realPart,' , x2 = ',imagPart

C       One distinct real root        
        ELSEIF (discriminant .EQ. 0.0D0) THEN
             realRoot = -bCoeff / (2.0D0*aCoeff)
             write(*,*) 'Repeated real root: x = ', realRoot
        ELSE
C       Complex roots
            sqrtDisc = DSQRT(-discriminant)
            realPart = -bCoeff / (2.0D0*aCoeff)
            imagPart = sqrtDisc / (2.0D0*aCoeff)
       WRITE(*,*) 'Complex roots: x = ', realPart,' +/- i*', imagPart
         END IF
      END IF

      END PROGRAM QUADNEAT
