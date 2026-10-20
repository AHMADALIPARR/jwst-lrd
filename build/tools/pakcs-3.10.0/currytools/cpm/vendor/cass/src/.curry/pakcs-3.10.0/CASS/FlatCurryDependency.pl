%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Data.List').
:-importModule('Data.Map').
:-importModule('Data.Set').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('CASS.FlatCurryDependency').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('CASS.FlatCurryDependency.dependsDirectlyOnTypes',dependsDirectlyOnTypes,1,'CASS.FlatCurryDependency.dependsDirectlyOnTypes',nofix,notype).
functiontype('CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1','CASS.FlatCurryDependency.dependsDirectlyOnTypes._#lambda1',1,'CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1',nofix,notype).
functiontype('CASS.FlatCurryDependency.tconsOf','CASS.FlatCurryDependency.tconsOf',1,'CASS.FlatCurryDependency.tconsOf',nofix,notype).
functiontype('CASS.FlatCurryDependency.callsDirectly',callsDirectly,1,'CASS.FlatCurryDependency.callsDirectly',nofix,notype).
functiontype('CASS.FlatCurryDependency.directlyDependent','CASS.FlatCurryDependency.directlyDependent',1,'CASS.FlatCurryDependency.directlyDependent',nofix,notype).
functiontype('CASS.FlatCurryDependency.funcSetOfExpr','CASS.FlatCurryDependency.funcSetOfExpr',1,'CASS.FlatCurryDependency.funcSetOfExpr',nofix,notype).
functiontype('CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63','CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63',1,'CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63',nofix,notype).
functiontype('CASS.FlatCurryDependency.isConstructorComb','CASS.FlatCurryDependency.isConstructorComb',1,'CASS.FlatCurryDependency.isConstructorComb',nofix,notype).
functiontype('CASS.FlatCurryDependency.unionMap','CASS.FlatCurryDependency.unionMap',1,'CASS.FlatCurryDependency.unionMap',nofix,notype).
functiontype('CASS.FlatCurryDependency.emptySet','CASS.FlatCurryDependency.emptySet',0,'CASS.FlatCurryDependency.emptySet',nofix,notype).
functiontype('CASS.FlatCurryDependency.leqQName','CASS.FlatCurryDependency.leqQName',2,'CASS.FlatCurryDependency.leqQName',nofix,notype).
functiontype('CASS.FlatCurryDependency.isConstructorComb._\'23caseor0','CASS.FlatCurryDependency.isConstructorComb._#caseor0',2,'CASS.FlatCurryDependency.isConstructorComb._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'CASS.FlatCurryDependency.dependsDirectlyOnTypes'(_53379016,_53379018,_53379020,_53379022):-freeze(_53379020,'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes'(_53379016,_53379018,_53379020,_53379022)).
'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes'(_53379102,_53382150,_53382156,_53382162):-hnf(_53379102,_53384220,_53382156,_53384232),'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'(_53384220,_53382150,_53384232,_53382162).

'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'(_53384756,_53384758,_53384760,_53384762):-freeze(_53384760,'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'(_53384756,_53384758,_53384760,_53384762)).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FlatCurry.Types.Type'(_53379218,_53379236,_53379254,_53379272),_53385264,_53385270,_53385276):-hnf('Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),'Prelude.apply'('Prelude.concatMap'(partcall(1,'CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1',[])),_53379272)),_53385264,_53385270,_53385276).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FlatCurry.Types.TypeSyn'(_53380156,_53380174,_53380192,_53380210),_53389552,_53389558,_53389564):-hnf('Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),'CASS.FlatCurryDependency.tconsOf'(_53380210)),_53389552,_53389558,_53389564).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FlatCurry.Types.TypeNew'(_53380926,_53380944,_53380962,_53380980),_53393720,_53393726,_53393732):-!,hnf(_53380980,_53396870,_53393726,_53396900),'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'(_53396870,_53380926,_53380944,_53380962,_53393720,_53396900,_53393732).

