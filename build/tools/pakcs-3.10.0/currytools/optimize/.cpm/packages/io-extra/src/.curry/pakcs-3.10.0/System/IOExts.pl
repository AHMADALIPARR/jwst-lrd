%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Monad').
:-importModule('Prelude').
:-importModule('System.Directory').
:-importModule('System.IO').
:-importModule('System.Process').

:-curryModule('System.IOExts').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.IOExts.execCmd',execCmd,1,'System.IOExts.execCmd',nofix,notype).
functiontype('System.IOExts.prim_execCmd','System.IOExts.prim_execCmd',1,'System.IOExts.prim_execCmd',nofix,notype).
functiontype('System.IOExts.evalCmd',evalCmd,3,'System.IOExts.evalCmd',nofix,notype).
functiontype('System.IOExts.evalCmd.wrapArg.4','System.IOExts.evalCmd.wrapArg.4',1,'System.IOExts.evalCmd.wrapArg.4',nofix,notype).
functiontype('System.IOExts.evalCmd.wrapArg.4.escape.6','System.IOExts.evalCmd.wrapArg.4.escape.6',2,'System.IOExts.evalCmd.wrapArg.4.escape.6',nofix,notype).
functiontype('System.IOExts.evalCmd.wrapArg.4.goodChar.6','System.IOExts.evalCmd.wrapArg.4.goodChar.6',1,'System.IOExts.evalCmd.wrapArg.4.goodChar.6',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6','System.IOExts.evalCmd._#lambda6',4,'System.IOExts.evalCmd._\'23lambda6',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8','System.IOExts.evalCmd._#lambda6._#lambda8',3,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10','System.IOExts.evalCmd._#lambda6._#lambda8._#lambda10',3,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12','System.IOExts.evalCmd._#lambda6._#lambda8._#lambda10._#lambda12',3,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14','System.IOExts.evalCmd._#lambda6._#lambda8._#lambda10._#lambda12._#lambda14',4,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14',nofix,notype).
functiontype('System.IOExts.connectToCommand',connectToCommand,1,'System.IOExts.connectToCommand',nofix,notype).
functiontype('System.IOExts.prim_connectToCmd','System.IOExts.prim_connectToCmd',1,'System.IOExts.prim_connectToCmd',nofix,notype).
functiontype('System.IOExts.readCompleteFile',readCompleteFile,1,'System.IOExts.readCompleteFile',nofix,notype).
functiontype('System.IOExts.readCompleteFile.f.21','System.IOExts.readCompleteFile.f.21',2,'System.IOExts.readCompleteFile.f.21',nofix,notype).
functiontype('System.IOExts.readCompleteFile._\'23lambda17','System.IOExts.readCompleteFile._#lambda17',1,'System.IOExts.readCompleteFile._\'23lambda17',nofix,notype).
functiontype('System.IOExts.updateFile',updateFile,2,'System.IOExts.updateFile',nofix,notype).
functiontype('System.IOExts.updateFile._\'23lambda20','System.IOExts.updateFile._#lambda20',3,'System.IOExts.updateFile._\'23lambda20',nofix,notype).
functiontype('System.IOExts.exclusiveIO',exclusiveIO,2,'System.IOExts.exclusiveIO',nofix,notype).
functiontype('System.IOExts.exclusiveIO._\'23lambda23','System.IOExts.exclusiveIO._#lambda23',2,'System.IOExts.exclusiveIO._\'23lambda23',nofix,notype).
functiontype('System.IOExts.exclusiveIO._\'23lambda25','System.IOExts.exclusiveIO._#lambda25',2,'System.IOExts.exclusiveIO._\'23lambda25',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.IOExts.execCmd'(_27357656,_27357658,_27357660,_27357662):-freeze(_27357660,'blocked_System.IOExts.execCmd'(_27357656,_27357658,_27357660,_27357662)).
'blocked_System.IOExts.execCmd'(_27357742,_27357926,_27357932,_27357938):-hnf('Prelude.$##'(partcall(1,'System.IOExts.prim_execCmd',[]),_27357742),_27357926,_27357932,_27357938).

'System.IOExts.prim_execCmd'(_27359012,partcall(1,'System.IOExts.prim_execCmd$WORLD',[_27359012]),_27359396,_27359396).
'System.IOExts.prim_execCmd$WORLD'(_27359740,_27359742,_27359744,_27359746,_27359748):-freeze(_27359746,'blocked_System.IOExts.prim_execCmd$WORLD'(_27359740,_27359742,_27359744,_27359746,_27359748)).
'blocked_System.IOExts.prim_execCmd$WORLD'(_27359830,_27359836,'$io'(_27359848),_27359852,_27359396):-derefAll(_27359830,_27359012),'System.IOExts.prim_execCmd'(_27359012,_27359848),_27359852=_27359396.

'System.IOExts.evalCmd'(_27360914,_27360916,_27360918,_27360920,_27360922,_27360924):-freeze(_27360922,'blocked_System.IOExts.evalCmd'(_27360914,_27360916,_27360918,_27360920,_27360922,_27360924)).
'blocked_System.IOExts.evalCmd'(_27361020,_27361038,_27361056,_27361632,_27361638,_27361644):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Process.getPID'),partcall(1,'System.IOExts.evalCmd._\'23lambda6',[_27361038,_27361056,_27361020])),_27361632,_27361638,_27361644).

