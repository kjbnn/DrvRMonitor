unit sigmaEvent;

interface

uses
  System.Classes;

type
  TSigmaEvent = class(TThread)
  private

  protected
    procedure Execute; override;
  end;

var
  myindex: Int64 = 0;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,



  and UpdateCaption could look like,

  procedure SigmaEvent.UpdateCaption;
  begin
  Form1.Caption := 'Updated in a thread';
  end;

  or

  Synchronize(
  procedure
  begin
  Form1.Caption := 'Updated in thread via an anonymous method'
  end
  )
  );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

uses sigma, main, Sysutils;



  { SigmaEvent }

procedure TSigmaEvent.Execute;
begin
  NameThreadForDebugging('SigmaEvent');

  while not Terminated do
  begin

    try
      with dmSigma.qTable1 do
      begin
        Close;
        SQL.Clear;
        SQL.Text :=
          'select COD AS ID, DT AS EVENTTIME, IDBCP AS BCP, IDEVT AS EVENT' +
          ', IDOBJ AS OBJ, IDSOURCE, IDZON AS ZONE, NAMEEVT, NAMEOBJ, NAMESOURCE'
          + ', NAMEZON, OBJTYPE, TSTYPE AS TCOTYPE, TYPESOURCE AS TSOURCE from TABLE1'
          + ' where COD > ' + curEvent.ToString + 'order by COD';

        Open;
        while not Eof do
        begin
          curEvent := FieldByName('ID').AsLargeInt;
          sleep(1);
          Next;
        end;

      end;
    except
      dmSigma.DB_Protocol.Close;
    end;
    inc(myindex);
    //UpdateCaption;
    sleep(1000);
  end;
end;



end.
