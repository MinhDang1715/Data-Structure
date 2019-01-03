with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with tree, customer; use tree, customer;

procedure Main is
   type BinarySearchTree is access bTree;
   homeworkTree: BinarySearchTree := new bTree;
   newCustomer, currentHead : treePointer;
begin
   put("Setting Up Tree...");
   New_Line;
   setUpTree(homeworkTree);
   New_Line;

   put("Inserting Node...");
   New_Line;
   newCustomer := new customerRecord'(node with "Moutafis  ", "295-1492  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Ikerd     ", "291-1864  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Gladwin   ", "295-1601  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Robson    ", "293-6122  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Dang      ", "295-1882  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Bird      ", "291-7890  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Harris    ", "294-8075  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Ortiz     ", "584-3622  ");
   insertBinaryTree(homeworkTree, newCustomer);
   New_Line;

   put("Finding Ortiz...");
   New_Line;
   findCustomerIterative(homeworkTree, "Ortiz     ");
   currentHead := pointToHead(homeworkTree);
   findCustomerRecursive(homeworkTree, currentHead, "Ortiz     ");
   New_Line;

   put("Finding Penton...");
   New_Line;
   findCustomerIterative(homeworkTree, "Penton    ");
   currentHead := pointToHead(homeworkTree);
   findCustomerRecursive(homeworkTree, currentHead, "Penton    ");
   New_Line;

   put("Traversing from Ikerd In Order...");
   New_Line;
   inOrderSuccessor(homeworkTree, "Ikerd     ");
   New_Line;

   put("Inserting Node...");
   New_Line;
   newCustomer := new customerRecord'(node with "Avila     ", "294-1568  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Quijada   ", "294-1882  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Villatoro ", "295-6622  ");
   insertBinaryTree(homeworkTree, newCustomer);
   New_Line;

   put("Traversing from Root In Order...");
   New_Line;
   inOrderSuccessor(homeworkTree, "root");
   New_Line;

   put("Traverse from Root Pre Order with Stack...");
   New_Line;
   preOrderTraversalIterative(homeworkTree);
   New_Line;

   --not working
   put("Deleting Nodes... Not working");
   New_Line;
   --deleteRandomNode(homeworkTree, "Robson    ");
   --deleteRandomNode(homeworkTree, "Moutafis  ");
   --deleteRandomNode(homeworkTree, "Ikerd     ");
   New_Line;

   put("Inserting Node...");
   New_Line;
   newCustomer := new customerRecord'(node with "Poudel    ", "294-1666  ");
   insertBinaryTree(homeworkTree, newCustomer);
   newCustomer := new customerRecord'(node with "Spell     ", "295-1882  ");
   insertBinaryTree(homeworkTree, newCustomer);
   New_Line;

   put("Traversing from Root Reverse In Order Recursive...");
   New_Line;
   currentHead := pointToHead(homeworkTree);
   reverseInOrder(currentHead);
   New_Line;

   put("Traversing from Root Pre Order with No Stack Iterative...");
   New_Line;
   preOrderTraversalNoStackIterative(homeworkTree);
   New_Line;

   put("Traversing from Root Pre Order with No Stack Recursive...");
   New_Line;
   currentHead := pointToHead(homeworkTree);
   preOrderTraversalNoStackRecursive(homeworkTree, currentHead);
   New_Line;

   put("Traversing from Root Post Order Iterative...");
   New_Line;
   postOrderIterative(homeworkTree);
   New_Line;

   put("Traversing from Root Post Order Recursive...");
   New_Line;
   currentHead := pointToHead(homeworkTree);
   postOrderRecursive(currentHead);
   New_Line;
end Main;
