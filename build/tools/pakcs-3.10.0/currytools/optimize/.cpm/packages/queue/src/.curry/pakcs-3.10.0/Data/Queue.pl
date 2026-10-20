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
'Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21626772,_21626774,_21626776,_21626778,_21626780):-freeze(_21626778,'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21626772,_21626774,_21626776,_21626778,_21626780)).
'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21626868,_21626886,_21627774,_21627780,_21627786):-hnf(_21626886,_21630320,_21627780,_21630338),'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_21630320,_21626868,_21627774,_21630338,_21627786).

'blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_21630948,_21630950,_21630952,_21630954,_21630956):-freeze(_21630954,'blocked_blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_21630948,_21630950,_21630952,_21630954,_21630956)).
'blocked_blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('Prelude.()',_21626868,'Prelude._Dict\'23Data'(partcall(2,'Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23',[_21631402]),'Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21631402)),_21631310,_21631316):-!,makeShare(_21626868,_21631402),_21631310=_21631316.
'blocked_blocked_Data.Queue._inst\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('FAIL'(_21633618),_21626868,'FAIL'(_21633618),_21633632,_21633632):-nonvar(_21633618).

'Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21636156,_21636158,_21636160,_21636162,_21636164,_21636166):-freeze(_21636164,'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21636156,_21636158,_21636160,_21636162,_21636164,_21636166)).
'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21636262,_21636280,_21636298,_21638786,_21638792,_21638798):-hnf(_21636280,_21641772,_21638792,_21641796),'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_21641772,_21636262,_21636298,_21638786,_21641796,_21638798).

'blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_21642486,_21642488,_21642490,_21642492,_21642494,_21642496):-freeze(_21642494,'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'(_21642486,_21642488,_21642490,_21642492,_21642494,_21642496)).
'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('Data.Queue.S'(_21636414,_21636432,_21636450,_21636468),_21636262,_21636298,_21643528,_21643534,_21643540):-!,hnf(_21636298,_21647264,_21643534,_21647306),'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'(_21647264,_21636414,_21636432,_21636450,_21636468,_21636262,_21643528,_21647306,_21643540).

'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'(_21648176,_21648178,_21648180,_21648182,_21648184,_21648186,_21648188,_21648190,_21648192):-freeze(_21648190,'blocked_blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'(_21648176,_21648178,_21648180,_21648182,_21648184,_21648186,_21648188,_21648190,_21648192)).
'blocked_blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'('Data.Queue.S'(_21636608,_21636626,_21636644,_21636662),_21636414,_21636432,_21636450,_21636468,_21636262,_21648638,_21648644,_21648650):-!,makeShare(_21636262,_21649352),hnf('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_21636414),_21636608),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_21649352,_21636432,_21636626)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_21636450),_21636644)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_21649352,_21636468,_21636662)),_21648638,_21648644,_21648650).
'blocked_blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2_Data.Queue.S_6'('FAIL'(_21654910),_21636414,_21636432,_21636450,_21636468,_21636262,'FAIL'(_21654910),_21654924,_21654924):-nonvar(_21654910).
'blocked_blocked_Data.Queue._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23_2'('FAIL'(_21655020),_21636262,_21636298,'FAIL'(_21655020),_21655034,_21655034):-nonvar(_21655020).

'Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21657596,_21657598,_21657600,_21657602):-freeze(_21657600,'blocked_Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21657596,_21657598,_21657600,_21657602)).
'blocked_Data.Queue._impl\'23aValue\'23Prelude.Data\'23Data.Queue.Queue\'230\'23\'23'(_21657682,'Data.Queue.S'('Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_21658282),'Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_21658282)),_21658194,_21658200):-makeShare(_21657682,_21658282),_21658194=_21658200.

'Data.Queue.empty'(_21661854,_21661856,_21661858):-freeze(_21661856,'blocked_Data.Queue.empty'(_21661854,_21661856,_21661858)).
'blocked_Data.Queue.empty'('Data.Queue.S'(0,[],0,[]),_21662256,_21662256).

'Data.Queue.cons'(_21663646,_21663648,_21663650,_21663652,_21663654):-freeze(_21663652,'blocked_Data.Queue.cons'(_21663646,_21663648,_21663650,_21663652,_21663654)).
'blocked_Data.Queue.cons'(_21663742,_21663760,_21664754,_21664760,_21664766):-hnf(_21663760,_21665680,_21664760,_21665698),'blocked_Data.Queue.cons_2'(_21665680,_21663742,_21664754,_21665698,_21664766).

