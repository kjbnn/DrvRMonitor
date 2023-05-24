// {$A-}
unit constants;

interface

type
    TReaderMode = array[0..6] of string;
const 
    ReaderMode : TReaderMode = ('Close','Card','Card/Cod','Card&Cod','Open','Facility','Unknow');

const STATE_TAMPER    = $01;
const STATE_FORCED    = $02;
const STATE_HELD      = $04;
const STATE_AUX       = $08;
const STATE_DOOR_OPEN = $10;
const STATE_BUTTON    = $40;
const STATE_CARD      = $80;

const WAIT_CARD=0;
const WAIT_OPEN_DOOR1=1;
const WAIT_PAUSE_DOOR1=3;
const WAIT_CLOSE_DOOR1=4;
const WAIT_CHECK_BIO=5;
const WAIT_OPEN_DOOR2=6;
const WAIT_PAUSE_DOOR2=7;
const WAIT_CLOSE_DOOR2=8;

const ALARM_OPEN_DOOR1      =9;
const ALARM_PAUSE_DOOR1     =10;
const ALARM_CLOSE_DOOR1     =11;
const ERROR_NOTCLOSE_DOOR1  =12;
const ERROR_NOTCLOSE_DOOR2  =13;
const NOT_OPEN_DOOR1        =2;
const NOT_OPEN_DOOR2        =14;

const BIT_ALWAYS_ARMED                     =1;
const BIT_RESET_ALARM_AFTER_DISARMED       =2;
const BIT_RESET_ALARM_AFTER_READY          =4;
const BIT_OFF                              =8;
const BIT_LOOP                             =16;

const BIT_READY       =1;
const BIT_ARMED       =2;
const BIT_ALARM       =4;
const BIT_BYPASS      =8;
const BIT_ENABLE      =$80;

const TYPEDEVICE_UNKNOW        = 0;
const TYPEDEVICE_RIC           = 1;
const TYPEDEVICE_KBD           = 2;
const TYPEDEVICE_VRIC          = 3;
const TYPEDEVICE_SIGRIC        = 4;
const TYPEDEVICE_TRANE         = 5;
const TYPEDEVICE_GATE          = 6;

const         TYPE_OWNER_FIRES        =7;
const         TYPE_OWNER_CAMERA       =6;
const         TYPE_OWNER_TREE         =5;
const         TYPE_OWNER_GROUP        =4;
const         TYPE_OWNER_VISTA        =3;
const         TYPE_OWNER_ZONE         =2;
const         TYPE_OWNER_READER       =1;
const         TYPE_OWNER_OBJECT       =0;

// Номера модулей КСБ

  const APPLICATION_MESDRIVER           =00;
  const APPLICATION_SUDSERVER           =01;
  const APPLICATION_NBFIND              =02;
  const APPLICATION_NBSERVER            =03;
  const APPLICATION_MESSERVER           =04;
  const APPLICATION_KSBSERVER           =05;
  const APPLICATION_DRAWSERV            =06;
  const APPLICATION_CONFIGOS            =07;
  const APPLICATION_WHATHAPP            =08;
  const APPLICATION_SERVERTV            =09;
  const APPLICATION_KEYBOARDTV          =10;
  const APPLICATION_GAURDIAN            =11;
  const APPLICATION_BAKSHED             =12;
  const APPLICATION_SUDSERVERAAN        =13;
  const APPLICATION_MEGADRIVER          =14;
  const APPLICATION_TRANE               =15;
  const APPLICATION_DRIVERRIC           =16;
  const APPLICATION_GS2001              =17;
  const APPLICATION_CONTROL             =18;
  const APPLICATION_FOTOPOST            =19;
  const APPLICATION_KSBLOADER           =20;
  const APPLICATION_SPRITE              =21;
  const APPLICATION_ANN100              =22;
  const APPLICATION_TESTER              =23;
  const APPLICATION_DRV_VISTA           =24;
  const APPLICATION_DRV_FIRE            =25;
  const APPLICATION_DRV_R7              =26;
  const APPLICATION_DRV_R7_2            =27;
  const APPLICATION_DRV_GATE		=28;
//29
  const APPLICATION_DRV_PCE		=30;
  const APPLICATION_SWORKTIME           =31;
  const APPLICATION_ANN100_2            =32;
  const APPLICATION_DRV_UPSO            =34;
  const APPLICATION_DRV_ARECONT	        =35;
  const APPLICATION_DRV_HWS	        =36;

// Подсистемы КСБ
  const SYSTEM_OPS                      =0;
  const SYSTEM_SUD                      =1;
  const SYSTEM_TV                       =2;
  const SYSTEM_FIRE                     =3;
  const SYSTEM_PROGRAM                  =5;
  const SYSTEM_HWS                      =6;
  const SYSTEM_UPSO                     =7;


  const WORK_MONITOR                            =0;
  const ALARM_MONITOR                           =$4000;

  const ERNITEC_TYPE                    =1; //Бибиков typeDevice для Ernitec
  const ERNITEC_KEYBOARD_TYPE           =5; //Бибиков typeDevice для Ernitec
  const UNIPLEX_TYPE                    =4; //Бибиков typeDevice для UNIPLEX
  const RS_CONT_TYPE                    =0;
  const AAN_CONT_TYPE                   =1;
  const MEGA_CONT_TYPE                  =3;
  const PCE_CONT_TYPE                   =4;
  const RUBEJ_CONT_TYPE                 =99; //bsl, 05.03.2015 - переделать


  const TYPE_HWS_COMPUTER               =0;
  const TYPE_HWS_CPU                    =1;
  const TYPE_HWS_MAINBOARD              =2;
  const TYPE_HWS_HDD                    =3;
  const TYPE_HWS_FAN                    =4;

  const         ZT_NOT_USED                    =00;
  const         ZT_ENTER_EXIT_1                =01;  //10  BURGLARY
  const         ZT_ENTER_EXIT_2                =02;  //11  BURGLARY
  const         ZT_PERIMETR                    =03;  //12  BURGLARY
  const         ZT_INT_FOLLOWER                =04;  //13  BURGLARY
  const         ZT_DAY_NIGTH                   =05;  //14  BURGLARY (TROUBLE)
  const         ZT_HR_SILENT                   =06;  //15  PANIC
  const         ZT_HR_AUDIBLE                  =07;  //16  PANIC
  const         ZT_HR_AUX                      =08;  //17  AUXILARY  (всегда при нарушении тревога, сброс после снятия нарушения)
  const         ZT_FIRE                        =09;  //18  FIRE TRB
  const         ZT_INT_DELAY                   =10;  //19  BURGLARY

  const         ZT_ARMING_STAY                 =20;  //20
  const         ZT_ARMING_AWAY                 =21;  //21
  const         ZT_DISARMING                   =22;  //22
  const         ZT_NO_ALARM                    =23;  //23

{
  const      STATUS_ZONE_NOTBIG     = $1000; // нет информации от BIG
  const      STATUS_ZONE_ALARM      = $2000; //
  const      STATUS_ZONE_NOTACTIVE  = $4000; // ZONE отключена
  const      STATUS_ZONE_NOTLINK    = $8000; // нет информации от ZONE
  const      STATUS_ZONE_BYPASS     = $0004;
  const      STATUS_ZONE_ARMED      = $0002;
  const      STATUS_ZONE_NOTREADY   = $0001;
}

//-----------------------------------------------------------------------------

// Тип считывателя
  const      PASS_READER                       =0;// проход
  const      ENTER_READER                      =1;// выдача
  const      EXIT_READER                       =2;// изъятие
  const      PIN_READER                        =3;// изъятие

  const      PCEBRANCHTYPE                     =4;
  const      PCEREADERTYPE                     =0;// пульт PCE
  const      PCENODETYPE                       =$55; //узел PCE
  const      PCEVARTYPE                        =$57; //переменная PCE
  const      PCEDRIVERTYPE                     =$54; //порт PCE
  const      PCESTRINGTYPE                     =63; //строка PCE
  const      PCESTRINGTYPEDEVICE               =8; //порт PCE
  const      PCEPROGRAMTYPE                    =65; //микропрограмма PCE
  const      PCECOMMANDTYPE                    =75; //


// Состояние считывателя
  const      READER_CLOSE                      =0;
  const      READER_CARD                       =1;
  const      READER_CARD_OR_PIN                =2;
  const      READER_CARD_AND_PIN               =3;
  const      READER_OPEN                       =4;
  const      READER_FACILITY                   =5;
  const      READER_ACCESS_DENIED              =6;
  const      READER_ACCESS_GRANTED             =7;

