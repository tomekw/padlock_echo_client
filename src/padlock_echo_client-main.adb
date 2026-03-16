with Ada.Streams;
with Ada.Text_IO;

with Padlock.Configs;
with Padlock.Contexts;
with Padlock.Contexts.Clients;
with Padlock.Streams;

procedure Padlock_Echo_Client.Main is
   use Ada;
   package TLS renames Padlock;

   Cfg : constant TLS.Configs.Config := TLS.Configs.Init ("cert.pem");
   Ctx : TLS.Contexts.Clients.Client_Context := TLS.Contexts.Clients.Init (Cfg);

begin
   Ctx.Connect ("localhost", "4343");

   declare
      use type Streams.Stream_Element_Offset;

      Buffer : Streams.Stream_Element_Array (1 .. 5);
      Last : Streams.Stream_Element_Offset;

      Message : constant String := "hello";
   begin
      for Unused_I in 1 .. 5 loop
         Ctx.Write (TLS.Streams.To_Elements (Message));

         Ctx.Read (Buffer, Last);

         Text_IO.Put_Line ("Got: " & TLS.Streams.To_String (Buffer (Buffer'First .. Last)));

         delay 1.0;
      end loop;
   end;

   Ctx.Close;
end Padlock_Echo_Client.Main;
