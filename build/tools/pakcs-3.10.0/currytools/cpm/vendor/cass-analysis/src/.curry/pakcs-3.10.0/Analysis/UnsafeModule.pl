%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.Types').
:-importModule('Data.List').
:-importModule('FlatCurry.Goodies').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.UnsafeModule').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.UnsafeModule.unsafeModuleAnalysis',unsafeModuleAnalysis,0,'Analysis.UnsafeModule.unsafeModuleAnalysis',nofix,notype).
functiontype('Analysis.UnsafeModule.showUnsafe',showUnsafe,2,'Analysis.UnsafeModule.showUnsafe',nofix,notype).
functiontype('Analysis.UnsafeModule.importsUnsafe','Analysis.UnsafeModule.importsUnsafe',2,'Analysis.UnsafeModule.importsUnsafe',nofix,notype).
functiontype('Analysis.UnsafeModule.importsUnsafe._\'23caseor0','Analysis.UnsafeModule.importsUnsafe._#caseor0',2,'Analysis.UnsafeModule.importsUnsafe._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.UnsafeModule.unsafeModuleAnalysis'(_13862630,_13862632,_13862634):-freeze(_13862632,'blocked_Analysis.UnsafeModule.unsafeModuleAnalysis'(_13862630,_13862632,_13862634)).
'blocked_Analysis.UnsafeModule.unsafeModuleAnalysis'(_13864734,_13864740,_13864746):-hnf('Analysis.Types.dependencyModuleAnalysis'(['^U','^n','^s','^a','^f','^e','^M','^o','^d','^u','^l','^e'],partcall(2,'Analysis.UnsafeModule.importsUnsafe',[])),_13864734,_13864740,_13864746).

'Analysis.UnsafeModule.showUnsafe'(_13869594,_13869596,_13869598,_13869600,_13869602):-freeze(_13869600,'blocked_Analysis.UnsafeModule.showUnsafe'(_13869594,_13869596,_13869598,_13869600,_13869602)).
'blocked_Analysis.UnsafeModule.showUnsafe'(_13869690,_13869708,_13882600,_13882606,_13882612):-makeShare(_13869708,_13879962),hnf(_13879962,_13884138,_13882606,_13884162),'blocked_Analysis.UnsafeModule.showUnsafe_2'(_13884138,_13869690,_13884138,_13882600,_13884162,_13882612).

'blocked_Analysis.UnsafeModule.showUnsafe_2'(_13884624,_13884626,_13884628,_13884630,_13884632,_13884634):-freeze(_13884632,'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'(_13884624,_13884626,_13884628,_13884630,_13884632,_13884634)).
'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'([],_13869690,_13879962,['^s','^a','^f','^e'],_13884892,_13884892).
'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'([_13870540|_13870558],_13869690,_13879962,_13886794,_13886800,_13886806):-!,hnf(_13869690,_13888820,_13886800,_13888850),'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'(_13888820,_13870540,_13870558,_13879962,_13886794,_13888850,_13886806).

'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'(_13889410,_13889412,_13889414,_13889416,_13889418,_13889420,_13889422):-freeze(_13889420,'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'(_13889410,_13889412,_13889414,_13889416,_13889418,_13889420,_13889422)).
'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'('Analysis.Types.ANote',_13870540,_13870558,_13879962,['^u','^n','^s','^a','^f','^e'],_13889920,_13889920).
'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'('Analysis.Types.AText',_13870540,_13870558,_13879962,_13892664,_13892670,_13892676):-!,hnf(_13870558,_13895712,_13892670,_13895736),'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'(_13895712,_13870540,_13879962,_13892664,_13895736,_13892676).

'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'(_13896474,_13896476,_13896478,_13896480,_13896482,_13896484):-freeze(_13896482,'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'(_13896474,_13896476,_13896478,_13896480,_13896482,_13896484)).
'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'([],_13870540,_13879962,_13896736,_13896742,_13896748):-hnf('Prelude.++'(['^u','^n','^s','^a','^f','^e','^ ','^(','^d','^u','^e','^ ','^t','^o','^ ','^m','^o','^d','^u','^l','^e','^ '],'Prelude.++'(_13870540,['^)'])),_13896736,_13896742,_13896748).
'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'([_13875772|_13875790],_13870540,_13879962,_13903088,_13903094,_13903100):-!,hnf('Prelude.++'(['^u','^n','^s','^a','^f','^e','^ ','^(','^d','^u','^e','^ ','^t','^o','^ ','^m','^o','^d','^u','^l','^e','^s','^ '],'Prelude.++'('Prelude.unwords'(_13879962),['^)'])),_13903088,_13903094,_13903100).
'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'('FAIL'(_13909802),_13870540,_13879962,'FAIL'(_13909802),_13909816,_13909816):-nonvar(_13909802).
'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'('FAIL'(_13909888),_13870540,_13870558,_13879962,'FAIL'(_13909888),_13909902,_13909902):-nonvar(_13909888).
'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'('FAIL'(_13909982),_13869690,_13879962,'FAIL'(_13909982),_13909996,_13909996):-nonvar(_13909982).

'Analysis.UnsafeModule.importsUnsafe'(_13911526,_13911528,_13911530,_13911532,_13911534):-freeze(_13911532,'blocked_Analysis.UnsafeModule.importsUnsafe'(_13911526,_13911528,_13911530,_13911532,_13911534)).
'blocked_Analysis.UnsafeModule.importsUnsafe'(_13911622,_13911640,_13914644,_13914650,_13914656):-makeShare(_13911668,_13914916),makeShare(_13911622,_13914936),hnf('Prelude.cond'(letrec4PAKCS(_13914916,'Prelude.++'('Analysis.UnsafeModule.importsUnsafe._\'23caseor0'('Prelude.apply'('Prelude.any'(partcall(1,'Data.List.isInfixOf',[['^U','^n','^s','^a','^f','^e'],partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])),['Prelude.apply'('FlatCurry.Goodies.progName',_13914936)|'Prelude.apply'('FlatCurry.Goodies.progImports',_13914936)]),_13914936),'Prelude.apply'('Prelude.concatMap'(partcall(1,'Prelude.snd',[])),_13911640))),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_13914916)),_13914644,_13914650,_13914656).

'Analysis.UnsafeModule.importsUnsafe._\'23caseor0'(_13923972,_13923974,_13923976,_13923978,_13923980):-freeze(_13923978,'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0'(_13923972,_13923974,_13923976,_13923978,_13923980)).
'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0'(_13924068,_13924086,_13925002,_13925008,_13925014):-hnf(_13924068,_13927080,_13925008,_13927098),'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'(_13927080,_13924086,_13925002,_13927098,_13925014).

'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'(_13927636,_13927638,_13927640,_13927642,_13927644):-freeze(_13927642,freeze(_13927636,'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'(_13927636,_13927638,_13927640,_13927642,_13927644))).
'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'('Prelude.True',_13924086,['Prelude.apply'('FlatCurry.Goodies.progName',_13924086)],_13928036,_13928036).
'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'('Prelude.False',_13924086,[],_13929580,_13929580):-!.
'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'('FAIL'(_13930166),_13924086,'FAIL'(_13930166),_13930180,_13930180).

:-costCenters(['']).




%%%%% Number of shared variables: 2