//-------------------------------------------------------------------------------------------
 const LINK_CLIEN2CARD                 = 3000;
 const MAN_ARMED_GROUP                 = 3010; // $0BC2
 const MAN_DISARMED_GROUP              = 3011; // $0BC3
 const MAN_BYPASS_ZONE                 = 3012; // $0BC4   обход зоны
 const MAN_RESET_BYPASS_ZONE           = 3013; // $0BС5   отмена обхода зоны

 const VIRT_ARMED_GROUP                = 3016; //
 const VIRT_DISARMED_GROUP             = 3017; //
 const VIRT_ALARM_GROUP                = 3018; //
 const VIRT_DISALARM_GROUP             = 3019; //

 const FIND_ELEMENT_ID                 = 3020; //

 //-------------------------------------------------------------------------------------------

 const PRN_LOG_50_FULL                 = 4000;
 const PRN_LOG_90_FULL                 = 4001;
 const PRN_SYSTEM_RESET                = 4002;
 const PRN_LOW_BATTERY                 = 4003;
 const PRN_ARMED                       = 4004;
 const PRN_ARMED_AUTO                  = 4005;
 const PRN_DISARMED                    = 4006;
 const PRN_PANIC                       = 4007;
 const PRN_PNC_RST                     = 4008;
 const PRN_BURGLARY                    = 4009;
 const PRN_BURG_RST                    = 4010;
 const PRN_FIRE_TRB                    = 4011;
 const PRN_FRTR_RST                    = 4012;
 const PRN_RECENT_ARM                  = 4013;
 const PRN_PRINTER_RSTR                = 4014;
 const PRN_PRINTER_FAIL                = 4015;
 const PRN_CANCEL                      = 4016;
 const PRN_AUXILARY                    = 4017;
 const PRN_AUX_RST                     = 4018;
 const PRN_TROUBLE                     = 4019;
 const PRN_TRBL_RST                    = 4020;
 const PRN_FIRE                        = 4021;
 const PRN_FIRE_RST                    = 4022;
 const PRN_BATTERY_FAIL                = 4023;
 const PRN_BYPASS                      = 4024;
 const PRN_BYP_RST                     = 4025;
 const PRN_EXP_SHRT                    = 4026;
 const PRN_EXP_RST                     = 4027;
 const PRN_LOG_OVERFLOW                = 4028;
 const PRN_RPM_SUPR                    = 4029;
 const PRN_RPM_RST                     = 4030;
 const PRN_ARMED_STAY                  = 4031;
 const PRN_TAMPER                      = 4032;
 const PRN_TMPR_RST                    = 4033;
 const PRN_AC_LOSS                     = 4034;
 const PRN_AC_RESTORE                  = 4035;
 const PRN_PROGRM_ENTRY                = 4036;
 const PRN_PROGRAM_EXIT                = 4037;
 const PRN_PROG_CHANGE                 = 4038;
 const PRN_LOW_BATT_RST                = 4039;
 const PRN_USRXX_ADD_BY                = 4040;
 const PRN_USRXX_DEL_BY                = 4041;
 const PRN_LOG_CLEARED                 = 4042;
 const PRN_ARMED_EARLY                 = 4043;
 const PRN_DISRMD_LATE                 = 4044;
 const PRN_ARMED_LATE                  = 4045;
 const PRN_SKED_CHANGE                 = 4046;
 const PRN_FAIL_TO_COMM                = 4047;
 const PRN_DURESS                      = 4048;
 const PRN_ERROR_PROG                  = 4050; // неверный номер раздела в сообщ принт порта <Бибиков>
 const PRN_ERROR_PROG_RST              = 4051; // неверный номер раздела в сообщ принт порта сброшен <Бибиков>

 //------------------------------------------------------------------------------
 const CAM_SHOW_LIVE       = 5105;
 const CAM_ENABLE          = 5106;
 const CAM_DISABLE         = 5107;
 const CAM_FRAME_EXPORT    = 5108;
 const CAM_VIDEO_EXPORT    = 5110;
 const CAM_SET_SUBTITLES   = 5111;
 const CAM_CLEAR_SUBTITLES = 5112;
 const CAM_ARM             = 5113;
 const CAM_DISARM          = 5114;
 const CAM_CONFIG          = 5115;
 const CAM_SHOW_REC        = 5119;
 const CAM_GO_PRESET       = 5121;
 const CAM_START_REC       = 5122;
 const CAM_STOP_REC        = 5123;
 const CAM_SET_FPS         = 5124;
 const CAM_SET_BRIGHT      = 5125;
 const CAM_SET_COLOR       = 5126;
 const CAM_SET_SAT         = 5127;
 const MACRO_RUN           = 5150;
 const MACRO_ENABLE        = 5151;
 const MACRO_DISABLE       = 5152;
 const CAM_ZONE_ENABLE     = 5153;
 const CAM_ZONE_DISABLE    = 5154;
 const MONITOR_CONFIG      = 5155;


 const VIDEO_UNIPLEX_CAMERA_ONOFF      = 5022;
 const VIDEO_UNIPLEX_CAMERA_FAIL       = 5023;
 const VIDEO_SENDKEY_ERNITEC           = 5100;
 const VIDEO_SENDKEY_UNIPLEX           = 5101;
 const VIDEO_CAMERA_FAIL               = 5102;
 const VIDEO_CAMERA_TEST               = 5103;
 const VIDEO_CAMERA_ON                 = 5104;
 const VIDEO_MONITOR                   = 5001;
 const VIDEO_CAMERA                    = 5002;
 const VIDEO_POS                       = 5003;
 const VIDEO_NUM                       = 5004;
 const VIDEO_EMPTY                     = 5005;
 const VIDEO_CAMFIXED                  = 5006;
 const VIDEO_MONNF                     = 5007;
 const VIDEO_REMSYSNV                  = 5008;
 const VIDEO_CAMNV                     = 5009;
 const VIDEO_SEQNF                     = 5010;
 const VIDEO_KBDUM                     = 5011;
 const VIDEO_ADPRO                     = 5012;
 const VIDEO_NOTDEFINED                = 5013;
 const VIDEO_PRESSMON                  = 5014;
 const VIDEO_MONITOR_CAMERA            = 5015;
 const VIDEO_RUN_SCENARY               = 5016;
 const VIDEO_RUN_DVMD_PROGRAM          = 5017;
 const VIDEO_CAMERA_ON_SPOT            = 5018;
 const VIDEO_CAMERA_ON_MAIN            = 5019;

 const VIDEO_SPRITE_ONLINE             = 5020;
 const VIDEO_SPRITE_OFFLINE            = 5021;

 const VIDEO_AV_SET_BRIGHTNESS	       = 5300;
 const VIDEO_AV_SETTED_BRIGHTNESS      = 5301;
 const VIDEO_AV_NOT_SET_BRIGHTNESS     = 5302;
 const VIDEO_AV_SET_SHARPNESS          = 5303;
 const VIDEO_AV_SETTED_SHARPNESS       = 5304;
 const VIDEO_AV_NOT_SET_SHARPNESS      = 5305;
 const VIDEO_AV_SET_SATURATION         = 5306;
 const VIDEO_AV_SETTED_SATURATION      = 5307;
 const VIDEO_AV_NOT_SET_SATURATION     = 5308;
 const VIDEO_AV_SET_BLUE	           = 5309;
 const VIDEO_AV_SETTED_BLUE	           = 5310;
 const VIDEO_AV_NOT_SET_BLUE	       = 5311;
 const VIDEO_AV_SET_RED                = 5312;
 const VIDEO_AV_SETTED_RED             = 5313;
 const VIDEO_AV_NOT_SET_RED            = 5314;
 const VIDEO_AV_SET_ILLUM              = 5315;
 const VIDEO_AV_SETTED_ILLUM           = 5316;
 const VIDEO_AV_NOT_SET_ILLUM          = 5317;
 const VIDEO_AV_SET_FREQ               = 5318;
 const VIDEO_AV_SETTED_FREQ            = 5319;
 const VIDEO_AV_NOT_SET_FREQ           = 5320;
 const VIDEO_AV_SET_LOWLIGHT           = 5321;
 const VIDEO_AV_SETTED_LOWLIGHT        = 5322;
 const VIDEO_AV_NOT_SET_LOWLIGHT       = 5323;
 const VIDEO_AV_SET_ROTATE             = 5324;
 const VIDEO_AV_SETTED_ROTATE          = 5325;
 const VIDEO_AV_NOT_SET_ROTATE         = 5326;
 const VIDEO_AV_SET_AUTOEXP            = 5327;
 const VIDEO_AV_SETTED_AUTOEXP         = 5328;
 const VIDEO_AV_NOT_SET_AUTOEXP        = 5329;
 const VIDEO_AV_SET_EXPWNDLEFT         = 5330;
 const VIDEO_AV_SETTED_EXPWNDLEFT      = 5331;
 const VIDEO_AV_NOT_SET_EXPWNDLEFT     = 5332;
 const VIDEO_AV_SET_EXPWNDTOP          = 5333;
 const VIDEO_AV_SETTED_EXPWNDTOP       = 5334;
 const VIDEO_AV_NOT_SET_EXPWNDTOP      = 5335;
 const VIDEO_AV_SET_EXPWNDWIDTH        = 5336;
 const VIDEO_AV_SETTED_EXPWNDWIDTH     = 5337;
 const VIDEO_AV_NOT_SET_EXPWNDWIDTH    = 5338;
 const VIDEO_AV_SET_EXPWNDHEIGHT       = 5339;
 const VIDEO_AV_SETTED_EXPWNDHEIGHT    = 5340;
 const VIDEO_AV_NOT_SET_EXPWNDHEIGHT   = 5341;
 const VIDEO_AV_SET_SENSORLEFT         = 5342;
 const VIDEO_AV_SETTED_SENSORLEFT      = 5343;
 const VIDEO_AV_NOT_SET_SENSORLEFT     = 5344;
 const VIDEO_AV_SET_SENSORTOP          = 5345;
 const VIDEO_AV_SETTED_SENSORTOP       = 5346;
 const VIDEO_AV_NOT_SET_SENSORTOP      = 5347;
 const VIDEO_AV_SET_SENSORWIDTH        = 5348;
 const VIDEO_AV_SETTED_SENSORWIDTH     = 5349;
 const VIDEO_AV_NOT_SET_SENSORWIDTH    = 5350;
 const VIDEO_AV_SET_SENSORHEIGHT       = 5351;
 const VIDEO_AV_SETTED_SENSORHEIGHT    = 5352;
 const VIDEO_AV_NOT_SET_SENSORHEIGHT   = 5353;
 const VIDEO_AV_SET_IMGLEFT            = 5354;
 const VIDEO_AV_SETTED_IMGLEFT         = 5355;
 const VIDEO_AV_NOT_SET_IMGLEFT        = 5357;
 const VIDEO_AV_SET_IMGTOP             = 5358;
 const VIDEO_AV_SETTED_IMGTOP          = 5359;
 const VIDEO_AV_NOT_SET_IMGTOP         = 5360;
 const VIDEO_AV_SET_IMGWIDTH           = 5361;
 const VIDEO_AV_SETTED_IMGWIDTH        = 5362;
 const VIDEO_AV_NOT_SET_IMGWIDTH       = 5363;
 const VIDEO_AV_SET_IMGHEIGHT          = 5364;
 const VIDEO_AV_SETTED_IMGHEIGHT       = 5365;
 const VIDEO_AV_NOT_SET_IMGHEIGHT      = 5366;
 const VIDEO_AV_SET_IMGQUALITY         = 5367;
 const VIDEO_AV_SETTED_IMGQUALITY      = 5368;
 const VIDEO_AV_NOT_SET_IMGQUALITY     = 5369;
 const VIDEO_AV_SET_IMGRES	           = 5370;
 const VIDEO_AV_SETTED_IMGRES          = 5371;
 const VIDEO_AV_NOT_SET_IMGRES	       = 5372;
 const VIDEO_AV_SET_AUTOIRIS           = 5373;
 const VIDEO_AV_SETTED_AUTOIRIS        = 5374;
 const VIDEO_AV_NOT_SET_AUTOIRIS       = 5375;
 const VIDEO_AV_SET_IRISGAIN           = 5376;
 const VIDEO_AV_SETTED_IRISGAIN        = 5377;
 const VIDEO_AV_NOT_SET_IRISGAIN       = 5378;
 const VIDEO_AV_SET_MOTIONDETECT       = 5379;
 const VIDEO_AV_SETTED_MOTIONDETECT    = 5380;
 const VIDEO_AV_NOT_SET_MOTIONDETECT   = 5381;
 const VIDEO_AV_SET_MDMODE             = 5382;
 const VIDEO_AV_SETTED_MDMODE          = 5383;
 const VIDEO_AV_NOT_SET_MDMODE         = 5384;
 const VIDEO_AV_SET_MDTOTALZONES       = 5385;
 const VIDEO_AV_SETTED_MDTOTALZONES    = 5386;
 const VIDEO_AV_NOT_SET_MDTOTALZONES   = 5387;
 const VIDEO_AV_SET_MDZONESIZE         = 5388;
 const VIDEO_AV_SETTED_MDZONESIZE      = 5389;
 const VIDEO_AV_NOT_SET_MDZONESIZE     = 5390;
 const VIDEO_AV_SET_MDLEVTHR           = 5391;
 const VIDEO_AV_SETTED_MDLEVTHR        = 5392;
 const VIDEO_AV_NOT_SET_MDLEVTHR       = 5393;
 const VIDEO_AV_SET_MDSENSITIVITY      = 5394;
 const VIDEO_AV_SETTED_MDSENSITIVITY   = 5395;
 const VIDEO_AV_NOT_SET_MDSENSITIVITY  = 5396;
 const VIDEO_AV_SET_MDDETAIL           = 5397;
 const VIDEO_AV_SETTED_MDDETAIL        = 5398;
 const VIDEO_AV_NOT_SET_MDDETAIL       = 5399;
 const VIDEO_AV_SET_MDPRIVASYMASK      = 5400;
 const VIDEO_AV_SETTED_MDPRIVASYMASK   = 5401;
 const VIDEO_AV_NOT_SET_MDPRIVASYMASK  = 5402;
 const VIDEO_AV_SET_ADMINPSWD          = 5403;
 const VIDEO_AV_SETTED_ADMINPSWD       = 5404;
 const VIDEO_AV_NOT_SET_ADMINPSWD      = 5405;
 const VIDEO_AV_SET_VIEWERPSWD         = 5406;
 const VIDEO_AV_SETTED_VIEWERPSWD      = 5407;
 const VIDEO_AV_NOT_SET_VIEWERPSWD     = 5408;
 const VIDEO_AV_SET_CROPPING           = 5409;
 const VIDEO_AV_SETTED_CROPPING        = 5410;
 const VIDEO_AV_NOT_SET_CROPPING       = 5411;
 const VIDEO_AV_SET_DAYBINNING         = 5412;
 const VIDEO_AV_SETTED_DAYBINNING      = 5413;
 const VIDEO_AV_NOT_SET_DAYBINNING     = 5414;
 const VIDEO_AV_SET_NIGHTBINNING       = 5415;
 const VIDEO_AV_SETTED_NIGHTBINNING    = 5416;
 const VIDEO_AV_NOT_SET_NIGHTBINNING   = 5417;
 const VIDEO_AV_SET_PMASK              = 5418;
 const VIDEO_AV_SETTED_PMASK           = 5419;
 const VIDEO_AV_NOT_SET_PMASK          = 5420;
 const VIDEO_AV_SET_PMASKLEFT          = 5421;
 const VIDEO_AV_SETTED_PMASKLEFT       = 5422;
 const VIDEO_AV_NOT_SET_PMASKLEFT      = 5423;
 const VIDEO_AV_SET_PMASKTOP           = 5424;
 const VIDEO_AV_SETTED_PMASKTOP        = 5425;
 const VIDEO_AV_NOT_SET_PMASKTOP       = 5426;
 const VIDEO_AV_SET_PMASKRIGHT         = 5427;
 const VIDEO_AV_SETTED_PMASKRIGHT      = 5428;
 const VIDEO_AV_NOT_SET_PMASKRIGHT     = 5429;
 const VIDEO_AV_SET_CASINO             = 5430;
 const VIDEO_AV_SETTED_CASINO          = 5431;
 const VIDEO_AV_NOT_SET_CASINO         = 5432;
 const VIDEO_AV_SET_DAYNIGHT           = 5433;
 const VIDEO_AV_SETTED_DAYNIGHT        = 5434;
 const VIDEO_AV_NOT_SET_DAYNIGHT       = 5435;
 const VIDEO_AV_SET_NIGHTGAIN          = 5436;
 const VIDEO_AV_SETTED_NIGHTGAIN       = 5437;
 const VIDEO_AV_NOT_SET_NIGHTGAIN      = 5438;
 const VIDEO_AV_SET_DAYGAIN            = 5439;
 const VIDEO_AV_SETTED_DAYGAIN         = 5440;
 const VIDEO_AV_NOT_SET_DAYGAIN        = 5441;
 const VIDEO_AV_SET_SHORTEXP           = 5442;
 const VIDEO_AV_SETTED_SHORTEXP        = 5443;
 const VIDEO_AV_NOT_SET_SHORTEXP       = 5444;
 const VIDEO_AV_SET_PMASKBOTTOM        = 5445;
 const VIDEO_AV_SETTED_PMASKBOTTOM     = 5446;
 const VIDEO_AV_NOT_SET_PMASKBOTTOM    = 5447;
 const VIDEO_AV_SET_PMASKBLOCK         = 5448;
 const VIDEO_AV_SETTED_PMASKBLOCK      = 5449;
 const VIDEO_AV_NOT_SET_PMASKBLOCK     = 5450;

 const VIDEO_AV_GET_BRIGHTNESS	       = 5500;
 const VIDEO_AV_GETTED_BRIGHTNESS      = 5501;
 const VIDEO_AV_NOT_GET_BRIGHTNESS     = 5502;
 const VIDEO_AV_GET_SHARPNESS          = 5503;
 const VIDEO_AV_GETTED_SHARPNESS       = 5504;
 const VIDEO_AV_NOT_GET_SHARPNESS      = 5505;
 const VIDEO_AV_GET_SATURATION         = 5506;
 const VIDEO_AV_GETTED_SATURATION      = 5507;
 const VIDEO_AV_NOT_GET_SATURATION     = 5508;
 const VIDEO_AV_GET_BLUE	           = 5509;
 const VIDEO_AV_GETTED_BLUE	           = 5510;
 const VIDEO_AV_NOT_GET_BLUE	       = 5511;
 const VIDEO_AV_GET_RED                = 5512;
 const VIDEO_AV_GETTED_RED             = 5513;
 const VIDEO_AV_NOT_GET_RED            = 5514;
 const VIDEO_AV_GET_ILLUM              = 5515;
 const VIDEO_AV_GETTED_ILLUM           = 5516;
 const VIDEO_AV_NOT_GET_ILLUM          = 5517;
 const VIDEO_AV_GET_FREQ               = 5518;
 const VIDEO_AV_GETTED_FREQ            = 5519;
 const VIDEO_AV_NOT_GET_FREQ           = 5520;
 const VIDEO_AV_GET_LOWLIGHT           = 5521;
 const VIDEO_AV_GETTED_LOWLIGHT        = 5522;
 const VIDEO_AV_NOT_GET_LOWLIGHT       = 5523;
 const VIDEO_AV_GET_ROTATE             = 5524;
 const VIDEO_AV_GETTED_ROTATE          = 5525;
 const VIDEO_AV_NOT_GET_ROTATE         = 5526;
 const VIDEO_AV_GET_AUTOEXP            = 5527;
 const VIDEO_AV_GETTED_AUTOEXP         = 5528;
 const VIDEO_AV_NOT_GET_AUTOEXP        = 5529;
 const VIDEO_AV_GET_EXPWNDLEFT         = 5530;
 const VIDEO_AV_GETTED_EXPWNDLEFT      = 5531;
 const VIDEO_AV_NOT_GET_EXPWNDLEFT     = 5532;
 const VIDEO_AV_GET_EXPWNDTOP          = 5533;
 const VIDEO_AV_GETTED_EXPWNDTOP       = 5534;
 const VIDEO_AV_NOT_GET_EXPWNDTOP      = 5535;
 const VIDEO_AV_GET_EXPWNDWIDTH        = 5536;
 const VIDEO_AV_GETTED_EXPWNDWIDTH     = 5537;
 const VIDEO_AV_NOT_GET_EXPWNDWIDTH    = 5538;
 const VIDEO_AV_GET_EXPWNDHEIGHT       = 5539;
 const VIDEO_AV_GETTED_EXPWNDHEIGHT    = 5540;
 const VIDEO_AV_NOT_GET_EXPWNDHEIGHT   = 5541;
 const VIDEO_AV_GET_SENSORLEFT         = 5542;
 const VIDEO_AV_GETTED_SENSORLEFT      = 5543;
 const VIDEO_AV_NOT_GET_SENSORLEFT     = 5544;
 const VIDEO_AV_GET_SENSORTOP          = 5545;
 const VIDEO_AV_GETTED_SENSORTOP       = 5546;
 const VIDEO_AV_NOT_GET_SENSORTOP      = 5547;
 const VIDEO_AV_GET_SENSORWIDTH        = 5548;
 const VIDEO_AV_GETTED_SENSORWIDTH     = 5549;
 const VIDEO_AV_NOT_GET_SENSORWIDTH    = 5550;
 const VIDEO_AV_GET_SENSORHEIGHT       = 5551;
 const VIDEO_AV_GETTED_SENSORHEIGHT    = 5552;
 const VIDEO_AV_NOT_GET_SENSORHEIGHT   = 5553;
 const VIDEO_AV_GET_IMGLEFT            = 5554;
 const VIDEO_AV_GETTED_IMGLEFT         = 5555;
 const VIDEO_AV_NOT_GET_IMGLEFT        = 5557;
 const VIDEO_AV_GET_IMGTOP             = 5558;
 const VIDEO_AV_GETTED_IMGTOP          = 5559;
 const VIDEO_AV_NOT_GET_IMGTOP         = 5560;
 const VIDEO_AV_GET_IMGWIDTH           = 5561;
 const VIDEO_AV_GETTED_IMGWIDTH        = 5562;
 const VIDEO_AV_NOT_GET_IMGWIDTH       = 5563;
 const VIDEO_AV_GET_IMGHEIGHT          = 5564;
 const VIDEO_AV_GETTED_IMGHEIGHT       = 5565;
 const VIDEO_AV_NOT_GET_IMGHEIGHT      = 5566;
 const VIDEO_AV_GET_IMGQUALITY         = 5567;
 const VIDEO_AV_GETTED_IMGQUALITY      = 5568;
 const VIDEO_AV_NOT_GET_IMGQUALITY     = 5569;
 const VIDEO_AV_GET_IMGRES	           = 5570;
 const VIDEO_AV_GETTED_IMGRES          = 5571;
 const VIDEO_AV_NOT_GET_IMGRES	       = 5572;
 const VIDEO_AV_GET_AUTOIRIS           = 5573;
 const VIDEO_AV_GETTED_AUTOIRIS        = 5574;
 const VIDEO_AV_NOT_GET_AUTOIRIS       = 5575;
 const VIDEO_AV_GET_IRISGAIN           = 5576;
 const VIDEO_AV_GETTED_IRISGAIN        = 5577;
 const VIDEO_AV_NOT_GET_IRISGAIN       = 5578;
 const VIDEO_AV_GET_MOTIONDETECT       = 5579;
 const VIDEO_AV_GETTED_MOTIONDETECT    = 5580;
 const VIDEO_AV_NOT_GET_MOTIONDETECT   = 5581;
 const VIDEO_AV_GET_MDMODE             = 5582;
 const VIDEO_AV_GETTED_MDMODE          = 5583;
 const VIDEO_AV_NOT_GET_MDMODE         = 5584;
 const VIDEO_AV_GET_MDTOTALZONES       = 5585;
 const VIDEO_AV_GETTED_MDTOTALZONES    = 5586;
 const VIDEO_AV_NOT_GET_MDTOTALZONES   = 5587;
 const VIDEO_AV_GET_MDZONESIZE         = 5588;
 const VIDEO_AV_GETTED_MDZONESIZE      = 5589;
 const VIDEO_AV_NOT_GET_MDZONESIZE     = 5590;
 const VIDEO_AV_GET_MDLEVTHR           = 5591;
 const VIDEO_AV_GETTED_MDLEVTHR        = 5592;
 const VIDEO_AV_NOT_GET_MDLEVTHR       = 5593;
 const VIDEO_AV_GET_MDSENSITIVITY      = 5594;
 const VIDEO_AV_GETTED_MDSENSITIVITY   = 5595;
 const VIDEO_AV_NOT_GET_MDSENSITIVITY  = 5596;
 const VIDEO_AV_GET_MDDETAIL           = 5597;
 const VIDEO_AV_GETTED_MDDETAIL        = 5598;
 const VIDEO_AV_NOT_GET_MDDETAIL       = 5599;
 const VIDEO_AV_GET_MDPRIVASYMASK      = 5600;
 const VIDEO_AV_GETTED_MDPRIVASYMASK   = 5601;
 const VIDEO_AV_NOT_GET_MDPRIVASYMASK  = 5602;
 const VIDEO_AV_GET_ADMINPSWD          = 5603;
 const VIDEO_AV_GETTED_ADMINPSWD       = 5604;
 const VIDEO_AV_NOT_GET_ADMINPSWD      = 5605;
 const VIDEO_AV_GET_VIEWERPSWD         = 5606;
 const VIDEO_AV_GETTED_VIEWERPSWD      = 5607;
 const VIDEO_AV_NOT_GET_VIEWERPSWD     = 5608;
 const VIDEO_AV_GET_CROPPING           = 5609;
 const VIDEO_AV_GETTED_CROPPING        = 5610;
 const VIDEO_AV_NOT_GET_CROPPING       = 5611;
 const VIDEO_AV_GET_DAYBINNING         = 5612;
 const VIDEO_AV_GETTED_DAYBINNING      = 5613;
 const VIDEO_AV_NOT_GET_DAYBINNING     = 5614;
 const VIDEO_AV_GET_NIGHTBINNING       = 5615;
 const VIDEO_AV_GETTED_NIGHTBINNING    = 5616;
 const VIDEO_AV_NOT_GET_NIGHTBINNING   = 5617;
 const VIDEO_AV_GET_PMASK              = 5618;
 const VIDEO_AV_GETTED_PMASK           = 5619;
 const VIDEO_AV_NOT_GET_PMASK          = 5620;
 const VIDEO_AV_GET_CASINO             = 5630;
 const VIDEO_AV_GETTED_CASINO          = 5631;
 const VIDEO_AV_NOT_GET_CASINO         = 5632;
 const VIDEO_AV_GET_DAYNIGHT           = 5633;
 const VIDEO_AV_GETTED_DAYNIGHT        = 5634;
 const VIDEO_AV_NOT_GET_DAYNIGHT       = 5635;
 const VIDEO_AV_GET_NIGHTGAIN          = 5636;
 const VIDEO_AV_GETTED_NIGHTGAIN       = 5637;
 const VIDEO_AV_NOT_GET_NIGHTGAIN      = 5638;
 const VIDEO_AV_GET_DAYGAIN            = 5639;
 const VIDEO_AV_GETTED_DAYGAIN         = 5640;
 const VIDEO_AV_NOT_GET_DAYGAIN        = 5641;
 const VIDEO_AV_GET_SHORTEXP           = 5642;
 const VIDEO_AV_GETTED_SHORTEXP        = 5643;
 const VIDEO_AV_NOT_GET_SHORTEXP       = 5644;
 const VIDEO_AV_GET_PMASKBOTTOM        = 5645;

 const VIDEO_AV_GET_JIMAGE             = 5701;
 const VIDEO_AV_GETTED_JIMAGE          = 5702;
 const VIDEO_AV_NOT_GET_JIMAGE         = 5703;
 const VIDEO_AV_GET_MJPEG              = 5705;
 const VIDEO_AV_GETTED_MJPEG           = 5706;
 const VIDEO_AV_NOT_GET_MJPEG          = 5707;
 const VIDEO_AV_SAVE                   = 5708;
 const VIDEO_AV_SAVED		           = 5709;
 const VIDEO_AV_NOT_SAVED	           = 5710;
 const VIDEO_AV_REC_MAC                = 5711;
 const VIDEO_AV_RECD_MAC               = 5712;
 const VIDEO_AV_NOT_RECD_MAC           = 5713;
 const VIDEO_AV_REC_MAKE               = 5714;
 const VIDEO_AV_RECD_MAKE              = 5715;
 const VIDEO_AV_NOT_RECD_MAKE          = 5716;
 const VIDEO_AV_REC_MODEL              = 5717;
 const VIDEO_AV_RECD_MODEL             = 5718;
 const VIDEO_AV_NOT_RECD_MODEL         = 5719;
 const VIDEO_AV_REC_FW                 = 5720;
 const VIDEO_AV_RECD_FW                = 5721;
 const VIDEO_AV_NOT_RECD_FW            = 5722;
 const VIDEO_AV_REC_PROC               = 5723;
 const VIDEO_AV_RECD_PROC              = 5724;
 const VIDEO_AV_NOT_RECD_PROC          = 5725;
 const VIDEO_AV_REC_NETVER             = 5726;
 const VIDEO_AV_RECD_NETVER            = 5727;
 const VIDEO_AV_NOT_RECD_NETVER        = 5728;
 const VIDEO_AV_REC_REVISION           = 5729;
 const VIDEO_AV_RECD_REVISION          = 5730;
 const VIDEO_AV_NOT_RECD_REVISION      = 5731;
 const VIDEO_AV_FACTORYRESET           = 5732;
 const VIDEO_AV_FACTORYRESETED         = 5733;
 const VIDEO_AV_NOT_FACTORYRESETED     = 5734;
 const VIDEO_AV_GET_MDRESULT           = 5736;
 const VIDEO_AV_GETTED_MDRESULT        = 5737;
 const VIDEO_AV_NOT_GET_MDRESULT       = 5738;

 const VIDEO_AV_LOW_CODE               = 5300;
 const VIDEO_AV_HIGH_CODE              = 5800;
 const VIDEO_AV_START_SET_CODE         = 5300;
 const VIDEO_AV_STOP_SET_CODE          = 5499;
 const VIDEO_AV_START_GET_CODE         = 5500;
 const VIDEO_AV_STOP_GET_CODE          = 5699;

