with Ada.Text_IO; use Ada.Text_IO;
with Unchecked_Conversion;
with Ada.Direct_IO;

package body processFile is
   fileToRead: File_Type;

   function toInt is new Unchecked_Conversion(Character, Integer);

   type originalKey is record
      key: String(1..16);
      HA: Long_Integer;
   end record;
   oriKey : originalKey;

   tempHashAdress: Long_Integer;

   keyArr: array(1..128) of originalKey;

   function hash(x: in String) return Long_Integer is
   begin
      --HA = ((Key[1] * 512 + Key[4] / 7 + Key[6] / 7) / 256) modulo 128
      tempHashAdress := ((Long_Integer(toInt(x(x'First))) * Long_Integer(512) + Long_Integer(toInt(x(x'First + 3))) / Long_Integer(7)
                         + Long_Integer(toInt(x(x'First + 5))) / Long_Integer(7)) / Long_Integer(256)) mod Long_Integer(128);
      return tempHashAdress;
   end hash;

   --my hash function
   function myHash(x: in String) return Long_Integer is
   begin
      --HA = (Key[3] *  Key[4] + Key[5])  modulo 128
      tempHashAdress := (Long_Integer(toInt(x(x'First + 2))) * Long_Integer(toInt(x(x'First + 3)))
                         + Long_Integer(toInt(x(x'First + 4)))) mod Long_Integer(128);
      return tempHashAdress;
   end myHash;

   procedure getKey(x: in String; y: in Integer) is
   begin
      Open(File => fileToRead, Mode => In_File, Name => "Lab4.txt");
      for i in 1..y loop
         oriKey.key := Get_Line(fileToRead);
         --oriKey.HA := hash(oriKey.key);
         oriKey.HA := myHash(oriKey.key);
         keyArr(i) := oriKey;
      end loop;
      close(fileToRead);
   end getKey;

   procedure clearKeyArray is
   begin
      for i of keyArr loop
         i.key := "0000000000000000";
         i.HA := Long_Integer(0);
      end loop;
   end clearKeyArray;

   function returnKey(x: Integer) return String is
   begin
      return keyArr(x).key;
   end returnKey;

   function returnHA(x: Integer) return Long_Integer is
   begin
      return keyArr(x).HA;
   end returnHA;
end processFile;
