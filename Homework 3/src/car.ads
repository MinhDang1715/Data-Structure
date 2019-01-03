--based on appedix 1, 4, and 5 in Dr. Burris note
with list;
package car is
   type string5 is new String(1..5);
   type carRecord is new list.node with record
      numDoor: Integer;
      Manufacturer: string5;
   end record;

   procedure setDoorNum(x: in out carRecord; y: in Integer);
   procedure setManu(x: in out carRecord; y: in string5);
   procedure getCarInfo(x: in carRecord);

   function getDoorNum(x: in carRecord) return Integer;
   function getManu(x: in carRecord) return string5;
end car;
