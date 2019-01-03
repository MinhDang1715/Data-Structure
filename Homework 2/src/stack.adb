--implementation of stack using Dr.Burris note
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body stack is  
   --limt storage for the stack
   stack : array(min..max) of item;

   --overflow variable
   checkOverflow, checkEmpty: Boolean := False;
   overflowItem : item;

   --stacks top and base
   base: array(1..num + 1) of Integer;
   top: array(1..num) of Integer;
   oneArray: array(1..num + 1) of Integer;
   
   --lets start by giving each stack equal amount of space
   stackSize : Integer := stackMax - stackMin + 1;
   --total stack space / number of stack
   space : Integer := stackSize / num;
   baseFirst: Integer := stackMin;
   baseLast: Integer := stackMax;
   
   --repack vars
   totalGrowth : Integer := 0;
   j: Integer;
   availSpace : Integer;
   --assume equalAllocate to 10%
   equalAllocate: Float := 0.2;
   growthAllocate: Float := 1.0 - equalAllocate;
   alpha, beta, tau, sigma : Float;
   deltaVar: Integer;

   --locate stacks for the first time
   procedure allocateStack is
   begin
      if space < 1 then
         raise Constraint_Error with "The memory space is too small to hold all the stacks";
      else
         --set up the base
         for i in 1..num + 1 loop
            if i /= num + 1 then
               base(i) := baseFirst;
               baseFirst := baseFirst + space;
            else
               base(i) := baseLast;
            end if;
         end loop;
         
         --set up the top
         for i in 1..num loop
            --if the array has negative bound then + 1 instead of -1
            top(i) := base(i);
         end loop;
         
         --1 array for oldTop, newBase and growth
         for i in 1..num + 1 loop
            oneArray(i) := base(i);
         end loop;
      end if;
   end AllocateStack;
   
   --push x to stack y
   procedure push(x: In item; y: In Integer) is 
   begin
      --inc top of the respective stack by 1
      top(y) := top(y) + 1;
      if top(y) > base(y + 1) then    
         Put("Overflow. Repacking...");
         New_Line;         
         
         checkOverflow := True;
         
         --save the overflow item
         overflowItem := x;        
                 
         Put("Base: ");
         for i in 1..num + 1 loop
            Put(base(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         Put("Top: ");
         for i in 1..num loop   
            Put(top(i), 0);
            Put(" ");
         end loop;
         New_Line;

         Put("One Array: ");
         for i in 1..num + 1 loop
            Put(oneArray(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         --repack the array to check for empty space and reallocate the stacks
         repack(y);
      else
         stack(top(y)) := x;
         
         --print out current Base and Top
         Put("Base: ");
         for i in 1..num + 1 loop
            Put(base(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         Put("Top: ");
         for i in 1..num loop   
            Put(top(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         Put("oneArray: ");
         for i in 1..num loop   
            Put(oneArray(i), 0);
            Put(" ");
         end loop;
         New_Line;
      end if;
   end push;
   
   --pop x at stack y
   procedure pop(x: OUT item; y: IN Integer) is 
   begin
      if top(y) = base(y) then
         checkEmpty := True;
      else
         x := stack(top(y));
         top(y) := top(y) - 1;
         
         --print out current Base and Top
         Put("Base: ");
         for i in 1..num + 1 loop
            Put(base(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         Put("Top: ");
         for i in 1..num loop   
            Put(top(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         Put("oneArray: ");
         for i in 1..num loop   
            Put(oneArray(i), 0);
            Put(" ");
         end loop;
         New_Line;
      end if;
   end pop;
   
   --repack the stack when overflow oocur
   --implemet by using Dr. Burris' note
   procedure repack(k: in Integer) is
   begin
      --find out if there is still some memory left also update the 
      --growth rate and growth
      availSpace := base(num + 1) - base(1);
      
      j := num;
      while j > 0 loop
         availSpace := availSpace - (top(j) - base(j));  
         if top(j) > oneArray(j) then
            oneArray(j) := top(j) - oneArray(j);
            totalGrowth := totalGrowth + oneArray(j);
         else
            oneArray(j) := 0;
         end if;
         j := j - 1;
      end loop;

      if availSpace < 0 then
         put("There are no memory left!!!");
         New_Line;
      else      
         --calculate alpha and beta
         alpha := equalAllocate * Float(availSpace) / Float(num);
         
         beta := growthAllocate * Float(availSpace) / Float(totalGrowth);
         
         --set oneArray(num + 1) to base 1
         --so we can swap them out and still have the growth of each stack before 
         --we calculate the new growth
         oneArray(num + 1) := base(1);
         sigma := 0.0;
         for j in 2..num loop
            tau:= sigma + alpha + Float(oneArray(j - 1)) * beta;
            
            --swap the first element in oneArray with it last element
            oneArray(j - 1) := oneArray(num + 1);
            
            if j /= num then
               --we store the new calculated base at the last element of the array
               oneArray(num + 1) := oneArray(j - 1) + top(j -1) - base(j - 1) + Integer(Float'Floor(tau)) - Integer(Float'Floor(sigma));
            else
               oneArray(j) := oneArray(j - 1) + top(j -1) - base(j - 1) + Integer(Float'Floor(tau)) - Integer(Float'Floor(sigma));
            end if;
            
            sigma := tau; 
         end loop;

         --move stack
         top(k) := top(k) - 1;
         moveStack;
         top(k) := top(k) + 1;
         --insert the item causing the overflow at top[K]
         stack(top(k)) := overflowItem;
              
         Put("New Base: ");
         for i in 1..num + 1 loop
            Put(base(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         Put("New Top: ");
         for i in 1..num loop   
            Put(top(i), 0);
            Put(" ");
         end loop;
         New_Line;
         
         --set up one array for the new overflow
         for i in 1..num loop   
            oneArray(i) := top(i);
         end loop;
      end if;
   end repack;
   
   procedure moveStack is
   begin
      --move all stacks down
      for j in 2..num loop
         if oneArray(j) < base(j) then
            deltaVar := base(j) - oneArray(j);
            for l in base(j) + 1..top(j) loop
               stack(l - deltaVar) := stack(l);
            end loop;
            base(j) := oneArray(j);
            top(j) := top(j) - deltaVar;
         end if;
      end loop;

      --move all stacks up
      for j in reverse 2..num loop
         if oneArray(j) > base(j) then
            deltaVar := oneArray(j) - base(j);
            for l in reverse base(j) + 1..top(j) loop
               stack(l + deltaVar) := stack(l);
            end loop;
            base(j) := oneArray(j);
            top(j) := top(j) + deltaVar;
         end if;         
      end loop;
   end moveStack;
   
   procedure printStack(x: out Item; i: In Integer) is
   begin
         x:= stack(i);
   end printStack;

   function returnBase(x: In Integer) return Integer is
   begin
      return base(x);
   end returnBase;
   
   function returnTop(x: In Integer) return Integer is
   begin
      return top(x);
   end returnTop;
   
   function isOverflow return Boolean is
   begin
      return checkOverflow;
   end isOverflow;
   
   function returnOverflowtItem return item is 
   begin
      return overflowItem;
   end returnOverflowtItem;
   
   function isEmpty return Boolean is 
   begin
      return checkEmpty;
   end isEmpty;
end stack;
