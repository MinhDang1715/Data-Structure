with tree;
package customer is
   type string10 is new String(1..10);
   type customerRecord is new tree.node with record
      Name:  string10;
      PhoneNumber: string10;
   end record;

   procedure printString10(x: in string10);

   function getName(x: in customerRecord) return string10;
   function getPhoneNumber(x: in customerRecord) return string10;
end customer;
