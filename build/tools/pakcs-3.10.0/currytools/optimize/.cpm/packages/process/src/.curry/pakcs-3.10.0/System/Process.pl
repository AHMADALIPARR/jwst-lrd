%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').
:-importModule('System.Environment').

:-curryModule('System.Process').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.Process.getPID',getPID,0,'System.Process.getPID',nofix,notype).
functiontype('System.Process.system',system,1,'System.Process.system',nofix,notype).
functiontype('System.Process.prim_system','System.Process.prim_system',1,'System.Process.prim_system',nofix,notype).
functiontype('System.Process.exitWith',exitWith,1,'System.Process.exitWith',nofix,notype).
functiontype('System.Process.prim_exitWith','System.Process.prim_exitWith',1,'System.Process.prim_exitWith',nofix,notype).
functiontype('System.Process.sleep',sleep,1,'System.Process.sleep',nofix,notype).
functiontype('System.Process.prim_sleep','System.Process.prim_sleep',1,'System.Process.prim_sleep',nofix,notype).
functiontype('System.Process.system._\'23caseor0','System.Process.system._#caseor0',2,'System.Process.system._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.Process.getPID'(partcall(1,'System.Process.getPID$WORLD',[]),_29907850,_29907850).
'System.Process.getPID$WORLD'(_29908156,_29908158,_29908160,_29908162):-freeze(_29908160,'blocked_System.Process.getPID$WORLD'(_29908156,_29908158,_29908160,_29908162)).
'blocked_System.Process.getPID$WORLD'(_29908236,'$io'(_29908248),_29908252,_29907850):-'System.Process.getPID'(_29908248),_29908252=_29907850.

'System.Process.system'(_29909266,_29909268,_29909270,_29909272):-freeze(_29909270,'blocked_System.Process.system'(_29909266,_29909268,_29909270,_29909272)).
'blocked_System.Process.system'(_29909352,_29910378,_29910384,_29910390):-makeShare(_29909380,_29910568),makeShare(_29909398,_29910588),hnf('Prelude.cond'(letrec4PAKCS(_29910568,'System.Environment.isWindows'),'Prelude.cond'(letrec4PAKCS(_29910588,'System.Process.system._\'23caseor0'(_29910568,_29909352)),'Prelude.$##'(partcall(1,'System.Process.prim_system',[]),_29910588))),_29910378,_29910384,_29910390).

'System.Process.prim_system'(_29913820,partcall(1,'System.Process.prim_system$WORLD',[_29913820]),_29914204,_29914204).
'System.Process.prim_system$WORLD'(_29914548,_29914550,_29914552,_29914554,_29914556):-freeze(_29914554,'blocked_System.Process.prim_system$WORLD'(_29914548,_29914550,_29914552,_29914554,_29914556)).
'blocked_System.Process.prim_system$WORLD'(_29914638,_29914644,'$io'(_29914656),_29914660,_29914204):-derefAll(_29914638,_29913820),'System.Process.prim_system'(_29913820,_29914656),_29914660=_29914204.

'System.Process.exitWith'(_29915798,_29915800,_29915802,_29915804):-freeze(_29915802,'blocked_System.Process.exitWith'(_29915798,_29915800,_29915802,_29915804)).
'blocked_System.Process.exitWith'(_29915884,_29916068,_29916074,_29916080):-hnf('Prelude.$#'(partcall(1,'System.Process.prim_exitWith',[]),_29915884),_29916068,_29916074,_29916080).

'System.Process.prim_exitWith'(_29917160,partcall(1,'System.Process.prim_exitWith$WORLD',[_29917160]),_29917568,_29917568).
'System.Process.prim_exitWith$WORLD'(_29917924,_29917926,_29917928,_29917930,_29917932):-freeze(_29917930,'blocked_System.Process.prim_exitWith$WORLD'(_29917924,_29917926,_29917928,_29917930,_29917932)).
'blocked_System.Process.prim_exitWith$WORLD'(_29918014,_29918020,'$io'(_29918032),_29918036,_29917568):-derefRoot(_29918014,_29917160),'System.Process.prim_exitWith'(_29917160,_29918032),_29918036=_29917568.

'System.Process.sleep'(_29920002,_29920004,_29920006,_29920008):-freeze(_29920006,'blocked_System.Process.sleep'(_29920002,_29920004,_29920006,_29920008)).
'blocked_System.Process.sleep'(_29920088,_29920272,_29920278,_29920284):-hnf('Prelude.$#'(partcall(1,'System.Process.prim_sleep',[]),_29920088),_29920272,_29920278,_29920284).

'System.Process.prim_sleep'(_29921310,partcall(1,'System.Process.prim_sleep$WORLD',[_29921310]),_29921682,_29921682).
'System.Process.prim_sleep$WORLD'(_29922020,_29922022,_29922024,_29922026,_29922028):-freeze(_29922026,'blocked_System.Process.prim_sleep$WORLD'(_29922020,_29922022,_29922024,_29922026,_29922028)).
'blocked_System.Process.prim_sleep$WORLD'(_29922110,_29922116,'$io'(_29922128),_29922132,_29921682):-derefRoot(_29922110,_29921310),'System.Process.prim_sleep'(_29921310,_29922128),_29922132=_29921682.

'System.Process.system._\'23caseor0'(_29924544,_29924546,_29924548,_29924550,_29924552):-freeze(_29924550,'blocked_System.Process.system._\'23caseor0'(_29924544,_29924546,_29924548,_29924550,_29924552)).
'blocked_System.Process.system._\'23caseor0'(_29924640,_29924658,_29925616,_29925622,_29925628):-hnf(_29924640,_29927190,_29925622,_29927208),'blocked_System.Process.system._\'23caseor0_1'(_29927190,_29924658,_29925616,_29927208,_29925628).

'blocked_System.Process.system._\'23caseor0_1'(_29927662,_29927664,_29927666,_29927668,_29927670):-freeze(_29927668,freeze(_29927662,'blocked_blocked_System.Process.system._\'23caseor0_1'(_29927662,_29927664,_29927666,_29927668,_29927670))).
'blocked_blocked_System.Process.system._\'23caseor0_1'('Prelude.True',_29924658,['^"'|'Prelude.++'(_29924658,['^"'])],_29928062,_29928062).
'blocked_blocked_System.Process.system._\'23caseor0_1'('Prelude.False',_29924658,_29929592,_29929598,_29929604):-!,hnf(_29924658,_29929592,_29929598,_29929604).
'blocked_blocked_System.Process.system._\'23caseor0_1'('FAIL'(_29930112),_29924658,'FAIL'(_29930112),_29930126,_29930126).

:-costCenters(['']).




%%%%% Number of shared variables: 2

:-style_check(-singleton).
'System.Process.getPID'(_29930210):-currentPID(_29930210).
'System.Process.prim_system'(_29930272,_29930274):-string2Atom(_29930272,_29930280),shellCmd(_29930280,_29930274).
'System.Process.prim_exitWith'(_29930346,_29930348):-halt(_29930346).
'System.Process.prim_sleep'(_29930406,'Prelude.()'):-sleepSeconds(_29930406).
