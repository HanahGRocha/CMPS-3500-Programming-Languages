C********************************************************************
C NAME: Hanah Rocha
C ASGT: Activity 2
C ORGN: CSUB - CMPS 3500
C FILE: copy of matrix.f, modified to matrixops.f
C DATE: 9/16/2025     
C********************************************************************
C This program implements matrix operations:
C    - Addition and subtraction
C    - Multiplication, dotproduct
C    - Power
C    I VERY MUCH DISLIKE THAT THIS LANGAUGE IS NOT CASE SENSITIVE :(
C ********************************************************************
C     Define variables of m1,m2,m3,v1
      INTEGER, PARAMETER :: ROW1=6, COL1=5
      INTEGER, PARAMETER :: ROW2=5, COL2=6
      INTEGER, PARAMETER :: ROW3=5, COL3=5
      INTEGER, PARAMETER :: VECLEN=5 
C     Matrices and vector        
      REAL m1(ROW1,COL1), m2(ROW2,COL2), m3(ROW3,COL3) 
      REAL v1(VECLEN)
C     Store results      
      REAL prod1(ROW1, COL2), prod2(ROW2,COL1), prod3(ROW1,COL1)
      REAL transp1(ROW1,COL1), transp2(COL2,ROW1), transp3(COL2,ROW1)  
      REAL pwm12(ROW3,COL3), pwm13(ROW3,COL3), pwm14(ROW3,COL3) 
      REAL pwm15(ROW3,COL3), pwm110(ROW3,COL3), pwm115(ROW3,COL3)
      REAL pwm120(ROW3,COL3)
C     Counters and loop 
      INTEGER SIZE1, SIZE2, SIZE3, SIZE4, I
C     Temp storage
      REAL, ALLOCATABLE :: mtemp1(:), mtemp2(:), mtemp3(:), vtemp(:)

C     ****************************************
C     Reading m1.in 6*5
C     ****************************************
      OPEN(1,FILE='m1.in',ERR=2002)
      SIZE1=0 
C     Getting size of matrix in file
  10  READ(1,*,END=20) 
      SIZE1 = SIZE1 + 1
      GO TO 10

C     if empty exit file
  20  CONTINUE
      IF(SIZE1.NE.ROW1*COL1) THEN
          PRINT *, 'ERROR: m1.in must have ', ROW1*COL1, ' got ',SIZE1
          STOP
      ENDIF

C     Reposition array to beginning
      REWIND(1)

C     Allocating size of new matrix
      ALLOCATE (mtemp1(1:SIZE1))

C   Set values of A and B
      DO I=1,SIZE1
        READ(1,*) mtemp1(I)
      END DO
      CLOSE(1)

C     Reshape function from a 1D to 2D array         
      m1 = RESHAPE(mtemp1,(/ROW1, COL1/))
      DEALLOCATE(mtemp1)

C     ****************************************
C     Reading m2.in 5*6
C     ****************************************
      OPEN(2,FILE='m2.in',ERR=2003)
      SIZE2=0 

C     Getting size of matrix in file
  40  READ(2,*,END=50) 
      SIZE2 = SIZE2 + 1
      GO TO 40

C     if empty exit file
  50  CONTINUE
      IF(SIZE2.NE.ROW2*COL2) THEN
          PRINT *, 'ERROR: m2.in must have ', ROW2*COL2,' got ',SIZE2
          STOP
      ENDIF

C     Reposition array to beginning
      REWIND(2)

C     Allocating size of new matrix
      ALLOCATE (mtemp2(1:SIZE2))

C   Set values of A and B
      DO I=1,SIZE2
        READ(2,*) mtemp2(I)
      END DO
      CLOSE(2)

C     Reshape function from a 1D to 2D array         
      m2 = RESHAPE(mtemp2,(/ROW2, COL2/))
      DEALLOCATE(mtemp2)

C     ****************************************
C     Reading m3.in (5x5)
C     ****************************************
      OPEN(3, FILE='m3.in', ERR=2004)
      SIZE3 = 0
 70   READ(3,*,END=80)
      SIZE3 = SIZE3 + 1
      GO TO 70

 80   CONTINUE
      IF (SIZE3.NE.ROW3*COL3) THEN
         PRINT *, 'ERROR: m3.in must have ', ROW3*COL3, ' got ', SIZE3
         STOP
      ENDIF

      REWIND(3)
      ALLOCATE (mtemp3(SIZE3))
      DO I = 1, SIZE3
        READ(3,*) mtemp3(I)
      END DO
      CLOSE(3)

      m3 = RESHAPE(mtemp3, (/ROW3, COL3/))
      DEALLOCATE(mtemp3)

C     ****************************************
C     Reading v1.in 5*1
C     ****************************************
      OPEN(4,FILE='v1.in',ERR=2005)
      SIZE4=0 

C     Getting size of matrix in file
  90  READ(4,*,END=100) 
      SIZE4 = SIZE4 + 1
      GO TO 90

C     if empty exit file
 100  CONTINUE
      IF(SIZE4.NE.VECLEN) THEN
          PRINT *, 'ERROR: v1.in must have ', VECLEN , ' got ', SIZE4
          STOP
      ENDIF

C     Reposition array to beginning
      REWIND(4)

C     Allocating size of new matrix
      ALLOCATE (vtemp(1:SIZE4))

C   Set values of A and B
      DO I=1,SIZE4
        READ(4,*) vtemp(I)
      END DO
      CLOSE(4)

      v1 = vtemp
      DEALLOCATE(vtemp)

C     ****************************************
C     Performing Operations
C     ****************************************
C     Doing m1 * m2 ------  (6*5) * (5*6) = 6x6      
      prod1 = MATMUL(m1,m2) 

C     Doing m2 * m1 ------  (5*6) * (6*5) = 5x5      
      prod2 = MATMUL(m2,m1) 

C     Doing m3 * m1 ------  (5*5) * (6*5) = invalid      

C     Doing m1 * m3 + m1 ------ (6*5)(5*5)+(6*5) = 6x5
      prod3 = MATMUL(m1, m3) + m1      

C     Doing m3*m2+m2*m1+m3 = (5*6) * (6*5) + 5x5 = invalid     

C     transp1 = transpose(transpose(m1)) = 6x5
      transp1 = TRANSPOSE(TRANSPOSE(m1)) 
C     Lucky me to have an Intrinsic Function

C     transp2 = transpose(m1 * m2) = 6x6  
      transp2 = TRANSPOSE(prod1)      

C     transp3 = transpose(m2) * transpose(m1) = 6x6
      transp3 = MATMUL(TRANSPOSE(m2), TRANSPOSE(m1)) 

C     Powers      
      pwm12  = power(m3,2)
      pwm13  = power(m3,3)
      pwm14  = power(m3,4)
      pwm15  = power(m3,5)
      pwm110 = power(m3,10)
      pwm115 = power(m3,15)
      pwm120 = power(m3,20)  

C     ****************************************
C     Writing Outputs - gave up trying to do WRITE and PRINT some lines
C     Hurts my pinkie to hold shift, I HATE THE CASE INSENSITIVITY
C     ****************************************

C     Printing outputs
      print *
      write(*,*) 'Program to show some matrix and vector operations'
      write(*,*) '*************************************************'
      print *
      
      write(*,*) ' m1 = '
      DO I = 1, ROW1
        WRITE(*, 2000) (m1(I,J), J=1,COL1)
      END DO
      PRINT * 
     
      write(*,*) ' m2 = '
      DO I = 1, ROW2
        WRITE(*, 2000) (m2(I,J), J=1,COL2)
      END DO
      PRINT *

      write(*,*) ' m3 = '
      DO I = 1, ROW3
        WRITE(*, 2000) (m3(I,J), J=1,COL3)
      END DO
      PRINT * 
    
      write(*,*) ' v1 = '
      write(*, 2001) v1
      print *

      write(*,*) ' prod1 = m1 * m2 = '
      DO I = 1, ROW1
        WRITE(*,2000) (prod1(I,J), J=1,COL2)
      END DO
      PRINT *

      write(*,*) ' prod2 = m2 * m1 = '
      DO I = 1, ROW2
        WRITE(*,2000) (prod2(I,J), J=1,COL1)
      END DO
      PRINT *

      write(*,*) ' prod3 = m3 * m1 = '
      write(*,*) '   invalid dimensions '
      PRINT *

      write(*,*) ' prod3 = m1 * m3 + m1 = '
      DO I = 1, ROW1
        WRITE(*,2000) (prod3(I,J), J=1,COL1)
      END DO
      PRINT *

      write(*,*) ' prod4 = m3 * m2 + m2 * m1 + m3 = '
      write(*,*) '   invalid dimensions'
      PRINT *

      write(*,*) ' transp1 = transpose(transpose(m1))'
      DO I = 1, ROW1
        WRITE(*,2000) (transp1(I,J), J=1,COL1)
      END DO
      PRINT *

       write(*,*) ' transp2 = transpose(m1 * m2)'
      DO I = 1, ROW1
        WRITE(*,2000) (transp2(I,J), J=1,ROW1)
      END DO
      PRINT *

      write(*,*) ' transp3 = transpose(m2) * transpose(m1)'
      DO I = 1, COL2
        WRITE(*,2000) (transp3(I,J), J=1,ROW1)
      END DO
      PRINT *

      write(*,*) ' pwm12 = power(m3,2)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm12(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) ' pwm13 = power(m3,3)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm13(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) ' pwm14 = power(m3,4)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm14(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) ' pwm15 = power(m3,5)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm15(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) ' pwm110 = power(m3,10)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm110(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) ' pwm115 = power(m3,15)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm115(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) ' pwm120 = power(m3,20)'
      DO I=1,ROW3
        WRITE(*,2006) (pwm120(I,J), J=1,COL3)
      END DO
      PRINT *

      write(*,*) '  Good bye!'

C     Format output arrays
C     Format output for 4x4 array
 2000 format(4x,100(f8.1))

C    Format output for 4x1 array
 2001 format ((5x,f8.1))
      stop

C     Erroring out of the file cannot be open or empty
 2002 PRINT *,' Empty or missing input file: m1.in'
      STOP
C     Erroring out of the file cannot be open or empty
 2003 PRINT *,' Empty or missing input file: m2.in'
      STOP
C     Erroring out of the file cannot be open or empty
 2004 PRINT *,' Empty or missing input file: m3.in'
      STOP
C     Erroring out of the file cannot be open or empty
 2005 PRINT *,' Empty or missing input file: v1.in'
      STOP
C     Format for powers matrix results, got big numbers
 2006 format(4x,100(f14.1))
      stop

      CONTAINS

C     ****************************************
C     Function: power
C     Calc power of m3 = 5x5 w/ repeated MATMUL
C     ****************************************
      FUNCTION power(A, n) RESULT(P)
        IMPLICIT NONE
        REAL,    INTENT(IN) :: A(5,5)
        INTEGER, INTENT(IN) :: n
        REAL :: P(5,5)
        INTEGER :: i

C     Handle n = 0 
        IF (n.EQ.0) THEN
           P = 0.0
           DO i=1,5
             P(i,i) = 1.0
           END DO
           RETURN
        END IF

C     Initialize P with A
        P = A

C     Multiply A into result (n-1) more times
        DO i = 2, n
           P = MATMUL(P, A)
        END DO
      END FUNCTION power
      END