'System.IOExts.evalCmd.wrapArg.4'(_27365054,_27365056,_27365058,_27365060):-freeze(_27365058,'blocked_System.IOExts.evalCmd.wrapArg.4'(_27365054,_27365056,_27365058,_27365060)).
'blocked_System.IOExts.evalCmd.wrapArg.4'(_27365140,_27368926,_27368932,_27368938):-makeShare(_27365140,_27367440),hnf('Prelude.null'(_27367440),_27370516,_27368932,_27370488),'blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'(_27370516,_27367440,_27368926,_27370488,_27368938).

'blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'(_27371002,_27371004,_27371006,_27371008,_27371010):-freeze(_27371008,freeze(_27371002,'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'(_27371002,_27371004,_27371006,_27371008,_27371010))).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'('Prelude.True',_27367440,['^\'','^\''],_27371402,_27371402).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'('Prelude.False',_27367440,_27374642,_27374648,_27374654):-!,makeShare(_27367440,_27372758),hnf('Prelude.apply'('Prelude.all'(partcall(1,'System.IOExts.evalCmd.wrapArg.4.goodChar.6',[])),_27372758),_27377380,_27374648,_27377352),'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'(_27377380,_27372758,_27374642,_27377352,_27374654).

'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'(_27378088,_27378090,_27378092,_27378094,_27378096):-freeze(_27378094,freeze(_27378088,'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'(_27378088,_27378090,_27378092,_27378094,_27378096))).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_27372758,_27378482,_27378488,_27378494):-hnf(_27372758,_27378482,_27378488,_27378494).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_27372758,_27380704,_27380710,_27380716):-!,hnf('Prelude.otherwise',_27384666,_27380710,_27384638),'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_27384666,_27372758,_27380704,_27384638,_27380716).

'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_27385566,_27385568,_27385570,_27385572,_27385574):-freeze(_27385572,freeze(_27385566,'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_27385566,_27385568,_27385570,_27385572,_27385574))).
'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_27372758,['^\''|'Prelude.foldr'(partcall(2,'System.IOExts.evalCmd.wrapArg.4.escape.6',[]),['^\''],_27372758)],_27385966,_27385966).
'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_27372758,_27388258,_27388264,_27388270):-!,hnf(reportFailure4PAKCS('System.IOExts.evalCmd.wrapArg.4',['Prelude.False']),_27388258,_27388264,_27388270).
'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_27390058),_27372758,'FAIL'(_27390058),_27390072,_27390072).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_27390132),_27372758,'FAIL'(_27390132),_27390146,_27390146).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'('FAIL'(_27390206),_27367440,'FAIL'(_27390206),_27390220,_27390220).

