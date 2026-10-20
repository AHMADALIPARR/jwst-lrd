%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('System.CPUTime').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.CPUTime.getCPUTime',getCPUTime,0,'System.CPUTime.getCPUTime',nofix,notype).
functiontype('System.CPUTime.getElapsedTime',getElapsedTime,0,'System.CPUTime.getElapsedTime',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.CPUTime.getCPUTime'(partcall(1,'System.CPUTime.getCPUTime$WORLD',[]),_3185650,_3185650).
'System.CPUTime.getCPUTime$WORLD'(_3185980,_3185982,_3185984,_3185986):-freeze(_3185984,'blocked_System.CPUTime.getCPUTime$WORLD'(_3185980,_3185982,_3185984,_3185986)).
'blocked_System.CPUTime.getCPUTime$WORLD'(_3186060,'$io'(_3186072),_3186076,_3185650):-'System.CPUTime.getCPUTime'(_3186072),_3186076=_3185650.

'System.CPUTime.getElapsedTime'(partcall(1,'System.CPUTime.getElapsedTime$WORLD',[]),_3186782,_3186782).
'System.CPUTime.getElapsedTime$WORLD'(_3187136,_3187138,_3187140,_3187142):-freeze(_3187140,'blocked_System.CPUTime.getElapsedTime$WORLD'(_3187136,_3187138,_3187140,_3187142)).
'blocked_System.CPUTime.getElapsedTime$WORLD'(_3187216,'$io'(_3187228),_3187232,_3186782):-'System.CPUTime.getElapsedTime'(_3187228),_3187232=_3186782.

:-costCenters(['']).




%%%%% Number of shared variables: 0

:-style_check(-singleton).
'System.CPUTime.getCPUTime'(_3187344):-getRunTime(_3187344).
'System.CPUTime.getElapsedTime'(_3187406):-getElapsedTime(_3187406).
