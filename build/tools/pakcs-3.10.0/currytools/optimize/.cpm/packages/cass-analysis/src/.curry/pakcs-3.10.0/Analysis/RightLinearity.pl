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
'Analysis.RightLinearity.rlinAnalysis'(_13504994,_13504996,_13504998):-freeze(_13504996,'blocked_Analysis.RightLinearity.rlinAnalysis'(_13504994,_13504996,_13504998)).
'blocked_Analysis.RightLinearity.rlinAnalysis'(_13507028,_13507034,_13507040):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^R','^i','^g','^h','^t','^L','^i','^n','^e','^a','^r'],'Prelude.True',partcall(2,'Analysis.RightLinearity.rlFunc',[])),_13507028,_13507034,_13507040).

'Analysis.RightLinearity.rlFunc'(_13511712,_13511714,_13511716,_13511718,_13511720):-freeze(_13511718,'blocked_Analysis.RightLinearity.rlFunc'(_13511712,_13511714,_13511716,_13511718,_13511720)).
'blocked_Analysis.RightLinearity.rlFunc'(_13511808,_13511826,_13512332,_13512338,_13512344):-hnf('Prelude.&&'('Analysis.RightLinearity.hasRightLinearRules'(_13511808),'Prelude.apply'('Prelude.all'(partcall(1,'Prelude.snd',[])),_13511826)),_13512332,_13512338,_13512344).

'Analysis.RightLinearity.showRightLinear'(_13515680,_13515682,_13515684,_13515686,_13515688):-freeze(_13515686,'blocked_Analysis.RightLinearity.showRightLinear'(_13515680,_13515682,_13515684,_13515686,_13515688)).
'blocked_Analysis.RightLinearity.showRightLinear'(_13515776,_13515794,_13523482,_13523488,_13523494):-hnf(_13515794,_13525272,_13523488,_13525290),'blocked_Analysis.RightLinearity.showRightLinear_2'(_13525272,_13515776,_13523482,_13525290,_13523494).

'blocked_Analysis.RightLinearity.showRightLinear_2'(_13525774,_13525776,_13525778,_13525780,_13525782):-freeze(_13525780,'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'(_13525774,_13525776,_13525778,_13525780,_13525782)).
'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'('Prelude.True',_13515776,['^r','^i','^g','^h','^t',^-,'^l','^i','^n','^e','^a','^r'],_13526168,_13526168).
'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'('Prelude.False',_13515776,_13529800,_13529806,_13529812):-!,hnf(_13515776,_13532370,_13529806,_13532382),'blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'(_13532370,_13529800,_13532382,_13529812).

'blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'(_13533020,_13533022,_13533024,_13533026):-freeze(_13533024,'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'(_13533020,_13533022,_13533024,_13533026)).
'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'('Analysis.Types.AText',['^n','^o','^t','^ ','^d','^e','^f','^i','^n','^e','^d','^ ','^b','^y','^ ','^r','^i','^g','^h','^t',^-,'^l','^i','^n','^e','^a','^r','^ ','^r','^u','^l','^e','^s'],_13533500,_13533500).
'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'('Analysis.Types.ANote',[],_13541162,_13541162):-!.
'blocked_blocked_blocked_Analysis.RightLinearity.showRightLinear_2_Prelude.False_1'('FAIL'(_13541770),'FAIL'(_13541770),_13541784,_13541784):-nonvar(_13541770).
'blocked_blocked_Analysis.RightLinearity.showRightLinear_2'('FAIL'(_13541840),_13515776,'FAIL'(_13541840),_13541854,_13541854):-nonvar(_13541840).

'Analysis.RightLinearity.hasRightLinearRules'(_13543680,_13543682,_13543684,_13543686):-freeze(_13543684,'blocked_Analysis.RightLinearity.hasRightLinearRules'(_13543680,_13543682,_13543684,_13543686)).
'blocked_Analysis.RightLinearity.hasRightLinearRules'(_13543766,_13544426,_13544432,_13544438):-hnf(_13543766,_13546352,_13544432,_13546364),'blocked_Analysis.RightLinearity.hasRightLinearRules_1'(_13546352,_13544426,_13546364,_13544438).