'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'(_53397670,_53397672,_53397674,_53397676,_53397678,_53397680,_53397682):-freeze(_53397680,'blocked_blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'(_53397670,_53397672,_53397674,_53397676,_53397678,_53397680,_53397682)).
'blocked_blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'('FlatCurry.Types.NewCons'(_53381120,_53381138,_53381156),_53380926,_53380944,_53380962,_53398236,_53398242,_53398248):-!,hnf('Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),'CASS.FlatCurryDependency.tconsOf'(_53381156)),_53398236,_53398242,_53398248).
'blocked_blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'('FAIL'(_53401874),_53380926,_53380944,_53380962,'FAIL'(_53401874),_53401888,_53401888):-nonvar(_53401874).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FAIL'(_53401968),'FAIL'(_53401968),_53401982,_53401982):-nonvar(_53401968).

'CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1'(_53404360,_53404362,_53404364,_53404366):-freeze(_53404364,'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1'(_53404360,_53404362,_53404364,_53404366)).
'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1'(_53404446,_53405346,_53405352,_53405358):-hnf(_53404446,_53407848,_53405352,_53407860),'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'(_53407848,_53405346,_53407860,_53405358).

'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'(_53408456,_53408458,_53408460,_53408462):-freeze(_53408460,'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'(_53408456,_53408458,_53408460,_53408462)).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'('FlatCurry.Types.Cons'(_53404562,_53404580,_53404598,_53404616),_53408964,_53408970,_53408976):-!,hnf('Prelude.apply'('Prelude.concatMap'(partcall(1,'CASS.FlatCurryDependency.tconsOf',[])),_53404616),_53408964,_53408970,_53408976).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'('FAIL'(_53410534),'FAIL'(_53410534),_53410548,_53410548):-nonvar(_53410534).

'CASS.FlatCurryDependency.tconsOf'(_53411948,_53411950,_53411952,_53411954):-freeze(_53411952,'blocked_CASS.FlatCurryDependency.tconsOf'(_53411948,_53411950,_53411952,_53411954)).
'blocked_CASS.FlatCurryDependency.tconsOf'(_53412034,_53413676,_53413682,_53413688):-hnf(_53412034,_53415206,_53413682,_53415218),'blocked_CASS.FlatCurryDependency.tconsOf_1'(_53415206,_53413676,_53415218,_53413688).

'blocked_CASS.FlatCurryDependency.tconsOf_1'(_53415652,_53415654,_53415656,_53415658):-freeze(_53415656,'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'(_53415652,_53415654,_53415656,_53415658)).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.TVar'(_53412150),[],_53416142,_53416142).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.FuncType'(_53412274,_53412292),_53417078,_53417084,_53417090):-hnf('Prelude.++'('CASS.FlatCurryDependency.tconsOf'(_53412274),'CASS.FlatCurryDependency.tconsOf'(_53412292)),_53417078,_53417084,_53417090).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.TCons'(_53412730,_53412748),[_53412730|'Prelude.apply'('Prelude.concatMap'(partcall(1,'CASS.FlatCurryDependency.tconsOf',[])),_53412748)],_53419004,_53419004).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.ForallType'(_53413270,_53413288),_53420936,_53420942,_53420948):-!,hnf('CASS.FlatCurryDependency.tconsOf'(_53413288),_53420936,_53420942,_53420948).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FAIL'(_53421810),'FAIL'(_53421810),_53421824,_53421824):-nonvar(_53421810).

'CASS.FlatCurryDependency.callsDirectly'(_53423452,_53423454,_53423456,_53423458):-freeze(_53423456,'blocked_CASS.FlatCurryDependency.callsDirectly'(_53423452,_53423454,_53423456,_53423458)).
'blocked_CASS.FlatCurryDependency.callsDirectly'(_53423538,_53423890,_53423896,_53423902):-hnf('Prelude.apply'('Data.Set.toList','Prelude.snd'('CASS.FlatCurryDependency.directlyDependent'(_53423538))),_53423890,_53423896,_53423902).

