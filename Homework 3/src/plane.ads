--based on appedix 1, 4, and 5 in Dr. Burris note
with list;
package plane is
   type string8 is new String(1..8);
   type planeRecord is new list.node with record
      numDoor: Integer;
      numEngine: Integer;
      Manufacturer: string8;
   end record;

   procedure setDoorNum(x: in out planeRecord; y: in Integer);
   procedure setEngNum(x: in out planeRecord; y: in Integer);
   procedure setManu(x: in out planeRecord; y: in string8);
   procedure printDoorNum(x: in planeRecord);
   procedure printManu(x: in planeRecord);
   procedure printPlane(x: in planeRecord);
   procedure getPlaneInfo(x: in planeRecord);
end plane;
