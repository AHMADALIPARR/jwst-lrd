%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.ProgInfo').
:-importModule('Analysis.Types').
:-importModule('Data.List').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').
:-importModule('RW.Base').

:-curryModule('Analysis.RootReplaced').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.RootReplaced.showRootRepl',showRootRepl,2,'Analysis.RootReplaced.showRootRepl',nofix,notype).
functiontype('Analysis.RootReplaced.showRootRepl._\'23lambda1','Analysis.RootReplaced.showRootRepl._#lambda1',1,'Analysis.RootReplaced.showRootRepl._\'23lambda1',nofix,notype).
functiontype('Analysis.RootReplaced.rootReplAnalysis',rootReplAnalysis,0,'Analysis.RootReplaced.rootReplAnalysis',nofix,notype).
functiontype('Analysis.RootReplaced.rrFunc','Analysis.RootReplaced.rrFunc',2,'Analysis.RootReplaced.rrFunc',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule','Analysis.RootReplaced.rrFuncRule',2,'Analysis.RootReplaced.rrFuncRule',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.lub.31','Analysis.RootReplaced.rrFuncRule.lub.31',4,'Analysis.RootReplaced.rrFuncRule.lub.31',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.rrOfExp.31','Analysis.RootReplaced.rrFuncRule.rrOfExp.31',3,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3','Analysis.RootReplaced.rrFuncRule.rrOfExp.31._#lambda3',1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4','Analysis.RootReplaced.rrFuncRule.rrOfExp.31._#lambda4',5,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5','Analysis.RootReplaced.rrFuncRule.rrOfExp.31._#lambda4._#lambda5',4,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6','Analysis.RootReplaced.rrFuncRule.rrOfExp.31._#lambda6',3,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6',nofix,notype).
functiontype('Analysis.RootReplaced.showRootCyclic',showRootCyclic,2,'Analysis.RootReplaced.showRootCyclic',nofix,notype).
functiontype('Analysis.RootReplaced.rootCyclicAnalysis',rootCyclicAnalysis,0,'Analysis.RootReplaced.rootCyclicAnalysis',nofix,notype).
functiontype('Analysis.RootReplaced.rcFunc','Analysis.RootReplaced.rcFunc',2,'Analysis.RootReplaced.rcFunc',nofix,notype).
functiontype('Analysis.RootReplaced.rcFunc._\'23lambda7','Analysis.RootReplaced.rcFunc._#lambda7',3,'Analysis.RootReplaced.rcFunc._\'23lambda7',nofix,notype).
functiontype('Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8','Analysis.RootReplaced.rcFunc._#lambda7._#lambda8',2,'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8',nofix,notype).
functiontype('Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9','Analysis.RootReplaced.rcFunc._#lambda7._#lambda8._#lambda9',2,'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9',nofix,notype).
functiontype('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0','Analysis.RootReplaced.rrFuncRule.rrOfExp.31._#lambda4._#caseor0',3,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.RootReplaced.showRootRepl'(_7907380,_7907382,_7907384,_7907386,_7907388):-freeze(_7907386,'blocked_Analysis.RootReplaced.showRootRepl'(_7907380,_7907382,_7907384,_7907386,_7907388)).
'blocked_Analysis.RootReplaced.showRootRepl'(_7907476,_7907494,_7916588,_7916594,_7916600):-hnf(_7907476,_7918198,_7916594,_7918216),'blocked_Analysis.RootReplaced.showRootRepl_1'(_7918198,_7907494,_7916588,_7918216,_7916600).

'blocked_Analysis.RootReplaced.showRootRepl_1'(_7918670,_7918672,_7918674,_7918676,_7918678):-freeze(_7918676,'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'(_7918670,_7918672,_7918674,_7918676,_7918678)).
'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'('Analysis.Types.AText',_7907494,_7919496,_7919502,_7919508):-hnf(_7907494,_7922096,_7919502,_7922108),'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'(_7922096,_7919496,_7922108,_7919508).

'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'(_7922740,_7922742,_7922744,_7922746):-freeze(_7922744,'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'(_7922740,_7922742,_7922744,_7922746)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'('Prelude.(,)'(_7907708,_7907726),_7925214,_7925220,_7925226):-!,makeShare(_7907708,_7923112),hnf(_7923112,_7928652,_7925220,_7928676),'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'(_7928652,_7928652,_7907726,_7925214,_7928676,_7925226).

'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'(_7929486,_7929488,_7929490,_7929492,_7929494,_7929496):-freeze(_7929494,'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'(_7929486,_7929488,_7929490,_7929492,_7929494,_7929496)).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'([],_7923112,_7907726,['^n','^o','^ ','^r','^o','^o','^t','^ ','^r','^e','^p','^l','^a','^c','^e','^m','^e','^n','^t','^s'],_7929754,_7929754).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'([_7911034|_7911052],_7923112,_7907726,_7934872,_7934878,_7934884):-!,hnf('Prelude.++'(['^r','^o','^o','^t','^ ','^r','^e','^p','^l','^a','^c','^e','^m','^e','^n','^t','^s',^:,'^ '],'Data.List.intercalate'(['^,'],'Prelude.map'(partcall(1,'Analysis.RootReplaced.showRootRepl._\'23lambda1',[]),_7923112))),_7934872,_7934878,_7934884).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'('FAIL'(_7941204),_7923112,_7907726,'FAIL'(_7941204),_7941218,_7941218):-nonvar(_7941204).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'('FAIL'(_7941290),'FAIL'(_7941290),_7941304,_7941304):-nonvar(_7941290).
'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'('Analysis.Types.ANote',_7907494,_7942096,_7942102,_7942108):-!,hnf(_7907494,_7944696,_7942102,_7944708),'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'(_7944696,_7942096,_7944708,_7942108).

'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'(_7945358,_7945360,_7945362,_7945364):-freeze(_7945362,'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'(_7945358,_7945360,_7945362,_7945364)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'('Prelude.(,)'(_7914862,_7914880),_7946972,_7946978,_7946984):-!,makeShare(_7914862,_7945730),hnf(_7945730,_7950410,_7946978,_7950434),'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'(_7950410,_7950410,_7914880,_7946972,_7950434,_7946984).

'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'(_7951244,_7951246,_7951248,_7951250,_7951252,_7951254):-freeze(_7951252,'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'(_7951244,_7951246,_7951248,_7951250,_7951252,_7951254)).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'([],_7945730,_7914880,[],_7951512,_7951512).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'([_7915108|_7915126],_7945730,_7914880,_7952590,_7952596,_7952602):-!,hnf('Prelude.++'(['^['],'Prelude.++'('Data.List.intercalate'(['^,'],'Prelude.map'(partcall(1,'Prelude.snd',[]),_7945730)),['^]'])),_7952590,_7952596,_7952602).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'('FAIL'(_7955616),_7945730,_7914880,'FAIL'(_7955616),_7955630,_7955630):-nonvar(_7955616).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'('FAIL'(_7955702),'FAIL'(_7955702),_7955716,_7955716):-nonvar(_7955702).
'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'('FAIL'(_7955772),_7907494,'FAIL'(_7955772),_7955786,_7955786):-nonvar(_7955772).

'Analysis.RootReplaced.showRootRepl._\'23lambda1'(_7957678,_7957680,_7957682,_7957684):-freeze(_7957682,'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1'(_7957678,_7957680,_7957682,_7957684)).
'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1'(_7957764,_7958762,_7958768,_7958774):-hnf(_7957764,_7960796,_7958768,_7960808),'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'(_7960796,_7958762,_7960808,_7958774).

'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'(_7961326,_7961328,_7961330,_7961332):-freeze(_7961330,'blocked_blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'(_7961326,_7961328,_7961330,_7961332)).
'blocked_blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'('Prelude.(,)'(_7957880,_7957898),_7961696,_7961702,_7961708):-!,hnf('Prelude.++'(_7957880,'Prelude.++'([^.],_7957898)),_7961696,_7961702,_7961708).
'blocked_blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'('FAIL'(_7963230),'FAIL'(_7963230),_7963244,_7963244):-nonvar(_7963230).

'Analysis.RootReplaced.rootReplAnalysis'(_7964872,_7964874,_7964876):-freeze(_7964874,'blocked_Analysis.RootReplaced.rootReplAnalysis'(_7964872,_7964874,_7964876)).
'blocked_Analysis.RootReplaced.rootReplAnalysis'(_7967228,_7967234,_7967240):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^R','^o','^o','^t','^R','^e','^p','^l','^a','^c','^e','^d'],'Prelude.(,)'([],[]),partcall(2,'Analysis.RootReplaced.rrFunc',[])),_7967228,_7967234,_7967240).

'Analysis.RootReplaced.rrFunc'(_7972228,_7972230,_7972232,_7972234,_7972236):-freeze(_7972234,'blocked_Analysis.RootReplaced.rrFunc'(_7972228,_7972230,_7972232,_7972234,_7972236)).
'blocked_Analysis.RootReplaced.rrFunc'(_7972324,_7972342,_7972982,_7972988,_7972994):-hnf(_7972324,_7974376,_7972988,_7974394),'blocked_Analysis.RootReplaced.rrFunc_1'(_7974376,_7972342,_7972982,_7974394,_7972994).

'blocked_Analysis.RootReplaced.rrFunc_1'(_7974812,_7974814,_7974816,_7974818,_7974820):-freeze(_7974818,'blocked_blocked_Analysis.RootReplaced.rrFunc_1'(_7974812,_7974814,_7974816,_7974818,_7974820)).
'blocked_blocked_Analysis.RootReplaced.rrFunc_1'('FlatCurry.Types.Func'(_7972458,_7972476,_7972494,_7972512,_7972530),_7972342,_7975338,_7975344,_7975350):-!,hnf('Analysis.RootReplaced.rrFuncRule'(_7972342,_7972530),_7975338,_7975344,_7975350).
'blocked_blocked_Analysis.RootReplaced.rrFunc_1'('FAIL'(_7976564),_7972342,'FAIL'(_7976564),_7976578,_7976578):-nonvar(_7976564).

'Analysis.RootReplaced.rrFuncRule'(_7977986,_7977988,_7977990,_7977992,_7977994):-freeze(_7977992,'blocked_Analysis.RootReplaced.rrFuncRule'(_7977986,_7977988,_7977990,_7977992,_7977994)).
'blocked_Analysis.RootReplaced.rrFuncRule'(_7978082,_7978100,_7979062,_7979068,_7979074):-hnf(_7978100,_7980600,_7979068,_7980618),'blocked_Analysis.RootReplaced.rrFuncRule_2'(_7980600,_7978082,_7979062,_7980618,_7979074).

'blocked_Analysis.RootReplaced.rrFuncRule_2'(_7981060,_7981062,_7981064,_7981066,_7981068):-freeze(_7981066,'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'(_7981060,_7981062,_7981064,_7981066,_7981068)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'('FlatCurry.Types.External'(_7978216),_7978082,'Prelude.(,)'([],[]),_7981608,_7981608).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'('FlatCurry.Types.Rule'(_7978508,_7978526),_7978082,_7982836,_7982842,_7982848):-!,hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_7978508,_7978082,_7978526),_7982836,_7982842,_7982848).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'('FAIL'(_7984070),_7978082,'FAIL'(_7984070),_7984084,_7984084):-nonvar(_7984070).

'Analysis.RootReplaced.rrFuncRule.lub.31'(_7985758,_7985760,_7985762,_7985764,_7985766,_7985768,_7985770):-freeze(_7985768,'blocked_Analysis.RootReplaced.rrFuncRule.lub.31'(_7985758,_7985760,_7985762,_7985764,_7985766,_7985768,_7985770)).
'blocked_Analysis.RootReplaced.rrFuncRule.lub.31'(_7985874,_7985892,_7985910,_7985928,_7987822,_7987828,_7987834):-hnf(_7985910,_7989628,_7987828,_7989658),'blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'(_7989628,_7985874,_7985892,_7985928,_7987822,_7989658,_7987834).

'blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'(_7990158,_7990160,_7990162,_7990164,_7990166,_7990168,_7990170):-freeze(_7990168,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'(_7990158,_7990160,_7990162,_7990164,_7990166,_7990168,_7990170)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'('Prelude.(,)'(_7986044,_7986062),_7985874,_7985892,_7985928,_7990962,_7990968,_7990974):-!,hnf(_7985928,_7993488,_7990968,_7993524),'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'(_7993488,_7986044,_7986062,_7985874,_7985892,_7990962,_7993524,_7990974).

'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'(_7994182,_7994184,_7994186,_7994188,_7994190,_7994192,_7994194,_7994196):-freeze(_7994194,'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'(_7994182,_7994184,_7994186,_7994188,_7994190,_7994192,_7994194,_7994196)).
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'('Prelude.(,)'(_7986190,_7986208),_7986044,_7986062,_7985874,_7985892,'Prelude.(,)'('Prelude.apply'('Data.List.sort'(_7995026),'Data.List.union'('Prelude._super\'23Prelude.Ord\'23Prelude.Eq\'230\'23'(_7995026),_7986044,_7986190)),'Prelude.apply'('Data.List.sort'(_7995046),'Data.List.union'('Prelude._super\'23Prelude.Ord\'23Prelude.Eq\'230\'23'(_7995046),_7986062,_7986208))),_7994598,_7994604):-!,makeShare(_7985892,_7995026),makeShare(_7985874,_7995046),_7994598=_7994604.
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'('FAIL'(_7999096),_7986044,_7986062,_7985874,_7985892,'FAIL'(_7999096),_7999110,_7999110):-nonvar(_7999096).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'('FAIL'(_7999198),_7985874,_7985892,_7985928,'FAIL'(_7999198),_7999212,_7999212):-nonvar(_7999198).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8001054,_8001056,_8001058,_8001060,_8001062,_8001064):-freeze(_8001062,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8001054,_8001056,_8001058,_8001060,_8001062,_8001064)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8001160,_8001178,_8001196,_8013736,_8013742,_8013748):-hnf(_8001196,_8015678,_8013742,_8015702),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'(_8015678,_8001160,_8001178,_8013736,_8015702,_8013748).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'(_8016224,_8016226,_8016228,_8016230,_8016232,_8016234):-freeze(_8016232,freeze(_8016224,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'(_8016224,_8016226,_8016228,_8016230,_8016232,_8016234))).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Var'(_8001312),_8001160,_8001178,_8016722,_8016728,_8016734):-hnf('Prelude.maybe'('Prelude.(,)'([],[]),partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3',[]),'Prelude.apply'('Data.List.elemIndex'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_8001312),_8001160)),_8016722,_8016728,_8016734).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Lit'(_8002164),_8001160,_8001178,'Prelude.(,)'([],[]),_8019712,_8019712).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Comb'(_8002456,_8002474,_8002492),_8001160,_8001178,_8024338,_8024344,_8024350):-hnf('FlatCurry.Types._impl\'23\'3D\'3D\'23Prelude.Eq\'23FlatCurry.Types.CombType\'23'(_8002456,'FlatCurry.Types.FuncCall'),_8027390,_8024344,_8027338),'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'(_8027390,_8002456,_8002474,_8002492,_8001160,_8001178,_8024338,_8027338,_8024350).

'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'(_8028130,_8028132,_8028134,_8028136,_8028138,_8028140,_8028142,_8028144,_8028146):-freeze(_8028144,freeze(_8028130,'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'(_8028130,_8028132,_8028134,_8028136,_8028138,_8028140,_8028142,_8028144,_8028146))).
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_8002456,_8002474,_8002492,_8001160,_8001178,_8028564,_8028570,_8028576):-makeShare(_8002474,_8029022),makeShare(_8001178,_8029042),hnf('Prelude.maybe'('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^A','^b','^s','^t','^r','^a','^c','^t','^ ','^v','^a','^l','^u','^e','^ ','^o','^f','^ '],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])])),_8029022),['^ ','^n','^o','^t','^ ','^f','^o','^u','^n','^d','^!']))),partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4',[_8029022,_8029042,_8001160,_8002492]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_8029022,_8029042)),_8028564,_8028570,_8028576).
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_8002456,_8002474,_8002492,_8001160,_8001178,'Prelude.(,)'([],[]),_8043156,_8043156):-!.
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_8044526),_8002456,_8002474,_8002492,_8001160,_8001178,'FAIL'(_8044526),_8044540,_8044540).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Typed'(_8009720,_8009738),_8001160,_8001178,_8045056,_8045062,_8045068):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8001160,_8001178,_8009720),_8045056,_8045062,_8045068).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Free'(_8010078,_8010096),_8001160,_8001178,_8046824,_8046830,_8046836):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8001160,_8001178,_8010096),_8046824,_8046830,_8046836).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Let'(_8010436,_8010454),_8001160,_8001178,_8048580,_8048586,_8048592):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8001160,_8001178,_8010454),_8048580,_8048586,_8048592).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Or'(_8010794,_8010812),_8001160,_8001178,_8050324,_8050330,_8050336):-makeShare(_8001160,_8050582),makeShare(_8001178,_8050602),hnf('Analysis.RootReplaced.rrFuncRule.lub.31'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8050582,_8050602,_8010794),'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8050582,_8050602,_8010812)),_8050324,_8050330,_8050336).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Case'(_8012034,_8012052,_8012070),_8001160,_8001178,_8056016,_8056022,_8056028):-!,makeShare(_8001160,_8056278),makeShare(_8001178,_8056298),hnf('Prelude.foldr'(partcall(2,'Analysis.RootReplaced.rrFuncRule.lub.31',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[])]),'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8056278,_8056298,_8012052),'Prelude.map'(partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6',[_8056298,_8056278]),_8012070)),_8056016,_8056022,_8056028).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FAIL'(_8061828),_8001160,_8001178,'FAIL'(_8061828),_8061842,_8061842).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3'(_8064080,_8064082,_8064084,_8064086):-freeze(_8064084,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3'(_8064080,_8064082,_8064084,_8064086)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3'(_8064166,'Prelude.(,)'([],[_8064166]),_8064524,_8064524).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4'(_8067716,_8067718,_8067720,_8067722,_8067724,_8067726,_8067728,_8067730):-freeze(_8067728,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4'(_8067716,_8067718,_8067720,_8067722,_8067724,_8067726,_8067728,_8067730)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4'(_8067842,_8067860,_8067878,_8067896,_8067914,_8070692,_8070698,_8070704):-hnf(_8067914,_8073082,_8070698,_8073118),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'(_8073082,_8067842,_8067860,_8067878,_8067896,_8070692,_8073118,_8070704).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'(_8073722,_8073724,_8073726,_8073728,_8073730,_8073732,_8073734,_8073736):-freeze(_8073734,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'(_8073722,_8073724,_8073726,_8073728,_8073730,_8073732,_8073734,_8073736)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'('Prelude.(,)'(_8068030,_8068048),_8067842,_8067860,_8067878,_8067896,_8074132,_8074138,_8074144):-!,makeShare(_8067896,_8074564),makeShare(_8068030,_8074584),hnf('Prelude.foldr'(partcall(2,'Analysis.RootReplaced.rrFuncRule.lub.31',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[])]),'Prelude.(,)'('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_8074564),_8074584),_8074564,_8074584),[]),'Prelude.map'(partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5',[_8067878,_8067860,_8067842]),_8068048)),_8074132,_8074138,_8074144).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'('FAIL'(_8083240),_8067842,_8067860,_8067878,_8067896,'FAIL'(_8083240),_8083254,_8083254):-nonvar(_8083240).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5'(_8085920,_8085922,_8085924,_8085926,_8085928,_8085930,_8085932):-freeze(_8085930,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5'(_8085920,_8085922,_8085924,_8085926,_8085928,_8085930,_8085932)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5'(_8086036,_8086054,_8086072,_8086090,_8086484,_8086490,_8086496):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8086054,_8086072,'Prelude.!!'(_8086036,_8086090)),_8086484,_8086490,_8086496).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6'(_8090464,_8090466,_8090468,_8090470,_8090472,_8090474):-freeze(_8090472,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6'(_8090464,_8090466,_8090468,_8090470,_8090472,_8090474)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6'(_8090570,_8090588,_8090606,_8091422,_8091428,_8091434):-hnf(_8090606,_8093796,_8091428,_8093820),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'(_8093796,_8090570,_8090588,_8091422,_8093820,_8091434).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'(_8094408,_8094410,_8094412,_8094414,_8094416,_8094418):-freeze(_8094416,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'(_8094408,_8094410,_8094412,_8094414,_8094416,_8094418)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'('FlatCurry.Types.Branch'(_8090722,_8090740),_8090570,_8090588,_8094944,_8094950,_8094956):-!,hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_8090570,_8090588,_8090740),_8094944,_8094950,_8094956).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'('FAIL'(_8096390),_8090570,_8090588,'FAIL'(_8096390),_8096404,_8096404):-nonvar(_8096390).

'Analysis.RootReplaced.showRootCyclic'(_8097972,_8097974,_8097976,_8097978,_8097980):-freeze(_8097978,'blocked_Analysis.RootReplaced.showRootCyclic'(_8097972,_8097974,_8097976,_8097978,_8097980)).
'blocked_Analysis.RootReplaced.showRootCyclic'(_8098068,_8098086,_8108878,_8108884,_8108890):-hnf(_8098068,_8110560,_8108884,_8110578),'blocked_Analysis.RootReplaced.showRootCyclic_1'(_8110560,_8098086,_8108878,_8110578,_8108890).

'blocked_Analysis.RootReplaced.showRootCyclic_1'(_8111044,_8111046,_8111048,_8111050,_8111052):-freeze(_8111050,'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'(_8111044,_8111046,_8111048,_8111050,_8111052)).
'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'('Analysis.Types.AText',_8098086,_8111882,_8111888,_8111894):-hnf(_8098086,_8114554,_8111888,_8114566),'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'(_8114554,_8111882,_8114566,_8111894).

'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'(_8115210,_8115212,_8115214,_8115216):-freeze(_8115214,'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'(_8115210,_8115212,_8115214,_8115216)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'('Prelude.False',['^n','^o','^ ','^c','^y','^c','^l','^e','^s','^ ','^a','^t','^ ','^t','^h','^e','^ ','^r','^o','^o','^t'],_8115606,_8115606).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'('Prelude.True',['^p','^o','^s','^s','^i','^b','^l','^e','^ ','^c','^y','^c','^l','^i','^c','^ ','^r','^o','^o','^t','^ ','^r','^e','^p','^l','^a','^c','^e','^m','^e','^n','^t'],_8120772,_8120772):-!.
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'('FAIL'(_8127868),'FAIL'(_8127868),_8127882,_8127882):-nonvar(_8127868).
'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'('Analysis.Types.ANote',_8098086,_8128686,_8128692,_8128698):-!,hnf(_8098086,_8131358,_8128692,_8131370),'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'(_8131358,_8128686,_8131370,_8128698).

'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'(_8132032,_8132034,_8132036,_8132038):-freeze(_8132036,'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'(_8132032,_8132034,_8132036,_8132038)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'('Prelude.False',[],_8132428,_8132428).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'('Prelude.True',['^r','^o','^o','^t',^-,'^c','^y','^c','^l','^i','^c'],_8133352,_8133352):-!.
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'('FAIL'(_8136206),'FAIL'(_8136206),_8136220,_8136220):-nonvar(_8136206).
'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'('FAIL'(_8136276),_8098086,'FAIL'(_8136276),_8136290,_8136290):-nonvar(_8136276).

'Analysis.RootReplaced.rootCyclicAnalysis'(_8138002,_8138004,_8138006):-freeze(_8138004,'blocked_Analysis.RootReplaced.rootCyclicAnalysis'(_8138002,_8138004,_8138006)).
'blocked_Analysis.RootReplaced.rootCyclicAnalysis'(_8141394,_8141400,_8141406):-hnf('Analysis.Types.combinedSimpleFuncAnalysis'(partcall(1,'Prelude._inst\'23Prelude.Read\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Int\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Char\'23',[])])])])]),partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23Prelude.Int\'23',[])]),partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23Prelude.Char\'23',[])]),partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23Prelude.Char\'23',[])])])])]),['^R','^o','^o','^t','^C','^y','^c','^l','^i','^c'],'Analysis.RootReplaced.rootReplAnalysis',partcall(2,'Analysis.RootReplaced.rcFunc',[])),_8141394,_8141400,_8141406).

