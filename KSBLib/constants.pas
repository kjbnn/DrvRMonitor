{R08}

unit constants;

interface

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
const TYPEDEVICE_VRIC          = 3;
const TYPEDEVICE_KBD           = 2;
const TYPEDEVICE_SIGRIC        = 4;
const TYPEDEVICE_TRANE         = 5;

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
  const APPLICATION_DRV_DS1820          =25;
  const APPLICATION_DRV_R7              =26;
  const APPLICATION_DRV_R7_2            =27;
  const APPLICATION_DRV_R8              =29;  
  const APPLICATION_ANN100_2            =32;
  const APPLICATION_S20                 =33;

// Подсистемы КСБ
  const SYSTEM_OPS                      =0;
  const SYSTEM_SUD                      =1;
  const SYSTEM_TV                       =2;
  const SYSTEM_PROGRAM                  =5;
  const SYSTEM_KLIMAT                   =6;

  const WORK_MONITOR                            =0;
  const ALARM_MONITOR                           =$4000;

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

 const MAN_ARMED_GROUP                 = 3010; // $0BC2
 const MAN_DISARMED_GROUP              = 3011; // $0BC3
 const MAN_BYPASS_ZONE                 = 3012; // $0BC4   обход зоны
 const MAN_RESET_BYPASS_ZONE           = 3013; // $0BС5   отмена обхода зоны

 const VIRT_ARMED_GROUP                = 3016; //
 const VIRT_DISARMED_GROUP             = 3017; //
 const VIRT_ALARM_GROUP                = 3018; //
 const VIRT_DISALARM_GROUP             = 3019; //

 const FIND_ELEMENT_IN_GROUP           = 3020; //

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

 //------------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------
 const SUD_AUX1_RIC                    = 223;
 const SUD_RESETAUX1_RIC               = 208;
 const SUD_SET_LINK_READER             = 194;
 const SUD_LOST_LINK_READER            = 195;

 const OUT_SET	                       = 253;
 const SUD_TIMEZONE_SETTED             = 252;
 const CONNECT_SET                     = 251;
 const TRYLINK                         = 249;
 const START                           = 248;
 const HANGLOW                         = 247;
 const HANGHIGH                        = 246;
 const NOTNETDEVICE                    = 245;
 const RESTORE_NETDEVICE               = 244;
 const LOST_NETDEVICE                  = 243;

 const ANTI_SET                        = 228;
 const NOTADDCARD_SET                  = 226;
 const SETCOMPUTER                     = 225;
 const LOSTCOMPUTER                    = 224;
 const SUD_GRANTED_BUTTON              = 237;
 const SUD_HELD                        = 222;
 const SUD_FORCED                      = 221;
 const SUD_RESETHELD                   = 220;
 const SUD_RESETFORCED                 = 219;

 const SUD_OK_ENTER                    = 1032; //Проход совершен
 const SUD_OK_NOT_ENTER                = 1033; //Проход не совершен
 const SUD_DOOR_CLOSE                  = {1}218;
 const SUD_DOOR_OPEN                   = {1}217;
 const SUD_LOCK_CLOSE                  = 1257;
 const SUD_LOCK_OPEN                   = 1242;

 const ANTI_COM                        = 209;
 const BRANCH_UNSIGNED                 = 193;
 const START_RS90                      = 192;
 const RIC_MODE                        = 191;
 const BEGIN_COMMAND                   = 139;
 const END_COMMAND                     = 140;

 const SUD_GRANTED_FACILITY            = 130; 
 const SUD_ACCESS_GRANTED              = 131;
 const SUD_BAD_FACILITY                = 132;
 const SUD_BAD_CARD_FORMAT             = 133;
 const SUD_NO_CARD                     = 134;
 const SUD_CALC_TIMEZONE               = 135;
 const SUD_BAD_PIN                     = 136;
 const SUD_BAD_LEVEL                   = 138;
 const SUD_BAD_APB                     = 148;
 const SUD_CHECK_RIGHT                 = 238;
 const SUD_SET_READER_MODE             = 6000;
 const SUD_GET_MODE_READER             = 6001;
 const SUD_ADD_CARD                    = 6002;
 const SUD_DEL_CARD                    = 6003;
 const SUD_SET_DATETIME                = 6004;
 const SUD_SETTED_DATETIME             = 232;//6005;
 const SUD_ADDED_CARD                  = 230;//6006;
 const SUD_DELETED_CARD                = 229;//6007;
 const SUD_SET_HOLIDAY                 = 6008;
 const SUD_SETTED_HOLIDAY              = 231;
 const SUD_SET_MASK                    = 6009;
 const SUD_SETTED_MASK                 = 254;//6010;
 const SUD_SET_READER_FULL             = 6011;
 const SUD_GET_READER_DATABASE         = 6012;
 const SUD_SET_LEVEL                   = 6013;
 const SUD_SET_LEVELS                  = 6014;
 const SUD_LOAD_LOGIC_LEVEL            = 6015;
 const SUD_SET_TIMEZONE                = 6016;
 const SUD_SET_TIMEZONES               = 6017;
 const SUD_CHANGE_BRANCH               = 6018;
 const SUD_SETTED_LEVEL                = 255;
 const COMMAND_OPEN_DOOR               = 235;
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
 const SUD_TAMPER_RIC                  = 6028;
 const SUD_RESETTAMPER_RIC             = 6029;
 const AAN100_SET_HOLIDAY              = 6030;
 const AAN100_WW_FORMAT                = 6031;
 const DRIVERRIC_REQUEST               = 6032;
 const DRIVERRIC_GRANTED               = 6033;
 const DRIVERRIC_DENIED                = 6034;
 const DRIVERRIC_ERROR                 = 6035;


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

 const PCE_OUTPUT_ENABLED              = 242;
 const PCE_OUTPUT_DISABLED             = 257;

