with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Unchecked_Conversion;
with stack;

procedure Main is
   Input, Output: File_Type;
   inputName: String (1..5);
   outputName: String (1..9);
   --new line when output to file
   CR : constant Character := Character'Val(10);

   --element in the stack
   element: Character;

   --define stack for the set
   subtype Set is Character;
   package string_stack is new stack(100, Set);
   use string_stack;

   --counter for the number of lines in the input file
   BMR_row: Integer := 0;

   --header for the BMR
   type header_A is(Ada, Bob, Koe, Ken, Sam, Sue, Tim, Tom, Jim);
   type header_B is('1', '2', '3', '4', '5', '6', '7');
   type header_C is(A, B, C, D, J, K, L);

   --converse char to int
   function charToInt is new Unchecked_Conversion(Character,Integer);

   --overload "or" fuction
   function orInt(x, y: Integer) return Integer is
   begin
      --1 or 0
      if(x + y = 96) then
         return 48;
      --1 or 1
      else
         return 49;
      end if;
   end orInt;

   function orBool(x, y: Integer) return Integer is
   begin
      --T or F
      if(x + y = 140) then
         return 70;
      --T or T
      else
         return 84;
      end if;
   end orBool;

begin
   --process all files
   for g in 1..4 loop
      if g = 1 then
         inputName := "A.txt";
         outputName := "TestA.txt";
      elsif g = 2 then
         inputName := "B.txt";
         outputName := "TestB.txt";
      elsif g = 3 then
         inputName := "C.txt";
         outputName := "TestC.txt";
      else
         inputName := "D.txt";
         outputName := "TestD.txt";
      end if;

      --reading the file
      Open(File => Input, Mode => In_File, Name => inputName);
      Create(File => Output, Mode => Out_File, Name => outputName);

      --count the number of line to create a 2D array
      while not End_Of_File(Input) loop
         declare
            Line: String := Get_Line(Input);
         begin
            BMR_row := BMR_row + 1;
            for i in 1..Line'Length loop
               --push the character to the stack
               push(Line(i));
            end loop;
         end;
      end loop;

      --create an array according to the number of the line in the file
      declare
         --array to store the BMR
         type BMR is array (Positive range<>, Positive range<>) of Character;
         arr : BMR (1..BMR_row, 1..BMR_row);
         --for populate the array
         row, column : Integer := BMR_row;
         --for print out
         i : Integer := 1;
      begin
         --poplulate the array with the elements in the stack
         while row > 0 loop
            while column > 0 loop
               pop(element);
               arr(row,column):= element;
               column := column - 1;
            end loop;
            row := row - 1;
            --reset y to do the loop
            column := BMR_row;
         end loop;

         --Warshall
         for i in 1..BMR_row loop
            for j in 1..BMR_row loop
               --int = 49 = 1
               --bool = 84 = T
               --determint to use orInt or orBool
               if charToInt(arr(j, i)) = 49 then
                  for k in 1..BMR_row loop
                     arr(j,k) := Character'Val(orInt(charToInt(arr(j,k)), charToInt(arr(i,k))));
                  end loop;
               elsif charToInt(arr(j, i)) = 84 then
                  for k in 1..BMR_row loop
                     arr(j,k) := Character'Val(orBool(charToInt(arr(j,k)), charToInt(arr(i,k))));
                  end loop;
               end if;
            end loop;
         end loop;

         --print out to the file with their corresponding header
         if g = 1 then
            Put(Output, "      ");
            for x in header_A'Range loop
               Put(Output, header_A'Image(x));
               Put(Output, "      ");
            end loop;
            Put(Output, CR);
            --BMR
            for x in header_A'Range loop
               Put(Output, header_A'Image(x));
               Put(Output, "   ");
               for t in 1..BMR_row loop
                  Put(Output, arr(i,t));
                  Put(Output, "        ");
               end loop;
               Put(Output, CR);
               i := i + 1;
            end loop;
            Close(Input);
            Close(Output);
         elsif g = 2 then
            Put(Output, "      ");
            for x in header_B'Range loop
               Put(Output, header_B'Image(x));
               Put(Output, "      ");
            end loop;
            Put(Output, CR);
            --BMR
            for x in header_B'Range loop
               Put(Output, header_B'Image(x));
               Put(Output, "   ");
               for t in 1..BMR_row loop
                  Put(Output, arr(i,t));
                  Put(Output, "        ");
               end loop;
               Put(Output, CR);
               i := i + 1;
            end loop;
            Close(Input);
            Close(Output);
         else
            Put(Output, "    ");
            for x in header_C'Range loop
               Put(Output, header_C'Image(x));
               Put(Output, "     ");
            end loop;
            Put(Output, CR);
            --BMR
            for x in header_C'Range loop
               Put(Output, header_C'Image(x));
               Put(Output, "   ");
               for t in 1..BMR_row loop
                  Put(Output, arr(i,t));
                  Put(Output, "     ");
               end loop;
               Put(Output, CR);
               i := i + 1;
            end loop;
            Close(Input);
            Close(Output);
         end if;
      end;
      --reset to 0 and start process the next file
      BMR_row := 0;

   end loop;
--handle file exception the file is not closed
exception
   when End_Error =>
      if Is_Open(Input) then
         Close(Input);
      end if;
      if Is_Open(Output) then
         Close(Output);
      end if;
end Main;
