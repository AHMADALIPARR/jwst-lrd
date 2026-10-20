%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.Types').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.Indeterministic').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.Indeterministic.indetAnalysis',indetAnalysis,0,'Analysis.Indeterministic.indetAnalysis',nofix,notype).
functiontype('Analysis.Indeterministic.indetFunc','Analysis.Indeterministic.indetFunc',2,'Analysis.Indeterministic.indetFunc',nofix,notype).
functiontype('Analysis.Indeterministic.showIndet',showIndet,2,'Analysis.Indeterministic.showIndet',nofix,notype).
functiontype('Analysis.Indeterministic.hasIndetRules','Analysis.Indeterministic.hasIndetRules',1,'Analysis.Indeterministic.hasIndetRules',nofix,notype).
functiontype('Analysis.Indeterministic.indetInExpr','Analysis.Indeterministic.indetInExpr',1,'Analysis.Indeterministic.indetInExpr',nofix,notype).
functiontype('Analysis.Indeterministic.indetInExpr.indetInBranch.44','Analysis.Indeterministic.indetInExpr.indetInBranch.44',1,'Analysis.Indeterministic.indetInExpr.indetInBranch.44',nofix,notype).
functiontype('Analysis.Indeterministic.isIndetFunction','Analysis.Indeterministic.isIndetFunction',1,'Analysis.Indeterministic.isIndetFunction',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.Indeterministic.indetAnalysis'(_38359474,_38359476,_38359478):-freeze(_38359476,'blocked_Analysis.Indeterministic.indetAnalysis'(_38359474,_38359476,_38359478)).
'blocked_Analysis.Indeterministic.indetAnalysis'(_38362124,_38362130,_38362136):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^I','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],'Prelude.False',partcall(2,'Analysis.Indeterministic.indetFunc',[])),_38362124,_38362130,_38362136).

'Analysis.Indeterministic.indetFunc'(_38367810,_38367812,_38367814,_38367816,_38367818):-freeze(_38367816,'blocked_Analysis.Indeterministic.indetFunc'(_38367810,_38367812,_38367814,_38367816,_38367818)).
'blocked_Analysis.Indeterministic.indetFunc'(_38367906,_38367924,_38368430,_38368436,_38368442):-hnf('Prelude.||'('Analysis.Indeterministic.hasIndetRules'(_38367906),'Prelude.apply'('Prelude.any'(partcall(1,'Prelude.snd',[])),_38367924)),_38368430,_38368436,_38368442).

'Analysis.Indeterministic.showIndet'(_38371582,_38371584,_38371586,_38371588,_38371590):-freeze(_38371588,'blocked_Analysis.Indeterministic.showIndet'(_38371582,_38371584,_38371586,_38371588,_38371590)).
'blocked_Analysis.Indeterministic.showIndet'(_38371678,_38371696,_38385556,_38385562,_38385568):-hnf(_38371678,_38387166,_38385562,_38387184),'blocked_Analysis.Indeterministic.showIndet_1'(_38387166,_38371696,_38385556,_38387184,_38385568).

'blocked_Analysis.Indeterministic.showIndet_1'(_38387638,_38387640,_38387642,_38387644,_38387646):-freeze(_38387644,'blocked_blocked_Analysis.Indeterministic.showIndet_1'(_38387638,_38387640,_38387642,_38387644,_38387646)).
'blocked_blocked_Analysis.Indeterministic.showIndet_1'('Analysis.Types.AText',_38371696,_38388464,_38388470,_38388476):-hnf(_38371696,_38391064,_38388470,_38391076),'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'(_38391064,_38388464,_38391076,_38388476).

'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'(_38391708,_38391710,_38391712,_38391714):-freeze(_38391712,'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'(_38391708,_38391710,_38391712,_38391714)).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'('Prelude.True',['^i','^m','^p','^u','^r','^e','^ ','^(','^i','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c','^)','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n'],_38392092,_38392092).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'('Prelude.False',['^r','^e','^f','^e','^r','^e','^n','^t','^i','^a','^l','^l','^y','^ ','^t','^r','^a','^n','^s','^p','^a','^r','^e','^n','^t','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n'],_38399884,_38399884):-!.
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'('FAIL'(_38407574),'FAIL'(_38407574),_38407588,_38407588):-nonvar(_38407574).
'blocked_blocked_Analysis.Indeterministic.showIndet_1'('Analysis.Types.ANote',_38371696,_38408380,_38408386,_38408392):-!,hnf(_38371696,_38410980,_38408386,_38410992),'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'(_38410980,_38408380,_38410992,_38408392).

