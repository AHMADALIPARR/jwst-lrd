%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').
:-importModule('System.IO').

:-curryModule('System.IO.Unsafe').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.IO.Unsafe.unsafePerformIO',unsafePerformIO,1,prim_unsafePerformIO,nofix,notype).
functiontype('System.IO.Unsafe.trace',trace,2,'System.IO.Unsafe.trace',nofix,notype).
functiontype('System.IO.Unsafe.spawnConstraint',spawnConstraint,2,prim_spawnConstraint,nofix,notype).
functiontype('System.IO.Unsafe.isVar',isVar,2,'System.IO.Unsafe.isVar',nofix,notype).
functiontype('System.IO.Unsafe.prim_isVar','System.IO.Unsafe.prim_isVar',1,'System.IO.Unsafe.prim_isVar',nofix,notype).
functiontype('System.IO.Unsafe.identicalVar',identicalVar,3,'System.IO.Unsafe.identicalVar',nofix,notype).
functiontype('System.IO.Unsafe.prim_identicalVar','System.IO.Unsafe.prim_identicalVar',2,'System.IO.Unsafe.prim_identicalVar',nofix,notype).
functiontype('System.IO.Unsafe.isGround',isGround,2,'System.IO.Unsafe.isGround',nofix,notype).
functiontype('System.IO.Unsafe.prim_isGround','System.IO.Unsafe.prim_isGround',1,'System.IO.Unsafe.prim_isGround',nofix,notype).
functiontype('System.IO.Unsafe.compareAnyTerm',compareAnyTerm,2,prim_compareAnyTerm,nofix,notype).
functiontype('System.IO.Unsafe.showAnyTerm',showAnyTerm,1,'System.IO.Unsafe.showAnyTerm',nofix,notype).
functiontype('System.IO.Unsafe.prim_showAnyTerm','System.IO.Unsafe.prim_showAnyTerm',1,'System.IO.Unsafe.prim_showAnyTerm',nofix,notype).
functiontype('System.IO.Unsafe.readsAnyUnqualifiedTerm',readsAnyUnqualifiedTerm,2,'System.IO.Unsafe.readsAnyUnqualifiedTerm',nofix,notype).
functiontype('System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes','System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes',2,'System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes',nofix,notype).
functiontype('System.IO.Unsafe.prim_readsAnyUnqualifiedTerm','System.IO.Unsafe.prim_readsAnyUnqualifiedTerm',2,'System.IO.Unsafe.prim_readsAnyUnqualifiedTerm',nofix,notype).
functiontype('System.IO.Unsafe.readAnyUnqualifiedTerm',readAnyUnqualifiedTerm,2,'System.IO.Unsafe.readAnyUnqualifiedTerm',nofix,notype).
functiontype('System.IO.Unsafe.showAnyExpression',showAnyExpression,1,prim_showAnyExpression,nofix,notype).
functiontype('System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0','System.IO.Unsafe.readAnyUnqualifiedTerm._#caseor0',1,'System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.IO.Unsafe.trace'(_4776462,_4776464,_4776466,_4776468,_4776470):-freeze(_4776468,'blocked_System.IO.Unsafe.trace'(_4776462,_4776464,_4776466,_4776468,_4776470)).
'blocked_System.IO.Unsafe.trace'(_4776558,_4776576,_4777334,_4777340,_4777346):-hnf('System.IO.Unsafe.unsafePerformIO'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hPutStrLn'('System.IO.stderr',_4776558)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_4776576))),_4777334,_4777340,_4777346).

'System.IO.Unsafe.isVar'(_4781196,_4781198,_4781200,_4781202,_4781204):-freeze(_4781202,'blocked_System.IO.Unsafe.isVar'(_4781196,_4781198,_4781200,_4781202,_4781204)).
'blocked_System.IO.Unsafe.isVar'(_4781292,_4781310,_4781494,_4781500,_4781506):-hnf('Prelude.$!'(partcall(1,'System.IO.Unsafe.prim_isVar',[]),_4781310),_4781494,_4781500,_4781506).

'System.IO.Unsafe.prim_isVar'(_4782910,_4782912,_4782914,_4782916):-freeze(_4782914,'blocked_System.IO.Unsafe.prim_isVar'(_4782910,_4782912,_4782914,_4782916)).
'blocked_System.IO.Unsafe.prim_isVar'(_4782990,_4782996,_4783002,_4783008):-derefAll(_4782990,_4783046),'System.IO.Unsafe.prim_isVar'(_4783046,_4782996),_4783002=_4783008.

'System.IO.Unsafe.identicalVar'(_4784378,_4784380,_4784382,_4784384,_4784386,_4784388):-freeze(_4784386,'blocked_System.IO.Unsafe.identicalVar'(_4784378,_4784380,_4784382,_4784384,_4784386,_4784388)).
'blocked_System.IO.Unsafe.identicalVar'(_4784484,_4784502,_4784520,_4784858,_4784864,_4784870):-hnf('Prelude.$!'('Prelude.$!'(partcall(2,'System.IO.Unsafe.prim_identicalVar',[]),_4784520),_4784502),_4784858,_4784864,_4784870).

'System.IO.Unsafe.prim_identicalVar'(_4786854,_4786856,_4786858,_4786860,_4786862):-freeze(_4786860,'blocked_System.IO.Unsafe.prim_identicalVar'(_4786854,_4786856,_4786858,_4786860,_4786862)).
'blocked_System.IO.Unsafe.prim_identicalVar'(_4786944,_4786950,_4786956,_4786962,_4786968):-derefAll(_4786944,_4787014),derefAll(_4786950,_4787020),'System.IO.Unsafe.prim_identicalVar'(_4787014,_4787020,_4786956),_4786962=_4786968.

'System.IO.Unsafe.isGround'(_4788240,_4788242,_4788244,_4788246,_4788248):-freeze(_4788246,'blocked_System.IO.Unsafe.isGround'(_4788240,_4788242,_4788244,_4788246,_4788248)).
'blocked_System.IO.Unsafe.isGround'(_4788336,_4788354,_4788538,_4788544,_4788550):-hnf('Prelude.$!!'(partcall(1,'System.IO.Unsafe.prim_isGround',[]),_4788354),_4788538,_4788544,_4788550).

'System.IO.Unsafe.prim_isGround'(_4790056,_4790058,_4790060,_4790062):-freeze(_4790060,'blocked_System.IO.Unsafe.prim_isGround'(_4790056,_4790058,_4790060,_4790062)).
'blocked_System.IO.Unsafe.prim_isGround'(_4790136,_4790142,_4790148,_4790154):-derefAll(_4790136,_4790192),'System.IO.Unsafe.prim_isGround'(_4790192,_4790142),_4790148=_4790154.

'System.IO.Unsafe.showAnyTerm'(_4791666,_4791668,_4791670,_4791672):-freeze(_4791670,'blocked_System.IO.Unsafe.showAnyTerm'(_4791666,_4791668,_4791670,_4791672)).
'blocked_System.IO.Unsafe.showAnyTerm'(_4791752,_4791936,_4791942,_4791948):-hnf('Prelude.$!!'(partcall(1,'System.IO.Unsafe.prim_showAnyTerm',[]),_4791752),_4791936,_4791942,_4791948).

'System.IO.Unsafe.prim_showAnyTerm'(_4793452,_4793454,_4793456,_4793458):-freeze(_4793456,'blocked_System.IO.Unsafe.prim_showAnyTerm'(_4793452,_4793454,_4793456,_4793458)).
'blocked_System.IO.Unsafe.prim_showAnyTerm'(_4793532,_4793538,_4793544,_4793550):-derefAll(_4793532,_4793588),'System.IO.Unsafe.prim_showAnyTerm'(_4793588,_4793538),_4793544=_4793550.

'System.IO.Unsafe.readsAnyUnqualifiedTerm'(_4795338,_4795340,_4795342,_4795344,_4795346):-freeze(_4795344,'blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm'(_4795338,_4795340,_4795342,_4795344,_4795346)).
'blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm'(_4795434,_4795452,_4807210,_4807216,_4807222):-hnf(_4795434,_4809036,_4807216,_4809054),'blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm_1'(_4809036,_4795452,_4807210,_4809054,_4807222).

'blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm_1'(_4809544,_4809546,_4809548,_4809550,_4809552):-freeze(_4809550,'blocked_blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm_1'(_4809544,_4809546,_4809548,_4809550,_4809552)).
'blocked_blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm_1'([],_4795452,_4809796,_4809802,_4809808):-hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^s','^A','^n','^y','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^l','^i','^s','^t','^ ','^o','^f','^ ','^m','^o','^d','^u','^l','^e','^ ','^p','^r','^e','^f','^i','^x','^e','^s','^ ','^i','^s','^ ','^e','^m','^p','^t','^y']),_4809796,_4809802,_4809808).
'blocked_blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm_1'([_4806532|_4806550],_4795452,_4824870,_4824876,_4824882):-!,hnf('System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes'([_4806532|_4806550],_4795452),_4824870,_4824876,_4824882).
'blocked_blocked_System.IO.Unsafe.readsAnyUnqualifiedTerm_1'('FAIL'(_4826316),_4795452,'FAIL'(_4826316),_4826330,_4826330):-nonvar(_4826316).

'System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes'(_4828498,_4828500,_4828502,_4828504,_4828506):-freeze(_4828504,'blocked_System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes'(_4828498,_4828500,_4828502,_4828504,_4828506)).
'blocked_System.IO.Unsafe.readsAnyUnqualifiedTermWithPrefixes'(_4828594,_4828612,_4828950,_4828956,_4828962):-hnf('Prelude.$##'('Prelude.$##'(partcall(2,'System.IO.Unsafe.prim_readsAnyUnqualifiedTerm',[]),_4828594),_4828612),_4828950,_4828956,_4828962).

'System.IO.Unsafe.prim_readsAnyUnqualifiedTerm'(_4831268,_4831270,_4831272,_4831274,_4831276):-freeze(_4831274,'blocked_System.IO.Unsafe.prim_readsAnyUnqualifiedTerm'(_4831268,_4831270,_4831272,_4831274,_4831276)).
'blocked_System.IO.Unsafe.prim_readsAnyUnqualifiedTerm'(_4831358,_4831364,_4831370,_4831376,_4831382):-derefAll(_4831358,_4831428),derefAll(_4831364,_4831434),'System.IO.Unsafe.prim_readsAnyUnqualifiedTerm'(_4831428,_4831434,_4831370),_4831376=_4831382.

'System.IO.Unsafe.readAnyUnqualifiedTerm'(_4833186,_4833188,_4833190,_4833192,_4833194):-freeze(_4833192,'blocked_System.IO.Unsafe.readAnyUnqualifiedTerm'(_4833186,_4833188,_4833190,_4833192,_4833194)).
'blocked_System.IO.Unsafe.readAnyUnqualifiedTerm'(_4833282,_4833300,_4833896,_4833902,_4833908):-makeShare(_4833328,_4834060),hnf('Prelude.cond'(letrec4PAKCS(_4834060,'System.IO.Unsafe.readsAnyUnqualifiedTerm'(_4833282,_4833300)),'System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0'(_4834060)),_4833896,_4833902,_4833908).

'System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0'(_4838430,_4838432,_4838434,_4838436):-freeze(_4838434,'blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0'(_4838430,_4838432,_4838434,_4838436)).
'blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0'(_4838516,_4864472,_4864478,_4864484):-hnf(_4838516,_4866686,_4864478,_4866698),'blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1'(_4866686,_4864472,_4866698,_4864484).

'blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1'(_4867252,_4867254,_4867256,_4867258):-freeze(_4867256,freeze(_4867252,'blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1'(_4867252,_4867254,_4867256,_4867258))).
'blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1'([_4838632|_4838650],_4867972,_4867978,_4867984):-hnf(_4838632,_4870666,_4867978,_4870684),'blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1'(_4870666,_4838650,_4867972,_4870684,_4867984).

'blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1'(_4871330,_4871332,_4871334,_4871336,_4871338):-freeze(_4871336,freeze(_4871330,'blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1'(_4871330,_4871332,_4871334,_4871336,_4871338))).
'blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1'('Prelude.(,)'(_4838778,_4838796),_4838650,_4872260,_4872266,_4872272):-!,hnf(_4838650,_4875706,_4872266,_4875730),'blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_4875706,_4838778,_4838796,_4872260,_4875730,_4872272).

'blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_4876534,_4876536,_4876538,_4876540,_4876542,_4876544):-freeze(_4876542,freeze(_4876534,'blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_4876534,_4876536,_4876538,_4876540,_4876542,_4876544))).
'blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'([],_4838778,_4838796,_4880670,_4880676,_4880682):-makeShare(_4838796,_4877180),hnf('Prelude.apply'('Prelude.all'(partcall(1,'Prelude.isSpace',[])),_4877180),_4884748,_4880676,_4884714),'blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_4884748,_4838778,_4877180,_4880670,_4884714,_4880682).

'blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_4885650,_4885652,_4885654,_4885656,_4885658,_4885660):-freeze(_4885658,freeze(_4885650,'blocked_blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_4885650,_4885652,_4885654,_4885656,_4885658,_4885660))).
'blocked_blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('Prelude.True',_4838778,_4877180,_4886054,_4886060,_4886066):-hnf(_4838778,_4886054,_4886060,_4886066).
'blocked_blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('Prelude.False',_4838778,_4877180,_4887402,_4887408,_4887414):-!,hnf('Prelude.error'('Prelude.++'(['^U','^n','^s','^a','^f','^e',^.,'^r','^e','^a','^d','^A','^n','^y','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^n','^o','^ ','^p','^a','^r','^s','^e','^,','^ '],'Prelude.++'(['^u','^n','^m','^a','^t','^c','^h','^e','^d','^ ','^s','^t','^r','^i','^n','^g','^ ','^a','^f','^t','^e','^r','^ ','^t','^e','^r','^m',^:,'^ '],_4877180))),_4887402,_4887408,_4887414).
'blocked_blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('FAIL'(_4903462),_4838778,_4877180,'FAIL'(_4903462),_4903476,_4903476).
'blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'([_4850652|_4850670],_4838778,_4838796,_4903734,_4903740,_4903746):-!,hnf('Prelude.error'(['^U','^n','^s','^a','^f','^e',^.,'^r','^e','^a','^d','^A','^n','^y','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^a','^m','^b','^i','^g','^u','^o','^u','^s','^ ','^p','^a','^r','^s','^e']),_4903734,_4903740,_4903746).
'blocked_blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'('FAIL'(_4914276),_4838778,_4838796,'FAIL'(_4914276),_4914290,_4914290).
'blocked_blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1_[|]_1'('FAIL'(_4914358),_4838650,'FAIL'(_4914358),_4914372,_4914372).
'blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1'([],_4914594,_4914600,_4914606):-!,hnf('Prelude.error'(['^U','^n','^s','^a','^f','^e',^.,'^r','^e','^a','^d','^A','^n','^y','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^n','^o','^ ','^p','^a','^r','^s','^e']),_4914594,_4914600,_4914606).
'blocked_blocked_System.IO.Unsafe.readAnyUnqualifiedTerm._\'23caseor0_1'('FAIL'(_4923226),'FAIL'(_4923226),_4923240,_4923240).

