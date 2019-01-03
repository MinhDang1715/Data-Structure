with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with list;

package body plane is
   procedure setDoorNum(x: in out planeRecord; y: in Integer) is
   begin
      x.numDoor := y;
   end setDoorNum;

   procedure setManu(x: in out planeRecord; y: in string8) is
   begin
      x.Manufacturer := y;
   end setManu;

   procedure setEngNum(x: in out planeRecord; y: in Integer) is
   begin
      x.numEngine := y;
   end setEngNum;

   procedure printDoorNum(x: in planeRecord) is
   begin
      put("Num doors: ");
      put(x.numDoor);
      New_Line;
   end printDoorNum;

   procedure printString8(x: String8) is
   begin for I in 1..8 loop
         put(x(I));
      end loop; end PrintString8;

   procedure printManu(x: in planeRecord) is
   begin
      put("Manufacturer is ");
      PrintString8(x.Manufacturer);
      New_Line;
   end printManu;

   procedure printPlane(x: in planeRecord) is
   begin
      put("Num doors: ");
      put(x.numDoor, 0);
      put("Num engines: ");
      put(x.numEngine, 0);
      put("Manufacturer: ");
      printString8(x.Manufacturer);
      new_line;
   end printPlane;

   procedure getPlaneInfo(x: in planeRecord) is
   begin
      put("Plane with ");
      put(x.numDoor, 0);
      put(" doors, ");
      put(x.numEngine, 0);
      put(" engines, ");
      put("made by ");
      PrintString8(x.Manufacturer);
      new_line;
   end getPlaneInfo;
end plane;
