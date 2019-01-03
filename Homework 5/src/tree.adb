--implement using Dr.Burris note
with customer; use customer;
with Ada.Text_IO; use Ada.Text_IO;
with Unchecked_Conversion;
with stack;

package body tree is
   procedure setUpTree(x: access bTree) is
   begin
      x.head.rLink := x.head;
      x.head.lLink := x.head;
      x.head.rTag := True;
      x.head.lTag := False;
   end setUpTree;

   -- Inserts the Node pointed to by Q as a subtree of P to the right
   procedure insertNodeRight(P, Q: in out treePointer) is
   begin
      Q.rLink := P.rLink;
      Q.rTag := P.rTag;
      P.rLink := Q;
      P.rTag := True;
      Q.lLink := P;
      Q.lTag := False;
      if Q.rTag = True then
         Q.rLink.lLink := Q;
      end if;
   end insertNodeRight;

   -- Inserts the Node pointed to by Q as a subtree of P to the left
   procedure insertNodeLeft(P, Q: in out treePointer) is
   begin
      Q.lLink := P.lLink;
      Q.lTag := P.lTag;
      P.lLink := Q;
      P.lTag := True;
      Q.rLink := P;
      Q.rTag := False;
      if Q.lTag = True then
         Q.lLink.rLink := Q;
      end if;
   end insertNodeLeft;

   procedure insertBinaryTree(tree: access bTree; input: in treePointer) is
      Q, P: treePointer;
      leftInsert, rightInsert, break: Boolean := False;
      inputName: string10 := getName(customerRecord(input.all));
   begin
      --tree is empty
      if tree.head.lTag = False then
         P := tree.head;
         Q := input;
         --insert the first node to the left of the empty tree
         insertNodeLeft(P, Q);
      else
         --check the value of the customer to make sure to insert it left or right
         Q := input;
         P := tree.head.lLink;
         while P /= null and not break loop
            if getName(customerRecord'Class(P.all)) < inputName then
               if P.rTag = False then
                  rightInsert := True;
                  break := True;
               else
                  P := P.rLink;
               end if;
            elsif getName(customerRecord'Class(P.all)) > inputName then
               if P.lTag = False then
                  leftInsert := True;
                  break := True;
               else
                  P := P.lLink;
               end if;
            elsif getName(customerRecord'Class(P.all)) = inputName then
               --if duplicate tree then we insert it to the right so it could be
               --after the original value
               insertNodeRight(P, Q);
               break := True;
            end if;
         end loop;
      end if;

      --insert
      if rightInsert then
         tree.size := tree.size + 1;
         insertNodeRight(P, Q);
      elsif leftInsert then
         tree.size := tree.size + 1;
         insertNodeLeft(P, Q);
      end if;
   end insertBinaryTree;

   function toString10 is new Unchecked_Conversion(String, string10);

   procedure findCustomerIterative(tree: access bTree; input: in String) is
      pt: treePointer := tree.head.lLink;
      done: Boolean := False;
   begin
      while pt /= null and not done loop
         if getName(customerRecord'Class(pt.all)) < toString10(input) and pt.rTag = True then
            pt := pt.rLink;
         elsif getName(customerRecord'Class(pt.all)) > toString10(input) and pt.lTag = True then
            pt := pt.lLink;
         elsif getName(customerRecord'Class(pt.all)) = toString10(input) then
            done := True;
         else
            pt := null;
         end if;
      end loop;

      if pt = null then
         put("There is no match for " & input & "!");
         New_Line;
      else
         put(input & "'s phone number is: ");
         printString10(getPhoneNumber(customerRecord'Class(pt.all)));
         New_Line;
      end if;
   end findCustomerIterative;

   procedure findCustomerRecursive(tree: access bTree; pointer: in out treePointer; input: in String) is
   begin
      if getName(customerRecord'Class(pointer.all)) < toString10(input) and pointer.rTag = True then
         pointer := pointer.rLink;
         findCustomerRecursive(tree, pointer, input);
      elsif getName(customerRecord'Class(pointer.all)) > toString10(input) and pointer.lTag = True then
         pointer := pointer.lLink;
         findCustomerRecursive(tree, pointer, input);
      elsif getName(customerRecord'Class(pointer.all)) = toString10(input) then
         put(input & "'s phone number is: ");
         printString10(getPhoneNumber(customerRecord'Class(pointer.all)));
         New_Line;
      else
         put("There is no match for " & input & "!");
         New_Line;
      end if;
   end findCustomerRecursive;

   --In Order Successor Algorithm by Dr. Burris
   function inOrder(x: in treePointer) return treePointer is
      P: treePointer := x;
      Q: treePointer;
   begin
      Q := P.rLink;
      if P.rTag = False then
         null;
      else
         while Q.lTag = True loop
            Q := Q.lLink;
         end loop;
      end if;
      return Q;
   end inOrder;

   --In Order Predecessor Algorithm by Dr. Burris
   function inOrderPredecessor(x: in treePointer) return treePointer is
      P: treePointer := x;
      Q: treePointer;
   begin
      Q := P.lLink;
      if P.lTag = True then
         while Q.RTag = True loop
            Q := Q.RLink;
         end loop;
      end if;
      return Q;
   end inOrderPredecessor;

   procedure inOrderSuccessor(tree: access bTree; input: in String) is
      P: treePointer := tree.head.lLink;
      break: Boolean := False;
      tempName : string10 := toString10(input);
      counter: Integer := 0;
   begin
      --check if we are just looking from a specific node or from the root
      if input = "root" then
         --reach the left most node
         while not break loop
            if P.lTag = True then
               P := P.lLink;
            else
               break := True;
            end if;
         end loop;

         while P.rLink /= P loop
            printString10(getName(customerRecord'Class(P.all)));
            printString10(getPhoneNumber(customerRecord'Class(P.all)));
            New_Line;
            P := inOrder(P);
         end loop;
      else
         --find the node
         while not break loop
            if getName(customerRecord'Class(P.all)) < toString10(input) and P.rTag = True then
               P := P.rLink;
            elsif getName(customerRecord'Class(P.all)) > toString10(input) and P.lTag = True then
               P := P.lLink;
            elsif getName(customerRecord'Class(P.all)) = toString10(input) then
               break := True;
            else
               P := null;
            end if;
         end loop;

         if P = null then
            put("Tree is empty!");
            New_Line;
         else
            --print out in inorder
            <<inOrderLoop>>
            loop
               --skip if we go back to the head
               if P.rLink = P then
                  P := inOrder(P);
                  goto inOrderLoop;
               end if;
               --disregard the first encouter
               if getName(customerRecord'Class(P.all)) = tempName then
                  counter := counter + 1;
               end if;
               --make sure we don't print out the duplicate of the node we start from
               if counter /= 2 then
                  printString10(getName(customerRecord'Class(P.all)));
                  New_Line;
                  P := inOrder(P);
               end if;
               exit when counter = 2;
            end loop;
         end if;
      end if;
   end inOrderSuccessor;

  --Pre Order with stack
   procedure preOrderTraversalIterative(tree: access bTree) is
      --set up stack
      package preOrderStack is new stack(50, treePointer);
      use preOrderStack;
      P: treePointer := tree.head.lLink;
      break: Boolean := False;
   begin

      push(P);

       --Pop all items one by one. Do following for every popped item
       --   print it
       --   push its right child
       --   push its left child
       --Note that right child is pushed first so that left is processed first
      while returnTop > 0 loop
         pop(P);
         printString10(getName(customerRecord'Class(P.all)));
         printString10(getPhoneNumber(customerRecord'Class(P.all)));
         New_Line;
         if P.rTag = True then
            push(P.rLink);
         end if;

         if P.lTag = True then
            push(P.lLink);
         end if;
      end loop;

      --print out the stack
      for i in 1..returnTop loop
         pop(P);
         printString10(getName(customerRecord'Class(P.all)));
         printString10(getPhoneNumber(customerRecord'Class(P.all)));
         New_Line;
      end loop;
   end preOrderTraversalIterative;

   procedure deleteNodeWithTwoChild(P, Q: in treePointer; tree: access bTree) is
      pre, succ: treePointer;
   begin
      null;
   end deleteNodeWithTwoChild;

   procedure deleteNodeWithOneChild(P, Q: in treePointer; tree: access bTree) is
      pre, suc: treePointer;
      temp : treePointer;
   begin
      if Q.lTag = True then
         --deleted node has 1 child to the left
         temp := Q.lLink;
      elsif Q.rTag = True then
         --deleted node has 1 child to the right
         temp := Q.rLink;
      end if;

      --check to see if the child of the deleted node is a left most or right most
      --node or not
      if temp.lLink.rLink = tree.head then
         --left most node
         P.lLink := Q.lLink;
         Q.lLink.rLink := P;
      elsif temp.rLink.rLink = tree.head then
         --right most node
         P.rLink := Q.rLink;
         Q.rLink.lLink := P;
      else
         --if the node we delete is the head node then replace the
         --root left link to the head node left link
         if P.rLink = P then
            P.lLink := temp;
         elsif Q = P.lLink then
            --delete node is to the left of its parent
            P.lLink := temp;
         else
            --delete node is to the right of its parent
            P.rLink := temp;
         end if;

         --now we find the predecessore and successor of the deleted node
         pre := inOrderPredecessor(Q);
         suc := inOrder(Q);

         --delete node has left subtree
         if Q.lTag = True then
            pre.rLink := suc;
         elsif Q.rTag = True then
            suc.lLink := pre;
         end if;
      end if;
   end deleteNodeWithOneChild;

   procedure deleteNode(P, Q: in treePointer; tree: access bTree) is
   begin
      --check to see if the child of the deleted node is a left most or right most
      --node or not
      if Q.lLink.rLink = tree.head then
         --left most node
         P.lTag := False;
         P.lLink := Q.lLink;
      elsif Q.rLink.rLink = tree.head then
         --right most node
         P.rTag := False;
         P.rLink := Q.rLink;
      else
         if P.lTag = True then
            P.lLink := Q.lLink;
            P.lTag := False;
         elsif P.rTag = True then
            P.rLink := Q.rLink;
            P.rTag := False;
         end if;
      end if;
   end deleteNode;

   procedure deleteRandomNode(tree: access bTree; toDelete: in String) is
      Q: treePointer := tree.head.lLink;
      done: Boolean := False;
      P: treePointer;
   begin
      --find the node we need to delete
      while Q /= null and not done loop
         if getName(customerRecord'Class(Q.all)) < toString10(toDelete) and Q.rTag = True then
            P := Q;
            Q := Q.rLink;
            --if we move to the right then the parent of the current node is on the left
         elsif getName(customerRecord'Class(Q.all)) > toString10(toDelete) and Q.lTag = True then
            P := Q;
            Q := Q.lLink;
            --if we move to the left then the parent of the current node is on the reft
         elsif getName(customerRecord'Class(Q.all)) = toString10(toDelete) then
            done := True;
         else
            Q := null;
         end if;
      end loop;

      --if the node is not found
      if Q = null then
         put("There is no match for " & toDelete & "!");
      else
         --determine what are we deleting
         if Q.lTag = True and Q.rTag = True then
            --node that has 2 child
            deleteNodeWithTwoChild(P, Q, tree);
         elsif Q.lTag = True and Q.rTag = True then
            --node that has left or right child
            deleteNodeWithOneChild(P, Q, tree);
         else
            --node that does not have a child
            deleteNode(P, Q, tree);
         end if;
      end if;
   end deleteRandomNode;

   procedure reverseInOrder(pointer: in out treePointer) is
   begin
      if pointer.rTag = True then
         reverseInOrder(pointer.rLink);
      end if;

      printString10(getName(customerRecord'Class(pointer.all)));
      printString10(getPhoneNumber(customerRecord'Class(pointer.all)));
      New_Line;

      if pointer.lTag = True then
         reverseInOrder(pointer.lLink);
      end if;
   end reverseInOrder;

   --Pre Order Successor using Dr. Burris' note
   function preOrderSuccessor(x: in treePointer) return treePointer is
      P: treePointer := x;
      Q: treePointer;
   begin
      if P.lTag = True then
         Q := P.lLink;
      else
         Q := P;
         while Q.rTag = False loop
            Q := Q.rLink;
         end loop;
         Q := Q.rLink;
      end if;
      return Q;
   end preOrderSuccessor;

   procedure preOrderTraversalNoStackIterative(tree: access bTree) is
      P: treePointer := tree.head.lLink;
   begin
      while P.rLink /= P loop
         printString10(getName(customerRecord'Class(P.all)));
         printString10(getPhoneNumber(customerRecord'Class(P.all)));
         New_Line;
         P := preOrderSuccessor(P);
      end loop;
   end preOrderTraversalNoStackIterative;

   procedure preOrderTraversalNoStackRecursive(tree: access btree; pointer: in out treePointer) is
   begin
      if pointer.rLink /= pointer then
         printString10(getName(customerRecord'Class(pointer.all)));
         printString10(getPhoneNumber(customerRecord'Class(pointer.all)));
         New_Line;
         if pointer.lTag = True then
            pointer := pointer.lLink;
         else
            while pointer.rTag = False loop
               pointer := pointer.rLink;
            end loop;
            pointer := pointer.rLink;
         end if;
         preOrderTraversalNoStackRecursive(tree, pointer);
      end if;
   end preOrderTraversalNoStackRecursive;

   --Post Order Predecessor using Dr. Burris' note
   function postOrderPredecessor(x: in treePointer) return treePointer is
      P: treePointer := x;
      Q: treePointer;
   begin
      Q := P;
      if P.rTag = True then
         Q := P.rLink;
      else
         while Q.lTag = False loop
            Q := Q.lLink;
         end loop;
         Q := Q.lLink;
      end if;
      return Q;
   end postOrderPredecessor;

   procedure postOrderIterative(tree: access bTree) is
      package postOrderStack is new stack(50, treePointer);
      use postOrderStack;
      P: treePointer := tree.head.lLink;
   begin
      while returnTop <= tree.size loop
         push(P);
         P := postOrderPredecessor(P);
      end loop;

      for i in 1..returnTop loop
         pop(P);
         printString10(getName(customerRecord'Class(P.all)));
         printString10(getPhoneNumber(customerRecord'Class(P.all)));
         New_Line;
      end loop;
      end postOrderIterative;

   procedure postOrderRecursive(pointer: in out treePointer) is
   begin
      if pointer.lTag = True then
         postOrderRecursive(pointer.lLink);
      end if;

      if pointer.rTag = True then
         postOrderRecursive(pointer.rLink);
      end if;

      printString10(getName(customerRecord'Class(pointer.all)));
      printString10(getPhoneNumber(customerRecord'Class(pointer.all)));
      New_Line;
   end postOrderRecursive;

   procedure customerName(pointer: in treePointer) is
   begin
      printString10(getName(customerRecord'Class(pointer.all)));
   end customerName;

   procedure customerPhone(pointer: in treePointer) is
   begin
      printString10(getPhoneNumber(customerRecord'Class(pointer.all)));
   end customerPhone;

   function pointToHead(x: access bTree) return treePointer is
   begin
      return x.head.lLink;
   end pointToHead;
end tree;
