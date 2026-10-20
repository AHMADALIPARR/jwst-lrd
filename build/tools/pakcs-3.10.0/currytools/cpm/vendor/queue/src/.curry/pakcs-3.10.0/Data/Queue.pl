%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.Queue').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23','_inst#Prelude.Data#Data.Queue.Queue#0##',2,'Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23',nofix,notype).
functiontype('Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23','_impl#===#Prelude.Data#Data.Queue.Queue#0##',3,'Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23',nofix,notype).
functiontype('Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23','_impl#aValue#Prelude.Data#Data.Queue.Queue#0##',1,'Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23',nofix,notype).
functiontype('Data.Queue.empty',empty,0,'Data.Queue.empty',nofix,notype).
functiontype('Data.Queue.cons',cons,2,'Data.Queue.cons',nofix,notype).
functiontype('Data.Queue.snoc',snoc,2,'Data.Queue.snoc',nofix,notype).
functiontype('Data.Queue.isEmpty',isEmpty,1,'Data.Queue.isEmpty',nofix,notype).
functiontype('Data.Queue.deqLength',deqLength,1,'Data.Queue.deqLength',nofix,notype).
functiontype('Data.Queue.deqHead',deqHead,1,'Data.Queue.deqHead',nofix,notype).
functiontype('Data.Queue.deqTail',deqTail,1,'Data.Queue.deqTail',nofix,notype).
functiontype('Data.Queue.deqLast',deqLast,1,'Data.Queue.deqLast',nofix,notype).
functiontype('Data.Queue.deqInit',deqInit,1,'Data.Queue.deqInit',nofix,notype).
functiontype('Data.Queue.deqReverse',deqReverse,1,'Data.Queue.deqReverse',nofix,notype).
functiontype('Data.Queue.rotate',rotate,1,'Data.Queue.rotate',nofix,notype).
functiontype('Data.Queue.matchHead',matchHead,1,'Data.Queue.matchHead',nofix,notype).
functiontype('Data.Queue.matchLast',matchLast,1,'Data.Queue.matchLast',nofix,notype).
functiontype('Data.Queue.listToDeq',listToDeq,1,'Data.Queue.listToDeq',nofix,notype).
functiontype('Data.Queue.deqToList',deqToList,1,'Data.Queue.deqToList',nofix,notype).
functiontype('Data.Queue.check','Data.Queue.check',4,'Data.Queue.check',nofix,notype).
functiontype('Data.Queue.check._\'23selFP2\'23f\'27','Data.Queue.check._#selFP2#f\'',1,'Data.Queue.check._\'23selFP2\'23f\'27',nofix,notype).
functiontype('Data.Queue.check._\'23selFP3\'23rf\'27','Data.Queue.check._#selFP3#rf\'',1,'Data.Queue.check._\'23selFP3\'23rf\'27',nofix,notype).
functiontype('Data.Queue.deqHead._\'23caseor0','Data.Queue.deqHead._#caseor0',3,'Data.Queue.deqHead._\'23caseor0',nofix,notype).
functiontype('Data.Queue.deqLast._\'23caseor0','Data.Queue.deqLast._#caseor0',3,'Data.Queue.deqLast._\'23caseor0',nofix,notype).
functiontype('Data.Queue.check._\'23caseor0','Data.Queue.check._#caseor0',9,'Data.Queue.check._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Data.Queue.S','Data.Queue.S',4,'Queue.S',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31683602,_31683604,_31683606,_31683608,_31683610):-freeze(_31683608,'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31683602,_31683604,_31683606,_31683608,_31683610)).
'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31683698,_31683716,_31684604,_31684610,_31684616):-hnf(_31683716,_31687150,_31684610,_31687168),'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_31687150,_31683698,_31684604,_31687168,_31684616).

'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_31687778,_31687780,_31687782,_31687784,_31687786):-freeze(_31687784,'blocked_blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_31687778,_31687780,_31687782,_31687784,_31687786)).
'blocked_blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('Prelude.()',_31683698,'Prelude._Dict\'23Data'(partcall(2,'Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23',[_31688232]),'Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31688232)),_31688140,_31688146):-!,makeShare(_31683698,_31688232),_31688140=_31688146.
'blocked_blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('FAIL'(_31690448),_31683698,'FAIL'(_31690448),_31690462,_31690462):-nonvar(_31690448).

'Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31692986,_31692988,_31692990,_31692992,_31692994,_31692996):-freeze(_31692994,'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31692986,_31692988,_31692990,_31692992,_31692994,_31692996)).
'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31693092,_31693110,_31693128,_31695616,_31695622,_31695628):-hnf(_31693110,_31698602,_31695622,_31698626),'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_31698602,_31693092,_31693128,_31695616,_31698626,_31695628).

