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
'Analysis.SolutionCompleteness.solcompAnalysis'(_11248612,_11248614,_11248616):-freeze(_11248614,'blocked_Analysis.SolutionCompleteness.solcompAnalysis'(_11248612,_11248614,_11248616)).
'blocked_Analysis.SolutionCompleteness.solcompAnalysis'(_11250646,_11250652,_11250658):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^S','^o','^l','^C','^o','^m','^p','^l','^e','^t','^e'],'Prelude.True',partcall(2,'Analysis.SolutionCompleteness.scFunc',[])),_11250646,_11250652,_11250658).

'Analysis.SolutionCompleteness.scFunc'(_11255648,_11255650,_11255652,_11255654,_11255656):-freeze(_11255654,'blocked_Analysis.SolutionCompleteness.scFunc'(_11255648,_11255650,_11255652,_11255654,_11255656)).
'blocked_Analysis.SolutionCompleteness.scFunc'(_11255744,_11255762,_11256268,_11256274,_11256280):-hnf('Prelude.&&'('Analysis.SolutionCompleteness.isFlexDefined'(_11255744),'Prelude.apply'('Prelude.all'(partcall(1,'Prelude.snd',[])),_11255762)),_11256268,_11256274,_11256280).

'Analysis.SolutionCompleteness.isFlexDefined'(_11259804,_11259806,_11259808,_11259810):-freeze(_11259808,'blocked_Analysis.SolutionCompleteness.isFlexDefined'(_11259804,_11259806,_11259808,_11259810)).
'blocked_Analysis.SolutionCompleteness.isFlexDefined'(_11259890,_11265418,_11265424,_11265430):-hnf(_11259890,_11267344,_11265424,_11267356),'blocked_Analysis.SolutionCompleteness.isFlexDefined_1'(_11267344,_11265418,_11267356,_11265430).

'blocked_Analysis.SolutionCompleteness.isFlexDefined_1'(_11267856,_11267858,_11267860,_11267862):-freeze(_11267860,'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1'(_11267856,_11267858,_11267860,_11267862)).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1'('FlatCurry.Types.Func'(_11260006,_11260024,_11260042,_11260060,_11260078),_11268800,_11268806,_11268812):-!,hnf(_11260078,_11271716,_11268806,_11271752),'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'(_11271716,_11260006,_11260024,_11260042,_11260060,_11268800,_11271752,_11268812).

'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'(_11272488,_11272490,_11272492,_11272494,_11272496,_11272498,_11272500,_11272502):-freeze(_11272500,'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'(_11272488,_11272490,_11272492,_11272494,_11272496,_11272498,_11272500,_11272502)).
'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_11260224,_11260242),_11260006,_11260024,_11260042,_11260060,_11273020,_11273026,_11273032):-hnf('Analysis.SolutionCompleteness.isFlexExpr'(_11260242),_11273020,_11273026,_11273032).
'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_11260442),_11260006,_11260024,_11260042,_11260060,_11274924,_11274930,_11274936):-!,hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_11260006),'Prelude.map'(partcall(1,'Analysis.SolutionCompleteness.pre',[]),[[^=,^:,^=],['^s','^u','^c','^c','^e','^s','^s'],[^&],[^&,^>],['^r','^e','^t','^u','^r','^n']])),_11274924,_11274930,_11274936).
'blocked_blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1_FlatCurry.Types.Func_5'('FAIL'(_11283840),_11260006,_11260024,_11260042,_11260060,'FAIL'(_11283840),_11283854,_11283854):-nonvar(_11283840).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexDefined_1'('FAIL'(_11283942),'FAIL'(_11283942),_11283956,_11283956):-nonvar(_11283942).

'Analysis.SolutionCompleteness.isFlexExpr'(_11285660,_11285662,_11285664,_11285666):-freeze(_11285664,'blocked_Analysis.SolutionCompleteness.isFlexExpr'(_11285660,_11285662,_11285664,_11285666)).
'blocked_Analysis.SolutionCompleteness.isFlexExpr'(_11285746,_11293008,_11293014,_11293020):-hnf(_11285746,_11294826,_11293014,_11294838),'blocked_Analysis.SolutionCompleteness.isFlexExpr_1'(_11294826,_11293008,_11294838,_11293020).

