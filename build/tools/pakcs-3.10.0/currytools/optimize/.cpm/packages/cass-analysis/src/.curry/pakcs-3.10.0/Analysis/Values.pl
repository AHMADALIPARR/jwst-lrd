%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.TermDomain').
:-importModule('Analysis.Types').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.Values').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.Values.extendEnv','Analysis.Values.extendEnv',3,'Analysis.Values.extendEnv',nofix,notype).
functiontype('Analysis.Values.showValue',showValue,3,'Analysis.Values.showValue',nofix,notype).
functiontype('Analysis.Values.resultValueAnalysisTop',resultValueAnalysisTop,0,'Analysis.Values.resultValueAnalysisTop',nofix,notype).
functiontype('Analysis.Values.resultValueAnalysis2',resultValueAnalysis2,0,'Analysis.Values.resultValueAnalysis2',nofix,notype).
functiontype('Analysis.Values.resultValueAnalysis5',resultValueAnalysis5,0,'Analysis.Values.resultValueAnalysis5',nofix,notype).
functiontype('Analysis.Values.analyseResultValues','Analysis.Values.analyseResultValues',3,'Analysis.Values.analyseResultValues',nofix,notype).
functiontype('Analysis.Values.analyseResultValues.anaExpr.16','Analysis.Values.analyseResultValues.anaExpr.16',4,'Analysis.Values.analyseResultValues.anaExpr.16',nofix,notype).
functiontype('Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2','Analysis.Values.analyseResultValues.anaExpr.16._#lambda2',4,'Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2',nofix,notype).
functiontype('Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3','Analysis.Values.analyseResultValues.anaExpr.16._#lambda3',4,'Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3',nofix,notype).
functiontype('Analysis.Values.analyseResultValues.anaresult.16','Analysis.Values.analyseResultValues.anaresult.16',3,'Analysis.Values.analyseResultValues.anaresult.16',nofix,notype).
functiontype('Analysis.Values.prelude','Analysis.Values.prelude',0,'Analysis.Values.prelude',nofix,notype).
functiontype('Analysis.Values.analyseResultValues._\'23caseor0','Analysis.Values.analyseResultValues._#caseor0',6,'Analysis.Values.analyseResultValues._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.Values.extendEnv'(_12549194,_12549196,_12549198,_12549200,_12549202,_12549204):-freeze(_12549202,'blocked_Analysis.Values.extendEnv'(_12549194,_12549196,_12549198,_12549200,_12549202,_12549204)).
'blocked_Analysis.Values.extendEnv'(_12549300,_12549318,_12549336,_12549828,_12549834,_12549840):-hnf('Prelude.++'('Prelude.zip'(_12549336,'Prelude.repeat'('Analysis.TermDomain.anyType'(_12549300))),_12549318),_12549828,_12549834,_12549840).

'Analysis.Values.showValue'(_12552536,_12552538,_12552540,_12552542,_12552544,_12552546):-freeze(_12552544,'blocked_Analysis.Values.showValue'(_12552536,_12552538,_12552540,_12552542,_12552544,_12552546)).
'blocked_Analysis.Values.showValue'(_12552642,_12552660,_12552678,_12552932,_12552938,_12552944):-hnf('Prelude.apply'('Analysis.TermDomain.showType'(_12552642),_12552678),_12552932,_12552938,_12552944).

'Analysis.Values.resultValueAnalysisTop'(_12555608,_12555610,_12555612):-freeze(_12555610,'blocked_Analysis.Values.resultValueAnalysisTop'(_12555608,_12555610,_12555612)).
'blocked_Analysis.Values.resultValueAnalysisTop'(_12556956,_12556962,_12556968):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^V','^a','^l','^u','^e','^s'],'Analysis.TermDomain._impl\'23emptyType\'23Analysis.TermDomain.TermDomain\'23Analysis.TermDomain.AType\'23',partcall(2,'Analysis.Values.analyseResultValues',[partcall(1,'Analysis.TermDomain._inst\'23Analysis.TermDomain.TermDomain\'23Analysis.TermDomain.AType\'23',[])])),_12556956,_12556962,_12556968).

