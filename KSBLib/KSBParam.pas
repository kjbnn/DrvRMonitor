{ *************************************************************************** }
{                                                                             }
{ Пограммное обеспечение РОСТЭК 2. Обработка параметров сообщений KSBMES.     }
{                                                                             }
{ Copyright (c) 2005 РОСТ-ВСП ООО. Версия файла 1.03 от 05.10.2005 г.         }
{                                                                             }
{ *************************************************************************** }


unit KSBParam;

interface

uses Windows, SysUtils,Classes, IBX.IBDatabase, SharedBuffer {<- KSBMES};

type
  TKSBParam = class
    // Private
    Params: TStrings;
    procedure ClearParams;
  public
    // Init object
    constructor Create;
    destructor Destroy; override;
    // Save & Load parameters
    procedure SaveToFile(const FileName: String);
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromBase(DB: TIBDatabase; const CategoryId: Integer);
    // Common read & write parameter
    function ReadParameter(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): Variant;
    function WriteParameter(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: Variant): Boolean;
    // Special read & write parameter
    function ReadDoubleParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): Double;
    function ReadIntegerParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): DWORD;
    function ReadStringParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): AnsiString;
    function WriteDoubleParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: Double): Boolean;
    function WriteIntegerParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: DWORD): Boolean;
    function WriteStringParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: AnsiString): Boolean;
  end;

var
  TheKSBParam: TKSBParam; // ГЛОБАЛЬНЫЙ ОБЪЕКТ ЧИТАТЕЛЬ/ПИСАТЕЛЬ ПАРАМЕТРОВ

implementation

uses IBX.IBSQL, IniFiles, Variants;

// Структура атрибутов параметра -----------------------------------------------
type
  TParamRec = class
     Kind: Word;      // Тип: 0 - параметр в KSBMES (включая ПИН-код);
                      //      1 - Integer в DATA после KSBMES;
                      //      2 - Double в DATA после KSBMES;
                      //      3 - String в DATA после KSBMES.
     Title: String;   // Название параметра
     Field: String;   // Имя поля данных в KSBMES
     Start: DWORD;    // Номер начального байта в DATA
     Length: DWORD;   // Длина данных в DATA
     Mask: DWORD;     // Маска числового параметра
  end;

// Сохранить параметры в файле -------------------------------------------------
procedure TKSBParam.SaveToFile(const FileName: String);
var
  i: Integer;
  F: TIniFile;
  P: TParamRec;
begin
  try
  F := nil;
  F := TIniFile.Create(FileName);
  for i := 0 to Params.Count - 1 do
    begin
      P := Params.Objects[i] as TParamRec;
      F.WriteString(Params.Strings[i],  'TITLE', P.Title);
      F.WriteInteger(Params.Strings[i], 'PARAM.KIND', P.Kind);
      F.WriteString(Params.Strings[i],  'KSB.FIELD', P.Field);
      F.WriteInteger(Params.Strings[i], 'BYTE.START', P.Start);
      F.WriteInteger(Params.Strings[i], 'BYTE.LENGTH', P.Length);
      F.WriteInteger(Params.Strings[i], 'DATA.MASK', P.Mask);
    end;
  finally
    if Assigned(F) then F.Free;
  end;
end;

// Загрузить параметры из файла ------------------------------------------------
procedure TKSBParam.LoadFromFile(const FileName: String);
var
  i: Integer;
  F: TIniFile;
  P: TParamRec;
begin
  if not FileExists(FileName) then SysUtils.Abort;
  try
  F := nil;
  ClearParams;
  F := TIniFile.Create(FileName);
  F.ReadSections(Params); // Загрузим все секции из ini-файла
  for i := Params.Count - 1 downto 0 do
    begin
      // Секция с параметром должна иметь все эти идентификаторы
      if F.ValueExists(Params.Strings[i], 'PARAM.KIND') and
         F.ValueExists(Params.Strings[i], 'KSB.FIELD') and
         F.ValueExists(Params.Strings[i], 'BYTE.START') and
         F.ValueExists(Params.Strings[i], 'BYTE.LENGTH') and
         F.ValueExists(Params.Strings[i], 'DATA.MASK') then
       begin
         P := TParamRec.Create;
         P.Title := F.ReadString(Params.Strings[i], 'TITLE', '');
         P.Mask := F.ReadInteger(Params.Strings[i], 'DATA.MASK', 0);
         P.Kind := F.ReadInteger(Params.Strings[i], 'PARAM.KIND', 0);
         P.Field := F.ReadString(Params.Strings[i], 'KSB.FIELD', '');
         P.Start := F.ReadInteger(Params.Strings[i], 'BYTE.START', 0);
         P.Length := F.ReadInteger(Params.Strings[i], 'BYTE.LENGTH', 0);
         Params.Objects[i] := P;
       end else Params.Delete(i); // Эта секция не параметр - удалим ее из списка
    end;
  finally
    if Assigned(F) then F.Free;
  end;