'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_31699316,_31699318,_31699320,_31699322,_31699324,_31699326):-freeze(_31699324,'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_31699316,_31699318,_31699320,_31699322,_31699324,_31699326)).
'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('Data.Queue.S'(_31693244,_31693262,_31693280,_31693298),_31693092,_31693128,_31700358,_31700364,_31700370):-!,hnf(_31693128,_31704094,_31700364,_31704136),'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'(_31704094,_31693244,_31693262,_31693280,_31693298,_31693092,_31700358,_31704136,_31700370).

'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'(_31705006,_31705008,_31705010,_31705012,_31705014,_31705016,_31705018,_31705020,_31705022):-freeze(_31705020,'blocked_blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'(_31705006,_31705008,_31705010,_31705012,_31705014,_31705016,_31705018,_31705020,_31705022)).
'blocked_blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'('Data.Queue.S'(_31693438,_31693456,_31693474,_31693492),_31693244,_31693262,_31693280,_31693298,_31693092,_31705468,_31705474,_31705480):-!,makeShare(_31693092,_31706182),hnf('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_31693244),_31693438),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_31706182,_31693262,_31693456)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_31693280),_31693474)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_31706182,_31693298,_31693492)),_31705468,_31705474,_31705480).
'blocked_blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'('FAIL'(_31711740),_31693244,_31693262,_31693280,_31693298,_31693092,'FAIL'(_31711740),_31711754,_31711754):-nonvar(_31711740).
'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('FAIL'(_31711850),_31693092,_31693128,'FAIL'(_31711850),_31711864,_31711864):-nonvar(_31711850).

'Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31714426,_31714428,_31714430,_31714432):-freeze(_31714430,'blocked_Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31714426,_31714428,_31714430,_31714432)).
'blocked_Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_31714512,'Data.Queue.S'('Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_31715112),'Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_31715112)),_31715024,_31715030):-makeShare(_31714512,_31715112),_31715024=_31715030.

'Data.Queue.empty'(_31718684,_31718686,_31718688):-freeze(_31718686,'blocked_Data.Queue.empty'(_31718684,_31718686,_31718688)).
'blocked_Data.Queue.empty'('Data.Queue.S'(0,[],0,[]),_31719086,_31719086).

'Data.Queue.cons'(_31720476,_31720478,_31720480,_31720482,_31720484):-freeze(_31720482,'blocked_Data.Queue.cons'(_31720476,_31720478,_31720480,_31720482,_31720484)).
'blocked_Data.Queue.cons'(_31720572,_31720590,_31721584,_31721590,_31721596):-hnf(_31720590,_31722510,_31721590,_31722528),'blocked_Data.Queue.cons_2'(_31722510,_31720572,_31721584,_31722528,_31721596).

'blocked_Data.Queue.cons_2'(_31722868,_31722870,_31722872,_31722874,_31722876):-freeze(_31722874,'blocked_blocked_Data.Queue.cons_2'(_31722868,_31722870,_31722872,_31722874,_31722876)).
'blocked_blocked_Data.Queue.cons_2'('Data.Queue.S'(_31720706,_31720724,_31720742,_31720760),_31720572,_31723290,_31723296,_31723302):-!,hnf('Data.Queue.check'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31720706,1),[_31720572|_31720724],_31720742,_31720760),_31723290,_31723296,_31723302).
'blocked_blocked_Data.Queue.cons_2'('FAIL'(_31725264),_31720572,'FAIL'(_31725264),_31725278,_31725278):-nonvar(_31725264).

'Data.Queue.snoc'(_31726040,_31726042,_31726044,_31726046,_31726048):-freeze(_31726046,'blocked_Data.Queue.snoc'(_31726040,_31726042,_31726044,_31726046,_31726048)).
'blocked_Data.Queue.snoc'(_31726136,_31726154,_31727232,_31727238,_31727244):-hnf(_31726154,_31728158,_31727238,_31728176),'blocked_Data.Queue.snoc_2'(_31728158,_31726136,_31727232,_31728176,_31727244).

'blocked_Data.Queue.snoc_2'(_31728516,_31728518,_31728520,_31728522,_31728524):-freeze(_31728522,'blocked_blocked_Data.Queue.snoc_2'(_31728516,_31728518,_31728520,_31728522,_31728524)).
'blocked_blocked_Data.Queue.snoc_2'('Data.Queue.S'(_31726270,_31726288,_31726306,_31726324),_31726136,_31728938,_31728944,_31728950):-!,hnf('Data.Queue.deqReverse'('Data.Queue.check'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31726306,1),[_31726136|_31726324],_31726270,_31726288)),_31728938,_31728944,_31728950).
'blocked_blocked_Data.Queue.snoc_2'('FAIL'(_31731148),_31726136,'FAIL'(_31731148),_31731162,_31731162):-nonvar(_31731148).