'Analysis.Values.resultValueAnalysis2'(_12562084,_12562086,_12562088):-freeze(_12562086,'blocked_Analysis.Values.resultValueAnalysis2'(_12562084,_12562086,_12562088)).
'blocked_Analysis.Values.resultValueAnalysis2'(_12563586,_12563592,_12563598):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^V','^a','^l','^u','^e','^s','^2'],'Analysis.TermDomain._impl\'23emptyType\'23Analysis.TermDomain.TermDomain\'23Analysis.TermDomain.DType2\'23',partcall(2,'Analysis.Values.analyseResultValues',[partcall(1,'Analysis.TermDomain._inst\'23Analysis.TermDomain.TermDomain\'23Analysis.TermDomain.DType2\'23',[])])),_12563586,_12563592,_12563598).

'Analysis.Values.resultValueAnalysis5'(_12568916,_12568918,_12568920):-freeze(_12568918,'blocked_Analysis.Values.resultValueAnalysis5'(_12568916,_12568918,_12568920)).
'blocked_Analysis.Values.resultValueAnalysis5'(_12570418,_12570424,_12570430):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^V','^a','^l','^u','^e','^s','^5'],'Analysis.TermDomain._impl\'23emptyType\'23Analysis.TermDomain.TermDomain\'23Analysis.TermDomain.DType5\'23',partcall(2,'Analysis.Values.analyseResultValues',[partcall(1,'Analysis.TermDomain._inst\'23Analysis.TermDomain.TermDomain\'23Analysis.TermDomain.DType5\'23',[])])),_12570418,_12570424,_12570430).

'Analysis.Values.analyseResultValues'(_12575710,_12575712,_12575714,_12575716,_12575718,_12575720):-freeze(_12575718,'blocked_Analysis.Values.analyseResultValues'(_12575710,_12575712,_12575714,_12575716,_12575718,_12575720)).
'blocked_Analysis.Values.analyseResultValues'(_12575816,_12575834,_12575852,_12582034,_12582040,_12582046):-hnf(_12575834,_12583688,_12582040,_12583712),'blocked_Analysis.Values.analyseResultValues_2'(_12583688,_12575816,_12575852,_12582034,_12583712,_12582046).

'blocked_Analysis.Values.analyseResultValues_2'(_12584180,_12584182,_12584184,_12584186,_12584188,_12584190):-freeze(_12584188,'blocked_blocked_Analysis.Values.analyseResultValues_2'(_12584180,_12584182,_12584184,_12584186,_12584188,_12584190)).
'blocked_blocked_Analysis.Values.analyseResultValues_2'('FlatCurry.Types.Func'(_12575968,_12575986,_12576004,_12576022,_12576040),_12575816,_12575852,_12585064,_12585070,_12585076):-!,hnf(_12575968,_12587708,_12585070,_12587756),'blocked_blocked_Analysis.Values.analyseResultValues_2_FlatCurry.Types.Func_1'(_12587708,_12575986,_12576004,_12576022,_12576040,_12575816,_12575852,_12585064,_12587756,_12585076).

'blocked_blocked_Analysis.Values.analyseResultValues_2_FlatCurry.Types.Func_1'(_12588460,_12588462,_12588464,_12588466,_12588468,_12588470,_12588472,_12588474,_12588476,_12588478):-freeze(_12588476,'blocked_blocked_blocked_Analysis.Values.analyseResultValues_2_FlatCurry.Types.Func_1'(_12588460,_12588462,_12588464,_12588466,_12588468,_12588470,_12588472,_12588474,_12588476,_12588478)).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues_2_FlatCurry.Types.Func_1'('Prelude.(,)'(_12576186,_12576204),_12575986,_12576004,_12576022,_12576040,_12575816,_12575852,_12588890,_12588896,_12588902):-!,makeShare(_12576244,_12589472),makeShare(_12575816,_12589492),hnf('Prelude.cond'(letrec4PAKCS(_12589472,['Prelude.(,)'(['^f','^a','^i','^l','^e','^d'],'Analysis.TermDomain.emptyType'(_12589492)),'Prelude.(,)'(['^e','^r','^r','^o','^r'],'Analysis.TermDomain.emptyType'(_12589492)),'Prelude.(,)'(['^p','^r','^i','^m','^_','^e','^r','^r','^o','^r'],'Analysis.TermDomain.emptyType'(_12589492))]),'Analysis.Values.analyseResultValues._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_12576186,'Analysis.Values.prelude'),_12576204,_12589472,_12575852,_12589492,_12576040)),_12588890,_12588896,_12588902).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues_2_FlatCurry.Types.Func_1'('FAIL'(_12599906),_12575986,_12576004,_12576022,_12576040,_12575816,_12575852,'FAIL'(_12599906),_12599920,_12599920):-nonvar(_12599906).
'blocked_blocked_Analysis.Values.analyseResultValues_2'('FAIL'(_12600024),_12575816,_12575852,'FAIL'(_12600024),_12600038,_12600038):-nonvar(_12600024).

