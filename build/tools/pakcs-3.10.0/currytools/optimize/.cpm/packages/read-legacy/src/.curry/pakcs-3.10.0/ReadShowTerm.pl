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
'ReadShowTerm.showTerm'(_10042940,_10042942,_10042944,_10042946,_10042948):-freeze(_10042946,'blocked_ReadShowTerm.showTerm'(_10042940,_10042942,_10042944,_10042946,_10042948)).
'blocked_ReadShowTerm.showTerm'(_10043036,_10043054,_10043238,_10043244,_10043250):-hnf('Prelude.$##'(partcall(1,'ReadShowTerm.prim_showTerm',[]),_10043054),_10043238,_10043244,_10043250).

'ReadShowTerm.prim_showTerm'(_10044660,_10044662,_10044664,_10044666):-freeze(_10044664,'blocked_ReadShowTerm.prim_showTerm'(_10044660,_10044662,_10044664,_10044666)).
'blocked_ReadShowTerm.prim_showTerm'(_10044740,_10044746,_10044752,_10044758):-derefAll(_10044740,_10044796),'ReadShowTerm.prim_showTerm'(_10044796,_10044746),_10044752=_10044758.

'ReadShowTerm.readsUnqualifiedTerm'(_10046280,_10046282,_10046284,_10046286,_10046288,_10046290):-freeze(_10046288,'blocked_ReadShowTerm.readsUnqualifiedTerm'(_10046280,_10046282,_10046284,_10046286,_10046288,_10046290)).
'blocked_ReadShowTerm.readsUnqualifiedTerm'(_10046386,_10046404,_10046422,_10057754,_10057760,_10057766):-hnf(_10046404,_10059336,_10057760,_10059360),'blocked_ReadShowTerm.readsUnqualifiedTerm_2'(_10059336,_10046386,_10046422,_10057754,_10059360,_10057766).

'blocked_ReadShowTerm.readsUnqualifiedTerm_2'(_10059816,_10059818,_10059820,_10059822,_10059824,_10059826):-freeze(_10059824,'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'(_10059816,_10059818,_10059820,_10059822,_10059824,_10059826)).
'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'([],_10046386,_10046422,_10060078,_10060084,_10060090):-hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^s','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^l','^i','^s','^t','^ ','^o','^f','^ ','^m','^o','^d','^u','^l','^e','^ ','^p','^r','^e','^f','^i','^x','^e','^s','^ ','^i','^s','^ ','^e','^m','^p','^t','^y']),_10060078,_10060084,_10060090).
'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'([_10057040|_10057058],_10046386,_10046422,_10074578,_10074584,_10074590):-!,hnf('ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_10046386,[_10057040|_10057058],_10046422),_10074578,_10074584,_10074590).
'blocked_blocked_ReadShowTerm.readsUnqualifiedTerm_2'('FAIL'(_10076142),_10046386,_10046422,'FAIL'(_10076142),_10076156,_10076156):-nonvar(_10076142).

'ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_10078066,_10078068,_10078070,_10078072,_10078074,_10078076):-freeze(_10078074,'blocked_ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_10078066,_10078068,_10078070,_10078072,_10078074,_10078076)).
'blocked_ReadShowTerm.readsUnqualifiedTermWithPrefixes'(_10078172,_10078190,_10078208,_10078546,_10078552,_10078558):-hnf('Prelude.$##'('Prelude.$##'(partcall(2,'ReadShowTerm.prim_readsUnqualifiedTerm',[]),_10078190),_10078208),_10078546,_10078552,_10078558).

'ReadShowTerm.prim_readsUnqualifiedTerm'(_10080770,_10080772,_10080774,_10080776,_10080778):-freeze(_10080776,'blocked_ReadShowTerm.prim_readsUnqualifiedTerm'(_10080770,_10080772,_10080774,_10080776,_10080778)).
'blocked_ReadShowTerm.prim_readsUnqualifiedTerm'(_10080860,_10080866,_10080872,_10080878,_10080884):-derefAll(_10080860,_10080930),derefAll(_10080866,_10080936),'ReadShowTerm.prim_readsUnqualifiedTerm'(_10080930,_10080936,_10080872),_10080878=_10080884.

