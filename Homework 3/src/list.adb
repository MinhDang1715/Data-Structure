with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with car; use car;
with plane; use plane;
with Unchecked_Conversion;

package body list is
   procedure insertFront(x: access dList; y: in pointer) is
   begin
      --check if empty list
      if x.front = null then
         y.rLink := y;
         y.lLink := y;
         x.front := y;
         x.rear := y;
      else
         y.rLink := x.front;
         x.rear.rLink := y;
         x.front.lLink := y;
         y.lLink := x.rear;
         --set the current front to y
         x.front := y;
      end if;
      --increament the size of the list
      x.size := x.size + 1;
   end insertFront;

   procedure insertRear(x: access dList; y: in pointer) is
   begin
      --check if empty list
      if x.front = null then
         y.rLink := y;
         y.lLink := y;
         x.front := y;
         x.rear := y;
      else
         y.rLink := x.rear.rLink;
         y.lLink := x.rear;
         x.rear.rLink := y;
         x.rear.lLink.lLink := y;
         --set the current rear to y
         x.rear := y;
      end if;

      --increament the size of the list
      x.size := x.size + 1;
   end insertRear;

   procedure deleteNode(x: access dList; y: in pointer) is
      --pt: pointer;
   begin
      --delete the front
      if y = x.front then
         x.rear.rLink := y.rLink;
         y.lLink := x.front.lLink;
         --set up new front
         x.front := x.front.rLink;
         x.size := x.size - 1;
      --delete the rear
      elsif y = x.rear then
         x.rear.lLink := x.rear.rLink;
         x.rear.rLink := x.rear.lLink;
         --set up new rear
         x.rear := x.front.lLink;
         x.size := x.size - 1;
      --random delete
      else
         y.lLink.rLink := y.rLink;
         y.rLink.lLink := y.lLink;

         -- no need for another pt
         --pt := y.rlink;
         --y.rLink.lLink := pt.lLink;

         x.size := x.size - 1;
      end if;
   end deleteNode;

   procedure returnSize(x: access dList) is
   begin
      put(x.size, 0);
   end returnSize;

   procedure printOut(x:access dList) is
      pt: pointer := x.front;
   begin
      --null list
      if pt = null then
         put("List is empty!");
      end if;
      pt := x.front;
      for i in 1..getSize(x) loop
         if pt.all in carRecord then
            getCarInfo(carRecord'Class(pt.all));
         elsif pt.all in planeRecord then
            getPlaneInfo(planeRecord'Class(pt.all));
         end if;
         pt := pt.rLink;
      end loop;
   end printOut;

   function getSize(x: access dList) return Integer is
   begin
      return x.size;
   end getSize;

   function toString5 is new Unchecked_Conversion(String, string5);

   procedure delete(x: access dList; y: String) is
      pt: pointer := x.front;
      listSize: Integer := getSize(x);
      done: Boolean := False;
   begin
      --null list
      if pt = null then
         put("List is empty!");
      end if;
      while listSize > 0 and not done loop
         if pt.all in carRecord then
            if getManu(carRecord'Class(pt.all)) = toString5(y) then
               deleteNode(x, pt);
               done := True;
            end if;
         end if;
         pt := pt.rLink;
         listSize := listSize - 1;
      end loop;
   end delete;
end list;
