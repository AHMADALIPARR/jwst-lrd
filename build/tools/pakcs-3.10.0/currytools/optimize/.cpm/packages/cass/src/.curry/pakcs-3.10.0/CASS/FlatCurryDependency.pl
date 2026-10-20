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
'CASS.FlatCurryDependency.dependsDirectlyOnTypes'(_24341706,_24341708,_24341710,_24341712):-freeze(_24341710,'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes'(_24341706,_24341708,_24341710,_24341712)).
'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes'(_24341792,_24344840,_24344846,_24344852):-hnf(_24341792,_24346910,_24344846,_24346922),'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'(_24346910,_24344840,_24346922,_24344852).

'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'(_24347446,_24347448,_24347450,_24347452):-freeze(_24347450,'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'(_24347446,_24347448,_24347450,_24347452)).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FlatCurry.Types.Type'(_24341908,_24341926,_24341944,_24341962),_24347954,_24347960,_24347966):-hnf('Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),'Prelude.apply'('Prelude.concatMap'(partcall(1,'CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1',[])),_24341962)),_24347954,_24347960,_24347966).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FlatCurry.Types.TypeSyn'(_24342846,_24342864,_24342882,_24342900),_24352242,_24352248,_24352254):-hnf('Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),'CASS.FlatCurryDependency.tconsOf'(_24342900)),_24352242,_24352248,_24352254).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FlatCurry.Types.TypeNew'(_24343616,_24343634,_24343652,_24343670),_24356410,_24356416,_24356422):-!,hnf(_24343670,_24359560,_24356416,_24359590),'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'(_24359560,_24343616,_24343634,_24343652,_24356410,_24359590,_24356422).

'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'(_24360360,_24360362,_24360364,_24360366,_24360368,_24360370,_24360372):-freeze(_24360370,'blocked_blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'(_24360360,_24360362,_24360364,_24360366,_24360368,_24360370,_24360372)).
'blocked_blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'('FlatCurry.Types.NewCons'(_24343810,_24343828,_24343846),_24343616,_24343634,_24343652,_24360926,_24360932,_24360938):-!,hnf('Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),'CASS.FlatCurryDependency.tconsOf'(_24343846)),_24360926,_24360932,_24360938).
'blocked_blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1_FlatCurry.Types.TypeNew_4'('FAIL'(_24364564),_24343616,_24343634,_24343652,'FAIL'(_24364564),_24364578,_24364578):-nonvar(_24364564).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes_1'('FAIL'(_24364658),'FAIL'(_24364658),_24364672,_24364672):-nonvar(_24364658).

'CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1'(_24367050,_24367052,_24367054,_24367056):-freeze(_24367054,'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1'(_24367050,_24367052,_24367054,_24367056)).
'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1'(_24367136,_24368036,_24368042,_24368048):-hnf(_24367136,_24370538,_24368042,_24370550),'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'(_24370538,_24368036,_24370550,_24368048).

'blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'(_24371146,_24371148,_24371150,_24371152):-freeze(_24371150,'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'(_24371146,_24371148,_24371150,_24371152)).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'('FlatCurry.Types.Cons'(_24367252,_24367270,_24367288,_24367306),_24371654,_24371660,_24371666):-!,hnf('Prelude.apply'('Prelude.concatMap'(partcall(1,'CASS.FlatCurryDependency.tconsOf',[])),_24367306),_24371654,_24371660,_24371666).
'blocked_blocked_CASS.FlatCurryDependency.dependsDirectlyOnTypes._\'23lambda1_1'('FAIL'(_24373224),'FAIL'(_24373224),_24373238,_24373238):-nonvar(_24373224).

'CASS.FlatCurryDependency.tconsOf'(_24374638,_24374640,_24374642,_24374644):-freeze(_24374642,'blocked_CASS.FlatCurryDependency.tconsOf'(_24374638,_24374640,_24374642,_24374644)).
'blocked_CASS.FlatCurryDependency.tconsOf'(_24374724,_24376366,_24376372,_24376378):-hnf(_24374724,_24377896,_24376372,_24377908),'blocked_CASS.FlatCurryDependency.tconsOf_1'(_24377896,_24376366,_24377908,_24376378).

'blocked_CASS.FlatCurryDependency.tconsOf_1'(_24378342,_24378344,_24378346,_24378348):-freeze(_24378346,'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'(_24378342,_24378344,_24378346,_24378348)).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.TVar'(_24374840),[],_24378832,_24378832).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.FuncType'(_24374964,_24374982),_24379768,_24379774,_24379780):-hnf('Prelude.++'('CASS.FlatCurryDependency.tconsOf'(_24374964),'CASS.FlatCurryDependency.tconsOf'(_24374982)),_24379768,_24379774,_24379780).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.TCons'(_24375420,_24375438),[_24375420|'Prelude.apply'('Prelude.concatMap'(partcall(1,'CASS.FlatCurryDependency.tconsOf',[])),_24375438)],_24381694,_24381694).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FlatCurry.Types.ForallType'(_24375960,_24375978),_24383626,_24383632,_24383638):-!,hnf('CASS.FlatCurryDependency.tconsOf'(_24375978),_24383626,_24383632,_24383638).
'blocked_blocked_CASS.FlatCurryDependency.tconsOf_1'('FAIL'(_24384500),'FAIL'(_24384500),_24384514,_24384514):-nonvar(_24384500).