'System.IOExts.evalCmd.wrapArg.4.escape.6'(_27391928,_27391930,_27391932,_27391934,_27391936):-freeze(_27391934,'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6'(_27391928,_27391930,_27391932,_27391934,_27391936)).
'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6'(_27392024,_27392042,_27395782,_27395788,_27395794):-makeShare(_27392024,_27394042),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_27394042,'^\''),_27397710,_27395788,_27397676),'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'(_27397710,_27394042,_27392042,_27395782,_27397676,_27395794).

'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'(_27398252,_27398254,_27398256,_27398258,_27398260,_27398262):-freeze(_27398260,freeze(_27398252,'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'(_27398252,_27398254,_27398256,_27398258,_27398260,_27398262))).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'('Prelude.True',_27394042,_27392042,_27398656,_27398662,_27398668):-hnf('Prelude.++'(['^\'',^\,'^\'','^\''],_27392042),_27398656,_27398662,_27398668).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'('Prelude.False',_27394042,_27392042,_27401812,_27401818,_27401824):-!,hnf('Prelude.otherwise',_27404888,_27401818,_27404854),'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'(_27404888,_27394042,_27392042,_27401812,_27404854,_27401824).

'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'(_27405640,_27405642,_27405644,_27405646,_27405648,_27405650):-freeze(_27405648,freeze(_27405640,'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'(_27405640,_27405642,_27405644,_27405646,_27405648,_27405650))).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_27394042,_27392042,[_27394042|_27392042],_27406050,_27406050).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_27394042,_27392042,_27407432,_27407438,_27407444):-!,hnf(reportFailure4PAKCS('System.IOExts.evalCmd.wrapArg.4.escape.6',['Prelude.False']),_27407432,_27407438,_27407444).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_27409210),_27394042,_27392042,'FAIL'(_27409210),_27409224,_27409224).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'('FAIL'(_27409292),_27394042,_27392042,'FAIL'(_27409292),_27409306,_27409306).