'CASS.FlatCurryDependency.directlyDependent'(_53427002,_53427004,_53427006,_53427008):-freeze(_53427006,'blocked_CASS.FlatCurryDependency.directlyDependent'(_53427002,_53427004,_53427006,_53427008)).
'blocked_CASS.FlatCurryDependency.directlyDependent'(_53427088,_53428326,_53428332,_53428338):-hnf(_53427088,_53430216,_53428332,_53430228),'blocked_CASS.FlatCurryDependency.directlyDependent_1'(_53430216,_53428326,_53430228,_53428338).

'blocked_CASS.FlatCurryDependency.directlyDependent_1'(_53430722,_53430724,_53430726,_53430728):-freeze(_53430726,'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1'(_53430722,_53430724,_53430726,_53430728)).
'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1'('FlatCurry.Types.Func'(_53427204,_53427222,_53427240,_53427258,_53427276),_53431660,_53431666,_53431672):-!,hnf(_53427276,_53434540,_53431666,_53434576),'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'(_53434540,_53427204,_53427222,_53427240,_53427258,_53431660,_53434576,_53431672).

'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'(_53435306,_53435308,_53435310,_53435312,_53435314,_53435316,_53435318,_53435320):-freeze(_53435318,'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'(_53435306,_53435308,_53435310,_53435312,_53435314,_53435316,_53435318,_53435320)).
'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_53427422,_53427440),_53427204,_53427222,_53427240,_53427258,'Prelude.(,)'(_53427204,'CASS.FlatCurryDependency.funcSetOfExpr'(_53427440)),_53435844,_53435844).
'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_53427794),_53427204,_53427222,_53427240,_53427258,'Prelude.(,)'(_53427204,'CASS.FlatCurryDependency.emptySet'),_53437978,_53437978):-!.
'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'('FAIL'(_53439464),_53427204,_53427222,_53427240,_53427258,'FAIL'(_53439464),_53439478,_53439478):-nonvar(_53439464).
'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1'('FAIL'(_53439566),'FAIL'(_53439566),_53439580,_53439580):-nonvar(_53439566).

'CASS.FlatCurryDependency.funcSetOfExpr'(_53441208,_53441210,_53441212,_53441214):-freeze(_53441212,'blocked_CASS.FlatCurryDependency.funcSetOfExpr'(_53441208,_53441210,_53441212,_53441214)).
'blocked_CASS.FlatCurryDependency.funcSetOfExpr'(_53441294,_53447488,_53447494,_53447500):-hnf(_53441294,_53449234,_53447494,_53449246),'blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'(_53449234,_53447488,_53449246,_53447500).

'blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'(_53449716,_53449718,_53449720,_53449722):-freeze(_53449720,'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'(_53449716,_53449718,_53449720,_53449722)).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Var'(_53441410),_53450188,_53450194,_53450200):-hnf('Data.Set.empty',_53450188,_53450194,_53450200).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Lit'(_53441534),_53451204,_53451210,_53451216):-hnf('Data.Set.empty',_53451204,_53451210,_53451216).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Comb'(_53441658,_53441676,_53441694),_53453670,_53453676,_53453682):-hnf('CASS.FlatCurryDependency.isConstructorComb'(_53441658),_53456514,_53453676,_53456474),'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'(_53456514,_53441658,_53441676,_53441694,_53453670,_53456474,_53453682).

