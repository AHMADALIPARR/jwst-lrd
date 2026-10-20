%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Data.Char').
:-importModule('Data.Maybe').
:-importModule('Prelude').

:-curryModule('Numeric').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Numeric.readInt',readInt,1,'Numeric.readInt',nofix,notype).
functiontype('Numeric.readInt._\'23lambda2','Numeric.readInt._#lambda2',1,'Numeric.readInt._\'23lambda2',nofix,notype).
functiontype('Numeric.readNat',readNat,1,'Numeric.readNat',nofix,notype).
functiontype('Numeric.readHex',readHex,1,'Numeric.readHex',nofix,notype).
functiontype('Numeric.readOct',readOct,1,'Numeric.readOct',nofix,notype).
functiontype('Numeric.readBin',readBin,1,'Numeric.readBin',nofix,notype).
functiontype('Numeric.readNumPrefix','Numeric.readNumPrefix',5,'Numeric.readNumPrefix',nofix,notype).
functiontype('Numeric.readInt._\'23caseor0','Numeric.readInt._#caseor0',2,'Numeric.readInt._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Numeric.readInt'(_5584120,_5584122,_5584124,_5584126):-freeze(_5584124,'blocked_Numeric.readInt'(_5584120,_5584122,_5584124,_5584126)).
'blocked_Numeric.readInt'(_5584206,_5584886,_5584892,_5584898):-makeShare(_5584234,_5585020),hnf('Prelude.cond'(letrec4PAKCS(_5585020,'Prelude.dropWhile'(partcall(1,'Prelude.isSpace',[]),_5584206)),'Numeric.readInt._\'23caseor0'(_5585020,_5585020)),_5584886,_5584892,_5584898).

'Numeric.readInt._\'23lambda2'(_5587982,_5587984,_5587986,_5587988):-freeze(_5587986,'blocked_Numeric.readInt._\'23lambda2'(_5587982,_5587984,_5587986,_5587988)).
'blocked_Numeric.readInt._\'23lambda2'(_5588068,_5588714,_5588720,_5588726):-hnf(_5588068,_5590064,_5588720,_5590076),'blocked_Numeric.readInt._\'23lambda2_1'(_5590064,_5588714,_5590076,_5588726).

'blocked_Numeric.readInt._\'23lambda2_1'(_5590480,_5590482,_5590484,_5590486):-freeze(_5590484,'blocked_blocked_Numeric.readInt._\'23lambda2_1'(_5590480,_5590482,_5590484,_5590486)).
'blocked_blocked_Numeric.readInt._\'23lambda2_1'('Prelude.(,)'(_5588184,_5588202),'Prelude.(,)'('Prelude._impl\'23negate\'23Prelude.Num\'23Prelude.Int\'23'(_5588184),_5588202),_5590856,_5590856):-!.
'blocked_blocked_Numeric.readInt._\'23lambda2_1'('FAIL'(_5592066),'FAIL'(_5592066),_5592080,_5592080):-nonvar(_5592066).

'Numeric.readNat'(_5592834,_5592836,_5592838,_5592840):-freeze(_5592838,'blocked_Numeric.readNat'(_5592834,_5592836,_5592838,_5592840)).
'blocked_Numeric.readNat'(_5592920,_5593678,_5593684,_5593690):-hnf('Prelude.$'(partcall(1,'Data.Maybe.maybeToList',[]),'Numeric.readNumPrefix'('Prelude.dropWhile'(partcall(1,'Prelude.isSpace',[]),_5592920),'Prelude.Nothing',10,partcall(1,'Prelude.isDigit',[]),partcall(1,'Data.Char.digitToInt',[]))),_5593678,_5593684,_5593690).

'Numeric.readHex'(_5596512,_5596514,_5596516,_5596518):-freeze(_5596516,'blocked_Numeric.readHex'(_5596512,_5596514,_5596516,_5596518)).
'blocked_Numeric.readHex'(_5596598,_5597356,_5597362,_5597368):-hnf('Prelude.$'(partcall(1,'Data.Maybe.maybeToList',[]),'Numeric.readNumPrefix'('Prelude.dropWhile'(partcall(1,'Prelude.isSpace',[]),_5596598),'Prelude.Nothing',16,partcall(1,'Prelude.isHexDigit',[]),partcall(1,'Data.Char.digitToInt',[]))),_5597356,_5597362,_5597368).

'Numeric.readOct'(_5600208,_5600210,_5600212,_5600214):-freeze(_5600212,'blocked_Numeric.readOct'(_5600208,_5600210,_5600212,_5600214)).
'blocked_Numeric.readOct'(_5600294,_5601052,_5601058,_5601064):-hnf('Prelude.$'(partcall(1,'Data.Maybe.maybeToList',[]),'Numeric.readNumPrefix'('Prelude.dropWhile'(partcall(1,'Prelude.isSpace',[]),_5600294),'Prelude.Nothing',8,partcall(1,'Prelude.isOctDigit',[]),partcall(1,'Data.Char.digitToInt',[]))),_5601052,_5601058,_5601064).

'Numeric.readBin'(_5603904,_5603906,_5603908,_5603910):-freeze(_5603908,'blocked_Numeric.readBin'(_5603904,_5603906,_5603908,_5603910)).
'blocked_Numeric.readBin'(_5603990,_5604748,_5604754,_5604760):-hnf('Prelude.$'(partcall(1,'Data.Maybe.maybeToList',[]),'Numeric.readNumPrefix'('Prelude.dropWhile'(partcall(1,'Prelude.isSpace',[]),_5603990),'Prelude.Nothing',2,partcall(1,'Prelude.isBinDigit',[]),partcall(1,'Data.Char.digitToInt',[]))),_5604748,_5604754,_5604760).

'Numeric.readNumPrefix'(_5607828,_5607830,_5607832,_5607834,_5607836,_5607838,_5607840,_5607842):-freeze(_5607840,'blocked_Numeric.readNumPrefix'(_5607828,_5607830,_5607832,_5607834,_5607836,_5607838,_5607840,_5607842)).
'blocked_Numeric.readNumPrefix'(_5607954,_5607972,_5607990,_5608008,_5608026,_5612892,_5612898,_5612904):-hnf(_5607954,_5614058,_5612898,_5614094),'blocked_Numeric.readNumPrefix_1'(_5614058,_5607972,_5607990,_5608008,_5608026,_5612892,_5614094,_5612904).

'blocked_Numeric.readNumPrefix_1'(_5614494,_5614496,_5614498,_5614500,_5614502,_5614504,_5614506,_5614508):-freeze(_5614506,'blocked_blocked_Numeric.readNumPrefix_1'(_5614494,_5614496,_5614498,_5614500,_5614502,_5614504,_5614506,_5614508)).
'blocked_blocked_Numeric.readNumPrefix_1'([],_5607972,_5607990,_5608008,_5608026,_5615040,_5615046,_5615052):-hnf(_5607972,_5616656,_5615046,_5616686),'blocked_blocked_Numeric.readNumPrefix_1_[]_1'(_5616656,_5607990,_5608008,_5608026,_5615040,_5616686,_5615052).

'blocked_blocked_Numeric.readNumPrefix_1_[]_1'(_5617156,_5617158,_5617160,_5617162,_5617164,_5617166,_5617168):-freeze(_5617166,'blocked_blocked_blocked_Numeric.readNumPrefix_1_[]_1'(_5617156,_5617158,_5617160,_5617162,_5617164,_5617166,_5617168)).
'blocked_blocked_blocked_Numeric.readNumPrefix_1_[]_1'('Prelude.Nothing',_5607990,_5608008,_5608026,'Prelude.Nothing',_5617606,_5617606).
'blocked_blocked_blocked_Numeric.readNumPrefix_1_[]_1'('Prelude.Just'(_5608340),_5607990,_5608008,_5608026,'Prelude.Just'('Prelude.(,)'(_5608340,[])),_5618658,_5618658):-!.
'blocked_blocked_blocked_Numeric.readNumPrefix_1_[]_1'('FAIL'(_5619816),_5607990,_5608008,_5608026,'FAIL'(_5619816),_5619830,_5619830):-nonvar(_5619816).
'blocked_blocked_Numeric.readNumPrefix_1'([_5608708|_5608726],_5607972,_5607990,_5608008,_5608026,_5620380,_5620386,_5620392):-!,hnf(_5607972,_5622026,_5620386,_5622068),'blocked_blocked_Numeric.readNumPrefix_1_[|]_3'(_5622026,_5608708,_5608726,_5607990,_5608008,_5608026,_5620380,_5622068,_5620392).

'blocked_blocked_Numeric.readNumPrefix_1_[|]_3'(_5622578,_5622580,_5622582,_5622584,_5622586,_5622588,_5622590,_5622592,_5622594):-freeze(_5622592,'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3'(_5622578,_5622580,_5622582,_5622584,_5622586,_5622588,_5622590,_5622592,_5622594)).
'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3'('Prelude.Just'(_5608854),_5608708,_5608726,_5607990,_5608008,_5608026,_5625694,_5625700,_5625706):-makeShare(_5608008,_5623636),makeShare(_5608708,_5623656),hnf('Prelude.apply'(_5623636,_5623656),_5628248,_5625700,_5628190),'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase'(_5628248,_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,_5625694,_5628190,_5625706).

'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase'(_5628918,_5628920,_5628922,_5628924,_5628926,_5628928,_5628930,_5628932,_5628934,_5628936):-freeze(_5628934,freeze(_5628918,'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase'(_5628918,_5628920,_5628922,_5628924,_5628926,_5628928,_5628930,_5628932,_5628934,_5628936))).
'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase'('Prelude.True',_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,_5629362,_5629368,_5629374):-makeShare(_5607990,_5629816),makeShare(_5608026,_5629836),hnf('Numeric.readNumPrefix'(_5608726,'Prelude.Just'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2A\'23Prelude.Num\'23Prelude.Int\'23'(_5629816,_5608854),'Prelude.apply'(_5629836,_5623656))),_5629816,_5623636,_5629836),_5629362,_5629368,_5629374).
'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase'('Prelude.False',_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,_5635010,_5635016,_5635022):-!,hnf('Prelude.otherwise',_5638790,_5635016,_5638732),'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase_Prelude.False_ComplexCase'(_5638790,_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,_5635010,_5638732,_5635022).