'System.IOExts.evalCmd.wrapArg.4.goodChar.6'(_27411098,_27411100,_27411102,_27411104):-freeze(_27411102,'blocked_System.IOExts.evalCmd.wrapArg.4.goodChar.6'(_27411098,_27411100,_27411102,_27411104)).
'blocked_System.IOExts.evalCmd.wrapArg.4.goodChar.6'(_27411184,_27412544,_27412550,_27412556):-makeShare(_27411184,_27412660),hnf('Prelude.||'('Prelude.isAlphaNum'(_27412660),'Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_27412660),[^-,'^_',^.,'^,',^/])),_27412544,_27412550,_27412556).

'System.IOExts.evalCmd._\'23lambda6'(_27417012,_27417014,_27417016,_27417018,_27417020,_27417022,_27417024):-freeze(_27417022,'blocked_System.IOExts.evalCmd._\'23lambda6'(_27417012,_27417014,_27417016,_27417018,_27417020,_27417022,_27417024)).
'blocked_System.IOExts.evalCmd._\'23lambda6'(_27417128,_27417146,_27417164,_27417182,_27424746,_27424752,_27424758):-makeShare(_27417210,_27425356),makeShare(_27417228,_27425376),hnf('Prelude.cond'(letrec4PAKCS(_27425356,_27417182),'Prelude.cond'(letrec4PAKCS(_27425376,'Prelude.++'([^/,'^t','^m','^p',^/,'^P','^A','^K','^C','^S','^_','^e','^v','^a','^l','^C','^M','^D'],'Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_27425356))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IOExts.execCmd'('Prelude.++'('Prelude.unwords'('Prelude.map'(partcall(1,'System.IOExts.evalCmd.wrapArg.4',[]),[_27417128|_27417164])),'Prelude.++'(['^ ','^;','^ ','^(','^e','^c','^h','^o','^ ',^$,^?,'^ ',^>,'^ '],'Prelude.++'(_27425376,['^)']))))),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8',[_27425376,_27417146])))),_27424746,_27424752,_27424758).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8'(_27440248,_27440250,_27440252,_27440254,_27440256,_27440258):-freeze(_27440256,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8'(_27440248,_27440250,_27440252,_27440254,_27440256,_27440258)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8'(_27440354,_27440372,_27440390,_27442710,_27442716,_27442722):-hnf(_27440390,_27444724,_27442716,_27444748),'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'(_27444724,_27440354,_27440372,_27442710,_27444748,_27442722).

'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'(_27445282,_27445284,_27445286,_27445288,_27445290,_27445292):-freeze(_27445290,freeze(_27445282,'blocked_blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'(_27445282,_27445284,_27445286,_27445288,_27445290,_27445292))).
'blocked_blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'('Prelude.(,,)'(_27440506,_27440524,_27440542),_27440354,_27440372,_27445692,_27445698,_27445704):-!,makeShare(_27440354,_27446026),makeShare(_27440506,_27446046),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Control.Monad.unless'(partcall(1,'Prelude._inst\'23Prelude.Applicative\'23Prelude.IO\'23',[]),'Prelude.null'(_27446026),'System.IO.hPutStrLn'(_27446046,_27446026))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hClose'(_27446046)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetContents'(_27440524)),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10',[_27440372,_27440542])))),_27445692,_27445698,_27445704).
'blocked_blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'('FAIL'(_27452144),_27440354,_27440372,'FAIL'(_27452144),_27452158,_27452158).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10'(_27454414,_27454416,_27454418,_27454420,_27454422,_27454424):-freeze(_27454422,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10'(_27454414,_27454416,_27454418,_27454420,_27454422,_27454424)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10'(_27454520,_27454538,_27454556,_27455474,_27455480,_27455486):-makeShare(_27454584,_27455702),hnf('Prelude.cond'(letrec4PAKCS(_27455702,_27454556),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetContents'(_27454520)),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12',[_27454538,_27455702]))),_27455474,_27455480,_27455486).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12'(_27461600,_27461602,_27461604,_27461606,_27461608,_27461610):-freeze(_27461608,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12'(_27461600,_27461602,_27461604,_27461606,_27461608,_27461610)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12'(_27461706,_27461724,_27461742,_27462730,_27462736,_27462742):-makeShare(_27461770,_27462996),makeShare(_27461724,_27463016),hnf('Prelude.cond'(letrec4PAKCS(_27462996,_27461742),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IOExts.readCompleteFile'(_27463016)),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14',[_27463016,_27461706,_27462996]))),_27462730,_27462736,_27462742).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14'(_27469864,_27469866,_27469868,_27469870,_27469872,_27469874,_27469876):-freeze(_27469874,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14'(_27469864,_27469866,_27469868,_27469870,_27469872,_27469874,_27469876)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14'(_27469980,_27469998,_27470016,_27470034,_27471358,_27471364,_27471370):-makeShare(_27470062,_27471664),hnf('Prelude.cond'(letrec4PAKCS(_27471664,_27470034),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.removeFile'(_27470016)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.(,,)'('Prelude.read'(partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Int\'23',[]),_27471664),_27469998,_27469980)))),_27471358,_27471364,_27471370).

'System.IOExts.connectToCommand'(_27477314,_27477316,_27477318,_27477320):-freeze(_27477318,'blocked_System.IOExts.connectToCommand'(_27477314,_27477316,_27477318,_27477320)).
'blocked_System.IOExts.connectToCommand'(_27477400,_27477584,_27477590,_27477596):-hnf('Prelude.$##'(partcall(1,'System.IOExts.prim_connectToCmd',[]),_27477400),_27477584,_27477590,_27477596).