'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'(_53457220,_53457222,_53457224,_53457226,_53457228,_53457230,_53457232):-freeze(_53457230,freeze(_53457220,'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'(_53457220,_53457222,_53457224,_53457226,_53457228,_53457230,_53457232))).
'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_53441658,_53441676,_53441694,_53457634,_53457640,_53457646):-hnf('Prelude.apply'('CASS.FlatCurryDependency.unionMap'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr',[])),_53441694),_53457634,_53457640,_53457646).
'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_53441658,_53441676,_53441694,_53459706,_53459712,_53459718):-!,hnf('Data.Set.insert'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),_53441676,'Prelude.apply'('CASS.FlatCurryDependency.unionMap'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr',[])),_53441694)),_53459706,_53459712,_53459718).
'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_53463814),_53441658,_53441676,_53441694,'FAIL'(_53463814),_53463828,_53463828).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Free'(_53443168,_53443186),_53464316,_53464322,_53464328):-hnf('CASS.FlatCurryDependency.funcSetOfExpr'(_53443186),_53464316,_53464322,_53464328).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Let'(_53443386,_53443404),_53465644,_53465650,_53465656):-hnf('Prelude.apply'('Prelude.apply'('Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),'Prelude.apply'('CASS.FlatCurryDependency.unionMap'('Prelude..'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr',[]),partcall(1,'FlatCurry.Types.expOfLetBind',[]))),_53443386)),'CASS.FlatCurryDependency.funcSetOfExpr'(_53443404)),_53465644,_53465650,_53465656).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Or'(_53444766,_53444784),_53470978,_53470984,_53470990):-hnf('Prelude.apply'('Prelude.apply'('Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),'CASS.FlatCurryDependency.funcSetOfExpr'(_53444766)),'CASS.FlatCurryDependency.funcSetOfExpr'(_53444784)),_53470978,_53470984,_53470990).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Case'(_53445810,_53445828,_53445846),_53475362,_53475368,_53475374):-hnf('Prelude.apply'('Prelude.apply'('Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),'CASS.FlatCurryDependency.funcSetOfExpr'(_53445828)),'Prelude.apply'('CASS.FlatCurryDependency.unionMap'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63',[])),_53445846)),_53475362,_53475368,_53475374).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Typed'(_53447046,_53447064),_53480428,_53480434,_53480440):-!,hnf('CASS.FlatCurryDependency.funcSetOfExpr'(_53447046),_53480428,_53480434,_53480440).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FAIL'(_53481374),'FAIL'(_53481374),_53481388,_53481388):-nonvar(_53481374).

'CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63'(_53483738,_53483740,_53483742,_53483744):-freeze(_53483742,'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63'(_53483738,_53483740,_53483742,_53483744)).
'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63'(_53483824,_53484496,_53484502,_53484508):-hnf(_53483824,_53486926,_53484502,_53486938),'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'(_53486926,_53484496,_53486938,_53484508).

'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'(_53487522,_53487524,_53487526,_53487528):-freeze(_53487526,'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'(_53487522,_53487524,_53487526,_53487528)).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'('FlatCurry.Types.Branch'(_53483940,_53483958),_53488038,_53488044,_53488050):-!,hnf('CASS.FlatCurryDependency.funcSetOfExpr'(_53483958),_53488038,_53488044,_53488050).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'('FAIL'(_53489098),'FAIL'(_53489098),_53489112,_53489112):-nonvar(_53489098).