//------------------------------------------------------------------------------

  const         SWITCH_PLAN                       =99;

  const         LOST_LINK_TAGET                   =7000;
  const         SET_LINK_TAGET                    =7001;


  const         KEYBOARD_DRAW                     =7011;
  const         REQUEST_KEYBOARD_ARMED            =7012;
  const         REQUEST_KEYBOARD_DISARMED         =7013;
  const         REQUEST_KEYBOARD_STATUS           =7015;

  const         START_PROGRAM                     = 7014;
  const         STOP_PROGRAM                      = 7017;//программа останвлена
  const         NET_TEST                          = 7034;//
  const         KILL_PROGRAM                      = 7022;//остановить программу
  const         CHECK_LIVE_PROGRAM                = 7025;//
  const         LOST_LIVE_PROGRAM                 = 7026;//
  const         I_LIVE_PROGRAM                    = 7027;//
  const         SET_TIME                          = 7028;//
  const         EXIT_PROGRAM                      = 7029;//оставить программу
  
  const         CONTROLSTATE_ERROR_ARMED          = 7023;//
  const         CONTROLSTATE_OK_ARMED             = 7024;//
  const         CONTROLSTATE_ERROR_DISARMED       = 7032;//
  const         CONTROLSTATE_OK_DISARMED          = 7033;//

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

  
  //------------------------------------------------------
  //                       Рубеж-08
  //------------------------------------------------------
  const         R8_CONNECT_FALSE                  = 9100;         //Отсутствие связи с БЦП+
  const         R8_CONNECT_TRUE                   = 9101;         //БЦП на связи +
  const         R8_SYSERROR                       = 9102;         //Системная ошибка БЦП+
  const         R8_OK                             = 9103;         //БЦП в норме (Сброс систем. ошибок)+
  const         R8_COMMAND_PANEL_REFRESH          = 9104;         //Запрос состояний БЦП,зон, ШС, СУ
  const         R8_COMMAND_SH_ARM                 = 9105;         //ШС Поставить на охрану+
  const         R8_COMMAND_SH_DISARM              = 9106;         //ШС Снять с охраны+
  const         R8_COMMAND_SH_OFF                 = 9107;         //ШС отключить+
  const         R8_COMMAND_SH_ON                  = 9108;         //ШС подключить+
  const         R8_COMMAND_SH_RESTORE             = 9109;         //ШС восстановить+
  const         R8_SH_ARMED                       = 9110;         //ШС под охраной+
  const         R8_SH_DISARMED                    = 9111;         //ШС без охраны+
  const         R8_SH_READY                       = 9112;         //ШС готов+
  const         R8_SH_NOTREADY                    = 9113;         //ШС не готов+
  const         R8_SH_CHECK                       = 9114;         //ШС неисправен+
  const         R8_SH_ALARM                       = 9115;         //ШС в тревоге+
  const         R8_SH_RESTORE                     = 9116;         //ШС восстановлен (исключен из тревож. сообщ.)
  const         R8_SH_OFF                         = 9117;         //ШС отключен+
  const         R8_SH_ON                          = 9118;         //ШС подключен+
  const         R8_SH_HW_OK                       = 9119;         //ШС Оборудование в норме
  const         R8_SH_HW_FAULT                    = 9120;         //ШС Оборудование неисправно
  const         R8_BLOCK_SH_ENABLED               = 9121;         //Блок доступных ШС+
  const         R8_BLOCK_SH_READY                 = 9122;         //Блок готовых ШС+
  const         R8_BLOCK_SH_ALARM                 = 9123;         //Блок ШС в тревоге+
  const         R8_BLOCK_SH_OFF                   = 9124;         //Блок отключенных ШС+
  const         R8_BLOCK_SH_ARMED                 = 9125;         //Блок ШС под охранной+
  const         R8_BLOCK_SH_CHECK                 = 9126;         //Блок неисправных ШС+
  const         R8_BLOCK_SH_HW_FAULT              = 9127;         //Блок ШС на связи+
  const         R8_COMMAND_ZONE_ARM               = 9128;         //Зона поставить на охрану+
  const         R8_COMMAND_ZONE_DISARM            = 9129;         //Зона снять с охраны+
  const         R8_ZONE_ARMED                     = 9130;         //Зона под охраной+
  const         R8_ZONE_DISARMED                  = 9131;         //Зона без охраны+
  const         R8_ZONE_READY                     = 9132;         //Зона готова+
  const         R8_ZONE_NOTREADY                  = 9133;         //Зона не готова+
  const         R8_ZONE_CHECK                     = 9134;         //Зона не исправена+
  const         R8_ZONE_ALARM                     = 9135;         //Зона в тревоге+
  const         R8_ZONE_RESTORE                   = 9136;         //Зона восстановлена+
  const         R8_ZONE_SH_OFF                    = 9137;         //В зоне есть отключенные ШС
  const         R8_ZONE_SH_ON                     = 9138;         //В зоне все ШС подключены
  const         R8_BLOCK_ZONE_READY               = 9139;         //Блок готовых зон+
  const         R8_BLOCK_ZONE_ALARM               = 9140;         //Блок зон в тревоге+
  const         R8_BLOCK_ZONE_CHECK               = 9141;         //Блок неисправных зон+
  const         R8_BLOCK_ZONE_ARMED               = 9142;         //Блок зон под охранной+
  const         R8_BLOCK_ZONE_OFF                 = 9143;         //Блок отключенных зон+
  const         R8_CU_CONNECT_OFF                 = 9144;         //СУ потеря связи+
  const         R8_CU_CONNECT_ON                  = 9145;         //СУ восстановление связи+
  const         R8_BLOCK_CU_CONNECT               = 9146;         //Блок СУ на линии     (!)
  const         R8_COMMAND_RELAY_0                = 9147;         //Реле выключить+
  const         R8_COMMAND_RELAY_1                = 9148;         //Реле включить+
  const         R8_RELAY_0                        = 9149;         //Реле выключено+
  const         R8_RELAY_1                        = 9150;         //Реле включено+
  const         R8_RELAY_HW_OK                    = 9151;         //Реле Оборудование в норме
  const         R8_RELAY_HW_FAULT                 = 9152;         //Реле Оборудование неисправно
  const         R8_BLOCK_RELAY_1                  = 9153;         //Блок включенных реле
  const         R8_BLOCK_RELAY_CONNECT            = 9154;         //Блок реле на связи
  const         R8_UPS_ACCESS                     = 9155;         //вскрытие корпуса ИБП-
  const         R8_UPS_OUT1_BAD                   = 9156;         //ИБП неисправность выхода 1+
  const         R8_UPS_OUT1_OK                    = 9157;         //ИБП восстановление выхода 1+
  const         R8_UPS_OUT2_BAD                   = 9158;         //ИБП неисправность выхода 2+
  const         R8_UPS_OUT2_OK                    = 9159;         //ИБП восстановление выхода 2+
  const         R8_UPS_IN220_BAD                  = 9160;         //ИБП неисправность входа 220+
  const         R8_UPS_IN220_OK                   = 9161;         //ИБП восстановление входа 220+
  const         R8_UPS_BAT_BAD                    = 9162;         //Разряд БА ИБП+
  const         R8_UPS_BAT_OK                     = 9163;         //Заряд в норме БА ИБП БА+
  const         R8_UPS_RESERV_ON                  = 9164;         //ИБП переход на резерв+
  const         R8_UPS_RESERV_OFF                 = 9165;         //ИБП воостановление питания 220+
  const         R8_UPS_BAT_DISCONNECT             = 9166;         //ИБП отключение БА+
  const         R8_UPS_BAT_CONNECT                = 9167;         //ИБП подключение БА+
  const         R8_USER_ENTER                     = 9168;         //Начало рабочей сессии БЦП+
  const         R8_USER_EXIT                      = 9169;         //Конец рабочей сессии БЦП+
  const         R8_POWER_UP                       = 9170;         //Включение БЦП+
  const         R8_POWER_DOWN                     = 9171;         //Выключение БЦП+
  const         R8_ENTER_CONF                     = 9172;         //Вход в конфигурирование БЦП+
  const         R8_UNKNOWN_USER                   = 9173;         //Ошибка авторизации оператора+
  const         R8_LOCK_KEYBOARD                  = 9174;         //Блокировка клавиатуры БЦП при авторизации+
  const         R8_OPEN                           = 9175;         //Вскрытие корпуса БЦП+
  const         R8_RESERV_POWER                   = 9176;         //Переход на резервное питание+
  const         R8_NORMAL_POWER                   = 9177;         //Восстановление сетевого питания+
  const         R8_WORKSETTINGS                   = 9178;         //Возврат к заводским установкам+
  const         R8_SYNC_TIME                      = 9179;         //Синхронизация часов БЦП+
  const         R8_TERM_ON                        = 9180;         //Терминал подключен, в норме+
  const         R8_TERM_OFF                       = 9181;         //Терминал отключен+
  const         R8_TERM_HW_OK                     = 9182;         //Терминал Оборудование в норме
  const         R8_TERM_HW_FAULT                  = 9183;         //Терминал Оборудование неисправно
  const         R8_BCP_OPEN                       = 9184;         //Вскрытие БЦП          (!)
  const         R8_DRV_READY                      = 9185;         //Драйвер готов к работе
  const         R8_CU_OPEN                        = 9186;         //Вскрытие СУ+  (!)
  const         R8_SMALL_CONNECT_FALSE            = 9187;         //Кратковременное (менее минуты) отсутствие связи с БЦП+
  const         R8_SH_NORIGTH                     = 9188;         //Нет прав на управление ШС
  const         R8_RELAY_NORIGTH                  = 9189;         //Нет прав на управление реле
  const         R8_TERM_NORIGTH                   = 9190;         //Нет прав на управление терминалом
  const         R8_CU_CLOSE                       = 9191;         //СУ корпус закрыт
  const         R8_BLOCK_CU_OPEN                  = 9192;         //Блок вскрытых СУ (!)
  const         R8_RETURN_COMMAND_FROM_ROSTEK     = 9193;         //Возвращение команды с ВУ               (!)
  const         R8_SH_RESET                       = 9194;         //ШС. Сброс                              (!)
  const         R8_SH_BYPASS                      = 9195;         //ШС. пропуск не готового к постановке      (!)
  const         R8_SH_INDELAY                     = 9196;         //ШС задержка на вход   (!)
  const         R8_SH_OUTDELAY                    = 9197;         //ШС задержка на выход  (!)
  const         R8_BAT_LOW                        = 9198;         //Разряд БА             (!)
  const         R8_BAT_NORMAL                     = 9199;         //Восстановление БА     (!)
  const         R8_COMMAND_CU_CREATE              = 9200;         //СУ создать+
  const         R8_COMMAND_CU_CHANGE              = 9201;         //СУ редактировать+
  const         R8_COMMAND_CU_DELETE              = 9202;         //СУ удалить+
  const         R8_COMMAND_CU_CONFIG              = 9203;         //СУ запрос конфигурации+
  const         R8_CU_CREATE                      = 9204;         //СУ создано+
  const         R8_CU_CHANGE                      = 9205;         //СУ редактировано+
  const         R8_CU_DELETE                      = 9206;         //СУ удалено+
  const         R8_CU_CONFIG                      = 9207;         //СУ конфигурация+
  const         R8_COMMAND_ZONE_CREATE            = 9208;         //Зону создать+
  const         R8_COMMAND_ZONE_CHANGE            = 9209;         //Зону редактировать+
  const         R8_COMMAND_ZONE_DELETE            = 9210;         //Зону удалить+
  const         R8_COMMAND_ZONE_NAME_DELETE       = 9211;         //Зону по имени удалить+
  const         R8_COMMAND_ZONE_CONFIG            = 9212;         //Зона запрос конфигурации+
  const         R8_ZONE_CREATE                    = 9213;         //Зона создана+
  const         R8_ZONE_CHANGE                    = 9214;         //Зона редактирована+
  const         R8_ZONE_DELETE                    = 9215;         //Зона удалена+
  const         R8_ZONE_CONFIG                    = 9216;         //Зона конфигурация+
  const         R8_COMMAND_SH_CREATE              = 9217;         //ШС создать+
  const         R8_COMMAND_SH_CHANGE              = 9218;         //ШС редактировать+
  const         R8_COMMAND_SH_DELETE              = 9219;         //ШС удалить+
  const         R8_COMMAND_SH_SERNUM_DELETE       = 9220;         //ШС удалить по sernum+
  const         R8_COMMAND_SH_CONFIG              = 9221;         //ШС запрос конфигурации+
  const         R8_SH_CREATE                      = 9222;         //ШС создан+
  const         R8_SH_CHANGE                      = 9223;         //ШС редактирован+
  const         R8_SH_DELETE                      = 9224;         //ШС удален+
  const         R8_SH_CONFIG                      = 9225;         //ШС конфигурация+
  const         R8_COMMAND_USER_CREATE            = 9226;         //Пользователь создать+
  const         R8_COMMAND_USER_CHANGE            = 9227;         //Пользователь редактировать+
  const         R8_COMMAND_USER_DELETE            = 9228;         //Пользователь удалить+
  const         R8_USER_CREATE                    = 9229;         //Пользователь создан+
  const         R8_USER_CHANGE                    = 9230;         //Пользователь редактирован+
  const         R8_USER_DELETE                    = 9231;         //Пользователь удален+
  const         R8_COMMAND_TZ_CREATE              = 9232;         //ВЗ создать+
  const         R8_COMMAND_TZ_CHANGE              = 9233;         //ВЗ редактировать+
  const         R8_COMMAND_TZ_DELETE              = 9234;         //ВЗ удалить+
  const         R8_TZ_CREATE                      = 9235;         //ВЗ создана+
  const         R8_TZ_CHANGE                      = 9236;         //ВЗ редактирована+
  const         R8_TZ_DELETE                      = 9237;         //ВЗ удалена+
  const         R8_COMMAND_RELAY_CREATE           = 9238;         //Реле создать
  const         R8_COMMAND_RELAY_CHANGE           = 9239;         //Реле редактировать
  const         R8_COMMAND_RELAY_DELETE           = 9240;         //Реле удалить
  const         R8_RELAY_CREATE                   = 9241;         //Реле создано+
  const         R8_RELAY_CHANGE                   = 9242;         //Реле редактировано+
  const         R8_RELAY_DELETE                   = 9243;         //Реле удалено+
  const         R8_COMMAND_SETTIME                = 9244;         //Время установить+
  const         R8_SETTIME                        = 9245;         //Время установлено+
  const         R8_COMMAND_GETTIME                = 9246;         //Время запросить+
  const         R8_GETTIME                        = 9247;         //Время выдано+
  const         R8_COMMAND_UD_CREATE              = 9248;         //УД создать+
  const         R8_COMMAND_UD_CHANGE              = 9249;         //УД редактировать+
  const         R8_COMMAND_UD_DELETE              = 9250;         //УД удалить+
  const         R8_UD_CREATE                      = 9251;         //УД создан+
  const         R8_UD_CHANGE                      = 9252;         //УД редактирован+
  const         R8_UD_DELETE                      = 9253;         //УД удален+
  const         R8_COMMAND_TERM_CREATE            = 9254;         //ТЕРМ создать
  const         R8_COMMAND_TERM_CHANGE            = 9255;         //ТЕРМ редактировать
  const         R8_COMMAND_TERM_DELETE            = 9256;         //ТЕРМ удалить
  const         R8_COMMAND_TERM_SERNUM_DELETE     = 9257;         //ТЕРМ удалить по sernum
  const         R8_COMMAND_TERM_CONFIG            = 9258;         //ТЕРМ запрос конфигурации
  const         R8_TERM_CREATE                    = 9259;         //ТЕРМ создан
  const         R8_TERM_CHANGE                    = 9260;         //ТЕРМ редактирован
  const         R8_TERM_DELETE                    = 9261;         //ТЕРМ удален
  const         R8_TERM_CONFIG                    = 9262;         //ТЕРМ конфигурация
  const         R8_COMMAND_CU_ALL_DELETE          = 9263;         //Удалить все СУ
  const         R8_CU_ALL_DELETE                  = 9264;         //Удалены все СУ
  const         R8_COMMAND_ZONE_ALL_DELETE        = 9265;         //Удалить все зоны
  const         R8_ZONE_ALL_DELETE                = 9266;         //Удалены все зоны
  const         R8_COMMAND_TZ_ALL_DELETE          = 9267;         //Удалить все ВЗ
  const         R8_TZ_ALL_DELETE                  = 9268;         //Удалены все ВЗ
  const         R8_COMMAND_UD_ALL_DELETE          = 9269;         //Удалить все УД
  const         R8_UD_ALL_DELETE                  = 9270;         //Удалены все УД
  const         R8_COMMAND_USER_ALL_DELETE        = 9271;         //Удалить всех пользователей
  const         R8_USER_ALL_DELETE                = 9272;         //Удалены все пользователи
  const         R8_COMMAND_RELAY_RESTORE          = 9273;         //Реле восстановить
  const         R8_COMMAND_AP_RESTORE             = 9274;         //ТД восстановить
  const         R8_SH_TEST                        = 9275;         //ШС. Режим проверки
  const         R8_SH_TESTPASSEDOK                = 9276;         //ШС. Проверка пройдена
  const         R8_SH_TESTTIMEOUT                 = 9277;         //ШС. Проверка не пройдена
  const         R8_SH_WAITFORREADY                = 9278;         //ШС. Ожидание готовности
  const         R8_SH_WAITFORREADYCANCEL          = 9279;         //ШС. Отмена ожидания готовности
  const         R8_COMMAND_GR_CREATE              = 9280;         //Группу создать
  const         R8_GR_CREATE                      = 9281;         //Группа создана
  const         R8_COMMAND_GR_CHANGE              = 9282;         //Группу редактировать
  const         R8_GR_CHANGE                      = 9283;         //Группа редактирована
  const         R8_COMMAND_GR_DELETE              = 9284;         //Группу удалить
  const         R8_GR_DELETE                      = 9285;         //Группа удалена
  const         R8_COMMAND_GR_DELETE_ALL          = 9286;         //Удалить все группы
  const         R8_GR_DELETEALL                   = 9287;         //Группы удалены
  const         R8_COMMAND_GR_GET                 = 9288;         //Группа. Запрос конфигурации
  const         R8_GR_GET                         = 9289;         //Группа конфигурация
  const         R8_COMMAND_GR_GETLIST             = 9290;         //Группа. Запрос конфигурации всех
  const         R8_COMMAND_USER_APBRESET          = 9291;         //Польз. Сбросить APB
  const         R8_USER_APBRESET                  = 9292;         //Польз. APB сброшен
  const         R8_USER_BLOCKING                  = 9293;         //Польз. заблокирован
  const         R8_USER_DEBLOCKING                = 9294;         //Польз. разблокирован
  const         R8_RELAY_OFF                      = 9295;         //Реле отключено+
  const         R8_RELAY_ON                       = 9296;         //Реле подключено+
  const         R8_COMMAND_SH_BYPASS              = 9297;         //ШС Пропустить
  const         R8_COMMAND_SH_RESET               = 9298;         //ШС Сбросить
  const         R8_COMMAND_SH_TEST                = 9299;         //ШС Проверка

  // Уникальные вещи -----------------------------------------------------------
  const         R8_BAD_ARG_IN_USER_CMD            = 9300;         //Неверный аргумент в команде User+/-/e для ServerRubeg  (!)
  const         R8_BCP_ERROR                      = 9301;         //Отчет Р08 об ошибке на команду                         (!)
  const         R8_RETURN_ROSTEK_CMD_ON_ERROR     = 9302;         //Возвращение команды с ВУ                               (!)
  const         R8_BAD_ARG_IN_ROSTEK_CMD          = 9303;         //Неверный аргумент в команде от ВУ                      (!)

  const         R8_SELFTEST                       = 9307;         //Самотестирование БЦП. Технологическая проверка на заводе
  const         R8_RESET                          = 9308;         //Сброс БЦП
  const         R8_HANDSHAKE                      = 9310;         //Нажали ПРИНЯТЬ
  const         R8_SH_FIRE_ALARM                  = 9311;         // (!) ПОЖАР
  const         R8_SH_FIRE_ATTENTION              = 9312;         // (!) Внимание

  const         R8_SH_NOTREADY_IN_CHECK           = 9319;         // (!) ШС не готов при неиспр.+
  const         R8_SH_READY_IN_CHECK              = 9320;         // (!) ШС готов при неиспр.+
  const         R8_SH_NOTREADY_IN_ALARM           = 9321;         // (!) ШС не готов при тревоге+
  const         R8_SH_READY_IN_ALARM              = 9322;         // (!) ШС готов при тревоге+



  { N E W vv}
  const         R8_TC_RESTORE                     = 9323;         // ТС восстановлен
  const         R8_TC_HW_FAULT                    = 9324;         // ТС Оборудование неисправно
  const         R8_TC_HW_OK                       = 9325;         // ТС Оборудование в норме
  const         R8_TC_NORIGTH                     = 9326;         // ТС Нет прав управления
  const         R8_TC_CREATE                      = 9327;         // ТС Создано
  const         R8_TC_CHANGE                      = 9328;         // ТС Редактировано
  const         R8_TC_DELETE                      = 9329;         // ТС Удалено
  { N E W ^^}

  const         R8_COMMAND_CLEAR                  = 9331;         // БЦП Очистить конфигурацию
  const         R8_COMMAND_CLEARSYSERROR          = 9332;         // БЦП Сбросить системную ошибку
  const         R8_COMMAND_STARTCHECKCONFIG       = 9333;         // БЦП Проверить конфигурацию
  const         R8_COMMAND_BCP_RESET              = 9334;         // БЦП Сбросить
  const         R8_COMMAND_BCP_CONSOLELOCK        = 9335;         // Выход из сеанса в БЦП
  const         R8_COMMAND_BCP_CONSOLEUNLOCK      = 9336;         // Сеанс админисратора в БЦП
  const         R8_COMMAND_BCP_DMQCLEARNND        = 9337;         // Восстановление всех готовых СУ
  const         R8_COMMAND_BCP_DMQCLEARTCO        = 9338;         // Восстановление всех готовых ШС
  const         R8_COMMAND_BCP_VAR_ASSIGN         = 9339;         // Присвоить перменной значение
  const         R8_COMMAND_BCP_ALLUSERSETSTATE    = 9340;         // Сбросить APB всех пользователей
  const         R8_BCP_ALLUSERSETSTATE            = 9341;         // Сброс APB всех пользователей

  const         R8_COMMAND_RN_DELETE_ALL          = 9342;         // Удалить все названия
  const         R8_COMMAND_RP_DELETE_ALL          = 9343;         // Удалить все программы
  const         R8_COMMAND_HD_DELETE_ALL          = 9344;         // Удалить все праздники

  const         R8_RN_ALL_DELETE                  = 9345;         // Удалены все названия
  const         R8_RP_ALL_DELETE                  = 9346;         // Удалить все программы
  const         R8_HD_ALL_DELETE                  = 9347;         // Удалить все праздники
  const         R8_COMMAND_BCP_RSPDOACTION_RUN    = 9348;         // Выполнить скрипт
  const         R8_COMMAND_BCP_RSPDOACTION_STOP   = 9349;         // Остановить скрипт

  const         R8_PCCONNECT_OFF                  = 9351;         //Потеря связи с ПЭВМ
  const         R8_PCCONNECT_ON                   = 9352;         //Восстановление связи с ПЭВМ


  // ТШ, терминал, АСПТ, и др. -------------------------------------------------------
  const         R8_RELAY_CHECK                    = 9401;         // (!) Реле неисправно
  const         R8_RELAY_RESTORE                  = 9402;         // (!) Реле восстановлено
  const         R8_RELAY_WAITON                   = 9403;         //Реле Задержка включения
  const         R8_COMMAND_RELAY_CONFIG           = 9404;         //Реле запрос конфигурации
  const         R8_RELAY_CONFIG                   = 9405;         //Реле конфигурация+
  const         R8_COMMAND_RELAY_OFF              = 9406;         //Реле отключить
  const         R8_COMMAND_RELAY_ON               = 9407;         //Реле подключить

  const         R8_TERM_REQUEST                   = 9411;         // (!) Запрос пользователя
  const         R8_TERM_BLOCKING                  = 9412;         // (!) Блокирование работы терминала
  const         R8_TERM_AUTHORIZATIONERROR        = 9413;         // (!) Ошибка авторизации пользователя
  const         R8_TERM_CODEFORGERY               = 9414;         // (!) Попытка подбора кода. Событие выдается после трех, сделанных подряд, ошибок авторизации пользователя.обл.
  const         R8_TERM_RESET                     = 9415;         // (!) Восстановление работы терминала после блокирования
  const         R8_TERM_USERCOMMAND               = 9416;         // (!) Пользовательская команда
  const         R8_TERM_CHECK                     = 9417;         // (!) Терминал неисправен
  const         R8_TERM_RESTORE                   = 9418;         // (!) Терминал восстановлен
  const         R8_COMMAND_TERM_RESTORE           = 9419;         // Терминал восстановить
  
  const         R8_TECHNO_AREA0 	          = 9421;         // (!) обл.0. Переход физического ШС в состояние в обл 0. Замкнуто для дискретных ШС
  const         R8_TECHNO_AREA1 	          = 9422; 	  // (!) обл 1. Переход физического ШС в состояние в обл 1. Разомкнуто для дискретных ШС
  const         R8_TECHNO_AREA2 	          = 9423; 	  // (!) обл 2. Переход физического ШС в состояние в обл 2
  const         R8_TECHNO_AREA3 	          = 9424; 	  // (!) обл 3. Переход физического ШС в состояние в обл 3
  const         R8_TECHNO_ALARM 	          = 9425; 	  // (!) Тревога тех. ШС
  const         R8_COMMAND_TERM_BLOCK             = 9426;         // Терминал заблокировать
  const         R8_COMMAND_TERM_RESET             = 9427;         // Терминал сбросить
  const         R8_COMMAND_TERM_OFF               = 9428;         // Терминал отключить
  const         R8_COMMAND_TERM_ON                = 9429;         // Терминал подключить

  const         R8_COMMAND_HOLIDAY_EDIT           = 9431;         // Редактировать праздники (код учтен в СКУД)
  const         R8_HOLIDAY_EDITED                 = 9432;         // Редактированы праздники (код учтен в СКУД)

  const         R8_ASPT_AUTOMATICON               = 9433;         // АСПТ. Автоматика включена
  const         R8_ASPT_AUTOMATICOFF              = 9434;         // АСПТ. Автоматика отключена
  const         R8_ASPT_DOOROPEN                  = 9435;         // АСПТ. Открывание двери
  const         R8_ASPT_DOORCLOSE                 = 9436;         // АСПТ. Закрывание двери
  const         R8_ASPT_AUTOMATICSTART            = 9437;         // АСПТ. Автоматический пуск
  const         R8_ASPT_REMOTESTART               = 9438;         // АСПТ. Дистанционный пуск
  const         R8_ASPT_MANUALSTART               = 9439;         // АСПТ. Ручной пуск 
  const         R8_ASPT_CANCELSTART               = 9440;         // АСПТ. Отмена пуска
  const         R8_ASPT_EVACUATIONDELAY           = 9441;         // АСПТ. Задержка на эвакуацию
  const         R8_ASPT_FIREEXTINGUISHING	  = 9442;         // АСПТ. Пуск ОТВ
  const         R8_ASPT_FIREEXTINGUISHINGCOMPLETE = 9443;         // АСПТ. Пуск прошел
  const         R8_ASPT_AUTHORIZATIONERROR        = 9444;         // АСПТ. Ошибка авторизации пользователя
  const         R8_ASPT_TIMEOUT                   = 9445;         // АСПТ. Таймаут
  const         R8_ASPT_OUTLAUNCHSUCCESS          = 9446;         // АСПТ. Срабатывание выхода СКУП-01
  const         R8_ASPT_OUTLAUNCHERROR	          = 9447;         // АСПТ. Ошибка срабатывания выхода СКУП-01
  const         R8_ASPT_TROUBLE                   = 9448;         // АСПТ. Неисправность
  const         R8_ASPT_SDU                       = 9449;         // АСПТ. Срабатывание СДУ
  const         R8_ASPT_WEIGHTSENSOR              = 9450;         // АСПТ. Срабатывание датчика наличия ОТВ
  const         R8_ASPT_RESET                     = 9451;         // АСПТ. Сброс
  const         R8_ASPT_FIRE                      = 9452;         // АСПТ. Пожар

  const         R8_CMD_ASPT_AUTOMATICON        	  = 9453;         // АСПТ. Включить автоматику 0901h
  const         R8_CMD_ASPT_AUTOMATICOFF          = 9454;         // АСПТ. Отключить автоматику 0902h
  const         R8_CMD_ASPT_REMOTESTART	          = 9455;         // АСПТ. Дистанционный пуск 0904h
  const         R8_CMD_ASPT_CANCELSTART	          = 9456;         // АСПТ. Отмена пуска 0906h
  const         R8_CMD_ASPT_RESET	          = 9457;         // АСПТ. Сбросить 0907h

  const         R8_ASPT_HW_FAULT                  = 9458;         // АСПТ. Оборудование неисправно
  const         R8_ASPT_HW_OK                     = 9459;         // АСПТ. Оборудование в норме
  const         R8_ASPT_NORIGTH                   = 9460;         // АСПТ. Нет прав на управление
  const         R8_ASPT_CREATE                    = 9461;         // АСПТ создан
  const         R8_ASPT_CHANGE                    = 9462;         // АСПТ редактирован
  const         R8_ASPT_DELETE                    = 9463;         // АСПТ удален
  const         R8_ASPT_CONFIG                    = 9464;         // АСПТ конфигурация
  const         R8_ASPT_RESTORE                   = 9465;         // АСПТ. Восстановлен
  const         R8_CMD_ASPT_RESTORE               = 9466;         // АСПТ. Восстановить
  const         R8_ASPT_ON                        = 9467;         // АСПТ подключен
  const         R8_ASPT_OFF                       = 9468;         // АСПТ отключен




  const         R8_VIDEO_ARM                      = 9471;         // Видео. Постановка на охрану
  const         R8_VIDEO_DISARM                   = 9472;         // Видео. Снятие с охраны
  const         R8_VIDEO_ALARM                    = 9473;         // Видео. Тревога
  const         R8_VIDEO_TROUBLE                  = 9474;         // Видео. Неисправность
  const         R8_VIDEO_STARTRECORD              = 9475;         // Видео. Начало записи
  const         R8_VIDEO_STOPRECORD               = 9476;         // Видео. Конец записи

