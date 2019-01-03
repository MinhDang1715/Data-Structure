with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Float_Text_IO;
with Unchecked_Conversion;
with Ada.Direct_IO;
with processFile; use processFile;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Main is
   package logFunctions is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use logFunctions;

   type entryRecord is record
      key: String(1..16) := "0000000000000000";
      hashAdress: String(1..5) := " 000 ";
      probeNum: String(1..4) := "000 ";
   end record;
   data: entryRecord;

   toString5: String(1..5);

   package myIO is new Ada.Direct_IO(entryRecord);
   use myIO;
   fileToRead, fileToCreate, fileToWrite: File_Type;

   tableSize: Integer := 128;

   p: array(1..tableSize) of Integer;

   --linear probe
   procedure linearProbe(checkHA: in Long_Integer; toInsert: in out entryRecord; inFile: String) is
      tempHA: Integer := Integer(checkHA);
      tempData : entryRecord;
      tempProbe: Integer := 1;
      tempCount : Positive_Count;
   begin
      if tempHA = 0 then
         tempHA := 1;
         toInsert.hashAdress := "  1  ";
      end if;

      Open(File => fileToWrite, Mode => Inout_File, Name => inFile);
      reset(fileToWrite);
      for i in Positive_Count range 1..128 loop
         --compare the HA to the line num in the file
         if Integer(i) = tempHA then
            --access the information at that line
            read(fileToWrite, tempData, i);
            --if that is an empty spot then insert
            if tempData.hashAdress = " 000 " then
               toInsert.probeNum := "  1 ";
               write(fileToWrite, toInsert, i);
               --if not then handling the collision
            else
               toInsert.probeNum := "  1 ";
               --go to the next line
               tempCount := i + 1;
               while tempData.hashAdress /= " 000 " loop
                  tempProbe := tempProbe + 1;
                  read(fileToWrite, tempData, tempCount);
                  if tempData.hashAdress = " 000 " then
                     --adjust the probe number so it could fit to the legnth
                     if tempProbe < 10 then
                       toInsert.probeNum := " " & tempProbe'Image & " ";
                     elsif tempProbe < 100 then
                        toInsert.probeNum := tempProbe'Image & " ";
                     else
                        toInsert.probeNum := tempProbe'Image;
                     end if;
                     write(fileToWrite, toInsert, tempCount);
                  end if;
                  if tempCount > Count(127) then
                     tempCount := Count(1);
                  else
                     tempCount := tempCount + 1;
                  end if;
               end loop;
            end if;
         end if;
      end loop;
      close(fileToWrite);
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
   procedure randomProbe(checkHA: in Long_Integer; toInsert: in out entryRecord; inFile: String) is
      pPointer: Integer := 1;
      root : Long_Integer := checkHA;
      tempData : entryRecord;
      tempProbe: Integer := 1;
      tempCount : Positive_Count;
      tempHA: Integer := Integer(checkHA);
   begin
      if tempHA = 0 then
         tempHA := 1;
         toInsert.hashAdress := "  1  ";
      end if;
      Open(File => fileToWrite, Mode => Inout_File, Name => inFile);
      reset(fileToWrite);
      for i in Positive_Count range 1..128 loop
         --compare the HA to the line num in the file
         if Integer(i) = tempHA then
            --access the information at that line
            read(fileToWrite, tempData, i);
            --if that is an empty spot then insert
            if tempData.hashAdress = " 000 " then
               toInsert.probeNum := "  1 ";
               write(fileToWrite, toInsert, i);
               --if not then handling the collision
            else
               --tempCount := i + 1;
               --go to the next line
               toInsert.probeNum := "  1 ";
               while tempData.hashAdress /= " 000 " loop
                  tempCount := Count(root) + Count(p(pPointer));
                  if tempCount > Count(128) then
                     tempCount := tempCount - count(128);
                  end if;
                  read(fileToWrite, tempData, tempCount);
                  tempProbe := tempProbe + 1;
                  if tempData.hashAdress = " 000 " then
                     --adjust the probe number so it could fit to the legnth
                     if tempProbe < 10 then
                        toInsert.probeNum := " " & tempProbe'Image & " ";
                     elsif tempProbe < 100 then
                        toInsert.probeNum := tempProbe'Image & " ";
                     else
                        toInsert.probeNum := tempProbe'Image;
                     end if;
                  end if;
                  pPointer := pPointer + 1;
               end loop;
               write(fileToWrite, toInsert, tempCount);
            end if;
         end if;
      end loop;
      close(fileToWrite);
   end randomProbe;

  --calculate the avg, max, min of the first(last) 30 keys in the table
   procedure stat30Key(start: in Integer; inFile: String) is
      total, average, max: Integer := 0;
      min : Integer := 1;
      tempData: entryRecord;
      tempProbe: Integer;
      i : Positive_Count := 1;
      keyNum : Integer := 30;
   begin
      Open(File => fileToRead, Mode => Inout_File, Name => inFile);
      if start = 1 then
         while keyNum /= 0 loop
            read(fileToRead, tempData, i);
            if tempData.key /= "0000000000000000" then
               tempProbe := Integer'Value(tempData.probeNum);
               total := total + tempProbe;
               if max < tempProbe then
                  max := tempProbe;
               end if;
               if min > tempProbe then
                  min := tempProbe;
               end if;
               i := i + 1;
               keyNum := keyNum - 1;
            else
               i := i + 1;
            end if;
         end loop;
      else
         i := 128;
         while keyNum /= 0 loop
            read(fileToRead, tempData, i);
            if tempData.key /= "0000000000000000" then
               tempProbe := Integer'Value(tempData.probeNum);
               total := total + tempProbe;
               if max < tempProbe then
                  max := tempProbe;
               end if;
               if min > tempProbe then
                  min := tempProbe;
               end if;
               i := i - 1;
               keyNum := keyNum - 1;
            else
               i := i - 1;
            end if;
         end loop;
      end if;

      average := total / 30;

      Ada.Text_IO.put("Average number of probe for the first(last) 30 keys: ");
      Ada.Integer_Text_IO.put(average, 0);
      Ada.Text_IO.New_Line;
      Ada.Text_IO.put("Maximum number of probe for the first(last)  30 keys: ");
      Ada.Integer_Text_IO.put(max, 0);
      Ada.Text_IO.New_Line;
      Ada.Text_IO.put("Minimum number of probe for the first(last)  30 keys: ");
      Ada.Integer_Text_IO.put(min, 0);
      Ada.Text_IO.New_Line;

      close(fileToRead);
   end stat30Key;

   procedure theoryLinear(x: in Float) is
      a: Float := x / Float(tableSize);
      result: Float;
   begin
      result := (1.0 - a / 2.0) / (1.0 - a);
      Ada.Text_IO.put("The theoretical expected number of probes to locate a random item in the table is: ");
      Ada.Float_Text_IO.put(result);
   end theoryLinear;

   procedure theoryRandom(x: in Float) is
      a: Float := x / Float(tableSize);
      result: Float;
   begin
      result := - (1.0 / a) * Log(1.0 - a);
      Ada.Text_IO.put("The theoretical expected number of probes to locate a random item in the table is: ");
      Ada.Float_Text_IO.put(result);
   end theoryRandom;

   --create empty table to the output file
   procedure createTable(outFile: String) is
   begin
      Create(File => fileToCreate, Mode => Inout_File, Name => outFile);
      for i in Positive_Count range 1..128 loop
         Write(fileToCreate, data, i);
      end loop;
      Close(fileToCreate);
   end createTable;