:-costCenters(['']).




%%%%% Number of shared variables: 2

:-style_check(-singleton).
prim_unsafePerformIO(_4923622,_4923624,_4923626,_4923628):-freeze(_4923626,blocked_prim_unsafePerformIO(_4923622,_4923624,_4923626,_4923628)).
blocked_prim_unsafePerformIO(_4923698,_4923700,_4923702,_4923704):-worldToken(_4923708),prim_apply(_4923698,_4923708,'$io'(_4923712),_4923702,_4923724),user:hnf(_4923712,_4923700,_4923724,_4923704).
prim_spawnConstraint(_4924118,_4924120,_4924122,_4924124,_4924126):-freeze(_4924124,blocked_prim_spawnConstraint(_4924118,_4924120,_4924122,_4924124,_4924126)).
blocked_prim_spawnConstraint(_4924204,_4924206,_4924208,_4924210,_4924212):-user:hnf(_4924204,_4924218,_4924210,_4924222),user:hnf(_4924206,_4924208,_4924210,_4924212).
'System.IO.Unsafe.prim_isVar'(_4924328,_4924330):-var(_4924328),!,_4924330='Prelude.True'.
'System.IO.Unsafe.prim_isVar'('VAR'(_4924406),_4924412):-!,_4924412='Prelude.True'.
'System.IO.Unsafe.prim_isVar'(_4924478,'Prelude.False').
'System.IO.Unsafe.prim_identicalVar'(_4924522,_4924524,_4924526):-var(_4924524),var(_4924522),!,(_4924524==_4924522->_4924526='Prelude.True';_4924526='Prelude.False').
'System.IO.Unsafe.prim_identicalVar'(_4924644,_4924646,_4924648):-var(_4924646),!,_4924648='Prelude.False'.
'System.IO.Unsafe.prim_identicalVar'(_4924732,_4924734,_4924736):-var(_4924732),!,_4924736='Prelude.False'.
'System.IO.Unsafe.prim_identicalVar'('VAR'(_4924820),'VAR'(_4924824),_4924832):-!,(_4924820=_4924824->_4924832='Prelude.True';_4924832='Prelude.False').
'System.IO.Unsafe.prim_identicalVar'(_4924930,_4924932,'Prelude.False').
'System.IO.Unsafe.prim_isGround'(_4924984,_4924986):-var(_4924984),!,_4924986='Prelude.False'.
'System.IO.Unsafe.prim_isGround'(_4925062,_4925064):-functor(_4925062,_4925070,_4925072),prim_isGroundArgs(1,_4925072,_4925062,_4925064).
prim_isGroundArgs(_4925142,_4925144,_4925146,_4925148):-_4925142>_4925144,!,_4925148='Prelude.True'.
prim_isGroundArgs(_4925242,_4925244,_4925246,_4925248):-arg(_4925242,_4925246,_4925256),'System.IO.Unsafe.prim_isGround'(_4925256,_4925262),(_4925262='Prelude.False'->_4925248=_4925262;_4925290 is _4925242+1,prim_isGroundArgs(_4925290,_4925244,_4925246,_4925248)).
prim_compareAnyTerm(_4925686,_4925688,_4925690,_4925692,_4925694):-freeze(_4925692,blocked_prim_compareAnyTerm(_4925686,_4925688,_4925690,_4925692,_4925694)).
blocked_prim_compareAnyTerm(_4925772,_4925774,_4925776,_4925778,_4925780):-user:hnf(_4925772,_4925786,_4925778,_4925790),user:hnf(_4925774,_4925802,_4925790,_4925806),prim_compareAnyTermHNF(_4925786,_4925802,_4925776,_4925806,_4925780).
prim_compareAnyTermHNF(_4926222,_4926224,_4926226,_4926228,_4926230):-freeze(_4926228,blocked_prim_compareAnyTermHNF(_4926222,_4926224,_4926226,_4926228,_4926230)).
blocked_prim_compareAnyTermHNF(_4926308,_4926310,_4926312,_4926314,_4926316):-(var(_4926308);var(_4926310)),!,(_4926308==_4926310->_4926312='Prelude.EQ';_4926308@<_4926310->_4926312='Prelude.LT';_4926312='Prelude.GT'),_4926314=_4926316.
blocked_prim_compareAnyTermHNF('FAIL'(_4926486),_4926496,'FAIL'(_4926486),_4926500,_4926500):-!.
blocked_prim_compareAnyTermHNF(_4926588,'FAIL'(_4926580),'FAIL'(_4926580),_4926594,_4926594):-!.
blocked_prim_compareAnyTermHNF(_4926674,_4926676,_4926678,_4926680,_4926682):-number(_4926674),!,(_4926674=_4926676->_4926678='Prelude.EQ';_4926674<_4926676->_4926678='Prelude.LT';_4926678='Prelude.GT'),_4926680=_4926682.
blocked_prim_compareAnyTermHNF(_4926842,_4926844,_4926846,_4926848,_4926850):-isCharCons(_4926842),!,char_int(_4926842,_4926860),char_int(_4926844,_4926866),(_4926860=_4926866->_4926846='Prelude.EQ';_4926860<_4926866->_4926846='Prelude.LT';_4926846='Prelude.GT'),_4926848=_4926850.
blocked_prim_compareAnyTermHNF(_4927034,_4927036,_4927038,_4927040,_4927042):-functor(_4927034,_4927048,_4927050),functor(_4927036,_4927056,_4927058),user:constructortype(_4927048,_4927064,_4927050,_4927068,_4927070,_4927072,_4927074),user:constructortype(_4927056,_4927086,_4927058,_4927090,_4927092,_4927094,_4927096),!,(_4927070<_4927092->_4927038='Prelude.LT',_4927040=_4927042;_4927070>_4927092->_4927038='Prelude.GT',_4927040=_4927042;prim_compareAnyTermArgs(1,_4927050,_4927034,_4927036,_4927038,_4927040,_4927042)).
prim_compareAnyTermArgs(_4927616,_4927618,_4927620,_4927622,_4927624,_4927626,_4927628):-freeze(_4927626,blocked_prim_compareAnyTermArgs(_4927616,_4927618,_4927620,_4927622,_4927624,_4927626,_4927628)).
blocked_prim_compareAnyTermArgs(_4927722,_4927724,_4927726,_4927728,_4927730,_4927732,_4927734):-_4927722>_4927724,!,_4927730='Prelude.EQ',_4927732=_4927734.
blocked_prim_compareAnyTermArgs(_4927864,_4927866,_4927868,_4927870,_4927872,_4927874,_4927876):-arg(_4927864,_4927868,_4927884),arg(_4927864,_4927870,_4927892),prim_compareAnyTerm(_4927884,_4927892,_4927900,_4927874,_4927904),(_4927900='Prelude.EQ'->_4927920 is _4927864+1,prim_compareAnyTermArgs(_4927920,_4927866,_4927868,_4927870,_4927872,_4927904,_4927876);_4927872=_4927900,_4927904=_4927876).
'System.IO.Unsafe.prim_showAnyTerm'(_4928086,_4928088):-copy_term(_4928086,_4928094),groundTermVars(_4928094,0,_4928102),readShowTerm:show_term(_4928094,unqualified,_4928088,[]).
'System.IO.Unsafe.prim_showAnyQTerm'(_4928184,_4928186):-copy_term(_4928184,_4928192),groundTermVars(_4928192,0,_4928200),readShowTerm:show_term(_4928192,qualified,_4928186,[]).
prim_showAnyExpression(_4928588,_4928590,_4928592,_4928594):-freeze(_4928592,blocked_prim_showAnyExpression(_4928588,_4928590,_4928592,_4928594)).
blocked_prim_showAnyExpression(_4928664,_4928666,_4928668,_4928670):-removeShares(_4928664,_4928676),copy_term(_4928676,_4928682),groundTermVars(_4928682,0,_4928690),readShowTerm:show_term(_4928682,unqualified,_4928666,[]),_4928668=_4928670.
prim_showAnyQExpression(_4929118,_4929120,_4929122,_4929124):-freeze(_4929122,blocked_prim_showAnyQExpression(_4929118,_4929120,_4929122,_4929124)).
blocked_prim_showAnyQExpression(_4929194,_4929196,_4929198,_4929200):-shares2let(_4929204,_4929194,_4929208),bindSingleLets(_4929204),copy_term(_4929208,_4929218),groundTermVars(_4929218,0,_4929226),readShowTerm:show_term(_4929218,qualified,_4929196,[]),_4929198=_4929200.
shares2let(_4929348,_4929350,_4929350):-var(_4929350),!.
shares2let(_4929430,makeShare(_4929424,_4929426),_4929434):-!,shares2let(_4929430,_4929424,_4929434),writeErr('MAKESHARE OCCURRED'),nlErr.
shares2let(_4929530,share(_4929526),_4929534):-lookupMutable(_4929530,_4929526,_4929534),!.
shares2let(_4929614,share(_4929610),_4929618):-!,get_mutable(_4929622,_4929610),(_4929622='$eval'(_4929628)->true;_4929628=_4929622),shares2let(_4929614,_4929628,_4929660),addOL(_4929614,(_4929610,_4929670,_4929660,_4929618)).
shares2let(_4929770,_4929772,_4929774):-_4929772=..[_4929780|_4929782],shares2letL(_4929770,_4929782,_4929796),_4929774=..[_4929780|_4929796].
shares2letL(_4929884,[],[]).
shares2letL(_4929954,[_4929940|_4929942],[_4929948|_4929950]):-shares2let(_4929954,_4929940,_4929948),shares2letL(_4929954,_4929942,_4929950).
lookupMutable(_4930042,_4930044,_4930046):-var(_4930042),!,fail.
lookupMutable([(_4930138,_4930132,_4930126,_4930128)|_4930146],_4930152,_4930154):-_4930152==_4930138,!,_4930154=_4930132,_4930128=let(_4930154,_4930126).
lookupMutable([_4930260|_4930262],_4930268,_4930270):-lookupMutable(_4930262,_4930268,_4930270).
addOL(_4930340,_4930342):-var(_4930340),!,_4930340=[_4930342|_4930354].
addOL([_4930428|_4930430],_4930436):-addOL(_4930430,_4930436).
bindSingleLets(_4930496):-var(_4930496),!.
bindSingleLets([(_4930566,_4930560,_4930554,_4930556)|_4930574]):-(var(_4930556)->_4930556=_4930554;true),bindSingleLets(_4930574).
groundTermVars(_4930656,_4930658,_4930660):-var(_4930656),!,_4930656='_'(_4930658),_4930660 is _4930658+1.
groundTermVars(_4930766,_4930768,_4930768):-atom(_4930766),!.
groundTermVars(_4930842,_4930844,_4930846):-_4930842=..[_4930852|_4930854],groundTermsVars(_4930854,_4930844,_4930846).
groundTermsVars([],_4930938,_4930938).
groundTermsVars([_4930992|_4930994],_4931000,_4931002):-groundTermVars(_4930992,_4931000,_4931010),groundTermsVars(_4930994,_4931010,_4931002).
'System.IO.Unsafe.prim_readsAnyQTerm'(_4931100,['Prelude.(,)'(_4931088,_4931090)]):-map2M(basics:char_int,_4931100,_4931116),readShowTerm:readTerm(_4931116,any_qualified,_4931124,_4931126),ungroundTermVars(_4931126,_4931088,_4931140),map2M(basics:char_int,_4931090,_4931124),!.
'System.IO.Unsafe.prim_readsAnyQTerm'(_4931232,[]).
'System.IO.Unsafe.prim_readsAnyUnqualifiedTerm'(_4931290,_4931292,['Prelude.(,)'(_4931278,_4931280)]):-(_4931290=[]->_4931304=any;map2M(prim_readshowterm:prefix2prefixdot,_4931290,_4931304)),map2M(basics:char_int,_4931292,_4931346),readShowTerm:readTerm(_4931346,any_unqualified(_4931304),_4931358,_4931360),ungroundTermVars(_4931360,_4931278,_4931374),map2M(basics:char_int,_4931280,_4931358),!.
'System.IO.Unsafe.prim_readsAnyUnqualifiedTerm'(_4931480,_4931482,[]).
'System.IO.Unsafe.prim_readsAnyQExpression'(_4931548,['Prelude.(,)'(_4931536,_4931538)]):-map2M(basics:char_int,_4931548,_4931564),readShowTerm:readTerm(_4931564,any_expression,_4931572,_4931574),ungroundTermVars(_4931574,_4931586,_4931588),let2share(_4931586,_4931536),map2M(basics:char_int,_4931538,_4931572),!.
'System.IO.Unsafe.prim_readsAnyQExpression'(_4931692,[]).
let2share(_4931736,_4931736):-var(_4931736),!.
let2share(share(_4931802),share(_4931802)):-!.
let2share(let(_4931866,_4931868),_4931866):-!,create_mutable(_4931868,_4931880),_4931866=share(_4931880).
let2share(_4931956,_4931958):-_4931956=..[_4931964|_4931966],map2M(user:let2share,_4931966,_4931986),_4931958=..[_4931964|_4931986].
ungroundTermVars('_'(_4932066),_4932072,_4932074):-!,getVarIndex(_4932074,_4932066,_4932072).
ungroundTermVars(_4932150,_4932150,_4932154):-atom(_4932150),!.
ungroundTermVars(_4932226,_4932228,_4932230):-_4932226=..[_4932236|_4932238],ungroundTermsVars(_4932238,_4932250,_4932230),_4932228=..[_4932236|_4932250].
ungroundTermsVars([],[],_4932344).
ungroundTermsVars([_4932396|_4932398],[_4932404|_4932406],_4932414):-ungroundTermVars(_4932396,_4932404,_4932414),ungroundTermsVars(_4932398,_4932406,_4932414).
getVarIndex(_4932498,_4932500,_4932502):-var(_4932498),!,_4932498=[_4932500=_4932502|_4932520].
getVarIndex([_4932602=_4932604|_4932610],_4932602,_4932618):-!,_4932604=_4932618.
getVarIndex([_4932694|_4932696],_4932702,_4932704):-getVarIndex(_4932696,_4932702,_4932704).