'ReadShowTerm.readUnqualifiedTerm'(_10082422,_10082424,_10082426,_10082428,_10082430,_10082432):-freeze(_10082430,'blocked_ReadShowTerm.readUnqualifiedTerm'(_10082422,_10082424,_10082426,_10082428,_10082430,_10082432)).
'blocked_ReadShowTerm.readUnqualifiedTerm'(_10082528,_10082546,_10082564,_10083230,_10083236,_10083242):-makeShare(_10082592,_10083452),hnf('Prelude.cond'(letrec4PAKCS(_10083452,'ReadShowTerm.readsUnqualifiedTerm'(_10082528,_10082546,_10082564)),'ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_10083452)),_10083230,_10083236,_10083242).

'ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_10087382,_10087384,_10087386,_10087388):-freeze(_10087386,'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_10087382,_10087384,_10087386,_10087388)).
'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0'(_10087468,_10114852,_10114858,_10114864):-hnf(_10087468,_10116814,_10114858,_10116826),'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'(_10116814,_10114852,_10116826,_10114864).

'blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'(_10117338,_10117340,_10117342,_10117344):-freeze(_10117342,freeze(_10117338,'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'(_10117338,_10117340,_10117342,_10117344))).
'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'([_10087584|_10087602],_10118016,_10118022,_10118028):-hnf(_10087584,_10120458,_10118022,_10120476),'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'(_10120458,_10087602,_10118016,_10120476,_10118028).

'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'(_10121080,_10121082,_10121084,_10121086,_10121088):-freeze(_10121086,freeze(_10121080,'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'(_10121080,_10121082,_10121084,_10121086,_10121088))).
'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'('Prelude.(,)'(_10087730,_10087748),_10087602,_10121968,_10121974,_10121980):-!,hnf(_10087602,_10125162,_10121974,_10125186),'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_10125162,_10087730,_10087748,_10121968,_10125186,_10121980).

'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_10125948,_10125950,_10125952,_10125954,_10125956,_10125958):-freeze(_10125956,freeze(_10125948,'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_10125948,_10125950,_10125952,_10125954,_10125956,_10125958))).
'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'([],_10087730,_10087748,_10130142,_10130148,_10130154):-makeShare(_10087748,_10126608),hnf('Prelude.apply'('Prelude.all'(partcall(1,'Prelude.isSpace',[])),_10126608),_10133968,_10130148,_10133934),'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_10133968,_10087730,_10126608,_10130142,_10133934,_10130154).

'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_10134828,_10134830,_10134832,_10134834,_10134836,_10134838):-freeze(_10134836,freeze(_10134828,'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'(_10134828,_10134830,_10134832,_10134834,_10134836,_10134838))).
'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('Prelude.True',_10087730,_10126608,_10135232,_10135238,_10135244):-hnf(_10087730,_10135232,_10135238,_10135244).
'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('Prelude.False',_10087730,_10126608,_10136538,_10136544,_10136550):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^n','^o','^ ','^p','^a','^r','^s','^e','^,','^ '],'Prelude.++'(['^u','^n','^m','^a','^t','^c','^h','^e','^d','^ ','^s','^t','^r','^i','^n','^g','^ ','^a','^f','^t','^e','^r','^ ','^t','^e','^r','^m',^:,'^ '],_10126608))),_10136538,_10136544,_10136550).
'blocked_blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3_[]_ComplexCase'('FAIL'(_10153368),_10087730,_10126608,'FAIL'(_10153368),_10153382,_10153382).
'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'([_10100150|_10100168],_10087730,_10087748,_10153640,_10153646,_10153652):-!,hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^a','^m','^b','^i','^g','^u','^o','^u','^s','^ ','^p','^a','^r','^s','^e']),_10153640,_10153646,_10153652).
'blocked_blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1_Prelude.(,)_3'('FAIL'(_10164746),_10087730,_10087748,'FAIL'(_10164746),_10164760,_10164760).
'blocked_blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1_[|]_1'('FAIL'(_10164828),_10087602,'FAIL'(_10164828),_10164842,_10164842).
'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'([],_10165064,_10165070,_10165076):-!,hnf('Prelude.error'(['^R','^e','^a','^d','^S','^h','^o','^w','^T','^e','^r','^m',^.,'^r','^e','^a','^d','^U','^n','^q','^u','^a','^l','^i','^f','^i','^e','^d','^T','^e','^r','^m',^:,'^ ','^n','^o','^ ','^p','^a','^r','^s','^e']),_10165064,_10165070,_10165076).
'blocked_blocked_ReadShowTerm.readUnqualifiedTerm._\'23caseor0_1'('FAIL'(_10174260),'FAIL'(_10174260),_10174274,_10174274).

:-costCenters(['']).




%%%%% Number of shared variables: 2

:-style_check(-singleton).
'ReadShowTerm.prim_showTerm'(_10174350,_10174352):-readShowTerm:prim_showTerm(_10174350,_10174352).
'ReadShowTerm.prim_readsUnqualifiedTerm'(_10174430,_10174432,_10174434):-readShowTerm:prim_readsUnqualifiedTerm(_10174430,_10174432,_10174434).