'blocked_Analysis.RightLinearity.hasRightLinearRules_1'(_13546864,_13546866,_13546868,_13546870):-freeze(_13546868,'blocked_blocked_Analysis.RightLinearity.hasRightLinearRules_1'(_13546864,_13546866,_13546868,_13546870)).
'blocked_blocked_Analysis.RightLinearity.hasRightLinearRules_1'('FlatCurry.Types.Func'(_13543882,_13543900,_13543918,_13543936,_13543954),_13547380,_13547386,_13547392):-!,hnf('Analysis.RightLinearity.isRightLinearRule'(_13543954),_13547380,_13547386,_13547392).
'blocked_blocked_Analysis.RightLinearity.hasRightLinearRules_1'('FAIL'(_13548572),'FAIL'(_13548572),_13548586,_13548586):-nonvar(_13548572).

'Analysis.RightLinearity.isRightLinearRule'(_13550328,_13550330,_13550332,_13550334):-freeze(_13550332,'blocked_Analysis.RightLinearity.isRightLinearRule'(_13550328,_13550330,_13550332,_13550334)).
'blocked_Analysis.RightLinearity.isRightLinearRule'(_13550414,_13551114,_13551120,_13551126):-hnf(_13550414,_13552968,_13551120,_13552980),'blocked_Analysis.RightLinearity.isRightLinearRule_1'(_13552968,_13551114,_13552980,_13551126).

'blocked_Analysis.RightLinearity.isRightLinearRule_1'(_13553468,_13553470,_13553472,_13553474):-freeze(_13553472,'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'(_13553468,_13553470,_13553472,_13553474)).
'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'('FlatCurry.Types.Rule'(_13550530,_13550548),_13553960,_13553966,_13553972):-hnf('Analysis.RightLinearity.linearExpr'(_13550548),_13553960,_13553966,_13553972).
'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'('FlatCurry.Types.External'(_13550748),'Prelude.True',_13555340,_13555340):-!.
'blocked_blocked_Analysis.RightLinearity.isRightLinearRule_1'('FAIL'(_13555958),'FAIL'(_13555958),_13555972,_13555972):-nonvar(_13555958).

'Analysis.RightLinearity.linearExpr'(_13557448,_13557450,_13557452,_13557454):-freeze(_13557452,'blocked_Analysis.RightLinearity.linearExpr'(_13557448,_13557450,_13557452,_13557454)).
'blocked_Analysis.RightLinearity.linearExpr'(_13557534,_13557970,_13557976,_13557982):-hnf('Prelude.maybe'('Prelude.False',partcall(1,'Prelude.const',['Prelude.True']),'Analysis.RightLinearity.linearVariables'(_13557534)),_13557970,_13557976,_13557982).

'Analysis.RightLinearity.linearVariables'(_13561112,_13561114,_13561116,_13561118):-freeze(_13561116,'blocked_Analysis.RightLinearity.linearVariables'(_13561112,_13561114,_13561116,_13561118)).
'blocked_Analysis.RightLinearity.linearVariables'(_13561198,_13568862,_13568868,_13568874):-hnf(_13561198,_13570644,_13568868,_13570656),'blocked_Analysis.RightLinearity.linearVariables_1'(_13570644,_13568862,_13570656,_13568874).

'blocked_Analysis.RightLinearity.linearVariables_1'(_13571132,_13571134,_13571136,_13571138):-freeze(_13571136,'blocked_blocked_Analysis.RightLinearity.linearVariables_1'(_13571132,_13571134,_13571136,_13571138)).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Var'(_13561314),'Prelude.Just'([_13561314]),_13571610,_13571610).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Lit'(_13561676),'Prelude.Just'([]),_13572910,_13572910).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Comb'(_13561884,_13561902,_13561920),_13580610,_13580616,_13580622):-makeShare(_13561920,_13574274),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_13561902,'Prelude.(,)'(['^P','^r','^e','^l','^u','^d','^e'],[^?])),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude.length'(_13574274),2)),_13583490,_13580616,_13583450),'blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'(_13583490,_13561884,_13561902,_13574274,_13580610,_13583450,_13580622).

'blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'(_13584214,_13584216,_13584218,_13584220,_13584222,_13584224,_13584226):-freeze(_13584224,freeze(_13584214,'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'(_13584214,_13584216,_13584218,_13584220,_13584222,_13584224,_13584226))).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_13561884,_13561902,_13574274,_13584628,_13584634,_13584640):-makeShare(_13574274,_13584746),hnf('Analysis.RightLinearity.linearVariables'('FlatCurry.Types.Or'('Prelude.head'(_13584746),'Prelude.head'('Prelude.tail'(_13584746)))),_13584628,_13584634,_13584640).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_13561884,_13561902,_13574274,_13588620,_13588626,_13588632):-!,hnf('Prelude.otherwise',_13592790,_13588626,_13592750),'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'(_13592790,_13561884,_13561902,_13574274,_13588620,_13592750,_13588632).

