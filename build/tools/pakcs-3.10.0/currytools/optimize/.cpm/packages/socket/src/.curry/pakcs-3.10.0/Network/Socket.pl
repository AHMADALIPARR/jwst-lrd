%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').
:-importModule('System.IO').

:-curryModule('Network.Socket').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Network.Socket.listenOn',listenOn,1,'Network.Socket.listenOn',nofix,notype).
functiontype('Network.Socket.prim_listenOn','Network.Socket.prim_listenOn',1,'Network.Socket.prim_listenOn',nofix,notype).
functiontype('Network.Socket.listenOnFresh',listenOnFresh,0,'Network.Socket.listenOnFresh',nofix,notype).
functiontype('Network.Socket.accept',accept,1,'Network.Socket.accept',nofix,notype).
functiontype('Network.Socket.prim_socketAccept','Network.Socket.prim_socketAccept',1,'Network.Socket.prim_socketAccept',nofix,notype).
functiontype('Network.Socket.waitForSocketAccept',waitForSocketAccept,2,'Network.Socket.waitForSocketAccept',nofix,notype).
functiontype('Network.Socket.prim_waitForSocketAccept','Network.Socket.prim_waitForSocketAccept',2,'Network.Socket.prim_waitForSocketAccept',nofix,notype).
functiontype('Network.Socket.close',close,1,'Network.Socket.close',nofix,notype).
functiontype('Network.Socket.prim_sClose','Network.Socket.prim_sClose',1,'Network.Socket.prim_sClose',nofix,notype).
functiontype('Network.Socket.connectToSocket',connectToSocket,2,'Network.Socket.connectToSocket',nofix,notype).
functiontype('Network.Socket.prim_connectToSocket','Network.Socket.prim_connectToSocket',2,'Network.Socket.prim_connectToSocket',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Network.Socket.listenOn'(_13988526,_13988528,_13988530,_13988532):-freeze(_13988530,'blocked_Network.Socket.listenOn'(_13988526,_13988528,_13988530,_13988532)).
'blocked_Network.Socket.listenOn'(_13988612,_13988796,_13988802,_13988808):-hnf('Prelude.$#'(partcall(1,'Network.Socket.prim_listenOn',[]),_13988612),_13988796,_13988802,_13988808).

'Network.Socket.prim_listenOn'(_13989888,partcall(1,'Network.Socket.prim_listenOn$WORLD',[_13989888]),_13990296,_13990296).
'Network.Socket.prim_listenOn$WORLD'(_13990652,_13990654,_13990656,_13990658,_13990660):-freeze(_13990658,'blocked_Network.Socket.prim_listenOn$WORLD'(_13990652,_13990654,_13990656,_13990658,_13990660)).
'blocked_Network.Socket.prim_listenOn$WORLD'(_13990742,_13990748,'$io'(_13990760),_13990764,_13990296):-derefRoot(_13990742,_13989888),'Network.Socket.prim_listenOn'(_13989888,_13990760),_13990764=_13990296.

'Network.Socket.listenOnFresh'(partcall(1,'Network.Socket.listenOnFresh$WORLD',[]),_13992442,_13992442).
'Network.Socket.listenOnFresh$WORLD'(_13992790,_13992792,_13992794,_13992796):-freeze(_13992794,'blocked_Network.Socket.listenOnFresh$WORLD'(_13992790,_13992792,_13992794,_13992796)).
'blocked_Network.Socket.listenOnFresh$WORLD'(_13992870,'$io'(_13992882),_13992886,_13992442):-'Network.Socket.listenOnFresh'(_13992882),_13992886=_13992442.

'Network.Socket.accept'(_13993900,_13993902,_13993904,_13993906):-freeze(_13993904,'blocked_Network.Socket.accept'(_13993900,_13993902,_13993904,_13993906)).
'blocked_Network.Socket.accept'(_13993986,_13994170,_13994176,_13994182):-hnf('Prelude.$##'(partcall(1,'Network.Socket.prim_socketAccept',[]),_13993986),_13994170,_13994176,_13994182).

'Network.Socket.prim_socketAccept'(_13995328,partcall(1,'Network.Socket.prim_socketAccept$WORLD',[_13995328]),_13995784,_13995784).
'Network.Socket.prim_socketAccept$WORLD'(_13996164,_13996166,_13996168,_13996170,_13996172):-freeze(_13996170,'blocked_Network.Socket.prim_socketAccept$WORLD'(_13996164,_13996166,_13996168,_13996170,_13996172)).
'blocked_Network.Socket.prim_socketAccept$WORLD'(_13996254,_13996260,'$io'(_13996272),_13996276,_13995784):-derefAll(_13996254,_13995328),'Network.Socket.prim_socketAccept'(_13995328,_13996272),_13996276=_13995784.

'Network.Socket.waitForSocketAccept'(_13997832,_13997834,_13997836,_13997838,_13997840):-freeze(_13997838,'blocked_Network.Socket.waitForSocketAccept'(_13997832,_13997834,_13997836,_13997838,_13997840)).
'blocked_Network.Socket.waitForSocketAccept'(_13997928,_13997946,_13998284,_13998290,_13998296):-hnf('Prelude.$#'('Prelude.$##'(partcall(2,'Network.Socket.prim_waitForSocketAccept',[]),_13997928),_13997946),_13998284,_13998290,_13998296).

'Network.Socket.prim_waitForSocketAccept'(_14000016,_14000022,partcall(1,'Network.Socket.prim_waitForSocketAccept$WORLD',[_14000022,_14000016]),_14000568,_14000568).
'Network.Socket.prim_waitForSocketAccept$WORLD'(_14000998,_14001000,_14001002,_14001004,_14001006,_14001008):-freeze(_14001006,'blocked_Network.Socket.prim_waitForSocketAccept$WORLD'(_14000998,_14001000,_14001002,_14001004,_14001006,_14001008)).
'blocked_Network.Socket.prim_waitForSocketAccept$WORLD'(_14001098,_14001104,_14001110,'$io'(_14001122),_14001126,_14000568):-derefAll(_14001098,_14000016),derefRoot(_14001104,_14000022),'Network.Socket.prim_waitForSocketAccept'(_14000016,_14000022,_14001122),_14001126=_14000568.

'Network.Socket.close'(_14003140,_14003142,_14003144,_14003146):-freeze(_14003144,'blocked_Network.Socket.close'(_14003140,_14003142,_14003144,_14003146)).
'blocked_Network.Socket.close'(_14003226,_14003410,_14003416,_14003422):-hnf('Prelude.$##'(partcall(1,'Network.Socket.prim_sClose',[]),_14003226),_14003410,_14003416,_14003422).

'Network.Socket.prim_sClose'(_14004490,partcall(1,'Network.Socket.prim_sClose$WORLD',[_14004490]),_14004874,_14004874).
'Network.Socket.prim_sClose$WORLD'(_14005218,_14005220,_14005222,_14005224,_14005226):-freeze(_14005224,'blocked_Network.Socket.prim_sClose$WORLD'(_14005218,_14005220,_14005222,_14005224,_14005226)).
'blocked_Network.Socket.prim_sClose$WORLD'(_14005308,_14005314,'$io'(_14005326),_14005330,_14004874):-derefAll(_14005308,_14004490),'Network.Socket.prim_sClose'(_14004490,_14005326),_14005330=_14004874.

'Network.Socket.connectToSocket'(_14006734,_14006736,_14006738,_14006740,_14006742):-freeze(_14006740,'blocked_Network.Socket.connectToSocket'(_14006734,_14006736,_14006738,_14006740,_14006742)).
'blocked_Network.Socket.connectToSocket'(_14006830,_14006848,_14007186,_14007192,_14007198):-hnf('Prelude.$#'('Prelude.$##'(partcall(2,'Network.Socket.prim_connectToSocket',[]),_14006830),_14006848),_14007186,_14007192,_14007198).

'Network.Socket.prim_connectToSocket'(_14008846,_14008852,partcall(1,'Network.Socket.prim_connectToSocket$WORLD',[_14008852,_14008846]),_14009350,_14009350).
'Network.Socket.prim_connectToSocket$WORLD'(_14009756,_14009758,_14009760,_14009762,_14009764,_14009766):-freeze(_14009764,'blocked_Network.Socket.prim_connectToSocket$WORLD'(_14009756,_14009758,_14009760,_14009762,_14009764,_14009766)).
'blocked_Network.Socket.prim_connectToSocket$WORLD'(_14009856,_14009862,_14009868,'$io'(_14009880),_14009884,_14009350):-derefAll(_14009856,_14008846),derefRoot(_14009862,_14008852),'Network.Socket.prim_connectToSocket'(_14008846,_14008852,_14009880),_14009884=_14009350.

:-costCenters(['']).




%%%%% Number of shared variables: 0

:-style_check(-singleton).
'Network.Socket.prim_listenOn'(_14011034,_14011036):-listenOnNewSocket(_14011034,_14011042,_14011036).
'Network.Socket.listenOnFresh'('Prelude.(,)'(_14011110,_14011112)):-listenOnNewSocket(_14011110,_14011122,_14011112).
'Network.Socket.prim_socketAccept'(_14011186,'Prelude.(,)'(_14011180,'$stream'('$inoutstream'(_14011170,_14011172)))):-socketAccept(_14011186,_14011194,_14011170,_14011172),atom2String(_14011194,_14011180),!.
'Network.Socket.prim_waitForSocketAccept'(_14011270,_14011272,_14011274):-waitForSocketClientStream(_14011270,_14011272,_14011282,_14011284,_14011286)->atom2String(_14011282,_14011292),_14011274='Prelude.Just'('Prelude.(,)'(_14011292,'$stream'('$inoutstream'(_14011284,_14011286))));_14011274='Prelude.Nothing'.
'Network.Socket.prim_sClose'(_14011404,'Prelude.()'):-socketClose(_14011404).
'Network.Socket.prim_connectToSocket'(_14011474,_14011476,'$stream'('$inoutstream'(_14011464,_14011466))):-string2Atom(_14011474,_14011484),!,connect2socket(_14011484,_14011476,_14011464,_14011466).
