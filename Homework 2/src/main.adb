with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with stack;

procedure Main is
   --size of the of the memory
   lower, upper, j : Integer;

   --total number of stack and the size of the total memory the stacks we can use
   stackNum, lowerStack, upperStack: Integer;

begin
   --get the total size of the memory
   Mem_size_loop:
   loop
      put("Please enter the lower bound of the array: ");
      get(lower);
      put("Please enter the upper bound of the array: ");
      get(upper);
      if upper < lower then
         put("Upper bound cannot be smaller than lower bound!");
         New_Line;
      end if;
      exit Mem_size_loop when upper > lower;
   end loop Mem_size_loop;
   New_Line;

   --get the total stack size
   put("Please enter the number of stack: ");
   get(stackNum);
   New_Line;

   --make sure the stack is inside the bounded array
   Stack_constraint_loop:
   loop
      put("Please enter the lower bound of the stacks: ");
      get(lowerStack);
      put("Please enter the upper bound of the stacks: ");
      get(upperStack);
      if lowerStack < lower or upperStack > upper then
         put("Stacks size must be within the bounded array!");
         New_Line;
      elsif upperStack < lowerStack then
         put("Upper bound is less than Lower bound!");
         New_Line;
      end if;
      exit Stack_constraint_loop when lowerStack >= lower and upperStack <= upper and lowerStack < upperStack;
   end loop Stack_constraint_loop;
   New_Line;

   --allocate the stacks in side the array
   put("Setting up the stack...");
   New_Line;
   declare
      opCode : Character;
      arrayNum : Integer;

      answer: Character;
      continue: Boolean := True;

      --A data
      type MonthName is (January, February, March, April, May, June, July, August, September, October, November, December);
      type Data is record
         Month:	MonthName;
         Day:	Integer range 1..31;
         Year:	Integer range 1400..2020;
      end record;

      package enumIO is new Ada.Text_IO.Enumeration_IO(MonthName);
      use enumIO;

      --B/C data
      type NameRange is (Joe, Bob, Devin, Elwin, ISagar, Ryan, Kyle, Tyler, Minh, Adrian, Daniel, Jailene, Jacob, Bryce,
                    Jaylene, Sagar, Ayran, Travis, Rahul, Victor, Corey, Bipin, Frank, Nathan, Amber, Amy);

      type Name is record
         x: NameRange;
      end record;

      package NameIO is new Ada.Text_IO.Enumeration_IO(NameRange);
      use NameIO;

      package seq_stack is new stack(lower, upper, stackNum, lowerStack, upperStack, Data);
      use seq_stack;

      --input output for the array
      stackInput: Data;
      nameInput: Name;

   begin
      --allocate the stacks equally the 1st time
      allocateStack;

      --print out the intital value of L(0) and M the stacks
      put("L(0) = ");
      put(returnBase(1), 0);
      New_Line;

      put("M = ");
      put(returnBase(stackNum + 1), 0);
      New_Line;

      --start processing all the data
      Working_loop:
      loop
         --I: push D: pop
         Check_opCode_loop:
         loop
            put("Enter op code: ");
            get(opCode);
            if opCode /= 'I' and opCode /= 'D' and opCode /= 'i' and opCode /= 'd' then
               put("Wrong Op Code");
               New_Line;
            end if;
            exit Check_opCode_loop when opCode = 'I' or opCode = 'D' or opCode = 'i' or opCode = 'd';
         end loop Check_opCode_loop;

         Check_num_array:
         loop
            put("Enter array: ");
            get(arrayNum);
            if arrayNum > stackNum then
               put("Wrong Array Num");
               New_Line;
            end if;
            exit Check_num_array when arrayNum <= stackNum;
         end loop Check_num_array;

         if opCode = 'I' or opCode = 'i' then

            --A option
            put("Enter Month: ");
            get(stackInput.Month);
            put("Enter Day: ");
            get(stackInput.Day);
            put("Enter Year: ");
            get(stackInput.Year);

            --B/C option
            --put("Enter Name: ");
            --get(nameInput.x);

            --notify the user the push
            New_Line;
            put("Pushing ");
            --A option
            put(stackInput.Month, 0);
            put(" ");
            put(stackInput.Day, 0);
            put(" ");
            put(stackInput.Year, 0);

            --B option
            --put(nameInput.x);

            put(" to stack ");
            put(arrayNum, 0);

            New_Line;

            --push
            --A option
            push(stackInput, arrayNum);

            --B/C option
            --push(nameInput, arrayNum);

            New_Line;

            j := lower;
            <<printOutLoop>>
            while(j <= upper) loop
               begin
                  --A option
                  printStack(stackInput, j);

                  --B/C option
                  --printStack(nameInput, j);

                  j := j + 1;

                  --A option
                  put(stackInput.Month, 0);
                  put(", ");
                  put(stackInput.Day, 0);
                  put(" ");
                  put(stackInput.Year, 0);
                  put(", ");

                  --B/C option
                  --put(nameInput.x);
                  --put(", ");

               exception
                  when Constraint_Error =>
                     --A option
                     put("Empty ");
                     put("Empty ");
                     put("Empty, ");

                     --B/C option
                     --put("Empty, ");

                     goto printOutLoop;
               end;
            end loop;
            New_Line;
            New_Line;
         else
            --pop
            --A option
            pop(stackInput, arrayNum);

            --B/C option
            --pop(nameInput, arrayNum);

            --notify the user the pop
            New_Line;
            if isEmpty then
               put("The stack is empty");
               New_Line;
            else
               put("Popping ");

               --A option
               put(stackInput.Month, 0);
               put(" ");
               put(stackInput.Day, 0);
               put(" ");
               put(stackInput.Year, 0);

               --B/C option
               --put(nameInput.x);

               put(" from stack ");
               put(arrayNum, 0);
               New_Line;

               j := lower;
               <<printOutLoop2>>
               while(j <= upper) loop
                  begin
                     --A option
                     printStack(stackInput, j);

                     --B/C option
                     --printStack(nameInput, j);

                     j := j + 1;

                     --A option
                     put(stackInput.Month, 0);
                     put(", ");
                     put(stackInput.Day, 0);
                     put(" ");
                     put(stackInput.Year, 0);
                     put(", ");

                     --B/C option
                     --put(nameInput.x);
                     --put(", ");

                  exception
                     when Constraint_Error =>
                     --A option
                     put("Empty ");
                     put("Empty ");
                     put("Empty, ");

                     --B/C option
                     --put("Empty, ");
                     goto printOutLoop2;
                  end;
               end loop;
               New_Line;
            end if;
         end if;
         --ask the user if want to continue the program
         put("Continue?(Y or N) ");
         get(answer);
         if answer = 'N' or answer = 'n' then
            continue := false;
         end if;
         exit Working_loop when continue = false;
      end loop Working_loop;
   end;
end Main;