'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase_Prelude.False_ComplexCase'(_5639658,_5639660,_5639662,_5639664,_5639666,_5639668,_5639670,_5639672,_5639674,_5639676):-freeze(_5639674,freeze(_5639658,'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase_Prelude.False_ComplexCase'(_5639658,_5639660,_5639662,_5639664,_5639666,_5639668,_5639670,_5639672,_5639674,_5639676))).
'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,'Prelude.Just'('Prelude.(,)'(_5608854,[_5623656|_5608726])),_5640108,_5640108).
'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,_5642354,_5642360,_5642366):-!,hnf(reportFailure4PAKCS('Numeric.readNumPrefix',['Prelude.False']),_5642354,_5642360,_5642366).
'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5644422),_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,'FAIL'(_5644422),_5644436,_5644436).
'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Just_ComplexCase'('FAIL'(_5644536),_5608854,_5623656,_5608726,_5607990,_5623636,_5608026,'FAIL'(_5644536),_5644550,_5644550).
'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3'('Prelude.Nothing',_5608708,_5608726,_5607990,_5608008,_5608026,_5647208,_5647214,_5647220):-!,makeShare(_5608008,_5645322),makeShare(_5608708,_5645342),hnf('Prelude.apply'(_5645322,_5645342),_5649846,_5647214,_5649794),'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase'(_5649846,_5645342,_5608726,_5607990,_5645322,_5608026,_5647208,_5649794,_5647220).

