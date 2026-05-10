-- ---------------------------------------------------------------------------
-- Name: Hanah Rocha
-- ORGN: CSUB - CMPS 3500
-- ASGT: Activity 4 "Matrix Operations in Ada"
-- DATE: 10/17/2025
-- FILE: solverfile.adb (filename must match outer procedure name)
--
-- compile only:            $ gcc -c solverfile.adb
-- compile and link:        $ gnatmake solverfile.adb
-- execute:                 $ ./solverfile
-- --------------------------------------------------------------------------

with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Strings.Fixed;       use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Float_Text_IO;       use Ada.Float_Text_IO;

procedure solverfile is

    MAX_ROW : INTEGER; -- Number of rows
    MAX_COL : INTEGER; -- Number of Columns

    --type myArray is array(positive range <>, positive range <>) of LONG_FLOAT;
    type MATRIX is array(NATURAL range <>, NATURAL range <>) of LONG_FLOAT;
    type VECTOR is array (NATURAL range <>) of LONG_FLOAT;


    A      : MATRIX (1..6, 1..6);     -- coefficient matrix
    Ainv   : MATRIX (1..6, 1..6);     -- inverse of A
    CofA   : MATRIX (1..6, 1..6);     -- cofactor(A)
    AdjA   : MATRIX (1..6, 1..6);     -- adj(A) = transpose(cofactor(A))
    b      : VECTOR (1..6);           -- RHS
    x      : VECTOR (1..6);           -- solution vector
    detA   : LONG_FLOAT;              -- det(A)

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Matrix Red and write methods
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Assigns variables to column 
    function Var_Col (C : Character) return Positive is
        L : constant Character := To_Lower (C);
    begin
        case L is
            when 'a' => return 1;
            when 'b' => return 2;
            when 'c' => return 3;
            when 'd' => return 4;
            when 'e' => return 5;
            when 'f' => return 6;
            when others =>
                raise Constraint_Error with "Unexpected variable: " & L;
        end case;
    end Var_Col;

    --Gets rid of spaces from a line
    function Strip_Spaces (S : String) return String is
        R : String (1 .. S'Length);
        K : Natural := 0;
    begin
        for i in S'Range loop
            if S (i) /= ' ' and then S (i) /= ASCII.HT then
                K := K + 1;
                R (K) := S (i);
            end if;
        end loop;
        return R (1 .. K);
    end Strip_Spaces;

    procedure Parse_Line (Line : String; Row : Positive) is
        S       : constant String := Strip_Spaces (Line);
        Eq_Pos  : constant Natural := Index (S, "=");
        i       : Positive;
        Sign    : Integer;
        Val     : Integer;
        Col     : Positive;
    begin
        if Eq_Pos = 0 then
            raise Constraint_Error with "Missing '=' in: " & Line;
        end if;

        -- Split into LHS/RHS
        declare
            LHS : constant String := S (S'First .. Eq_Pos - 1);
            RHS : constant String := S (Eq_Pos + 1 .. S'Last);
        begin
            -- zero the row
            for j in 1 .. MAX_COL loop
                A (Row, j) := 0.0;
            end loop;

            -- parse LHS terms
            i := LHS'First;
            while i <= LHS'Last loop
                -- sign
                if LHS (i) = '+' then
                    Sign := +1; i := i + 1;
                elsif LHS (i) = '-' then
                    Sign := -1; i := i + 1;
                else
                    Sign := +1;
                end if;

                -- optional coefficient
                declare
                    Start : Positive := i;
                begin
                    while i <= LHS'Last and then LHS (i) in '0' .. '9' loop
                        i := i + 1;
                    end loop;

                    if i = Start then
                        Val := 1;  -- implied 1 coefficient
                    else
                        Val := Integer'Value (LHS (Start .. i - 1));
                    end if;
                end;

                -- variable letter must follow
                if i > LHS'Last then
                    raise Constraint_Error with "Missing variable after coefficient in: " & Line;
                end if;

                Col := Var_Col (LHS (i));
                i := i + 1;

                A (Row, Col) := A (Row, Col) + Long_Float (Sign * Val);
            end loop;

            -- RHS integer value
            if RHS'Length = 0 then
                raise Constraint_Error with "Missing RHS after '=' in: " & Line;
            end if;
            b (Row) := Long_Float (Integer'Value (RHS));
        end;
    end Parse_Line;

    -- prints matrix to console (Reaed Long Float --> Prints Long Integer)
    procedure PrintMatrixLI (Input : in MATRIX) is
    begin
        Set_Output(Standard_Output);
        for Row in Integer range 1..MAX_ROW loop
            for Column in Integer range 1..MAX_COL loop
                -- ugly format due to long ints and lack of width
                Ada.Text_IO.Put(Long_Integer'Image(Long_Integer(Input(Row, Column))));
                Put(" ");
            end loop;
            New_Line;
        end loop;
    end PrintMatrixLI;

    -- Vector Printer to screen 
    procedure PrintVectorAsMatrixLI (Name : String; V : VECTOR) is
    begin
        Put_Line (Name & " =");
        for i in 1 .. MAX_ROW loop
            Put (" ");
            Put (Long_Integer'Image (Long_Integer (V (i))));
            New_Line;
        end loop;
    end PrintVectorAsMatrixLI;

    procedure PrintVectorAsMatrixF4 (Name : String; V : VECTOR) is
    begin
        Put_Line (Name & " =");
        for i in 1 .. MAX_ROW loop
            Put (" ");
            Put (Item => Float (V (i)), Aft => 4, Exp => 0);
            New_Line;
        end loop;
    end PrintVectorAsMatrixF4;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Matrix Operations
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- multiplies matrix by scalar
    function MultiplyScalar(Matrix_1 : in MATRIX; Scalar : in Long_Float) return MATRIX is
        Product : Long_Float;
        Result : MATRIX (1..6,1..6);
    begin
        for Row in Integer range 1..MAX_ROW loop
            for Column in Integer range 1..MAX_COL loop
                Product := Matrix_1(Row, Column) * Scalar;
                Result(Row, Column) := Product;
            end loop;
        end loop;
        return Result;
    end MultiplyScalar;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- multiples matrix by vector
    function MultiplyMatVec(Matrix_1 : in MATRIX; Vec : in VECTOR) return VECTOR is
        Result : VECTOR (1..MAX_ROW);
        Sum    : LONG_FLOAT;
    begin
        for Row in 1 .. MAX_ROW loop
            Sum := 0.0;
            for Column in 1 .. MAX_COL loop
                Sum := Sum + Matrix_1(Row, Column) * Vec(Column);
            end loop;
            Result(Row) := Sum;
        end loop;
        return Result;
    end MultiplyMatVec;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- transposes matrix
    function Transpose(Matrix_1 : in MATRIX) return MATRIX is
        Result : MATRIX (1..6,1..6);
    begin
        for Row in Integer range 1..MAX_ROW loop
            for Column in Integer range 1..MAX_COL loop
                Result(Row, Column) := Matrix_1(Column, Row);
            end loop;
        end loop;
        return Result;
    end Transpose;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    --Function to calculate the determinant om a matrix of Long Floats
    function Determinant(mdet: in out MATRIX; n: INTEGER) return LONG_FLOAT is
        i : INTEGER;
        aj : INTEGER;
        bj : INTEGER;
        k : LONG_FLOAT;
        d : LONG_FLOAT;
        l : LONG_FLOAT;
        sign : LONG_FLOAT;
        b : MATRIX(1..n-1, 1..n-1);

    begin
        i := 2;
        sign := 1.0;
        l := 0.0;
        k := 1.0;
        if n = 2 then
            d := (mdet(1,1) * mdet(2,2)) - (mdet(1,2) * mdet(2,1));
            return d;
        end if;

        for k in 1..n loop
            aj := 1;
            bj := 1;
            for i in 2..n loop
                bj := 1;
                for aj in 1..n loop
                    if aj = k then
                        goto endofloop;
                    end if;
                    if bj = n then
                        goto endofloop;
                    end if;
                    b(i-1, bj) := mdet(i, aj);
                    bj := bj + 1;
                    <<endofloop>>
                end loop;
            end loop;
            l := l + (sign * mdet(1, k) * Determinant(b, n-1));
            sign := sign * (-1.0);

        end loop;
        return l;
    end Determinant;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- Compute cofactor of m(i,j)
    function Cofactor(m : in MATRIX; i : in INTEGER; j : in INTEGER) return LONG_FLOAT is
        MinorMatrix : MATRIX(1..MAX_ROW-1, 1..MAX_COL-1); -- Matrix after removing row i and column j
        RowIndex    : INTEGER := 1;
        ColIndex    : INTEGER := 1;
        Det         : LONG_FLOAT;
    begin
        -- Construct the minor matrix by excluding row i and column j
        for p in 1..MAX_ROW loop
            for q in 1..MAX_COL loop
                if p /= i and q /= j then
                    MinorMatrix(RowIndex, ColIndex) := m(p, q);
                    ColIndex := ColIndex + 1;
                    if ColIndex > MAX_ROW-1 then
                        ColIndex := 1;
                        RowIndex := RowIndex + 1;
                    end if;
                end if;
            end loop;
        end loop;
        -- Compute the determinant of the minor matrix
        Det := Determinant(MinorMatrix, MAX_ROW-1);

        -- Multiply by (-1)^(i+j) to get the cofactor
        return (-1.0)**(i + j) * Det;
    end Cofactor;

    function CofactoMatrix(m: in MATRIX) return MATRIX is
        Result : MATRIX(1..MAX_ROW, 1..MAX_COL);
        CofactorMatrix : MATRIX(1..MAX_ROW, 1..MAX_COL);
    begin

        -- Compute the cofactor matrix first
        for i in 1..MAX_ROW loop
            for j in 1..MAX_COL loop
                CofactorMatrix(i, j) := Cofactor(m, i, j); 
            end loop;
        end loop;

        Result := CofactorMatrix;
        return Result;

    end CofactoMatrix;

begin

    --  This contrlos the size of the inputs matrices
    MAX_ROW := 6;
    MAX_COL := 6;

    -- zero A and b
    for i in 1 .. MAX_ROW loop
        b(i) := 0.0;
        for j in 1 .. MAX_COL loop
            A(i,j) := 0.0;
        end loop;
    end loop;

    -- Read the six equations from system1.txt
    Put_Line ("Reading system1.txt ...");
    declare
        Inf : FILE_TYPE;
        Ln  : String (1 .. 512);
        L   : Natural;
    begin
        --***************** REPLACE FILE NAME HERE FOR TESTING SIMILAR SYSTEMS OF EQUATIONS *********************
        Open (Inf, In_File, "system1.txt");
        for row in 1 .. MAX_ROW loop
            if End_Of_File (Inf) then
                raise Constraint_Error with "Expected 6 equations: file ended early.";
            end if;
            Get_Line (Inf, Ln, L);
            Parse_Line (Ln (1 .. L), row);
        end loop;
        Close (Inf);
    end;

    -- Echo
    Put_Line ("This is A * X = B");
    Put_Line ("We compute X = A^-1 * B");
    Put_Line ("A =");
    PrintMatrixLI (A);
    PrintVectorAsMatrixLI ("B", b);
    New_Line;

    -- Solve using cofactor
    Put_Line ("Operations");
    Put_Line ("**************");
    declare
        A_copy : MATRIX (1..MAX_ROW, 1..MAX_COL) := A;
    begin
        Put_Line ("det(A)");
        detA := Determinant (A_copy, MAX_ROW);
        Put (Item => Float (detA), Aft => 0, Exp => 0); New_Line;

        if detA = 0.0 then
            Put_Line ("Matrix is singular: no unique solution.");
        else
            Put_Line ("Computing A inverse, using Cofactor of A then Transposing and Multiplying");
            CofA := CofactoMatrix (A);
            AdjA := Transpose (CofA);
            Ainv := MultiplyScalar (AdjA, 1.0 / detA);

            Put_Line ("Solving: X = A^-1 * B");
            x := MultiplyMatVec (Ainv, b);

            Put_Line ("Solution (4 decimals):");
            PrintVectorAsMatrixF4 ("X", x);
        end if;
    end;

end solverfile;
