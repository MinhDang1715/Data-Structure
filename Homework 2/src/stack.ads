generic 
   --memory size
   min, max: Integer;
   --number of stacks
   num : Integer;
   --stacks total memory location
   stackMin, stackMax : Integer;
   type item is private;
   
package stack is  
   procedure allocateStack;
   procedure push(x: In item; y: In Integer);
   procedure pop(x: Out item; y: In Integer);
   procedure repack(k: In Integer);
   procedure moveStack;
   procedure printStack(x: Out item; i: In Integer);
   
   function returnBase(x: In Integer) return Integer;
   function returnTop(x: In Integer) return Integer;
   function isOverflow return Boolean;  
   function isEmpty return Boolean;  
   function returnOverflowtItem return item;
end stack;