'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase'(_5650550,_5650552,_5650554,_5650556,_5650558,_5650560,_5650562,_5650564,_5650566):-freeze(_5650564,freeze(_5650550,'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase'(_5650550,_5650552,_5650554,_5650556,_5650558,_5650560,_5650562,_5650564,_5650566))).
'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase'('Prelude.True',_5645342,_5608726,_5607990,_5645322,_5608026,_5650984,_5650990,_5650996):-makeShare(_5608026,_5651302),hnf('Numeric.readNumPrefix'(_5608726,'Prelude.Just'('Prelude.apply'(_5651302,_5645342)),_5607990,_5645322,_5651302),_5650984,_5650990,_5650996).
'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase'('Prelude.False',_5645342,_5608726,_5607990,_5645322,_5608026,_5655042,_5655048,_5655054):-!,hnf('Prelude.otherwise',_5658916,_5655048,_5658864),'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase_Prelude.False_ComplexCase'(_5658916,_5645342,_5608726,_5607990,_5645322,_5608026,_5655042,_5658864,_5655054).

'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase_Prelude.False_ComplexCase'(_5659800,_5659802,_5659804,_5659806,_5659808,_5659810,_5659812,_5659814,_5659816):-freeze(_5659814,freeze(_5659800,'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase_Prelude.False_ComplexCase'(_5659800,_5659802,_5659804,_5659806,_5659808,_5659810,_5659812,_5659814,_5659816))).
'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5645342,_5608726,_5607990,_5645322,_5608026,'Prelude.Nothing',_5660240,_5660240).
'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5645342,_5608726,_5607990,_5645322,_5608026,_5661862,_5661868,_5661874):-!,hnf(reportFailure4PAKCS('Numeric.readNumPrefix',['Prelude.False']),_5661862,_5661868,_5661874).
'blocked_blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5663874),_5645342,_5608726,_5607990,_5645322,_5608026,'FAIL'(_5663874),_5663888,_5663888).
'blocked_blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3_Prelude.Nothing_ComplexCase'('FAIL'(_5663980),_5645342,_5608726,_5607990,_5645322,_5608026,'FAIL'(_5663980),_5663994,_5663994).
'blocked_blocked_blocked_Numeric.readNumPrefix_1_[|]_3'('FAIL'(_5664086),_5608708,_5608726,_5607990,_5608008,_5608026,'FAIL'(_5664086),_5664100,_5664100):-nonvar(_5664086).
'blocked_blocked_Numeric.readNumPrefix_1'('FAIL'(_5664196),_5607972,_5607990,_5608008,_5608026,'FAIL'(_5664196),_5664210,_5664210):-nonvar(_5664196).

