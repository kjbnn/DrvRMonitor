{$A-}
unit cRights;

interface

function GetDriveSerialNumber(drive : integer) : string;

implementation

uses Windows,SysUtils;

type
    IDEREGS=record
        bFeaturesReg : BYTE;
        bSectorCountReg : BYTE;
        bSectorNumberReg : BYTE;
        bCylLowReg : BYTE;
        bCylHighReg : BYTE;
        bDriveHeadReg : BYTE;
        bCommandReg : BYTE;
        bReserved : BYTE;
end;

type
    SENDCMDINPARAMS=record
        cBufferSize : DWORD;
        irDriveRegs : IDEREGS;
        bDriveNumber : BYTE;
        bReserved : array[0..2]  of BYTE;
        dwReserved : array[0..3] of DWORD;
        bBuffer : array[0..1] of BYTE;
end;

type
    PSENDCMDINPARAMS=^SENDCMDINPARAMS;

type
    DRIVERSTATUS=record
        bDriverError : BYTE;
        bIDEStatus : BYTE;
        bReserved : array[0..1]  of BYTE;
        dwReserved : array[0..1] of DWORD;
end;

type
    SENDCMDOUTPARAMS=record
        cBufferSize : DWORD;
        DriverStatus : DRIVERSTATUS;
        bBuffer : array[0..1] of WORD;
end;

type
    PSENDCMDOUTPARAMS=^SENDCMDOUTPARAMS;

type
    GETVERSIONOUTPARAMS=record
        bVersion : BYTE;
        bRevision : BYTE;
        bReserved : BYTE;
        bIDEDeviceMap : BYTE;
        fCapabilities : DWORD;
        dwReserved : array[0..3] of DWORD;
end;

const  IDE_ATAPI_IDENTIFY=$A1;
const  IDE_ATA_IDENTIFY=$EC;
const  DFP_GET_VERSION=$00074080;
const  DFP_RECEIVE_DRIVE_DATA=$0007c088;
const  IDENTIFY_BUFFER_SIZE=512;

var
    IdOutCmd : array[0..sizeof(SENDCMDOUTPARAMS) + IDENTIFY_BUFFER_SIZE - 1] of BYTE;
//-----------------------------------------------------------------------------

function DoIDENTIFY(hPhysicalDriveIOCTL : DWORD; pSCIP : PSENDCMDINPARAMS; pSCOP : PSENDCMDOUTPARAMS; bIDCmd : BYTE; bDriveNum : BYTE; var lpcbBytesReturned : DWORD) : bool;
begin
    pSCIP.cBufferSize:=IDENTIFY_BUFFER_SIZE;
    pSCIP.irDriveRegs.bFeaturesReg := 0;
    pSCIP.irDriveRegs.bSectorCountReg := 1;
    pSCIP.irDriveRegs.bSectorNumberReg := 1;
    pSCIP.irDriveRegs.bCylLowReg := 0;
    pSCIP.irDriveRegs.bCylHighReg := 0;
    pSCIP.irDriveRegs.bDriveHeadReg := $A0 + ((bDriveNum and 1) shl 4);
    pSCIP.irDriveRegs.bCommandReg := bIDCmd;
    pSCIP.bDriveNumber := bDriveNum;
    pSCIP.cBufferSize := IDENTIFY_BUFFER_SIZE;

    result:=DeviceIoControl (hPhysicalDriveIOCTL, DFP_RECEIVE_DRIVE_DATA,
               pSCIP,
               sizeof(SENDCMDINPARAMS) - 1,
               pSCOP,
               sizeof(SENDCMDOUTPARAMS) + IDENTIFY_BUFFER_SIZE - 1,
               lpcbBytesReturned,nil);
end;

//-----------------------------------------------------------------------------

function GetDriveSerialNumber(drive : integer):string;
var
    i : integer;
    DriveName : string;
    hPhysicalDriveIOCTL : DWORD;
    cbBytesReturned : DWORD;
    n : DWORD;
    bIDCmd : BYTE;
    scip : SENDCMDINPARAMS;
    VersionParams : GETVERSIONOUTPARAMS;
    p : WORD;
    str : string;
begin
    Result:='';
    driveName:=Format('\\.\PhysicalDrive%d',[drive]);
    hPhysicalDriveIOCTL:=CreateFile(
    PChar(@DriveName[1]),GENERIC_READ + GENERIC_WRITE,
    FILE_SHARE_READ + FILE_SHARE_WRITE,nil,OPEN_EXISTING,0,0);
    if(hPhysicalDriveIOCTL=INVALID_HANDLE_VALUE) then
        exit;
    FillChar(VersionParams,sizeof(GETVERSIONOUTPARAMS),0);
    cbBytesReturned:=0;
    n:=sizeof(VersionParams);
    if(not DeviceIoControl(hPhysicalDriveIOCTL,DFP_GET_VERSION,nil,0,Pointer(@VersionParams),n,cbBytesReturned,nil)) then
      begin
        exit;
      end;
    if(VersionParams.bIDEDeviceMap > 0) then
      begin
        if((VersionParams.bIDEDeviceMap shr drive) and $10)>0 then
            bIDCmd:=IDE_ATAPI_IDENTIFY else  bIDCmd:=IDE_ATA_IDENTIFY;
        FillChar(scip,sizeof(scip),0);
        FillChar(IdOutCmd,sizeof(IdOutCmd),0);
        if(DoIDENTIFY(hPhysicalDriveIOCTL,@scip,@IdOutCmd,bIDCmd,drive,cbBytesReturned)) then
          begin
            str:='';
            i:=10;
            while i<=19 do
              begin
                p:=PSENDCMDOUTPARAMS(@IdOutCmd).bBuffer[i];
                str:=str+Format('%s%s',[Char(integer(p shr 8)),Char(integer(p and $FF))]);
                Inc(i);
              end;
            Result:=Trim(str);
          end;
      end;
    CloseHandle(hPhysicalDriveIOCTL);
end;
//-----------------------------------------------------------------------------
end.
