%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('System.Environment').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.Environment.getArgs',getArgs,0,'System.Environment.getArgs',nofix,notype).
functiontype('System.Environment.getEnv',getEnv,1,'System.Environment.getEnv',nofix,notype).
functiontype('System.Environment.prim_getEnviron','System.Environment.prim_getEnviron',1,'System.Environment.prim_getEnviron',nofix,notype).
functiontype('System.Environment.setEnv',setEnv,2,'System.Environment.setEnv',nofix,notype).
functiontype('System.Environment.prim_setEnviron','System.Environment.prim_setEnviron',2,'System.Environment.prim_setEnviron',nofix,notype).
functiontype('System.Environment.unsetEnv',unsetEnv,1,'System.Environment.unsetEnv',nofix,notype).
functiontype('System.Environment.prim_unsetEnviron','System.Environment.prim_unsetEnviron',1,'System.Environment.prim_unsetEnviron',nofix,notype).
functiontype('System.Environment.getHostname',getHostname,0,'System.Environment.getHostname',nofix,notype).
functiontype('System.Environment.getProgName',getProgName,0,'System.Environment.getProgName',nofix,notype).
functiontype('System.Environment.isPosix',isPosix,0,'System.Environment.isPosix',nofix,notype).
functiontype('System.Environment.isWindows',isWindows,0,'System.Environment.isWindows',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.Environment.getArgs'(partcall(1,'System.Environment.getArgs$WORLD',[]),_5170666,_5170666).
'System.Environment.getArgs$WORLD'(_5171002,_5171004,_5171006,_5171008):-freeze(_5171006,'blocked_System.Environment.getArgs$WORLD'(_5171002,_5171004,_5171006,_5171008)).
'blocked_System.Environment.getArgs$WORLD'(_5171082,'$io'(_5171094),_5171098,_5170666):-'System.Environment.getArgs'(_5171094),_5171098=_5170666.

'System.Environment.getEnv'(_5172264,_5172266,_5172268,_5172270):-freeze(_5172268,'blocked_System.Environment.getEnv'(_5172264,_5172266,_5172268,_5172270)).
'blocked_System.Environment.getEnv'(_5172350,_5172534,_5172540,_5172546):-hnf('Prelude.$##'(partcall(1,'System.Environment.prim_getEnviron',[]),_5172350),_5172534,_5172540,_5172546).

'System.Environment.prim_getEnviron'(_5173740,partcall(1,'System.Environment.prim_getEnviron$WORLD',[_5173740]),_5174220,_5174220).
'System.Environment.prim_getEnviron$WORLD'(_5174612,_5174614,_5174616,_5174618,_5174620):-freeze(_5174618,'blocked_System.Environment.prim_getEnviron$WORLD'(_5174612,_5174614,_5174616,_5174618,_5174620)).
'blocked_System.Environment.prim_getEnviron$WORLD'(_5174702,_5174708,'$io'(_5174720),_5174724,_5174220):-derefAll(_5174702,_5173740),'System.Environment.prim_getEnviron'(_5173740,_5174720),_5174724=_5174220.

'System.Environment.setEnv'(_5175938,_5175940,_5175942,_5175944,_5175946):-freeze(_5175944,'blocked_System.Environment.setEnv'(_5175938,_5175940,_5175942,_5175944,_5175946)).
'blocked_System.Environment.setEnv'(_5176034,_5176052,_5176390,_5176396,_5176402):-hnf('Prelude.$##'('Prelude.$##'(partcall(2,'System.Environment.prim_setEnviron',[]),_5176034),_5176052),_5176390,_5176396,_5176402).

'System.Environment.prim_setEnviron'(_5178038,_5178044,partcall(1,'System.Environment.prim_setEnviron$WORLD',[_5178044,_5178038]),_5178530,_5178530).
'System.Environment.prim_setEnviron$WORLD'(_5178930,_5178932,_5178934,_5178936,_5178938,_5178940):-freeze(_5178938,'blocked_System.Environment.prim_setEnviron$WORLD'(_5178930,_5178932,_5178934,_5178936,_5178938,_5178940)).
'blocked_System.Environment.prim_setEnviron$WORLD'(_5179030,_5179036,_5179042,'$io'(_5179054),_5179058,_5178530):-derefAll(_5179030,_5178038),derefAll(_5179036,_5178044),'System.Environment.prim_setEnviron'(_5178038,_5178044,_5179054),_5179058=_5178530.

'System.Environment.unsetEnv'(_5180396,_5180398,_5180400,_5180402):-freeze(_5180400,'blocked_System.Environment.unsetEnv'(_5180396,_5180398,_5180400,_5180402)).
'blocked_System.Environment.unsetEnv'(_5180482,_5180666,_5180672,_5180678):-hnf('Prelude.$##'(partcall(1,'System.Environment.prim_unsetEnviron',[]),_5180482),_5180666,_5180672,_5180678).

'System.Environment.prim_unsetEnviron'(_5181908,partcall(1,'System.Environment.prim_unsetEnviron$WORLD',[_5181908]),_5182412,_5182412).
'System.Environment.prim_unsetEnviron$WORLD'(_5182816,_5182818,_5182820,_5182822,_5182824):-freeze(_5182822,'blocked_System.Environment.prim_unsetEnviron$WORLD'(_5182816,_5182818,_5182820,_5182822,_5182824)).
'blocked_System.Environment.prim_unsetEnviron$WORLD'(_5182906,_5182912,'$io'(_5182924),_5182928,_5182412):-derefAll(_5182906,_5181908),'System.Environment.prim_unsetEnviron'(_5181908,_5182924),_5182928=_5182412.

'System.Environment.getHostname'(partcall(1,'System.Environment.getHostname$WORLD',[]),_5183700,_5183700).
'System.Environment.getHostname$WORLD'(_5184060,_5184062,_5184064,_5184066):-freeze(_5184064,'blocked_System.Environment.getHostname$WORLD'(_5184060,_5184062,_5184064,_5184066)).
'blocked_System.Environment.getHostname$WORLD'(_5184140,'$io'(_5184152),_5184156,_5183700):-'System.Environment.getHostname'(_5184152),_5184156=_5183700.

'System.Environment.getProgName'(partcall(1,'System.Environment.getProgName$WORLD',[]),_5184880,_5184880).
'System.Environment.getProgName$WORLD'(_5185240,_5185242,_5185244,_5185246):-freeze(_5185244,'blocked_System.Environment.getProgName$WORLD'(_5185240,_5185242,_5185244,_5185246)).
'blocked_System.Environment.getProgName$WORLD'(_5185320,'$io'(_5185332),_5185336,_5184880):-'System.Environment.getProgName'(_5185332),_5185336=_5184880.

'System.Environment.isPosix'(_5186540,_5186542,_5186544):-freeze(_5186542,'blocked_System.Environment.isPosix'(_5186540,_5186542,_5186544)).
'blocked_System.Environment.isPosix'(_5186712,_5186718,_5186724):-hnf('Prelude.not'('System.Environment.isWindows'),_5186712,_5186718,_5186724).

'System.Environment.isWindows'(_5187868,_5187870,_5187872):-freeze(_5187870,'blocked_System.Environment.isWindows'(_5187868,_5187870,_5187872)).
'blocked_System.Environment.isWindows'(_5187938,_5187944,_5187950):-'System.Environment.isWindows'(_5187938),_5187944=_5187950.

:-costCenters(['']).




%%%%% Number of shared variables: 0

:-style_check(-singleton).
'System.Environment.getArgs'(_5188060):-(rtArgs(_5188064)->true;getProgramArgs(_5188064)),map2M(basics:atom2String,_5188064,_5188060).
'System.Environment.prim_getEnviron'(_5188158,_5188160):-string2Atom(_5188158,_5188166),(getEnv(_5188166,_5188172)->atom2String(_5188172,_5188160);_5188160=[]).
'System.Environment.prim_setEnviron'(_5188256,_5188258,'Prelude.()'):-string2Atom(_5188256,_5188266),string2Atom(_5188258,_5188272),setEnv(_5188266,_5188272).
'System.Environment.prim_unsetEnviron'(_5188352,'Prelude.()'):-string2Atom(_5188352,_5188360),unsetEnv(_5188360).
'System.Environment.getHostname'(_5188424):-getHostname(_5188428),atom2String(_5188428,_5188424).
'System.Environment.getProgName'(_5188486):-user:currentModuleFile(_5188490,_5188492),atom2String(_5188490,_5188486).
'System.Environment.isWindows'(_5188556):-getEnv('COMSPEC',_5188562)->_5188556='Prelude.True';_5188556='Prelude.False'.
