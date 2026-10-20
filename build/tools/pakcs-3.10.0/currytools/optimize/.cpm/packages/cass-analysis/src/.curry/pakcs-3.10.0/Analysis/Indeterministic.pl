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
'Analysis.Indeterministic.indetAnalysis'(_17841614,_17841616,_17841618):-freeze(_17841616,'blocked_Analysis.Indeterministic.indetAnalysis'(_17841614,_17841616,_17841618)).
'blocked_Analysis.Indeterministic.indetAnalysis'(_17844264,_17844270,_17844276):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^I','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],'Prelude.False',partcall(2,'Analysis.Indeterministic.indetFunc',[])),_17844264,_17844270,_17844276).

'Analysis.Indeterministic.indetFunc'(_17849950,_17849952,_17849954,_17849956,_17849958):-freeze(_17849956,'blocked_Analysis.Indeterministic.indetFunc'(_17849950,_17849952,_17849954,_17849956,_17849958)).
'blocked_Analysis.Indeterministic.indetFunc'(_17850046,_17850064,_17850570,_17850576,_17850582):-hnf('Prelude.||'('Analysis.Indeterministic.hasIndetRules'(_17850046),'Prelude.apply'('Prelude.any'(partcall(1,'Prelude.snd',[])),_17850064)),_17850570,_17850576,_17850582).

'Analysis.Indeterministic.showIndet'(_17853722,_17853724,_17853726,_17853728,_17853730):-freeze(_17853728,'blocked_Analysis.Indeterministic.showIndet'(_17853722,_17853724,_17853726,_17853728,_17853730)).
'blocked_Analysis.Indeterministic.showIndet'(_17853818,_17853836,_17867696,_17867702,_17867708):-hnf(_17853818,_17869306,_17867702,_17869324),'blocked_Analysis.Indeterministic.showIndet_1'(_17869306,_17853836,_17867696,_17869324,_17867708).

'blocked_Analysis.Indeterministic.showIndet_1'(_17869778,_17869780,_17869782,_17869784,_17869786):-freeze(_17869784,'blocked_blocked_Analysis.Indeterministic.showIndet_1'(_17869778,_17869780,_17869782,_17869784,_17869786)).
'blocked_blocked_Analysis.Indeterministic.showIndet_1'('Analysis.Types.AText',_17853836,_17870604,_17870610,_17870616):-hnf(_17853836,_17873204,_17870610,_17873216),'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'(_17873204,_17870604,_17873216,_17870616).

'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'(_17873848,_17873850,_17873852,_17873854):-freeze(_17873852,'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'(_17873848,_17873850,_17873852,_17873854)).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'('Prelude.True',['^i','^m','^p','^u','^r','^e','^ ','^(','^i','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c','^)','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n'],_17874232,_17874232).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'('Prelude.False',['^r','^e','^f','^e','^r','^e','^n','^t','^i','^a','^l','^l','^y','^ ','^t','^r','^a','^n','^s','^p','^a','^r','^e','^n','^t','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n'],_17882024,_17882024):-!.
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.AText_1'('FAIL'(_17889714),'FAIL'(_17889714),_17889728,_17889728):-nonvar(_17889714).
'blocked_blocked_Analysis.Indeterministic.showIndet_1'('Analysis.Types.ANote',_17853836,_17890520,_17890526,_17890532):-!,hnf(_17853836,_17893120,_17890526,_17893132),'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'(_17893120,_17890520,_17893132,_17890532).

'blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'(_17893782,_17893784,_17893786,_17893788):-freeze(_17893786,'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'(_17893782,_17893784,_17893786,_17893788)).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'('Prelude.True',['^i','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],_17894166,_17894166).
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'('Prelude.False',[],_17898120,_17898120):-!.
'blocked_blocked_blocked_Analysis.Indeterministic.showIndet_1_Analysis.Types.ANote_1'('FAIL'(_17898740),'FAIL'(_17898740),_17898754,_17898754):-nonvar(_17898740).
'blocked_blocked_Analysis.Indeterministic.showIndet_1'('FAIL'(_17898810),_17853836,'FAIL'(_17898810),_17898824,_17898824):-nonvar(_17898810).

'Analysis.Indeterministic.hasIndetRules'(_17900460,_17900462,_17900464,_17900466):-freeze(_17900464,'blocked_Analysis.Indeterministic.hasIndetRules'(_17900460,_17900462,_17900464,_17900466)).
'blocked_Analysis.Indeterministic.hasIndetRules'(_17900546,_17901522,_17901528,_17901534):-hnf(_17900546,_17903268,_17901528,_17903280),'blocked_Analysis.Indeterministic.hasIndetRules_1'(_17903268,_17901522,_17903280,_17901534).