//-----------------------------------------------------------------------------

 const SUD_SETTED_LEVEL                = 255;
 const SUD_SETTED_MASK                 = 254;
 const OUT_SET                         = 253;
 const SUD_TIMEZONE_SETTED             = 252;
 const CONNECT_SET                     = 251;
 const SUD_BAD_PARAM                   = 250;
 const TRYLINK                         = 249;
 const START                           = 248;
 const HANGLOW                         = 247;
 const HANGHIGH                        = 246;
 const NOTNETDEVICE                    = 245;
 const RESTORE_NETDEVICE               = 244;
 const LOST_NETDEVICE                  = 243;
 const LOST_COMMAND_RIC                = 242;
 const SUD_CHANGE_GATE                 = 241;
 const NOT_ARMED_ZONE                  = 240;
 const SUD_TAMPER                      = 239;
 const SUD_RESET_TAMPER                = 238;
 const SUD_GRANTED_BUTTON              = 237;
 const SUD_BAD_WEIGHT                  = 236;
 const COMMAND_OPEN_DOOR               = 235;
 const SUD_CHANGE_GATE2                = 234;
 const SUD_GETTED_RIC_MODE	           = 226;
 const SUD_DOOR_OPENED		           = 1217;
 const SUD_DOOR_CLOSED		           = 1218;
 const SUD_ACCESS_VIOL		           = 1025;
 const SUD_ACCESS_VIOL_NOT_ENTER       = 1034;
 const SUD_ACCESS_VIOL_FAIL	           = 1040;
 const SUD_OK_ENTER                    = 1032;
 const SUD_OK_NOT_ENTER                = 1033;

 const ANTI_SET                        = 228;
 const NOTADDCARD_SET                  = 226;
 const SETCOMPUTER                     = 225;
 const LOSTCOMPUTER                    = 224;

 const SUD_AUX1                        = 223;
 const SUD_HELD                        = 222;
 const SUD_FORCED                      = 221;
 const SUD_RESET_HELD                  = 220;
 const SUD_RESET_FORCED                = 219;
 const SUD_DOOR_CLOSE                  = 218;
 const SUD_DOOR_OPEN                   = 217;
 const SUD_DOOR_NOT_OPEN	           = 1033;
 const SUD_RIC_SETTED_MODE	           = 250;

 const ANTI_COM                        = 209;
 const SUD_RESET_AUX1                  = 208;

 const SUD_LOST_LINK_READER            = 195;
 const SUD_SET_LINK_READER             = 194;
 const BRANCH_UNSIGNED                 = 193;
 const START_RS90                      = 192;
 const RIC_MODE                        = 191;
 const BEGIN_COMMAND                   = 139;
 const END_COMMAND                     = 140;

 const SUD_ACCESS_GRANTED              = 131;
 const SUD_BAD_FACILITY                = 132;
 const SUD_BAD_CARD_FORMAT             = 133;
 const SUD_NO_CARD                     = 134;
 const SUD_CALC_TIMEZONE               = 135;
 const SUD_BAD_PIN                     = 136;
 const SUD_BAD_LEVEL                   = 138;
 const SUD_BAD_APB                     = 148;
 const FIX_BAD_MAN                     = 149;
 const FIX_APB_MAN                     = 150;
 const GET_APB_MAN                     = 151;

 const SUD_PASSAGE_GRANTED             = 2001;
 const SUD_PASSAGE_FAIL                = 2002;
 const SUD_SET_READER_MODE             = 6000;
 const SUD_GET_MODE_READER             = 6001;
 const SUD_ADD_CARD                    = 6002;
 const SUD_DEL_CARD                    = 6003;
 const GLOBAL_ADD_CARD                 = 6102;
 const GLOBAL_DEL_CARD                 = 6103;
 const SUD_SET_DATETIME                = 6004;
 const SUD_SETTED_DATETIME             = 232;//6005;
 const SUD_FIX_NEWCARD                 = 233;
 const SUD_ADDED_CARD                  = 230;//6006;
 const SUD_DELETED_CARD                = 229;//6007;
 const SUD_SET_HOLIDAY                 = 6008;
 const SUD_SETTED_HOLIDAY              = 231;
 const SUD_SET_MASK                    = 6009;
 const SUD_SET_READER_FULL             = 6011;
 const SUD_GET_READER_DATABASE         = 6012;
 const SUD_SET_LEVEL                   = 6013;
 const SUD_SET_LEVELS                  = 6014;
 const SUD_LOAD_LOGIC_LEVEL            = 6015;
 const SUD_SET_TIMEZONE                = 6016;
 const SUD_SET_TIMEZONES               = 6017;
 const SUD_CHANGE_BRANCH               = 6018;
 const SUD_GRANTED_FACILITY            = 130;
 const SUD_GRANTED_FACILITY_NO_ENTER   = 129;
 const SUD_OBJECT_IN_ZONE	           = 6998;
 const SUD_OBJECT_OUT_ZONE	           = 6999;

 const SUD_TEST                        = 170;
 const AAN100_SET_TIMEZONE             = 6019;
 const AAN100_SET_LEVEL                = 6020;
 const AAN100_SET_MASK                 = 6021;
 const AAN100_SET_DATE                 = 6022;
 const AAN100_W_READER                 = 6023;
 const AAN100_W_FORMAT                 = 6024;
 const SUD_ACCESS_DENIED               = 6025;
 const SUD_ACCESS_CHOOSE               = 6026;
 const SUD_UNKNOW_MESSAGE              = 6027;
 const AAN100_SET_HOLIDAY              = 6030;
 const AAN100_WW_FORMAT                = 6031;
 const DRIVERRIC_REQUEST               = 6032;
 const DRIVERRIC_GRANTED               = 6033;
 const DRIVERRIC_DENIED                = 6034;
 const DRIVERRIC_ERROR                 = 6035;
 const SUD_ADD_PCEDEVICE               = 6120;
 const SUD_DEL_PCEDEVICE               = 6121;
 const SUD_ADD_PCEDRIVER               = 6122;
 const SUD_DEL_PCEDRIVER               = 6123;
 const SUD_ADD_PCENODE                 = 6124;
 const SUD_DEL_PCENODE                 = 6125;
 const SUD_ADD_PCERIGHT                = 6126;
 const SUD_DEL_PCERIGHT                = 6127;
 const SUD_ADD_PCECOMMAND              = 6128;
 const SUD_DEL_PCECOMMAND              = 6129;
 const SUD_ADD_PCEPROG                 = 6130;
 const SUD_DEL_PCEPROG                 = 6131;
 const SUD_ADD_PCESTRING               = 6132;
 const SUD_DEL_PCESTRING               = 6133;
 const SUD_RUN_PCEPROGRAM              = 6134;

 const SUD_LINK_STATE                  = 6038;
 const SUD_TAMPER_STATE                = 6039;
 const SUD_FORCE_STATE                 = 6040;
 const SUD_HELD_STATE                  = 6041;
 const SUD_AUX_STATE                   = 6042;
 const SUD_READ_STATE                  = 6043;
 const SUD_MODE_STATE                  = 6044;
 const SUD_DOWNLOAD_CARDS              = 6045;
 const SUD_RESET_APB_CARD              = 6046;
 const SUD_DOWNLOADED_CARDS            = 6047;

 const SUD_FIND_METAL                  = 6048;
 const SUD_ONE_MAN                     = 6049;
 const SUD_SET_TIMEZONERD              = 6050;
 const SUD_SETTED_TIMEZONERD           = 6051;

