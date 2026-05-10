-- ---------------------------------------------------------------------------
-- Name: Hanah Rocha
-- ORGN: CSUB - CMPS 3500
-- ASGT: Activity 4 "Matrix Operations in Ada"
-- DATE: 10/17/2025
-- FILE: detpattern.adb (filename must match outer procedure name)
--
-- compile only:            $ gcc -c detpattern.adb
-- compile and link:        $ gnatmake detpattern.adb
-- execute:                 $ ./detpattern
-- --------------------------------------------------------------------------

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;

procedure detpattern is
    -- Copied from solverfile:
    type MATRIX is array (NATURAL range <>, NATURAL range <>) of LONG_FLOAT;

    -- Copied from solverfile:
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
        i := 2; sign := 1.0; l := 0.0; k := 1.0;
        if n = 2 then
            d := (mdet(1,1) * mdet(2,2)) - (mdet(1,2) * mdet(2,1));
            return d;
        end if;

        for k in 1..n loop
            aj := 1; bj := 1;
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

    -- Formating 
    procedure Indent (S : String) is
    begin
        Put_Line ("    " & S);  -- 4 spaces
    end Indent;

    procedure Print_Matrix_3x3 (M : MATRIX) is
    begin
        for r in 1 .. 3 loop
            Put ("    "); -- indent
            for c in 1 .. 3 loop
                Put (Integer (Long_Integer (M (r, c))), Width => 2);
                if c < 3 then
                    Put (' ');
                end if;
            end loop;
            New_Line;
        end loop;
    end Print_Matrix_3x3;

    type Triple is record a, b, c : Integer; 
    end record;
    Tests : constant array (1 .. 6) of Triple :=
        ( (a => -2, b => -2, c =>  1),
          (a => -2, b => -2, c =>  2),
          (a => -2, b =>  2, c =>  1),
          (a =>  0, b =>  0, c =>  0),   
          (a =>  3, b => -1, c =>  2), 
          (a =>  5, b =>  0, c => -2) );

-- 3 X 3 builder
    M  : MATRIX (1..3, 1..3);
    d  : LONG_FLOAT;
begin
    New_Line;
    for run in Tests'Range loop
        declare
            a : constant Integer := Tests(run).a;
            b : constant Integer := Tests(run).b;
            c : constant Integer := Tests(run).c;
            Mcopy : MATRIX (1 .. 3, 1 .. 3);
        begin
            Indent ("Run " & Integer'Image (run) & ":");
            Indent ("---------------------");
            Indent ("a: " & Integer'Image(a)
            & " , b: " & Integer'Image(b)
            & " , c: " & Integer'Image(c));
            New_Line;

            -- Fill M from a,b,c:
            M(1,1) := Long_Float (a - b - c);  
            M(1,2) := Long_Float (2*b);  
            M(1,3) := Long_Float (2*c);

            M(2,1) := Long_Float (2*a);         
            M(2,2) := Long_Float (b - c - a); 
            M(2,3) := Long_Float (2*c);

            M(3,1) := Long_Float (2*a);         
            M(3,2) := Long_Float (2*b);  
            M(3,3) := Long_Float (c - a - b);

            Indent ("Matrix:");
            Print_Matrix_3x3 (M);
            New_Line;
            Mcopy := M;
            D := Determinant (Mcopy, 3);

            Indent ("Determinant:");
            Put ("    ");  Put (Item => Float (D), Aft => 4, Exp => 0);  New_Line;
            New_Line;
        end;
    end loop;

end detpattern;