'Data.Queue.isEmpty'(_31732038,_31732040,_31732042,_31732044):-freeze(_31732042,'blocked_Data.Queue.isEmpty'(_31732038,_31732040,_31732042,_31732044)).
'blocked_Data.Queue.isEmpty'(_31732124,_31732834,_31732840,_31732846):-hnf(_31732124,_31733860,_31732840,_31733872),'blocked_Data.Queue.isEmpty_1'(_31733860,_31732834,_31733872,_31732846).

'blocked_Data.Queue.isEmpty_1'(_31734222,_31734224,_31734226,_31734228):-freeze(_31734226,'blocked_blocked_Data.Queue.isEmpty_1'(_31734222,_31734224,_31734226,_31734228)).
'blocked_blocked_Data.Queue.isEmpty_1'('Data.Queue.S'(_31732240,_31732258,_31732276,_31732294),_31734634,_31734640,_31734646):-!,hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31732240,_31732276),0),_31734634,_31734640,_31734646).
'blocked_blocked_Data.Queue.isEmpty_1'('FAIL'(_31736278),'FAIL'(_31736278),_31736292,_31736292):-nonvar(_31736278).

'Data.Queue.deqLength'(_31737236,_31737238,_31737240,_31737242):-freeze(_31737240,'blocked_Data.Queue.deqLength'(_31737236,_31737238,_31737240,_31737242)).
'blocked_Data.Queue.deqLength'(_31737322,_31737890,_31737896,_31737902):-hnf(_31737322,_31738988,_31737896,_31739000),'blocked_Data.Queue.deqLength_1'(_31738988,_31737890,_31739000,_31737902).

'blocked_Data.Queue.deqLength_1'(_31739362,_31739364,_31739366,_31739368):-freeze(_31739366,'blocked_blocked_Data.Queue.deqLength_1'(_31739362,_31739364,_31739366,_31739368)).
'blocked_blocked_Data.Queue.deqLength_1'('Data.Queue.S'(_31737438,_31737456,_31737474,_31737492),_31739774,_31739780,_31739786):-!,hnf('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31737438,_31737474),_31739774,_31739780,_31739786).
'blocked_blocked_Data.Queue.deqLength_1'('FAIL'(_31740924),'FAIL'(_31740924),_31740938,_31740938):-nonvar(_31740924).

'Data.Queue.deqHead'(_31741806,_31741808,_31741810,_31741812):-freeze(_31741810,'blocked_Data.Queue.deqHead'(_31741806,_31741808,_31741810,_31741812)).
'blocked_Data.Queue.deqHead'(_31741892,_31742756,_31742762,_31742768):-hnf(_31741892,_31743782,_31742762,_31743794),'blocked_Data.Queue.deqHead_1'(_31743782,_31742756,_31743794,_31742768).

'blocked_Data.Queue.deqHead_1'(_31744144,_31744146,_31744148,_31744150):-freeze(_31744148,'blocked_blocked_Data.Queue.deqHead_1'(_31744144,_31744146,_31744148,_31744150)).
'blocked_blocked_Data.Queue.deqHead_1'('Data.Queue.S'(_31742008,_31742026,_31742044,_31742062),_31744556,_31744562,_31744568):-!,hnf('Prelude.head'('Data.Queue.deqHead._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'(_31742008,0),_31742062,_31742026)),_31744556,_31744562,_31744568).
'blocked_blocked_Data.Queue.deqHead_1'('FAIL'(_31746374),'FAIL'(_31746374),_31746388,_31746388):-nonvar(_31746374).

'Data.Queue.deqTail'(_31747256,_31747258,_31747260,_31747262):-freeze(_31747260,'blocked_Data.Queue.deqTail'(_31747256,_31747258,_31747260,_31747262)).
'blocked_Data.Queue.deqTail'(_31747342,_31748528,_31748534,_31748540):-hnf(_31747342,_31749554,_31748534,_31749566),'blocked_Data.Queue.deqTail_1'(_31749554,_31748528,_31749566,_31748540).

'blocked_Data.Queue.deqTail_1'(_31749916,_31749918,_31749920,_31749922):-freeze(_31749920,'blocked_blocked_Data.Queue.deqTail_1'(_31749916,_31749918,_31749920,_31749922)).
'blocked_blocked_Data.Queue.deqTail_1'('Data.Queue.S'(_31747458,_31747476,_31747494,_31747512),_31750582,_31750588,_31750594):-!,hnf(_31747476,_31752358,_31750588,_31752388),'blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'(_31752358,_31747458,_31747494,_31747512,_31750582,_31752388,_31750594).

'blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'(_31752918,_31752920,_31752922,_31752924,_31752926,_31752928,_31752930):-freeze(_31752928,'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'(_31752918,_31752920,_31752922,_31752924,_31752926,_31752928,_31752930)).
'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'([],_31747458,_31747494,_31747512,_31753190,_31753196,_31753202):-hnf('Data.Queue.empty',_31753190,_31753196,_31753202).
'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'([_31747752|_31747770],_31747458,_31747494,_31747512,_31754190,_31754196,_31754202):-!,hnf('Data.Queue.deqReverse'('Data.Queue.check'(_31747494,_31747512,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31747458,1),_31747770)),_31754190,_31754196,_31754202).
'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'('FAIL'(_31756322),_31747458,_31747494,_31747512,'FAIL'(_31756322),_31756336,_31756336):-nonvar(_31756322).
'blocked_blocked_Data.Queue.deqTail_1'('FAIL'(_31756416),'FAIL'(_31756416),_31756430,_31756430):-nonvar(_31756416).

'Data.Queue.deqLast'(_31757298,_31757300,_31757302,_31757304):-freeze(_31757302,'blocked_Data.Queue.deqLast'(_31757298,_31757300,_31757302,_31757304)).
'blocked_Data.Queue.deqLast'(_31757384,_31758248,_31758254,_31758260):-hnf(_31757384,_31759274,_31758254,_31759286),'blocked_Data.Queue.deqLast_1'(_31759274,_31758248,_31759286,_31758260).

'blocked_Data.Queue.deqLast_1'(_31759636,_31759638,_31759640,_31759642):-freeze(_31759640,'blocked_blocked_Data.Queue.deqLast_1'(_31759636,_31759638,_31759640,_31759642)).
'blocked_blocked_Data.Queue.deqLast_1'('Data.Queue.S'(_31757500,_31757518,_31757536,_31757554),_31760048,_31760054,_31760060):-!,hnf('Prelude.head'('Data.Queue.deqLast._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'(_31757536,0),_31757518,_31757554)),_31760048,_31760054,_31760060).
'blocked_blocked_Data.Queue.deqLast_1'('FAIL'(_31761866),'FAIL'(_31761866),_31761880,_31761880):-nonvar(_31761866).

'Data.Queue.deqInit'(_31762748,_31762750,_31762752,_31762754):-freeze(_31762752,'blocked_Data.Queue.deqInit'(_31762748,_31762750,_31762752,_31762754)).
'blocked_Data.Queue.deqInit'(_31762834,_31763936,_31763942,_31763948):-hnf(_31762834,_31764962,_31763942,_31764974),'blocked_Data.Queue.deqInit_1'(_31764962,_31763936,_31764974,_31763948).

'blocked_Data.Queue.deqInit_1'(_31765324,_31765326,_31765328,_31765330):-freeze(_31765328,'blocked_blocked_Data.Queue.deqInit_1'(_31765324,_31765326,_31765328,_31765330)).
'blocked_blocked_Data.Queue.deqInit_1'('Data.Queue.S'(_31762950,_31762968,_31762986,_31763004),_31766006,_31766012,_31766018):-!,hnf(_31763004,_31767782,_31766012,_31767812),'blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'(_31767782,_31762950,_31762968,_31762986,_31766006,_31767812,_31766018).

'blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'(_31768342,_31768344,_31768346,_31768348,_31768350,_31768352,_31768354):-freeze(_31768352,'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'(_31768342,_31768344,_31768346,_31768348,_31768350,_31768352,_31768354)).
'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'([],_31762950,_31762968,_31762986,_31768614,_31768620,_31768626):-hnf('Data.Queue.empty',_31768614,_31768620,_31768626).
'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'([_31763244|_31763262],_31762950,_31762968,_31762986,_31769614,_31769620,_31769626):-!,hnf('Data.Queue.check'(_31762950,_31762968,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31762986,1),_31763262),_31769614,_31769620,_31769626).
'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'('FAIL'(_31771510),_31762950,_31762968,_31762986,'FAIL'(_31771510),_31771524,_31771524):-nonvar(_31771510).
'blocked_blocked_Data.Queue.deqInit_1'('FAIL'(_31771604),'FAIL'(_31771604),_31771618,_31771618):-nonvar(_31771604).

'Data.Queue.deqReverse'(_31772600,_31772602,_31772604,_31772606):-freeze(_31772604,'blocked_Data.Queue.deqReverse'(_31772600,_31772602,_31772604,_31772606)).
'blocked_Data.Queue.deqReverse'(_31772686,_31773400,_31773406,_31773412):-hnf(_31772686,_31774534,_31773406,_31774546),'blocked_Data.Queue.deqReverse_1'(_31774534,_31773400,_31774546,_31773412).

'blocked_Data.Queue.deqReverse_1'(_31774914,_31774916,_31774918,_31774920):-freeze(_31774918,'blocked_blocked_Data.Queue.deqReverse_1'(_31774914,_31774916,_31774918,_31774920)).
'blocked_blocked_Data.Queue.deqReverse_1'('Data.Queue.S'(_31772802,_31772820,_31772838,_31772856),'Data.Queue.S'(_31772838,_31772856,_31772802,_31772820),_31775332,_31775332):-!.
'blocked_blocked_Data.Queue.deqReverse_1'('FAIL'(_31776470),'FAIL'(_31776470),_31776484,_31776484):-nonvar(_31776470).

