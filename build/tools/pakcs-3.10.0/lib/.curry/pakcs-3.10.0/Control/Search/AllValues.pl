%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Search.Unsafe').
:-importModule('Prelude').

:-curryModule('Control.Search.AllValues').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Control.Search.AllValues.getAllValues',getAllValues,1,'Control.Search.AllValues.getAllValues',nofix,notype).
functiontype('Control.Search.AllValues.getAllValuesDFS',getAllValuesDFS,1,'Control.Search.AllValues.getAllValuesDFS',nofix,notype).
functiontype('Control.Search.AllValues.getOneValue',getOneValue,1,'Control.Search.AllValues.getOneValue',nofix,notype).
functiontype('Control.Search.AllValues.getOneValueDFS',getOneValueDFS,1,'Control.Search.AllValues.getOneValueDFS',nofix,notype).
functiontype('Control.Search.AllValues.getAllFailures',getAllFailures,2,'Control.Search.AllValues.getAllFailures',nofix,notype).
functiontype('Control.Search.AllValues.getAllFailures._\'23lambda3','Control.Search.AllValues.getAllFailures._#lambda3',2,'Control.Search.AllValues.getAllFailures._\'23lambda3',nofix,notype).
functiontype('Control.Search.AllValues.getAllFailures._\'23lambda3._\'23lambda5','Control.Search.AllValues.getAllFailures._#lambda3._#lambda5',1,'Control.Search.AllValues.getAllFailures._\'23lambda3._\'23lambda5',nofix,notype).
functiontype('Control.Search.AllValues.naf','Control.Search.AllValues.naf',2,'Control.Search.AllValues.naf',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Control.Search.AllValues.getAllValues'(_3574306,_3574308,_3574310,_3574312):-freeze(_3574310,'blocked_Control.Search.AllValues.getAllValues'(_3574306,_3574308,_3574310,_3574312)).
'blocked_Control.Search.AllValues.getAllValues'(_3574392,_3574660,_3574666,_3574672):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.Unsafe.allValues'(_3574392)),_3574660,_3574666,_3574672).

'Control.Search.AllValues.getAllValuesDFS'(_3577686,_3577688,_3577690,_3577692):-freeze(_3577690,'blocked_Control.Search.AllValues.getAllValuesDFS'(_3577686,_3577688,_3577690,_3577692)).
'blocked_Control.Search.AllValues.getAllValuesDFS'(_3577772,_3578040,_3578046,_3578052):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.Unsafe.allValuesDFS'(_3577772)),_3578040,_3578046,_3578052).

'Control.Search.AllValues.getOneValue'(_3580950,_3580952,_3580954,_3580956):-freeze(_3580954,'blocked_Control.Search.AllValues.getOneValue'(_3580950,_3580952,_3580954,_3580956)).
'blocked_Control.Search.AllValues.getOneValue'(_3581036,_3581304,_3581310,_3581316):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.Unsafe.oneValue'(_3581036)),_3581304,_3581310,_3581316).

'Control.Search.AllValues.getOneValueDFS'(_3584280,_3584282,_3584284,_3584286):-freeze(_3584284,'blocked_Control.Search.AllValues.getOneValueDFS'(_3584280,_3584282,_3584284,_3584286)).
'blocked_Control.Search.AllValues.getOneValueDFS'(_3584366,_3584634,_3584640,_3584646):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.Unsafe.oneValueDFS'(_3584366)),_3584634,_3584640,_3584646).

'Control.Search.AllValues.getAllFailures'(_3587646,_3587648,_3587650,_3587652,_3587654):-freeze(_3587652,'blocked_Control.Search.AllValues.getAllFailures'(_3587646,_3587648,_3587650,_3587652,_3587654)).
'blocked_Control.Search.AllValues.getAllFailures'(_3587742,_3587760,_3588266,_3588272,_3588278):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.AllValues.getAllValues'(_3587742)),partcall(1,'Control.Search.AllValues.getAllFailures._\'23lambda3',[_3587760])),_3588266,_3588272,_3588278).

'Control.Search.AllValues.getAllFailures._\'23lambda3'(_3592516,_3592518,_3592520,_3592522,_3592524):-freeze(_3592522,'blocked_Control.Search.AllValues.getAllFailures._\'23lambda3'(_3592516,_3592518,_3592520,_3592522,_3592524)).
'blocked_Control.Search.AllValues.getAllFailures._\'23lambda3'(_3592612,_3592630,_3593730,_3593736,_3593742):-makeShare(_3592658,_3593906),hnf('Prelude.cond'(letrec4PAKCS(_3593906,_3592630),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),partcall(1,'Control.Search.AllValues.naf',[_3592612])),_3593906)),partcall(1,'Control.Search.AllValues.getAllFailures._\'23lambda3._\'23lambda5',[]))),_3593730,_3593736,_3593742).

'Control.Search.AllValues.getAllFailures._\'23lambda3._\'23lambda5'(_3600140,_3600142,_3600144,_3600146):-freeze(_3600144,'blocked_Control.Search.AllValues.getAllFailures._\'23lambda3._\'23lambda5'(_3600140,_3600142,_3600144,_3600146)).
'blocked_Control.Search.AllValues.getAllFailures._\'23lambda3._\'23lambda5'(_3600226,_3600920,_3600926,_3600932):-makeShare(_3600254,_3601042),hnf('Prelude.cond'(letrec4PAKCS(_3601042,_3600226),'Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.concat',_3601042))),_3600920,_3600926,_3600932).

'Control.Search.AllValues.naf'(_3604632,_3604634,_3604636,_3604638,_3604640):-freeze(_3604638,'blocked_Control.Search.AllValues.naf'(_3604632,_3604634,_3604636,_3604638,_3604640)).
'blocked_Control.Search.AllValues.naf'(_3604728,_3604746,_3605910,_3605916,_3605922):-makeShare(_3604746,_3606064),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.AllValues.getOneValue'('Prelude.apply'(_3604728,_3606064))),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',partcall(1,'Prelude.maybe',[partcall(1,'Prelude.const',[[]]),[_3606064]]))),_3605910,_3605916,_3605922).

:-costCenters(['']).




%%%%% Number of shared variables: 3