'System.IOExts.prim_connectToCmd'(_27478784,partcall(1,'System.IOExts.prim_connectToCmd$WORLD',[_27478784]),_27479228,_27479228).
'System.IOExts.prim_connectToCmd$WORLD'(_27479602,_27479604,_27479606,_27479608,_27479610):-freeze(_27479608,'blocked_System.IOExts.prim_connectToCmd$WORLD'(_27479602,_27479604,_27479606,_27479608,_27479610)).
'blocked_System.IOExts.prim_connectToCmd$WORLD'(_27479692,_27479698,'$io'(_27479710),_27479714,_27479228):-derefAll(_27479692,_27478784),'System.IOExts.prim_connectToCmd'(_27478784,_27479710),_27479714=_27479228.

'System.IOExts.readCompleteFile'(_27481118,_27481120,_27481122,_27481124):-freeze(_27481122,'blocked_System.IOExts.readCompleteFile'(_27481118,_27481120,_27481122,_27481124)).
'blocked_System.IOExts.readCompleteFile'(_27481204,_27481640,_27481646,_27481652):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_27481204)),partcall(1,'System.IOExts.readCompleteFile._\'23lambda17',[])),_27481640,_27481646,_27481652).

'System.IOExts.readCompleteFile.f.21'(_27484920,_27484922,_27484924,_27484926,_27484928):-freeze(_27484926,'blocked_System.IOExts.readCompleteFile.f.21'(_27484920,_27484922,_27484924,_27484926,_27484928)).
'blocked_System.IOExts.readCompleteFile.f.21'(_27485016,_27485034,_27485730,_27485736,_27485742):-hnf(_27485016,_27487376,_27485736,_27487394),'blocked_System.IOExts.readCompleteFile.f.21_1'(_27487376,_27485034,_27485730,_27487394,_27485742).

'blocked_System.IOExts.readCompleteFile.f.21_1'(_27487854,_27487856,_27487858,_27487860,_27487862):-freeze(_27487860,'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'(_27487854,_27487856,_27487858,_27487860,_27487862)).
'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'([],_27485034,_27488106,_27488112,_27488118):-hnf(_27485034,_27488106,_27488112,_27488118).
'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'([_27485236|_27485254],_27485034,_27488810,_27488816,_27488822):-!,hnf('System.IOExts.readCompleteFile.f.21'(_27485254,_27485034),_27488810,_27488816,_27488822).
'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'('FAIL'(_27489898),_27485034,'FAIL'(_27489898),_27489912,_27489912):-nonvar(_27489898).

'System.IOExts.readCompleteFile._\'23lambda17'(_27491690,_27491692,_27491694,_27491696):-freeze(_27491694,'blocked_System.IOExts.readCompleteFile._\'23lambda17'(_27491690,_27491692,_27491694,_27491696)).
'blocked_System.IOExts.readCompleteFile._\'23lambda17'(_27491776,_27492456,_27492462,_27492468):-makeShare(_27491804,_27492590),hnf('Prelude.cond'(letrec4PAKCS(_27492590,_27491776),'System.IOExts.readCompleteFile.f.21'(_27492590,'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_27492590))),_27492456,_27492462,_27492468).

'System.IOExts.updateFile'(_27495912,_27495914,_27495916,_27495918,_27495920):-freeze(_27495918,'blocked_System.IOExts.updateFile'(_27495912,_27495914,_27495916,_27495918,_27495920)).
'blocked_System.IOExts.updateFile'(_27496008,_27496026,_27496602,_27496608,_27496614):-makeShare(_27496026,_27496730),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IOExts.readCompleteFile'(_27496730)),partcall(1,'System.IOExts.updateFile._\'23lambda20',[_27496008,_27496730])),_27496602,_27496608,_27496614).