'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'(_13593724,_13593726,_13593728,_13593730,_13593732,_13593734,_13593736):-freeze(_13593734,freeze(_13593724,'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'(_13593724,_13593726,_13593728,_13593730,_13593732,_13593734,_13593736))).
'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_13561884,_13561902,_13574274,_13594138,_13594144,_13594150):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.Maybe\'23',[]),partcall(1,'Analysis.RightLinearity.linearVariables',[])),_13574274),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda1',[])),_13594138,_13594144,_13594150).
'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_13561884,_13561902,_13574274,_13597596,_13597602,_13597608):-!,hnf(reportFailure4PAKCS('Analysis.RightLinearity.linearVariables',['Prelude.False']),_13597596,_13597602,_13597608).
'blocked_blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_13599622),_13561884,_13561902,_13574274,'FAIL'(_13599622),_13599636,_13599636).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables_1_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_13599712),_13561884,_13561902,_13574274,'FAIL'(_13599712),_13599726,_13599726).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Free'(_13566076,_13566094),_13600214,_13600220,_13600226):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_13566094),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda2',[_13566076])),_13600214,_13600220,_13600226).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Let'(_13566532,_13566550),_13602554,_13602560,_13602566):-makeShare(_13566532,_13602680),hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.Maybe\'23',[]),partcall(1,'Analysis.RightLinearity.linearVariables',[])),'Prelude.apply'('FlatCurry.Types.expsOfLetBind',_13602680)),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda3',[_13602680,_13566550])),_13602554,_13602560,_13602566).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Or'(_13567478,_13567496),_13606462,_13606468,_13606474):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_13567478),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda5',[_13567496])),_13606462,_13606468,_13606474).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Case'(_13567934,_13567952,_13567970),_13608822,_13608828,_13608834):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_13567952),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7',[_13567970])),_13608822,_13608828,_13608834).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FlatCurry.Types.Typed'(_13568414,_13568432),_13611252,_13611258,_13611264):-!,hnf('Analysis.RightLinearity.linearVariables'(_13568414),_13611252,_13611258,_13611264).
'blocked_blocked_Analysis.RightLinearity.linearVariables_1'('FAIL'(_13612210),'FAIL'(_13612210),_13612224,_13612224):-nonvar(_13612210).

