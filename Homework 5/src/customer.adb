with tree;
with Ada.Text_IO; use Ada.Text_IO;

package body customer is
   function getName(x: in customerRecord) return string10 is
   begin
      return x.Name;
   end getName;

   function getPhoneNumber(x: in customerRecord) return string10 is
   begin
      return x.PhoneNumber;
   end getPhoneNumber;

   procedure printString10(x: string10) is
   begin
      for i in 1..10 loop
         put(x(i));
      end loop;
   end printString10;
 end customer;
