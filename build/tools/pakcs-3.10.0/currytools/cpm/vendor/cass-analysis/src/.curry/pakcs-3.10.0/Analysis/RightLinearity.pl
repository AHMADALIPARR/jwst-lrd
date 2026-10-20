%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.Types').
:-importModule('Data.List').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.RightLinearity').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.RightLinearity.rlinAnalysis',rlinAnalysis,0,'Analysis.RightLinearity.rlinAnalysis',nofix,notype).
functiontype('Analysis.RightLinearity.rlFunc','Analysis.RightLinearity.rlFunc',2,'Analysis.RightLinearity.rlFunc',nofix,notype).
functiontype('Analysis.RightLinearity.showRightLinear',showRightLinear,2,'Analysis.RightLinearity.showRightLinear',nofix,notype).
functiontype('Analysis.RightLinearity.hasRightLinearRules',hasRightLinearRules,1,'Analysis.RightLinearity.hasRightLinearRules',nofix,notype).
functiontype('Analysis.RightLinearity.isRightLinearRule','Analysis.RightLinearity.isRightLinearRule',1,'Analysis.RightLinearity.isRightLinearRule',nofix,notype).
functiontype('Analysis.RightLinearity.linearExpr',linearExpr,1,'Analysis.RightLinearity.linearExpr',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables','Analysis.RightLinearity.linearVariables',1,'Analysis.RightLinearity.linearVariables',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda1','Analysis.RightLinearity.linearVariables._#lambda1',1,'Analysis.RightLinearity.linearVariables._\'23lambda1',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda2','Analysis.RightLinearity.linearVariables._#lambda2',2,'Analysis.RightLinearity.linearVariables._\'23lambda2',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda3','Analysis.RightLinearity.linearVariables._#lambda3',3,'Analysis.RightLinearity.linearVariables._\'23lambda3',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4','Analysis.RightLinearity.linearVariables._#lambda3._#lambda4',3,'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda5','Analysis.RightLinearity.linearVariables._#lambda5',2,'Analysis.RightLinearity.linearVariables._\'23lambda5',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6','Analysis.RightLinearity.linearVariables._#lambda5._#lambda6',2,'Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables.patternVars.52','Analysis.RightLinearity.linearVariables.patternVars.52',1,'Analysis.RightLinearity.linearVariables.patternVars.52',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda7','Analysis.RightLinearity.linearVariables._#lambda7',2,'Analysis.RightLinearity.linearVariables._\'23lambda7',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8','Analysis.RightLinearity.linearVariables._#lambda7._#lambda8',1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9','Analysis.RightLinearity.linearVariables._#lambda7._#lambda9',3,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10','Analysis.RightLinearity.linearVariables._#lambda7._#lambda9._#lambda10',1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0','Analysis.RightLinearity.linearVariables._#lambda1._#caseor0',2,'Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0','Analysis.RightLinearity.linearVariables._#lambda3._#lambda4._#caseor0',3,'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0',nofix,notype).
functiontype('Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0','Analysis.RightLinearity.linearVariables._#lambda7._#lambda9._#caseor0',2,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.RightLinearity.rlinAnalysis'(_40311442,_40311444,_40311446):-freeze(_40311444,'blocked_Analysis.RightLinearity.rlinAnalysis'(_40311442,_40311444,_40311446)).
'blocked_Analysis.RightLinearity.rlinAnalysis'(_40313476,_40313482,_40313488):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^R','^i','^g','^h','^t','^L','^i','^n','^e','^a','^r'],'Prelude.True',partcall(2,'Analysis.RightLinearity.rlFunc',[])),_40313476,_40313482,_40313488).

'Analysis.RightLinearity.rlFunc'(_40318160,_40318162,_40318164,_40318166,_40318168):-freeze(_40318166,'blocked_Analysis.RightLinearity.rlFunc'(_40318160,_40318162,_40318164,_40318166,_40318168)).
'blocked_Analysis.RightLinearity.rlFunc'(_40318256,_40318274,_40318780,_40318786,_40318792):-hnf('Prelude.&&'('Analysis.RightLinearity.hasRightLinearRules'(_40318256),'Prelude.apply'('Prelude.all'(partcall(1,'Prelude.snd',[])),_40318274)),_40318780,_40318786,_40318792).

'Analysis.RightLinearity.showRightLinear'(_40322128,_40322130,_40322132,_40322134,_40322136):-freeze(_40322134,'blocked_Analysis.RightLinearity.showRightLinear'(_40322128,_40322130,_40322132,_40322134,_40322136)).
'blocked_Analysis.RightLinearity.showRightLinear'(_40322224,_40322242,_40329930,_40329936,_40329942):-hnf(_40322242,_40331720,_40329936,_40331738),'blocked_Analysis.RightLinearity.showRightLinear_2'(_40331720,_40322224,_40329930,_40331738,_40329942).

'blocked_Analysis.RightLinearity.showRightLinear_2'(_40332222,_40332224,_40332226,_40332228,_40332230):-freeze(_40332228,'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'(_40332222,_40332224,_40332226,_40332228,_40332230)).
'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'('Prelude.True',_40322224,['^r','^i','^g','^h','^t',^-,'^l','^i','^n','^e','^a','^r'],_40332616,_40332616).
'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'('Prelude.False',_40322224,_40336248,_40336254,_40336260):-!,hnf(_40322224,_40338818,_40336254,_40338830),'blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'(_40338818,_40336248,_40338830,_40336260).

'blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'(_40339468,_40339470,_40339472,_40339474):-freeze(_40339472,'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'(_40339468,_40339470,_40339472,_40339474)).
'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'('Analysis.Types.AText',['^n','^o','^t','^ ','^d','^e','^f','^i','^n','^e','^d','^ ','^b','^y','^ ','^r','^i','^g','^h','^t',^-,'^l','^i','^n','^e','^a','^r','^ ','^r','^u','^l','^e','^s'],_40339948,_40339948).
'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'('Analysis.Types.ANote',[],_40347610,_40347610):-!.
'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'('FAIL'(_40348218),'FAIL'(_40348218),_40348232,_40348232):-nonvar(_40348218).
'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'('FAIL'(_40348288),_40322224,'FAIL'(_40348288),_40348302,_40348302):-nonvar(_40348288).

'Analysis.RightLinearity.hasRightLinearRules'(_40350128,_40350130,_40350132,_40350134):-freeze(_40350132,'blocked_Analysis.RightLinearity.hasRightLinearRules'(_40350128,_40350130,_40350132,_40350134)).
'blocked_Analysis.RightLinearity.hasRightLinearRules'(_40350214,_40350874,_40350880,_40350886):-hnf(_40350214,_40352800,_40350880,_40352812),'blocked_Analysis.RightLinearity.hasRightLinearRules_1'(_40352800,_40350874,_40352812,_40350886).

'blocked_Analysis.RightLinearity.hasRightLinearRules_1'(_40353312,_40353314,_40353316,_40353318):-freeze(_40353316,'blocked_blocked_Analysis.RightLinearity.hasRightLinearRules_1'(_40353312,_40353314,_40353316,_40353318)).
'blocked_blocked_Analysis.RightLinearity.hasRightLinearRules_1'('FlatCurry.Types.Func'(_40350330,_40350348,_40350366,_40350384,_40350402),_40353828,_40353834,_40353840):-!,hnf('Analysis.RightLinearity.isRightLinearRule'(_40350402),_40353828,_40353834,_40353840).
'blocked_blocked_Analysis.RightLinearity.hasRightLinearRules_1'('FAIL'(_40355020),'FAIL'(_40355020),_40355034,_40355034):-nonvar(_40355020).

'Analysis.RightLinearity.isRightLinearRule'(_40356776,_40356778,_40356780,_40356782):-freeze(_40356780,'blocked_Analysis.RightLinearity.isRightLinearRule'(_40356776,_40356778,_40356780,_40356782)).
'blocked_Analysis.RightLinearity.isRightLinearRule'(_40356862,_40357562,_40357568,_40357574):-hnf(_40356862,_40359416,_40357568,_40359428),'blocked_Analysis.RightLinearity.isRightLinearRule_1'(_40359416,_40357562,_40359428,_40357574).

'blocked_Analysis.RightLinearity.isRightLinearRule_1'(_40359916,_40359918,_40359920,_40359922):-freeze(_40359920,'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'(_40359916,_40359918,_40359920,_40359922)).
'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'('FlatCurry.Types.Rule'(_40356978,_40356996),_40360408,_40360414,_40360420):-hnf('Analysis.RightLinearity.linearExpr'(_40356996),_40360408,_40360414,_40360420).
'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'('FlatCurry.Types.External'(_40357196),'Prelude.True',_40361788,_40361788):-!.
'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'('FAIL'(_40362406),'FAIL'(_40362406),_40362420,_40362420):-nonvar(_40362406).

'Analysis.RightLinearity.linearExpr'(_40363896,_40363898,_40363900,_40363902):-freeze(_40363900,'blocked_Analysis.RightLinearity.linearExpr'(_40363896,_40363898,_40363900,_40363902)).
'blocked_Analysis.RightLinearity.linearExpr'(_40363982,_40364418,_40364424,_40364430):-hnf('Prelude.maybe'('Prelude.False',partcall(1,'Prelude.const',['Prelude.True']),'Analysis.RightLinearity.linearVariables'(_40363982)),_40364418,_40364424,_40364430).

'Analysis.RightLinearity.linearVariables'(_40367560,_40367562,_40367564,_40367566):-freeze(_40367564,'blocked_Analysis.RightLinearity.linearVariables'(_40367560,_40367562,_40367564,_40367566)).
'blocked_Analysis.RightLinearity.linearVariables'(_40367646,_40375310,_40375316,_40375322):-hnf(_40367646,_40377092,_40375316,_40377104),'blocked_Analysis.RightLinearity.linearVariables_1'(_40377092,_40375310,_40377104,_40375322).

'blocked_Analysis.RightLinearity.linearVariables_1'(_40377580,_40377582,_40377584,_40377586):-freeze(_40377584,'blocked_blocked_Analysis.RightLinearity.linearVariables_1'(_40377580,_40377582,_40377584,_40377586)).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Var'(_40367762),'Prelude.Just'([_40367762]),_40378058,_40378058).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Lit'(_40368124),'Prelude.Just'([]),_40379358,_40379358).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Comb'(_40368332,_40368350,_40368368),_40387058,_40387064,_40387070):-makeShare(_40368368,_40380722),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_40368350,'Prelude.(,)'(['^P','^r','^e','^l','^u','^d','^e'],[^?])),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude.length'(_40380722),2)),_40389938,_40387064,_40389898),'blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'(_40389938,_40368332,_40368350,_40380722,_40387058,_40389898,_40387070).

'blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'(_40390662,_40390664,_40390666,_40390668,_40390670,_40390672,_40390674):-freeze(_40390672,freeze(_40390662,'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'(_40390662,_40390664,_40390666,_40390668,_40390670,_40390672,_40390674))).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_40368332,_40368350,_40380722,_40391076,_40391082,_40391088):-makeShare(_40380722,_40391194),hnf('Analysis.RightLinearity.linearVariables'('FlatCurry.Types.Or'('Prelude.head'(_40391194),'Prelude.head'('Prelude.tail'(_40391194)))),_40391076,_40391082,_40391088).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_40368332,_40368350,_40380722,_40395068,_40395074,_40395080):-!,hnf('Prelude.otherwise',_40399238,_40395074,_40399198),'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'(_40399238,_40368332,_40368350,_40380722,_40395068,_40399198,_40395080).

'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'(_40400172,_40400174,_40400176,_40400178,_40400180,_40400182,_40400184):-freeze(_40400182,freeze(_40400172,'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'(_40400172,_40400174,_40400176,_40400178,_40400180,_40400182,_40400184))).
'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_40368332,_40368350,_40380722,_40400586,_40400592,_40400598):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.Maybe\'23',[]),partcall(1,'Analysis.RightLinearity.linearVariables',[])),_40380722),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda1',[])),_40400586,_40400592,_40400598).
'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_40368332,_40368350,_40380722,_40404044,_40404050,_40404056):-!,hnf(reportFailure4PAKCS('Analysis.RightLinearity.linearVariables',['Prelude.False']),_40404044,_40404050,_40404056).
'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_40406070),_40368332,_40368350,_40380722,'FAIL'(_40406070),_40406084,_40406084).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_40406160),_40368332,_40368350,_40380722,'FAIL'(_40406160),_40406174,_40406174).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Free'(_40372524,_40372542),_40406662,_40406668,_40406674):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_40372542),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda2',[_40372524])),_40406662,_40406668,_40406674).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Let'(_40372980,_40372998),_40409002,_40409008,_40409014):-makeShare(_40372980,_40409128),hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.Maybe\'23',[]),partcall(1,'Analysis.RightLinearity.linearVariables',[])),'Prelude.apply'('FlatCurry.Types.expsOfLetBind',_40409128)),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda3',[_40409128,_40372998])),_40409002,_40409008,_40409014).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Or'(_40373926,_40373944),_40412910,_40412916,_40412922):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_40373926),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda5',[_40373944])),_40412910,_40412916,_40412922).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Case'(_40374382,_40374400,_40374418),_40415270,_40415276,_40415282):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_40374400),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7',[_40374418])),_40415270,_40415276,_40415282).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Typed'(_40374862,_40374880),_40417700,_40417706,_40417712):-!,hnf('Analysis.RightLinearity.linearVariables'(_40374862),_40417700,_40417706,_40417712).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FAIL'(_40418658),'FAIL'(_40418658),_40418672,_40418672):-nonvar(_40418658).

