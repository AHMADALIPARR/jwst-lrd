%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('ReadShowTerm').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('ReadShowTerm.showTerm',showTerm,2,'ReadShowTerm.showTerm',nofix,notype).
functiontype('ReadShowTerm.prim_showTerm','ReadShowTerm.prim_showTerm',1,'ReadShowTerm.prim_showTerm',nofix,notype).
functiontype('ReadShowTerm.readsUnqualifiedTerm',readsUnqualifiedTerm,3,'ReadShowTerm.readsUnqualifiedTerm',nofix,notype).
functiontype('ReadShowTerm.readsUnqualifiedTermWithPrefixes','ReadShowTerm.readsUnqualifiedTermWithPrefixes',3,'ReadShowTerm.readsUnqualifiedTermWithPrefixes',nofix,notype).
functiontype('ReadShowTerm.prim_readsUnqualifiedTerm','ReadShowTerm.prim_readsUnqualifiedTerm',2,'ReadShowTerm.prim_readsUnqualifiedTerm',nofix,notype).
functiontype('ReadShowTerm.readUnqualifiedTerm',readUnqualifiedTerm,3,'ReadShowTerm.readUnqualifiedTerm',nofix,notype).
functiontype('ReadShowTerm.readUnqualifiedTerm._\'23caseor0','ReadShowTerm.readUnqualifiedTerm._#caseor0',1,'ReadShowTerm.readUnqualifiedTerm._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'ReadShowTerm.showTerm'(_25682086,_25682088,_25682090,_25682092,_25682094):-freeze(_25682092,'blocked_ReadShowTerm.showTerm'(_25682086,_25682088,_25682090,_25682092,_25682094)).
'blocked_ReadShowTerm.showTerm'(_25682182,_25682200,_25682384,_25682390,_25682396):-hnf('Prelude.$##'(partcall(1,'ReadShowTerm.prim_showTerm',[]),_25682200),_25682384,_25682390,_25682396).

'ReadShowTerm.prim_showTerm'(_25683806,_25683808,_25683810,_25683812):-freeze(_25683810,'blocked_ReadShowTerm.prim_showTerm'(_25683806,_25683808,_25683810,_25683812)).
'blocked_ReadShowTerm.prim_showTerm'(_25683886,_25683892,_25683898,_25683904):-derefAll(_25683886,_25683942),'ReadShowTerm.prim_showTerm'(_25683942,_25683892),_25683898=_25683904.

'ReadShowTerm.readsUnqualifiedTerm'(_25685426,_25685428,_25685430,_25685432,_25685434,_25685436):-freeze(_25685434,'blocked_ReadShowTerm.readsUnqualifiedTerm'(_25685426,_25685428,_25685430,_25685432,_25685434,_25685436)).
'blocked_ReadShowTerm.readsUnqualifiedTerm'(_25685532,_25685550,_25685568,_25696900,_25696906,_25696912):-hnf(_25685550,_25698482,_25696906,_25698506),'blocked_ReadShowTerm.readsUnqualifiedTerm_2'(_25698482,_25685532,_25685568,_25696900,_25698506,_25696912).

'blocked_ReadShowTerm.readsUnqualifiedTerm_2'(_25698962,_25698964,_25698966,_25698968,_25698970,_25698972):-freeze(_25698970,'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'(_25698962,_25698964,_25698966,_25698968,_25698970,_25698972)).
'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'([],_25685532,_25685568,_25699224,_25699230,_25699236):-hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^s','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^l','^i','^s','^t','^ ','^o','^f','^ ','^m','^o','^d','^u','^l','^e','^ ','^p','^r','^e','^f','^i','^x','^e','^s','^ ','^i','^s','^ ','^e','^m','^p','^t','^y']),_25699224,_25699230,_25699236).
'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'([_25696186|_25696204],_25685532,_25685568,_25713724,_25713730,_25713736):-!,hnf('ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_25685532,[_25696186|_25696204],_25685568),_25713724,_25713730,_25713736).
'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'('FAIL'(_25715288),_25685532,_25685568,'FAIL'(_25715288),_25715302,_25715302):-nonvar(_25715288).

'ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_25717212,_25717214,_25717216,_25717218,_25717220,_25717222):-freeze(_25717220,'blocked_ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_25717212,_25717214,_25717216,_25717218,_25717220,_25717222)).
'blocked_ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_25717318,_25717336,_25717354,_25717692,_25717698,_25717704):-hnf('Prelude.$##'('Prelude.$##'(partcall(2,'ReadShowTerm.prim_readsUnqualifiedTerm',[]),_25717336),_25717354),_25717692,_25717698,_25717704).

'ReadShowTerm.prim_readsUnqualifiedTerm'(_25719916,_25719918,_25719920,_25719922,_25719924):-freeze(_25719922,'blocked_ReadShowTerm.prim_readsUnqualifiedTerm'(_25719916,_25719918,_25719920,_25719922,_25719924)).
'blocked_ReadShowTerm.prim_readsUnqualifiedTerm'(_25720006,_25720012,_25720018,_25720024,_25720030):-derefAll(_25720006,_25720076),derefAll(_25720012,_25720082),'ReadShowTerm.prim_readsUnqualifiedTerm'(_25720076,_25720082,_25720018),_25720024=_25720030.