end;

// Загрузить параметры из базы описаний КИСБ -----------------------------------
procedure TKSBParam.LoadFromBase(DB: TIBDatabase; const CategoryId: Integer);
var
  P: TParamRec;
  Query: TIBSQL;
begin
  try
  ClearParams;
  Query := nil;
  Query := TIBSQL.Create(nil);
  Query.Database := DB;
  Query.Transaction := DB.DefaultTransaction;
  Query.SQL.Text := 'select PARAMETER_TITLE, PARAMETER_NAME, PARAMETER_KIND, ' +
                    'FIELD_NAME, BYTE_NUMBER, BYTE_LENGTH, DATA_MASK ' +
                    'from CATEGORY_PARAMETER ';
  if CategoryId > 0 then
    Query.SQL.Text := Query.SQL.Text + 'where CATEGORY_ID = ' + IntToStr(CategoryId);
  Query.ExecQuery;
  while not Query.Eof do
    begin
      P := TParamRec.Create;
      P.Title := Query.FieldByName('PARAMETER_TITLE').asString;
      P.Kind := Query.FieldByName('PARAMETER_KIND').asInteger;
      P.Field := Query.FieldByName('FIELD_NAME').asString;
      P.Start := Query.FieldByName('BYTE_NUMBER').asInteger;
      P.Length := Query.FieldByName('BYTE_LENGTH').asInteger;
      P.Mask := Query.FieldByName('DATA_MASK').asInteger;
      Params.AddObject(Query.FieldByName('PARAMETER_NAME').asString, P);
      Query.Next;
    end;
  finally
    if Assigned(Query) then Query.Free;
  end;
end;

// Прочитать значение параметра ------------------------------------------------
function TKSBParam.ReadParameter(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): Variant;
var
  Ind: Integer;
  P: TParamRec;
begin
  Result := null;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  if P.Kind = 0 then // Параметр в структуре KSBMES
    begin
      if P.Field = 'PIN' then
        begin
          Result := ReadStringParam(MES, DATA, ParamName);
        end else
      if (P.Field = 'CmdTime') or (P.Field = 'SendTime') or (P.Field = 'WriteTime') then
        begin
          Result := ReadDoubleParam(MES, DATA, ParamName);
        end else
        begin
          Result := ReadIntegerParam(MES, DATA, ParamName);
        end;
    end else
  if P.Kind = 1 then // Числовой параметр в DATA
    begin
      Result := ReadIntegerParam(MES, DATA, ParamName);
    end else
  if P.Kind = 2 then // Временной параметр в DATA
    begin
      Result := ReadDoubleParam(MES, DATA, ParamName);
    end else
  if P.Kind = 3 then // Строковый параметр в DATA
    begin
      Result := ReadStringParam(MES, DATA, ParamName);
   end;
end;

// Записать значение параметра -------------------------------------------------
function TKSBParam.WriteParameter(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: Variant): Boolean;
var
  Ind: Integer;
  P: TParamRec;
begin
  Result := False;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  if P.Kind = 0 then // Параметр в структуре KSBMES
    begin
      if P.Field = 'PIN' then
        begin
          Result := WriteStringParam(MES, DATA, ParamName, Value);
        end else
      if (P.Field = 'CmdTime') or (P.Field = 'SendTime') or (P.Field = 'WriteTime') then
        begin
          Result := WriteDoubleParam(MES, DATA, ParamName, Value);
        end else
        begin
          Result := WriteIntegerParam(MES, DATA, ParamName, Value);
        end;
    end else
  if P.Kind = 1 then // Числовой параметр в DATA
    begin
      Result := WriteIntegerParam(MES, DATA, ParamName, Value);
    end else
  if P.Kind = 2 then // Временной параметр в DATA
    begin
      Result := WriteDoubleParam(MES, DATA, ParamName, Value);
    end else
  if P.Kind = 3 then // Строковый параметр в DATA
    begin
      Result := WriteStringParam(MES, DATA, ParamName, Value);
   end;
