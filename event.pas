unit event;

interface

procedure EventConvert(tstype, idIvent: Integer; out typeDevice, Code: word);

implementation

uses SysUtils, constants, SharedBuffer;

procedure EventConvert(tstype, idIvent: Integer; out typeDevice, Code: word);

var
  st: string;
  Id, Sernum, Prm: word;
  PrmStr: string;
  Card: boolean;
  CuNumber: longword;
  CuName: string;
  mes: KSBMES;

begin

  case tstype of
    1: //
      begin
        mes.typeDevice := 4;
        mes.Partion := Id;
        mes.User := Prm;

        case idIvent of
          $101:
            begin
              mes.Code := R8_SH_ARMED;
              st := Format('На охране ШС #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;
          $102:
            begin
              mes.Code := R8_SH_DISARMED;
              st := Format('Без охраны ШС #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $103:
            begin
              mes.Code := R8_SH_ALARM;
              st := Format('Тревога проникновения ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $104:
            begin
              mes.Code := R8_SH_CHECK;
              st := Format('Неисправность (КЗ) ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $105:
            begin
              mes.Code := R8_SH_READY;
              st := Format('Переход в норму ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $106: // -г Не готов к постановке на охрану. Переход физического ШС в состояние «Тревога», когда объект находится в состоянии «Готов» или «Проникновение». Переход физического ШС в состояние «Неисправность», когда объект находится в состоянии «Проникновение» или «Неисправность».
            begin
              mes.Code := R8_SH_NOTREADY;
              st := Format('Не готов к постановке на охрану ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $107: // -т Сброс ШС
            begin
              mes.Code := R8_SH_RESET;
              st := Format('Сброс ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $108: // Ничего. Пропуск не готового к постановке на охрану объекта
            begin
              mes.Code := R8_SH_BYPASS;
              st := Format('Пропуск ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $109: // -в Задержка на вход. Переход физического ШС в состояние «Тревога», когда объект находится в состоянии «Взято» и для него определена задержка на вход.
            begin
              mes.Code := R8_SH_INDELAY;
              st := Format('Задержка на вход при снятии ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $10A: // +в Задержка на выход. Событие выдается при постановке объекта на охрану, если для него определена задержка на выход.
            begin
              mes.Code := R8_SH_OUTDELAY;
              st := Format('Задержка на выход при постановке ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $10B: // Ожидание готовности. При постановке на охрану, «Не готов»
            begin
              mes.Code := R8_SH_WAITFORREADY;
              st := Format('Ожидание готовности ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $10C: // Ожидание готовности. При постановке на охрану, «Не готов»
            begin
              mes.Code := R8_SH_WAITFORREADYCANCEL;
              st := Format('Отмена ожидания готовности ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $10D: // Дистанционный контроль пройден
            begin
              st := Format('Дистанционный контроль пройден. ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $10E: // Ошибка дистанционного контроля
            begin
              st := Format('Ошибка дистанционного контроля. ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $10F: // Внимание. Одиночная сработка.
            begin
              st := Format('Внимание. Одиночная сработка. ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $201: // +т  Тревога. Переход физического ШС в состояние «Тревога», когда объект находится в со-стоянии «Норма».
            begin
              mes.Code := R8_SH_ALARM;
              st := Format('Тревога ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $202: // +н  Неисправность. Переход физического ШС в состояние «Неисправность», когда объект находится в состоянии «Норма».
            begin
              mes.Code := R8_SH_CHECK;
              st := Format('Неисправность ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $203: // -т Сброс ШС
            begin
              mes.Code := R8_SH_RESET;
              st := Format('Сброс ШС #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;
          $204: // +г Готов к восстановлению. Переход физического ШС в состояние «Норма».
            begin
              mes.Code := R8_SH_READY;
              st := Format('Готов к восстановлению ШС #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $205: // -г Не готов к восстановлению. Переход физического ШС в состояние «Тревога» или «Неисправность», когда объект находится в состоянии «Тревога». Переход физического ШС в состояние «Неисправность», когда объект находится в состоянии «Неисправность».
            begin
              mes.Code := R8_SH_NOTREADY;
              st := Format('Не готов к восстановлению ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $206: // Режим проверки
            begin
              mes.Code := R8_SH_TEST;
              st := Format('Режим проверки ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $207: // Проверка пройдена
            begin
              mes.Code := R8_SH_TESTPASSEDOK;
              st := Format('Проверка пройдена ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $208: // Проверка не пройдена
            begin
              mes.Code := R8_SH_TESTTIMEOUT;
              st := Format('Проверка не пройдена ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $301: // +т  Тревога. Переход физического ШС в состояние «Тревога», когда объект находится в со-стоянии «Норма».
            begin
              mes.Code := R8_SH_FIRE_ALARM;
              st := Format('Пожар ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $302: // +н  Неисправность. Переход физического ШС в состояние «Неисправность», когда объект находится в состоянии «Норма».
            begin
              mes.Code := R8_SH_CHECK;
              st := Format('Неисправность ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);;
            end;
          $303: // Внимание. при норме
            begin
              mes.Code := R8_SH_FIRE_ATTENTION;
              st := Format('Внимание ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $304: // -т Сброс ШС
            begin
              mes.Code := R8_SH_RESET;
              st := Format('Сброс ШС #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;
          $305: // +г Готов к восстановлению. Переход физического ШС в состояние «Норма».
            begin
              mes.Code := R8_SH_READY;
              st := Format('Готов к восстановлению ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $306: // -г Не готов к восстановлению. Переход физического ШС в состояние «Тревога» или «Неисправность», когда объект находится в состоянии «Тревога». Переход физического ШС в состояние «Неисправность», когда объект находится в состоянии «Неисправность».
            begin
              mes.Code := R8_SH_NOTREADY;
              st := Format('Готов к восстановлению ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          // ШСтехн (связь-опрос ТС -неисправность-тревога- сост.2бит - сост.1бит)  с-о-н-т-2-1
          $401: // Область 0. Переход физического ШС в состояние в область 0. Замкнуто для дискретных ШС
            begin
              mes.Code := R8_TECHNO_AREA0;
              st := Format('Область 0 ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $402: // Область 1. Переход физического ШС в состояние в область 1. Разомкнуто для дискретных ШС
            begin
              mes.Code := R8_TECHNO_AREA1;
              st := Format('Область 1 ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $403: // Неисправность. Переход физического ШС в состояние «Неисправность».
            begin
              mes.Code := R8_SH_CHECK;
              st := Format('Неисправность ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $404: // Тревожная область 0. Переход физического ШС в состояние в область 0, область 0 сконфигурирована как тревожная
            begin
              // исключение
              mes.Code := R8_TECHNO_AREA0;
              // send(mes);
              mes.Code := R8_TECHNO_ALARM;
              st := Format('Область 0. Тревога ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $405: // Тревожная область 1. Переход физического ШС в состояние в область 1, область 1 сконфигурирована как тревожная
            begin
              // исключение
              mes.Code := R8_TECHNO_AREA1;
              // send(mes);
              mes.Code := R8_TECHNO_ALARM;
              st := Format('Область 1. Тревога ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $406: // Область 2. Переход физического ШС в состояние в область 2
            begin
              mes.Code := R8_TECHNO_AREA2;
              st := Format('Область 2 ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $407: // Область 3. Переход физического ШС в состояние в область 3
            begin
              mes.Code := R8_TECHNO_AREA3;
              st := Format('Область 3 ШС #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          $408: // Тревожная область 2. Переход физического ШС в состояние в область 2, область 2 сконфигурирована как тревожная
            begin
              // исключение
              mes.Code := R8_TECHNO_AREA2;
              // send(mes);
              mes.Code := R8_TECHNO_ALARM;
              st := Format('Область 2. Тревога ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $409: // Тревожная область 3. Переход физического ШС в состояние в область 3, область 3 сконфигурирована как тревожная
            begin
              // исключение
              mes.Code := R8_TECHNO_AREA3;
              // send(mes);
              mes.Code := R8_TECHNO_ALARM;
              st := Format('Область 3. Тревога ШС #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);;
            end;

          // реле (связь-резерв-неисправность-резерв-вкл-резерв) с-х-х-х-вкл-х
          $501: // вкл.
            begin
              mes.Code := R8_RELAY_1;
              st := Format('Включено РЕЛЕ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $502: // выкл.
            begin
              mes.Code := R8_RELAY_0;
              st := Format('Выключено РЕЛЕ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $503: // Задержка включения
            begin
              mes.Code := R8_RELAY_WAITON;
              st := Format('Задержка включения РЕЛЕ #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $504: // неисправно
            begin
              mes.Code := R8_RELAY_CHECK;
              st := Format('Неисправность РЕЛЕ #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $601: // Вход (!)
            begin
              mes.Code := { R8_AP_IN } SUD_ACCESS_GRANTED;
              st := Format('Вход ТД #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;
          $602: // Выход (!)
            begin
              mes.Code := { R8_AP_OUT } SUD_ACCESS_GRANTED;
              st := Format('Выход ТД #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;
          $603: // Проход
            begin
              mes.Code := { R8_AP_PASSENABLE } SUD_ACCESS_GRANTED;
              st := Format
                (' Проход по команде «Открыть замок» ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $604: // Открывание двери
            begin
              mes.Code := { R8_AP_DOOROPEN } SUD_DOOR_OPEN;
              st := Format('Открывание двери ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $605: // Удержание (!)
            begin
              mes.Code := { R8_AP_DOORNOCLOSED } SUD_HELD;
              st := Format('Удержание двери ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;

          $606: // Взлом (!)
            begin
              mes.Code := { R8_AP_DOORALARM } SUD_FORCED;
              st := Format('Взлом двери ТД #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $607: // Закрывание двери
            begin
              mes.Code := R8_AP_DOORCLOSE;
              st := Format('Закрывание двери ТД #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;
          $608: // Блокирование (!)
            begin
              mes.Code := { R8_AP_BLOCKING } RIC_MODE;
              mes.Level := 0;
              mes.Partion := 6;
              st := Format('Блокирование ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $609: // Разблокирование (!)
            begin
              mes.Code := { R8_AP_DEBLOCKING } RIC_MODE;
              mes.Level := 4;
              mes.Partion := 5;
              st := Format('Разблокирование ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $60A: // Выход по кнопке (!)
            begin
              mes.Code := { R8_AP_EXITBUTTON } SUD_GRANTED_BUTTON;
              st := Format('Выход по кнопке ТД #%d [%.4d] %s',
                [Id, Sernum, PrmStr]);
            end;

          $60B: // Восстановление (сброс)
            begin
              // mes.Code := ApEventAfterReset(State);

            end;

          $60C: // Ошибка авторизации
            begin
              mes.Code := R8_AP_AUTHORIZATIONERROR;
              if Prm = 0 then
              begin
                mes.Code := SUD_NO_CARD;
                st := Format('Нет карты в БЦП. ТД #%d [%.4d]. %s',
                  [Id, Sernum, PrmStr]);
              end
              else
              begin
                mes.Code := SUD_BAD_PIN;
                st := Format
                  ('Доступ запрещен. Неверный пинкод. ТД #%d [%.4d]. %s',
                  [Id, Sernum, PrmStr]);
              end;
            end;
          $60D: // подбор (!)
            begin
              mes.Code := { R8_AP_CODEFORGERY } SUD_ACCESS_CHOOSE;
              st := Format('Попытка подбора кода. ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $60E: // Запрос прохода
            begin
              mes.Code := R8_AP_REQUESTPASS;
              st := Format('Запрос прохода. ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $60F: // Нападение
            begin
              mes.Code := R8_AP_FORCING;
              st := Format('Нападение. ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $610: // Нарушение правил прохода
            begin
              mes.Code := { R8_AP_APBERROR } SUD_BAD_APB;
              st := Format('Нарушение правил прохода. ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $611: // Доступ разрешен
            begin
              mes.Code := { R8_AP_ACCESSGRANTED } SUD_ACCESS_GRANTED;
              st := Format('Доступ разрешен. ТД #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $612: // Таймаут
            begin
              mes.Code := R8_AP_ACCESSTIMEOUT;
              st := Format('Таймаут ТД #%d [%.4d] %s', [Id, Sernum, PrmStr]);
            end;
          // терминал (связь-резерв -неисправность-тревога-откр-готовность) с-х-х-х-вкл-х
          $701: // Запрос пользователя
            begin
              mes.Code := R8_TERM_REQUEST;
              st := Format('Запрос пользователя. ТЕРМИНАЛА #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $702: // Блокирование работы терминала
            begin
              mes.Code := R8_TERM_BLOCKING;
              st := Format('Блокирование ТЕРМИНАЛА #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $703: // Ошибка авторизации пользователя
            begin
              mes.Code := R8_TERM_AUTHORIZATIONERROR;
              st := Format
                ('Ошибка авторизации пользователя. ТЕРМИНАЛ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $704: // Попытка подбора кода. Событие выдается после трех, сделанных подряд, ошибок авто-ризации пользователя.
            begin
              mes.Code := R8_TERM_CODEFORGERY;
              st := Format('Попытка подбора кода. ТЕРМИНАЛ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $705: // Восстановление работы терминала после блокирования
            begin
              mes.Code := R8_TERM_RESET;
              st := Format
                ('Восстановление работы после блокирования. ТЕРМИНАЛ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $706: // Пользовательская команда
            begin
              mes.Code := R8_TERM_USERCOMMAND;
              st := Format('Пользовательская команда. ТЕРМИНАЛ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $801:
            begin
              st := Format
                ('Вход. Вход пользователя через шлюз, в зону шлюза. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $802:
            begin
              st := Format
                ('Выход. Выход пользователя через шлюз, из зоны шлюза. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $803:
            begin
              st := Format
                ('Вход в шлюз. Вход пользователя в шлюзовую кабину. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $805:
            begin
              st := Format
                ('Проход разрешен в первую дверь шлюза. Разрешение прохода командой «Открыть замок1». ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $806:
            begin
              st := Format
                ('Проход разрешен во вторую дверь шлюза.Разрешение прохода командой «Открыть замок 2». ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $807:
            begin
              st := Format('Открывание двери. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $808:
            begin
              st := Format('Удержание двери. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $809:
            begin
              st := Format('Взлом двери. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $80A:
            begin
              st := Format('Закрывание двери. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $80B:
            begin
              st := Format('Блокирование шлюза. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $80C:
            begin
              st := Format('Разблокирование шлюза. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $80D:
            begin
              st := Format('Восстановление работы. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $80E:
            begin
              st := Format
                ('Ошибка авторизации пользователя. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $80F:
            begin
              st := Format('Попытка подбора кода. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $810:
            begin
              st := Format('Таймаут шлюза. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $811:
            begin
              st := Format
                ('Срабатывание тревожного входа шлюза. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $812:
            begin
              st := Format('Нарушение правил прохода. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $813:
            begin
              st := Format('Доступ разрешен. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $814:
            begin
              st := Format('Таймаут. ШЛЮЗ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;

          $901:
            begin
              mes.Code := R8_ASPT_AUTOMATICON;
              st := Format('Автоматика включена. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $902:
            begin
              mes.Code := R8_ASPT_AUTOMATICOFF;
              st := Format('Автоматика отключена. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $903:
            begin
              mes.Code := R8_ASPT_DOOROPEN;
              st := Format('Открывание двери. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $904:
            begin
              mes.Code := R8_ASPT_DOORCLOSE;
              st := Format('Закрывание двери. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $905:
            begin
              mes.Code := R8_ASPT_AUTOMATICSTART;
              st := Format('Автоматический пуск. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $906:
            begin
              mes.Code := R8_ASPT_REMOTESTART;
              st := Format('Дистанционный пуск. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $907:
            begin
              mes.Code := R8_ASPT_MANUALSTART;
              st := Format('Ручной пуск. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $908:
            begin
              mes.Code := R8_ASPT_CANCELSTART;
              st := Format('Отмена пуска. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $909:
            begin
              mes.Code := R8_ASPT_EVACUATIONDELAY;
              st := Format('Задержка на эвакуацию. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $90A:
            begin
              mes.Code := R8_ASPT_FIREEXTINGUISHING;
              st := Format('Пуск ОТВ. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $90B:
            begin
              mes.Code := R8_ASPT_FIREEXTINGUISHINGCOMPLETE;
              st := Format('Пуск прошел. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $90C:
            begin
              mes.Code := R8_ASPT_AUTHORIZATIONERROR;
              st := Format
                ('Ошибка авторизации пользователя. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $90D:
            begin
              mes.Code := R8_ASPT_TIMEOUT;
              st := Format('Таймаут. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $90E:
            begin
              mes.Code := R8_ASPT_OUTLAUNCHSUCCESS;
              st := Format('Срабатывание выхода СКУП-01. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $90F:
            begin
              mes.Code := R8_ASPT_OUTLAUNCHERROR;
              st := Format
                ('Ошибка срабатывания выхода СКУП-01. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $910:
            begin
              mes.Code := R8_ASPT_TROUBLE;
              st := Format('Неисправность. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $911:
            begin
              mes.Code := R8_ASPT_SDU;
              st := Format('Срабатывание СДУ. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $912:
            begin
              mes.Code := R8_ASPT_WEIGHTSENSOR;
              st := Format
                ('Срабатывание датчика наличия ОТВ. АСПТ #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $913:
            begin
              mes.Code := R8_ASPT_RESET;
              st := Format('Сброс. АСПТ #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;
          $914:
            begin
              mes.Code := R8_ASPT_FIRE;
              st := Format('Пожар. АСПТ #%d [%.4d]. %s', [Id, Sernum, PrmStr]);
            end;

          $A01:
            begin
              mes.Code := R8_VIDEO_ARM;
              st := Format('Постановка на охрану. ВИДЕО #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $A02:
            begin
              mes.Code := R8_VIDEO_DISARM;
              st := Format('Снятие с охраны. ВИДЕО #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $A03:
            begin
              mes.Code := R8_VIDEO_ALARM;
              st := Format('Тревога. ВИДЕО #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $A04:
            begin
              mes.Code := R8_VIDEO_TROUBLE;
              st := Format('Неисправность. ВИДЕО #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $A05:
            begin
              mes.Code := R8_VIDEO_STARTRECORD;
              st := Format('Начало записи. ВИДЕО #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;
          $A06:
            begin
              mes.Code := R8_VIDEO_STOPRECORD;
              st := Format('Конец записи. ВИДЕО #%d [%.4d]. %s',
                [Id, Sernum, PrmStr]);
            end;

        end;

      end;

  end; // 1
end;

end.