'CASS.FlatCurryDependency.callsDirectly'(_24386142,_24386144,_24386146,_24386148):-freeze(_24386146,'blocked_CASS.FlatCurryDependency.callsDirectly'(_24386142,_24386144,_24386146,_24386148)).
'blocked_CASS.FlatCurryDependency.callsDirectly'(_24386228,_24386580,_24386586,_24386592):-hnf('Prelude.apply'('Data.Set.toList','Prelude.snd'('CASS.FlatCurryDependency.directlyDependent'(_24386228))),_24386580,_24386586,_24386592).

'CASS.FlatCurryDependency.directlyDependent'(_24389692,_24389694,_24389696,_24389698):-freeze(_24389696,'blocked_CASS.FlatCurryDependency.directlyDependent'(_24389692,_24389694,_24389696,_24389698)).
'blocked_CASS.FlatCurryDependency.directlyDependent'(_24389778,_24391016,_24391022,_24391028):-hnf(_24389778,_24392906,_24391022,_24392918),'blocked_CASS.FlatCurryDependency.directlyDependent_1'(_24392906,_24391016,_24392918,_24391028).

'blocked_CASS.FlatCurryDependency.directlyDependent_1'(_24393412,_24393414,_24393416,_24393418):-freeze(_24393416,'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1'(_24393412,_24393414,_24393416,_24393418)).
'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1'('FlatCurry.Types.Func'(_24389894,_24389912,_24389930,_24389948,_24389966),_24394350,_24394356,_24394362):-!,hnf(_24389966,_24397230,_24394356,_24397266),'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'(_24397230,_24389894,_24389912,_24389930,_24389948,_24394350,_24397266,_24394362).

'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'(_24397996,_24397998,_24398000,_24398002,_24398004,_24398006,_24398008,_24398010):-freeze(_24398008,'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'(_24397996,_24397998,_24398000,_24398002,_24398004,_24398006,_24398008,_24398010)).
'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_24390112,_24390130),_24389894,_24389912,_24389930,_24389948,'Prelude.(,)'(_24389894,'CASS.FlatCurryDependency.funcSetOfExpr'(_24390130)),_24398534,_24398534).
'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_24390484),_24389894,_24389912,_24389930,_24389948,'Prelude.(,)'(_24389894,'CASS.FlatCurryDependency.emptySet'),_24400668,_24400668):-!.
'blocked_blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1_FlatCurry.Types.Func_5'('FAIL'(_24402154),_24389894,_24389912,_24389930,_24389948,'FAIL'(_24402154),_24402168,_24402168):-nonvar(_24402154).
'blocked_blocked_CASS.FlatCurryDependency.directlyDependent_1'('FAIL'(_24402256),'FAIL'(_24402256),_24402270,_24402270):-nonvar(_24402256).

'CASS.FlatCurryDependency.funcSetOfExpr'(_24403898,_24403900,_24403902,_24403904):-freeze(_24403902,'blocked_CASS.FlatCurryDependency.funcSetOfExpr'(_24403898,_24403900,_24403902,_24403904)).
'blocked_CASS.FlatCurryDependency.funcSetOfExpr'(_24403984,_24410178,_24410184,_24410190):-hnf(_24403984,_24411924,_24410184,_24411936),'blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'(_24411924,_24410178,_24411936,_24410190).

'blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'(_24412406,_24412408,_24412410,_24412412):-freeze(_24412410,'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'(_24412406,_24412408,_24412410,_24412412)).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Var'(_24404100),_24412878,_24412884,_24412890):-hnf('Data.Set.empty',_24412878,_24412884,_24412890).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Lit'(_24404224),_24413894,_24413900,_24413906):-hnf('Data.Set.empty',_24413894,_24413900,_24413906).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Comb'(_24404348,_24404366,_24404384),_24416360,_24416366,_24416372):-hnf('CASS.FlatCurryDependency.isConstructorComb'(_24404348),_24419204,_24416366,_24419164),'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'(_24419204,_24404348,_24404366,_24404384,_24416360,_24419164,_24416372).