'Numeric.readInt._\'23caseor0'(_5665404,_5665406,_5665408,_5665410,_5665412):-freeze(_5665410,'blocked_Numeric.readInt._\'23caseor0'(_5665404,_5665406,_5665408,_5665410,_5665412)).
'blocked_Numeric.readInt._\'23caseor0'(_5665500,_5665518,_5666706,_5666712,_5666718):-hnf(_5665500,_5668064,_5666712,_5668082),'blocked_Numeric.readInt._\'23caseor0_1'(_5668064,_5665518,_5666706,_5668082,_5666718).

'blocked_Numeric.readInt._\'23caseor0_1'(_5668500,_5668502,_5668504,_5668506,_5668508):-freeze(_5668506,freeze(_5668500,'blocked_blocked_Numeric.readInt._\'23caseor0_1'(_5668500,_5668502,_5668504,_5668506,_5668508))).
'blocked_blocked_Numeric.readInt._\'23caseor0_1'([],_5665518,[],_5668764,_5668764).
'blocked_blocked_Numeric.readInt._\'23caseor0_1'([_5665734|_5665752],_5665518,_5670762,_5670768,_5670774):-!,hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_5665734,^-),_5672708,_5670768,_5672668),'blocked_blocked_Numeric.readInt._\'23caseor0_1_[|]_ComplexCase'(_5672708,_5665734,_5665752,_5665518,_5670762,_5672668,_5670774).

'blocked_blocked_Numeric.readInt._\'23caseor0_1_[|]_ComplexCase'(_5673264,_5673266,_5673268,_5673270,_5673272,_5673274,_5673276):-freeze(_5673274,freeze(_5673264,'blocked_blocked_blocked_Numeric.readInt._\'23caseor0_1_[|]_ComplexCase'(_5673264,_5673266,_5673268,_5673270,_5673272,_5673274,_5673276))).
'blocked_blocked_blocked_Numeric.readInt._\'23caseor0_1_[|]_ComplexCase'('Prelude.True',_5665734,_5665752,_5665518,_5673678,_5673684,_5673690):-hnf('Prelude.map'(partcall(1,'Numeric.readInt._\'23lambda2',[]),'Numeric.readNat'(_5665752)),_5673678,_5673684,_5673690).
'blocked_blocked_blocked_Numeric.readInt._\'23caseor0_1_[|]_ComplexCase'('Prelude.False',_5665734,_5665752,_5665518,_5675396,_5675402,_5675408):-!,hnf('Numeric.readNat'(_5665518),_5675396,_5675402,_5675408).
'blocked_blocked_blocked_Numeric.readInt._\'23caseor0_1_[|]_ComplexCase'('FAIL'(_5676372),_5665734,_5665752,_5665518,'FAIL'(_5676372),_5676386,_5676386).
'blocked_blocked_Numeric.readInt._\'23caseor0_1'('FAIL'(_5676462),_5665518,'FAIL'(_5676462),_5676476,_5676476).

:-costCenters(['']).




%%%%% Number of shared variables: 8

