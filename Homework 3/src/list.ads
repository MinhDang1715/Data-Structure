--based on appedix 1, 4, and 5 in Dr. Burris note
package list is
   type dList is limited private;
   type node is tagged private;
   type pointer is access all node'Class;

   procedure insertFront(x: access dList; y: in pointer);
   procedure insertRear(x: access dList;  y: in pointer);
   procedure returnSize(x: access dList);
   procedure deleteNode(x: access dList; y: in pointer);
   procedure printOut(x: access dList);
   procedure delete(x: access dList; y: String);

   function getSize(x: access dList) return Integer;
private
   type node is tagged record
      lLink: pointer := null;
      rLink: pointer := null;
   end record;

   type dList is limited record
      front: pointer := null;
      rear: pointer := null;
      size: Integer := 0;
   end record;
end list;
