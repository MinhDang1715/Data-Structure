--implementation of stack using Dr.Burris note as guidance
generic
   --stack size
   max: Integer;
   type item is private;
package stack is
   procedure push(x: In item);
   procedure pop(x: Out item);

   function returnTop return Integer;
end stack;