'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'(_38411642,_38411644,_38411646,_38411648):-freeze(_38411646,'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'(_38411642,_38411644,_38411646,_38411648)).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'('Prelude.True',['^i','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],_38412026,_38412026).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'('Prelude.False',[],_38415980,_38415980):-!.
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'('FAIL'(_38416600),'FAIL'(_38416600),_38416614,_38416614):-nonvar(_38416600).
'blocked_blocked_Analysis.Indeterministic.showIndet_1'('FAIL'(_38416670),_38371696,'FAIL'(_38416670),_38416684,_38416684):-nonvar(_38416670).

'Analysis.Indeterministic.hasIndetRules'(_38418320,_38418322,_38418324,_38418326):-freeze(_38418324,'blocked_Analysis.Indeterministic.hasIndetRules'(_38418320,_38418322,_38418324,_38418326)).
'blocked_Analysis.Indeterministic.hasIndetRules'(_38418406,_38419382,_38419388,_38419394):-hnf(_38418406,_38421128,_38419388,_38421140),'blocked_Analysis.Indeterministic.hasIndetRules_1'(_38421128,_38419382,_38421140,_38419394).

'blocked_Analysis.Indeterministic.hasIndetRules_1'(_38421610,_38421612,_38421614,_38421616):-freeze(_38421614,'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1'(_38421610,_38421612,_38421614,_38421616)).
'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1'('FlatCurry.Types.Func'(_38418522,_38418540,_38418558,_38418576,_38418594),_38422524,_38422530,_38422536):-!,hnf(_38418594,_38425260,_38422530,_38425296),'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'(_38425260,_38418522,_38418540,_38418558,_38418576,_38422524,_38425296,_38422536).

'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'(_38426002,_38426004,_38426006,_38426008,_38426010,_38426012,_38426014,_38426016):-freeze(_38426014,'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'(_38426002,_38426004,_38426006,_38426008,_38426010,_38426012,_38426014,_38426016)).
'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_38418740,_38418758),_38418522,_38418540,_38418558,_38418576,_38426534,_38426540,_38426546):-hnf('Analysis.Indeterministic.indetInExpr'(_38418758),_38426534,_38426540,_38426546).
'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_38418958),_38418522,_38418540,_38418558,_38418576,_38428384,_38428390,_38428396):-!,hnf('Analysis.Indeterministic.isIndetFunction'(_38418522),_38428384,_38428390,_38428396).
'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'('FAIL'(_38429758),_38418522,_38418540,_38418558,_38418576,'FAIL'(_38429758),_38429772,_38429772):-nonvar(_38429758).
'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1'('FAIL'(_38429860),'FAIL'(_38429860),_38429874,_38429874):-nonvar(_38429860).

'Analysis.Indeterministic.indetInExpr'(_38431426,_38431428,_38431430,_38431432):-freeze(_38431430,'blocked_Analysis.Indeterministic.indetInExpr'(_38431426,_38431428,_38431430,_38431432)).
'blocked_Analysis.Indeterministic.indetInExpr'(_38431512,_38435068,_38435074,_38435080):-hnf(_38431512,_38436742,_38435074,_38436754),'blocked_Analysis.Indeterministic.indetInExpr_1'(_38436742,_38435068,_38436754,_38435080).

'blocked_Analysis.Indeterministic.indetInExpr_1'(_38437212,_38437214,_38437216,_38437218):-freeze(_38437216,'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'(_38437212,_38437214,_38437216,_38437218)).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Var'(_38431628),'Prelude.False',_38437690,_38437690).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Lit'(_38431752),'Prelude.False',_38438670,_38438670).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Comb'(_38431876,_38431894,_38431912),_38439672,_38439678,_38439684):-hnf('Prelude.||'('Analysis.Indeterministic.isIndetFunction'(_38431894),'Prelude.apply'('Prelude.any'(partcall(1,'Analysis.Indeterministic.indetInExpr',[])),_38431912)),_38439672,_38439678,_38439684).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Free'(_38432524,_38432542),_38442108,_38442114,_38442120):-hnf('Analysis.Indeterministic.indetInExpr'(_38432542),_38442108,_38442114,_38442120).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Let'(_38432742,_38432760),_38443412,_38443418,_38443424):-hnf('Prelude.||'('Prelude.apply'('Prelude.any'(partcall(1,'Analysis.Indeterministic.indetInExpr',[])),'Prelude.apply'('FlatCurry.Types.expsOfLetBind',_38432742)),'Analysis.Indeterministic.indetInExpr'(_38432760)),_38443412,_38443418,_38443424).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Or'(_38433534,_38433552),_38446204,_38446210,_38446216):-hnf('Prelude.||'('Analysis.Indeterministic.indetInExpr'(_38433534),'Analysis.Indeterministic.indetInExpr'(_38433552)),_38446204,_38446210,_38446216).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Case'(_38433990,_38434008,_38434026),_38448192,_38448198,_38448204):-hnf('Prelude.||'('Analysis.Indeterministic.indetInExpr'(_38434008),'Prelude.apply'('Prelude.any'(partcall(1,'Analysis.Indeterministic.indetInExpr.indetInBranch.44',[])),_38434026)),_38448192,_38448198,_38448204).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Typed'(_38434638,_38434656),_38450718,_38450724,_38450730):-!,hnf('Analysis.Indeterministic.indetInExpr'(_38434638),_38450718,_38450724,_38450730).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FAIL'(_38451640),'FAIL'(_38451640),_38451654,_38451654):-nonvar(_38451640).