'blocked_Analysis.Indeterministic.hasIndetRules_1'(_17903750,_17903752,_17903754,_17903756):-freeze(_17903754,'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1'(_17903750,_17903752,_17903754,_17903756)).
'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1'('FlatCurry.Types.Func'(_17900662,_17900680,_17900698,_17900716,_17900734),_17904664,_17904670,_17904676):-!,hnf(_17900734,_17907400,_17904670,_17907436),'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'(_17907400,_17900662,_17900680,_17900698,_17900716,_17904664,_17907436,_17904676).

'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'(_17908142,_17908144,_17908146,_17908148,_17908150,_17908152,_17908154,_17908156):-freeze(_17908154,'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'(_17908142,_17908144,_17908146,_17908148,_17908150,_17908152,_17908154,_17908156)).
'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_17900880,_17900898),_17900662,_17900680,_17900698,_17900716,_17908674,_17908680,_17908686):-hnf('Analysis.Indeterministic.indetInExpr'(_17900898),_17908674,_17908680,_17908686).
'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_17901098),_17900662,_17900680,_17900698,_17900716,_17910524,_17910530,_17910536):-!,hnf('Analysis.Indeterministic.isIndetFunction'(_17900662),_17910524,_17910530,_17910536).
'blocked_blocked_blocked_Analysis.Indeterministic.hasIndetRules_1_FlatCurry.Types.Func_5'('FAIL'(_17911898),_17900662,_17900680,_17900698,_17900716,'FAIL'(_17911898),_17911912,_17911912):-nonvar(_17911898).
'blocked_blocked_Analysis.Indeterministic.hasIndetRules_1'('FAIL'(_17912000),'FAIL'(_17912000),_17912014,_17912014):-nonvar(_17912000).

'Analysis.Indeterministic.indetInExpr'(_17913566,_17913568,_17913570,_17913572):-freeze(_17913570,'blocked_Analysis.Indeterministic.indetInExpr'(_17913566,_17913568,_17913570,_17913572)).
'blocked_Analysis.Indeterministic.indetInExpr'(_17913652,_17917208,_17917214,_17917220):-hnf(_17913652,_17918882,_17917214,_17918894),'blocked_Analysis.Indeterministic.indetInExpr_1'(_17918882,_17917208,_17918894,_17917220).

'blocked_Analysis.Indeterministic.indetInExpr_1'(_17919352,_17919354,_17919356,_17919358):-freeze(_17919356,'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'(_17919352,_17919354,_17919356,_17919358)).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Var'(_17913768),'Prelude.False',_17919830,_17919830).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Lit'(_17913892),'Prelude.False',_17920810,_17920810).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Comb'(_17914016,_17914034,_17914052),_17921812,_17921818,_17921824):-hnf('Prelude.||'('Analysis.Indeterministic.isIndetFunction'(_17914034),'Prelude.apply'('Prelude.any'(partcall(1,'Analysis.Indeterministic.indetInExpr',[])),_17914052)),_17921812,_17921818,_17921824).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Free'(_17914664,_17914682),_17924248,_17924254,_17924260):-hnf('Analysis.Indeterministic.indetInExpr'(_17914682),_17924248,_17924254,_17924260).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Let'(_17914882,_17914900),_17925552,_17925558,_17925564):-hnf('Prelude.||'('Prelude.apply'('Prelude.any'(partcall(1,'Analysis.Indeterministic.indetInExpr',[])),'Prelude.apply'('FlatCurry.Types.expsOfLetBind',_17914882)),'Analysis.Indeterministic.indetInExpr'(_17914900)),_17925552,_17925558,_17925564).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Or'(_17915674,_17915692),_17928344,_17928350,_17928356):-hnf('Prelude.||'('Analysis.Indeterministic.indetInExpr'(_17915674),'Analysis.Indeterministic.indetInExpr'(_17915692)),_17928344,_17928350,_17928356).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Case'(_17916130,_17916148,_17916166),_17930332,_17930338,_17930344):-hnf('Prelude.||'('Analysis.Indeterministic.indetInExpr'(_17916148),'Prelude.apply'('Prelude.any'(partcall(1,'Analysis.Indeterministic.indetInExpr.indetInBranch.44',[])),_17916166)),_17930332,_17930338,_17930344).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FlatCurry.Types.Typed'(_17916778,_17916796),_17932858,_17932864,_17932870):-!,hnf('Analysis.Indeterministic.indetInExpr'(_17916778),_17932858,_17932864,_17932870).
'blocked_blocked_Analysis.Indeterministic.indetInExpr_1'('FAIL'(_17933780),'FAIL'(_17933780),_17933794,_17933794):-nonvar(_17933780).