'blocked_Data.Queue.cons_2'(_21666038,_21666040,_21666042,_21666044,_21666046):-freeze(_21666044,'blocked_blocked_Data.Queue.cons_2'(_21666038,_21666040,_21666042,_21666044,_21666046)).
'blocked_blocked_Data.Queue.cons_2'('Data.Queue.S'(_21663876,_21663894,_21663912,_21663930),_21663742,_21666460,_21666466,_21666472):-!,hnf('Data.Queue.check'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_21663876,1),[_21663742|_21663894],_21663912,_21663930),_21666460,_21666466,_21666472).
'blocked_blocked_Data.Queue.cons_2'('FAIL'(_21668434),_21663742,'FAIL'(_21668434),_21668448,_21668448):-nonvar(_21668434).

'Data.Queue.snoc'(_21669210,_21669212,_21669214,_21669216,_21669218):-freeze(_21669216,'blocked_Data.Queue.snoc'(_21669210,_21669212,_21669214,_21669216,_21669218)).
'blocked_Data.Queue.snoc'(_21669306,_21669324,_21670402,_21670408,_21670414):-hnf(_21669324,_21671328,_21670408,_21671346),'blocked_Data.Queue.snoc_2'(_21671328,_21669306,_21670402,_21671346,_21670414).

'blocked_Data.Queue.snoc_2'(_21671686,_21671688,_21671690,_21671692,_21671694):-freeze(_21671692,'blocked_blocked_Data.Queue.snoc_2'(_21671686,_21671688,_21671690,_21671692,_21671694)).
'blocked_blocked_Data.Queue.snoc_2'('Data.Queue.S'(_21669440,_21669458,_21669476,_21669494),_21669306,_21672108,_21672114,_21672120):-!,hnf('Data.Queue.deqReverse'('Data.Queue.check'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_21669476,1),[_21669306|_21669494],_21669440,_21669458)),_21672108,_21672114,_21672120).
'blocked_blocked_Data.Queue.snoc_2'('FAIL'(_21674318),_21669306,'FAIL'(_21674318),_21674332,_21674332):-nonvar(_21674318).

'Data.Queue.isEmpty'(_21675208,_21675210,_21675212,_21675214):-freeze(_21675212,'blocked_Data.Queue.isEmpty'(_21675208,_21675210,_21675212,_21675214)).
'blocked_Data.Queue.isEmpty'(_21675294,_21676004,_21676010,_21676016):-hnf(_21675294,_21677030,_21676010,_21677042),'blocked_Data.Queue.isEmpty_1'(_21677030,_21676004,_21677042,_21676016).

'blocked_Data.Queue.isEmpty_1'(_21677392,_21677394,_21677396,_21677398):-freeze(_21677396,'blocked_blocked_Data.Queue.isEmpty_1'(_21677392,_21677394,_21677396,_21677398)).
'blocked_blocked_Data.Queue.isEmpty_1'('Data.Queue.S'(_21675410,_21675428,_21675446,_21675464),_21677804,_21677810,_21677816):-!,hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_21675410,_21675446),0),_21677804,_21677810,_21677816).
'blocked_blocked_Data.Queue.isEmpty_1'('FAIL'(_21679448),'FAIL'(_21679448),_21679462,_21679462):-nonvar(_21679448).

'Data.Queue.deqLength'(_21680406,_21680408,_21680410,_21680412):-freeze(_21680410,'blocked_Data.Queue.deqLength'(_21680406,_21680408,_21680410,_21680412)).
'blocked_Data.Queue.deqLength'(_21680492,_21681060,_21681066,_21681072):-hnf(_21680492,_21682158,_21681066,_21682170),'blocked_Data.Queue.deqLength_1'(_21682158,_21681060,_21682170,_21681072).

'blocked_Data.Queue.deqLength_1'(_21682532,_21682534,_21682536,_21682538):-freeze(_21682536,'blocked_blocked_Data.Queue.deqLength_1'(_21682532,_21682534,_21682536,_21682538)).
'blocked_blocked_Data.Queue.deqLength_1'('Data.Queue.S'(_21680608,_21680626,_21680644,_21680662),_21682944,_21682950,_21682956):-!,hnf('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_21680608,_21680644),_21682944,_21682950,_21682956).
'blocked_blocked_Data.Queue.deqLength_1'('FAIL'(_21684094),'FAIL'(_21684094),_21684108,_21684108):-nonvar(_21684094).

'Data.Queue.deqHead'(_21684976,_21684978,_21684980,_21684982):-freeze(_21684980,'blocked_Data.Queue.deqHead'(_21684976,_21684978,_21684980,_21684982)).
'blocked_Data.Queue.deqHead'(_21685062,_21685926,_21685932,_21685938):-hnf(_21685062,_21686952,_21685932,_21686964),'blocked_Data.Queue.deqHead_1'(_21686952,_21685926,_21686964,_21685938).

'blocked_Data.Queue.deqHead_1'(_21687314,_21687316,_21687318,_21687320):-freeze(_21687318,'blocked_blocked_Data.Queue.deqHead_1'(_21687314,_21687316,_21687318,_21687320)).
'blocked_blocked_Data.Queue.deqHead_1'('Data.Queue.S'(_21685178,_21685196,_21685214,_21685232),_21687726,_21687732,_21687738):-!,hnf('Prelude.head'('Data.Queue.deqHead._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'(_21685178,0),_21685232,_21685196)),_21687726,_21687732,_21687738).
'blocked_blocked_Data.Queue.deqHead_1'('FAIL'(_21689544),'FAIL'(_21689544),_21689558,_21689558):-nonvar(_21689544).