'blocked_Analysis.SolutionCompleteness.isFlexExpr_1'(_11295320,_11295322,_11295324,_11295326):-freeze(_11295324,'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'(_11295320,_11295322,_11295324,_11295326)).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Var'(_11285862),'Prelude.True',_11295798,_11295798).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Lit'(_11285986),'Prelude.True',_11296796,_11296796).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Comb'(_11286110,_11286128,_11286146),_11297816,_11297822,_11297828):-makeShare(_11286128,_11298016),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_11298016),'Analysis.SolutionCompleteness.pre'(['^a','^p','^p','^l','^y'])),'Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_11298016),'Analysis.SolutionCompleteness.pre'(['^c','^o','^m','^m','^i','^t'])),'Prelude.apply'('Prelude.all'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr',[])),_11286146))),_11297816,_11297822,_11297828).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Free'(_11290034,_11290052),_11308388,_11308394,_11308400):-hnf('Analysis.SolutionCompleteness.isFlexExpr'(_11290052),_11308388,_11308394,_11308400).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Let'(_11290252,_11290270),_11309740,_11309746,_11309752):-hnf('Prelude.&&'('Prelude.apply'('Prelude.all'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr',[])),'Prelude.apply'('FlatCurry.Types.expsOfLetBind',_11290252)),'Analysis.SolutionCompleteness.isFlexExpr'(_11290270)),_11309740,_11309746,_11309752).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Or'(_11291044,_11291062),_11312604,_11312610,_11312616):-hnf('Prelude.&&'('Analysis.SolutionCompleteness.isFlexExpr'(_11291044),'Analysis.SolutionCompleteness.isFlexExpr'(_11291062)),_11312604,_11312610,_11312616).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Case'(_11291500,_11291518,_11291536),_11314664,_11314670,_11314676):-hnf('Prelude.&&'('FlatCurry.Types._impl\'23\'3D\'3D\'23Prelude.Eq\'23FlatCurry.Types.CaseType\'23'(_11291500,'FlatCurry.Types.Flex'),'Prelude.apply'('Prelude.all'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr',[])),[_11291518|'Prelude.map'(partcall(1,'Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1',[]),_11291536)])),_11314664,_11314670,_11314676).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FlatCurry.Types.Typed'(_11292554,_11292572),_11318412,_11318418,_11318424):-!,hnf('Analysis.SolutionCompleteness.isFlexExpr'(_11292554),_11318412,_11318418,_11318424).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr_1'('FAIL'(_11319382),'FAIL'(_11319382),_11319396,_11319396):-nonvar(_11319382).

'Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1'(_11321508,_11321510,_11321512,_11321514):-freeze(_11321512,'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1'(_11321508,_11321510,_11321512,_11321514)).
'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1'(_11321594,_11322152,_11322158,_11322164):-hnf(_11321594,_11324402,_11322158,_11324414),'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'(_11324402,_11322152,_11324414,_11322164).

'blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'(_11324968,_11324970,_11324972,_11324974):-freeze(_11324972,'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'(_11324968,_11324970,_11324972,_11324974)).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'('FlatCurry.Types.Branch'(_11321710,_11321728),_11325484,_11325490,_11325496):-!,hnf(_11321728,_11325484,_11325490,_11325496).
'blocked_blocked_Analysis.SolutionCompleteness.isFlexExpr._\'23lambda1_1'('FAIL'(_11326176),'FAIL'(_11326176),_11326190,_11326190):-nonvar(_11326176).

'Analysis.SolutionCompleteness.showSolComplete'(_11328084,_11328086,_11328088,_11328090,_11328092):-freeze(_11328090,'blocked_Analysis.SolutionCompleteness.showSolComplete'(_11328084,_11328086,_11328088,_11328090,_11328092)).
'blocked_Analysis.SolutionCompleteness.showSolComplete'(_11328180,_11328198,_11333408,_11333414,_11333420):-hnf(_11328198,_11335414,_11333414,_11335432),'blocked_Analysis.SolutionCompleteness.showSolComplete_2'(_11335414,_11328180,_11333408,_11335432,_11333420).

'blocked_Analysis.SolutionCompleteness.showSolComplete_2'(_11335952,_11335954,_11335956,_11335958,_11335960):-freeze(_11335958,'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'(_11335952,_11335954,_11335956,_11335958,_11335960)).
'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'('Prelude.True',_11328180,['^s','^o','^l','^u','^t','^i','^o','^n','^ ','^c','^o','^m','^p','^l','^e','^t','^e'],_11336346,_11336346).
'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'('Prelude.False',_11328180,['^m','^a','^y','^b','^e','^ ','^s','^u','^s','^p','^e','^n','^d'],_11340658,_11340658):-!.
'blocked_blocked_Analysis.SolutionCompleteness.showSolComplete_2'('FAIL'(_11343858),_11328180,'FAIL'(_11343858),_11343872,_11343872):-nonvar(_11343858).

'Analysis.SolutionCompleteness.pre'(_11345318,_11345320,_11345322,_11345324):-freeze(_11345322,'blocked_Analysis.SolutionCompleteness.pre'(_11345318,_11345320,_11345322,_11345324)).
'blocked_Analysis.SolutionCompleteness.pre'(_11345404,'Prelude.(,)'(['^P','^r','^e','^l','^u','^d','^e'],_11345404),_11346672,_11346672).

:-costCenters(['']).




%%%%% Number of shared variables: 1

