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
'Analysis.RootReplaced.showRootRepl'(_31958644,_31958646,_31958648,_31958650,_31958652):-freeze(_31958650,'blocked_Analysis.RootReplaced.showRootRepl'(_31958644,_31958646,_31958648,_31958650,_31958652)).
'blocked_Analysis.RootReplaced.showRootRepl'(_31958740,_31958758,_31967852,_31967858,_31967864):-hnf(_31958740,_31969462,_31967858,_31969480),'blocked_Analysis.RootReplaced.showRootRepl_1'(_31969462,_31958758,_31967852,_31969480,_31967864).

'blocked_Analysis.RootReplaced.showRootRepl_1'(_31969934,_31969936,_31969938,_31969940,_31969942):-freeze(_31969940,'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'(_31969934,_31969936,_31969938,_31969940,_31969942)).
'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'('Analysis.Types.AText',_31958758,_31970760,_31970766,_31970772):-hnf(_31958758,_31973360,_31970766,_31973372),'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'(_31973360,_31970760,_31973372,_31970772).

'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'(_31974004,_31974006,_31974008,_31974010):-freeze(_31974008,'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'(_31974004,_31974006,_31974008,_31974010)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'('Prelude.(,)'(_31958972,_31958990),_31976478,_31976484,_31976490):-!,makeShare(_31958972,_31974376),hnf(_31974376,_31979916,_31976484,_31979940),'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'(_31979916,_31979916,_31958990,_31976478,_31979940,_31976490).

'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'(_31980750,_31980752,_31980754,_31980756,_31980758,_31980760):-freeze(_31980758,'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'(_31980750,_31980752,_31980754,_31980756,_31980758,_31980760)).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'([],_31974376,_31958990,['^n','^o','^ ','^r','^o','^o','^t','^ ','^r','^e','^p','^l','^a','^c','^e','^m','^e','^n','^t','^s'],_31981018,_31981018).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'([_31962298|_31962316],_31974376,_31958990,_31986136,_31986142,_31986148):-!,hnf('Prelude.++'(['^r','^o','^o','^t','^ ','^r','^e','^p','^l','^a','^c','^e','^m','^e','^n','^t','^s',^:,'^ '],'Data.List.intercalate'(['^,'],'Prelude.map'(partcall(1,'Analysis.RootReplaced.showRootRepl._\'23lambda1',[]),_31974376))),_31986136,_31986142,_31986148).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1_Prelude.(,)_1'('FAIL'(_31992468),_31974376,_31958990,'FAIL'(_31992468),_31992482,_31992482):-nonvar(_31992468).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.AText_1'('FAIL'(_31992554),'FAIL'(_31992554),_31992568,_31992568):-nonvar(_31992554).
'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'('Analysis.Types.ANote',_31958758,_31993360,_31993366,_31993372):-!,hnf(_31958758,_31995960,_31993366,_31995972),'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'(_31995960,_31993360,_31995972,_31993372).

'blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'(_31996622,_31996624,_31996626,_31996628):-freeze(_31996626,'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'(_31996622,_31996624,_31996626,_31996628)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'('Prelude.(,)'(_31966126,_31966144),_31998236,_31998242,_31998248):-!,makeShare(_31966126,_31996994),hnf(_31996994,_32001674,_31998242,_32001698),'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'(_32001674,_32001674,_31966144,_31998236,_32001698,_31998248).

'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'(_32002508,_32002510,_32002512,_32002514,_32002516,_32002518):-freeze(_32002516,'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'(_32002508,_32002510,_32002512,_32002514,_32002516,_32002518)).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'([],_31996994,_31966144,[],_32002776,_32002776).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'([_31966372|_31966390],_31996994,_31966144,_32003854,_32003860,_32003866):-!,hnf('Prelude.++'(['^['],'Prelude.++'('Data.List.intercalate'(['^,'],'Prelude.map'(partcall(1,'Prelude.snd',[]),_31996994)),['^]'])),_32003854,_32003860,_32003866).
'blocked_blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1_Prelude.(,)_1'('FAIL'(_32006880),_31996994,_31966144,'FAIL'(_32006880),_32006894,_32006894):-nonvar(_32006880).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootRepl_1_Analysis.Types.ANote_1'('FAIL'(_32006966),'FAIL'(_32006966),_32006980,_32006980):-nonvar(_32006966).
'blocked_blocked_Analysis.RootReplaced.showRootRepl_1'('FAIL'(_32007036),_31958758,'FAIL'(_32007036),_32007050,_32007050):-nonvar(_32007036).

'Analysis.RootReplaced.showRootRepl._\'23lambda1'(_32008942,_32008944,_32008946,_32008948):-freeze(_32008946,'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1'(_32008942,_32008944,_32008946,_32008948)).
'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1'(_32009028,_32010026,_32010032,_32010038):-hnf(_32009028,_32012060,_32010032,_32012072),'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'(_32012060,_32010026,_32012072,_32010038).

'blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'(_32012590,_32012592,_32012594,_32012596):-freeze(_32012594,'blocked_blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'(_32012590,_32012592,_32012594,_32012596)).
'blocked_blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'('Prelude.(,)'(_32009144,_32009162),_32012960,_32012966,_32012972):-!,hnf('Prelude.++'(_32009144,'Prelude.++'([^.],_32009162)),_32012960,_32012966,_32012972).
'blocked_blocked_Analysis.RootReplaced.showRootRepl._\'23lambda1_1'('FAIL'(_32014494),'FAIL'(_32014494),_32014508,_32014508):-nonvar(_32014494).

'Analysis.RootReplaced.rootReplAnalysis'(_32016136,_32016138,_32016140):-freeze(_32016138,'blocked_Analysis.RootReplaced.rootReplAnalysis'(_32016136,_32016138,_32016140)).
'blocked_Analysis.RootReplaced.rootReplAnalysis'(_32018492,_32018498,_32018504):-hnf('Analysis.Types.dependencyFuncAnalysis'(['^R','^o','^o','^t','^R','^e','^p','^l','^a','^c','^e','^d'],'Prelude.(,)'([],[]),partcall(2,'Analysis.RootReplaced.rrFunc',[])),_32018492,_32018498,_32018504).

'Analysis.RootReplaced.rrFunc'(_32023492,_32023494,_32023496,_32023498,_32023500):-freeze(_32023498,'blocked_Analysis.RootReplaced.rrFunc'(_32023492,_32023494,_32023496,_32023498,_32023500)).
'blocked_Analysis.RootReplaced.rrFunc'(_32023588,_32023606,_32024246,_32024252,_32024258):-hnf(_32023588,_32025640,_32024252,_32025658),'blocked_Analysis.RootReplaced.rrFunc_1'(_32025640,_32023606,_32024246,_32025658,_32024258).

'blocked_Analysis.RootReplaced.rrFunc_1'(_32026076,_32026078,_32026080,_32026082,_32026084):-freeze(_32026082,'blocked_blocked_Analysis.RootReplaced.rrFunc_1'(_32026076,_32026078,_32026080,_32026082,_32026084)).
'blocked_blocked_Analysis.RootReplaced.rrFunc_1'('FlatCurry.Types.Func'(_32023722,_32023740,_32023758,_32023776,_32023794),_32023606,_32026602,_32026608,_32026614):-!,hnf('Analysis.RootReplaced.rrFuncRule'(_32023606,_32023794),_32026602,_32026608,_32026614).
'blocked_blocked_Analysis.RootReplaced.rrFunc_1'('FAIL'(_32027828),_32023606,'FAIL'(_32027828),_32027842,_32027842):-nonvar(_32027828).

'Analysis.RootReplaced.rrFuncRule'(_32029250,_32029252,_32029254,_32029256,_32029258):-freeze(_32029256,'blocked_Analysis.RootReplaced.rrFuncRule'(_32029250,_32029252,_32029254,_32029256,_32029258)).
'blocked_Analysis.RootReplaced.rrFuncRule'(_32029346,_32029364,_32030326,_32030332,_32030338):-hnf(_32029364,_32031864,_32030332,_32031882),'blocked_Analysis.RootReplaced.rrFuncRule_2'(_32031864,_32029346,_32030326,_32031882,_32030338).

'blocked_Analysis.RootReplaced.rrFuncRule_2'(_32032324,_32032326,_32032328,_32032330,_32032332):-freeze(_32032330,'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'(_32032324,_32032326,_32032328,_32032330,_32032332)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'('FlatCurry.Types.External'(_32029480),_32029346,'Prelude.(,)'([],[]),_32032872,_32032872).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'('FlatCurry.Types.Rule'(_32029772,_32029790),_32029346,_32034100,_32034106,_32034112):-!,hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32029772,_32029346,_32029790),_32034100,_32034106,_32034112).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule_2'('FAIL'(_32035334),_32029346,'FAIL'(_32035334),_32035348,_32035348):-nonvar(_32035334).

'Analysis.RootReplaced.rrFuncRule.lub.31'(_32037022,_32037024,_32037026,_32037028,_32037030,_32037032,_32037034):-freeze(_32037032,'blocked_Analysis.RootReplaced.rrFuncRule.lub.31'(_32037022,_32037024,_32037026,_32037028,_32037030,_32037032,_32037034)).
'blocked_Analysis.RootReplaced.rrFuncRule.lub.31'(_32037138,_32037156,_32037174,_32037192,_32039086,_32039092,_32039098):-hnf(_32037174,_32040892,_32039092,_32040922),'blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'(_32040892,_32037138,_32037156,_32037192,_32039086,_32040922,_32039098).

'blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'(_32041422,_32041424,_32041426,_32041428,_32041430,_32041432,_32041434):-freeze(_32041432,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'(_32041422,_32041424,_32041426,_32041428,_32041430,_32041432,_32041434)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'('Prelude.(,)'(_32037308,_32037326),_32037138,_32037156,_32037192,_32042226,_32042232,_32042238):-!,hnf(_32037192,_32044752,_32042232,_32044788),'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'(_32044752,_32037308,_32037326,_32037138,_32037156,_32042226,_32044788,_32042238).

'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'(_32045446,_32045448,_32045450,_32045452,_32045454,_32045456,_32045458,_32045460):-freeze(_32045458,'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'(_32045446,_32045448,_32045450,_32045452,_32045454,_32045456,_32045458,_32045460)).
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'('Prelude.(,)'(_32037454,_32037472),_32037308,_32037326,_32037138,_32037156,'Prelude.(,)'('Prelude.apply'('Data.List.sort'(_32046290),'Data.List.union'('Prelude._super\'23Prelude.Ord\'23Prelude.Eq\'230\'23'(_32046290),_32037308,_32037454)),'Prelude.apply'('Data.List.sort'(_32046310),'Data.List.union'('Prelude._super\'23Prelude.Ord\'23Prelude.Eq\'230\'23'(_32046310),_32037326,_32037472))),_32045862,_32045868):-!,makeShare(_32037156,_32046290),makeShare(_32037138,_32046310),_32045862=_32045868.
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3_Prelude.(,)_5'('FAIL'(_32050360),_32037308,_32037326,_32037138,_32037156,'FAIL'(_32050360),_32050374,_32050374):-nonvar(_32050360).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.lub.31_3'('FAIL'(_32050462),_32037138,_32037156,_32037192,'FAIL'(_32050462),_32050476,_32050476):-nonvar(_32050462).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32052318,_32052320,_32052322,_32052324,_32052326,_32052328):-freeze(_32052326,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32052318,_32052320,_32052322,_32052324,_32052326,_32052328)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32052424,_32052442,_32052460,_32065000,_32065006,_32065012):-hnf(_32052460,_32066942,_32065006,_32066966),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'(_32066942,_32052424,_32052442,_32065000,_32066966,_32065012).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'(_32067488,_32067490,_32067492,_32067494,_32067496,_32067498):-freeze(_32067496,freeze(_32067488,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'(_32067488,_32067490,_32067492,_32067494,_32067496,_32067498))).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Var'(_32052576),_32052424,_32052442,_32067986,_32067992,_32067998):-hnf('Prelude.maybe'('Prelude.(,)'([],[]),partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3',[]),'Prelude.apply'('Data.List.elemIndex'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),_32052576),_32052424)),_32067986,_32067992,_32067998).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Lit'(_32053428),_32052424,_32052442,'Prelude.(,)'([],[]),_32070976,_32070976).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Comb'(_32053720,_32053738,_32053756),_32052424,_32052442,_32075602,_32075608,_32075614):-hnf('FlatCurry.Types._impl\'23\'3D\'3D\'23Prelude.Eq\'23FlatCurry.Types.CombType\'23'(_32053720,'FlatCurry.Types.FuncCall'),_32078654,_32075608,_32078602),'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'(_32078654,_32053720,_32053738,_32053756,_32052424,_32052442,_32075602,_32078602,_32075614).

'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'(_32079394,_32079396,_32079398,_32079400,_32079402,_32079404,_32079406,_32079408,_32079410):-freeze(_32079408,freeze(_32079394,'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'(_32079394,_32079396,_32079398,_32079400,_32079402,_32079404,_32079406,_32079408,_32079410))).
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'('Prelude.True',_32053720,_32053738,_32053756,_32052424,_32052442,_32079828,_32079834,_32079840):-makeShare(_32053738,_32080286),makeShare(_32052442,_32080306),hnf('Prelude.maybe'('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^A','^b','^s','^t','^r','^a','^c','^t','^ ','^v','^a','^l','^u','^e','^ ','^o','^f','^ '],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])])),_32080286),['^ ','^n','^o','^t','^ ','^f','^o','^u','^n','^d','^!']))),partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4',[_32080286,_32080306,_32052424,_32053756]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_32080286,_32080306)),_32079828,_32079834,_32079840).
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'('Prelude.False',_32053720,_32053738,_32053756,_32052424,_32052442,'Prelude.(,)'([],[]),_32094420,_32094420):-!.
'blocked_blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3_FlatCurry.Types.Comb_ComplexCase'('FAIL'(_32095790),_32053720,_32053738,_32053756,_32052424,_32052442,'FAIL'(_32095790),_32095804,_32095804).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Typed'(_32060984,_32061002),_32052424,_32052442,_32096320,_32096326,_32096332):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32052424,_32052442,_32060984),_32096320,_32096326,_32096332).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Free'(_32061342,_32061360),_32052424,_32052442,_32098088,_32098094,_32098100):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32052424,_32052442,_32061360),_32098088,_32098094,_32098100).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Let'(_32061700,_32061718),_32052424,_32052442,_32099844,_32099850,_32099856):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32052424,_32052442,_32061718),_32099844,_32099850,_32099856).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Or'(_32062058,_32062076),_32052424,_32052442,_32101588,_32101594,_32101600):-makeShare(_32052424,_32101846),makeShare(_32052442,_32101866),hnf('Analysis.RootReplaced.rrFuncRule.lub.31'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32101846,_32101866,_32062058),'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32101846,_32101866,_32062076)),_32101588,_32101594,_32101600).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FlatCurry.Types.Case'(_32063298,_32063316,_32063334),_32052424,_32052442,_32107280,_32107286,_32107292):-!,makeShare(_32052424,_32107542),makeShare(_32052442,_32107562),hnf('Prelude.foldr'(partcall(2,'Analysis.RootReplaced.rrFuncRule.lub.31',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[])]),'Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32107542,_32107562,_32063316),'Prelude.map'(partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6',[_32107562,_32107542]),_32063334)),_32107280,_32107286,_32107292).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31_3'('FAIL'(_32113092),_32052424,_32052442,'FAIL'(_32113092),_32113106,_32113106).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3'(_32115344,_32115346,_32115348,_32115350):-freeze(_32115348,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3'(_32115344,_32115346,_32115348,_32115350)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda3'(_32115430,'Prelude.(,)'([],[_32115430]),_32115788,_32115788).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4'(_32118980,_32118982,_32118984,_32118986,_32118988,_32118990,_32118992,_32118994):-freeze(_32118992,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4'(_32118980,_32118982,_32118984,_32118986,_32118988,_32118990,_32118992,_32118994)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4'(_32119106,_32119124,_32119142,_32119160,_32119178,_32121956,_32121962,_32121968):-hnf(_32119178,_32124346,_32121962,_32124382),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'(_32124346,_32119106,_32119124,_32119142,_32119160,_32121956,_32124382,_32121968).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'(_32124986,_32124988,_32124990,_32124992,_32124994,_32124996,_32124998,_32125000):-freeze(_32124998,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'(_32124986,_32124988,_32124990,_32124992,_32124994,_32124996,_32124998,_32125000)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'('Prelude.(,)'(_32119294,_32119312),_32119106,_32119124,_32119142,_32119160,_32125396,_32125402,_32125408):-!,makeShare(_32119160,_32125828),makeShare(_32119294,_32125848),hnf('Prelude.foldr'(partcall(2,'Analysis.RootReplaced.rrFuncRule.lub.31',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[])]),'Prelude.(,)'('Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_32125828),_32125848),_32125828,_32125848),[]),'Prelude.map'(partcall(1,'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5',[_32119142,_32119124,_32119106]),_32119312)),_32125396,_32125402,_32125408).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4_5'('FAIL'(_32134504),_32119106,_32119124,_32119142,_32119160,'FAIL'(_32134504),_32134518,_32134518):-nonvar(_32134504).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5'(_32137184,_32137186,_32137188,_32137190,_32137192,_32137194,_32137196):-freeze(_32137194,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5'(_32137184,_32137186,_32137188,_32137190,_32137192,_32137194,_32137196)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23lambda5'(_32137300,_32137318,_32137336,_32137354,_32137748,_32137754,_32137760):-hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32137318,_32137336,'Prelude.!!'(_32137300,_32137354)),_32137748,_32137754,_32137760).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6'(_32141728,_32141730,_32141732,_32141734,_32141736,_32141738):-freeze(_32141736,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6'(_32141728,_32141730,_32141732,_32141734,_32141736,_32141738)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6'(_32141834,_32141852,_32141870,_32142686,_32142692,_32142698):-hnf(_32141870,_32145060,_32142692,_32145084),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'(_32145060,_32141834,_32141852,_32142686,_32145084,_32142698).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'(_32145672,_32145674,_32145676,_32145678,_32145680,_32145682):-freeze(_32145680,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'(_32145672,_32145674,_32145676,_32145678,_32145680,_32145682)).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'('FlatCurry.Types.Branch'(_32141986,_32142004),_32141834,_32141852,_32146208,_32146214,_32146220):-!,hnf('Analysis.RootReplaced.rrFuncRule.rrOfExp.31'(_32141834,_32141852,_32142004),_32146208,_32146214,_32146220).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda6_3'('FAIL'(_32147654),_32141834,_32141852,'FAIL'(_32147654),_32147668,_32147668):-nonvar(_32147654).