'Data.Queue.deqTail'(_21690426,_21690428,_21690430,_21690432):-freeze(_21690430,'blocked_Data.Queue.deqTail'(_21690426,_21690428,_21690430,_21690432)).
'blocked_Data.Queue.deqTail'(_21690512,_21691698,_21691704,_21691710):-hnf(_21690512,_21692724,_21691704,_21692736),'blocked_Data.Queue.deqTail_1'(_21692724,_21691698,_21692736,_21691710).

'blocked_Data.Queue.deqTail_1'(_21693086,_21693088,_21693090,_21693092):-freeze(_21693090,'blocked_blocked_Data.Queue.deqTail_1'(_21693086,_21693088,_21693090,_21693092)).
'blocked_blocked_Data.Queue.deqTail_1'('Data.Queue.S'(_21690628,_21690646,_21690664,_21690682),_21693752,_21693758,_21693764):-!,hnf(_21690646,_21695528,_21693758,_21695558),'blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'(_21695528,_21690628,_21690664,_21690682,_21693752,_21695558,_21693764).

'blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'(_21696088,_21696090,_21696092,_21696094,_21696096,_21696098,_21696100):-freeze(_21696098,'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'(_21696088,_21696090,_21696092,_21696094,_21696096,_21696098,_21696100)).
'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'([],_21690628,_21690664,_21690682,_21696360,_21696366,_21696372):-hnf('Data.Queue.empty',_21696360,_21696366,_21696372).
'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'([_21690922|_21690940],_21690628,_21690664,_21690682,_21697360,_21697366,_21697372):-!,hnf('Data.Queue.deqReverse'('Data.Queue.check'(_21690664,_21690682,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_21690628,1),_21690940)),_21697360,_21697366,_21697372).
'blocked_blocked_blocked_Data.Queue.deqTail_1_Data.Queue.S_2'('FAIL'(_21699492),_21690628,_21690664,_21690682,'FAIL'(_21699492),_21699506,_21699506):-nonvar(_21699492).
'blocked_blocked_Data.Queue.deqTail_1'('FAIL'(_21699586),'FAIL'(_21699586),_21699600,_21699600):-nonvar(_21699586).

'Data.Queue.deqLast'(_21700468,_21700470,_21700472,_21700474):-freeze(_21700472,'blocked_Data.Queue.deqLast'(_21700468,_21700470,_21700472,_21700474)).
'blocked_Data.Queue.deqLast'(_21700554,_21701418,_21701424,_21701430):-hnf(_21700554,_21702444,_21701424,_21702456),'blocked_Data.Queue.deqLast_1'(_21702444,_21701418,_21702456,_21701430).

'blocked_Data.Queue.deqLast_1'(_21702806,_21702808,_21702810,_21702812):-freeze(_21702810,'blocked_blocked_Data.Queue.deqLast_1'(_21702806,_21702808,_21702810,_21702812)).
'blocked_blocked_Data.Queue.deqLast_1'('Data.Queue.S'(_21700670,_21700688,_21700706,_21700724),_21703218,_21703224,_21703230):-!,hnf('Prelude.head'('Data.Queue.deqLast._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'(_21700706,0),_21700688,_21700724)),_21703218,_21703224,_21703230).
'blocked_blocked_Data.Queue.deqLast_1'('FAIL'(_21705036),'FAIL'(_21705036),_21705050,_21705050):-nonvar(_21705036).

'Data.Queue.deqInit'(_21705918,_21705920,_21705922,_21705924):-freeze(_21705922,'blocked_Data.Queue.deqInit'(_21705918,_21705920,_21705922,_21705924)).
'blocked_Data.Queue.deqInit'(_21706004,_21707106,_21707112,_21707118):-hnf(_21706004,_21708132,_21707112,_21708144),'blocked_Data.Queue.deqInit_1'(_21708132,_21707106,_21708144,_21707118).