'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'(_24419910,_24419912,_24419914,_24419916,_24419918,_24419920,_24419922):-freeze(_24419920,freeze(_24419910,'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'(_24419910,_24419912,_24419914,_24419916,_24419918,_24419920,_24419922))).
'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_24404348,_24404366,_24404384,_24420324,_24420330,_24420336):-hnf('Prelude.apply'('CASS.FlatCurryDependency.unionMap'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr',[])),_24404384),_24420324,_24420330,_24420336).
'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_24404348,_24404366,_24404384,_24422396,_24422402,_24422408):-!,hnf('Data.Set.insert'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),_24404366,'Prelude.apply'('CASS.FlatCurryDependency.unionMap'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr',[])),_24404384)),_24422396,_24422402,_24422408).
'blocked_blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_24426504),_24404348,_24404366,_24404384,'FAIL'(_24426504),_24426518,_24426518).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Free'(_24405858,_24405876),_24427006,_24427012,_24427018):-hnf('CASS.FlatCurryDependency.funcSetOfExpr'(_24405876),_24427006,_24427012,_24427018).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Let'(_24406076,_24406094),_24428334,_24428340,_24428346):-hnf('Prelude.apply'('Prelude.apply'('Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),'Prelude.apply'('CASS.FlatCurryDependency.unionMap'('Prelude..'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr',[]),partcall(1,'FlatCurry.Types.expOfLetBind',[]))),_24406076)),'CASS.FlatCurryDependency.funcSetOfExpr'(_24406094)),_24428334,_24428340,_24428346).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Or'(_24407456,_24407474),_24433668,_24433674,_24433680):-hnf('Prelude.apply'('Prelude.apply'('Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),'CASS.FlatCurryDependency.funcSetOfExpr'(_24407456)),'CASS.FlatCurryDependency.funcSetOfExpr'(_24407474)),_24433668,_24433674,_24433680).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Case'(_24408500,_24408518,_24408536),_24438052,_24438058,_24438064):-hnf('Prelude.apply'('Prelude.apply'('Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),'CASS.FlatCurryDependency.funcSetOfExpr'(_24408518)),'Prelude.apply'('CASS.FlatCurryDependency.unionMap'(partcall(1,'CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63',[])),_24408536)),_24438052,_24438058,_24438064).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FlatCurry.Types.Typed'(_24409736,_24409754),_24443118,_24443124,_24443130):-!,hnf('CASS.FlatCurryDependency.funcSetOfExpr'(_24409736),_24443118,_24443124,_24443130).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr_1'('FAIL'(_24444064),'FAIL'(_24444064),_24444078,_24444078):-nonvar(_24444064).

'CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63'(_24446428,_24446430,_24446432,_24446434):-freeze(_24446432,'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63'(_24446428,_24446430,_24446432,_24446434)).
'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63'(_24446514,_24447186,_24447192,_24447198):-hnf(_24446514,_24449616,_24447192,_24449628),'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'(_24449616,_24447186,_24449628,_24447198).

'blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'(_24450212,_24450214,_24450216,_24450218):-freeze(_24450216,'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'(_24450212,_24450214,_24450216,_24450218)).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'('FlatCurry.Types.Branch'(_24446630,_24446648),_24450728,_24450734,_24450740):-!,hnf('CASS.FlatCurryDependency.funcSetOfExpr'(_24446648),_24450728,_24450734,_24450740).
'blocked_blocked_CASS.FlatCurryDependency.funcSetOfExpr.funcSetOfBranch.63_1'('FAIL'(_24451788),'FAIL'(_24451788),_24451802,_24451802):-nonvar(_24451788).

'CASS.FlatCurryDependency.isConstructorComb'(_24453582,_24453584,_24453586,_24453588):-freeze(_24453586,'blocked_CASS.FlatCurryDependency.isConstructorComb'(_24453582,_24453584,_24453586,_24453588)).
'blocked_CASS.FlatCurryDependency.isConstructorComb'(_24453668,_24454194,_24454200,_24454206):-makeShare(_24453696,_24454312),hnf('Prelude.cond'(letrec4PAKCS(_24454312,'Prelude.False'),'CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_24453668,_24454312)),_24454194,_24454200,_24454206).

'CASS.FlatCurryDependency.unionMap'(_24457570,_24457572,_24457574,_24457576):-freeze(_24457574,'blocked_CASS.FlatCurryDependency.unionMap'(_24457570,_24457572,_24457574,_24457576)).
'blocked_CASS.FlatCurryDependency.unionMap'(_24457656,_24458512,_24458518,_24458524):-hnf('Prelude..'(partcall(1,'Prelude.foldr',['CASS.FlatCurryDependency.emptySet','Data.Set.union'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]))]),partcall(1,'Prelude.map',[_24457656])),_24458512,_24458518,_24458524).

'CASS.FlatCurryDependency.emptySet'(_24463436,_24463438,_24463440):-freeze(_24463438,'blocked_CASS.FlatCurryDependency.emptySet'(_24463436,_24463438,_24463440)).
'blocked_CASS.FlatCurryDependency.emptySet'(_24463524,_24463530,_24463536):-hnf('Data.Set.empty',_24463524,_24463530,_24463536).

'CASS.FlatCurryDependency.leqQName'(_24465366,_24465368,_24465370,_24465372,_24465374):-freeze(_24465372,'blocked_CASS.FlatCurryDependency.leqQName'(_24465366,_24465368,_24465370,_24465372,_24465374)).
'blocked_CASS.FlatCurryDependency.leqQName'(_24465462,_24465480,_24466930,_24466936,_24466942):-hnf(_24465462,_24468504,_24466936,_24468522),'blocked_CASS.FlatCurryDependency.leqQName_1'(_24468504,_24465480,_24466930,_24468522,_24466942).

'blocked_CASS.FlatCurryDependency.leqQName_1'(_24468970,_24468972,_24468974,_24468976,_24468978):-freeze(_24468976,'blocked_blocked_CASS.FlatCurryDependency.leqQName_1'(_24468970,_24468972,_24468974,_24468976,_24468978)).
'blocked_blocked_CASS.FlatCurryDependency.leqQName_1'('Prelude.(,)'(_24465596,_24465614),_24465480,_24469702,_24469708,_24469714):-!,hnf(_24465480,_24471996,_24469708,_24472020),'blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'(_24471996,_24465596,_24465614,_24469702,_24472020,_24469714).

'blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'(_24472626,_24472628,_24472630,_24472632,_24472634,_24472636):-freeze(_24472634,'blocked_blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'(_24472626,_24472628,_24472630,_24472632,_24472634,_24472636)).
'blocked_blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'('Prelude.(,)'(_24465742,_24465760),_24465596,_24465614,_24473016,_24473022,_24473028):-!,hnf('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[]),'Prelude.++'(_24465596,[^.|_24465614]),'Prelude.++'(_24465742,[^.|_24465760])),_24473016,_24473022,_24473028).
'blocked_blocked_blocked_CASS.FlatCurryDependency.leqQName_1_Prelude.(,)_3'('FAIL'(_24475924),_24465596,_24465614,'FAIL'(_24475924),_24475938,_24475938):-nonvar(_24475924).
'blocked_blocked_CASS.FlatCurryDependency.leqQName_1'('FAIL'(_24476010),_24465480,'FAIL'(_24476010),_24476024,_24476024):-nonvar(_24476010).

'CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_24478220,_24478222,_24478224,_24478226,_24478228):-freeze(_24478226,'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_24478220,_24478222,_24478224,_24478226,_24478228)).
'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0'(_24478316,_24478334,_24479190,_24479196,_24479202):-hnf(_24478316,_24481520,_24479196,_24481538),'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'(_24481520,_24478334,_24479190,_24481538,_24479202).

'blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'(_24482118,_24482120,_24482122,_24482124,_24482126):-freeze(_24482124,freeze(_24482118,'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'(_24482118,_24482120,_24482122,_24482124,_24482126))).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.ConsCall',_24478334,'Prelude.True',_24482662,_24482662).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.ConsPartCall'(_24478550),_24478334,'Prelude.True',_24483860,_24483860).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.FuncCall',_24478334,_24485060,_24485066,_24485072):-hnf(_24478334,_24485060,_24485066,_24485072).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FlatCurry.Types.FuncPartCall'(_24478760),_24478334,_24486188,_24486194,_24486200):-!,hnf(_24478334,_24486188,_24486194,_24486200).
'blocked_blocked_CASS.FlatCurryDependency.isConstructorComb._\'23caseor0_1'('FAIL'(_24486900),_24478334,'FAIL'(_24486900),_24486914,_24486914).

:-costCenters(['']).




%%%%% Number of shared variables: 1

