package tree is
   type bTree is limited private;
   type node is tagged private;
   type treePointer is access node'Class;

   --set up an empty root for the tree
   procedure setUpTree(x: access bTree);

   procedure insertBinaryTree(tree: access bTree; input: in treePointer);

   procedure findCustomerIterative(tree: access bTree; input: in String);


   procedure findCustomerRecursive(tree: access bTree; pointer: in out treePointer; input: in String);

   procedure inOrderSuccessor(tree: access bTree; input: in String);

   --preorder traversal with stack
   procedure preOrderTraversalIterative(tree: access bTree);

   procedure customerName(pointer: in treePointer);

   procedure customerPhone(pointer: in treePointer);

   --search for the node we want to delete
   --determine which case
   --   1. a node with 1 child
   --   2. a node with 2 children
   --   3. a node with no child
   procedure deleteRandomNode(tree: access bTree; toDelete : in String);

   --recursive
   procedure reverseInOrder(pointer: in out treePointer);

   --preorder traversal without stack iterative
   procedure preOrderTraversalNoStackIterative(tree: access btree);

   --preorder traversal without stack recursive
   procedure preOrderTraversalNoStackRecursive(tree: access btree; pointer: in out treePointer);

   procedure postOrderIterative(tree: access bTree);

   procedure postOrderRecursive(pointer: in out treePointer);

   --this function will return the head of the x tree
   --use for recursive
   function pointToHead(x: access bTree) return treePointer;
private
   type node is tagged record
      lLink, rLink: treePointer := null;
      -- True indicates pointer to lower level, False a thread.
      lTag, rTag: Boolean := False;
   end record;

   type bTree is limited record
      head: treePointer := new node;
      size: Integer := 0;
   end record;
end tree;