'Analysis.Values.analyseResultValues.anaExpr.16'(_12601986,_12601988,_12601990,_12601992,_12601994,_12601996,_12601998):-freeze(_12601996,'blocked_Analysis.Values.analyseResultValues.anaExpr.16'(_12601986,_12601988,_12601990,_12601992,_12601994,_12601996,_12601998)).
'blocked_Analysis.Values.analyseResultValues.anaExpr.16'(_12602102,_12602120,_12602138,_12602156,_12612182,_12612188,_12612194):-hnf(_12602156,_12614240,_12612188,_12614270),'blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'(_12614240,_12602102,_12602120,_12602138,_12612182,_12614270,_12612194).

'blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'(_12614818,_12614820,_12614822,_12614824,_12614826,_12614828,_12614830):-freeze(_12614828,freeze(_12614818,'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'(_12614818,_12614820,_12614822,_12614824,_12614826,_12614828,_12614830))).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Var'(_12602272),_12602102,_12602120,_12602138,_12615326,_12615332,_12615338):-hnf('Prelude.maybe'('Analysis.TermDomain.anyType'(_12602120),partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_12602272,_12602138)),_12615326,_12615332,_12615338).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Lit'(_12602942),_12602102,_12602120,_12602138,_12617932,_12617938,_12617944):-hnf('Prelude.apply'('Analysis.TermDomain.aLit'(_12602120),_12602942),_12617932,_12617938,_12617944).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Comb'(_12603290,_12603308,_12603326),_12602102,_12602120,_12602138,_12623102,_12623108,_12623114):-hnf('FlatCurry.Types._impl\'23\'3D\'3D\'23Prelude.Eq\'23FlatCurry.Types.CombType\'23'(_12603290,'FlatCurry.Types.FuncCall'),_12626276,_12623108,_12626218),'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase'(_12626276,_12603290,_12603308,_12603326,_12602102,_12602120,_12602138,_12623102,_12626218,_12623114).

'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase'(_12627036,_12627038,_12627040,_12627042,_12627044,_12627046,_12627048,_12627050,_12627052,_12627054):-freeze(_12627052,freeze(_12627036,'blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase'(_12627036,_12627038,_12627040,_12627042,_12627044,_12627046,_12627048,_12627050,_12627052,_12627054))).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_12603290,_12603308,_12603326,_12602102,_12602120,_12602138,_12633584,_12633590,_12633596):-makeShare(_12603308,_12627916),makeShare(_12603326,_12627936),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_12627916,'Prelude.(,)'('Analysis.Values.prelude',[^?])),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude.length'(_12627936),2)),_12638018,_12633590,_12637960),'blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase_Prelude.True_ComplexCase'(_12638018,_12603290,_12627916,_12627936,_12602102,_12602120,_12602138,_12633584,_12637960,_12633596).

'blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase_Prelude.True_ComplexCase'(_12639000,_12639002,_12639004,_12639006,_12639008,_12639010,_12639012,_12639014,_12639016,_12639018):-freeze(_12639016,freeze(_12639000,'blocked_blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase_Prelude.True_ComplexCase'(_12639000,_12639002,_12639004,_12639006,_12639008,_12639010,_12639012,_12639014,_12639016,_12639018))).
'blocked_blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_12603290,_12627916,_12627936,_12602102,_12602120,_12602138,_12639444,_12639450,_12639456):-makeShare(_12627936,_12639738),hnf('Analysis.Values.analyseResultValues.anaExpr.16'(_12602102,_12602120,_12602138,'FlatCurry.Types.Or'('Prelude.!!'(_12639738,0),'Prelude.!!'(_12639738,1))),_12639444,_12639450,_12639456).
'blocked_blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_12603290,_12627916,_12627936,_12602102,_12602120,_12602138,_12643094,_12643100,_12643106):-!,hnf('Prelude.maybe'('Analysis.TermDomain.anyType'(_12602120),partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_12627916,_12602102)),_12643094,_12643100,_12643106).
'blocked_blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_12647546),_12603290,_12627916,_12627936,_12602102,_12602120,_12602138,'FAIL'(_12647546),_12647560,_12647560).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_12603290,_12603308,_12603326,_12602102,_12602120,_12602138,_12647970,_12647976,_12647982):-!,makeShare(_12602120,_12648288),hnf('Prelude.apply'('Prelude.apply'('Analysis.TermDomain.aCons'(_12648288),_12603308),'Prelude.map'(partcall(1,'Analysis.Values.analyseResultValues.anaExpr.16',[_12602138,_12648288,_12602102]),_12603326)),_12647970,_12647976,_12647982).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_12651214),_12603290,_12603308,_12603326,_12602102,_12602120,_12602138,'FAIL'(_12651214),_12651228,_12651228).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Let'(_12607636,_12607654),_12602102,_12602120,_12602138,_12651728,_12651734,_12651740):-makeShare(_12602102,_12652084),makeShare(_12602120,_12652104),makeShare(_12602138,_12652124),hnf('Analysis.Values.analyseResultValues.anaExpr.16'(_12652084,_12652104,'Prelude.++'('Prelude.map'(partcall(1,'Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2',[_12652104,_12652084,_12652124]),_12607636),_12652124),_12607654),_12651728,_12651734,_12651740).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Free'(_12608596,_12608614),_12602102,_12602120,_12602138,_12655782,_12655788,_12655794):-makeShare(_12602120,_12656086),hnf('Analysis.Values.analyseResultValues.anaExpr.16'(_12602102,_12656086,'Analysis.Values.extendEnv'(_12656086,_12602138,'Prelude.map'(partcall(1,'Prelude.fst',[]),_12608596)),_12608614),_12655782,_12655788,_12655794).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Or'(_12609416,_12609434),_12602102,_12602120,_12602138,_12658860,_12658866,_12658872):-makeShare(_12602120,_12659232),makeShare(_12602102,_12659252),makeShare(_12602138,_12659272),hnf('Prelude.apply'('Prelude.apply'('Analysis.TermDomain.lubType'(_12659232),'Analysis.Values.analyseResultValues.anaExpr.16'(_12659252,_12659232,_12659272,_12609416)),'Analysis.Values.analyseResultValues.anaExpr.16'(_12659252,_12659232,_12659272,_12609434)),_12658860,_12658866,_12658872).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Case'(_12610530,_12610548,_12610566),_12602102,_12602120,_12602138,_12663166,_12663172,_12663178):-makeShare(_12602120,_12663412),hnf('Prelude.foldr'('Analysis.TermDomain.lubType'(_12663412),'Analysis.TermDomain.emptyType'(_12663412),'Prelude.map'(partcall(1,'Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3',[_12663412,_12602102,_12602138]),_12610566)),_12663166,_12663172,_12663178).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FlatCurry.Types.Typed'(_12611458,_12611476),_12602102,_12602120,_12602138,_12666678,_12666684,_12666690):-!,hnf('Analysis.Values.analyseResultValues.anaExpr.16'(_12602102,_12602120,_12602138,_12611458),_12666678,_12666684,_12666690).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16_4'('FAIL'(_12668290),_12602102,_12602120,_12602138,'FAIL'(_12668290),_12668304,_12668304).

'Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2'(_12670664,_12670666,_12670668,_12670670,_12670672,_12670674,_12670676):-freeze(_12670674,'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2'(_12670664,_12670666,_12670668,_12670670,_12670672,_12670674,_12670676)).
'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2'(_12670780,_12670798,_12670816,_12670834,_12671924,_12671930,_12671936):-hnf(_12670834,_12674414,_12671930,_12674444),'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2_4'(_12674414,_12670780,_12670798,_12670816,_12671924,_12674444,_12671936).

'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2_4'(_12675058,_12675060,_12675062,_12675064,_12675066,_12675068,_12675070):-freeze(_12675068,'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2_4'(_12675058,_12675060,_12675062,_12675064,_12675066,_12675068,_12675070)).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2_4'('Prelude.(,,)'(_12670950,_12670968,_12670986),_12670780,_12670798,_12670816,'Prelude.(,)'(_12670950,'Analysis.Values.analyseResultValues.anaExpr.16'(_12670798,_12670816,_12670780,_12670986)),_12675478,_12675478):-!.
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda2_4'('FAIL'(_12677500),_12670780,_12670798,_12670816,'FAIL'(_12677500),_12677514,_12677514):-nonvar(_12677500).

'Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3'(_12679878,_12679880,_12679882,_12679884,_12679886,_12679888,_12679890):-freeze(_12679888,'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3'(_12679878,_12679880,_12679882,_12679884,_12679886,_12679888,_12679890)).
'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3'(_12679994,_12680012,_12680030,_12680048,_12680960,_12680966,_12680972):-hnf(_12680048,_12683450,_12680966,_12683480),'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3_4'(_12683450,_12679994,_12680012,_12680030,_12680960,_12683480,_12680972).

'blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3_4'(_12684094,_12684096,_12684098,_12684100,_12684102,_12684104,_12684106):-freeze(_12684104,'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3_4'(_12684094,_12684096,_12684098,_12684100,_12684102,_12684104,_12684106)).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3_4'('FlatCurry.Types.Branch'(_12680164,_12680182),_12679994,_12680012,_12680030,_12684640,_12684646,_12684652):-!,hnf('Analysis.Values.analyseResultValues.anaExpr.16'(_12680012,_12680030,_12679994,_12680182),_12684640,_12684646,_12684652).
'blocked_blocked_Analysis.Values.analyseResultValues.anaExpr.16._\'23lambda3_4'('FAIL'(_12686324),_12679994,_12680012,_12680030,'FAIL'(_12686324),_12686338,_12686338):-nonvar(_12686324).

'Analysis.Values.analyseResultValues.anaresult.16'(_12688370,_12688372,_12688374,_12688376,_12688378,_12688380):-freeze(_12688378,'blocked_Analysis.Values.analyseResultValues.anaresult.16'(_12688370,_12688372,_12688374,_12688376,_12688378,_12688380)).
'blocked_Analysis.Values.analyseResultValues.anaresult.16'(_12688476,_12688494,_12688512,_12689788,_12689794,_12689800):-hnf(_12688512,_12691910,_12689794,_12691934),'blocked_Analysis.Values.analyseResultValues.anaresult.16_3'(_12691910,_12688476,_12688494,_12689788,_12691934,_12689800).

'blocked_Analysis.Values.analyseResultValues.anaresult.16_3'(_12692480,_12692482,_12692484,_12692486,_12692488,_12692490):-freeze(_12692488,'blocked_blocked_Analysis.Values.analyseResultValues.anaresult.16_3'(_12692480,_12692482,_12692484,_12692486,_12692488,_12692490)).
'blocked_blocked_Analysis.Values.analyseResultValues.anaresult.16_3'('FlatCurry.Types.External'(_12688628),_12688476,_12688494,_12693032,_12693038,_12693044):-hnf('Analysis.TermDomain.anyType'(_12688494),_12693032,_12693038,_12693044).
'blocked_blocked_Analysis.Values.analyseResultValues.anaresult.16_3'('FlatCurry.Types.Rule'(_12688822,_12688840),_12688476,_12688494,_12694448,_12694454,_12694460):-!,makeShare(_12688494,_12694680),hnf('Analysis.Values.analyseResultValues.anaExpr.16'(_12688476,_12694680,'Analysis.Values.extendEnv'(_12694680,[],_12688822),_12688840),_12694448,_12694454,_12694460).
'blocked_blocked_Analysis.Values.analyseResultValues.anaresult.16_3'('FAIL'(_12696704),_12688476,_12688494,'FAIL'(_12696704),_12696718,_12696718):-nonvar(_12696704).