'blocked_Data.Queue.deqInit_1'(_21708494,_21708496,_21708498,_21708500):-freeze(_21708498,'blocked_blocked_Data.Queue.deqInit_1'(_21708494,_21708496,_21708498,_21708500)).
'blocked_blocked_Data.Queue.deqInit_1'('Data.Queue.S'(_21706120,_21706138,_21706156,_21706174),_21709176,_21709182,_21709188):-!,hnf(_21706174,_21710952,_21709182,_21710982),'blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'(_21710952,_21706120,_21706138,_21706156,_21709176,_21710982,_21709188).

'blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'(_21711512,_21711514,_21711516,_21711518,_21711520,_21711522,_21711524):-freeze(_21711522,'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'(_21711512,_21711514,_21711516,_21711518,_21711520,_21711522,_21711524)).
'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'([],_21706120,_21706138,_21706156,_21711784,_21711790,_21711796):-hnf('Data.Queue.empty',_21711784,_21711790,_21711796).
'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'([_21706414|_21706432],_21706120,_21706138,_21706156,_21712784,_21712790,_21712796):-!,hnf('Data.Queue.check'(_21706120,_21706138,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_21706156,1),_21706432),_21712784,_21712790,_21712796).
'blocked_blocked_blocked_Data.Queue.deqInit_1_Data.Queue.S_4'('FAIL'(_21714680),_21706120,_21706138,_21706156,'FAIL'(_21714680),_21714694,_21714694):-nonvar(_21714680).
'blocked_blocked_Data.Queue.deqInit_1'('FAIL'(_21714774),'FAIL'(_21714774),_21714788,_21714788):-nonvar(_21714774).

'Data.Queue.deqReverse'(_21715770,_21715772,_21715774,_21715776):-freeze(_21715774,'blocked_Data.Queue.deqReverse'(_21715770,_21715772,_21715774,_21715776)).
'blocked_Data.Queue.deqReverse'(_21715856,_21716570,_21716576,_21716582):-hnf(_21715856,_21717704,_21716576,_21717716),'blocked_Data.Queue.deqReverse_1'(_21717704,_21716570,_21717716,_21716582).

'blocked_Data.Queue.deqReverse_1'(_21718084,_21718086,_21718088,_21718090):-freeze(_21718088,'blocked_blocked_Data.Queue.deqReverse_1'(_21718084,_21718086,_21718088,_21718090)).
'blocked_blocked_Data.Queue.deqReverse_1'('Data.Queue.S'(_21715972,_21715990,_21716008,_21716026),'Data.Queue.S'(_21716008,_21716026,_21715972,_21715990),_21718502,_21718502):-!.
'blocked_blocked_Data.Queue.deqReverse_1'('FAIL'(_21719640),'FAIL'(_21719640),_21719654,_21719654):-nonvar(_21719640).

'Data.Queue.rotate'(_21720484,_21720486,_21720488,_21720490):-freeze(_21720488,'blocked_Data.Queue.rotate'(_21720484,_21720486,_21720488,_21720490)).
'blocked_Data.Queue.rotate'(_21720570,_21720908,_21720914,_21720920):-makeShare(_21720570,_21720998),hnf('Data.Queue.snoc'('Data.Queue.deqHead'(_21720998),'Data.Queue.deqTail'(_21720998)),_21720908,_21720914,_21720920).

'Data.Queue.matchHead'(_21723100,_21723102,_21723104,_21723106):-freeze(_21723104,'blocked_Data.Queue.matchHead'(_21723100,_21723102,_21723104,_21723106)).
'blocked_Data.Queue.matchHead'(_21723186,_21730922,_21730928,_21730934):-hnf(_21723186,_21732020,_21730928,_21732032),'blocked_Data.Queue.matchHead_1'(_21732020,_21730922,_21732032,_21730934).

'blocked_Data.Queue.matchHead_1'(_21732394,_21732396,_21732398,_21732400):-freeze(_21732398,'blocked_blocked_Data.Queue.matchHead_1'(_21732394,_21732396,_21732398,_21732400)).
'blocked_blocked_Data.Queue.matchHead_1'('Data.Queue.S'(_21723302,_21723320,_21723338,_21723356),_21733072,_21733078,_21733084):-!,hnf(_21723320,_21734920,_21733078,_21734950),'blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'(_21734920,_21723302,_21723338,_21723356,_21733072,_21734950,_21733084).

'blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'(_21735492,_21735494,_21735496,_21735498,_21735500,_21735502,_21735504):-freeze(_21735502,'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'(_21735492,_21735494,_21735496,_21735498,_21735500,_21735502,_21735504)).
'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'([],_21723302,_21723338,_21723356,_21736176,_21736182,_21736188):-hnf(_21723356,_21738576,_21736182,_21738600),'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'(_21738576,_21723302,_21723338,_21736176,_21738600,_21736188).

'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'(_21739194,_21739196,_21739198,_21739200,_21739202,_21739204):-freeze(_21739202,'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'(_21739194,_21739196,_21739198,_21739200,_21739202,_21739204)).
'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'([],_21723302,_21723338,'Prelude.Nothing',_21739462,_21739462).
'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'([_21723694|_21723712],_21723302,_21723338,_21740930,_21740936,_21740942):-!,hnf(_21723712,_21743820,_21740936,_21743850),'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'(_21743820,_21723694,_21723302,_21723338,_21740930,_21743850,_21740942).

'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'(_21744554,_21744556,_21744558,_21744560,_21744562,_21744564,_21744566):-freeze(_21744564,'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'(_21744554,_21744556,_21744558,_21744560,_21744562,_21744564,_21744566)).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'([],_21723694,_21723302,_21723338,'Prelude.Just'('Prelude.(,)'(_21723694,'Data.Queue.empty')),_21744832,_21744832).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'([_21724178|_21724196],_21723694,_21723302,_21723338,_21746418,_21746424,_21746430):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),['^D','^a','^t','^a',^.,'^Q','^u','^e','^u','^e',^.,'^m','^a','^t','^c','^h','^H','^e','^a','^d',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^q','^u','^e','^u','^e']),_21746418,_21746424,_21746430).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3_[|]_2'('FAIL'(_21754916),_21723694,_21723302,_21723338,'FAIL'(_21754916),_21754930,_21754930):-nonvar(_21754916).
'blocked_blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2_[]_3'('FAIL'(_21755010),_21723302,_21723338,'FAIL'(_21755010),_21755024,_21755024):-nonvar(_21755010).
'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'([_21729896|_21729914],_21723302,_21723338,_21723356,'Prelude.Just'('Prelude.(,)'(_21729896,'Data.Queue.deqReverse'('Data.Queue.check'(_21723338,_21723356,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_21723302,1),_21729914)))),_21755292,_21755292):-!.
'blocked_blocked_blocked_Data.Queue.matchHead_1_Data.Queue.S_2'('FAIL'(_21757890),_21723302,_21723338,_21723356,'FAIL'(_21757890),_21757904,_21757904):-nonvar(_21757890).
'blocked_blocked_Data.Queue.matchHead_1'('FAIL'(_21757984),'FAIL'(_21757984),_21757998,_21757998):-nonvar(_21757984).

'Data.Queue.matchLast'(_21758942,_21758944,_21758946,_21758948):-freeze(_21758946,'blocked_Data.Queue.matchLast'(_21758942,_21758944,_21758946,_21758948)).
'blocked_Data.Queue.matchLast'(_21759028,_21766680,_21766686,_21766692):-hnf(_21759028,_21767778,_21766686,_21767790),'blocked_Data.Queue.matchLast_1'(_21767778,_21766680,_21767790,_21766692).

'blocked_Data.Queue.matchLast_1'(_21768152,_21768154,_21768156,_21768158):-freeze(_21768156,'blocked_blocked_Data.Queue.matchLast_1'(_21768152,_21768154,_21768156,_21768158)).
'blocked_blocked_Data.Queue.matchLast_1'('Data.Queue.S'(_21759144,_21759162,_21759180,_21759198),_21768846,_21768852,_21768858):-!,hnf(_21759198,_21770694,_21768852,_21770724),'blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'(_21770694,_21759144,_21759162,_21759180,_21768846,_21770724,_21768858).

'blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'(_21771266,_21771268,_21771270,_21771272,_21771274,_21771276,_21771278):-freeze(_21771276,'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'(_21771266,_21771268,_21771270,_21771272,_21771274,_21771276,_21771278)).
'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'([],_21759144,_21759162,_21759180,_21771942,_21771948,_21771954):-hnf(_21759162,_21774342,_21771948,_21774366),'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'(_21774342,_21759144,_21759180,_21771942,_21774366,_21771954).

'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'(_21774960,_21774962,_21774964,_21774966,_21774968,_21774970):-freeze(_21774968,'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'(_21774960,_21774962,_21774964,_21774966,_21774968,_21774970)).
'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'([],_21759144,_21759180,'Prelude.Nothing',_21775228,_21775228).
'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'([_21759536|_21759554],_21759144,_21759180,_21776696,_21776702,_21776708):-!,hnf(_21759554,_21779586,_21776702,_21779616),'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'(_21779586,_21759536,_21759144,_21759180,_21776696,_21779616,_21776708).