end;

// Прочитать Double параметр из KSBMES+DATA ------------------------------------
function TKSBParam.ReadDoubleParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): Double;
var
  i: Integer;
  Param: BYTE;
  Ind: Integer;
  P: TParamRec;
  PValue: ^Double;
begin
  Result := 0;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  // Число в данных за структурой KSBMES ---------------------------------------
  if (P.Kind = 2) then
    begin
      Ind := 0;
      PValue := @Result;
      if MES.Size = 0 then Exit;
      if P.Start > MES.Size div 2 then Exit;
      if P.Length > SizeOf(Result) then Exit;
      if P.Start + P.Length > MES.Size div 2 then Exit;
      for i := P.Start to P.Start + P.Length - 1 do
        begin
          Param := BYTE(DATA[i]);
          PValue^ := Param;
          Inc(PValue);
        end;
    end else
  // Числовой параметр в структуре KSBMES --------------------------------------
  if ((P.Kind = 0) and (P.Field = 'CmdTime')) or
     ((P.Kind = 0) and (P.Field = 'SendTime')) or
     ((P.Kind = 0) and (P.Field = 'WriteTime')) then
    begin
      if P.Field = 'CmdTime' then Result := MES.CmdTime else
      if P.Field = 'SendTime' then Result := MES.SendTime else
      if P.Field = 'WriteTime' then Result := MES.WriteTime;
    end;
end;

// Прочитать Integer параметр из KSBMES+DATA -----------------------------------
function TKSBParam.ReadIntegerParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): DWORD;
var
  i: Integer;
  Param: BYTE;
  Ind: Integer;
  P: TParamRec;
  Mask: DWORD;
begin
  Result := 0;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  Mask := P.Mask; // Маска по умолчанию $FFFFFFFF
  // Числовой параметр в структуре KSBMES --------------------------------------
  if (P.Kind = 0) and (P.Field <> 'PIN') then
    begin
      if P.Field = 'Code' then Result := MES.Code else
      if P.Field = 'Partion' then Result := MES.Partion else
      if P.Field = 'Level' then Result := MES.Level else
      if P.Field = '_Group' then Result := MES._Group else
      if P.Field = 'User' then Result := MES.User else
      if P.Field = 'Fill' then Result := MES.Fill[0] + MES.Fill[1] shl 8 + MES.Fill[2] shl 16 else
      if P.Field = 'Keyboard' then Result := MES.Keyboard else
      if P.Field = 'Camera' then Result := MES.Camera else
      if P.Field = 'Monitor' then Result := MES.Monitor else
      if P.Field = 'NumCard' then Result := MES.NumCard else
      if P.Field = 'RepPass' then Result := MES.RepPass else
      if P.Field = 'Facility' then Result := MES.Facility else
      if P.Field = 'Scenary' then Result := MES.Scenary else
      if P.Field = 'Mode' then Result := MES.Mode else
      if P.Field = 'Group' then Result := MES.Group else
      if P.Field = 'EmployeeID' then Result := MES.EmployeeID else
      if P.Field = 'OperatorID' then Result := MES.OperatorID else
      if P.Field = 'DomainID' then Result := MES.DomainId;
    end else
  // Число в данных за структурой KSBMES ---------------------------------------
  if (P.Kind = 1) then
    begin
      Ind := 0;
      if MES.Size = 0 then Exit;
      if P.Start > MES.Size div 2 then Exit;
      if P.Length > SizeOf(Result) then Exit;
      if P.Start + P.Length > MES.Size div 2 then Exit;
      for i := P.Start to P.Start + P.Length - 1 do
        begin
          Param := Byte(DATA[i]);
          Result := Result + (Param shl (Ind * 8));
          Inc(Ind);
        end;
    end;
  // Маскирование результата ---------------------------------------------------
  while Mask and $0001 = 0 do // Сдвигаем пока 0-бит равен 0
    begin
      if Result = 0 then Exit;
      Result := Result shr 1;
      Mask := Mask shr 1;
    end;
  Result := Result and Mask;