'Analysis.Indeterministic.indetInExpr.indetInBranch.44'(_17935992,_17935994,_17935996,_17935998):-freeze(_17935996,'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44'(_17935992,_17935994,_17935996,_17935998)).
'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44'(_17936078,_17936726,_17936732,_17936738):-hnf(_17936078,_17939012,_17936732,_17939024),'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'(_17939012,_17936726,_17939024,_17936738).

'blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'(_17939584,_17939586,_17939588,_17939590):-freeze(_17939588,'blocked_blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'(_17939584,_17939586,_17939588,_17939590)).
'blocked_blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'('FlatCurry.Types.Branch'(_17936194,_17936212),_17940100,_17940106,_17940112):-!,hnf('Analysis.Indeterministic.indetInExpr'(_17936212),_17940100,_17940106,_17940112).
'blocked_blocked_Analysis.Indeterministic.indetInExpr.indetInBranch.44_1'('FAIL'(_17941124),'FAIL'(_17941124),_17941138,_17941138):-nonvar(_17941124).

'Analysis.Indeterministic.isIndetFunction'(_17942842,_17942844,_17942846,_17942848):-freeze(_17942846,'blocked_Analysis.Indeterministic.isIndetFunction'(_17942842,_17942844,_17942846,_17942848)).
'blocked_Analysis.Indeterministic.isIndetFunction'(_17942928,_17979856,_17979862,_17979868):-hnf(_17942928,_17981674,_17979862,_17981686),'blocked_Analysis.Indeterministic.isIndetFunction_1'(_17981674,_17979856,_17981686,_17979868).

'blocked_Analysis.Indeterministic.isIndetFunction_1'(_17982168,_17982170,_17982172,_17982174):-freeze(_17982172,'blocked_blocked_Analysis.Indeterministic.isIndetFunction_1'(_17982168,_17982170,_17982172,_17982174)).
'blocked_blocked_Analysis.Indeterministic.isIndetFunction_1'('Prelude.(,)'(_17943044,_17943062),_17982538,_17982544,_17982550):-!,makeShare(_17943044,_17983618),makeShare(_17943062,_17983638),hnf('Prelude.||'('Prelude.&&'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_17983618),[['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^a','^r','^c','^h',^.,'^S','^e','^t','^F','^u','^n','^c','^t','^i','^o','^n','^s'],['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^t','^F','^u','^n','^c','^t','^i','^o','^n','^s']]),'Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_17983638),[['^s','^e','^l','^e','^c','^t'],['^s','^e','^l','^e','^c','^t','^V','^a','^l','^u','^e']])),'Prelude.||'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_17983618),[['^S','^y','^s','^t','^e','^m',^.,'^I','^O',^.,'^U','^n','^s','^a','^f','^e'],['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^a','^r','^c','^h',^.,'^U','^n','^s','^a','^f','^e'],['^C','^o','^n','^t','^r','^o','^l',^.,'^A','^l','^l','^V','^a','^l','^u','^e','^s'],['^C','^o','^n','^t','^r','^o','^l',^.,'^F','^i','^n','^d','^a','^l','^l'],['^C','^o','^n','^t','^r','^o','^l',^.,'^S','^e','^a','^r','^c','^h',^.,'^S','^e','^a','^r','^c','^h','^T','^r','^e','^e',^.,'^U','^n','^s','^a','^f','^e']]),'Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_17983618,['^N','^e','^t','^w','^o','^r','^k',^.,'^P','^o','^r','^t','^s']),'Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_17983638),[['^s','^e','^n','^d'],['^t','^i','^m','^e','^o','^u','^t','^O','^n','^S','^t','^r','^e','^a','^m'],['^c','^h','^o','^i','^c','^e','^S','^P','^E','^P']])))),_17982538,_17982544,_17982550).
'blocked_blocked_Analysis.Indeterministic.isIndetFunction_1'('FAIL'(_18035242),'FAIL'(_18035242),_18035256,_18035256):-nonvar(_18035242).

:-costCenters(['']).




%%%%% Number of shared variables: 2