'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'(_21780320,_21780322,_21780324,_21780326,_21780328,_21780330,_21780332):-freeze(_21780330,'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'(_21780320,_21780322,_21780324,_21780326,_21780328,_21780330,_21780332)).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'([],_21759536,_21759144,_21759180,'Prelude.Just'('Prelude.(,)'(_21759536,'Data.Queue.empty')),_21780598,_21780598).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'([_21760020|_21760038],_21759536,_21759144,_21759180,_21782184,_21782190,_21782196):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),['^D','^a','^t','^a',^.,'^Q','^u','^e','^u','^e',^.,'^m','^a','^t','^c','^h','^L','^a','^s','^t',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^q','^u','^e','^u','^e']),_21782184,_21782190,_21782196).
'blocked_blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2_[|]_2'('FAIL'(_21790682),_21759536,_21759144,_21759180,'FAIL'(_21790682),_21790696,_21790696):-nonvar(_21790682).
'blocked_blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4_[]_2'('FAIL'(_21790776),_21759144,_21759180,'FAIL'(_21790776),_21790790,_21790790):-nonvar(_21790776).
'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'([_21765738|_21765756],_21759144,_21759162,_21759180,'Prelude.Just'('Prelude.(,)'(_21765738,'Data.Queue.check'(_21759144,_21759162,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_21759180,1),_21765756))),_21791058,_21791058):-!.
'blocked_blocked_blocked_Data.Queue.matchLast_1_Data.Queue.S_4'('FAIL'(_21793420),_21759144,_21759162,_21759180,'FAIL'(_21793420),_21793434,_21793434):-nonvar(_21793420).
'blocked_blocked_Data.Queue.matchLast_1'('FAIL'(_21793514),'FAIL'(_21793514),_21793528,_21793528):-nonvar(_21793514).

'Data.Queue.listToDeq'(_21794472,_21794474,_21794476,_21794478):-freeze(_21794476,'blocked_Data.Queue.listToDeq'(_21794472,_21794474,_21794476,_21794478)).
'blocked_Data.Queue.listToDeq'(_21794558,_21794966,_21794972,_21794978):-makeShare(_21794558,_21795058),hnf('Data.Queue.check'('Prelude.length'(_21795058),_21795058,0,[]),_21794966,_21794972,_21794978).

'Data.Queue.deqToList'(_21797124,_21797126,_21797128,_21797130):-freeze(_21797128,'blocked_Data.Queue.deqToList'(_21797124,_21797126,_21797128,_21797130)).
'blocked_Data.Queue.deqToList'(_21797210,_21797946,_21797952,_21797958):-hnf(_21797210,_21799044,_21797952,_21799056),'blocked_Data.Queue.deqToList_1'(_21799044,_21797946,_21799056,_21797958).

'blocked_Data.Queue.deqToList_1'(_21799418,_21799420,_21799422,_21799424):-freeze(_21799422,'blocked_blocked_Data.Queue.deqToList_1'(_21799418,_21799420,_21799422,_21799424)).
'blocked_blocked_Data.Queue.deqToList_1'('Data.Queue.S'(_21797326,_21797344,_21797362,_21797380),_21799830,_21799836,_21799842):-!,hnf('Prelude.++'(_21797344,'Prelude.apply'('Prelude.reverse',_21797380)),_21799830,_21799836,_21799842).
'blocked_blocked_Data.Queue.deqToList_1'('FAIL'(_21801186),'FAIL'(_21801186),_21801200,_21801200):-nonvar(_21801186).

