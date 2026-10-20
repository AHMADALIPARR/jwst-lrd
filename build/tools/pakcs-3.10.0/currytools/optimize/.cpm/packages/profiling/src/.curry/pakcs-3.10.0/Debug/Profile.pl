%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Data.List').
:-importModule('Prelude').

:-curryModule('Debug.Profile').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23','_inst#Prelude.Data#Debug.Profile.ProcessInfo#',1,'Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23','_impl#===#Prelude.Data#Debug.Profile.ProcessInfo#',2,'Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23','_impl#aValue#Prelude.Data#Debug.Profile.ProcessInfo#',0,'Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23','_inst#Prelude.Eq#Debug.Profile.ProcessInfo#',1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23','_impl#==#Prelude.Eq#Debug.Profile.ProcessInfo#',2,'Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23\'2F\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23','_impl#/=#Prelude.Eq#Debug.Profile.ProcessInfo#',0,'Debug.Profile._impl\'23\'2F\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23','_inst#Prelude.Show#Debug.Profile.ProcessInfo#',1,'Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23show\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23','_impl#show#Prelude.Show#Debug.Profile.ProcessInfo#',0,'Debug.Profile._impl\'23show\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23','_impl#showsPrec#Prelude.Show#Debug.Profile.ProcessInfo#',2,'Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile._impl\'23showList\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23','_impl#showList#Prelude.Show#Debug.Profile.ProcessInfo#',0,'Debug.Profile._impl\'23showList\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',nofix,notype).
functiontype('Debug.Profile.getProcessInfos',getProcessInfos,0,'Debug.Profile.getProcessInfos',nofix,notype).
functiontype('Debug.Profile.garbageCollectorOff',garbageCollectorOff,0,'Debug.Profile.garbageCollectorOff',nofix,notype).
functiontype('Debug.Profile.garbageCollectorOn',garbageCollectorOn,0,'Debug.Profile.garbageCollectorOn',nofix,notype).
functiontype('Debug.Profile.garbageCollect',garbageCollect,0,'Debug.Profile.garbageCollect',nofix,notype).
functiontype('Debug.Profile.showMemInfo',showMemInfo,1,'Debug.Profile.showMemInfo',nofix,notype).
functiontype('Debug.Profile.showMemInfo.showBytes.2','Debug.Profile.showMemInfo.showBytes.2',3,'Debug.Profile.showMemInfo.showBytes.2',nofix,notype).
functiontype('Debug.Profile.showMemInfo.formatItem.2','Debug.Profile.showMemInfo.formatItem.2',3,'Debug.Profile.showMemInfo.formatItem.2',nofix,notype).
functiontype('Debug.Profile.showMemInfo.formatItem.2._\'23lambda1','Debug.Profile.showMemInfo.formatItem.2._#lambda1',2,'Debug.Profile.showMemInfo.formatItem.2._\'23lambda1',nofix,notype).
functiontype('Debug.Profile.printMemInfo',printMemInfo,0,'Debug.Profile.printMemInfo',nofix,notype).
functiontype('Debug.Profile.profileTime',profileTime,1,'Debug.Profile.profileTime',nofix,notype).
functiontype('Debug.Profile.profileTime._\'23lambda3','Debug.Profile.profileTime._#lambda3',1,'Debug.Profile.profileTime._\'23lambda3',nofix,notype).
functiontype('Debug.Profile.getTimings',getTimings,1,'Debug.Profile.getTimings',nofix,notype).
functiontype('Debug.Profile.getTimings._\'23lambda8','Debug.Profile.getTimings._#lambda8',2,'Debug.Profile.getTimings._\'23lambda8',nofix,notype).
functiontype('Debug.Profile.getTimings._\'23lambda8._\'23lambda10','Debug.Profile.getTimings._#lambda8._#lambda10',2,'Debug.Profile.getTimings._\'23lambda8._\'23lambda10',nofix,notype).
functiontype('Debug.Profile.getTimings._\'23lambda8._\'23lambda10._\'23lambda12','Debug.Profile.getTimings._#lambda8._#lambda10._#lambda12',3,'Debug.Profile.getTimings._\'23lambda8._\'23lambda10._\'23lambda12',nofix,notype).
functiontype('Debug.Profile.getTimingsNF',getTimingsNF,1,'Debug.Profile.getTimingsNF',nofix,notype).
functiontype('Debug.Profile.getTimingsNF._\'23lambda15','Debug.Profile.getTimingsNF._#lambda15',1,'Debug.Profile.getTimingsNF._\'23lambda15',nofix,notype).
functiontype('Debug.Profile.getElapsedTimeNF',getElapsedTimeNF,1,'Debug.Profile.getElapsedTimeNF',nofix,notype).
functiontype('Debug.Profile.getElapsedTimeNF._\'23lambda20','Debug.Profile.getElapsedTimeNF._#lambda20',2,'Debug.Profile.getElapsedTimeNF._\'23lambda20',nofix,notype).
functiontype('Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22','Debug.Profile.getElapsedTimeNF._#lambda20._#lambda22',2,'Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22',nofix,notype).
functiontype('Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22._\'23lambda24','Debug.Profile.getElapsedTimeNF._#lambda20._#lambda22._#lambda24',3,'Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22._\'23lambda24',nofix,notype).
functiontype('Debug.Profile.profileTimeNF',profileTimeNF,1,'Debug.Profile.profileTimeNF',nofix,notype).
functiontype('Debug.Profile.profileSpace',profileSpace,1,'Debug.Profile.profileSpace',nofix,notype).
functiontype('Debug.Profile.profileSpace._\'23lambda29','Debug.Profile.profileSpace._#lambda29',2,'Debug.Profile.profileSpace._\'23lambda29',nofix,notype).
functiontype('Debug.Profile.profileSpace._\'23lambda29._\'23lambda31','Debug.Profile.profileSpace._#lambda29._#lambda31',2,'Debug.Profile.profileSpace._\'23lambda29._\'23lambda31',nofix,notype).
functiontype('Debug.Profile.profileSpace._\'23lambda29._\'23lambda31._\'23lambda33','Debug.Profile.profileSpace._#lambda29._#lambda31._#lambda33',3,'Debug.Profile.profileSpace._\'23lambda29._\'23lambda31._\'23lambda33',nofix,notype).
functiontype('Debug.Profile.profileSpaceNF',profileSpaceNF,1,'Debug.Profile.profileSpaceNF',nofix,notype).
functiontype('Debug.Profile.showInfoDiff','Debug.Profile.showInfoDiff',3,'Debug.Profile.showInfoDiff',nofix,notype).
functiontype('Debug.Profile.infoDiff','Debug.Profile.infoDiff',3,'Debug.Profile.infoDiff',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Debug.Profile.RunTime','RunTime',0,'Profile.RunTime',0,notype,['Debug.Profile.ElapsedTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Code'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Heap'/0,'Debug.Profile.Choices'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.ElapsedTime','ElapsedTime',0,'Profile.ElapsedTime',1,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Code'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Heap'/0,'Debug.Profile.Choices'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.Memory','Memory',0,'Profile.Memory',2,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.ElapsedTime'/0,'Debug.Profile.Code'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Heap'/0,'Debug.Profile.Choices'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.Code','Code',0,'Profile.Code',3,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.ElapsedTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Heap'/0,'Debug.Profile.Choices'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.Stack','Stack',0,'Profile.Stack',4,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.ElapsedTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Code'/0,'Debug.Profile.Heap'/0,'Debug.Profile.Choices'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.Heap','Heap',0,'Profile.Heap',5,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.ElapsedTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Code'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Choices'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.Choices','Choices',0,'Profile.Choices',6,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.ElapsedTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Code'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Heap'/0,'Debug.Profile.GarbageCollections'/0]).
constructortype('Debug.Profile.GarbageCollections','GarbageCollections',0,'Profile.GarbageCollections',7,notype,['Debug.Profile.RunTime'/0,'Debug.Profile.ElapsedTime'/0,'Debug.Profile.Memory'/0,'Debug.Profile.Code'/0,'Debug.Profile.Stack'/0,'Debug.Profile.Heap'/0,'Debug.Profile.Choices'/0]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_23905500,_23905502,_23905504,_23905506):-freeze(_23905504,'blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_23905500,_23905502,_23905504,_23905506)).
'blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_23905586,_23906356,_23906362,_23906368):-hnf(_23905586,_23909074,_23906362,_23909086),'blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'(_23909074,_23906356,_23909086,_23906368).

'blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'(_23909718,_23909720,_23909722,_23909724):-freeze(_23909722,'blocked_blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'(_23909718,_23909720,_23909722,_23909724)).
'blocked_blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23',[]),'Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'),_23910070,_23910070):-!.
'blocked_blocked_Debug.Profile._inst\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('FAIL'(_23911946),'FAIL'(_23911946),_23911960,_23911960):-nonvar(_23911946).

'Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_23914762,_23914764,_23914766,_23914768,_23914770):-freeze(_23914768,'blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_23914762,_23914764,_23914766,_23914768,_23914770)).
'blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_23914858,_23914876,_23922682,_23922688,_23922694):-hnf(_23914858,_23925840,_23922688,_23925858),'blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'(_23925840,_23914876,_23922682,_23925858,_23922694).

'blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'(_23926570,_23926572,_23926574,_23926576,_23926578):-freeze(_23926576,'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'(_23926570,_23926572,_23926574,_23926576,_23926578)).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.RunTime',_23914876,_23927666,_23927672,_23927678):-hnf(_23914876,_23931844,_23927672,_23931856),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'(_23931844,_23927666,_23931856,_23927678).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'(_23932752,_23932754,_23932756,_23932758):-freeze(_23932756,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'(_23932752,_23932754,_23932756,_23932758)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.RunTime','Prelude.True',_23933244,_23933244).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.ElapsedTime','Prelude.False',_23934652,_23934652).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Memory','Prelude.False',_23936006,_23936006).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Code','Prelude.False',_23937336,_23937336).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Stack','Prelude.False',_23938678,_23938678).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Heap','Prelude.False',_23940008,_23940008).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Choices','Prelude.False',_23941374,_23941374).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.GarbageCollections','Prelude.False',_23942872,_23942872):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('FAIL'(_23943838),'FAIL'(_23943838),_23943852,_23943852):-nonvar(_23943838).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.ElapsedTime',_23914876,_23944962,_23944968,_23944974):-hnf(_23914876,_23949260,_23944968,_23949272),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'(_23949260,_23944962,_23949272,_23944974).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'(_23950192,_23950194,_23950196,_23950198):-freeze(_23950196,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'(_23950192,_23950194,_23950196,_23950198)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.RunTime','Prelude.False',_23950684,_23950684).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.ElapsedTime','Prelude.True',_23952122,_23952122).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Memory','Prelude.False',_23953494,_23953494).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Code','Prelude.False',_23954848,_23954848).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Stack','Prelude.False',_23956214,_23956214).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Heap','Prelude.False',_23957568,_23957568).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Choices','Prelude.False',_23958958,_23958958).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.GarbageCollections','Prelude.False',_23960480,_23960480):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('FAIL'(_23961470),'FAIL'(_23961470),_23961484,_23961484):-nonvar(_23961470).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Memory',_23914876,_23962534,_23962540,_23962546):-hnf(_23914876,_23966682,_23962540,_23966694),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'(_23966682,_23962534,_23966694,_23962546).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'(_23967584,_23967586,_23967588,_23967590):-freeze(_23967588,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'(_23967584,_23967586,_23967588,_23967590)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.RunTime','Prelude.False',_23968076,_23968076).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.ElapsedTime','Prelude.False',_23969484,_23969484).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Memory','Prelude.True',_23970832,_23970832).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Code','Prelude.False',_23972150,_23972150).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Stack','Prelude.False',_23973486,_23973486).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Heap','Prelude.False',_23974810,_23974810).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Choices','Prelude.False',_23976170,_23976170).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.GarbageCollections','Prelude.False',_23977662,_23977662):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('FAIL'(_23978622),'FAIL'(_23978622),_23978636,_23978636):-nonvar(_23978622).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Code',_23914876,_23979662,_23979668,_23979674):-hnf(_23914876,_23983750,_23979668,_23983762),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'(_23983750,_23979662,_23983762,_23979674).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'(_23984640,_23984642,_23984644,_23984646):-freeze(_23984644,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'(_23984640,_23984642,_23984644,_23984646)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.RunTime','Prelude.False',_23985132,_23985132).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.ElapsedTime','Prelude.False',_23986528,_23986528).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Memory','Prelude.False',_23987864,_23987864).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Code','Prelude.True',_23989176,_23989176).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Stack','Prelude.False',_23990494,_23990494).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Heap','Prelude.False',_23991806,_23991806).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Choices','Prelude.False',_23993154,_23993154).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.GarbageCollections','Prelude.False',_23994634,_23994634):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('FAIL'(_23995582),'FAIL'(_23995582),_23995596,_23995596):-nonvar(_23995582).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Stack',_23914876,_23996634,_23996640,_23996646):-hnf(_23914876,_24000752,_23996640,_24000764),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'(_24000752,_23996634,_24000764,_23996646).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'(_24001648,_24001650,_24001652,_24001654):-freeze(_24001652,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'(_24001648,_24001650,_24001652,_24001654)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.RunTime','Prelude.False',_24002140,_24002140).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.ElapsedTime','Prelude.False',_24003542,_24003542).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Memory','Prelude.False',_24004884,_24004884).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Code','Prelude.False',_24006202,_24006202).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Stack','Prelude.True',_24007532,_24007532).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Heap','Prelude.False',_24008844,_24008844).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Choices','Prelude.False',_24010198,_24010198).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.GarbageCollections','Prelude.False',_24011684,_24011684):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('FAIL'(_24012638),'FAIL'(_24012638),_24012652,_24012652):-nonvar(_24012638).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Heap',_23914876,_24013678,_24013684,_24013690):-hnf(_23914876,_24017766,_24013684,_24017778),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'(_24017766,_24013678,_24017778,_24013690).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'(_24018656,_24018658,_24018660,_24018662):-freeze(_24018660,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'(_24018656,_24018658,_24018660,_24018662)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.RunTime','Prelude.False',_24019148,_24019148).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.ElapsedTime','Prelude.False',_24020544,_24020544).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Memory','Prelude.False',_24021880,_24021880).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Code','Prelude.False',_24023192,_24023192).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Stack','Prelude.False',_24024516,_24024516).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Heap','Prelude.True',_24025828,_24025828).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Choices','Prelude.False',_24027170,_24027170).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.GarbageCollections','Prelude.False',_24028650,_24028650):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('FAIL'(_24029598),'FAIL'(_24029598),_24029612,_24029612):-nonvar(_24029598).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Choices',_23914876,_24030674,_24030680,_24030686):-hnf(_23914876,_24034852,_24030680,_24034864),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'(_24034852,_24030674,_24034864,_24030686).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'(_24035760,_24035762,_24035764,_24035766):-freeze(_24035764,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'(_24035760,_24035762,_24035764,_24035766)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.RunTime','Prelude.False',_24036252,_24036252).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.ElapsedTime','Prelude.False',_24037666,_24037666).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Memory','Prelude.False',_24039020,_24039020).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Code','Prelude.False',_24040350,_24040350).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Stack','Prelude.False',_24041692,_24041692).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Heap','Prelude.False',_24043022,_24043022).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Choices','Prelude.True',_24044388,_24044388).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.GarbageCollections','Prelude.False',_24045880,_24045880):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('FAIL'(_24046846),'FAIL'(_24046846),_24046860,_24046860):-nonvar(_24046846).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.GarbageCollections',_23914876,_24048054,_24048060,_24048066):-!,hnf(_23914876,_24052562,_24048060,_24052574),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'(_24052562,_24048054,_24052574,_24048066).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'(_24053554,_24053556,_24053558,_24053560):-freeze(_24053558,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'(_24053554,_24053556,_24053558,_24053560)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.RunTime','Prelude.False',_24054046,_24054046).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.ElapsedTime','Prelude.False',_24055526,_24055526).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Memory','Prelude.False',_24056946,_24056946).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Code','Prelude.False',_24058342,_24058342).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Stack','Prelude.False',_24059750,_24059750).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Heap','Prelude.False',_24061146,_24061146).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Choices','Prelude.False',_24062578,_24062578).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.GarbageCollections','Prelude.True',_24064142,_24064142):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('FAIL'(_24065168),'FAIL'(_24065168),_24065182,_24065182):-nonvar(_24065168).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23_1'('FAIL'(_24065238),_23914876,'FAIL'(_24065238),_24065252,_24065252):-nonvar(_24065238).

'Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_24068092,_24068094,_24068096):-freeze(_24068094,'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'(_24068092,_24068094,_24068096)).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.RunTime',_24070818,_24070818).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.ElapsedTime',_24071542,_24071542).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.Memory',_24072290,_24072290).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.Code',_24073008,_24073008).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.Stack',_24073714,_24073714).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.Heap',_24074426,_24074426).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.Choices',_24075132,_24075132).
'blocked_Debug.Profile._impl\'23aValue\'23Prelude.Data\'23Debug.Profile.ProcessInfo\'23'('Debug.Profile.GarbageCollections',_24075856,_24075856).

'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24079052,_24079054,_24079056,_24079058):-freeze(_24079056,'blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24079052,_24079054,_24079056,_24079058)).
'blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24079138,_24079896,_24079902,_24079908):-hnf(_24079138,_24082542,_24079902,_24082554),'blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'(_24082542,_24079896,_24082554,_24079908).

'blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'(_24083174,_24083176,_24083178,_24083180):-freeze(_24083178,'blocked_blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'(_24083174,_24083176,_24083178,_24083180)).
'blocked_blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Prelude.()','Prelude._Dict\'23Eq'(partcall(2,'Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[]),'Debug.Profile._impl\'23\'2F\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'),_24083526,_24083526):-!.
'blocked_blocked_Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('FAIL'(_24085336),'FAIL'(_24085336),_24085350,_24085350):-nonvar(_24085336).

'Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24088010,_24088012,_24088014,_24088016,_24088018):-freeze(_24088016,'blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24088010,_24088012,_24088014,_24088016,_24088018)).
'blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24088106,_24088124,_24095900,_24095906,_24095912):-hnf(_24088106,_24098878,_24095906,_24098896),'blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'(_24098878,_24088124,_24095900,_24098896,_24095912).

'blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'(_24099578,_24099580,_24099582,_24099584,_24099586):-freeze(_24099584,'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'(_24099578,_24099580,_24099582,_24099584,_24099586)).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.RunTime',_24088124,_24100644,_24100650,_24100656):-hnf(_24088124,_24104642,_24100650,_24104654),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'(_24104642,_24100644,_24104654,_24100656).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'(_24105520,_24105522,_24105524,_24105526):-freeze(_24105524,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'(_24105520,_24105522,_24105524,_24105526)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.RunTime','Prelude.True',_24106012,_24106012).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.ElapsedTime','Prelude.False',_24107390,_24107390).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Memory','Prelude.False',_24108714,_24108714).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Code','Prelude.False',_24110014,_24110014).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Stack','Prelude.False',_24111326,_24111326).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Heap','Prelude.False',_24112626,_24112626).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.Choices','Prelude.False',_24113962,_24113962).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('Debug.Profile.GarbageCollections','Prelude.False',_24115430,_24115430):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.RunTime_1'('FAIL'(_24116366),'FAIL'(_24116366),_24116380,_24116380):-nonvar(_24116366).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.ElapsedTime',_24088124,_24117460,_24117466,_24117472):-hnf(_24088124,_24121578,_24117466,_24121590),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'(_24121578,_24117460,_24121590,_24117472).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'(_24122480,_24122482,_24122484,_24122486):-freeze(_24122484,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'(_24122480,_24122482,_24122484,_24122486)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.RunTime','Prelude.False',_24122972,_24122972).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.ElapsedTime','Prelude.True',_24124380,_24124380).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Memory','Prelude.False',_24125722,_24125722).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Code','Prelude.False',_24127046,_24127046).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Stack','Prelude.False',_24128382,_24128382).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Heap','Prelude.False',_24129706,_24129706).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.Choices','Prelude.False',_24131066,_24131066).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('Debug.Profile.GarbageCollections','Prelude.False',_24132558,_24132558):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.ElapsedTime_1'('FAIL'(_24133518),'FAIL'(_24133518),_24133532,_24133532):-nonvar(_24133518).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Memory',_24088124,_24134552,_24134558,_24134564):-hnf(_24088124,_24138520,_24134558,_24138532),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'(_24138520,_24134552,_24138532,_24134564).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'(_24139392,_24139394,_24139396,_24139398):-freeze(_24139396,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'(_24139392,_24139394,_24139396,_24139398)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.RunTime','Prelude.False',_24139884,_24139884).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.ElapsedTime','Prelude.False',_24141262,_24141262).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Memory','Prelude.True',_24142580,_24142580).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Code','Prelude.False',_24143868,_24143868).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Stack','Prelude.False',_24145174,_24145174).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Heap','Prelude.False',_24146468,_24146468).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.Choices','Prelude.False',_24147798,_24147798).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('Debug.Profile.GarbageCollections','Prelude.False',_24149260,_24149260):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Memory_1'('FAIL'(_24150190),'FAIL'(_24150190),_24150204,_24150204):-nonvar(_24150190).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Code',_24088124,_24151200,_24151206,_24151212):-hnf(_24088124,_24155108,_24151206,_24155120),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'(_24155108,_24151200,_24155120,_24151212).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'(_24155968,_24155970,_24155972,_24155974):-freeze(_24155972,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'(_24155968,_24155970,_24155972,_24155974)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.RunTime','Prelude.False',_24156460,_24156460).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.ElapsedTime','Prelude.False',_24157826,_24157826).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Memory','Prelude.False',_24159132,_24159132).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Code','Prelude.True',_24160414,_24160414).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Stack','Prelude.False',_24161702,_24161702).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Heap','Prelude.False',_24162984,_24162984).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.Choices','Prelude.False',_24164302,_24164302).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('Debug.Profile.GarbageCollections','Prelude.False',_24165752,_24165752):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Code_1'('FAIL'(_24166670),'FAIL'(_24166670),_24166684,_24166684):-nonvar(_24166670).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Stack',_24088124,_24167692,_24167698,_24167704):-hnf(_24088124,_24171630,_24167698,_24171642),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'(_24171630,_24167692,_24171642,_24167704).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'(_24172496,_24172498,_24172500,_24172502):-freeze(_24172500,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'(_24172496,_24172498,_24172500,_24172502)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.RunTime','Prelude.False',_24172988,_24172988).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.ElapsedTime','Prelude.False',_24174360,_24174360).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Memory','Prelude.False',_24175672,_24175672).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Code','Prelude.False',_24176960,_24176960).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Stack','Prelude.True',_24178260,_24178260).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Heap','Prelude.False',_24179542,_24179542).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.Choices','Prelude.False',_24180866,_24180866).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('Debug.Profile.GarbageCollections','Prelude.False',_24182322,_24182322):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Stack_1'('FAIL'(_24183246),'FAIL'(_24183246),_24183260,_24183260):-nonvar(_24183246).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Heap',_24088124,_24184256,_24184262,_24184268):-hnf(_24088124,_24188164,_24184262,_24188176),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'(_24188164,_24184256,_24188176,_24184268).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'(_24189024,_24189026,_24189028,_24189030):-freeze(_24189028,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'(_24189024,_24189026,_24189028,_24189030)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.RunTime','Prelude.False',_24189516,_24189516).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.ElapsedTime','Prelude.False',_24190882,_24190882).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Memory','Prelude.False',_24192188,_24192188).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Code','Prelude.False',_24193470,_24193470).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Stack','Prelude.False',_24194764,_24194764).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Heap','Prelude.True',_24196046,_24196046).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.Choices','Prelude.False',_24197358,_24197358).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('Debug.Profile.GarbageCollections','Prelude.False',_24198808,_24198808):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Heap_1'('FAIL'(_24199726),'FAIL'(_24199726),_24199740,_24199740):-nonvar(_24199726).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.Choices',_24088124,_24200772,_24200778,_24200784):-hnf(_24088124,_24204770,_24200778,_24204782),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'(_24204770,_24200772,_24204782,_24200784).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'(_24205648,_24205650,_24205652,_24205654):-freeze(_24205652,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'(_24205648,_24205650,_24205652,_24205654)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.RunTime','Prelude.False',_24206140,_24206140).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.ElapsedTime','Prelude.False',_24207524,_24207524).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Memory','Prelude.False',_24208848,_24208848).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Code','Prelude.False',_24210148,_24210148).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Stack','Prelude.False',_24211460,_24211460).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Heap','Prelude.False',_24212760,_24212760).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.Choices','Prelude.True',_24214096,_24214096).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('Debug.Profile.GarbageCollections','Prelude.False',_24215558,_24215558):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.Choices_1'('FAIL'(_24216494),'FAIL'(_24216494),_24216508,_24216508):-nonvar(_24216494).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('Debug.Profile.GarbageCollections',_24088124,_24217672,_24217678,_24217684):-!,hnf(_24088124,_24222000,_24217678,_24222012),'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'(_24222000,_24217672,_24222012,_24217684).

'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'(_24222962,_24222964,_24222966,_24222968):-freeze(_24222966,'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'(_24222962,_24222964,_24222966,_24222968)).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.RunTime','Prelude.False',_24223454,_24223454).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.ElapsedTime','Prelude.False',_24224904,_24224904).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Memory','Prelude.False',_24226294,_24226294).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Code','Prelude.False',_24227660,_24227660).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Stack','Prelude.False',_24229038,_24229038).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Heap','Prelude.False',_24230404,_24230404).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.Choices','Prelude.False',_24231806,_24231806).
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('Debug.Profile.GarbageCollections','Prelude.True',_24233340,_24233340):-!.
'blocked_blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1_Debug.Profile.GarbageCollections_1'('FAIL'(_24234336),'FAIL'(_24234336),_24234350,_24234350):-nonvar(_24234336).
'blocked_blocked_Debug.Profile._impl\'23\'3D\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23_1'('FAIL'(_24234406),_24088124,'FAIL'(_24234406),_24234420,_24234420):-nonvar(_24234406).

'Debug.Profile._impl\'23\'2F\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24237088,_24237090,_24237092):-freeze(_24237090,'blocked_Debug.Profile._impl\'23\'2F\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24237088,_24237090,_24237092)).
'blocked_Debug.Profile._impl\'23\'2F\'3D\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23'(_24237260,_24237266,_24237272):-hnf(partcall(2,'Prelude._def\'23\'2F\'3D\'23Prelude.Eq',[partcall(1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[])]),_24237260,_24237266,_24237272).

'Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24241058,_24241060,_24241062,_24241064):-freeze(_24241062,'blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24241058,_24241060,_24241062,_24241064)).
'blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24241144,_24241998,_24242004,_24242010):-hnf(_24241144,_24244716,_24242004,_24244728),'blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_1'(_24244716,_24241998,_24244728,_24242010).

'blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_1'(_24245360,_24245362,_24245364,_24245366):-freeze(_24245364,'blocked_blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_1'(_24245360,_24245362,_24245364,_24245366)).
'blocked_blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_1'('Prelude.()','Prelude._Dict\'23Show'('Debug.Profile._impl\'23show\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',partcall(2,'Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',[]),'Debug.Profile._impl\'23showList\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'),_24245712,_24245712):-!.
'blocked_blocked_Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_1'('FAIL'(_24248140),'FAIL'(_24248140),_24248154,_24248154):-nonvar(_24248140).

'Debug.Profile._impl\'23show\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24250910,_24250912,_24250914):-freeze(_24250912,'blocked_Debug.Profile._impl\'23show\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24250910,_24250912,_24250914)).
'blocked_Debug.Profile._impl\'23show\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24251082,_24251088,_24251094):-hnf(partcall(1,'Prelude._def\'23show\'23Prelude.Show',[partcall(1,'Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',[])]),_24251082,_24251088,_24251094).

'Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24255300,_24255302,_24255304,_24255306,_24255308):-freeze(_24255306,'blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24255300,_24255302,_24255304,_24255306,_24255308)).
'blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24255396,_24255414,_24267016,_24267022,_24267028):-hnf(_24255414,_24270174,_24267022,_24270192),'blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'(_24270174,_24255396,_24267016,_24270192,_24267028).

'blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'(_24270904,_24270906,_24270908,_24270910,_24270912):-freeze(_24270910,'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'(_24270904,_24270906,_24270908,_24270910,_24270912)).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.RunTime',_24255396,_24271400,_24271406,_24271412):-hnf(partcall(1,'Prelude.showString',[['^R','^u','^n','^T','^i','^m','^e']]),_24271400,_24271406,_24271412).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.ElapsedTime',_24255396,_24274270,_24274276,_24274282):-hnf(partcall(1,'Prelude.showString',[['^E','^l','^a','^p','^s','^e','^d','^T','^i','^m','^e']]),_24274270,_24274276,_24274282).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.Memory',_24255396,_24277888,_24277894,_24277900):-hnf(partcall(1,'Prelude.showString',[['^M','^e','^m','^o','^r','^y']]),_24277888,_24277894,_24277900).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.Code',_24255396,_24280472,_24280478,_24280484):-hnf(partcall(1,'Prelude.showString',[['^C','^o','^d','^e']]),_24280472,_24280478,_24280484).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.Stack',_24255396,_24282664,_24282670,_24282676):-hnf(partcall(1,'Prelude.showString',[['^S','^t','^a','^c','^k']]),_24282664,_24282670,_24282676).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.Heap',_24255396,_24285046,_24285052,_24285058):-hnf(partcall(1,'Prelude.showString',[['^H','^e','^a','^p']]),_24285046,_24285052,_24285058).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.Choices',_24255396,_24287262,_24287268,_24287274):-hnf(partcall(1,'Prelude.showString',[['^C','^h','^o','^i','^c','^e','^s']]),_24287262,_24287268,_24287274).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('Debug.Profile.GarbageCollections',_24255396,_24290216,_24290222,_24290228):-!,hnf(partcall(1,'Prelude.showString',[['^G','^a','^r','^b','^a','^g','^e','^C','^o','^l','^l','^e','^c','^t','^i','^o','^n','^s']]),_24290216,_24290222,_24290228).
'blocked_blocked_Debug.Profile._impl\'23showsPrec\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23_2'('FAIL'(_24294872),_24255396,'FAIL'(_24294872),_24294886,_24294886):-nonvar(_24294872).

'Debug.Profile._impl\'23showList\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24297802,_24297804,_24297806):-freeze(_24297804,'blocked_Debug.Profile._impl\'23showList\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24297802,_24297804,_24297806)).
'blocked_Debug.Profile._impl\'23showList\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23'(_24297974,_24297980,_24297986):-hnf('Prelude._def\'23showList\'23Prelude.Show'(partcall(1,'Debug.Profile._inst\'23Prelude.Show\'23Debug.Profile.ProcessInfo\'23',[])),_24297974,_24297980,_24297986).

'Debug.Profile.getProcessInfos'(partcall(1,'Debug.Profile.getProcessInfos$WORLD',[]),_24299962,_24299962).
'Debug.Profile.getProcessInfos$WORLD'(_24300316,_24300318,_24300320,_24300322):-freeze(_24300320,'blocked_Debug.Profile.getProcessInfos$WORLD'(_24300316,_24300318,_24300320,_24300322)).
'blocked_Debug.Profile.getProcessInfos$WORLD'(_24300396,'$io'(_24300408),_24300412,_24299962):-'Debug.Profile.getProcessInfos'(_24300408),_24300412=_24299962.

'Debug.Profile.garbageCollectorOff'(partcall(1,'Debug.Profile.garbageCollectorOff$WORLD',[]),_24301190,_24301190).
'Debug.Profile.garbageCollectorOff$WORLD'(_24301568,_24301570,_24301572,_24301574):-freeze(_24301572,'blocked_Debug.Profile.garbageCollectorOff$WORLD'(_24301568,_24301570,_24301572,_24301574)).
'blocked_Debug.Profile.garbageCollectorOff$WORLD'(_24301648,'$io'(_24301660),_24301664,_24301190):-'Debug.Profile.garbageCollectorOff'(_24301660),_24301664=_24301190.

'Debug.Profile.garbageCollectorOn'(partcall(1,'Debug.Profile.garbageCollectorOn$WORLD',[]),_24302424,_24302424).
'Debug.Profile.garbageCollectorOn$WORLD'(_24302796,_24302798,_24302800,_24302802):-freeze(_24302800,'blocked_Debug.Profile.garbageCollectorOn$WORLD'(_24302796,_24302798,_24302800,_24302802)).
'blocked_Debug.Profile.garbageCollectorOn$WORLD'(_24302876,'$io'(_24302888),_24302892,_24302424):-'Debug.Profile.garbageCollectorOn'(_24302888),_24302892=_24302424.

'Debug.Profile.garbageCollect'(partcall(1,'Debug.Profile.garbageCollect$WORLD',[]),_24303580,_24303580).
'Debug.Profile.garbageCollect$WORLD'(_24303928,_24303930,_24303932,_24303934):-freeze(_24303932,'blocked_Debug.Profile.garbageCollect$WORLD'(_24303928,_24303930,_24303932,_24303934)).
'blocked_Debug.Profile.garbageCollect$WORLD'(_24304008,'$io'(_24304020),_24304024,_24303580):-'Debug.Profile.garbageCollect'(_24304020),_24304024=_24303580.

'Debug.Profile.showMemInfo'(_24305190,_24305192,_24305194,_24305196):-freeze(_24305194,'blocked_Debug.Profile.showMemInfo'(_24305190,_24305192,_24305194,_24305196)).
'blocked_Debug.Profile.showMemInfo'(_24305276,_24313272,_24313278,_24313284):-makeShare(_24305276,_24313594),hnf('Prelude.$'(partcall(1,'Data.List.intercalate',[['^,','^ ']]),'Prelude.++'('Debug.Profile.showMemInfo.formatItem.2'(_24313594,'Debug.Profile.Memory',['^M','^e','^m','^o','^r','^y',^:,'^ ']),'Prelude.++'('Debug.Profile.showMemInfo.formatItem.2'(_24313594,'Debug.Profile.Code',['^C','^o','^d','^e',^:,'^ ']),'Prelude.++'('Debug.Profile.showMemInfo.formatItem.2'(_24313594,'Debug.Profile.Stack',['^S','^t','^a','^c','^k',^:,'^ ']),'Prelude.++'('Debug.Profile.showMemInfo.formatItem.2'(_24313594,'Debug.Profile.Choices',['^C','^h','^o','^i','^c','^e','^s',^:,'^ ']),'Debug.Profile.showMemInfo.formatItem.2'(_24313594,'Debug.Profile.Heap',['^H','^e','^a','^p',^:,'^ '])))))),_24313272,_24313278,_24313284).

'Debug.Profile.showMemInfo.showBytes.2'(_24328286,_24328288,_24328290,_24328292,_24328294,_24328296):-freeze(_24328294,'blocked_Debug.Profile.showMemInfo.showBytes.2'(_24328286,_24328288,_24328290,_24328292,_24328294,_24328296)).
'blocked_Debug.Profile.showMemInfo.showBytes.2'(_24328392,_24328410,_24328428,_24336124,_24336130,_24336136):-makeShare(_24328392,_24331808),makeShare(_24328428,_24331828),hnf('Prelude.apply'('Prelude.apply'('Prelude.<'('Prelude._super\'23Prelude.Real\'23Prelude.Ord\'230\'23'('Prelude._super\'23Prelude.Integral\'23Prelude.Real\'230\'23'(_24331808))),_24331828),'Prelude.apply'('Prelude.fromInt'('Prelude._super\'23Prelude.Real\'23Prelude.Num\'230\'23'('Prelude._super\'23Prelude.Integral\'23Prelude.Real\'230\'23'(_24331808))),10000)),_24337958,_24336130,_24337918),'blocked_Debug.Profile.showMemInfo.showBytes.2_ComplexCase'(_24337958,_24331808,_24328410,_24331828,_24336124,_24337918,_24336136).