'Analysis.RootReplaced.rcFunc'(_8153646,_8153648,_8153650,_8153652,_8153654):-freeze(_8153652,'blocked_Analysis.RootReplaced.rcFunc'(_8153646,_8153648,_8153650,_8153652,_8153654)).
'blocked_Analysis.RootReplaced.rcFunc'(_8153742,_8153760,_8155076,_8155082,_8155088):-hnf(_8153760,_8156470,_8155082,_8156488),'blocked_Analysis.RootReplaced.rcFunc_2'(_8156470,_8153742,_8155076,_8156488,_8155088).

'blocked_Analysis.RootReplaced.rcFunc_2'(_8156906,_8156908,_8156910,_8156912,_8156914):-freeze(_8156912,'blocked_blocked_Analysis.RootReplaced.rcFunc_2'(_8156906,_8156908,_8156910,_8156912,_8156914)).
'blocked_blocked_Analysis.RootReplaced.rcFunc_2'('FlatCurry.Types.Func'(_8153876,_8153894,_8153912,_8153930,_8153948),_8153742,_8157770,_8157776,_8157782):-!,hnf(_8153948,_8160154,_8157776,_8160196),'blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'(_8160154,_8153876,_8153894,_8153912,_8153930,_8153742,_8157770,_8160196,_8157782).

'blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'(_8160850,_8160852,_8160854,_8160856,_8160858,_8160860,_8160862,_8160864,_8160866):-freeze(_8160864,'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'(_8160850,_8160852,_8160854,_8160856,_8160858,_8160860,_8160862,_8160864,_8160866)).
'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_8154094),_8153876,_8153894,_8153912,_8153930,_8153742,'Prelude.False',_8161438,_8161438).
'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_8154218,_8154236),_8153876,_8153894,_8153912,_8153930,_8153742,_8162940,_8162946,_8162952):-!,makeShare(_8153742,_8163124),makeShare(_8153876,_8163144),hnf('Prelude.maybe'('Prelude.True',partcall(1,'Analysis.RootReplaced.rcFunc._\'23lambda7',[_8163144,_8163124]),'Analysis.ProgInfo.lookupProgInfo'(_8163144,_8163124)),_8162940,_8162946,_8162952).
'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'('FAIL'(_8165850),_8153876,_8153894,_8153912,_8153930,_8153742,'FAIL'(_8165850),_8165864,_8165864):-nonvar(_8165850).
'blocked_blocked_Analysis.RootReplaced.rcFunc_2'('FAIL'(_8165960),_8153742,'FAIL'(_8165960),_8165974,_8165974):-nonvar(_8165960).