'Data.Queue.rotate'(_31777314,_31777316,_31777318,_31777320):-freeze(_31777318,'blocked_Data.Queue.rotate'(_31777314,_31777316,_31777318,_31777320)).
'blocked_Data.Queue.rotate'(_31777400,_31777738,_31777744,_31777750):-makeShare(_31777400,_31777828),hnf('Data.Queue.snoc'('Data.Queue.deqHead'(_31777828),'Data.Queue.deqTail'(_31777828)),_31777738,_31777744,_31777750).

'Data.Queue.matchHead'(_31779930,_31779932,_31779934,_31779936):-freeze(_31779934,'blocked_Data.Queue.matchHead'(_31779930,_31779932,_31779934,_31779936)).
'blocked_Data.Queue.matchHead'(_31780016,_31787752,_31787758,_31787764):-hnf(_31780016,_31788850,_31787758,_31788862),'blocked_Data.Queue.matchHead_1'(_31788850,_31787752,_31788862,_31787764).

'blocked_Data.Queue.matchHead_1'(_31789224,_31789226,_31789228,_31789230):-freeze(_31789228,'blocked_blocked_Data.Queue.matchHead_1'(_31789224,_31789226,_31789228,_31789230)).
'blocked_blocked_Data.Queue.matchHead_1'('Data.Queue.S'(_31780132,_31780150,_31780168,_31780186),_31789902,_31789908,_31789914):-!,hnf(_31780150,_31791750,_31789908,_31791780),'blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'(_31791750,_31780132,_31780168,_31780186,_31789902,_31791780,_31789914).

'blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'(_31792322,_31792324,_31792326,_31792328,_31792330,_31792332,_31792334):-freeze(_31792332,'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'(_31792322,_31792324,_31792326,_31792328,_31792330,_31792332,_31792334)).
'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'([],_31780132,_31780168,_31780186,_31793006,_31793012,_31793018):-hnf(_31780186,_31795406,_31793012,_31795430),'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'(_31795406,_31780132,_31780168,_31793006,_31795430,_31793018).

'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'(_31796024,_31796026,_31796028,_31796030,_31796032,_31796034):-freeze(_31796032,'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'(_31796024,_31796026,_31796028,_31796030,_31796032,_31796034)).
'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'([],_31780132,_31780168,'Prelude.Nothing',_31796292,_31796292).
'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'([_31780524|_31780542],_31780132,_31780168,_31797760,_31797766,_31797772):-!,hnf(_31780542,_31800650,_31797766,_31800680),'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'(_31800650,_31780524,_31780132,_31780168,_31797760,_31800680,_31797772).

'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'(_31801384,_31801386,_31801388,_31801390,_31801392,_31801394,_31801396):-freeze(_31801394,'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'(_31801384,_31801386,_31801388,_31801390,_31801392,_31801394,_31801396)).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'([],_31780524,_31780132,_31780168,'Prelude.Just'('Prelude.(,)'(_31780524,'Data.Queue.empty')),_31801662,_31801662).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'([_31781008|_31781026],_31780524,_31780132,_31780168,_31803248,_31803254,_31803260):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),['^D','^a','^t','^a',^.,'^Q','^u','^e','^u','^e',^.,'^m','^a','^t','^c','^h','^H','^e','^a','^d',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^q','^u','^e','^u','^e']),_31803248,_31803254,_31803260).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'('FAIL'(_31811746),_31780524,_31780132,_31780168,'FAIL'(_31811746),_31811760,_31811760):-nonvar(_31811746).
'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'('FAIL'(_31811840),_31780132,_31780168,'FAIL'(_31811840),_31811854,_31811854):-nonvar(_31811840).
'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'([_31786726|_31786744],_31780132,_31780168,_31780186,'Prelude.Just'('Prelude.(,)'(_31786726,'Data.Queue.deqReverse'('Data.Queue.check'(_31780168,_31780186,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31780132,1),_31786744)))),_31812122,_31812122):-!.
'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'('FAIL'(_31814720),_31780132,_31780168,_31780186,'FAIL'(_31814720),_31814734,_31814734):-nonvar(_31814720).
'blocked_blocked_Data.Queue.matchHead_1'('FAIL'(_31814814),'FAIL'(_31814814),_31814828,_31814828):-nonvar(_31814814).

'Data.Queue.matchLast'(_31815772,_31815774,_31815776,_31815778):-freeze(_31815776,'blocked_Data.Queue.matchLast'(_31815772,_31815774,_31815776,_31815778)).
'blocked_Data.Queue.matchLast'(_31815858,_31823510,_31823516,_31823522):-hnf(_31815858,_31824608,_31823516,_31824620),'blocked_Data.Queue.matchLast_1'(_31824608,_31823510,_31824620,_31823522).

