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
'Network.Socket.listenOn'(_21732762,_21732764,_21732766,_21732768):-freeze(_21732766,'blocked_Network.Socket.listenOn'(_21732762,_21732764,_21732766,_21732768)).
'blocked_Network.Socket.listenOn'(_21732848,_21733032,_21733038,_21733044):-hnf('Prelude.$#'(partcall(1,'Network.Socket.prim_listenOn',[]),_21732848),_21733032,_21733038,_21733044).

'Network.Socket.prim_listenOn'(_21734124,partcall(1,'Network.Socket.prim_listenOn$WORLD',[_21734124]),_21734532,_21734532).
'Network.Socket.prim_listenOn$WORLD'(_21734888,_21734890,_21734892,_21734894,_21734896):-freeze(_21734894,'blocked_Network.Socket.prim_listenOn$WORLD'(_21734888,_21734890,_21734892,_21734894,_21734896)).
'blocked_Network.Socket.prim_listenOn$WORLD'(_21734978,_21734984,'$io'(_21734996),_21735000,_21734532):-derefRoot(_21734978,_21734124),'Network.Socket.prim_listenOn'(_21734124,_21734996),_21735000=_21734532.

'Network.Socket.listenOnFresh'(partcall(1,'Network.Socket.listenOnFresh$WORLD',[]),_21736678,_21736678).
'Network.Socket.listenOnFresh$WORLD'(_21737026,_21737028,_21737030,_21737032):-freeze(_21737030,'blocked_Network.Socket.listenOnFresh$WORLD'(_21737026,_21737028,_21737030,_21737032)).
'blocked_Network.Socket.listenOnFresh$WORLD'(_21737106,'$io'(_21737118),_21737122,_21736678):-'Network.Socket.listenOnFresh'(_21737118),_21737122=_21736678.

'Network.Socket.accept'(_21738136,_21738138,_21738140,_21738142):-freeze(_21738140,'blocked_Network.Socket.accept'(_21738136,_21738138,_21738140,_21738142)).
'blocked_Network.Socket.accept'(_21738222,_21738406,_21738412,_21738418):-hnf('Prelude.$##'(partcall(1,'Network.Socket.prim_socketAccept',[]),_21738222),_21738406,_21738412,_21738418).

'Network.Socket.prim_socketAccept'(_21739564,partcall(1,'Network.Socket.prim_socketAccept$WORLD',[_21739564]),_21740020,_21740020).
'Network.Socket.prim_socketAccept$WORLD'(_21740400,_21740402,_21740404,_21740406,_21740408):-freeze(_21740406,'blocked_Network.Socket.prim_socketAccept$WORLD'(_21740400,_21740402,_21740404,_21740406,_21740408)).
'blocked_Network.Socket.prim_socketAccept$WORLD'(_21740490,_21740496,'$io'(_21740508),_21740512,_21740020):-derefAll(_21740490,_21739564),'Network.Socket.prim_socketAccept'(_21739564,_21740508),_21740512=_21740020.

'Network.Socket.waitForSocketAccept'(_21742068,_21742070,_21742072,_21742074,_21742076):-freeze(_21742074,'blocked_Network.Socket.waitForSocketAccept'(_21742068,_21742070,_21742072,_21742074,_21742076)).
'blocked_Network.Socket.waitForSocketAccept'(_21742164,_21742182,_21742520,_21742526,_21742532):-hnf('Prelude.$#'('Prelude.$##'(partcall(2,'Network.Socket.prim_waitForSocketAccept',[]),_21742164),_21742182),_21742520,_21742526,_21742532).

'Network.Socket.prim_waitForSocketAccept'(_21744252,_21744258,partcall(1,'Network.Socket.prim_waitForSocketAccept$WORLD',[_21744258,_21744252]),_21744804,_21744804).
'Network.Socket.prim_waitForSocketAccept$WORLD'(_21745234,_21745236,_21745238,_21745240,_21745242,_21745244):-freeze(_21745242,'blocked_Network.Socket.prim_waitForSocketAccept$WORLD'(_21745234,_21745236,_21745238,_21745240,_21745242,_21745244)).
'blocked_Network.Socket.prim_waitForSocketAccept$WORLD'(_21745334,_21745340,_21745346,'$io'(_21745358),_21745362,_21744804):-derefAll(_21745334,_21744252),derefRoot(_21745340,_21744258),'Network.Socket.prim_waitForSocketAccept'(_21744252,_21744258,_21745358),_21745362=_21744804.

