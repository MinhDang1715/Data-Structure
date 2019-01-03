with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with list;

package body car is
   procedure setDoorNum(x: in out carRecord; y: in Integer) is
   begin
      x.numDoor := y;
   end setDoorNum;

   procedure setManu(x: in out carRecord; y: in string5) is
   begin
      x.Manufacturer := y;
   end setManu;

   procedure printString5(x: string5) is
   begin
      for I in 1..5 loop
         put(x(I));
      end loop;
   end printString5;

   procedure getCarInfo(x: in carRecord) is
   begin
      put("Car with ");
      put(x.numDoor, 0);
      put(" doors");
      put(" made by ");
      printString5(x.Manufacturer);
      new_line;
   end getCarInfo;

   function getManu(x: in carRecord) return string5 is
   begin
      return x.Manufacturer;
   end getManu;

   function getDoorNum(x: in carRecord) return Integer is
   begin
      return x.numDoor;
   end getDoorNum;
end car;