'blocked_Data.Queue.matchLast_1'(_31824982,_31824984,_31824986,_31824988):-freeze(_31824986,'blocked_blocked_Data.Queue.matchLast_1'(_31824982,_31824984,_31824986,_31824988)).
'blocked_blocked_Data.Queue.matchLast_1'('Data.Queue.S'(_31815974,_31815992,_31816010,_31816028),_31825676,_31825682,_31825688):-!,hnf(_31816028,_31827524,_31825682,_31827554),'blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'(_31827524,_31815974,_31815992,_31816010,_31825676,_31827554,_31825688).

'blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'(_31828096,_31828098,_31828100,_31828102,_31828104,_31828106,_31828108):-freeze(_31828106,'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'(_31828096,_31828098,_31828100,_31828102,_31828104,_31828106,_31828108)).
'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'([],_31815974,_31815992,_31816010,_31828772,_31828778,_31828784):-hnf(_31815992,_31831172,_31828778,_31831196),'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'(_31831172,_31815974,_31816010,_31828772,_31831196,_31828784).

'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'(_31831790,_31831792,_31831794,_31831796,_31831798,_31831800):-freeze(_31831798,'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'(_31831790,_31831792,_31831794,_31831796,_31831798,_31831800)).
'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'([],_31815974,_31816010,'Prelude.Nothing',_31832058,_31832058).
'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'([_31816366|_31816384],_31815974,_31816010,_31833526,_31833532,_31833538):-!,hnf(_31816384,_31836416,_31833532,_31836446),'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'(_31836416,_31816366,_31815974,_31816010,_31833526,_31836446,_31833538).

'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'(_31837150,_31837152,_31837154,_31837156,_31837158,_31837160,_31837162):-freeze(_31837160,'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'(_31837150,_31837152,_31837154,_31837156,_31837158,_31837160,_31837162)).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'([],_31816366,_31815974,_31816010,'Prelude.Just'('Prelude.(,)'(_31816366,'Data.Queue.empty')),_31837428,_31837428).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'([_31816850|_31816868],_31816366,_31815974,_31816010,_31839014,_31839020,_31839026):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),['^D','^a','^t','^a',^.,'^Q','^u','^e','^u','^e',^.,'^m','^a','^t','^c','^h','^L','^a','^s','^t',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^q','^u','^e','^u','^e']),_31839014,_31839020,_31839026).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'('FAIL'(_31847512),_31816366,_31815974,_31816010,'FAIL'(_31847512),_31847526,_31847526):-nonvar(_31847512).
'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'('FAIL'(_31847606),_31815974,_31816010,'FAIL'(_31847606),_31847620,_31847620):-nonvar(_31847606).
'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'([_31822568|_31822586],_31815974,_31815992,_31816010,'Prelude.Just'('Prelude.(,)'(_31822568,'Data.Queue.check'(_31815974,_31815992,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31816010,1),_31822586))),_31847888,_31847888):-!.
'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'('FAIL'(_31850250),_31815974,_31815992,_31816010,'FAIL'(_31850250),_31850264,_31850264):-nonvar(_31850250).
'blocked_blocked_Data.Queue.matchLast_1'('FAIL'(_31850344),'FAIL'(_31850344),_31850358,_31850358):-nonvar(_31850344).

'Data.Queue.listToDeq'(_31851302,_31851304,_31851306,_31851308):-freeze(_31851306,'blocked_Data.Queue.listToDeq'(_31851302,_31851304,_31851306,_31851308)).
'blocked_Data.Queue.listToDeq'(_31851388,_31851796,_31851802,_31851808):-makeShare(_31851388,_31851888),hnf('Data.Queue.check'('Prelude.length'(_31851888),_31851888,0,[]),_31851796,_31851802,_31851808).

'Data.Queue.deqToList'(_31853954,_31853956,_31853958,_31853960):-freeze(_31853958,'blocked_Data.Queue.deqToList'(_31853954,_31853956,_31853958,_31853960)).
'blocked_Data.Queue.deqToList'(_31854040,_31854776,_31854782,_31854788):-hnf(_31854040,_31855874,_31854782,_31855886),'blocked_Data.Queue.deqToList_1'(_31855874,_31854776,_31855886,_31854788).

'blocked_Data.Queue.deqToList_1'(_31856248,_31856250,_31856252,_31856254):-freeze(_31856252,'blocked_blocked_Data.Queue.deqToList_1'(_31856248,_31856250,_31856252,_31856254)).
'blocked_blocked_Data.Queue.deqToList_1'('Data.Queue.S'(_31854156,_31854174,_31854192,_31854210),_31856660,_31856666,_31856672):-!,hnf('Prelude.++'(_31854174,'Prelude.apply'('Prelude.reverse',_31854210)),_31856660,_31856666,_31856672).
'blocked_blocked_Data.Queue.deqToList_1'('FAIL'(_31858016),'FAIL'(_31858016),_31858030,_31858030):-nonvar(_31858016).