'CASS.FlatCurryDependency.isConstructorComb'(_53490892,_53490894,_53490896,_53490898):-freeze(_53490896,'blocked_CASS.FlatCurryDependency.isConstructorComb'(_53490892,_53490894,_53490896,_53490898)).
'blocked_CASS.FlatCurryDependency.isConstructorComb'(_53490978,_53491504,_53491510,_53491516):-makeShare(_53491006,_53491622),hnf('Prelude.cond'(letrec4PAKCS(_53491622,'Prelude.False'),'CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_53490978,_53491622)),_53491504,_53491510,_53491516).

'CASS.FlatCurryDependency.unionMap'(_53494880,_53494882,_53494884,_53494886):-freeze(_53494884,'blocked_CASS.FlatCurryDependency.unionMap'(_53494880,_53494882,_53494884,_53494886)).
'blocked_CASS.FlatCurryDependency.unionMap'(_53494966,_53495822,_53495828,_53495834):-hnf('Prelude..'(partcall(1,'Prelude.foldr',['CASS.FlatCurryDependency.emptySet','Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]))]),partcall(1,'Prelude.map',[_53494966])),_53495822,_53495828,_53495834).

'CASS.FlatCurryDependency.emptySet'(_53500746,_53500748,_53500750):-freeze(_53500748,'blocked_CASS.FlatCurryDependency.emptySet'(_53500746,_53500748,_53500750)).
'blocked_CASS.FlatCurryDependency.emptySet'(_53500834,_53500840,_53500846):-hnf('Data.Set.empty',_53500834,_53500840,_53500846).

'CASS.FlatCurryDependency.leqQName'(_53502676,_53502678,_53502680,_53502682,_53502684):-freeze(_53502682,'blocked_CASS.FlatCurryDependency.leqQName'(_53502676,_53502678,_53502680,_53502682,_53502684)).
'blocked_CASS.FlatCurryDependency.leqQName'(_53502772,_53502790,_53504240,_53504246,_53504252):-hnf(_53502772,_53505814,_53504246,_53505832),'blocked_CASS.FlatCurryDependency.leqQName_1'(_53505814,_53502790,_53504240,_53505832,_53504252).

'blocked_CASS.FlatCurryDependency.leqQName_1'(_53506280,_53506282,_53506284,_53506286,_53506288):-freeze(_53506286,'blocked_blocked_CASS.FlatCurryDependency.leqQName_1'(_53506280,_53506282,_53506284,_53506286,_53506288)).
'blocked_blocked_CASS.FlatCurryDependency.leqQName_1'('Prelude.(,)'(_53502906,_53502924),_53502790,_53507012,_53507018,_53507024):-!,hnf(_53502790,_53509306,_53507018,_53509330),'blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'(_53509306,_53502906,_53502924,_53507012,_53509330,_53507024).

'blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'(_53509936,_53509938,_53509940,_53509942,_53509944,_53509946):-freeze(_53509944,'blocked_blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'(_53509936,_53509938,_53509940,_53509942,_53509944,_53509946)).
'blocked_blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'('Prelude.(,)'(_53503052,_53503070),_53502906,_53502924,_53510326,_53510332,_53510338):-!,hnf('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[]),'Prelude.++'(_53502906,[^.|_53502924]),'Prelude.++'(_53503052,[^.|_53503070])),_53510326,_53510332,_53510338).
'blocked_blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'('FAIL'(_53513234),_53502906,_53502924,'FAIL'(_53513234),_53513248,_53513248):-nonvar(_53513234).
'blocked_blocked_CASS.FlatCurryDependency.leqQName_1'('FAIL'(_53513320),_53502790,'FAIL'(_53513320),_53513334,_53513334):-nonvar(_53513320).

'CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_53515530,_53515532,_53515534,_53515536,_53515538):-freeze(_53515536,'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_53515530,_53515532,_53515534,_53515536,_53515538)).
'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_53515626,_53515644,_53516500,_53516506,_53516512):-hnf(_53515626,_53518830,_53516506,_53518848),'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'(_53518830,_53515644,_53516500,_53518848,_53516512).

'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'(_53519428,_53519430,_53519432,_53519434,_53519436):-freeze(_53519434,freeze(_53519428,'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'(_53519428,_53519430,_53519432,_53519434,_53519436))).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.ConsCall',_53515644,'Prelude.True',_53519972,_53519972).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.ConsPartCall'(_53515860),_53515644,'Prelude.True',_53521170,_53521170).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.FuncCall',_53515644,_53522370,_53522376,_53522382):-hnf(_53515644,_53522370,_53522376,_53522382).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.FuncPartCall'(_53516070),_53515644,_53523498,_53523504,_53523510):-!,hnf(_53515644,_53523498,_53523504,_53523510).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FAIL'(_53524210),_53515644,'FAIL'(_53524210),_53524224,_53524224).

:-costCenters(['']).




%%%%% Number of shared variables: 1

