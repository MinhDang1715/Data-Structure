--implementation of stack using Dr.Burris note as guidance
package body stack is
   --limit storage for the stack
   stack: array(1..max) of item;
   top: Integer range 0..max := 0;

   procedure push(x: IN item) is
   begin
      if top >= max then
         raise Constraint_Error with "The stack is full";
      else
         top := top + 1;
         stack(top) := x;
      end if;
   end push;

   procedure pop(x: OUT item) is
   begin
      if top = 0 then
       raise Constraint_Error with "The stack is empty";
      else
         x := stack(top);
         top := top - 1;
      end if;
   end pop;

   function returnTop return Integer is
   begin
      return top;
   end returnTop;
end stack;
