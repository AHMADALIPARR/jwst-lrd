%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Curry.Compiler.Distribution').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Curry.Compiler.Distribution.curryCompiler',curryCompiler,0,'Curry.Compiler.Distribution.curryCompiler',nofix,notype).
functiontype('Curry.Compiler.Distribution.curryCompilerMajorVersion',curryCompilerMajorVersion,0,'Curry.Compiler.Distribution.curryCompilerMajorVersion',nofix,notype).
functiontype('Curry.Compiler.Distribution.curryCompilerMinorVersion',curryCompilerMinorVersion,0,'Curry.Compiler.Distribution.curryCompilerMinorVersion',nofix,notype).
functiontype('Curry.Compiler.Distribution.curryCompilerRevisionVersion',curryCompilerRevisionVersion,0,'Curry.Compiler.Distribution.curryCompilerRevisionVersion',nofix,notype).
functiontype('Curry.Compiler.Distribution.curryRuntime',curryRuntime,0,'Curry.Compiler.Distribution.curryRuntime',nofix,notype).
functiontype('Curry.Compiler.Distribution.curryRuntimeMajorVersion',curryRuntimeMajorVersion,0,'Curry.Compiler.Distribution.curryRuntimeMajorVersion',nofix,notype).
functiontype('Curry.Compiler.Distribution.curryRuntimeMinorVersion',curryRuntimeMinorVersion,0,'Curry.Compiler.Distribution.curryRuntimeMinorVersion',nofix,notype).
functiontype('Curry.Compiler.Distribution.baseVersion',baseVersion,0,'Curry.Compiler.Distribution.baseVersion',nofix,notype).
functiontype('Curry.Compiler.Distribution.installDir',installDir,0,'Curry.Compiler.Distribution.installDir',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Curry.Compiler.Distribution.curryCompiler'(_3458768,_3458770,_3458772):-freeze(_3458770,'blocked_Curry.Compiler.Distribution.curryCompiler'(_3458768,_3458770,_3458772)).
'blocked_Curry.Compiler.Distribution.curryCompiler'(_3458838,_3458844,_3458850):-'Curry.Compiler.Distribution.curryCompiler'(_3458838),_3458844=_3458850.

'Curry.Compiler.Distribution.curryCompilerMajorVersion'(_3459714,_3459716,_3459718):-freeze(_3459716,'blocked_Curry.Compiler.Distribution.curryCompilerMajorVersion'(_3459714,_3459716,_3459718)).
'blocked_Curry.Compiler.Distribution.curryCompilerMajorVersion'(_3459784,_3459790,_3459796):-'Curry.Compiler.Distribution.curryCompilerMajorVersion'(_3459784),_3459790=_3459796.

'Curry.Compiler.Distribution.curryCompilerMinorVersion'(_3460660,_3460662,_3460664):-freeze(_3460662,'blocked_Curry.Compiler.Distribution.curryCompilerMinorVersion'(_3460660,_3460662,_3460664)).
'blocked_Curry.Compiler.Distribution.curryCompilerMinorVersion'(_3460730,_3460736,_3460742):-'Curry.Compiler.Distribution.curryCompilerMinorVersion'(_3460730),_3460736=_3460742.

'Curry.Compiler.Distribution.curryCompilerRevisionVersion'(_3461642,_3461644,_3461646):-freeze(_3461644,'blocked_Curry.Compiler.Distribution.curryCompilerRevisionVersion'(_3461642,_3461644,_3461646)).
'blocked_Curry.Compiler.Distribution.curryCompilerRevisionVersion'(_3461712,_3461718,_3461724):-'Curry.Compiler.Distribution.curryCompilerRevisionVersion'(_3461712),_3461718=_3461724.

'Curry.Compiler.Distribution.curryRuntime'(_3462432,_3462434,_3462436):-freeze(_3462434,'blocked_Curry.Compiler.Distribution.curryRuntime'(_3462432,_3462434,_3462436)).
'blocked_Curry.Compiler.Distribution.curryRuntime'(_3462502,_3462508,_3462514):-'Curry.Compiler.Distribution.curryRuntime'(_3462502),_3462508=_3462514.

'Curry.Compiler.Distribution.curryRuntimeMajorVersion'(_3463366,_3463368,_3463370):-freeze(_3463368,'blocked_Curry.Compiler.Distribution.curryRuntimeMajorVersion'(_3463366,_3463368,_3463370)).
'blocked_Curry.Compiler.Distribution.curryRuntimeMajorVersion'(_3463436,_3463442,_3463448):-'Curry.Compiler.Distribution.curryRuntimeMajorVersion'(_3463436),_3463442=_3463448.

'Curry.Compiler.Distribution.curryRuntimeMinorVersion'(_3464300,_3464302,_3464304):-freeze(_3464302,'blocked_Curry.Compiler.Distribution.curryRuntimeMinorVersion'(_3464300,_3464302,_3464304)).
'blocked_Curry.Compiler.Distribution.curryRuntimeMinorVersion'(_3464370,_3464376,_3464382):-'Curry.Compiler.Distribution.curryRuntimeMinorVersion'(_3464370),_3464376=_3464382.

'Curry.Compiler.Distribution.baseVersion'(_3465078,_3465080,_3465082):-freeze(_3465080,'blocked_Curry.Compiler.Distribution.baseVersion'(_3465078,_3465080,_3465082)).
'blocked_Curry.Compiler.Distribution.baseVersion'(_3465148,_3465154,_3465160):-'Curry.Compiler.Distribution.baseVersion'(_3465148),_3465154=_3465160.

'Curry.Compiler.Distribution.installDir'(_3465844,_3465846,_3465848):-freeze(_3465846,'blocked_Curry.Compiler.Distribution.installDir'(_3465844,_3465846,_3465848)).
'blocked_Curry.Compiler.Distribution.installDir'(_3465914,_3465920,_3465926):-'Curry.Compiler.Distribution.installDir'(_3465914),_3465920=_3465926.

:-costCenters(['']).




%%%%% Number of shared variables: 0

:-style_check(-singleton).
'Curry.Compiler.Distribution.curryCompiler'(_3466036):-atom2String(pakcs,_3466036).
'Curry.Compiler.Distribution.curryCompilerMajorVersion'(_3466100):-compilerMajorVersion(_3466100).
'Curry.Compiler.Distribution.curryCompilerMinorVersion'(_3466150):-compilerMinorVersion(_3466150).
'Curry.Compiler.Distribution.curryCompilerRevisionVersion'(_3466200):-compilerRevisionVersion(_3466200).
'Curry.Compiler.Distribution.curryRuntime'(_3466250):-prolog(_3466254),atom2String(_3466254,_3466250).
'Curry.Compiler.Distribution.curryRuntimeMajorVersion'(_3466312):-prologMajorVersion(_3466312).
'Curry.Compiler.Distribution.curryRuntimeMinorVersion'(_3466362):-prologMinorVersion(_3466362).
'Curry.Compiler.Distribution.baseVersion'(_3466412):-baseVersion(_3466416),atom2String(_3466416,_3466412).
'Curry.Compiler.Distribution.installDir'(_3466474):-installDir(_3466478)->atom2String(_3466478,_3466474);raise_exception('Curry.Compiler.Distribution.installDir: cannot determine installation directory!').