'Data.Queue.check'(_21801992,_21801994,_21801996,_21801998,_21802000,_21802002,_21802004):-freeze(_21802002,'blocked_Data.Queue.check'(_21801992,_21801994,_21801996,_21801998,_21802000,_21802002,_21802004)).
'blocked_Data.Queue.check'(_21802108,_21802126,_21802144,_21802162,_21806892,_21806898,_21806904):-makeShare(_21802190,_21808916),makeShare(_21802108,_21808936),makeShare(_21802144,_21808956),makeShare(_21802208,_21808976),makeShare(_21802226,_21808996),makeShare(_21802244,_21809016),makeShare(_21802126,_21809036),makeShare(_21802262,_21809056),makeShare(_21802280,_21809076),makeShare(_21802298,_21809096),makeShare(_21802162,_21809116),hnf('Prelude.cond'(letrec4PAKCS(_21808916,'Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_21808936,_21808956)),'Prelude.cond'(letrec4PAKCS(_21808976,'Prelude.apply'('Prelude.apply'('Prelude._impl\'23div\'23Prelude.Integral\'23Prelude.Int\'23',_21808916),2)),'Prelude.cond'(letrec4PAKCS(_21808996,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_21808916,_21808976)),'Prelude.cond'(letrec4PAKCS(_21809016,'Prelude.splitAt'(_21808976,_21809036)),'Prelude.cond'(letrec4PAKCS(_21809056,'Data.Queue.check._\'23selFP2\'23f\'27'(_21809016)),'Prelude.cond'(letrec4PAKCS(_21809076,'Data.Queue.check._\'23selFP3\'23rf\'27'(_21809016)),'Prelude.cond'(letrec4PAKCS(_21809096,'Prelude.++'(_21809116,'Prelude.apply'('Prelude.reverse',_21809076))),'Data.Queue.check._\'23caseor0'('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'(_21808936,'Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2A\'23Prelude.Num\'23Prelude.Int\'23'(3,_21808956),1)),_21808936,_21809036,_21808956,_21809116,_21808976,_21809056,_21808996,_21809096)))))))),_21806892,_21806898,_21806904).

'Data.Queue.check._\'23selFP2\'23f\'27'(_21823256,_21823258,_21823260,_21823262):-freeze(_21823260,'blocked_Data.Queue.check._\'23selFP2\'23f\'27'(_21823256,_21823258,_21823260,_21823262)).
'blocked_Data.Queue.check._\'23selFP2\'23f\'27'(_21823342,_21823792,_21823798,_21823804):-hnf(_21823342,_21825394,_21823798,_21825406),'blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'(_21825394,_21823792,_21825406,_21823804).

'blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'(_21825852,_21825854,_21825856,_21825858):-freeze(_21825856,'blocked_blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'(_21825852,_21825854,_21825856,_21825858)).
'blocked_blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'('Prelude.(,)'(_21823458,_21823476),_21826222,_21826228,_21826234):-!,hnf(_21823458,_21826222,_21826228,_21826234).
'blocked_blocked_Data.Queue.check._\'23selFP2\'23f\'27_1'('FAIL'(_21826806),'FAIL'(_21826806),_21826820,_21826820):-nonvar(_21826806).

'Data.Queue.check._\'23selFP3\'23rf\'27'(_21828218,_21828220,_21828222,_21828224):-freeze(_21828222,'blocked_Data.Queue.check._\'23selFP3\'23rf\'27'(_21828218,_21828220,_21828222,_21828224)).
'blocked_Data.Queue.check._\'23selFP3\'23rf\'27'(_21828304,_21828760,_21828766,_21828772):-hnf(_21828304,_21830398,_21828766,_21830410),'blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'(_21830398,_21828760,_21830410,_21828772).

'blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'(_21830862,_21830864,_21830866,_21830868):-freeze(_21830866,'blocked_blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'(_21830862,_21830864,_21830866,_21830868)).
'blocked_blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'('Prelude.(,)'(_21828420,_21828438),_21831232,_21831238,_21831244):-!,hnf(_21828438,_21831232,_21831238,_21831244).
'blocked_blocked_Data.Queue.check._\'23selFP3\'23rf\'27_1'('FAIL'(_21831822),'FAIL'(_21831822),_21831836,_21831836):-nonvar(_21831822).

'Data.Queue.deqHead._\'23caseor0'(_21833112,_21833114,_21833116,_21833118,_21833120,_21833122):-freeze(_21833120,'blocked_Data.Queue.deqHead._\'23caseor0'(_21833112,_21833114,_21833116,_21833118,_21833120,_21833122)).
'blocked_Data.Queue.deqHead._\'23caseor0'(_21833218,_21833236,_21833254,_21833718,_21833724,_21833730):-hnf(_21833218,_21835192,_21833724,_21835216),'blocked_Data.Queue.deqHead._\'23caseor0_1'(_21835192,_21833236,_21833254,_21833718,_21835216,_21833730).

'blocked_Data.Queue.deqHead._\'23caseor0_1'(_21835660,_21835662,_21835664,_21835666,_21835668,_21835670):-freeze(_21835668,freeze(_21835660,'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'(_21835660,_21835662,_21835664,_21835666,_21835668,_21835670))).
'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'('Prelude.True',_21833236,_21833254,_21836064,_21836070,_21836076):-hnf(_21833236,_21836064,_21836070,_21836076).
'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'('Prelude.False',_21833236,_21833254,_21836932,_21836938,_21836944):-!,hnf(_21833254,_21836932,_21836938,_21836944).
'blocked_blocked_Data.Queue.deqHead._\'23caseor0_1'('FAIL'(_21837508),_21833236,_21833254,'FAIL'(_21837508),_21837522,_21837522).