begin
   --initialize 4 empty .txt to store all the hash that will be generated
   createTable("50%_Linear.txt");
   createTable("90%_Linear.txt");
   createTable("50%_Random.txt");
   createTable("90%_Random.txt");

   --50% full table
   getKey("Lab4.txt", 64);
   for i in 1..64 loop
      data.key := returnKey(i);
      data.probeNum := "000 ";
      --convert the HA to string then adjust its length to fit
      if returnHA(i) < Long_Integer(10) then
         toString5 := " " & returnHA(i)'Image & "  ";
      elsif returnHA(i) < Long_Integer(100) then
         toString5 := returnHA(i)'Image & "  ";
      else
         toString5 := returnHA(i)'Image & " ";
      end if;
      data.hashAdress := toString5;
      --do the insert and handle the collision
      linearProbe(returnHA(i), data, "50%_Linear.txt");
   end loop;
   Ada.Text_IO.put("Stat for 50% full with linear collision handle");
   Ada.Text_IO.New_Line;
   stat30Key(1, "50%_Linear.txt");
   Ada.Text_IO.New_Line;
   stat30Key(128, "50%_Linear.txt");
   Ada.Text_IO.New_Line;
   theoryLinear(64.0);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.put("------------------------------------------------------");
   Ada.Text_IO.New_Line;

   --clear the key array
   clearKeyArray;

   --90% full table
   getKey("Lab4.txt", 115);
   for i in 1..115 loop
      data.key := returnKey(i);
      data.probeNum := "000 ";
      --convert the HA to string then adjust its length to fit
      if returnHA(i) < Long_Integer(10) then
         toString5 := " " & returnHA(i)'Image & "  ";
      elsif returnHA(i) < Long_Integer(100) then
         toString5 := returnHA(i)'Image & "  ";
      else
         toString5 := returnHA(i)'Image & " ";
      end if;
      data.hashAdress := toString5;
      --do the insert and handle the collision
      linearProbe(returnHA(i), data, "90%_Linear.txt");
   end loop;
   Ada.Text_IO.put("Stat for 90% full with linear collision handle");
   Ada.Text_IO.New_Line;
   stat30Key(1, "90%_Linear.txt");
   Ada.Text_IO.New_Line;
   stat30Key(128, "90%_Linear.txt");
   Ada.Text_IO.New_Line;
   theoryLinear(115.0);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.put("------------------------------------------------------");
   Ada.Text_IO.New_Line;

   --clear the key array
   clearKeyArray;

   --generate the random number before do the random probe
   calculateP;

   --50% full table
   getKey("Lab4.txt", 64);
   for i in 1..64 loop
      data.key := returnKey(i);
      data.probeNum := "000 ";
      --convert the HA to string then adjust its length to fit
      if returnHA(i) < Long_Integer(10) then
         toString5 := " " & returnHA(i)'Image & "  ";
      elsif returnHA(i) < Long_Integer(100) then
         toString5 := returnHA(i)'Image & "  ";
      else
         toString5 := returnHA(i)'Image & " ";
      end if;
      data.hashAdress := toString5;
      --do the insert and handle the collision
      randomProbe(returnHA(i), data, "50%_Random.txt");
   end loop;
   Ada.Text_IO.put("Stat for 50% full with random collision handle");
   Ada.Text_IO.New_Line;
   stat30Key(1, "50%_Random.txt");
   Ada.Text_IO.New_Line;
   stat30Key(128, "50%_Random.txt");
   Ada.Text_IO.New_Line;
   theoryRandom(50.0);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.put("------------------------------------------------------");
   Ada.Text_IO.New_Line;

   --clear the key array
   clearKeyArray;

   --90% full table
   getKey("Lab4.txt", 115);
   for i in 1..115 loop
      data.key := returnKey(i);
      data.probeNum := "000 ";
      --convert the HA to string then adjust its length to fit
      if returnHA(i) < Long_Integer(10) then
         toString5 := " " & returnHA(i)'Image & "  ";
      elsif returnHA(i) < Long_Integer(100) then
         toString5 := returnHA(i)'Image & "  ";
      else
         toString5 := returnHA(i)'Image & " ";
      end if;
      data.hashAdress := toString5;
      --do the insert and handle the collision
      randomProbe(returnHA(i), data, "90%_Random.txt");
   end loop;
   Ada.Text_IO.put("Stat for 90% full with random collision handle");
   Ada.Text_IO.New_Line;
   stat30Key(1, "90%_Random.txt");
   Ada.Text_IO.New_Line;
   stat30Key(128, "90%_Random.txt");
   Ada.Text_IO.New_Line;
   theoryRandom(115.0);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.put("------------------------------------------------------");
   Ada.Text_IO.New_Line;

   --clear the key array
   clearKeyArray;
end Main;