'System.IOExts.updateFile._\'23lambda20'(_27500438,_27500440,_27500442,_27500444,_27500446,_27500448):-freeze(_27500446,'blocked_System.IOExts.updateFile._\'23lambda20'(_27500438,_27500440,_27500442,_27500444,_27500446,_27500448)).
'blocked_System.IOExts.updateFile._\'23lambda20'(_27500544,_27500562,_27500580,_27501246,_27501252,_27501258):-makeShare(_27500608,_27501468),hnf('Prelude.cond'(letrec4PAKCS(_27501468,_27500580),'Prelude.writeFile'(_27500544,'Prelude.apply'(_27500562,_27501468))),_27501246,_27501252,_27501258).

'System.IOExts.exclusiveIO'(_27504472,_27504474,_27504476,_27504478,_27504480):-freeze(_27504478,'blocked_System.IOExts.exclusiveIO'(_27504472,_27504474,_27504476,_27504478,_27504480)).
'blocked_System.IOExts.exclusiveIO'(_27504568,_27504586,_27515206,_27515212,_27515218):-makeShare(_27504614,_27515664),makeShare(_27504568,_27515684),hnf('Prelude.cond'(letrec4PAKCS(_27515664,'Prelude.$'(partcall(1,'System.Process.system',[]),'Prelude.++'(['^l','^o','^c','^k','^f','^i','^l','^e',^-,'^r','^e','^m','^o','^v','^e','^ ',^-,^-,'^l','^o','^c','^k',^-,'^n','^a','^m','^e','^ '],_27515684))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'System.Process.system',[]),'Prelude.++'(['^l','^o','^c','^k','^f','^i','^l','^e',^-,'^c','^r','^e','^a','^t','^e','^ ',^-,^-,'^l','^o','^c','^k',^-,'^n','^a','^m','^e','^ '],_27515684))),'Prelude.catch'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23',_27504586),partcall(1,'System.IOExts.exclusiveIO._\'23lambda23',[_27515664])),partcall(1,'System.IOExts.exclusiveIO._\'23lambda25',[_27515664])))),_27515206,_27515212,_27515218).

'System.IOExts.exclusiveIO._\'23lambda23'(_27534022,_27534024,_27534026,_27534028,_27534030):-freeze(_27534028,'blocked_System.IOExts.exclusiveIO._\'23lambda23'(_27534022,_27534024,_27534026,_27534028,_27534030)).
'blocked_System.IOExts.exclusiveIO._\'23lambda23'(_27534118,_27534136,_27534984,_27534990,_27534996):-makeShare(_27534164,_27535154),hnf('Prelude.cond'(letrec4PAKCS(_27535154,_27534136),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23',_27534118),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_27535154))),_27534984,_27534990,_27534996).

'System.IOExts.exclusiveIO._\'23lambda25'(_27539490,_27539492,_27539494,_27539496,_27539498):-freeze(_27539496,'blocked_System.IOExts.exclusiveIO._\'23lambda25'(_27539490,_27539492,_27539494,_27539496,_27539498)).
'blocked_System.IOExts.exclusiveIO._\'23lambda25'(_27539586,_27539604,_27540026,_27540032,_27540038):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23',_27539586),'Prelude.ioError'(_27539604)),_27540026,_27540032,_27540038).

:-costCenters(['']).




%%%%% Number of shared variables: 18

:-style_check(-singleton).
'System.IOExts.prim_execCmd'(_27541712,'Prelude.(,,)'(_27541704,_27541706,_27541708)):-string2Atom(_27541712,_27541720),execCommand(_27541720,_27541704,_27541706,_27541708).
'System.IOExts.prim_connectToCmd'(_27541812,'$stream'('$inoutstream'(_27541802,_27541804))):-string2Atom(_27541812,_27541820),execCommand(_27541820,_27541804,_27541802,std).