'Analysis.RootReplaced.rcFunc._\'23lambda7'(_8167638,_8167640,_8167642,_8167644,_8167646,_8167648):-freeze(_8167646,'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7'(_8167638,_8167640,_8167642,_8167644,_8167646,_8167648)).
'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7'(_8167744,_8167762,_8167780,_8169098,_8169104,_8169110):-makeShare(_8167780,_8169300),hnf('Prelude.||'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_8167762),'Prelude.fst'(_8169300)),'Prelude.apply'('Prelude.any'(partcall(1,'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8',[_8167744])),'Prelude.fst'(_8169300))),_8169098,_8169104,_8169110).

'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8'(_8176034,_8176036,_8176038,_8176040,_8176042):-freeze(_8176040,'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8'(_8176034,_8176036,_8176038,_8176040,_8176042)).
'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8'(_8176130,_8176148,_8176640,_8176646,_8176652):-makeShare(_8176148,_8176766),hnf('Prelude.maybe'('Prelude.True',partcall(1,'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9',[_8176766]),'Analysis.ProgInfo.lookupProgInfo'(_8176766,_8176130)),_8176640,_8176646,_8176652).

'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9'(_8181282,_8181284,_8181286,_8181288,_8181290):-freeze(_8181288,'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9'(_8181282,_8181284,_8181286,_8181288,_8181290)).
'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9'(_8181378,_8181396,_8182154,_8182160,_8182166):-hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_8181378),'Prelude.fst'(_8181396)),_8182154,_8182160,_8182166).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'(_8188070,_8188072,_8188074,_8188076,_8188078,_8188080):-freeze(_8188078,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'(_8188070,_8188072,_8188074,_8188076,_8188078,_8188080)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'(_8188176,_8188194,_8188212,_8189472,_8189478,_8189484):-hnf(_8188176,_8192278,_8189478,_8192302),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'(_8192278,_8188194,_8188212,_8189472,_8192302,_8189484).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'(_8192968,_8192970,_8192972,_8192974,_8192976,_8192978):-freeze(_8192976,freeze(_8192968,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'(_8192968,_8192970,_8192972,_8192974,_8192976,_8192978))).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'('Prelude.True',_8188194,_8188212,_8193372,_8193378,_8193384):-hnf(_8188212,_8193372,_8193378,_8193384).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'('Prelude.False',_8188194,_8188212,_8194462,_8194468,_8194474):-!,hnf('Data.List.insertBy'(partcall(2,'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),_8188194,_8188212),_8194462,_8194468,_8194474).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'('FAIL'(_8197660),_8188194,_8188212,'FAIL'(_8197660),_8197674,_8197674).

:-costCenters(['']).




%%%%% Number of shared variables: 14