'Analysis.RightLinearity.linearVariables._\'23lambda1'(_13614298,_13614300,_13614302,_13614304):-freeze(_13614302,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1'(_13614298,_13614300,_13614302,_13614304)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1'(_13614384,_13615470,_13615476,_13615482):-makeShare(_13614412,_13615626),hnf('Prelude.cond'(letrec4PAKCS(_13615626,'Prelude.apply'('Prelude.concat',_13614384)),'Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13615626),_13615626),_13615626)),_13615470,_13615476,_13615482).

'Analysis.RightLinearity.linearVariables._\'23lambda2'(_13621342,_13621344,_13621346,_13621348,_13621350):-freeze(_13621348,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda2'(_13621342,_13621344,_13621346,_13621348,_13621350)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda2'(_13621438,_13621456,'Prelude.Just'('Data.List.\'5C\'5C'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13621456,'Prelude.map'(partcall(1,'Prelude.fst',[]),_13621438))),_13621968,_13621968).

'Analysis.RightLinearity.linearVariables._\'23lambda3'(_13625798,_13625800,_13625802,_13625804,_13625806,_13625808):-freeze(_13625806,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3'(_13625798,_13625800,_13625802,_13625804,_13625806,_13625808)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3'(_13625904,_13625922,_13625940,_13626348,_13626354,_13626360):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_13625904),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4',[_13625922,_13625940])),_13626348,_13626354,_13626360).

'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4'(_13631000,_13631002,_13631004,_13631006,_13631008,_13631010):-freeze(_13631008,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4'(_13631000,_13631002,_13631004,_13631006,_13631008,_13631010)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4'(_13631106,_13631124,_13631142,_13632452,_13632458,_13632464):-makeShare(_13631170,_13632714),hnf('Prelude.cond'(letrec4PAKCS(_13632714,'Prelude.apply'('Prelude.concat',[_13631142|_13631106])),'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13632714),_13632714),_13632714,_13631124)),_13632452,_13632458,_13632464).

'Analysis.RightLinearity.linearVariables._\'23lambda5'(_13638982,_13638984,_13638986,_13638988,_13638990):-freeze(_13638988,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5'(_13638982,_13638984,_13638986,_13638988,_13638990)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5'(_13639078,_13639096,_13639434,_13639440,_13639446):-hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Analysis.RightLinearity.linearVariables'(_13639078),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6',[_13639096])),_13639434,_13639440,_13639446).

'Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6'(_13643892,_13643894,_13643896,_13643898,_13643900):-freeze(_13643898,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6'(_13643892,_13643894,_13643896,_13643898,_13643900)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda5._\'23lambda6'(_13643988,_13644006,'Prelude.Just'('Data.List.union'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13643988,_13644006)),_13644350,_13644350).

'Analysis.RightLinearity.linearVariables.patternVars.52'(_13648054,_13648056,_13648058,_13648060):-freeze(_13648058,'blocked_Analysis.RightLinearity.linearVariables.patternVars.52'(_13648054,_13648056,_13648058,_13648060)).
'blocked_Analysis.RightLinearity.linearVariables.patternVars.52'(_13648140,_13648986,_13648992,_13648998):-hnf(_13648140,_13651308,_13648992,_13651320),'blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'(_13651308,_13648986,_13651320,_13648998).

'blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'(_13651886,_13651888,_13651890,_13651892):-freeze(_13651890,'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'(_13651886,_13651888,_13651890,_13651892)).
'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'('FlatCurry.Types.Branch'(_13648256,_13648274),_13652864,_13652870,_13652876):-!,hnf(_13648256,_13656236,_13652870,_13656254),'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'(_13656236,_13648274,_13652864,_13656254,_13652876).

'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'(_13657044,_13657046,_13657048,_13657050,_13657052):-freeze(_13657050,'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'(_13657044,_13657046,_13657048,_13657050,_13657052)).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'('FlatCurry.Types.Pattern'(_13648402,_13648420),_13648274,_13657582,_13657588,_13657594):-hnf(_13648420,_13657582,_13657588,_13657594).
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'('FlatCurry.Types.LPattern'(_13648536),_13648274,[],_13658998,_13658998):-!.
'blocked_blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1_FlatCurry.Types.Branch_1'('FAIL'(_13659890),_13648274,'FAIL'(_13659890),_13659904,_13659904):-nonvar(_13659890).
'blocked_blocked_Analysis.RightLinearity.linearVariables.patternVars.52_1'('FAIL'(_13659968),'FAIL'(_13659968),_13659982,_13659982):-nonvar(_13659968).

'Analysis.RightLinearity.linearVariables._\'23lambda7'(_13662056,_13662058,_13662060,_13662062,_13662064):-freeze(_13662062,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7'(_13662056,_13662058,_13662060,_13662062,_13662064)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7'(_13662152,_13662170,_13662998,_13663004,_13663010):-makeShare(_13662152,_13663132),hnf('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.Maybe\'23'('Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.Maybe\'23',[]),partcall(1,'Analysis.RightLinearity.linearVariables',[])),'Prelude.map'(partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8',[]),_13663132)),partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9',[_13662170,_13663132])),_13662998,_13663004,_13663010).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8'(_13669232,_13669234,_13669236,_13669238):-freeze(_13669236,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8'(_13669232,_13669234,_13669236,_13669238)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8'(_13669318,_13669942,_13669948,_13669954):-hnf(_13669318,_13672588,_13669948,_13672600),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'(_13672588,_13669942,_13672600,_13669954).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'(_13673220,_13673222,_13673224,_13673226):-freeze(_13673224,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'(_13673220,_13673222,_13673224,_13673226)).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'('FlatCurry.Types.Branch'(_13669434,_13669452),_13673736,_13673742,_13673748):-!,hnf(_13669452,_13673736,_13673742,_13673748).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda8_1'('FAIL'(_13674494),'FAIL'(_13674494),_13674508,_13674508):-nonvar(_13674494).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9'(_13676990,_13676992,_13676994,_13676996,_13676998,_13677000):-freeze(_13676998,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9'(_13676990,_13676992,_13676994,_13676996,_13676998,_13677000)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9'(_13677096,_13677114,_13677132,_13678862,_13678868,_13678874):-makeShare(_13677160,_13679134),hnf('Prelude.cond'(letrec4PAKCS(_13679134,'Prelude.++'('Prelude.foldr'(partcall(2,'Data.List.union',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[])]),[],'Prelude.map'(partcall(1,'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10',[]),'Prelude.zip'(_13677096,_13677132))),_13677114)),'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13679134),_13679134),_13679134)),_13678862,_13678868,_13678874).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10'(_13687782,_13687784,_13687786,_13687788):-freeze(_13687786,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10'(_13687782,_13687784,_13687786,_13687788)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10'(_13687868,_13688892,_13688898,_13688904):-hnf(_13687868,_13692006,_13688898,_13692018),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'(_13692006,_13688892,_13692018,_13688904).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'(_13692716,_13692718,_13692720,_13692722):-freeze(_13692720,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'(_13692716,_13692718,_13692720,_13692722)).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'('Prelude.(,)'(_13687984,_13688002),_13693086,_13693092,_13693098):-!,hnf('Data.List.\'5C\'5C'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13688002,'Analysis.RightLinearity.linearVariables.patternVars.52'(_13687984)),_13693086,_13693092,_13693098).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23lambda10_1'('FAIL'(_13695040),'FAIL'(_13695040),_13695054,_13695054):-nonvar(_13695040).

'Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'(_13697536,_13697538,_13697540,_13697542,_13697544):-freeze(_13697542,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'(_13697536,_13697538,_13697540,_13697542,_13697544)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0'(_13697632,_13697650,_13698410,_13698416,_13698422):-hnf(_13697632,_13701064,_13698416,_13701082),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'(_13701064,_13697650,_13698410,_13701082,_13698422).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'(_13701716,_13701718,_13701720,_13701722,_13701724):-freeze(_13701722,freeze(_13701716,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'(_13701716,_13701718,_13701720,_13701722,_13701724))).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'('Prelude.True',_13697650,'Prelude.Just'(_13697650),_13702116,_13702116).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'('Prelude.False',_13697650,'Prelude.Nothing',_13703272,_13703272):-!.
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda1._\'23caseor0_1'('FAIL'(_13704048),_13697650,'FAIL'(_13704048),_13704062,_13704062).

'Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'(_13706956,_13706958,_13706960,_13706962,_13706964,_13706966):-freeze(_13706964,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'(_13706956,_13706958,_13706960,_13706962,_13706964,_13706966)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0'(_13707062,_13707080,_13707098,_13708336,_13708342,_13708348):-hnf(_13707062,_13711430,_13708342,_13711454),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'(_13711430,_13707080,_13707098,_13708336,_13711454,_13708348).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'(_13712168,_13712170,_13712172,_13712174,_13712176,_13712178):-freeze(_13712176,freeze(_13712168,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'(_13712168,_13712170,_13712172,_13712174,_13712176,_13712178))).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'('Prelude.True',_13707080,_13707098,'Prelude.Just'('Data.List.\'5C\'5C'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_13707080,'Prelude.apply'('FlatCurry.Types.varsOfLetBind',_13707098))),_13712578,_13712578).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'('Prelude.False',_13707080,_13707098,'Prelude.Nothing',_13715034,_13715034):-!.
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda3._\'23lambda4._\'23caseor0_1'('FAIL'(_13715956),_13707080,_13707098,'FAIL'(_13715956),_13715970,_13715970).

'Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'(_13718872,_13718874,_13718876,_13718878,_13718880):-freeze(_13718878,'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'(_13718872,_13718874,_13718876,_13718878,_13718880)).
'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0'(_13718968,_13718986,_13719818,_13719824,_13719830):-hnf(_13718968,_13722904,_13719824,_13722922),'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'(_13722904,_13718986,_13719818,_13722922,_13719830).

'blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'(_13723628,_13723630,_13723632,_13723634,_13723636):-freeze(_13723634,freeze(_13723628,'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'(_13723628,_13723630,_13723632,_13723634,_13723636))).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'('Prelude.True',_13718986,'Prelude.Just'(_13718986),_13724028,_13724028).
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'('Prelude.False',_13718986,'Prelude.Nothing',_13725256,_13725256):-!.
'blocked_blocked_Analysis.RightLinearity.linearVariables._\'23lambda7._\'23lambda9._\'23caseor0_1'('FAIL'(_13726104),_13718986,'FAIL'(_13726104),_13726118,_13726118).

:-costCenters(['']).




%%%%% Number of shared variables: 7