end;

// Прочитать String параметр из KSBMES+DATA ------------------------------------
function TKSBParam.ReadStringParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString): AnsiString;
var
  s: String;
  i: Integer;
  sMES: String;
  Ind: Integer;
  P: TParamRec;
begin
  Result := '';
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  // Строка в данных за структурой KSBMES --------------------------------------
  if P.Kind = 3 then
    begin
      Ind := 0;
      for i := P.Start to P.Start + P.Length - 1 do
        begin
          Inc(Ind);
          if DATA[i] = #0 then Break;
          SetLength(Result, Ind);
          Result[Ind] := DATA[i];
        end;
    end else
  // ПИН-код в структуре KSBMES ------------------------------------------------
  if (P.Kind = 0) and (P.Field = 'PIN') then
    begin
      SetLength(Result, 6);
      Result[1] := MES.PIN[0];
      Result[2] := MES.PIN[1];
      Result[3] := MES.PIN[2];
      Result[4] := MES.PIN[3];
      Result[5] := MES.PIN[4];
      Result[6] := MES.PIN[5];
    end;
end;

// Записать Double параметр в KSBMES+DATA --------------------------------------
function TKSBParam.WriteDoubleParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: Double): Boolean;
var
  i: Integer;
  Param: BYTE;
  Ind: Integer;
  P: TParamRec;
  PValue: ^Double;
begin
  Result := False;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  // Число в данных за структурой KSBMES ---------------------------------------
  if (P.Kind = 2) then
    begin
      Ind := 0;
      Result := True;
      PValue := @Value;
      if MES.Size = 0 then Exit;
      if P.Start > MES.Size div 2 then Exit;
      if P.Length > SizeOf(Value) then Exit;
      if P.Start + P.Length > MES.Size div 2 then Exit;
      for i := P.Start to P.Start + P.Length - 1 do
        begin
          Param := BYTE(PAnsiChar(PValue)[0]);
          DATA[i] := AnsiChar(Param);
          Inc(PValue);
        end;
    end else
  // Числовой параметр в структуре KSBMES --------------------------------------
  if ((P.Kind = 0) and (P.Field = 'CmdTime')) or
     ((P.Kind = 0) and (P.Field = 'SendTime')) or
     ((P.Kind = 0) and (P.Field = 'WriteTime')) then
    begin
      Result := True;
      if P.Field = 'CmdTime' then MES.CmdTime := Value else
      if P.Field = 'SendTime' then MES.SendTime := Value else
      if P.Field = 'WriteTime' then MES.WriteTime := Value;
    end;
end;

// Записать Integer параметр в KSBMES+DATA -------------------------------------
function TKSBParam.WriteIntegerParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: DWORD): Boolean;
var
  i: Integer;
  Param: BYTE;
  Ind: Integer;
  P: TParamRec;
  Number: DWORD;
  Mask: DWORD;