//------------------------------------------------------------------------------

  const         SWITCH_PLAN                       =99;

  const         LOST_LINK_TAGET                   =7000;
  const         SET_LINK_TAGET                    =7001;

  const         SUD_RIC_COMMAND                   = 6052;
  const         SUD_FAST_MODE                     = 6053;
  const         SUD_FULL_PCE_CONFIG               = 6135;

  const         KEYBOARD_DRAW                     =7011;
  const         REQUEST_KEYBOARD_ARMED            =7012;
  const         REQUEST_KEYBOARD_DISARMED         =7013;
  const         REQUEST_KEYBOARD_STATUS           =7015;

  const         START_PROGRAM                     = 7014;
  const         STOP_PROGRAM                      = 7017;//программа остановлена
  const         NET_TEST                          = 7034;//
  const         KILL_PROGRAM                      = 7022;//убить программу
  const         RESTORE_LIVE_PROGRAM              = 7023;//
  const         CHECK_LIVE_PROGRAM                = 7025;//
  const         LOST_LIVE_PROGRAM                 = 7026;//
  const         I_LIVE_PROGRAM                    = 7027;//
  const         SET_TIME                          = 7028;//
  const         EXIT_PROGRAM                      = 7029;//оставить программу

  const         CONTROLSTATE_ERROR_ARMED          = 7023;//
  const         CONTROLSTATE_OK_ARMED             = 7024;//
  const         CONTROLSTATE_ERROR_DISARMED       = 7032;//
  const         CONTROLSTATE_OK_DISARMED          = 7033;//

  const         LOST_CONNECT_CONFIGOS             = 7032;//

  const         KEYVISTA_PART_READY               = 4100; // раздел готов
  const         KEYVISTA_PART_NOTREADY            = 4101; // раздел не готов
  const         KEYVISTA_PART_ARMED               = 4102; // раздел под охраной
  const         KEYVISTA_PART_DISARMED            = 4103; // раздел без охраны

  const         STATE_PART_ARMED                  = 4104; // блок данных содержит биты охраны разделов
  const         STATE_PART_READY                  = 4105; // блок данных содержит готовности разделов
  const         STATE_ZONE_ENABLED                = 4106; // зарезервировано
  const         STATE_ZONE_READY                  = 4107; // блок данных содержит готовности зон

  const         COMMAND_PART_ARMED                = 4108; // поставить на охрану
  const         COMMAND_PART_DISARMED             = 4109; // снять с охраны
  const         COMMAND_ZONE_BYPASS               = 4110; // обход зоны

  const         KEYVISTA_ZONE_ALARM               = 4111; // зона в тревоге
  const         KEYVISTA_ZONE_CHECK               = 4112; // зона не исправна
  const         KEYVISTA_ZONE_FAULT               = 4113; // зона не готова
  const         KEYVISTA_ZONE_BYPASS              = 4114; // зона в BYPASSe

  const         KEYVISTA_LOBAT                    = 4115; // низкое напряжение на батарее
  const         KEYVISTA_OKBAT                    = 4116; // батарея в норме
  const         PANEL_REFRESH                     = 4117; // запрос на чтение состояний зон и разделов ( драйвер отвечает STATE_... )
  const         COMMAND_VISTA_CONFIG              = 4118; // конфигурация зон (данные по зонам в разделе и тип реакции)
  const         STATE_ZONE_ALARM                  = 4119; // блок данных содержит тревоги зон
  const         KEYVISTA_ZONE_ALARM_RESET         = 4120; // тревога в зоне сброшена
  const         KEYVISTA_ZONE_READY               = 4121; // зона готова
  const         KEYVISTA_PART_BYPASS              = 4122; // раздел в BYPASS
  const         STATE_PART_BYPASS                 = 4123; // блок данных содержит биты BYPASS разделов
  const         KEYVISTA_ZONE_BYPASS_RESET        = 4124; // зона в BYPASSe сброс
  const         STATE_ZONE_BYPASS                 = 4125; // блок данных содержит BYPASS зон

  const         COMMAND_DISARMED_ZONE             = 4126; // снять зону с охраны
  const         COMMAND_ARMED_ZONE                = 4127; // поставить зону на охрану
  const         KEYVISTA_ZONE_CHECK_RESET         = 4128; //
  const         KEYVISTA_ZONE_ARMED               = 4129; // зона под охраной
  const         KEYVISTA_ZONE_DISARMED            = 4130; // зона без охраны

  const         KEYBOARD_FAILED                   = 4131; //
  const         KEYBOARD_RESTORE                  = 4132; //
  const         VIRT_ALARM_ZONE                   = 4133; // отображена системой мониторинга
  const         VISTA_ENABLED_ZONE                = 4134; // запрос состояния запрограммированых зон

  const         PRN_SILENT_PANIC                  = 4135; // генерится по PRN_PANIC после анализа типа зоны
  const         PRN_AUDIBLE_PANIC                 = 4136; // генерится по PRN_PANIC после анализа типа зоны

  const         KEYVISTA_PART_BYPASS_RESET        = 4137; // раздел вышел из  BYPASS
  const         VIRT_ARMED_ZONE                   = 4138; // отображена системой мониторинга
  const         VIRT_DISARMED_ZONE                = 4139; // отображена системой мониторинга

  const         STATE_ZONE_ARMED                  = 4140; // блок данных содержит биты охраны зон
  const         STATE_PART_ALARM                  = 4141; // блок данных содержит биты тревоги разделов

  const         KEYVISTA_PART_ALARM               = 4142; // тревога в разделе
  const         KEYVISTA_PART_ALARM_RESET         = 4143; // отбой тревога в разделе
  const         KEYVISTA_PART_FAULT               = 4144; // нарушение в разделе
  const         KEYVISTA_PART_FAULT_RESET         = 4145; // отбой нарушения в разделе
  const         KEYVISTA_PART_CHECK               = 4146; // неисправность в разделе
  const         KEYVISTA_PART_CHECK_RESET         = 4147; // отбой неисправности в разделе
  const         KEYVISTA_ZONE_FAULT_RESET         = 4148; // тревога в зоне сброшена

  const         STATE_PART_CHECK                  = 4149; // блок данных содержит биты неисправности разделов
  const         STATE_PART_FAULT                  = 4150; // блок данных содержит биты нарушений разделов

  const         STATE_ZONE_CHECK                  = 4151; // блок данных содержит биты неисправности зон
  const         STATE_ZONE_FAULT                  = 4152; // блок данных содержит биты нарушений зон
  const         STATE_VISTA                       = 4153;
  const         KEY_PRINTER_RSTR                  = 4154;
  const         KEY_PRINTER_FAIL                  = 4155;
  const         KEY_ERROR_PROG                    = 4156;

  const         KEYVISTA_AC_LOSS                  = 4157; // низкое напряжение на батарее
  const         KEYVISTA_AC_OK                    = 4158; // батарея в норме
  const         KEYVISTA_ZONE_ATTENTION           = 4159;
  const         COMMAND_ZONE_RESET_ALARM          = 4160;
  const         COMMAND_READ_PART                 = 4161;
  const         COMMAND_READ_ZONE                 = 4162;
  const         KEY_ERROR_PROG_RST                = 4163; // неверный номер раздела в сообщ клав порта сброшен <Бибиков>

  const         VST_ARMED                         = 4204;
  const         VST_DISARMED                      = 4206;
  const         PANEL_RESTART                     = 4207;
  const         VISTA_STATE                       = 4208;

  const         MEGA_ZONE_READY                   = 1001;
  const         MEGA_ZONE_NOT_READY               = 1002;
  const         MEGA_ZONE_ARMED                   = 1003;
  const         MEGA_ZONE_DISARMED                = 1004;
  const         MEGA_ZONE_ALARM                   = 1005;
  const         MEGA_ZONE_ALARM_RESET             = 1006;
  const         MEGA_ZONE_BYPASS                  = 1007;
  const         MEGA_ZONE_BYPASS_RESET            = 1008;

  const         FIRE_START                        = 8000;

