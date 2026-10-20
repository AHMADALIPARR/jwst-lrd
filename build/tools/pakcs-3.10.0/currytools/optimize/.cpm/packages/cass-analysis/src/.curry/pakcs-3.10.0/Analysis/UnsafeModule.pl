%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.Types').
:-importModule('Data.List').
:-importModule('FlatCurry.Goodies').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.UnsafeModule').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.UnsafeModule.unsafeModuleAnalysis',unsafeModuleAnalysis,0,'Analysis.UnsafeModule.unsafeModuleAnalysis',nofix,notype).
functiontype('Analysis.UnsafeModule.showUnsafe',showUnsafe,2,'Analysis.UnsafeModule.showUnsafe',nofix,notype).
functiontype('Analysis.UnsafeModule.importsUnsafe','Analysis.UnsafeModule.importsUnsafe',2,'Analysis.UnsafeModule.importsUnsafe',nofix,notype).
functiontype('Analysis.UnsafeModule.importsUnsafe._\'23caseor0','Analysis.UnsafeModule.importsUnsafe._#caseor0',2,'Analysis.UnsafeModule.importsUnsafe._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.UnsafeModule.unsafeModuleAnalysis'(_15988036,_15988038,_15988040):-freeze(_15988038,'blocked_Analysis.UnsafeModule.unsafeModuleAnalysis'(_15988036,_15988038,_15988040)).
'blocked_Analysis.UnsafeModule.unsafeModuleAnalysis'(_15990140,_15990146,_15990152):-hnf('Analysis.Types.dependencyModuleAnalysis'(['^U','^n','^s','^a','^f','^e','^M','^o','^d','^u','^l','^e'],partcall(2,'Analysis.UnsafeModule.importsUnsafe',[])),_15990140,_15990146,_15990152).

'Analysis.UnsafeModule.showUnsafe'(_15995000,_15995002,_15995004,_15995006,_15995008):-freeze(_15995006,'blocked_Analysis.UnsafeModule.showUnsafe'(_15995000,_15995002,_15995004,_15995006,_15995008)).
'blocked_Analysis.UnsafeModule.showUnsafe'(_15995096,_15995114,_16008006,_16008012,_16008018):-makeShare(_15995114,_16005368),hnf(_16005368,_16009544,_16008012,_16009568),'blocked_Analysis.UnsafeModule.showUnsafe_2'(_16009544,_15995096,_16009544,_16008006,_16009568,_16008018).

'blocked_Analysis.UnsafeModule.showUnsafe_2'(_16010030,_16010032,_16010034,_16010036,_16010038,_16010040):-freeze(_16010038,'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'(_16010030,_16010032,_16010034,_16010036,_16010038,_16010040)).
'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'([],_15995096,_16005368,['^s','^a','^f','^e'],_16010298,_16010298).
'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'([_15995946|_15995964],_15995096,_16005368,_16012200,_16012206,_16012212):-!,hnf(_15995096,_16014226,_16012206,_16014256),'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'(_16014226,_15995946,_15995964,_16005368,_16012200,_16014256,_16012212).

'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'(_16014816,_16014818,_16014820,_16014822,_16014824,_16014826,_16014828):-freeze(_16014826,'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'(_16014816,_16014818,_16014820,_16014822,_16014824,_16014826,_16014828)).
'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'('Analysis.Types.ANote',_15995946,_15995964,_16005368,['^u','^n','^s','^a','^f','^e'],_16015326,_16015326).
'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'('Analysis.Types.AText',_15995946,_15995964,_16005368,_16018070,_16018076,_16018082):-!,hnf(_15995964,_16021118,_16018076,_16021142),'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'(_16021118,_15995946,_16005368,_16018070,_16021142,_16018082).

'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'(_16021880,_16021882,_16021884,_16021886,_16021888,_16021890):-freeze(_16021888,'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'(_16021880,_16021882,_16021884,_16021886,_16021888,_16021890)).
'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'([],_15995946,_16005368,_16022142,_16022148,_16022154):-hnf('Prelude.++'(['^u','^n','^s','^a','^f','^e','^ ','^(','^d','^u','^e','^ ','^t','^o','^ ','^m','^o','^d','^u','^l','^e','^ '],'Prelude.++'(_15995946,['^)'])),_16022142,_16022148,_16022154).
'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'([_16001178|_16001196],_15995946,_16005368,_16028494,_16028500,_16028506):-!,hnf('Prelude.++'(['^u','^n','^s','^a','^f','^e','^ ','^(','^d','^u','^e','^ ','^t','^o','^ ','^m','^o','^d','^u','^l','^e','^s','^ '],'Prelude.++'('Prelude.unwords'(_16005368),['^)'])),_16028494,_16028500,_16028506).
'blocked_blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3_Analysis.Types.AText_2'('FAIL'(_16035208),_15995946,_16005368,'FAIL'(_16035208),_16035222,_16035222):-nonvar(_16035208).
'blocked_blocked_blocked_Analysis.UnsafeModule.showUnsafe_2_[|]_3'('FAIL'(_16035294),_15995946,_15995964,_16005368,'FAIL'(_16035294),_16035308,_16035308):-nonvar(_16035294).
'blocked_blocked_Analysis.UnsafeModule.showUnsafe_2'('FAIL'(_16035388),_15995096,_16005368,'FAIL'(_16035388),_16035402,_16035402):-nonvar(_16035388).

'Analysis.UnsafeModule.importsUnsafe'(_16036932,_16036934,_16036936,_16036938,_16036940):-freeze(_16036938,'blocked_Analysis.UnsafeModule.importsUnsafe'(_16036932,_16036934,_16036936,_16036938,_16036940)).
'blocked_Analysis.UnsafeModule.importsUnsafe'(_16037028,_16037046,_16040050,_16040056,_16040062):-makeShare(_16037074,_16040322),makeShare(_16037028,_16040342),hnf('Prelude.cond'(letrec4PAKCS(_16040322,'Prelude.++'('Analysis.UnsafeModule.importsUnsafe._\'23caseor0'('Prelude.apply'('Prelude.any'(partcall(1,'Data.List.isInfixOf',[['^U','^n','^s','^a','^f','^e'],partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])),['Prelude.apply'('FlatCurry.Goodies.progName',_16040342)|'Prelude.apply'('FlatCurry.Goodies.progImports',_16040342)]),_16040342),'Prelude.apply'('Prelude.concatMap'(partcall(1,'Prelude.snd',[])),_16037046))),'Data.List.nub'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_16040322)),_16040050,_16040056,_16040062).

'Analysis.UnsafeModule.importsUnsafe._\'23caseor0'(_16049378,_16049380,_16049382,_16049384,_16049386):-freeze(_16049384,'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0'(_16049378,_16049380,_16049382,_16049384,_16049386)).
'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0'(_16049474,_16049492,_16050408,_16050414,_16050420):-hnf(_16049474,_16052486,_16050414,_16052504),'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'(_16052486,_16049492,_16050408,_16052504,_16050420).

'blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'(_16053042,_16053044,_16053046,_16053048,_16053050):-freeze(_16053048,freeze(_16053042,'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'(_16053042,_16053044,_16053046,_16053048,_16053050))).
'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'('Prelude.True',_16049492,['Prelude.apply'('FlatCurry.Goodies.progName',_16049492)],_16053442,_16053442).
'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'('Prelude.False',_16049492,[],_16054986,_16054986):-!.
'blocked_blocked_Analysis.UnsafeModule.importsUnsafe._\'23caseor0_1'('FAIL'(_16055572),_16049492,'FAIL'(_16055572),_16055586,_16055586).

:-costCenters(['']).




%%%%% Number of shared variables: 2