begin
  Result := False;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  Mask := P.Mask; // Маска по умолчанию $FFFFFFFF
  // Подгоняем под маску занчение числа ----------------------------------------
  Number := Value;
  while Mask and $0001 = 0 do // Сдвигаем пока 0-бит равен 0
    begin
      if Number = 0 then Break;
      Number := Number shl 1;
      Mask := Mask shr 1;
    end;
  Number := Number and P.Mask;
  // Числовой параметр в структуре KSBMES --------------------------------------
  if (P.Kind = 0) and (P.Field <> 'PIN') then
    begin
      Result := True;
      if P.Field = 'Code' then MES.Code := MES.Code or Word(Number) else
      if P.Field = 'Partion' then MES.Partion := MES.Partion or Word(Number) else
      if P.Field = 'Level' then MES.Level := MES.Level or Word(Number) else
      if P.Field = '_Group' then MES._Group := MES._Group or Word(Number) else
      if P.Field = 'User' then MES.User := MES.User or Word(Number) else
      if P.Field = 'Fill' then
        begin
          MES.Fill[0] := MES.Fill[0] or Byte(Number and $000000FF);
          MES.Fill[1] := MES.Fill[1] or Byte(Number and $0000FF00);
          MES.Fill[2] := MES.Fill[2] or Byte(Number and $00FF0000);
        end else
      if P.Field = 'Keyboard' then MES.Keyboard := MES.Keyboard or Word(Number) else
      if P.Field = 'Camera' then MES.Camera := MES.Camera or Word(Number) else
      if P.Field = 'Monitor' then MES.Monitor := MES.Monitor or Word(Number) else
      if P.Field = 'NumCard' then MES.NumCard := MES.NumCard or Word(Number) else
      if P.Field = 'RepPass' then MES.RepPass := MES.RepPass or Byte(Number) else
      if P.Field = 'Facility' then MES.Facility := MES.Facility or Byte(Number) else
      if P.Field = 'Scenary' then MES.Scenary := MES.Scenary or Word(Number) else
      if P.Field = 'Mode' then MES.Mode := MES.Mode or Word(Number) else
      if P.Field = 'Group' then MES.Group := MES.Group or Number else
      if P.Field = 'EmployeeID' then MES.EmployeeID := MES.EmployeeID or Word(Number) else
      if P.Field = 'OperatorID' then MES.OperatorID := MES.OperatorID or Word(Number) else
      if P.Field = 'DomainID' then MES.DomainId := MES.DomainId or Word(Number);
    end else
  // Число в данных за структурой KSBMES ---------------------------------------
  if P.Kind = 1 then
    begin
      Ind := 0;
      if MES.Size = 0 then Exit;
      if P.Start > MES.Size div 2 then Exit;
      if P.Length > SizeOf(Value) then Exit;
      if P.Start + P.Length > MES.Size div 2 then Exit;
      for i := P.Start to P.Start + P.Length - 1 do
        begin
          Param := BYTE(DATA[i]);
          Param := Param or (Number shr (Ind * 8)) and $FF;
          DATA[i] := AnsiChar(Param);
          Inc(Ind);
        end;
    end;
end;

// Записать String параметр в KSBMES+DATA --------------------------------------
function TKSBParam.WriteStringParam(var MES: KSBMES; DATA: PAnsiChar; const ParamName: AnsiString; const Value: AnsiString): Boolean;
var
  i: Integer;
  Ind: Integer;
  P: TParamRec;
begin
  Result := False;
  Ind := Params.IndexOf(ParamName);
  if Ind < 0 then Exit;
  P := Params.Objects[Ind] as TParamRec;
  // ПИН-код в структуре KSBMES ------------------------------------------------
  if (P.Kind = 0) and (P.Field = 'PIN') then
    begin
      if Length(Value) > 0 then MES.PIN[0] := Value[1];
      if Length(Value) > 1 then MES.PIN[1] := Value[2];
      if Length(Value) > 2 then MES.PIN[2] := Value[3];
      if Length(Value) > 3 then MES.PIN[3] := Value[4];
      if Length(Value) > 4 then MES.PIN[4] := Value[5];
      if Length(Value) > 5 then MES.PIN[5] := Value[6];
    end else
  // Строка в данных -----------------------------------------------------------  
  if (P.Kind = 3) then
    begin
      Ind := 0;
      for i := P.Start to P.Start + P.Length - 1 do
        begin
          Inc(Ind);
          if Value[Ind] = #0 then Break;
          DATA[i] := Value[Ind];
        end;
    end;
end;

// Конструктор -----------------------------------------------------------------
constructor TKSBParam.Create;
begin
  Params := nil;
  inherited Create;
  Params := TStringList.Create;
end;

// Деструктор ------------------------------------------------------------------
destructor TKSBParam.Destroy;
begin
  ClearParams;
  if Assigned(Params) then Params.Free;
  inherited Destroy;
end;

// Очистить список парамеиров --------------------------------------------------
procedure TKSBParam.ClearParams;
var
  i: Integer;
  P: TParamRec;
begin
  for i := 0 to Params.Count - 1 do
    begin
      P := Params.Objects[i] as TParamRec;
      P.Free;
    end;
  Params.Clear;
end;

initialization
  TheKSBParam := nil;
  TheKSBParam := TKSBParam.Create;

finalization
  if Assigned(TheKSBParam) then TheKSBParam.Free;

end.

