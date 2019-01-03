package processFile is
   --get y key from x file
   procedure getKey(x: in String; y: in Integer);
   procedure clearKeyArray;

   function returnKey(x: Integer) return String;
   function returnHA(x: Integer) return Long_Integer;
end processFile;