'Data.Queue.deqLast._\'23caseor0'(_21838810,_21838812,_21838814,_21838816,_21838818,_21838820):-freeze(_21838818,'blocked_Data.Queue.deqLast._\'23caseor0'(_21838810,_21838812,_21838814,_21838816,_21838818,_21838820)).
'blocked_Data.Queue.deqLast._\'23caseor0'(_21838916,_21838934,_21838952,_21839416,_21839422,_21839428):-hnf(_21838916,_21840890,_21839422,_21840914),'blocked_Data.Queue.deqLast._\'23caseor0_1'(_21840890,_21838934,_21838952,_21839416,_21840914,_21839428).

'blocked_Data.Queue.deqLast._\'23caseor0_1'(_21841358,_21841360,_21841362,_21841364,_21841366,_21841368):-freeze(_21841366,freeze(_21841358,'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'(_21841358,_21841360,_21841362,_21841364,_21841366,_21841368))).
'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'('Prelude.True',_21838934,_21838952,_21841762,_21841768,_21841774):-hnf(_21838934,_21841762,_21841768,_21841774).
'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'('Prelude.False',_21838934,_21838952,_21842630,_21842636,_21842642):-!,hnf(_21838952,_21842630,_21842636,_21842642).
'blocked_blocked_Data.Queue.deqLast._\'23caseor0_1'('FAIL'(_21843206),_21838934,_21838952,'FAIL'(_21843206),_21843220,_21843220).

'Data.Queue.check._\'23caseor0'(_21844432,_21844434,_21844436,_21844438,_21844440,_21844442,_21844444,_21844446,_21844448,_21844450,_21844452,_21844454):-freeze(_21844452,'blocked_Data.Queue.check._\'23caseor0'(_21844432,_21844434,_21844436,_21844438,_21844440,_21844442,_21844444,_21844446,_21844448,_21844450,_21844452,_21844454)).
'blocked_Data.Queue.check._\'23caseor0'(_21844598,_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,_21846336,_21846342,_21846348):-hnf(_21844598,_21847786,_21846342,_21847846),'blocked_Data.Queue.check._\'23caseor0_1'(_21847786,_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,_21846336,_21847846,_21846348).

'blocked_Data.Queue.check._\'23caseor0_1'(_21848326,_21848328,_21848330,_21848332,_21848334,_21848336,_21848338,_21848340,_21848342,_21848344,_21848346,_21848348):-freeze(_21848346,freeze(_21848326,'blocked_blocked_Data.Queue.check._\'23caseor0_1'(_21848326,_21848328,_21848330,_21848332,_21848334,_21848336,_21848338,_21848340,_21848342,_21848344,_21848346,_21848348))).
'blocked_blocked_Data.Queue.check._\'23caseor0_1'('Prelude.True',_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,'Data.Queue.S'(_21844616,_21844634,_21844652,_21844670),_21848796,_21848796).
'blocked_blocked_Data.Queue.check._\'23caseor0_1'('Prelude.False',_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,_21851996,_21852002,_21852008):-!,hnf('Prelude.otherwise',_21854364,_21852002,_21854294),'blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'(_21854364,_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,_21851996,_21854294,_21852008).

'blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'(_21854996,_21854998,_21855000,_21855002,_21855004,_21855006,_21855008,_21855010,_21855012,_21855014,_21855016,_21855018):-freeze(_21855016,freeze(_21854996,'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'(_21854996,_21854998,_21855000,_21855002,_21855004,_21855006,_21855008,_21855010,_21855012,_21855014,_21855016,_21855018))).
'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,'Data.Queue.S'(_21844688,_21844706,_21844724,_21844742),_21855466,_21855466).
'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,_21857476,_21857482,_21857488):-!,hnf(reportFailure4PAKCS('Data.Queue.check._\'23caseor0',['Prelude.False']),_21857476,_21857482,_21857488).
'blocked_blocked_blocked_Data.Queue.check._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_21859494),_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,'FAIL'(_21859494),_21859508,_21859508).
'blocked_blocked_Data.Queue.check._\'23caseor0_1'('FAIL'(_21859624),_21844616,_21844634,_21844652,_21844670,_21844688,_21844706,_21844724,_21844742,'FAIL'(_21859624),_21859638,_21859638).

:-costCenters(['']).




%%%%% Number of shared variables: 16