'blocked_Debug.Profile.showMemInfo.showBytes.2_ComplexCase'(_24338496,_24338498,_24338500,_24338502,_24338504,_24338506,_24338508):-freeze(_24338506,freeze(_24338496,'blocked_blocked_Debug.Profile.showMemInfo.showBytes.2_ComplexCase'(_24338496,_24338498,_24338500,_24338502,_24338504,_24338506,_24338508))).
'blocked_blocked_Debug.Profile.showMemInfo.showBytes.2_ComplexCase'('Prelude.True',_24331808,_24328410,_24331828,_24338910,_24338916,_24338922):-hnf('Prelude.apply'('Prelude.show'(_24328410),_24331828),_24338910,_24338916,_24338922).
'blocked_blocked_Debug.Profile.showMemInfo.showBytes.2_ComplexCase'('Prelude.False',_24331808,_24328410,_24331828,_24340428,_24340434,_24340440):-!,makeShare(_24331808,_24340648),hnf('Prelude.++'('Prelude.apply'('Prelude.show'(_24328410),'Prelude.apply'('Prelude.apply'('Prelude.div'(_24340648),_24331828),'Prelude.apply'('Prelude.fromInt'('Prelude._super\'23Prelude.Real\'23Prelude.Num\'230\'23'('Prelude._super\'23Prelude.Integral\'23Prelude.Real\'230\'23'(_24340648))),1000))),['^ ','^k','^b']),_24340428,_24340434,_24340440).
'blocked_blocked_Debug.Profile.showMemInfo.showBytes.2_ComplexCase'('FAIL'(_24344934),_24331808,_24328410,_24331828,'FAIL'(_24344934),_24344948,_24344948).

'Debug.Profile.showMemInfo.formatItem.2'(_24346596,_24346598,_24346600,_24346602,_24346604,_24346606):-freeze(_24346604,'blocked_Debug.Profile.showMemInfo.formatItem.2'(_24346596,_24346598,_24346600,_24346602,_24346604,_24346606)).
'blocked_Debug.Profile.showMemInfo.formatItem.2'(_24346702,_24346720,_24346738,_24347314,_24347320,_24347326):-hnf('Prelude.maybe'([],partcall(1,'Debug.Profile.showMemInfo.formatItem.2._\'23lambda1',[_24346738]),'Prelude.lookup'(partcall(1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[]),_24346720,_24346702)),_24347314,_24347320,_24347326).

'Debug.Profile.showMemInfo.formatItem.2._\'23lambda1'(_24351518,_24351520,_24351522,_24351524,_24351526):-freeze(_24351524,'blocked_Debug.Profile.showMemInfo.formatItem.2._\'23lambda1'(_24351518,_24351520,_24351522,_24351524,_24351526)).
'blocked_Debug.Profile.showMemInfo.formatItem.2._\'23lambda1'(_24351614,_24351632,['Prelude.++'(_24351614,'Debug.Profile.showMemInfo.showBytes.2'(partcall(1,'Prelude._inst\'23Prelude.Integral\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Int\'23',[]),_24351632))],_24352228,_24352228).

'Debug.Profile.printMemInfo'(_24355610,_24355612,_24355614):-freeze(_24355612,'blocked_Debug.Profile.printMemInfo'(_24355610,_24355612,_24355614)).
'blocked_Debug.Profile.printMemInfo'(_24356202,_24356208,_24356214):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),'Prelude..'(partcall(1,'Prelude.putStrLn',[]),partcall(1,'Debug.Profile.showMemInfo',[]))),_24356202,_24356208,_24356214).

'Debug.Profile.profileTime'(_24359292,_24359294,_24359296,_24359298):-freeze(_24359296,'blocked_Debug.Profile.profileTime'(_24359292,_24359294,_24359296,_24359298)).
'blocked_Debug.Profile.profileTime'(_24359378,_24359814,_24359820,_24359826):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getTimings'(_24359378)),partcall(1,'Debug.Profile.profileTime._\'23lambda3',[])),_24359814,_24359820,_24359826).

'Debug.Profile.profileTime._\'23lambda3'(_24363104,_24363106,_24363108,_24363110):-freeze(_24363108,'blocked_Debug.Profile.profileTime._\'23lambda3'(_24363104,_24363106,_24363108,_24363110)).
'blocked_Debug.Profile.profileTime._\'23lambda3'(_24363190,_24378238,_24378244,_24378250):-hnf(_24363190,_24379948,_24378244,_24379960),'blocked_Debug.Profile.profileTime._\'23lambda3_1'(_24379948,_24378238,_24379960,_24378250).

'blocked_Debug.Profile.profileTime._\'23lambda3_1'(_24380430,_24380432,_24380434,_24380436):-freeze(_24380434,freeze(_24380430,'blocked_blocked_Debug.Profile.profileTime._\'23lambda3_1'(_24380430,_24380432,_24380434,_24380436))).
'blocked_blocked_Debug.Profile.profileTime._\'23lambda3_1'('Prelude.(,,,)'(_24363306,_24363324,_24363342,_24363360),_24380834,_24380840,_24380846):-!,hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^R','^u','^n','^ ','^t','^i','^m','^e',^:,'^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ '],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_24363324),['^ ','^m','^s','^e','^c',^.])))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^E','^l','^a','^p','^s','^e','^d','^ ','^t','^i','^m','^e',^:,'^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ '],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_24363342),['^ ','^m','^s','^e','^c',^.])))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^G','^a','^r','^b','^a','^g','^e','^ ','^c','^o','^l','^l','^e','^c','^t','^i','^o','^n','^s',^:,'^ '],'Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_24363360)))),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_24363306)))),_24380834,_24380840,_24380846).
'blocked_blocked_Debug.Profile.profileTime._\'23lambda3_1'('FAIL'(_24404888),'FAIL'(_24404888),_24404902,_24404902).

'Debug.Profile.getTimings'(_24405994,_24405996,_24405998,_24406000):-freeze(_24405998,'blocked_Debug.Profile.getTimings'(_24405994,_24405996,_24405998,_24406000)).
'blocked_Debug.Profile.getTimings'(_24406080,_24406852,_24406858,_24406864):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.garbageCollect'),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),partcall(1,'Debug.Profile.getTimings._\'23lambda8',[_24406080]))),_24406852,_24406858,_24406864).

'Debug.Profile.getTimings._\'23lambda8'(_24411212,_24411214,_24411216,_24411218,_24411220):-freeze(_24411218,'blocked_Debug.Profile.getTimings._\'23lambda8'(_24411212,_24411214,_24411216,_24411218,_24411220)).
'blocked_Debug.Profile.getTimings._\'23lambda8'(_24411308,_24411326,_24412090,_24412096,_24412102):-makeShare(_24411354,_24412258),hnf('Prelude.cond'(letrec4PAKCS(_24412258,_24411326),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23',_24411308),partcall(1,'Debug.Profile.getTimings._\'23lambda8._\'23lambda10',[_24412258]))),_24412090,_24412096,_24412102).