'Analysis.Values.prelude'(_12697792,_12697794,_12697796):-freeze(_12697794,'blocked_Analysis.Values.prelude'(_12697792,_12697794,_12697796)).
'blocked_Analysis.Values.prelude'(['^P','^r','^e','^l','^u','^d','^e'],_12698964,_12698964).

'Analysis.Values.analyseResultValues._\'23caseor0'(_12702532,_12702534,_12702536,_12702538,_12702540,_12702542,_12702544,_12702546,_12702548):-freeze(_12702546,'blocked_Analysis.Values.analyseResultValues._\'23caseor0'(_12702532,_12702534,_12702536,_12702538,_12702540,_12702542,_12702544,_12702546,_12702548)).
'blocked_Analysis.Values.analyseResultValues._\'23caseor0'(_12702668,_12702686,_12702704,_12702722,_12702740,_12702758,_12704886,_12704892,_12704898):-hnf(_12702668,_12706996,_12704892,_12707038),'blocked_Analysis.Values.analyseResultValues._\'23caseor0_1'(_12706996,_12702686,_12702704,_12702722,_12702740,_12702758,_12704886,_12707038,_12704898).

'blocked_Analysis.Values.analyseResultValues._\'23caseor0_1'(_12707608,_12707610,_12707612,_12707614,_12707616,_12707618,_12707620,_12707622,_12707624):-freeze(_12707622,freeze(_12707608,'blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1'(_12707608,_12707610,_12707612,_12707614,_12707616,_12707618,_12707620,_12707622,_12707624))).
'blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1'('Prelude.True',_12702686,_12702704,_12702722,_12702740,_12702758,_12708042,_12708048,_12708054):-hnf('Prelude.maybe'('Analysis.Values.analyseResultValues.anaresult.16'(_12702722,_12702740,_12702758),partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_12702686,_12702704)),_12708042,_12708048,_12708054).
'blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1'('Prelude.False',_12702686,_12702704,_12702722,_12702740,_12702758,_12712694,_12712700,_12712706):-!,hnf('Prelude.otherwise',_12715704,_12712700,_12715652),'blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1_Prelude.False_ComplexCase'(_12715704,_12702686,_12702704,_12702722,_12702740,_12702758,_12712694,_12715652,_12712706).

'blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1_Prelude.False_ComplexCase'(_12716444,_12716446,_12716448,_12716450,_12716452,_12716454,_12716456,_12716458,_12716460):-freeze(_12716458,freeze(_12716444,'blocked_blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1_Prelude.False_ComplexCase'(_12716444,_12716446,_12716448,_12716450,_12716452,_12716454,_12716456,_12716458,_12716460))).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_12702686,_12702704,_12702722,_12702740,_12702758,_12716878,_12716884,_12716890):-hnf('Analysis.Values.analyseResultValues.anaresult.16'(_12702722,_12702740,_12702758),_12716878,_12716884,_12716890).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_12702686,_12702704,_12702722,_12702740,_12702758,_12718892,_12718898,_12718904):-!,hnf(reportFailure4PAKCS('Analysis.Values.analyseResultValues._\'23caseor0',['Prelude.False']),_12718892,_12718898,_12718904).
'blocked_blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_12720916),_12702686,_12702704,_12702722,_12702740,_12702758,'FAIL'(_12720916),_12720930,_12720930).
'blocked_blocked_Analysis.Values.analyseResultValues._\'23caseor0_1'('FAIL'(_12721022),_12702686,_12702704,_12702722,_12702740,_12702758,'FAIL'(_12721022),_12721036,_12721036).

:-costCenters(['']).




%%%%% Number of shared variables: 15