'Analysis.RootReplaced.showRootCyclic'(_32149236,_32149238,_32149240,_32149242,_32149244):-freeze(_32149242,'blocked_Analysis.RootReplaced.showRootCyclic'(_32149236,_32149238,_32149240,_32149242,_32149244)).
'blocked_Analysis.RootReplaced.showRootCyclic'(_32149332,_32149350,_32160142,_32160148,_32160154):-hnf(_32149332,_32161824,_32160148,_32161842),'blocked_Analysis.RootReplaced.showRootCyclic_1'(_32161824,_32149350,_32160142,_32161842,_32160154).

'blocked_Analysis.RootReplaced.showRootCyclic_1'(_32162308,_32162310,_32162312,_32162314,_32162316):-freeze(_32162314,'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'(_32162308,_32162310,_32162312,_32162314,_32162316)).
'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'('Analysis.Types.AText',_32149350,_32163146,_32163152,_32163158):-hnf(_32149350,_32165818,_32163152,_32165830),'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'(_32165818,_32163146,_32165830,_32163158).

'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'(_32166474,_32166476,_32166478,_32166480):-freeze(_32166478,'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'(_32166474,_32166476,_32166478,_32166480)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'('Prelude.False',['^n','^o','^ ','^c','^y','^c','^l','^e','^s','^ ','^a','^t','^ ','^t','^h','^e','^ ','^r','^o','^o','^t'],_32166870,_32166870).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'('Prelude.True',['^p','^o','^s','^s','^i','^b','^l','^e','^ ','^c','^y','^c','^l','^i','^c','^ ','^r','^o','^o','^t','^ ','^r','^e','^p','^l','^a','^c','^e','^m','^e','^n','^t'],_32172036,_32172036):-!.
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.AText_1'('FAIL'(_32179132),'FAIL'(_32179132),_32179146,_32179146):-nonvar(_32179132).
'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'('Analysis.Types.ANote',_32149350,_32179950,_32179956,_32179962):-!,hnf(_32149350,_32182622,_32179956,_32182634),'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'(_32182622,_32179950,_32182634,_32179962).

'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'(_32183296,_32183298,_32183300,_32183302):-freeze(_32183300,'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'(_32183296,_32183298,_32183300,_32183302)).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'('Prelude.False',[],_32183692,_32183692).
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'('Prelude.True',['^r','^o','^o','^t',^-,'^c','^y','^c','^l','^i','^c'],_32184616,_32184616):-!.
'blocked_blocked_blocked_Analysis.RootReplaced.showRootCyclic_1_Analysis.Types.ANote_1'('FAIL'(_32187470),'FAIL'(_32187470),_32187484,_32187484):-nonvar(_32187470).
'blocked_blocked_Analysis.RootReplaced.showRootCyclic_1'('FAIL'(_32187540),_32149350,'FAIL'(_32187540),_32187554,_32187554):-nonvar(_32187540).

'Analysis.RootReplaced.rootCyclicAnalysis'(_32189266,_32189268,_32189270):-freeze(_32189268,'blocked_Analysis.RootReplaced.rootCyclicAnalysis'(_32189266,_32189268,_32189270)).
'blocked_Analysis.RootReplaced.rootCyclicAnalysis'(_32192658,_32192664,_32192670):-hnf('Analysis.Types.combinedSimpleFuncAnalysis'(partcall(1,'Prelude._inst\'23Prelude.Read\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Int\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Read\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Char\'23',[])])])])]),partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23Prelude.Int\'23',[])]),partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23Prelude.Char\'23',[])]),partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23\'5B\'5D\'230\'23\'23',[partcall(1,'RW.Base._inst\'23RW.Base.ReadWrite\'23Prelude.Char\'23',[])])])])]),['^R','^o','^o','^t','^C','^y','^c','^l','^i','^c'],'Analysis.RootReplaced.rootReplAnalysis',partcall(2,'Analysis.RootReplaced.rcFunc',[])),_32192658,_32192664,_32192670).