'Debug.Profile.getTimings._\'23lambda8._\'23lambda10'(_24416758,_24416760,_24416762,_24416764,_24416766):-freeze(_24416764,'blocked_Debug.Profile.getTimings._\'23lambda8._\'23lambda10'(_24416758,_24416760,_24416762,_24416764,_24416766)).
'blocked_Debug.Profile.getTimings._\'23lambda8._\'23lambda10'(_24416854,_24416872,_24417720,_24417726,_24417732):-makeShare(_24416900,_24417890),hnf('Prelude.cond'(letrec4PAKCS(_24417890,_24416872),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),partcall(1,'Debug.Profile.getTimings._\'23lambda8._\'23lambda10._\'23lambda12',[_24416854,_24417890]))),_24417720,_24417726,_24417732).

'Debug.Profile.getTimings._\'23lambda8._\'23lambda10._\'23lambda12'(_24423276,_24423278,_24423280,_24423282,_24423284,_24423286):-freeze(_24423284,'blocked_Debug.Profile.getTimings._\'23lambda8._\'23lambda10._\'23lambda12'(_24423276,_24423278,_24423280,_24423282,_24423284,_24423286)).
'blocked_Debug.Profile.getTimings._\'23lambda8._\'23lambda10._\'23lambda12'(_24423382,_24423400,_24423418,_24424952,_24424958,_24424964):-makeShare(_24423446,_24425316),makeShare(_24423400,_24425336),hnf('Prelude.cond'(letrec4PAKCS(_24425316,_24423418),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.(,,,)'(_24423382,'Debug.Profile.infoDiff'(_24425336,_24425316,'Debug.Profile.RunTime'),'Debug.Profile.infoDiff'(_24425336,_24425316,'Debug.Profile.ElapsedTime'),'Debug.Profile.infoDiff'(_24425336,_24425316,'Debug.Profile.GarbageCollections')))),_24424952,_24424958,_24424964).

'Debug.Profile.getTimingsNF'(_24430948,_24430950,_24430952,_24430954):-freeze(_24430952,'blocked_Debug.Profile.getTimingsNF'(_24430948,_24430950,_24430952,_24430954)).
'blocked_Debug.Profile.getTimingsNF'(_24431034,_24431974,_24431980,_24431986):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getTimings'('Prelude.seq'('Prelude.$!!'(partcall(1,'Prelude.id',[]),_24431034),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.()')))),partcall(1,'Debug.Profile.getTimingsNF._\'23lambda15',[])),_24431974,_24431980,_24431986).

'Debug.Profile.getTimingsNF._\'23lambda15'(_24436754,_24436756,_24436758,_24436760):-freeze(_24436758,'blocked_Debug.Profile.getTimingsNF._\'23lambda15'(_24436754,_24436756,_24436758,_24436760)).
'blocked_Debug.Profile.getTimingsNF._\'23lambda15'(_24436840,_24437760,_24437766,_24437772):-hnf(_24436840,_24439542,_24437766,_24439554),'blocked_Debug.Profile.getTimingsNF._\'23lambda15_1'(_24439542,_24437760,_24439554,_24437772).

'blocked_Debug.Profile.getTimingsNF._\'23lambda15_1'(_24440036,_24440038,_24440040,_24440042):-freeze(_24440040,freeze(_24440036,'blocked_blocked_Debug.Profile.getTimingsNF._\'23lambda15_1'(_24440036,_24440038,_24440040,_24440042))).
'blocked_blocked_Debug.Profile.getTimingsNF._\'23lambda15_1'('Prelude.(,,,)'(_24436956,_24436974,_24436992,_24437010),_24440440,_24440446,_24440452):-!,hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.(,,)'(_24436974,_24436992,_24437010)),_24440440,_24440446,_24440452).
'blocked_blocked_Debug.Profile.getTimingsNF._\'23lambda15_1'('FAIL'(_24442192),'FAIL'(_24442192),_24442206,_24442206).

'Debug.Profile.getElapsedTimeNF'(_24443526,_24443528,_24443530,_24443532):-freeze(_24443530,'blocked_Debug.Profile.getElapsedTimeNF'(_24443526,_24443528,_24443530,_24443532)).
'blocked_Debug.Profile.getElapsedTimeNF'(_24443612,_24444384,_24444390,_24444396):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.garbageCollect'),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),partcall(1,'Debug.Profile.getElapsedTimeNF._\'23lambda20',[_24443612]))),_24444384,_24444390,_24444396).

'Debug.Profile.getElapsedTimeNF._\'23lambda20'(_24449088,_24449090,_24449092,_24449094,_24449096):-freeze(_24449094,'blocked_Debug.Profile.getElapsedTimeNF._\'23lambda20'(_24449088,_24449090,_24449092,_24449094,_24449096)).
'blocked_Debug.Profile.getElapsedTimeNF._\'23lambda20'(_24449184,_24449202,_24450386,_24450392,_24450398):-makeShare(_24449230,_24450564),hnf('Prelude.cond'(letrec4PAKCS(_24450564,_24449202),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23',_24449184),partcall(1,'Prelude.$!!',['Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23']))),partcall(1,'Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22',[_24450564]))),_24450386,_24450392,_24450398).

'Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22'(_24456940,_24456942,_24456944,_24456946,_24456948):-freeze(_24456946,'blocked_Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22'(_24456940,_24456942,_24456944,_24456946,_24456948)).
'blocked_Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22'(_24457036,_24457054,_24457902,_24457908,_24457914):-makeShare(_24457082,_24458072),hnf('Prelude.cond'(letrec4PAKCS(_24458072,_24457054),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),partcall(1,'Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22._\'23lambda24',[_24457036,_24458072]))),_24457902,_24457908,_24457914).

'Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22._\'23lambda24'(_24463808,_24463810,_24463812,_24463814,_24463816,_24463818):-freeze(_24463816,'blocked_Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22._\'23lambda24'(_24463808,_24463810,_24463812,_24463814,_24463816,_24463818)).
'blocked_Debug.Profile.getElapsedTimeNF._\'23lambda20._\'23lambda22._\'23lambda24'(_24463914,_24463932,_24463950,_24464868,_24464874,_24464880):-makeShare(_24463978,_24465096),hnf('Prelude.cond'(letrec4PAKCS(_24465096,_24463950),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.(,)'(_24463914,'Debug.Profile.infoDiff'(_24463932,_24465096,'Debug.Profile.ElapsedTime')))),_24464868,_24464874,_24464880).

'Debug.Profile.profileTimeNF'(_24469248,_24469250,_24469252,_24469254):-freeze(_24469252,'blocked_Debug.Profile.profileTimeNF'(_24469248,_24469250,_24469252,_24469254)).
'blocked_Debug.Profile.profileTimeNF'(_24469334,_24469938,_24469944,_24469950):-hnf('Debug.Profile.profileTime'('Prelude.seq'('Prelude.$!!'(partcall(1,'Prelude.id',[]),_24469334),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.()'))),_24469938,_24469944,_24469950).

'Debug.Profile.profileSpace'(_24473108,_24473110,_24473112,_24473114):-freeze(_24473112,'blocked_Debug.Profile.profileSpace'(_24473108,_24473110,_24473112,_24473114)).
'blocked_Debug.Profile.profileSpace'(_24473194,_24474302,_24474308,_24474314):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.garbageCollect'),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.garbageCollectorOff'),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),partcall(1,'Debug.Profile.profileSpace._\'23lambda29',[_24473194])))),_24474302,_24474308,_24474314).

