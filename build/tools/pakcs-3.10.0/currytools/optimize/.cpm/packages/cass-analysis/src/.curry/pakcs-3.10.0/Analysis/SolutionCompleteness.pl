%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.Types').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.SolutionCompleteness').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.SolutionCompleteness.solcompAnalysis',solcompAnalysis,0,'Analysis.SolutionCompleteness.solcompAnalysis',nofix,notype).
functiontype('Analysis.SolutionCompleteness.scFunc','Analysis.SolutionCompleteness.scFunc',2,'Analysis.SolutionCompleteness.scFunc',nofix,notype).
functiontype('Analysis.SolutionCompleteness.isFlexDefined','Analysis.SolutionCompleteness.isFlexDefined',1,'Analysis.SolutionCompleteness.isFlexDefined',nofix,notype).
functiontype('Analysis.SolutionCompleteness.isFlexExpr','Analysis.SolutionCompleteness.isFlexExpr',1,'Analysis.SolutionCompleteness.isFlexExpr',nofix,notype).
functiontype('Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1','Analysis.SolutionCompleteness.isFlexExpr._#lambda1',1,'Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1',nofix,notype).
functiontype('Analysis.SolutionCompleteness.showSolComplete',showSolComplete,2,'Analysis.SolutionCompleteness.showSolComplete',nofix,notype).
functiontype('Analysis.SolutionCompleteness.pre','Analysis.SolutionCompleteness.pre',1,'Analysis.SolutionCompleteness.pre',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.SolutionCompleteness.solcompAnalysis'(_20671572,_20671574,_20671576):-freeze(_20671574,'blocked_Analysis.SolutionCompleteness.solcompAnalysis'(_20671572,_20671574,_20671576)).
'blocked_Analysis.SolutionCompleteness.solcompAnalysis'(_20673606,_20673612,_20673618):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^S','^o','^l','^C','^o','^m','^p','^l','^e','^t','^e'],'Prelude.True',partcall(2,'Analysis.SolutionCompleteness.scFunc',[])),_20673606,_20673612,_20673618).

'Analysis.SolutionCompleteness.scFunc'(_20678608,_20678610,_20678612,_20678614,_20678616):-freeze(_20678614,'blocked_Analysis.SolutionCompleteness.scFunc'(_20678608,_20678610,_20678612,_20678614,_20678616)).
'blocked_Analysis.SolutionCompleteness.scFunc'(_20678704,_20678722,_20679228,_20679234,_20679240):-hnf('Prelude.&&'('Analysis.SolutionCompleteness.isFlexDefined'(_20678704),'Prelude.apply'('Prelude.all'(partcall(1,'Prelude.snd',[])),_20678722)),_20679228,_20679234,_20679240).

'Analysis.SolutionCompleteness.isFlexDefined'(_20682764,_20682766,_20682768,_20682770):-freeze(_20682768,'blocked_Analysis.SolutionCompleteness.isFlexDefined'(_20682764,_20682766,_20682768,_20682770)).
'blocked_Analysis.SolutionCompleteness.isFlexDefined'(_20682850,_20688378,_20688384,_20688390):-hnf(_20682850,_20690304,_20688384,_20690316),'blocked_Analysis.SolutionCompleteness.isFlexDefined_1'(_20690304,_20688378,_20690316,_20688390).

'blocked_Analysis.SolutionCompleteness.isFlexDefined_1'(_20690816,_20690818,_20690820,_20690822):-freeze(_20690820,'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1'(_20690816,_20690818,_20690820,_20690822)).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1'('FlatCurry.Types.Func'(_20682966,_20682984,_20683002,_20683020,_20683038),_20691760,_20691766,_20691772):-!,hnf(_20683038,_20694676,_20691766,_20694712),'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'(_20694676,_20682966,_20682984,_20683002,_20683020,_20691760,_20694712,_20691772).

'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'(_20695448,_20695450,_20695452,_20695454,_20695456,_20695458,_20695460,_20695462):-freeze(_20695460,'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'(_20695448,_20695450,_20695452,_20695454,_20695456,_20695458,_20695460,_20695462)).
'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_20683184,_20683202),_20682966,_20682984,_20683002,_20683020,_20695980,_20695986,_20695992):-hnf('Analysis.SolutionCompleteness.isFlexExpr'(_20683202),_20695980,_20695986,_20695992).
'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_20683402),_20682966,_20682984,_20683002,_20683020,_20697884,_20697890,_20697896):-!,hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_20682966),'Prelude.map'(partcall(1,'Analysis.SolutionCompleteness.pre',[]),[[^=,^:,^=],['^s','^u','^c','^c','^e','^s','^s'],[^&],[^&,^>],['^r','^e','^t','^u','^r','^n']])),_20697884,_20697890,_20697896).
'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'('FAIL'(_20706800),_20682966,_20682984,_20683002,_20683020,'FAIL'(_20706800),_20706814,_20706814):-nonvar(_20706800).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1'('FAIL'(_20706902),'FAIL'(_20706902),_20706916,_20706916):-nonvar(_20706902).

'Analysis.SolutionCompleteness.isFlexExpr'(_20708620,_20708622,_20708624,_20708626):-freeze(_20708624,'blocked_Analysis.SolutionCompleteness.isFlexExpr'(_20708620,_20708622,_20708624,_20708626)).
'blocked_Analysis.SolutionCompleteness.isFlexExpr'(_20708706,_20715968,_20715974,_20715980):-hnf(_20708706,_20717786,_20715974,_20717798),'blocked_Analysis.SolutionCompleteness.isFlexExpr_1'(_20717786,_20715968,_20717798,_20715980).

'blocked_Analysis.SolutionCompleteness.isFlexExpr_1'(_20718280,_20718282,_20718284,_20718286):-freeze(_20718284,'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'(_20718280,_20718282,_20718284,_20718286)).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Var'(_20708822),'Prelude.True',_20718758,_20718758).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Lit'(_20708946),'Prelude.True',_20719756,_20719756).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Comb'(_20709070,_20709088,_20709106),_20720776,_20720782,_20720788):-makeShare(_20709088,_20720976),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_20720976),'Analysis.SolutionCompleteness.pre'(['^a','^p','^p','^l','^y'])),'Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_20720976),'Analysis.SolutionCompleteness.pre'(['^c','^o','^m','^m','^i','^t'])),'Prelude.apply'('Prelude.all'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr',[])),_20709106))),_20720776,_20720782,_20720788).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Free'(_20712994,_20713012),_20731348,_20731354,_20731360):-hnf('Analysis.SolutionCompleteness.isFlexExpr'(_20713012),_20731348,_20731354,_20731360).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Let'(_20713212,_20713230),_20732700,_20732706,_20732712):-hnf('Prelude.&&'('Prelude.apply'('Prelude.all'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr',[])),'Prelude.apply'('FlatCurry.Types.expsOfLetBind',_20713212)),'Analysis.SolutionCompleteness.isFlexExpr'(_20713230)),_20732700,_20732706,_20732712).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Or'(_20714004,_20714022),_20735564,_20735570,_20735576):-hnf('Prelude.&&'('Analysis.SolutionCompleteness.isFlexExpr'(_20714004),'Analysis.SolutionCompleteness.isFlexExpr'(_20714022)),_20735564,_20735570,_20735576).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Case'(_20714460,_20714478,_20714496),_20737624,_20737630,_20737636):-hnf('Prelude.&&'('FlatCurry.Types._impl\'23\'3D\'3D\'23Prelude.Eq\'23FlatCurry.Types.CaseType\'23'(_20714460,'FlatCurry.Types.Flex'),'Prelude.apply'('Prelude.all'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr',[])),[_20714478|'Prelude.map'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1',[]),_20714496)])),_20737624,_20737630,_20737636).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Typed'(_20715514,_20715532),_20741372,_20741378,_20741384):-!,hnf('Analysis.SolutionCompleteness.isFlexExpr'(_20715514),_20741372,_20741378,_20741384).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FAIL'(_20742342),'FAIL'(_20742342),_20742356,_20742356):-nonvar(_20742342).

'Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1'(_20744468,_20744470,_20744472,_20744474):-freeze(_20744472,'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1'(_20744468,_20744470,_20744472,_20744474)).
'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1'(_20744554,_20745112,_20745118,_20745124):-hnf(_20744554,_20747362,_20745118,_20747374),'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'(_20747362,_20745112,_20747374,_20745124).

'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'(_20747928,_20747930,_20747932,_20747934):-freeze(_20747932,'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'(_20747928,_20747930,_20747932,_20747934)).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'('FlatCurry.Types.Branch'(_20744670,_20744688),_20748444,_20748450,_20748456):-!,hnf(_20744688,_20748444,_20748450,_20748456).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'('FAIL'(_20749136),'FAIL'(_20749136),_20749150,_20749150):-nonvar(_20749136).

'Analysis.SolutionCompleteness.showSolComplete'(_20751044,_20751046,_20751048,_20751050,_20751052):-freeze(_20751050,'blocked_Analysis.SolutionCompleteness.showSolComplete'(_20751044,_20751046,_20751048,_20751050,_20751052)).
'blocked_Analysis.SolutionCompleteness.showSolComplete'(_20751140,_20751158,_20756368,_20756374,_20756380):-hnf(_20751158,_20758374,_20756374,_20758392),'blocked_Analysis.SolutionCompleteness.showSolComplete_2'(_20758374,_20751140,_20756368,_20758392,_20756380).

'blocked_Analysis.SolutionCompleteness.showSolComplete_2'(_20758912,_20758914,_20758916,_20758918,_20758920):-freeze(_20758918,'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'(_20758912,_20758914,_20758916,_20758918,_20758920)).
'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'('Prelude.True',_20751140,['^s','^o','^l','^u','^t','^i','^o','^n','^ ','^c','^o','^m','^p','^l','^e','^t','^e'],_20759306,_20759306).
'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'('Prelude.False',_20751140,['^m','^a','^y','^b','^e','^ ','^s','^u','^s','^p','^e','^n','^d'],_20763618,_20763618):-!.
'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'('FAIL'(_20766818),_20751140,'FAIL'(_20766818),_20766832,_20766832):-nonvar(_20766818).

'Analysis.SolutionCompleteness.pre'(_20768278,_20768280,_20768282,_20768284):-freeze(_20768282,'blocked_Analysis.SolutionCompleteness.pre'(_20768278,_20768280,_20768282,_20768284)).
'blocked_Analysis.SolutionCompleteness.pre'(_20768364,'Prelude.(,)'(['^P','^r','^e','^l','^u','^d','^e'],_20768364),_20769632,_20769632).

:-costCenters(['']).




%%%%% Number of shared variables: 1

