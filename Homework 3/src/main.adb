with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with list, car, plane; use list, car, plane;
with Unchecked_Conversion;

procedure Main is
   type list_pointer is access dList;
   homeworkList: list_pointer := new dList;
   newCar, newPlane: pointer;

   --name of the manufacture to delete
   toDelete : String := "Ford ";
   done: Boolean := False;
begin
   --insert car
   --empty space to fill out 5 chars for string
   newCar := new carRecord'(node with 4, "Ford ");
   insertRear(homeworkList, newCar);
   newCar := new carRecord'(node with 2, "Ford ");
   insertFront(homeworkList, newCar);
   newCar := new carRecord'(node with 2, "GMC  ");
   insertRear(homeworkList, newCar);
   newCar := new carRecord'(node with 2, "RAM  ");
   insertRear(homeworkList, newCar);
   newCar := new carRecord'(node with 3, "Chevy");
   insertFront(homeworkList, newCar);

   --print out list size
   put("List size is: ");
   returnSize(homeworkList);
   New_Line;
   New_Line;

   --print out list
   printOut(homeworkList);
   New_Line;

   --delete the first Ford
   delete(homeworkList, toDelete);

   --print out list size
   put("List size is: ");
   returnSize(homeworkList);
   New_Line;
   New_Line;

   --print out list
   printOut(homeworkList);
   New_Line;

   --insert plane
   newPlane := new planeRecord'(node with 3, 6, "Boeing  ");
   insertFront(homeworkList, newPlane);
   newPlane := new planeRecord'(node with 2, 1, "Piper   ");
   insertFront(homeworkList, newPlane);
   newPlane := new planeRecord'(node with 4, 4, "Cessna  ");
   insertFront(homeworkList, newPlane);

   --print out list
   printOut(homeworkList);
   New_Line;
end Main;