'Analysis.RightLinearity.linearVariables._\'23lambda1'(_40420746,_40420748,_40420750,_40420752):-freeze(_40420750,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1'(_40420746,_40420748,_40420750,_40420752)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1'(_40420832,_40421918,_40421924,_40421930):-makeShare(_40420860,_40422074),hnf('Prelude.cond'(letrec4PAKCS(_40422074,'Prelude.apply'('Prelude.concat',_40420832)),'Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40422074),_40422074),_40422074)),_40421918,_40421924,_40421930).

'Analysis.RightLinearity.linearVariables._\'23lambda2'(_40427790,_40427792,_40427794,_40427796,_40427798):-freeze(_40427796,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda2'(_40427790,_40427792,_40427794,_40427796,_40427798)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda2'(_40427886,_40427904,'Prelude.Just'('Data.List.\'5C\'5C'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40427904,'Prelude.map'(partcall(1,'Prelude.fst',[]),_40427886))),_40428416,_40428416).

'Analysis.RightLinearity.linearVariables._\'23lambda3'(_40432246,_40432248,_40432250,_40432252,_40432254,_40432256):-freeze(_40432254,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3'(_40432246,_40432248,_40432250,_40432252,_40432254,_40432256)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3'(_40432352,_40432370,_40432388,_40432796,_40432802,_40432808):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_40432352),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4',[_40432370,_40432388])),_40432796,_40432802,_40432808).

'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4'(_40437448,_40437450,_40437452,_40437454,_40437456,_40437458):-freeze(_40437456,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4'(_40437448,_40437450,_40437452,_40437454,_40437456,_40437458)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4'(_40437554,_40437572,_40437590,_40438900,_40438906,_40438912):-makeShare(_40437618,_40439162),hnf('Prelude.cond'(letrec4PAKCS(_40439162,'Prelude.apply'('Prelude.concat',[_40437590|_40437554])),'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40439162),_40439162),_40439162,_40437572)),_40438900,_40438906,_40438912).

'Analysis.RightLinearity.linearVariables._\'23lambda5'(_40445430,_40445432,_40445434,_40445436,_40445438):-freeze(_40445436,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5'(_40445430,_40445432,_40445434,_40445436,_40445438)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5'(_40445526,_40445544,_40445882,_40445888,_40445894):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_40445526),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6',[_40445544])),_40445882,_40445888,_40445894).

'Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6'(_40450340,_40450342,_40450344,_40450346,_40450348):-freeze(_40450346,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6'(_40450340,_40450342,_40450344,_40450346,_40450348)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6'(_40450436,_40450454,'Prelude.Just'('Data.List.union'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40450436,_40450454)),_40450798,_40450798).

'Analysis.RightLinearity.linearVariables.patternVars.52'(_40454502,_40454504,_40454506,_40454508):-freeze(_40454506,'blocked_Analysis.RightLinearity.linearVariables.patternVars.52'(_40454502,_40454504,_40454506,_40454508)).
'blocked_Analysis.RightLinearity.linearVariables.patternVars.52'(_40454588,_40455434,_40455440,_40455446):-hnf(_40454588,_40457756,_40455440,_40457768),'blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'(_40457756,_40455434,_40457768,_40455446).

'blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'(_40458334,_40458336,_40458338,_40458340):-freeze(_40458338,'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'(_40458334,_40458336,_40458338,_40458340)).
'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'('FlatCurry.Types.Branch'(_40454704,_40454722),_40459312,_40459318,_40459324):-!,hnf(_40454704,_40462684,_40459318,_40462702),'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'(_40462684,_40454722,_40459312,_40462702,_40459324).

'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'(_40463492,_40463494,_40463496,_40463498,_40463500):-freeze(_40463498,'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'(_40463492,_40463494,_40463496,_40463498,_40463500)).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'('FlatCurry.Types.Pattern'(_40454850,_40454868),_40454722,_40464030,_40464036,_40464042):-hnf(_40454868,_40464030,_40464036,_40464042).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'('FlatCurry.Types.LPattern'(_40454984),_40454722,[],_40465446,_40465446):-!.
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'('FAIL'(_40466338),_40454722,'FAIL'(_40466338),_40466352,_40466352):-nonvar(_40466338).
'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'('FAIL'(_40466416),'FAIL'(_40466416),_40466430,_40466430):-nonvar(_40466416).

'Analysis.RightLinearity.linearVariables._\'23lambda7'(_40468504,_40468506,_40468508,_40468510,_40468512):-freeze(_40468510,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7'(_40468504,_40468506,_40468508,_40468510,_40468512)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7'(_40468600,_40468618,_40469446,_40469452,_40469458):-makeShare(_40468600,_40469580),hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.Maybe\'23',[]),partcall(1,'Analysis.RightLinearity.linearVariables',[])),'Prelude.map'(partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8',[]),_40469580)),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9',[_40468618,_40469580])),_40469446,_40469452,_40469458).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8'(_40475680,_40475682,_40475684,_40475686):-freeze(_40475684,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8'(_40475680,_40475682,_40475684,_40475686)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8'(_40475766,_40476390,_40476396,_40476402):-hnf(_40475766,_40479036,_40476396,_40479048),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'(_40479036,_40476390,_40479048,_40476402).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'(_40479668,_40479670,_40479672,_40479674):-freeze(_40479672,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'(_40479668,_40479670,_40479672,_40479674)).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'('FlatCurry.Types.Branch'(_40475882,_40475900),_40480184,_40480190,_40480196):-!,hnf(_40475900,_40480184,_40480190,_40480196).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'('FAIL'(_40480942),'FAIL'(_40480942),_40480956,_40480956):-nonvar(_40480942).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9'(_40483438,_40483440,_40483442,_40483444,_40483446,_40483448):-freeze(_40483446,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9'(_40483438,_40483440,_40483442,_40483444,_40483446,_40483448)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9'(_40483544,_40483562,_40483580,_40485310,_40485316,_40485322):-makeShare(_40483608,_40485582),hnf('Prelude.cond'(letrec4PAKCS(_40485582,'Prelude.++'('Prelude.foldr'(partcall(2,'Data.List.union',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[])]),[],'Prelude.map'(partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10',[]),'Prelude.zip'(_40483544,_40483580))),_40483562)),'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40485582),_40485582),_40485582)),_40485310,_40485316,_40485322).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10'(_40494230,_40494232,_40494234,_40494236):-freeze(_40494234,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10'(_40494230,_40494232,_40494234,_40494236)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10'(_40494316,_40495340,_40495346,_40495352):-hnf(_40494316,_40498454,_40495346,_40498466),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'(_40498454,_40495340,_40498466,_40495352).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'(_40499164,_40499166,_40499168,_40499170):-freeze(_40499168,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'(_40499164,_40499166,_40499168,_40499170)).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'('Prelude.(,)'(_40494432,_40494450),_40499534,_40499540,_40499546):-!,hnf('Data.List.\'5C\'5C'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40494450,'Analysis.RightLinearity.linearVariables.patternVars.52'(_40494432)),_40499534,_40499540,_40499546).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'('FAIL'(_40501488),'FAIL'(_40501488),_40501502,_40501502):-nonvar(_40501488).

'Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'(_40503984,_40503986,_40503988,_40503990,_40503992):-freeze(_40503990,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'(_40503984,_40503986,_40503988,_40503990,_40503992)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'(_40504080,_40504098,_40504858,_40504864,_40504870):-hnf(_40504080,_40507512,_40504864,_40507530),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'(_40507512,_40504098,_40504858,_40507530,_40504870).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'(_40508164,_40508166,_40508168,_40508170,_40508172):-freeze(_40508170,freeze(_40508164,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'(_40508164,_40508166,_40508168,_40508170,_40508172))).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'('Prelude.True',_40504098,'Prelude.Just'(_40504098),_40508564,_40508564).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'('Prelude.False',_40504098,'Prelude.Nothing',_40509720,_40509720):-!.
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'('FAIL'(_40510496),_40504098,'FAIL'(_40510496),_40510510,_40510510).

'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'(_40513404,_40513406,_40513408,_40513410,_40513412,_40513414):-freeze(_40513412,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'(_40513404,_40513406,_40513408,_40513410,_40513412,_40513414)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'(_40513510,_40513528,_40513546,_40514784,_40514790,_40514796):-hnf(_40513510,_40517878,_40514790,_40517902),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'(_40517878,_40513528,_40513546,_40514784,_40517902,_40514796).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'(_40518616,_40518618,_40518620,_40518622,_40518624,_40518626):-freeze(_40518624,freeze(_40518616,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'(_40518616,_40518618,_40518620,_40518622,_40518624,_40518626))).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'('Prelude.True',_40513528,_40513546,'Prelude.Just'('Data.List.\'5C\'5C'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_40513528,'Prelude.apply'('FlatCurry.Types.varsOfLetBind',_40513546))),_40519026,_40519026).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'('Prelude.False',_40513528,_40513546,'Prelude.Nothing',_40521482,_40521482):-!.
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'('FAIL'(_40522404),_40513528,_40513546,'FAIL'(_40522404),_40522418,_40522418).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'(_40525320,_40525322,_40525324,_40525326,_40525328):-freeze(_40525326,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'(_40525320,_40525322,_40525324,_40525326,_40525328)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'(_40525416,_40525434,_40526266,_40526272,_40526278):-hnf(_40525416,_40529352,_40526272,_40529370),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'(_40529352,_40525434,_40526266,_40529370,_40526278).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'(_40530076,_40530078,_40530080,_40530082,_40530084):-freeze(_40530082,freeze(_40530076,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'(_40530076,_40530078,_40530080,_40530082,_40530084))).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'('Prelude.True',_40525434,'Prelude.Just'(_40525434),_40530476,_40530476).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'('Prelude.False',_40525434,'Prelude.Nothing',_40531704,_40531704):-!.
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'('FAIL'(_40532552),_40525434,'FAIL'(_40532552),_40532566,_40532566).

:-costCenters(['']).




%%%%% Number of shared variables: 7