'Data.Queue.check'(_31858822,_31858824,_31858826,_31858828,_31858830,_31858832,_31858834):-freeze(_31858832,'blocked_Data.Queue.check'(_31858822,_31858824,_31858826,_31858828,_31858830,_31858832,_31858834)).
'blocked_Data.Queue.check'(_31858938,_31858956,_31858974,_31858992,_31863722,_31863728,_31863734):-makeShare(_31859020,_31865746),makeShare(_31858938,_31865766),makeShare(_31858974,_31865786),makeShare(_31859038,_31865806),makeShare(_31859056,_31865826),makeShare(_31859074,_31865846),makeShare(_31858956,_31865866),makeShare(_31859092,_31865886),makeShare(_31859110,_31865906),makeShare(_31859128,_31865926),makeShare(_31858992,_31865946),hnf('Prelude.cond'(letrec4PAKCS(_31865746,'Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31865766,_31865786)),'Prelude.cond'(letrec4PAKCS(_31865806,'Prelude.apply'('Prelude.apply'('Prelude._impl\'23div\'23Prelude.Integral\'23Prelude.Int\'23',_31865746),2)),'Prelude.cond'(letrec4PAKCS(_31865826,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31865746,_31865806)),'Prelude.cond'(letrec4PAKCS(_31865846,'Prelude.splitAt'(_31865806,_31865866)),'Prelude.cond'(letrec4PAKCS(_31865886,'Data.Queue.check._\'23selFP2\'23f\'27'(_31865846)),'Prelude.cond'(letrec4PAKCS(_31865906,'Data.Queue.check._\'23selFP3\'23rf\'27'(_31865846)),'Prelude.cond'(letrec4PAKCS(_31865926,'Prelude.++'(_31865946,'Prelude.apply'('Prelude.reverse',_31865906))),'Data.Queue.check._\'23caseor0'('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'(_31865766,'Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2A\'23Prelude.Num\'23Prelude.Int\'23'(3,_31865786),1)),_31865766,_31865866,_31865786,_31865946,_31865806,_31865886,_31865826,_31865926)))))))),_31863722,_31863728,_31863734).

'Data.Queue.check._\'23selFP2\'23f\'27'(_31880086,_31880088,_31880090,_31880092):-freeze(_31880090,'blocked_Data.Queue.check._\'23selFP2\'23f\'27'(_31880086,_31880088,_31880090,_31880092)).
'blocked_Data.Queue.check._\'23selFP2\'23f\'27'(_31880172,_31880622,_31880628,_31880634):-hnf(_31880172,_31882224,_31880628,_31882236),'blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'(_31882224,_31880622,_31882236,_31880634).

'blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'(_31882682,_31882684,_31882686,_31882688):-freeze(_31882686,'blocked_blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'(_31882682,_31882684,_31882686,_31882688)).
'blocked_blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'('Prelude.(,)'(_31880288,_31880306),_31883052,_31883058,_31883064):-!,hnf(_31880288,_31883052,_31883058,_31883064).
'blocked_blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'('FAIL'(_31883636),'FAIL'(_31883636),_31883650,_31883650):-nonvar(_31883636).

'Data.Queue.check._\'23selFP3\'23rf\'27'(_31885048,_31885050,_31885052,_31885054):-freeze(_31885052,'blocked_Data.Queue.check._\'23selFP3\'23rf\'27'(_31885048,_31885050,_31885052,_31885054)).
'blocked_Data.Queue.check._\'23selFP3\'23rf\'27'(_31885134,_31885590,_31885596,_31885602):-hnf(_31885134,_31887228,_31885596,_31887240),'blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'(_31887228,_31885590,_31887240,_31885602).

'blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'(_31887692,_31887694,_31887696,_31887698):-freeze(_31887696,'blocked_blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'(_31887692,_31887694,_31887696,_31887698)).
'blocked_blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'('Prelude.(,)'(_31885250,_31885268),_31888062,_31888068,_31888074):-!,hnf(_31885268,_31888062,_31888068,_31888074).
'blocked_blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'('FAIL'(_31888652),'FAIL'(_31888652),_31888666,_31888666):-nonvar(_31888652).

'Data.Queue.deqHead._\'23caseor0'(_31889942,_31889944,_31889946,_31889948,_31889950,_31889952):-freeze(_31889950,'blocked_Data.Queue.deqHead._\'23caseor0'(_31889942,_31889944,_31889946,_31889948,_31889950,_31889952)).
'blocked_Data.Queue.deqHead._\'23caseor0'(_31890048,_31890066,_31890084,_31890548,_31890554,_31890560):-hnf(_31890048,_31892022,_31890554,_31892046),'blocked_Data.Queue.deqHead._\'23caseor0_1'(_31892022,_31890066,_31890084,_31890548,_31892046,_31890560).