'Analysis.RootReplaced.rcFunc'(_32204910,_32204912,_32204914,_32204916,_32204918):-freeze(_32204916,'blocked_Analysis.RootReplaced.rcFunc'(_32204910,_32204912,_32204914,_32204916,_32204918)).
'blocked_Analysis.RootReplaced.rcFunc'(_32205006,_32205024,_32206340,_32206346,_32206352):-hnf(_32205024,_32207734,_32206346,_32207752),'blocked_Analysis.RootReplaced.rcFunc_2'(_32207734,_32205006,_32206340,_32207752,_32206352).

'blocked_Analysis.RootReplaced.rcFunc_2'(_32208170,_32208172,_32208174,_32208176,_32208178):-freeze(_32208176,'blocked_blocked_Analysis.RootReplaced.rcFunc_2'(_32208170,_32208172,_32208174,_32208176,_32208178)).
'blocked_blocked_Analysis.RootReplaced.rcFunc_2'('FlatCurry.Types.Func'(_32205140,_32205158,_32205176,_32205194,_32205212),_32205006,_32209034,_32209040,_32209046):-!,hnf(_32205212,_32211418,_32209040,_32211460),'blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'(_32211418,_32205140,_32205158,_32205176,_32205194,_32205006,_32209034,_32211460,_32209046).

'blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'(_32212114,_32212116,_32212118,_32212120,_32212122,_32212124,_32212126,_32212128,_32212130):-freeze(_32212128,'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'(_32212114,_32212116,_32212118,_32212120,_32212122,_32212124,_32212126,_32212128,_32212130)).
'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'('FlatCurry.Types.External'(_32205358),_32205140,_32205158,_32205176,_32205194,_32205006,'Prelude.False',_32212702,_32212702).
'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'('FlatCurry.Types.Rule'(_32205482,_32205500),_32205140,_32205158,_32205176,_32205194,_32205006,_32214204,_32214210,_32214216):-!,makeShare(_32205006,_32214388),makeShare(_32205140,_32214408),hnf('Prelude.maybe'('Prelude.True',partcall(1,'Analysis.RootReplaced.rcFunc._\'23lambda7',[_32214408,_32214388]),'Analysis.ProgInfo.lookupProgInfo'(_32214408,_32214388)),_32214204,_32214210,_32214216).
'blocked_blocked_blocked_Analysis.RootReplaced.rcFunc_2_FlatCurry.Types.Func_5'('FAIL'(_32217114),_32205140,_32205158,_32205176,_32205194,_32205006,'FAIL'(_32217114),_32217128,_32217128):-nonvar(_32217114).
'blocked_blocked_Analysis.RootReplaced.rcFunc_2'('FAIL'(_32217224),_32205006,'FAIL'(_32217224),_32217238,_32217238):-nonvar(_32217224).