'ReadShowTerm.readUnqualifiedTerm'(_25721568,_25721570,_25721572,_25721574,_25721576,_25721578):-freeze(_25721576,'blocked_ReadShowTerm.readUnqualifiedTerm'(_25721568,_25721570,_25721572,_25721574,_25721576,_25721578)).
'blocked_ReadShowTerm.readUnqualifiedTerm'(_25721674,_25721692,_25721710,_25722376,_25722382,_25722388):-makeShare(_25721738,_25722598),hnf('Prelude.cond'(letrec4PAKCS(_25722598,'ReadShowTerm.readsUnqualifiedTerm'(_25721674,_25721692,_25721710)),'ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_25722598)),_25722376,_25722382,_25722388).

'ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_25726528,_25726530,_25726532,_25726534):-freeze(_25726532,'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_25726528,_25726530,_25726532,_25726534)).
'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_25726614,_25753998,_25754004,_25754010):-hnf(_25726614,_25755960,_25754004,_25755972),'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'(_25755960,_25753998,_25755972,_25754010).

'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'(_25756484,_25756486,_25756488,_25756490):-freeze(_25756488,freeze(_25756484,'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'(_25756484,_25756486,_25756488,_25756490))).
'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'([_25726730|_25726748],_25757162,_25757168,_25757174):-hnf(_25726730,_25759604,_25757168,_25759622),'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'(_25759604,_25726748,_25757162,_25759622,_25757174).

'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'(_25760226,_25760228,_25760230,_25760232,_25760234):-freeze(_25760232,freeze(_25760226,'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'(_25760226,_25760228,_25760230,_25760232,_25760234))).
'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'('Prelude.(,)'(_25726876,_25726894),_25726748,_25761114,_25761120,_25761126):-!,hnf(_25726748,_25764308,_25761120,_25764332),'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_25764308,_25726876,_25726894,_25761114,_25764332,_25761126).

'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_25765094,_25765096,_25765098,_25765100,_25765102,_25765104):-freeze(_25765102,freeze(_25765094,'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_25765094,_25765096,_25765098,_25765100,_25765102,_25765104))).
'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'([],_25726876,_25726894,_25769288,_25769294,_25769300):-makeShare(_25726894,_25765754),hnf('Prelude.apply'('Prelude.all'(partcall(1,'Prelude.isSpace',[])),_25765754),_25773114,_25769294,_25773080),'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_25773114,_25726876,_25765754,_25769288,_25773080,_25769300).

'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_25773974,_25773976,_25773978,_25773980,_25773982,_25773984):-freeze(_25773982,freeze(_25773974,'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_25773974,_25773976,_25773978,_25773980,_25773982,_25773984))).
'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('Prelude.True',_25726876,_25765754,_25774378,_25774384,_25774390):-hnf(_25726876,_25774378,_25774384,_25774390).
'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('Prelude.False',_25726876,_25765754,_25775684,_25775690,_25775696):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^n','^o','^ ','^p','^a','^r','^s','^e','^,','^ '],'Prelude.++'(['^u','^n','^m','^a','^t','^c','^h','^e','^d','^ ','^s','^t','^r','^i','^n','^g','^ ','^a','^f','^t','^e','^r','^ ','^t','^e','^r','^m',^:,'^ '],_25765754))),_25775684,_25775690,_25775696).
'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('FAIL'(_25792514),_25726876,_25765754,'FAIL'(_25792514),_25792528,_25792528).
'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'([_25739296|_25739314],_25726876,_25726894,_25792786,_25792792,_25792798):-!,hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^a','^m','^b','^i','^g','^u','^o','^u','^s','^ ','^p','^a','^r','^s','^e']),_25792786,_25792792,_25792798).
'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'('FAIL'(_25803892),_25726876,_25726894,'FAIL'(_25803892),_25803906,_25803906).
'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'('FAIL'(_25803974),_25726748,'FAIL'(_25803974),_25803988,_25803988).
'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'([],_25804210,_25804216,_25804222):-!,hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^n','^o','^ ','^p','^a','^r','^s','^e']),_25804210,_25804216,_25804222).
'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'('FAIL'(_25813406),'FAIL'(_25813406),_25813420,_25813420).

:-costCenters(['']).




%%%%% Number of shared variables: 2

:-style_check(-singleton).
'ReadShowTerm.prim_showTerm'(_25813496,_25813498):-readShowTerm:prim_showTerm(_25813496,_25813498).
'ReadShowTerm.prim_readsUnqualifiedTerm'(_25813576,_25813578,_25813580):-readShowTerm:prim_readsUnqualifiedTerm(_25813576,_25813578,_25813580).