'blocked_Data.Queue.deqHead._\'23caseor0_1'(_31892490,_31892492,_31892494,_31892496,_31892498,_31892500):-freeze(_31892498,freeze(_31892490,'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'(_31892490,_31892492,_31892494,_31892496,_31892498,_31892500))).
'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'('Prelude.True',_31890066,_31890084,_31892894,_31892900,_31892906):-hnf(_31890066,_31892894,_31892900,_31892906).
'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'('Prelude.False',_31890066,_31890084,_31893762,_31893768,_31893774):-!,hnf(_31890084,_31893762,_31893768,_31893774).
'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'('FAIL'(_31894338),_31890066,_31890084,'FAIL'(_31894338),_31894352,_31894352).

'Data.Queue.deqLast._\'23caseor0'(_31895640,_31895642,_31895644,_31895646,_31895648,_31895650):-freeze(_31895648,'blocked_Data.Queue.deqLast._\'23caseor0'(_31895640,_31895642,_31895644,_31895646,_31895648,_31895650)).
'blocked_Data.Queue.deqLast._\'23caseor0'(_31895746,_31895764,_31895782,_31896246,_31896252,_31896258):-hnf(_31895746,_31897720,_31896252,_31897744),'blocked_Data.Queue.deqLast._\'23caseor0_1'(_31897720,_31895764,_31895782,_31896246,_31897744,_31896258).

'blocked_Data.Queue.deqLast._\'23caseor0_1'(_31898188,_31898190,_31898192,_31898194,_31898196,_31898198):-freeze(_31898196,freeze(_31898188,'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'(_31898188,_31898190,_31898192,_31898194,_31898196,_31898198))).
'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'('Prelude.True',_31895764,_31895782,_31898592,_31898598,_31898604):-hnf(_31895764,_31898592,_31898598,_31898604).
'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'('Prelude.False',_31895764,_31895782,_31899460,_31899466,_31899472):-!,hnf(_31895782,_31899460,_31899466,_31899472).
'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'('FAIL'(_31900036),_31895764,_31895782,'FAIL'(_31900036),_31900050,_31900050).

'Data.Queue.check._\'23caseor0'(_31901262,_31901264,_31901266,_31901268,_31901270,_31901272,_31901274,_31901276,_31901278,_31901280,_31901282,_31901284):-freeze(_31901282,'blocked_Data.Queue.check._\'23caseor0'(_31901262,_31901264,_31901266,_31901268,_31901270,_31901272,_31901274,_31901276,_31901278,_31901280,_31901282,_31901284)).
'blocked_Data.Queue.check._\'23caseor0'(_31901428,_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,_31903166,_31903172,_31903178):-hnf(_31901428,_31904616,_31903172,_31904676),'blocked_Data.Queue.check._\'23caseor0_1'(_31904616,_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,_31903166,_31904676,_31903178).

'blocked_Data.Queue.check._\'23caseor0_1'(_31905156,_31905158,_31905160,_31905162,_31905164,_31905166,_31905168,_31905170,_31905172,_31905174,_31905176,_31905178):-freeze(_31905176,freeze(_31905156,'blocked_blocked_Data.Queue.check._\'23caseor0_1'(_31905156,_31905158,_31905160,_31905162,_31905164,_31905166,_31905168,_31905170,_31905172,_31905174,_31905176,_31905178))).
'blocked_blocked_Data.Queue.check._\'23caseor0_1'('Prelude.True',_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,'Data.Queue.S'(_31901446,_31901464,_31901482,_31901500),_31905626,_31905626).
'blocked_blocked_Data.Queue.check._\'23caseor0_1'('Prelude.False',_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,_31908826,_31908832,_31908838):-!,hnf('Prelude.otherwise',_31911194,_31908832,_31911124),'blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'(_31911194,_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,_31908826,_31911124,_31908838).

'blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'(_31911826,_31911828,_31911830,_31911832,_31911834,_31911836,_31911838,_31911840,_31911842,_31911844,_31911846,_31911848):-freeze(_31911846,freeze(_31911826,'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'(_31911826,_31911828,_31911830,_31911832,_31911834,_31911836,_31911838,_31911840,_31911842,_31911844,_31911846,_31911848))).
'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,'Data.Queue.S'(_31901518,_31901536,_31901554,_31901572),_31912296,_31912296).
'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,_31914306,_31914312,_31914318):-!,hnf(reportFailure4PAKCS('Data.Queue.check._\'23caseor0',['Prelude.False']),_31914306,_31914312,_31914318).
'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_31916324),_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,'FAIL'(_31916324),_31916338,_31916338).
'blocked_blocked_Data.Queue.check._\'23caseor0_1'('FAIL'(_31916454),_31901446,_31901464,_31901482,_31901500,_31901518,_31901536,_31901554,_31901572,'FAIL'(_31916454),_31916468,_31916468).

:-costCenters(['']).




%%%%% Number of shared variables: 16

