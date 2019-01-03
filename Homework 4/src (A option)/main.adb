with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Long_Integer_Text_IO; use Ada.Long_Integer_Text_IO;
with Unchecked_Conversion;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Main is
   Input: File_Type;

   tableSize: Integer := 128;

   p: array(1..tableSize) of Integer;

   tempHashAdress: Long_Integer;
   tempKey: String(1..16);

   package logFunctions is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use logFunctions;

   type entryRecord is record
      key: String(1..16) := "0000000000000000";
      hashAdress: Long_Integer := 0;
      probeNum: Integer := 0;
   end record;

   table: array(1..tableSize) of entryRecord;

   --convert char to int
   function toInt is new Unchecked_Conversion(Character, Integer);

   --hash function
   function hash(x: in String) return Long_Integer is
   begin
      --HA = ( (Key[1] * 512 + Key[4] / 7 + Key[6] / 7) / 256 ) modulo 128
      tempHashAdress := ((Long_Integer(toInt(x(x'First))) * Long_Integer(512) + Long_Integer(toInt(x(x'First + 3))) / Long_Integer(7)
        + Long_Integer(toInt(x(x'First + 5))) / Long_Integer(7)) / Long_Integer(256)) mod Long_Integer(128);
      return tempHashAdress;
   end hash;

   --my hash function
   function myHash(x: in String) return Long_Integer is
   begin
      --HA = (Key[3] *  Key[4] + Key[5])  modulo 128
      tempHashAdress := (Long_Integer(toInt(x(x'First+2))) * Long_Integer(toInt(x(x'First + 3)))
                         + Long_Integer(toInt(x(x'First + 4)))) mod Long_Integer(128);
      return tempHashAdress;
   end myHash;

   --linear probe
   procedure linearProbe(checkHA: in Long_Integer; toInsert: in out entryRecord) is
      tempHA: Integer := Integer(checkHA);
   begin
      if tempHA = 0 then
         tempHA := 1;
         toInsert.hashAdress := Long_Integer(1);
      end if;
      --when find an empty spot insert the toInsert
      if table(tempHA).hashAdress = Long_Integer(0) then
         toInsert.probeNum := 1;
         table(tempHA) := toInsert;
      --keep looking for an empty spot
      else
         toInsert.probeNum := 1;
         while table(tempHA).hashAdress /= Long_Integer(0) loop
            toInsert.probeNum := toInsert.probeNum + 1;
            if tempHA < 128 then
            tempHA := tempHA + 1;
            else
               tempHA := 1;
            end if;
         end loop;
         table(tempHA) := toInsert;
      end if;
   end linearProbe;

   --calculate the random number then store it in the array p
   procedure calculateP is
      r, i: Integer := 1;
      done: Boolean := False;
   begin
      while not done loop
         r := r * 5;
         r := r mod (2**9);
         if r = 1 then
            done := True;
         end if;
         p(i) := r / 4;
         i := i + 1;
      end loop;
   end calculateP;

   --random proble
   --using Dr. Burris note
   procedure randomProbe(checkHA: in Long_Integer; toInsert: in out entryRecord) is
      tempHA: Integer := Integer(checkHA);
      root: Integer := Integer(checkHA);
      i: Integer := 1;
   begin
      --if we end up with HA 0 then set it to 1
      if tempHA = 0 then
         tempHA := 1;
         toInsert.hashAdress := Long_Integer(1);
      end if;
      --when find an empty spot insert the toInsert
      if table(tempHA).hashAdress = Long_Integer(0) then
         toInsert.probeNum := 1;
         table(tempHA) := toInsert;
         --keep looking for an empty spot
      else
         toInsert.probeNum := 1;
         while table(tempHA).hashAdress /= Long_Integer(0) loop
            toInsert.probeNum := toInsert.probeNum + 1;
            tempHA := root + p(i);
            if tempHA > tableSize then
               tempHA := tempHA - 128;
            end if;
            i := i + 1;
         end loop;
         table(tempHA) := toInsert;
      end if;
   end randomProbe;

   --calculate the avg, max, min of the first 30 keys in the table
   procedure stat30Key(start: in Integer) is
      total, average, max: Integer := 0;
      min : Integer := 1;
      keyNum : Integer := 30;
      i: Integer := 1;
   begin
      if start = 1 then
         while keyNum /= 0 loop
            if table(i).key /= "0000000000000000" then
               --get the total number of probe
               total := total + table(i).probeNum;

               --get the maximum number of probe
               if table(i).probeNum > max then
                  max := table(i).probeNum;
               end if;

               --get the minimum number of probe
               if table(i).probeNum < min then
                  min := table(i).probeNum;
               end if;
               i := i + 1;
               keyNum := keyNum - 1;
            else
               i := i + 1;
            end if;

         end loop;
      else
         i := start;
         while keyNum /= 0 loop
            if table(i).key /= "0000000000000000" then
               --get the total number of probe
               total := total + table(i).probeNum;

               --get the maximum number of probe
               if table(i).probeNum > max then
                  max := table(i).probeNum;
               end if;

               --get the minimum number of probe
               if table(i).probeNum < min then
                  min := table(i).probeNum;
               end if;
               i := i - 1;
               keyNum := keyNum - 1;
            else
               i := i - 1;
            end if;
         end loop;
      end if;
      average := total / 30;
      put("Average number of probe for the first(last) 30 keys: ");
      put(average, 0);
      New_Line;
      put("Maximum number of probe for the first(last)  30 keys: ");
      put(max, 0);
      New_Line;
      put("Minimum number of probe for the first(last)  30 keys: ");
      put(min, 0);
      New_Line;
   end stat30Key;

   procedure theoryLinear(x: in Float) is
      a: Float := x / Float(tableSize);
      result: Float;
   begin
      result := (1.0 - a / 2.0) / (1.0 - a);
      put("The theoretical expected number of probes to locate a random item in the table is: ");
      put(result);
   end theoryLinear;

   procedure theoryRandom(x: in Float) is
      a: Float := x / Float(tableSize);
      result: Float;
   begin
      result := - (1.0 / a) * Log(1.0 - a);
      put("The theoretical expected number of probes to locate a random item in the table is: ");
      put(result);
   end theoryRandom;


   --print the table
   procedure printTable is
      num : Integer := 1;
   begin
      for i of table loop
         put(num, 0);
         put(")        ");
         put(i.key);
         put(i.hashAdress);
         put(i.probeNum);
         New_Line;
         num := num + 1;
      end loop;
   end printTable;

   --clear the table for next time
   procedure clearTable is
   begin
      for i of table loop
         i.key := "0000000000000000";
         i.hashAdress := 0;
         i.probeNum := 0;
      end loop;
   end clearTable;

   --create table with the x percent full
   --mode = 1: linear
   --mode = 2: random
   procedure populateTable(x: Integer; mode: Integer) is
      percentToValue : Integer := tableSize * x / 100;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => "Lab4.txt");
      for i in 1..percentToValue loop
         declare
            data: entryRecord;
         begin
            tempKey := Get_Line(Input);
            data.key := tempKey;
            --data.hashAdress := hash(tempKey);
            data.hashAdress := myHash(tempKey);
            if mode = 1 then
               --insert with linear approach
               linearProbe(data.hashAdress, data);
            else
               --insert with random approach
               randomProbe(data.hashAdress, data);
            end if;
         end;
      end loop;

      Close(Input);
   exception
      when End_Error =>
         if Is_Open(Input) then
            Close (Input);
         end if;
   end populateTable;

begin
   --50% full table
   put("Stat for 50% full with linear collision handle");
   New_Line;
   populateTable(50, 1);
   stat30Key(1);
   New_Line;
   stat30Key(128);
   New_Line;
   theoryLinear(64.0);
   New_Line;
   New_Line;
   printTable;
   put("------------------------------------------------------");
   New_Line;


   clearTable;

   --90% full table
   put("Stat for 90% full with linear collision handle");
   New_Line;
   populateTable(90, 1);
   stat30Key(1);
   New_Line;
   stat30Key(128);
   New_Line;
   theoryLinear(115.0);
   New_Line;
   New_Line;
   printTable;
   put("------------------------------------------------------");
   New_Line;

   clearTable;

   --generate the random number before do the random probe
   calculateP;

   --50% full table
   put("Stat for 50% full with random collision handle");
   New_Line;
   populateTable(50, 2);
   stat30Key(1);
   New_Line;
   stat30Key(128);
   New_Line;
   theoryRandom(50.0);
   New_Line;
   New_Line;
   printTable;
   put("------------------------------------------------------");
   New_Line;

   clearTable;

   --90% full table
   put("Stat for 90% full with random collision handle");
   New_Line;
   populateTable(90, 2);
   stat30Key(1);
   New_Line;
   stat30Key(128);
   New_Line;
   theoryRandom(115.0);
   New_Line;
   New_Line;
   printTable;
   put("------------------------------------------------------");
   New_Line;
end Main;