{
Коды состояния ТС «АСПТ»
STATE_ASPT_AUTOMATICON 0901h Автоматика включена
STATE_ASPT_AUTOMATICOFF 0902h Автоматика отключена
STATE_ASPT_DOOROPEN 0903h Дверь открыта
STATE_ASPT_FIRE 0904h Пожар
STATE_ASPT_ATTENTION 0905h Внимание
STATE_ASPT_TROUBLE 0906h Неисправность
STATE_ASPT_EVACUATIONDELAY 0907h Задержка на эвакуацию
STATE_ASPT_FIREEXTINGUISHING 0908h Пуск ОТВ
STATE_ASPT_FIREEXTINGUISHINGCOMPLETE 0909h Пуск прошел
STATE_ASPT_TROUBLEWEIGHTSENSOR 090Ah Неисправность датчика ОТВё
STATE_ASPT_TROUBLESDU 090Bh Неисправность СДУ
STATE_ASPT_TROUBLELAUNCH 090Ch Неисправность выходов СКУП-01
STATE_ASPT_TROUBLEPPO01 090Dh Неисправность ППО-01
STATE_ASPT_TROUBLEDOORSENSOR 090Eh Неисправность датчика двери
STATE_ASPT_TROUBLENOTIFIER 090Fh Неисправность оповещения

}





  // -------------------
  // --- Д О С Т У П ---
  // -------------------
  // BCP события
  //------------------------
  const         R8_AP_IN                          = 9501;         //ТД Вход. Проход пользователя через ТД, сконфигурированную на вход.
  const         R8_AP_OUT                         = 9502;         //ТД Выход. Проход пользователя через ТД, сконфигурированную на выход.
  const         R8_AP_PASSENABLE                  = 9503;         //ТД Проход разрешен командой «Открыть замок».
  const         R8_AP_DOOROPEN                    = 9504;         //ТД Открывание двери.
  const         R8_AP_DOORNOCLOSED                = 9505;         //ТД Удержание двери
  const         R8_AP_DOORALARM                   = 9506;         //ТД Взлом двери
  const         R8_AP_DOORCLOSE                   = 9507;         //ТД Закрывание двери
  const         R8_AP_BLOCKING                    = 9508;         //ТД Блокирование
  const         R8_AP_DEBLOCKING                  = 9509;         //ТД Разблокирование
  const         R8_AP_EXITBUTTON                  = 9510;         //ТД Выход по кнопке
  const         R8_AP_RESET                       = 9511;         //ТД в норме (сброс). Восстановление после блокирования или разблокирования
  const         R8_AP_AUTHORIZATIONERROR          = 9512;         //ТД Ошибка авторизации пользователя
  const         R8_AP_CODEFORGERY                 = 9513;         //ТД Попытка подбора кода
  const         R8_AP_REQUESTPASS                 = 9514;         //ТД Запрос прохода. Выдается, когда ТД сконфигурирована на проход с запросом
  const         R8_AP_FORCING                     = 9515;         //ТД Нападение
  const         R8_AP_APBERROR                    = 9516;         //ТД Нарушение правил прохода
  const         R8_AP_ACCESSGRANTED               = 9517;         //ТД Доступ разрешен
  const         R8_AP_ACCESSTIMEOUT               = 9518;         //ТД Таймаут

  // BCP команды
  //------------------------
  const         R8_COMMAND_AP_PASS                = 9521;         //ТД Разрешить проход
  const         R8_COMMAND_AP_LOCK                = 9522;         //ТД Закрыть
  const         R8_COMMAND_AP_UNLOCK              = 9523;         //ТД Открыть
  const         R8_COMMAND_AP_RESET               = 9524;         //ТД Сброс
  const         R8_COMMAND_AP_OFF                 = 9525;         //ТД отключить
  const         R8_COMMAND_AP_ON                  = 9526;         //ТД подключить

  // мои события
  //------------------------
  const         R8_AP_CHECK                       = 9531;         //ТД. Неисправность
  const         R8_AP_RESTORE                     = 9532;         //ТД. Восстановлена (исключен из тревож. сообщ.)
  const         R8_AP_NORIGTH                     = 9533;         //ТД. Нет прав на управление
  const         R8_AP_HW_OK                       = 9534;         //ТД. Оборудование в норме
  const         R8_AP_HW_FAULT                    = 9535;         //ТД. Оборудование неисправно
  const         R8_BLOCK_AP_DATA                  = 9536;         //ТД. Блок режимов и состояний
  //const       R8_BLOCK_AP_STATE                 = 9537;         //ТД. Блок состояний

  // BCP конфигурирование
  //------------------------
  const         R8_COMMAND_AP_CREATE              = 9541;         //ТД создать +
  const         R8_COMMAND_AP_CHANGE              = 9542;         //ТД редактировать +
  const         R8_COMMAND_AP_DELETE              = 9543;         //ТД удалить +
  const         R8_COMMAND_AP_SERNUM_DELETE       = 9544;         //ТД удалить по sernum
  const         R8_COMMAND_AP_CONFIG              = 9545;         //ТД запрос конфигурации
  const         R8_AP_CREATE                      = 9546;         //ТД создана +
  const         R8_AP_CHANGE                      = 9547;         //ТД редактирована +
  const         R8_AP_DELETE                      = 9548;         //ТД удалена +
  const         R8_AP_CONFIG                      = 9549;         //ТД конфигурация
  const         R8_AP_OFF                         = 9550;         //ТД выключена
  const         R8_AP_ON                          = 9551;         //ТД включена
  const         R8_COMMAND_APSHZMK_SET            = 9552;         //установить ШС замка
  const         R8_APSHZMK_SET                    = 9553;         //установлен ШС замка 
  const         R8_COMMAND_APSHZMK_DELETE         = 9554;         //удалить ШС замка
  const         R8_APSHZMK_DELETE                 = 9555;         //удален ШС замка

  //------------------------
  // СКУ команды и ответы
  //------------------------
  const         SCU_GET_DEVVER                    = 9801;         //
  const         SCU_DEVVER                        = 9802;         //
  const         SCU_GET_BOOTVER                   = 9803;         //
  const         SCU_BOOTVER                       = 9804;         //
  const         SCU_GET_DEVSTATE                  = 9805;         //
  const         SCU_DEVSTATE                      = 9806;         //
  const         SCU_GET_ALTDEVSTATE               = 9807;         //
  const         SCU_ALTDEVSTATE                   = 9808;         //
  const         SCU_GET_STATEWORD                 = 9809;         //
  const         SCU_STATEWORD                     = 9810;         //
  const         SCU_GET_PARAMARRAY                = 9811;         //
  const         SCU_PARAMARRAY                    = 9812;         //
  const         SCU_TIME_GET                      = 9813;         //
  const         SCU_TIME                          = 9814;         //
  const         SCU_TIME_EDIT                     = 9815;         //
  const         SCU_TIME_EDITED                   = 9816;         //
  const         SCU_TIME_SYNC                     = 9817;         //
  const         SCU_TIME_SYNCED                   = 9818;         //
  const         SCU_NETWORK_GET                   = 9819;         //
  const         SCU_NETWORK                       = 9820;         //
  const         SCU_NETWORK_EDIT                  = 9821;         //
  const         SCU_NETWORK_EDITED                = 9822;         //
  const         SCU_CARD_REQUEST                  = 9823;         //
  const         SCU_CARD_REQUESTED                = 9824;         //
  const         SCU_PRG_WRITE                     = 9825;         //
  const         SCU_PRG_READ                      = 9826;         //
  const         SCU_PRG_DATA                      = 9827;         //

  const         SCU_SH_EDIT                       = 9831;         // -
  const         SCU_SH_EDITED                     = 9832;         // -
  const         SCU_SH_GET                        = 9833;         // -
  const         SCU_SH                            = 9834;         // -
  const         SCU_RELAY_EDIT                    = 9835;         // -
  const         SCU_RELAY_EDITED                  = 9836;         // -
  const         SCU_RELAY_GET                     = 9837;         // -
  const         SCU_RELAY                         = 9838;         // -
  const         SCU_USK_EDIT                      = 9839;         // -
  const         SCU_USK_EDITED                    = 9840;         // -
  const         SCU_USK_GET                       = 9841;         // -
  const         SCU_USK                           = 9842;         // -
  const         SCU_AP_EDIT                       = 9843;         // -
  const         SCU_AP_EDITED                     = 9844;         // -
  const         SCU_AP_GET                        = 9845;         // -
  const         SCU_AP                            = 9846;         // -
  const         SCU_USER_ADD                      = 9847;         // -
  const         SCU_USER_ADDED                    = 9848;         // -
  const         SCU_USER_ADDNOCHECK               = 9849;         // -
  const         SCU_USER_EDIT                     = 9850;         // -
  const         SCU_USER_EDITED                   = 9851;         // -
  const         SCU_USER_DELETE                   = 9852;         // -
  const         SCU_USER_DELETED                  = 9853;         // -
  const         SCU_USER_DELETE_ALL               = 9854;         // -
  const         SCU_USER_DELETED_ALL              = 9855;         // -
  const         SCU_USER_GET                      = 9856;         // -
  const         SCU_USER                          = 9857;         // -
  const         SCU_USER_GETLIST                  = 9858;         //

  const         SCU_TC_RESTORE                    = 9861;         //
  const         SCU_TC_RESTORED                   = 9862;         //
  const         SCU_SHOCHR_DISARM                 = 9863;         //
  const         SCU_SHOCHR_DISARMED               = 9864;         //
  const         SCU_SHOCHR_ARM                    = 9865;         //
  const         SCU_SHOCHR_ARMED                  = 9866;         //
  const         SCU_SHOCHR_RESET                  = 9867;         //
  const         SCU_SHTREV_RESET                  = 9868;         //
  const         SCU_SHFIRE_RESET                  = 9869;         //
  const         SCU_SH_RESETED                    = 9870;         //
  const         SCU_RELAY_1                       = 9871;         //
  const         SCU_RELAY_IS_1                    = 9872;         //
  const         SCU_RELAY_0                       = 9873;         //
  const         SCU_RELAY_IS_0                    = 9874;         //

  const         SCU_AP_PASS                       = 9875;         //
  const         SCU_AP_PASSED                     = 9876;         //
  const         SCU_AP_LOCK                       = 9877;         //
  const         SCU_AP_LOCKED                     = 9878;         //
  const         SCU_AP_UNLOCK                     = 9879;         //
  const         SCU_AP_UNLOCKED                   = 9880;         //
  const         SCU_AP_RESET                      = 9881;         //
  const         SCU_AP_RESETED                    = 9882;         //

  //------------------------
  // СКУ мои события
  //------------------------
  const         SCU_NOTANSWER                     = 9891;         //
  const         SCU_INCORRECTANSWER               = 9892;         //

  //------------------------
  // СКУ конфигурирование
  //------------------------
  const         SCU_HW_EDIT                       = 9893;         //+
  const         SCU_HW_EDITED                     = 9894;         //+
  const         SCU_HW_GET                        = 9895;         //
  const         SCU_HW                            = 9896;         //
  //------------------------
  // СКУ мои события
  //------------------------
  const         SCU_CARD_ADD                     = 9901;         // -
  const         SCU_CARD_ADDED                   = 9902;         // -
  const         SCU_CARD_DELETE                  = 9903;         // -
  const         SCU_CARD_DELETED                 = 9904;         // -
  const         SCU_USERMAP_WR_PERMIT            = 9905;         // -
  const         SCU_USERMAP_WR_ALL               = 9906;         // -



implementation

end.