//---------------------- Рубеж-08 ------------------------

  const         R8_CONNECT_FALSE                   = 9100;         //Потеря связи с панелью+
  const         R8_CONNECT_TRUE                    = 9101;         //Восстановление связи с панелью+
  const         R8_PANEL_FALSE                     = 9102;         //Отказ панели+
  const         R8_PANEL_TRUE                      = 9103;         //Панель в норме+
  const         R8_COMMAND_PANEL_REFRESH           = 9104;         //Запрос на чтение состояний зон и разделов ( драйвер отвечает STATE_... )+
  const         R8_COMMAND_SH_ARMED                = 9105;         //Поставить на охрану зону+
  const         R8_COMMAND_SH_DISARMED             = 9106;         //Снять с охраны зону+
  const         R8_COMMAND_SH_BYPASS_ON            = 9107;         //Обход зоны включен+
  const         R8_COMMAND_SH_BYPASS_OFF           = 9108;         //Обход зоны выключен+
  const         R8_COMMAND_SH_ALARM_RESET          = 9109;         //Сбросить тревогу зоны+
  const         R8_SH_ARMED                        = 9110;         //ШС под охраной+
  const         R8_SH_DISARMED                     = 9111;         //ШС без охраны+
  const         R8_SH_READY                        = 9112;         //ШС готова+
  const         R8_SH_NOTREADY                     = 9113;         //ШС не готова+
  const         R8_SH_CHECK                        = 9114;         //ШС не исправна+
  const         R8_SH_ALARM                        = 9115;         //ШС в тревоге+
  const         R8_SH_ALARM_RESET                  = 9116;         //ШС тревога сброшена+
  const         R8_SH_BYPASS_ON                    = 9117;         //ШС в BYPASSe+
  const         R8_SH_BYPASS_OFF                   = 9118;         //ШС вышла из BYPASSа+
  const         R8_SH_CONNECT_ON                   = 9119;         //ШС связь ON+
  const         R8_SH_CONNECT_OFF                  = 9120;         //ШС связь OFF+
  const         R8_STATE_SH_ENABLED                = 9121;         //Блок данных содержит доступные ШС+
  const         R8_STATE_SH_READY                  = 9122;         //Блок данных содержит готовности ШС+
  const         R8_STATE_SH_ALARM                  = 9123;         //Блок данных содержит биты тревожных ШС+
  const         R8_STATE_SH_BYPASS                 = 9124;         //Блок данных содержит биты ШС в байпассе+
  const         R8_STATE_SH_ARMED                  = 9125;         //Блок данных содержит биты ШС под охранной+
  const         R8_STATE_SH_CHECK                  = 9126;         //Блок данных содержит биты неисправности ШС+
  const         R8_STATE_SH_CONNECT                = 9127;         //Блок данных содержит биты на связи ШС+
  const         R8_COMMAND_ZONE_ARMED              = 9128;         //Зона поставить на охрану+
  const         R8_COMMAND_ZONE_DISARMED           = 9129;         //Зона снять с охраны+
  const         R8_ZONE_ARMED                      = 9130;         //Зона под охраной+
  const         R8_ZONE_DISARMED                   = 9131;         //Зона без охраны+
  const         R8_ZONE_READY                      = 9132;         //Зона готова+
  const         R8_ZONE_NOTREADY                   = 9133;         //Зона не готова+
  const         R8_ZONE_CHECK                      = 9134;         //Зона не исправен+
  const         R8_ZONE_ALARM                      = 9135;         //Зона в тревоге+
  const         R8_ZONE_ALARM_RESET                = 9136;         //Зона тревога сброшена+
  const         R8_ZONE_BYPASS_ON                  = 9137;         //Зона в BYPASSe+
  const         R8_ZONE_BYPASS_OFF                 = 9138;         //Зона вышла из BYPASSа+
  const         R8_STATE_ZONE_READY                = 9139;         //Блок данных содержит готовности зон+
  const         R8_STATE_ZONE_ALARM                = 9140;         //Блок данных содержит биты тревожных зон+
  const         R8_STATE_ZONE_CHECK                = 9141;         //Блок данных содержит биты неисправности зон+
  const         R8_STATE_ZONE_ARMED                = 9142;         //Блок данных содержит биты охраны зон+
  const         R8_STATE_ZONE_BYPASS               = 9143;         //Блок данных содержит биты байпасных зон+
  const         R8_CU_CONNECT_OFF                  = 9144;         //СУ потеря связи+
  const         R8_CU_CONNECT_ON                   = 9145;         //СУ восстановление связи+
  const         R8_STATE_CU_CONNECT                = 9146;         //Блок данных содержит байты состяний СУ (0,1-адрес, 2-состояние <0-off, 1-on>)
  const         R8_COMMAND_RELAY_OFF               = 9147;         //Реле выключить+
  const         R8_COMMAND_RELAY_ON                = 9148;         //Реле включить+
  const         R8_RELAY_OFF                       = 9149;         //Реле выключено+
  const         R8_RELAY_ON                        = 9150;         //Реле включено+
  const         R8_RELAY_CONNECT_ON                = 9151;         //Реле связь ON+
  const         R8_RELAY_CONNECT_OFF               = 9152;         //Реле связь OFF+
  const         R8_STATE_RELAY_ON                  = 9153;         //Блок данных содержит байты включенных реле
  const         R8_STATE_RELAY_CONNECT             = 9154;         //Блок данных содержит байты на связи реле
  const         R8_UPS_ACCESS                      = 9155;         //вскрытие корпуса ИБП-
  const         R8_UPS_OUT1_BAD                    = 9156;         //ИБП неисправность выхода 1+
  const         R8_UPS_OUT1_OK                     = 9157;         //ИБП восстановление выхода 1+
  const         R8_UPS_OUT2_BAD                    = 9158;         //ИБП неисправность выхода 2+
  const         R8_UPS_OUT2_OK                     = 9159;         //ИБП восстановление выхода 2+
  const         R8_UPS_IN220_BAD                   = 9160;         //ИБП неисправность входа 220+
  const         R8_UPS_IN220_OK                    = 9161;         //ИБП восстановление входа 220+
  const         R8_UPS_BAT_BAD                     = 9162;         //ИБП неисправность БА+
  const         R8_UPS_BAT_OK                      = 9163;         //ИБП восстановление БА+
  const         R8_UPS_RESERV_ON                   = 9164;         //ИБП переход на резерв+
  const         R8_UPS_RESERV_OFF                  = 9165;         //ИБП воостановление питания 220+
  const         R8_UPS_BAT_DISCONNECT              = 9166;         //ИБП отключение БА+
  const         R8_UPS_BAT_CONNECT                 = 9167;         //ИБП подключение БА+
  const         R8_USER_ENTER                      = 9168;         //Пользователь в сеансе+
  const         R8_USER_EXIT                       = 9169;         //Пользователь из сеанса+
  const         R8_POWER_UP                        = 9170;         //Питание включено+
  const         R8_POWER_DOWN                      = 9171;         //Питание выключено+
  const         R8_ENTER_CONF                      = 9172;         //Вход в конфигурирование БЦП+
  const         R8_UNKNOWN_USER                    = 9173;         //Ошибка авторизации оператора+
  const         R8_LOCK_KEYBOARD                   = 9174;         //Блокировка клавиауты БЦП при авторизации+
  const         R8_ALARM_OPEN                      = 9175;         //Вскрытие корпуса БЦП+
  const         R8_RESERV_POWER                    = 9176;         //Переход на резервное питание+
  const         R8_NORMAL_POWER                    = 9177;         //Восстановление сетевого питания+
  const         R8_RESET_CONF                      = 9178;         //Возврат к заводским установкам+
  const         R8_SYNC_TIME                       = 9179;         //Синхронизация часов БЦП+
  const         R8_TERM_ON                         = 9180;         //Терминал открыт+
  const         R8_TERM_OFF                        = 9181;         //Терминал закрыт+
  const         R8_TERM_CONNECT_ON                 = 9182;         //Терминал связь ON+
  const         R8_TERM_CONNECT_OFF                = 9183;         //Терминал связь OFF+
  const         R8_OBJECT_OFF                      = 9184;         //Объект отключен+
  const         R8_DRV_READY                       = 9185;         //Драйвер готов к работе
  const         R8_CU_ACCESS                       = 9186;         //вскрытие корпуса СУ+
  const         R8_SMALL_CONNECT_FALSE             = 9187;         //Кратковременная потеря связи с панелью+
  const         R8_SH_NORIGTH                      = 9188;         //Нет прав на управление ШС
  const         R8_RELAY_NORIGTH                   = 9189;         //Нет прав на управление реле
  const         R8_TERM_NORIGTH                    = 9190;         //Нет прав на управление терминалом

  const         R8_COMMAND_CU_CREATE               = 9200;         //СУ создать+
  const         R8_COMMAND_CU_CHANGE               = 9201;         //СУ редактировать+
  const         R8_COMMAND_CU_DELETE               = 9202;         //СУ удалить+
  const         R8_COMMAND_CU_CONFIG               = 9203;         //СУ запрос конфигурации+
  const         R8_CU_CREATE                       = 9204;         //СУ создано+
  const         R8_CU_CHANGE                       = 9205;         //СУ редактировано+
  const         R8_CU_DELETE                       = 9206;         //СУ удалено+
  const         R8_CU_CONFIG                       = 9207;         //СУ конфигурация+
  const         R8_COMMAND_ZONE_CREATE             = 9208;         //Зона создать+
  const         R8_COMMAND_ZONE_CHANGE             = 9209;         //Зона редактировать+
  const         R8_COMMAND_ZONE_DELETE             = 9210;         //Зона удалить+
  const         R8_COMMAND_ZONE_NAME_DELETE        = 9211;         //Зона по имени удалить+
  const         R8_COMMAND_ZONE_CONFIG             = 9212;         //Зона запрос конфигурации+
  const         R8_ZONE_CREATE                     = 9213;         //Зона создана+
  const         R8_ZONE_CHANGE                     = 9214;         //Зона редактирована+
  const         R8_ZONE_DELETE                     = 9215;         //Зона удалена+
  const         R8_ZONE_CONFIG                     = 9216;         //Зона конфигурация+
  const         R8_COMMAND_SH_CREATE               = 9217;         //ШС создать+
  const         R8_COMMAND_SH_CHANGE               = 9218;         //ШС редактировать+
  const         R8_COMMAND_SH_DELETE               = 9219;         //ШС удалить+
  const         R8_COMMAND_SH_SERNUM_DELETE        = 9220;         //ШС удалить по sernum+
  const         R8_COMMAND_SH_CONFIG               = 9221;         //ШС запрос конфигурации+
  const         R8_SH_CREATE                       = 9222;         //ШС создан+
  const         R8_SH_CHANGE                       = 9223;         //ШС редактирован+
  const         R8_SH_DELETE                       = 9224;         //ШС удален+
  const         R8_SH_CONFIG                       = 9225;         //ШС конфигурация+
  const         R8_COMMAND_USER_CREATE             = 9226;         //Пользователь создать+
  const         R8_COMMAND_USER_CHANGE             = 9227;         //Пользователь редактировать+
  const         R8_COMMAND_USER_DELETE             = 9228;         //Пользователь удалить+
  const         R8_USER_CREATE                     = 9229;         //Пользователь создан+
  const         R8_USER_CHANGE                     = 9230;         //Пользователь редактирован+
  const         R8_USER_DELETE                     = 9231;         //Пользователь удален+
  const         R8_COMMAND_TZ_CREATE               = 9232;         //ВЗ создать+
  const         R8_COMMAND_TZ_CHANGE               = 9233;         //ВЗ редактировать+
  const         R8_COMMAND_TZ_DELETE               = 9234;         //ВЗ удалить+
  const         R8_TZ_CREATE                       = 9235;         //ВЗ создана+
  const         R8_TZ_CHANGE                       = 9236;         //ВЗ редактирована+
  const         R8_TZ_DELETE                       = 9237;         //ВЗ удалена+
  const         R8_COMMAND_RELAY_CREATE            = 9238;         //Реле создать
  const         R8_COMMAND_RELAY_CHANGE            = 9239;         //Реле редактировать
  const         R8_COMMAND_RELAY_DELETE            = 9240;         //Реле удалить
  const         R8_COMMAND_RELAY_CONFIG            = 9254;         //Реле запрос конфигурации
  const         R8_RELAY_CREATE                    = 9241;         //Реле создано+
  const         R8_RELAY_CHANGE                    = 9242;         //Реле редактировано+
  const         R8_RELAY_DELETE                    = 9243;         //Реле удалено+
  const         R8_RELAY_CONFIG                    = 9255;         //Реле конфигурация+
  const         R8_COMMAND_SETTIME                 = 9244;         //Время установить+
  const         R8_SETTIME                         = 9245;         //Время установлено+
  const         R8_COMMAND_GETTIME                 = 9246;         //Время запросить+
  const         R8_GETTIME                         = 9247;         //Время выдано+
  const         R8_COMMAND_UD_CREATE               = 9248;         //УД создать+
  const         R8_COMMAND_UD_CHANGE               = 9249;         //УД редактировать+
  const         R8_COMMAND_UD_DELETE               = 9250;         //УД удалить+
  const         R8_UD_CREATE                       = 9251;         //УД создан+
  const         R8_UD_CHANGE                       = 9252;         //УД редактирован+
  const         R8_UD_DELETE                       = 9253;         //УД удален+
  const         R8_BAD_ARGUMENT                    = 9300;         //неверный агрумент

  const         SUD_ERR_ADDED_CARD                = 259;
  const         SUD_ERR_DELETED_CARD              = 258;
  const         PCE_OUTPUT_ENABLED                = 242;
  const         PCE_OUTPUT_DISABLED               = 257;
  const         PCE_INPUT_ENABLED                 = 217;
  const         PCE_INPUT_ARMED                   = 932;
  const         PCE_INPUT_DISARMED                = 933;
  const         PCE_BLOCKED_USER			      = 934;
  const         PCE_RDR_ADDED                     = 260;
  const         PCE_RDR_CHANGED                   = 261;
  const         PCE_RDR_DELETED                   = 262;
  const         PCE_RDR_ERR_ADDED                 = 263;
  const         PCE_RDR_ERR_CHANGED               = 264;
  const         PCE_RDR_ERR_DELETED               = 265;

  const PCE_INPUT_ADDED                   = 266;
  const PCE_INPUT_CHANGED                 = 267;
  const PCE_INPUT_DELETED                 = 268;
  const PCE_INPUT_ERR_ADDED               = 269;
  const PCE_INPUT_ERR_CHANGED             = 270;
  const PCE_INPUT_ERR_DELETED             = 271;

  const PCE_OUTPUT_ADDED                  = 272;
  const PCE_OUTPUT_CHANGED                = 273;
  const PCE_OUTPUT_DELETED                = 274;
  const PCE_OUTPUT_ERR_ADDED              = 275;
  const PCE_OUTPUT_ERR_CHANGED            = 276;
  const PCE_OUTPUT_ERR_DELETED            = 277;

  const PCE_DSPL_ADDED                    = 278;
  const PCE_DSPL_CHANGED                  = 279;
  const PCE_DSPL_DELETED                  = 280;
  const PCE_DSPL_ERR_ADDED                = 281;
  const PCE_DSPL_ERR_CHANGED              = 282;
  const PCE_DSPL_ERR_DELETED              = 283;

  const PCE_PART_CREATED                  = 284;
  const PCE_PART_CHANGED                  = 285;
  const PCE_PART_DELETED                  = 286;
  const PCE_PART_ERR_CREATED              = 287;
  const PCE_PART_ERR_CHANGED              = 288;
  const PCE_PART_ERR_DELETED              = 289;

  const PCE_PART_ADDED_DEVICE             = 290;
  const PCE_PART_DELETED_DEVICE           = 291;
  const PCE_PART_ERR_ADDED_DEVICE         = 292;
  const PCE_PART_ERR_DELETED_DEVICE       = 293;

  const PCE_RLIST_CREATED                 = 294;
  const PCE_RLIST_DELETED                 = 295;
  const PCE_RLIST_ERR_CREATED             = 296;
  const PCE_RLIST_ERR_DELETED             = 297;

  const PCE_RLIST_ITEM_ADDED              = 298;
  const PCE_RLIST_ITEM_CLEARED            = 299;
  const PCE_RLIST_ITEM_CHANGED            = 300;
  const PCE_RLIST_ERR_ITEM_ADDED          = 301;
  const PCE_RLIST_ERR_ITEM_CLEARED        = 302;
  const PCE_RLIST_ERR_ITEM_CHANGED        = 303;

  const PCE_RDR_ADDED_COMMAND             = 304;
  const PCE_RDR_DELETED_COMMAND           = 305;
  const PCE_RDR_ERR_ADDED_COMMAND         = 306;
  const PCE_RDR_ERR_DELETED_COMMAND       = 307;

  const PCE_RIGHT_ADDED                   = 308;
  const PCE_RIGHT_DELETED                 = 309;
  const PCE_RIGHT_CHANGED                 = 310;
  const PCE_RIGHT_ERR_ADDED               = 311;
  const PCE_RIGHT_ERR_DELETED             = 312;
  const PCE_RIGHT_ERR_CHANGED             = 313;

  const PCE_TS_CREATED                    = 314;
  const PCE_TS_DELETED                    = 315;
  const PCE_TS_ERR_CREATED                = 316;
  const PCE_TS_ERR_DELETED                = 317;

  const PCE_TS_DAY_ADDED                  = 318;
  const PCE_TS_DAY_DELETED                = 319;
  const PCE_TS_DAY_ERR_ADDED              = 320;
  const PCE_TS_DAY_ERR_DELETED            = 321;

  const PCE_TS_REG_ADDED                  = 322;
  const PCE_TS_REG_DELETED                = 323;
  const PCE_TS_ERR_REG_ADDED              = 324;
  const PCE_TS_ERR_REG_DELETED            = 325;

  const PCE_TS_VDAY_ADDED                 = 326;
  const PCE_TS_VDAY_DELETED               = 327;
  const PCE_TS_VDAY_ERR_ADDED             = 328;
  const PCE_TS_VDAY_ERR_DELETED           = 329;

  const PCE_TZ_CREATED                    = 330;
  const PCE_TZ_DELETED                    = 331;
  const PCE_TZ_ERR_CREATED                = 332;
  const PCE_TZ_ERR_DELETED                = 333;

  const PCE_TZ_TI_ADDED                   = 334;
  const PCE_TZ_TI_DELETED                 = 335;
  const PCE_TZ_ERR_TI_ADDED               = 336;
  const PCE_TZ_ERR_TI_DELETED             = 337;

  const PCE_TI_CREATED                    = 338;
  const PCE_TI_DELETED                    = 339;
  const PCE_TI_CHANGED                    = 340;
  const PCE_TI_ERR_CREATED                = 350;
  const PCE_TI_ERR_DELETED                = 351;
  const PCE_TI_ERR_CHANGED                = 352;

  const PCE_VDAY_CREATED                  = 353;
  const PCE_VDAY_DELETED                  = 354;
  const PCE_VDAY_CHANGED                  = 355;
  const PCE_VDAY_ERR_CREATED              = 356;
  const PCE_VDAY_ERR_DELETED              = 357;
  const PCE_VDAY_ERR_CHANGED              = 358;

  const PCE_OPERCMD_CREATED               = 359;
  const PCE_OPERCMD_DELETED               = 360;
  const PCE_OPERCMD_CHANGED               = 361;
  const PCE_OPERCMD_ERR_CREATED           = 362;
  const PCE_OPERCMD_ERR_DELETED           = 363;
  const PCE_OPERCMD_ERR_CHANGED           = 364;

  const PCE_PROGRAMM_CREATED              = 365;
  const PCE_PROGRAMM_DELETED              = 366;
  const PCE_PROGRAMM_CLEARED              = 367;
  const PCE_PROGRAMM_ERR_CREATED          = 368;
  const PCE_PROGRAMM_ERR_DELETED          = 369;
  const PCE_PROGRAMM_ERR_CLEARED          = 370;
  const PCE_PROGRAMM_INST_ADDED           = 372;
  const PCE_PROGRAMM_INST_ERR_ADDED       = 373;

  const PCE_TRS_CREATED                   = 374;
  const PCE_TRS_DELETED                   = 375;
  const PCE_TRS_ERR_CREATED               = 376;
  const PCE_TRS_ERR_DELETED               = 377;
  const PCE_TRS_TI_ADDED                  = 378;
  const PCE_TRS_TI_DELETED                = 379;
  const PCE_TRS_ERR_TI_ADDED              = 380;
  const PCE_TRS_ERR_TI_DELETED            = 381;

  const PCE_VAR_CREATED                   = 920;
  const PCE_VAR_DELETED                   = 921;
  const PCE_VAR_CHANGED                   = 922;
  const PCE_VAR_ERR_CREATED               = 923;
  const PCE_VAR_ERR_DELETED               = 924;
  const PCE_VAR_ERR_CHANGED               = 925;

  const PCE_VOBJ_CREATED                  = 926;
  const PCE_VOBJ_DELETED                  = 927;
  const PCE_VOBJ_ERR_CREATED              = 928;
  const PCE_VOBJ_ERR_DELETED              = 929;

  const PCE_STRING_CREATED                = 382;
  const PCE_STRING_DELETED                = 383;
  const PCE_STRING_CHANGED                = 384;
  const PCE_STRING_ERR_CREATED            = 385;
  const PCE_STRING_ERR_DELETED            = 386;
  const PCE_STRING_ERR_CHANGED            = 387;

  const PCE_ADGROUP_CREATED               = 388;
  const PCE_ADGROUP_DELETED               = 389;
  const PCE_ADGROUP_ERR_CREATED           = 390;
  const PCE_ADGROUP_ERR_DELETED           = 391;
  const PCE_ADGROUP_DSPL_ADDED            = 392;
  const PCE_ADGROUP_DSPL_DELETED          = 393;
  const PCE_ADGROUP_DSPL_ERR_ADDED        = 394;
  const PCE_ADGROUP_DSPL_ERR_DELETED      = 395;

  const PCE_ALGCLASS_CREATED              = 396;
  const PCE_ALGCLASS_DELETED              = 397;
  const PCE_ALGCLASS_CHANGED              = 398;
  const PCE_ALGCLASS_ERR_CREATED          = 399;
  const PCE_ALGCLASS_ERR_DELETED          = 400;
  const PCE_ALGCLASS_ERR_CHANGED          = 401;

  const PCE_ALGORITHM_CREATED             = 402;
  const PCE_ALGORITHM_DELETED             = 403;
  const PCE_ALGORITHM_CHANGED             = 404;
  const PCE_ALGORITHM_ERR_CREATED         = 405;
  const PCE_ALGORITHM_ERR_DELETED         = 406;
  const PCE_ALGORITHM_ERR_CHANGED         = 407;

  const PCE_EVT_CFG_CHANGED               = 408;
  const PCE_EVT_CFG_DELETED               = 409;
  const PCE_EVT_CFG_ERR_CHANGED           = 410;
  const PCE_EVT_CFG_ERR_DELETED           = 411;
  const PCE_EVT_CFG_ARR_CHANGED           = 412;
  const PCE_EVT_CFG_ERR_ARR_CHANGED       = 413;

  const PCE_CONTROLLER_CREATED            = 414;
  const PCE_CONTROLLER_DELETED            = 415;
  const PCE_CONTROLLER_CHANGED            = 416;
  const PCE_CONTROLLER_CLEARED            = 417;
  const PCE_CONTROLLER_ERR_CREATED        = 418;
  const PCE_CONTROLLER_ERR_DELETED        = 419;
  const PCE_CONTROLLER_ERR_CHANGED        = 420;
  const PCE_CONTROLLER_ERR_CLEARED        = 421;
  const PCE_CONTROLLER_COMMAND_ADDED      = 422;
  const PCE_CONTROLLER_COMMAND_DELETED    = 423;
  const PCE_CONTROLLER_ERR_COMMAND_ADDED  = 424;
  const PCE_CONTROLLER_ERR_COMMAND_DELETED= 425;
  const PCE_CONTROLLER_ARRCOMMAND_ADDED   = 426;
  const PCE_CONTROLLER_ERR_ARRCOMMAND_ADDED=427;

  const PCE_DRIVER_CREATED                = 428;
  const PCE_DRIVER_DELETED                = 429;
  const PCE_DRIVER_CHANGED                = 430;
  const PCE_DRIVER_ERR_CREATED            = 431;
  const PCE_DRIVER_ERR_DELETED            = 432;
  const PCE_DRIVER_ERR_CHANGED            = 433;
  const PCE_DRIVER_NODE_ADDED             = 434;
  const PCE_DRIVER_NODE_DELETED           = 435;
  const PCE_DRIVER_NODE_ERR_ADDED         = 436;
  const PCE_DRIVER_NODE_ERR_DELETED       = 437;

  const PCE_HANDLER_SETTED                = 438;
  const PCE_HANDLER_DELETED               = 439;
  const PCE_HANDLER_ERR_SETTED            = 440;
  const PCE_HANDLER_ERR_DELETED           = 441;

  const PCE_SYSCONFIG_GETTED              = 900;
  const PCE_SYSCONFIG_SETTED              = 901;
  const PCE_SYSTIME_GETTED                = 902;
  const PCE_SYSCONFIG_CLEANED             = 904;
  const PCE_SYSTIME_STARTED               = 905;
  const PCE_SYSTIME_FINISHED              = 906;

  const PCE_ERR_SYSCONFIG_GETTED          = 907;
  const PCE_ERR_SYSCONFIG_SETTED          = 908;
  const PCE_ERR_SYSTIME_GETTED            = 909;
  const SUD_ERR_SETTED_DATETIME           = 910;
  const PCE_ERR_SYSCONFIG_CLEANED         = 911;
  const PCE_ERR_SYSTIME_STARTED           = 912;
  const PCE_ERR_SYSTIME_FINISHED          = 913;

  const PCE_KEY_PRESSED			        = 914;
  const PCE_KEY_UNPRESSED			        = 915;
  const PCE_ILLEGIAL_CMD                  = 916;
  const PCE_UNKNOWN_CMD                   = 917;
  const PCE_READER_BLOCKED                = 918;
  const PCE_READER_DEBLOCKED              = 919;
  const PCE_NOCONFIG_READER               = 930;
  const PCE_FORMAT_ERROR_RDR		        = 931;

  const PCE_CODE_MIN                     = 18000;
  const PCE_CODE_MAX                     = 18999;

  const PCE_DRV_NOTCONNECT               = 18000;
  const PCE_DRV_READY                    = 18001;
  const PCE_CONNECT                      = 18002; //поключение к панели
  const PCE_DISCONNECT                   = 18003; //отключение от панели

  //пользователь
  const PCE_USER_CREATE                  = 18007; //добавить пользователя
  const PCE_USER_DELETE                  = 18008; //удалить пользовтаеля
  const PCE_USER_CHANGE                  = 18009; //изменить
  //раздел
  const PCE_PART_CREATE                  = 18010; //создать
  const PCE_PART_DELETE                  = 18011; //удалить
  const PCE_PART_CHANGE                  = 18012; //изменить
  const PCE_PART_ADD_DEV                 = 18013; //добавить устройство
  const PCE_PART_DEL_DEV                 = 18014; //удалить устройство
  //область
  const PCE_AREA_CREATE                  = 18015;
  const PCE_AREA_DELETE                  = 18016;
  const PCE_AREA_CHANGE                  = 18017;
  //считыватель
  const PCE_RDR_CREATE                   = 18018;
  const PCE_RDR_DELETE                   = 18019;
  const PCE_RDR_CHANGE                   = 18020;
  const PCE_RDR_ADD_CMD                  = 18021; //разрешить команду
  const PCE_RDR_DEL_CMD                  = 18022; //запретить команду
  //вход
  const PCE_INPUT_CREATE                 = 18023;
  const PCE_INPUT_DELETE                 = 18024;
  const PCE_INPUT_CHANGE                 = 18025;
  //выход
  const PCE_OUTPUT_CREATE                = 18026;
  const PCE_OUTPUT_DELETE                = 18027;
  const PCE_OUTPUT_CHANGE                = 18028;
  //дисплей
  const PCE_DISPLAY_CREATE               = 18029;
  const PCE_DISPLAY_DELETE               = 18030;
  const PCE_DISPLAY_CHANGE               = 18031;
  //группа тревожных дисплеев
  const PCE_DSPLGRP_CREATE               = 18032;
  const PCE_DSPLGRP_DELETE               = 18033;
  const PCE_DSPLGRP_ADD                  = 18034;
  const PCE_DSPLGRP_CLEAR                = 18035;
  //строка
  const PCE_STRING_CREATE                = 18036;
  const PCE_STRING_DELETE                = 18037;
  const PCE_STRING_CHANGE                = 18038;
  //полномочие
  const PCE_RLIST_CREATE                 = 18039;
  const PCE_RLIST_DELETE                 = 18040;
  const PCE_RLIST_ADD                    = 18041; //add item
  const PCE_RLIST_CLEAR                  = 18042; //delete item
  const PCE_RLIST_CHANGE                 = 18043; //change item
  //права
  const PCE_RIGHT_CREATE                 = 18044;
  const PCE_RIGHT_DELETE                 = 18045;
  const PCE_RIGHT_CHANGE                 = 18046;
  //раписание
  const PCE_TS_CREATE                    = 18047;
  const PCE_TS_DELETE                    = 18048;
  const PCE_TS_ADD_DAY                   = 18049; //добавить день
  const PCE_TS_DEL_DAY                   = 18050; //удалить день
  const PCE_TS_ADD_REG                   = 18051; //добавить регулярное расписание
  const PCE_TS_DEL_REG                   = 18052; //удалить регулярное расписание
  const PCE_TS_ADD_VDAY                  = 18053; //добавить виртуальный день
  const PCE_TS_DEL_VDAY                  = 18054; //удалить виртуальный день
  //временная зона
  const PCE_TZ_CREATE                    = 18055;
  const PCE_TZ_DELETE                    = 18056;
  const PCE_TZ_ADD_TI                    = 18057; //добавить временной интервал
  const PCE_TZ_DEL_TI                    = 18058; //удалить временной интервал
  //временной интервал
  const PCE_TI_CREATE                    = 18059;
  const PCE_TI_DELETE                    = 18060;
  const PCE_TI_CHANGE                    = 18061;
  //виртуальный день
  const PCE_VDAY_CREATE                  = 18062;
  const PCE_VDAY_DELETE                  = 18063;
  const PCE_VDAY_CHANGE                  = 18064;
  //регулярное расписание
  const PCE_REG_CREATE                   = 18065;
  const PCE_REG_DELETE                   = 18066;
  const PCE_REG_ADD                      = 18067; //добавить item
  const PCE_REG_CLEAR                    = 18068; //удалить item
  //микропрограмма
  const PCE_PRG_CREATE                   = 18069;
  const PCE_PRG_DELETE                   = 18070;
  const PCE_PRG_ADD                      = 18071;
  const PCE_PRG_CLEAR                    = 18072;
  //команды оператора
  const PCE_OPERCMD_CREATE               = 18073;
  const PCE_OPERCMD_DELETE               = 18074;
  const PCE_OPERCMD_CHANGE               = 18075;
  //переменная
  const PCE_VARIABLE_CREATE              = 18076;
  const PCE_VARIABLE_DELETE              = 18077;
  const PCE_VARIABLE_CHANGE              = 18078;
  //виртуальный объект
  const PCE_VOBJECT_CREATE               = 18079;
  const PCE_VOBJECT_DELETE               = 18080;
  //алгоритм
  const PCE_ALG_CREATE                   = 18081;
  const PCE_ALG_DELETE                   = 18082;
  const PCE_ALG_CHANGE                   = 18083;
  //класс алгоритмов
  const PCE_CLSALG_CREATE                = 18084;
  const PCE_CLSALG_DELETE                = 18085;
  const PCE_CLSALG_ADD                   = 18086;
  //система
  const PCE_SYSCONFIG_GET                = 18087; //запрос конфигурации
  const PCE_SYSCONFIG_SET                = 18112;
  const PCE_GET_TIME                     = 18088; //запрос времени
  const PCE_SET_TIME                     = 18089; //установка времени
  const PCE_START_CFG                    = 18090; //старт конфигурации
  const PCE_STOP_CFG                     = 18091; //стоп конфигурации
  const PCE_FULL_CLEAR                   = 18092; //полная очистка конфигурации
  //событие
  const PCE_EVT_CHANGE                   = 18093;
  const PCE_EVT_DELETE                   = 18097;    
  const PCE_EVT_ARRCHANGE                = 18098;
  //панель
  const PCE_PANEL_CREATE                 = 18099;
  const PCE_PANEL_DELETE                 = 18100;
  const PCE_PANEL_CHANGE                 = 18101;
  const PCE_PANEL_CLEAR                  = 18102;
  const PCE_PANEL_SETLOCAL               = 18103; //разрешить команду
  const PCE_PANEL_DELLOCAL               = 18104; //запредить команду
  //драйвер шины
  const PCE_DRIVER_CREATE                = 18105;
  const PCE_DRIVER_DELETE                = 18106;
  const PCE_DRIVER_CHANGE                = 18107;
  const PCE_DRIVER_ADD                   = 18108; //добавить node
  const PCE_DRIVER_CLEAR                 = 18109; //удалить node
  //все
  const PCE_SET_HANDLER                  = 18110;
  const PCE_CLEAR_HANDLER                = 18111;

  //команды управления
  const PCE_DOOR_CONTROL                 = 18200;
  const PCE_DOOR_OPEN                    = 1;
  const PCE_DOOR_CLOSE                   = 0;
  const PCE_SET_READER_MODE              = 18201;
  //неисправность!
  const PCE_MULFUNCTION			 = 18300;

  const PCE_ALL                          = 18999;

  //мониторинг аппаратного обеспечения
  const HWS_LOW_CODE                     = 7100;
  const HWS_HIGH_CODE                    = 7200;

  const HWS_MON_STARTED                  = 7100;

  const HWS_TEMP_NORMAL                  = 7101;
  const HWS_TEMP_ALARM                   = 7102;
  const HWS_FAN_NORMAL                   = 7103;
  const HWS_FAN_ALARM                    = 7104;
  const HWS_VOLT_NORMAL                  = 7105;
  const HWS_VOLT_ALARM                   = 7106;
  const HWS_DISK_NORMAL                  = 7107;
  const HWS_DISK_ALARM                   = 7108;

  const HWS_GET_TEMP                     = 7110;
  const HWS_GETTED_TEMP                  = 7111;
  const HWS_NOT_GET_TEMP                 = 7112;
  const HWS_GET_FAN                      = 7113;
  const HWS_GETTED_FAN                   = 7114;
  const HWS_NOT_GET_FAN                  = 7115;
  const HWS_GET_VOLT                     = 7116;
  const HWS_GETTED_VOLT                  = 7117;
  const HWS_NOT_GET_VOLT                 = 7118;
  const HWS_GET_DISK_STATE               = 7119;
  const HWS_GETTED_DISK_STATE            = 7120;
  const HWS_NOT_GET_DISK_STATE           = 7121;

  const HWS_NOT_SPEEDFAN                 = 7130;

implementation

end.