'Network.Socket.close'(_21747376,_21747378,_21747380,_21747382):-freeze(_21747380,'blocked_Network.Socket.close'(_21747376,_21747378,_21747380,_21747382)).
'blocked_Network.Socket.close'(_21747462,_21747646,_21747652,_21747658):-hnf('Prelude.$##'(partcall(1,'Network.Socket.prim_sClose',[]),_21747462),_21747646,_21747652,_21747658).

'Network.Socket.prim_sClose'(_21748726,partcall(1,'Network.Socket.prim_sClose$WORLD',[_21748726]),_21749110,_21749110).
'Network.Socket.prim_sClose$WORLD'(_21749454,_21749456,_21749458,_21749460,_21749462):-freeze(_21749460,'blocked_Network.Socket.prim_sClose$WORLD'(_21749454,_21749456,_21749458,_21749460,_21749462)).
'blocked_Network.Socket.prim_sClose$WORLD'(_21749544,_21749550,'$io'(_21749562),_21749566,_21749110):-derefAll(_21749544,_21748726),'Network.Socket.prim_sClose'(_21748726,_21749562),_21749566=_21749110.

'Network.Socket.connectToSocket'(_21750970,_21750972,_21750974,_21750976,_21750978):-freeze(_21750976,'blocked_Network.Socket.connectToSocket'(_21750970,_21750972,_21750974,_21750976,_21750978)).
'blocked_Network.Socket.connectToSocket'(_21751066,_21751084,_21751422,_21751428,_21751434):-hnf('Prelude.$#'('Prelude.$##'(partcall(2,'Network.Socket.prim_connectToSocket',[]),_21751066),_21751084),_21751422,_21751428,_21751434).

'Network.Socket.prim_connectToSocket'(_21753082,_21753088,partcall(1,'Network.Socket.prim_connectToSocket$WORLD',[_21753088,_21753082]),_21753586,_21753586).
'Network.Socket.prim_connectToSocket$WORLD'(_21753992,_21753994,_21753996,_21753998,_21754000,_21754002):-freeze(_21754000,'blocked_Network.Socket.prim_connectToSocket$WORLD'(_21753992,_21753994,_21753996,_21753998,_21754000,_21754002)).
'blocked_Network.Socket.prim_connectToSocket$WORLD'(_21754092,_21754098,_21754104,'$io'(_21754116),_21754120,_21753586):-derefAll(_21754092,_21753082),derefRoot(_21754098,_21753088),'Network.Socket.prim_connectToSocket'(_21753082,_21753088,_21754116),_21754120=_21753586.

:-costCenters(['']).




%%%%% Number of shared variables: 0

:-style_check(-singleton).
'Network.Socket.prim_listenOn'(_21755270,_21755272):-listenOnNewSocket(_21755270,_21755278,_21755272).
'Network.Socket.listenOnFresh'('Prelude.(,)'(_21755346,_21755348)):-listenOnNewSocket(_21755346,_21755358,_21755348).
'Network.Socket.prim_socketAccept'(_21755422,'Prelude.(,)'(_21755416,'$stream'('$inoutstream'(_21755406,_21755408)))):-socketAccept(_21755422,_21755430,_21755406,_21755408),atom2String(_21755430,_21755416),!.
'Network.Socket.prim_waitForSocketAccept'(_21755506,_21755508,_21755510):-waitForSocketClientStream(_21755506,_21755508,_21755518,_21755520,_21755522)->atom2String(_21755518,_21755528),_21755510='Prelude.Just'('Prelude.(,)'(_21755528,'$stream'('$inoutstream'(_21755520,_21755522))));_21755510='Prelude.Nothing'.
'Network.Socket.prim_sClose'(_21755640,'Prelude.()'):-socketClose(_21755640).
'Network.Socket.prim_connectToSocket'(_21755710,_21755712,'$stream'('$inoutstream'(_21755700,_21755702))):-string2Atom(_21755710,_21755720),!,connect2socket(_21755720,_21755712,_21755700,_21755702).