'Analysis.RootReplaced.rcFunc._\'23lambda7'(_32218902,_32218904,_32218906,_32218908,_32218910,_32218912):-freeze(_32218910,'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7'(_32218902,_32218904,_32218906,_32218908,_32218910,_32218912)).
'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7'(_32219008,_32219026,_32219044,_32220362,_32220368,_32220374):-makeShare(_32219044,_32220564),hnf('Prelude.||'('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_32219026),'Prelude.fst'(_32220564)),'Prelude.apply'('Prelude.any'(partcall(1,'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8',[_32219008])),'Prelude.fst'(_32220564))),_32220362,_32220368,_32220374).

'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8'(_32227298,_32227300,_32227302,_32227304,_32227306):-freeze(_32227304,'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8'(_32227298,_32227300,_32227302,_32227304,_32227306)).
'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8'(_32227394,_32227412,_32227904,_32227910,_32227916):-makeShare(_32227412,_32228030),hnf('Prelude.maybe'('Prelude.True',partcall(1,'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9',[_32228030]),'Analysis.ProgInfo.lookupProgInfo'(_32228030,_32227394)),_32227904,_32227910,_32227916).

'Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9'(_32232546,_32232548,_32232550,_32232552,_32232554):-freeze(_32232552,'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9'(_32232546,_32232548,_32232550,_32232552,_32232554)).
'blocked_Analysis.RootReplaced.rcFunc._\'23lambda7._\'23lambda8._\'23lambda9'(_32232642,_32232660,_32233418,_32233424,_32233430):-hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_32232642),'Prelude.fst'(_32232660)),_32233418,_32233424,_32233430).

'Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'(_32239334,_32239336,_32239338,_32239340,_32239342,_32239344):-freeze(_32239342,'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'(_32239334,_32239336,_32239338,_32239340,_32239342,_32239344)).
'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0'(_32239440,_32239458,_32239476,_32240736,_32240742,_32240748):-hnf(_32239440,_32243542,_32240742,_32243566),'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'(_32243542,_32239458,_32239476,_32240736,_32243566,_32240748).

'blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'(_32244232,_32244234,_32244236,_32244238,_32244240,_32244242):-freeze(_32244240,freeze(_32244232,'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'(_32244232,_32244234,_32244236,_32244238,_32244240,_32244242))).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'('Prelude.True',_32239458,_32239476,_32244636,_32244642,_32244648):-hnf(_32239476,_32244636,_32244642,_32244648).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'('Prelude.False',_32239458,_32239476,_32245726,_32245732,_32245738):-!,hnf('Data.List.insertBy'(partcall(2,'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])]),_32239458,_32239476),_32245726,_32245732,_32245738).
'blocked_blocked_Analysis.RootReplaced.rrFuncRule.rrOfExp.31._\'23lambda4._\'23caseor0_1'('FAIL'(_32248924),_32239458,_32239476,'FAIL'(_32248924),_32248938,_32248938).

:-costCenters(['']).




%%%%% Number of shared variables: 14