'Analysis.Indeterministic.indetInExpr.indetInBranch.44'(_38453852,_38453854,_38453856,_38453858):-freeze(_38453856,'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44'(_38453852,_38453854,_38453856,_38453858)).
'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44'(_38453938,_38454586,_38454592,_38454598):-hnf(_38453938,_38456872,_38454592,_38456884),'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'(_38456872,_38454586,_38456884,_38454598).

'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'(_38457444,_38457446,_38457448,_38457450):-freeze(_38457448,'blocked_blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'(_38457444,_38457446,_38457448,_38457450)).
'blocked_blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'('FlatCurry.Types.Branch'(_38454054,_38454072),_38457960,_38457966,_38457972):-!,hnf('Analysis.Indeterministic.indetInExpr'(_38454072),_38457960,_38457966,_38457972).
'blocked_blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'('FAIL'(_38458984),'FAIL'(_38458984),_38458998,_38458998):-nonvar(_38458984).

'Analysis.Indeterministic.isIndetFunction'(_38460702,_38460704,_38460706,_38460708):-freeze(_38460706,'blocked_Analysis.Indeterministic.isIndetFunction'(_38460702,_38460704,_38460706,_38460708)).
'blocked_Analysis.Indeterministic.isIndetFunction'(_38460788,_38497716,_38497722,_38497728):-hnf(_38460788,_38499534,_38497722,_38499546),'blocked_Analysis.Indeterministic.isIndetFunction_1'(_38499534,_38497716,_38499546,_38497728).

'blocked_Analysis.Indeterministic.isIndetFunction_1'(_38500028,_38500030,_38500032,_38500034):-freeze(_38500032,'blocked_blocked_Analysis.Indeterministic.isIndetFunction_1'(_38500028,_38500030,_38500032,_38500034)).
'blocked_blocked_Analysis.Indeterministic.isIndetFunction_1'('Prelude.(,)'(_38460904,_38460922),_38500398,_38500404,_38500410):-!,makeShare(_38460904,_38501478),makeShare(_38460922,_38501498),hnf('Prelude.||'('Prelude.&&'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_38501478),[['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^a','^r','^c','^h',^.,'^S','^e','^t','^F','^u','^n','^c','^t','^i','^o','^n','^s'],['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^t','^F','^u','^n','^c','^t','^i','^o','^n','^s']]),'Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_38501498),[['^s','^e','^l','^e','^c','^t'],['^s','^e','^l','^e','^c','^t','^V','^a','^l','^u','^e']])),'Prelude.||'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_38501478),[['^S','^y','^s','^t','^e','^m',^.,'^I','^O',^.,'^U','^n','^s','^a','^f','^e'],['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^a','^r','^c','^h',^.,'^U','^n','^s','^a','^f','^e'],['^C','^o','^n','^t','^r','^o','^l',^.,'^A','^l','^l','^V','^a','^l','^u','^e','^s'],['^C','^o','^n','^t','^r','^o','^l',^.,'^F','^i','^n','^d','^a','^l','^l'],['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^a','^r','^c','^h',^.,'^S','^e','^a','^r','^c','^h','^T','^r','^e','^e',^.,'^U','^n','^s','^a','^f','^e']]),'Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_38501478,['^N','^e','^t','^w','^o','^r','^k',^.,'^P','^o','^r','^t','^s']),'Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_38501498),[['^s','^e','^n','^d'],['^t','^i','^m','^e','^o','^u','^t','^O','^n','^S','^t','^r','^e','^a','^m'],['^c','^h','^o','^i','^c','^e','^S','^P','^E','^P']])))),_38500398,_38500404,_38500410).
'blocked_blocked_Analysis.Indeterministic.isIndetFunction_1'('FAIL'(_38553102),'FAIL'(_38553102),_38553116,_38553116):-nonvar(_38553102).

:-costCenters(['']).




%%%%% Number of shared variables: 2