'Debug.Profile.profileSpace._\'23lambda29'(_24479924,_24479926,_24479928,_24479930,_24479932):-freeze(_24479930,'blocked_Debug.Profile.profileSpace._\'23lambda29'(_24479924,_24479926,_24479928,_24479930,_24479932)).
'blocked_Debug.Profile.profileSpace._\'23lambda29'(_24480020,_24480038,_24480802,_24480808,_24480814):-makeShare(_24480066,_24480970),hnf('Prelude.cond'(letrec4PAKCS(_24480970,_24480038),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23',_24480020),partcall(1,'Debug.Profile.profileSpace._\'23lambda29._\'23lambda31',[_24480970]))),_24480802,_24480808,_24480814).

'Debug.Profile.profileSpace._\'23lambda29._\'23lambda31'(_24485620,_24485622,_24485624,_24485626,_24485628):-freeze(_24485626,'blocked_Debug.Profile.profileSpace._\'23lambda29._\'23lambda31'(_24485620,_24485622,_24485624,_24485626,_24485628)).
'blocked_Debug.Profile.profileSpace._\'23lambda29._\'23lambda31'(_24485716,_24485734,_24486582,_24486588,_24486594):-makeShare(_24485762,_24486752),hnf('Prelude.cond'(letrec4PAKCS(_24486752,_24485734),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.getProcessInfos'),partcall(1,'Debug.Profile.profileSpace._\'23lambda29._\'23lambda31._\'23lambda33',[_24485716,_24486752]))),_24486582,_24486588,_24486594).

'Debug.Profile.profileSpace._\'23lambda29._\'23lambda31._\'23lambda33'(_24492288,_24492290,_24492292,_24492294,_24492296,_24492298):-freeze(_24492296,'blocked_Debug.Profile.profileSpace._\'23lambda29._\'23lambda31._\'23lambda33'(_24492288,_24492290,_24492292,_24492294,_24492296,_24492298)).
'blocked_Debug.Profile.profileSpace._\'23lambda29._\'23lambda31._\'23lambda33'(_24492394,_24492412,_24492430,_24518310,_24518316,_24518322):-makeShare(_24492458,_24519370),makeShare(_24492412,_24519390),hnf('Prelude.cond'(letrec4PAKCS(_24519370,_24492430),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Profile.garbageCollectorOn'),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^R','^u','^n','^ ','^t','^i','^m','^e',^:,'^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ '],'Prelude.++'('Debug.Profile.showInfoDiff'(_24519390,_24519370,'Debug.Profile.RunTime'),['^ ','^m','^s','^e','^c',^.])))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^E','^l','^a','^p','^s','^e','^d','^ ','^t','^i','^m','^e',^:,'^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ '],'Prelude.++'('Debug.Profile.showInfoDiff'(_24519390,_24519370,'Debug.Profile.ElapsedTime'),['^ ','^m','^s','^e','^c',^.])))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^G','^a','^r','^b','^a','^g','^e','^ ','^c','^o','^l','^l','^e','^c','^t','^i','^o','^n','^s',^:,'^ '],'Debug.Profile.showInfoDiff'(_24519390,_24519370,'Debug.Profile.GarbageCollections')))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^H','^e','^a','^p','^ ','^u','^s','^a','^g','^e',^:,'^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ '],'Prelude.++'('Debug.Profile.showInfoDiff'(_24519390,_24519370,'Debug.Profile.Heap'),['^ ','^b','^y','^t','^e','^s'])))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^S','^t','^a','^c','^k','^ ','^u','^s','^a','^g','^e',^:,'^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ ','^ '],'Prelude.++'('Debug.Profile.showInfoDiff'(_24519390,_24519370,'Debug.Profile.Stack'),['^ ','^b','^y','^t','^e','^s'])))),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_24492394)))))))),_24518310,_24518316,_24518322).

'Debug.Profile.profileSpaceNF'(_24562004,_24562006,_24562008,_24562010):-freeze(_24562008,'blocked_Debug.Profile.profileSpaceNF'(_24562004,_24562006,_24562008,_24562010)).
'blocked_Debug.Profile.profileSpaceNF'(_24562090,_24562694,_24562700,_24562706):-hnf('Debug.Profile.profileSpace'('Prelude.seq'('Prelude.$!!'(partcall(1,'Prelude.id',[]),_24562090),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.()'))),_24562694,_24562700,_24562706).

'Debug.Profile.showInfoDiff'(_24565876,_24565878,_24565880,_24565882,_24565884,_24565886):-freeze(_24565884,'blocked_Debug.Profile.showInfoDiff'(_24565876,_24565878,_24565880,_24565882,_24565884,_24565886)).
'blocked_Debug.Profile.showInfoDiff'(_24565982,_24566000,_24566018,_24567308,_24567314,_24567320):-makeShare(_24566018,_24567498),hnf('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23','Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.maybe'(0,partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[]),_24567498,_24566000)),'Prelude.maybe'(0,partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[]),_24567498,_24565982)))),_24567308,_24567314,_24567320).

'Debug.Profile.infoDiff'(_24572636,_24572638,_24572640,_24572642,_24572644,_24572646):-freeze(_24572644,'blocked_Debug.Profile.infoDiff'(_24572636,_24572638,_24572640,_24572642,_24572644,_24572646)).
'blocked_Debug.Profile.infoDiff'(_24572742,_24572760,_24572778,_24573900,_24573906,_24573912):-makeShare(_24572778,_24574086),hnf('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.maybe'(0,partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[]),_24574086,_24572760)),'Prelude.maybe'(0,partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Debug.Profile._inst\'23Prelude.Eq\'23Debug.Profile.ProcessInfo\'23',[]),_24574086,_24572742))),_24573900,_24573906,_24573912).

:-costCenters(['']).




%%%%% Number of shared variables: 17

:-style_check(-singleton).
'Debug.Profile.getProcessInfos'(_24577652):-(getCurrentGCs(_24577656)->_24577674=['Prelude.(,)'('Debug.Profile.GarbageCollections',_24577656)];_24577674=[]),(getCurrentChoiceSize(_24577698)->_24577716=['Prelude.(,)'('Debug.Profile.Choices',_24577698)|_24577674];_24577716=_24577674),(getCurrentHeapSize(_24577740)->_24577758=['Prelude.(,)'('Debug.Profile.Heap',_24577740)|_24577716];_24577758=_24577716),(getCurrentStackSize(_24577782)->_24577800=['Prelude.(,)'('Debug.Profile.Stack',_24577782)|_24577758];_24577800=_24577758),(getCurrentCodeSize(_24577824)->_24577842=['Prelude.(,)'('Debug.Profile.Code',_24577824)|_24577800];_24577842=_24577800),(getCurrentMemorySize(_24577866)->_24577884=['Prelude.(,)'('Debug.Profile.Memory',_24577866)|_24577842];_24577884=_24577842),(getElapsedTime(_24577908)->_24577926=['Prelude.(,)'('Debug.Profile.ElapsedTime',_24577908)|_24577884];_24577926=_24577884),(getRunTime(_24577950)->_24577968=['Prelude.(,)'('Debug.Profile.RunTime',_24577950)|_24577926];_24577968=_24577926),_24577652=_24577968.
'Debug.Profile.garbageCollectorOn'('Prelude.()'):-garbageCollectorOn.
'Debug.Profile.garbageCollectorOff'('Prelude.()'):-garbageCollectorOff.
'Debug.Profile.garbageCollect'('Prelude.()'):-garbageCollect.
