%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Search.SetFunctions').
:-importModule('Data.List').
:-importModule('GrowthClassify').
:-importModule('Prelude').
:-importModule('System.Environment').

:-curryModule('TestGrowthClassify').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('TestGrowthClassify.check',check,2,'TestGrowthClassify.check',nofix,notype).
functiontype('TestGrowthClassify.near',near,2,'TestGrowthClassify.near',nofix,notype).
functiontype('TestGrowthClassify.findTuple',findTuple,5,'TestGrowthClassify.findTuple',nofix,notype).
functiontype('TestGrowthClassify.findTuple._\'23lambda1','TestGrowthClassify.findTuple._#lambda1',5,'TestGrowthClassify.findTuple._\'23lambda1',nofix,notype).
functiontype('TestGrowthClassify.main',main,0,'TestGrowthClassify.main',nofix,notype).
functiontype('TestGrowthClassify.main._\'23lambda4','TestGrowthClassify.main._#lambda4',1,'TestGrowthClassify.main._\'23lambda4',nofix,notype).
functiontype('TestGrowthClassify.mainAt',mainAt,1,'TestGrowthClassify.mainAt',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9','TestGrowthClassify.mainAt._#lambda9',1,'TestGrowthClassify.mainAt._\'23lambda9',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23lambda19','TestGrowthClassify.mainAt._#lambda9._#lambda19',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda19',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23lambda20','TestGrowthClassify.mainAt._#lambda9._#lambda20',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda20',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23lambda21','TestGrowthClassify.mainAt._#lambda9._#lambda21',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda21',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22','TestGrowthClassify.mainAt._#lambda9._#lambda22',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22',nofix,notype).
functiontype('TestGrowthClassify.check._\'23caseor0','TestGrowthClassify.check._#caseor0',1,'TestGrowthClassify.check._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.check._\'23caseor0._\'23caseor0','TestGrowthClassify.check._#caseor0._#caseor0',1,'TestGrowthClassify.check._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0._#caseor0._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0',2,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0','TestGrowthClassify.mainAt._#lambda9._#lambda22._#caseor0',1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'TestGrowthClassify.check'(_4672594,_4672596,_4672598,_4672600,_4672602):-freeze(_4672600,'blocked_TestGrowthClassify.check'(_4672594,_4672596,_4672598,_4672600,_4672602)).
'blocked_TestGrowthClassify.check'(_4672690,_4672708,_4673774,_4673780,_4673786):-makeShare(_4672708,_4673926),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.putStrLn'('Prelude.++'('TestGrowthClassify.check._\'23caseor0'(_4673926),'Prelude.++'(_4672690,'TestGrowthClassify.check._\'23caseor0._\'23caseor0'(_4673926))))),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_4673926)),_4673774,_4673780,_4673786).

'TestGrowthClassify.near'(_4678590,_4678592,_4678594,_4678596,_4678598):-freeze(_4678596,'blocked_TestGrowthClassify.near'(_4678590,_4678592,_4678594,_4678596,_4678598)).
'blocked_TestGrowthClassify.near'(_4678686,_4678704,_4679280,_4679286,_4679292):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Float\'23','Prelude._impl\'23abs\'23Prelude.Num\'23Prelude.Float\'23'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Float\'23'(_4678686,_4678704))),1.0e-6),_4679280,_4679286,_4679292).

'TestGrowthClassify.findTuple'(_4682756,_4682758,_4682760,_4682762,_4682764,_4682766,_4682768,_4682770):-freeze(_4682768,'blocked_TestGrowthClassify.findTuple'(_4682756,_4682758,_4682760,_4682762,_4682764,_4682766,_4682768,_4682770)).
'blocked_TestGrowthClassify.findTuple'(_4682882,_4682900,_4682918,_4682936,_4682954,_4685994,_4686000,_4686006):-hnf('Prelude.apply'('Prelude.concatMap'(partcall(1,'TestGrowthClassify.findTuple._\'23lambda1',[_4682936,_4682900,_4682918,_4682954])),_4682882),_4687532,_4686000,_4687480),'blocked_TestGrowthClassify.findTuple_ComplexCase'(_4687532,_4682882,_4682900,_4682918,_4682936,_4682954,_4685994,_4687480,_4686006).

'blocked_TestGrowthClassify.findTuple_ComplexCase'(_4687996,_4687998,_4688000,_4688002,_4688004,_4688006,_4688008,_4688010,_4688012):-freeze(_4688010,freeze(_4687996,'blocked_blocked_TestGrowthClassify.findTuple_ComplexCase'(_4687996,_4687998,_4688000,_4688002,_4688004,_4688006,_4688008,_4688010,_4688012))).
'blocked_blocked_TestGrowthClassify.findTuple_ComplexCase'([_4683602|_4683620],_4682882,_4682900,_4682918,_4682936,_4682954,'Prelude.Just'(_4683602),_4688328,_4688328).
'blocked_blocked_TestGrowthClassify.findTuple_ComplexCase'([],_4682882,_4682900,_4682918,_4682936,_4682954,'Prelude.Nothing',_4689614,_4689614):-!.
'blocked_blocked_TestGrowthClassify.findTuple_ComplexCase'('FAIL'(_4690536),_4682882,_4682900,_4682918,_4682936,_4682954,'FAIL'(_4690536),_4690550,_4690550).

'TestGrowthClassify.findTuple._\'23lambda1'(_4692242,_4692244,_4692246,_4692248,_4692250,_4692252,_4692254,_4692256):-freeze(_4692254,'blocked_TestGrowthClassify.findTuple._\'23lambda1'(_4692242,_4692244,_4692246,_4692248,_4692250,_4692252,_4692254,_4692256)).
'blocked_TestGrowthClassify.findTuple._\'23lambda1'(_4692368,_4692386,_4692404,_4692422,_4692440,_4696956,_4696962,_4696968):-makeShare(_4692440,_4694706),hnf('TestGrowthClassify.near'('GrowthClassify.tLam'(_4694706),_4692404),_4698926,_4696962,_4698874),'blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase'(_4698926,_4692368,_4692386,_4692404,_4692422,_4694706,_4696956,_4698874,_4696968).

'blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase'(_4699474,_4699476,_4699478,_4699480,_4699482,_4699484,_4699486,_4699488,_4699490):-freeze(_4699488,freeze(_4699474,'blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase'(_4699474,_4699476,_4699478,_4699480,_4699482,_4699484,_4699486,_4699488,_4699490))).
'blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase'('Prelude.True',_4692368,_4692386,_4692404,_4692422,_4694706,_4702296,_4702302,_4702308):-makeShare(_4694706,_4700138),hnf('TestGrowthClassify.near'('GrowthClassify.tEps'(_4700138),_4692386),_4705384,_4702302,_4705332),'blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase'(_4705384,_4692368,_4692386,_4692404,_4692422,_4700138,_4702296,_4705332,_4702308).

'blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase'(_4706130,_4706132,_4706134,_4706136,_4706138,_4706140,_4706142,_4706144,_4706146):-freeze(_4706144,freeze(_4706130,'blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase'(_4706130,_4706132,_4706134,_4706136,_4706138,_4706140,_4706142,_4706144,_4706146))).
'blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_4692368,_4692386,_4692404,_4692422,_4700138,_4708878,_4708884,_4708890):-makeShare(_4700138,_4706722),hnf('TestGrowthClassify.near'('GrowthClassify.tZForm'(_4706722),_4692422),_4713154,_4708884,_4713102),'blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'(_4713154,_4692368,_4692386,_4692404,_4692422,_4706722,_4708878,_4713102,_4708890).

'blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'(_4714098,_4714100,_4714102,_4714104,_4714106,_4714108,_4714110,_4714112,_4714114):-freeze(_4714112,freeze(_4714098,'blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'(_4714098,_4714100,_4714102,_4714104,_4714106,_4714108,_4714110,_4714112,_4714114))).
'blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_4692368,_4692386,_4692404,_4692422,_4706722,_4716766,_4716772,_4716778):-makeShare(_4706722,_4714630),hnf('TestGrowthClassify.near'('GrowthClassify.tDuty'(_4714630),_4692368),_4722230,_4716772,_4722178),'blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'(_4722230,_4692368,_4692386,_4692404,_4692422,_4714630,_4716766,_4722178,_4716778).

'blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'(_4723372,_4723374,_4723376,_4723378,_4723380,_4723382,_4723384,_4723386,_4723388):-freeze(_4723386,freeze(_4723372,'blocked_blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'(_4723372,_4723374,_4723376,_4723378,_4723380,_4723382,_4723384,_4723386,_4723388))).
'blocked_blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_4692368,_4692386,_4692404,_4692422,_4714630,[_4714630],_4723812,_4723812).
'blocked_blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_4692368,_4692386,_4692404,_4692422,_4714630,[],_4725812,_4725812):-!.
'blocked_blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_4727306),_4692368,_4692386,_4692404,_4692422,_4714630,'FAIL'(_4727306),_4727320,_4727320).
'blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_4692368,_4692386,_4692404,_4692422,_4706722,[],_4727728,_4727728):-!.
'blocked_blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_4729024),_4692368,_4692386,_4692404,_4692422,_4706722,'FAIL'(_4729024),_4729038,_4729038).
'blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_4692368,_4692386,_4692404,_4692422,_4700138,[],_4729446,_4729446):-!.
'blocked_blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_4730544),_4692368,_4692386,_4692404,_4692422,_4700138,'FAIL'(_4730544),_4730558,_4730558).
'blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase'('Prelude.False',_4692368,_4692386,_4692404,_4692422,_4694706,[],_4730966,_4730966):-!.
'blocked_blocked_TestGrowthClassify.findTuple._\'23lambda1_ComplexCase'('FAIL'(_4731866),_4692368,_4692386,_4692404,_4692422,_4694706,'FAIL'(_4731866),_4731880,_4731880).

'TestGrowthClassify.main'(_4732974,_4732976,_4732978):-freeze(_4732976,'blocked_TestGrowthClassify.main'(_4732974,_4732976,_4732978)).
'blocked_TestGrowthClassify.main'(_4733398,_4733404,_4733410):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Environment.getArgs'),partcall(1,'TestGrowthClassify.main._\'23lambda4',[])),_4733398,_4733404,_4733410).

'TestGrowthClassify.main._\'23lambda4'(_4736432,_4736434,_4736436,_4736438):-freeze(_4736436,'blocked_TestGrowthClassify.main._\'23lambda4'(_4736432,_4736434,_4736436,_4736438)).
'blocked_TestGrowthClassify.main._\'23lambda4'(_4736518,_4742324,_4742330,_4742336):-hnf(_4736518,_4743962,_4742330,_4743974),'blocked_TestGrowthClassify.main._\'23lambda4_1'(_4743962,_4742324,_4743974,_4742336).

'blocked_TestGrowthClassify.main._\'23lambda4_1'(_4744432,_4744434,_4744436,_4744438):-freeze(_4744436,freeze(_4744432,'blocked_blocked_TestGrowthClassify.main._\'23lambda4_1'(_4744432,_4744434,_4744436,_4744438))).
'blocked_blocked_TestGrowthClassify.main._\'23lambda4_1'([_4736634|_4736652],_4744708,_4744714,_4744720):-hnf('TestGrowthClassify.mainAt'(_4736634),_4744708,_4744714,_4744720).
'blocked_blocked_TestGrowthClassify.main._\'23lambda4_1'([],_4745702,_4745708,_4745714):-!,hnf('TestGrowthClassify.mainAt'(['^f','^i','^x','^t','^u','^r','^e','^s',^/,'^g','^r','^o','^w','^t','^h',^/,'^f','^e','^a','^s','^i','^b','^l','^e','^_','^g','^r','^i','^d',^.,'^r','^e','^c']),_4745702,_4745708,_4745714).
'blocked_blocked_TestGrowthClassify.main._\'23lambda4_1'('FAIL'(_4753098),'FAIL'(_4753098),_4753112,_4753112).

'TestGrowthClassify.mainAt'(_4754242,_4754244,_4754246,_4754248):-freeze(_4754246,'blocked_TestGrowthClassify.mainAt'(_4754242,_4754244,_4754246,_4754248)).
'blocked_TestGrowthClassify.mainAt'(_4754328,_4754764,_4754770,_4754776):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','GrowthClassify.loadGrowth'(_4754328)),partcall(1,'TestGrowthClassify.mainAt._\'23lambda9',[])),_4754764,_4754770,_4754776).

'TestGrowthClassify.mainAt._\'23lambda9'(_4758060,_4758062,_4758064,_4758066):-freeze(_4758064,'blocked_TestGrowthClassify.mainAt._\'23lambda9'(_4758060,_4758062,_4758064,_4758066)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9'(_4758146,_4805454,_4805460,_4805466):-makeShare(_4758174,_4807630),makeShare(_4758192,_4807650),makeShare(_4758210,_4807670),makeShare(_4758228,_4807690),makeShare(_4758246,_4807710),makeShare(_4758264,_4807730),hnf('Prelude.cond'(letrec4PAKCS(_4807630,_4758146),'Prelude.cond'(letrec4PAKCS(_4807650,'TestGrowthClassify.findTuple'(_4807630,1.0,0.1,20.0,1.0)),'Prelude.cond'(letrec4PAKCS(_4807670,'TestGrowthClassify.findTuple'(_4807630,1.5,0.2,20.0,1.0)),'Prelude.cond'(letrec4PAKCS(_4807690,'TestGrowthClassify.findTuple'(_4807630,0.5,0.3,12.0,0.1)),'Prelude.cond'(letrec4PAKCS(_4807710,'TestGrowthClassify.findTuple'(_4807630,0.5,0.05,25.0,0.5)),'Prelude.cond'(letrec4PAKCS(_4807730,'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0'(_4807670)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.sequence'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),['TestGrowthClassify.check'(['^r','^o','^w','^_','^c','^o','^u','^n','^t','^_','^1','^2','^0','^0'],'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude.length'(_4807630),1200)),'TestGrowthClassify.check'(['^b','^e','^n','^c','^h','^m','^a','^r','^k','^_','^t','^u','^p','^l','^e','^_','^f','^o','^u','^n','^d'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0'(_4807650)),'TestGrowthClassify.check'(['^b','^e','^n','^c','^h','^m','^a','^r','^k','^_','^s','^e','^e','^d','^_','^n','^e','^a','^r','^_','^4','^9','^7'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0'(_4807650)),'TestGrowthClassify.check'(['^b','^e','^n','^c','^h','^m','^a','^r','^k','^_','^h','^e','^a','^v','^y','^_','^s','^e','^e','^d','^_','^o','^n','^l','^y'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4807650)),'TestGrowthClassify.check'(['^c','^o','^m','^p','^e','^t','^i','^n','^g','^_','^h','^y','^p','^o','^t','^h','^e','^s','^e','^s','^_','^a','^l','^i','^v','^e'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4807670)),'TestGrowthClassify.check'(['^n','^o','^n','^d','^e','^t','^_','^m','^a','^t','^c','^h','^e','^s','^_','^f','^i','^l','^t','^e','^r'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4807670,_4807730)),'TestGrowthClassify.check'(['^w','^e','^a','^k','^_','^t','^u','^p','^l','^e','^_','^i','^s','^_','^c','^o','^u','^n','^t','^e','^r','^e','^x','^a','^m','^p','^l','^e'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4807690)),'TestGrowthClassify.check'(['^p','^b','^h','^_','^r','^a','^n','^g','^e','^_','^a','^l','^i','^v','^e'],'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4807710)),'TestGrowthClassify.check'(['^l','^i','^g','^h','^t','^_','^s','^e','^e','^d','^_','^e','^x','^i','^s','^t','^s'],'Prelude.apply'('Prelude.any'(partcall(1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda19',[])),_4807630)),'TestGrowthClassify.check'(['^e','^v','^e','^r','^y','^_','^f','^e','^a','^s','^i','^b','^l','^e','^_','^h','^a','^s','^_','^h','^y','^p','^o','^t','^h','^e','^s','^i','^s'],'Prelude.apply'('Prelude.all'(partcall(1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda20',[])),_4807630)),'TestGrowthClassify.check'(['^n','^o','^_','^i','^n','^f','^e','^a','^s','^i','^b','^l','^e','^_','^h','^a','^s','^_','^h','^y','^p','^o','^t','^h','^e','^s','^i','^s'],'Prelude.apply'('Prelude.all'(partcall(1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda21',[])),_4807630))])),partcall(1,'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22',[])))))))),_4805454,_4805460,_4805466).

'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda19'(_4882240,_4882242,_4882244,_4882246):-freeze(_4882244,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda19'(_4882240,_4882242,_4882244,_4882246)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda19'(_4882326,_4882762,_4882768,_4882774):-hnf('Prelude.apply'('Prelude.elem'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'GrowthClassify.LightSeed'),'GrowthClassify.hypothesesOf'(_4882326)),_4882762,_4882768,_4882774).

'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda20'(_4886624,_4886626,_4886628,_4886630):-freeze(_4886628,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda20'(_4886624,_4886626,_4886628,_4886630)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda20'(_4886710,_4887300,_4887306,_4887312):-makeShare(_4886710,_4887396),hnf('Prelude.||'('Prelude.not'('GrowthClassify.feasible'(_4887396)),'Prelude.not'('Prelude.null'('GrowthClassify.hypothesesOf'(_4887396)))),_4887300,_4887306,_4887312).

'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda21'(_4891386,_4891388,_4891390,_4891392):-freeze(_4891390,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda21'(_4891386,_4891388,_4891390,_4891392)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda21'(_4891472,_4891894,_4891900,_4891906):-makeShare(_4891472,_4891986),hnf('Prelude.||'('GrowthClassify.feasible'(_4891986),'Prelude.null'('GrowthClassify.hypothesesOf'(_4891986))),_4891894,_4891900,_4891906).

'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22'(_4895628,_4895630,_4895632,_4895634):-freeze(_4895632,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22'(_4895628,_4895630,_4895632,_4895634)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22'(_4895714,_4896324,_4896330,_4896336):-makeShare(_4895742,_4896444),hnf('Prelude.cond'(letrec4PAKCS(_4896444,_4895714),'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0'('Prelude.apply'('Prelude.and',_4896444))),_4896324,_4896330,_4896336).

'TestGrowthClassify.check._\'23caseor0'(_4900038,_4900040,_4900042,_4900044):-freeze(_4900042,'blocked_TestGrowthClassify.check._\'23caseor0'(_4900038,_4900040,_4900042,_4900044)).
'blocked_TestGrowthClassify.check._\'23caseor0'(_4900124,_4904040,_4904046,_4904052):-hnf(_4900124,_4905714,_4904046,_4905726),'blocked_TestGrowthClassify.check._\'23caseor0_1'(_4905714,_4904040,_4905726,_4904052).

'blocked_TestGrowthClassify.check._\'23caseor0_1'(_4906190,_4906192,_4906194,_4906196):-freeze(_4906194,freeze(_4906190,'blocked_blocked_TestGrowthClassify.check._\'23caseor0_1'(_4906190,_4906192,_4906194,_4906196))).
'blocked_blocked_TestGrowthClassify.check._\'23caseor0_1'('Prelude.True',['^P','^A','^S','^S','^ ','^c','^u','^r','^r','^y',^.],_4906580,_4906580).
'blocked_blocked_TestGrowthClassify.check._\'23caseor0_1'('Prelude.False',['^F','^A','^I','^L','^ ','^c','^u','^r','^r','^y',^.],_4909552,_4909552):-!.
'blocked_blocked_TestGrowthClassify.check._\'23caseor0_1'('FAIL'(_4912220),'FAIL'(_4912220),_4912234,_4912234).

'TestGrowthClassify.check._\'23caseor0._\'23caseor0'(_4914142,_4914144,_4914146,_4914148):-freeze(_4914146,'blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0'(_4914142,_4914144,_4914146,_4914148)).
'blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0'(_4914228,_4917292,_4917298,_4917304):-hnf(_4914228,_4919398,_4917298,_4919410),'blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0_1'(_4919398,_4917292,_4919410,_4917304).

'blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0_1'(_4919946,_4919948,_4919950,_4919952):-freeze(_4919950,freeze(_4919946,'blocked_blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0_1'(_4919946,_4919948,_4919950,_4919952))).
'blocked_blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0_1'('Prelude.True',[],_4920336,_4920336).
'blocked_blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0_1'('Prelude.False',['^ ','^a','^s','^s','^e','^r','^t','^i','^o','^n','^_','^f','^a','^l','^s','^e'],_4921158,_4921158):-!.
'blocked_blocked_TestGrowthClassify.check._\'23caseor0._\'23caseor0_1'('FAIL'(_4924908),'FAIL'(_4924908),_4924922,_4924922).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0'(_4926868,_4926870,_4926872,_4926874):-freeze(_4926872,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0'(_4926868,_4926870,_4926872,_4926874)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0'(_4926954,_4928158,_4928164,_4928170):-hnf(_4926954,_4930300,_4928164,_4930312),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0_1'(_4930300,_4928158,_4930312,_4928170).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0_1'(_4930854,_4930856,_4930858,_4930860):-freeze(_4930858,freeze(_4930854,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0_1'(_4930854,_4930856,_4930858,_4930860))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0_1'('Prelude.Just'(_4927070),_4931248,_4931254,_4931260):-hnf('Data.List.nub'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'Prelude.apply'('Control.Search.SetFunctions.sortValues'(partcall(1,'GrowthClassify._inst\'23Prelude.Ord\'23GrowthClassify.Hypothesis\'23',[])),'Control.Search.SetFunctions.set1'(partcall(1,'GrowthClassify.hypothesis',[]),_4927070))),_4931248,_4931254,_4931260).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0_1'('Prelude.Nothing',[],_4934462,_4934462):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0_1'('FAIL'(_4934986),'FAIL'(_4934986),_4935000,_4935000).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0'(_4937354,_4937356,_4937358,_4937360):-freeze(_4937358,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0'(_4937354,_4937356,_4937358,_4937360)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0'(_4937440,_4938142,_4938148,_4938154):-hnf(_4937440,_4940716,_4938148,_4940728),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0_1'(_4940716,_4938142,_4940728,_4938154).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0_1'(_4941342,_4941344,_4941346,_4941348):-freeze(_4941346,freeze(_4941342,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0_1'(_4941342,_4941344,_4941346,_4941348))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_4937556),'Prelude.True',_4941742,_4941742).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0_1'('Prelude.Nothing','Prelude.False',_4942808,_4942808):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0_1'('FAIL'(_4943486),'FAIL'(_4943486),_4943500,_4943500).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0'(_4946262,_4946264,_4946266,_4946268):-freeze(_4946266,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0'(_4946262,_4946264,_4946266,_4946268)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0'(_4946348,_4948074,_4948080,_4948086):-hnf(_4946348,_4951080,_4948080,_4951092),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4951080,_4948074,_4951092,_4948086).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4951778,_4951780,_4951782,_4951784):-freeze(_4951782,freeze(_4951778,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4951778,_4951780,_4951782,_4951784))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_4946464),_4952172,_4952178,_4952184):-makeShare(_4946464,_4952278),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'23Prelude.Ord\'23Prelude.Float\'23','GrowthClassify.tSeedSimple'(_4952278)),480.0),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Float\'23','GrowthClassify.tSeedSimple'(_4952278)),525.0)),_4952172,_4952178,_4952184).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Nothing','Prelude.False',_4956102,_4956102):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0_1'('FAIL'(_4956852),'FAIL'(_4956852),_4956866,_4956866).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4960036,_4960038,_4960040,_4960042):-freeze(_4960040,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4960036,_4960038,_4960040,_4960042)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4960122,_4961458,_4961464,_4961470):-hnf(_4960122,_4964896,_4961464,_4964908),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4964896,_4961458,_4964908,_4961470).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4965666,_4965668,_4965670,_4965672):-freeze(_4965670,freeze(_4965666,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4965666,_4965668,_4965670,_4965672))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_4960238),_4966060,_4966066,_4966072):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'GrowthClassify.hypothesesOf'(_4960238),['GrowthClassify.HeavySeed']),_4966060,_4966066,_4966072).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Nothing','Prelude.False',_4968882,_4968882):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('FAIL'(_4969704),'FAIL'(_4969704),_4969718,_4969718).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4973296,_4973298,_4973300,_4973302):-freeze(_4973300,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4973296,_4973298,_4973300,_4973302)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4973382,_4974958,_4974964,_4974970):-hnf(_4973382,_4978828,_4974964,_4978840),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4978828,_4974958,_4978840,_4974970).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4979670,_4979672,_4979674,_4979676):-freeze(_4979674,freeze(_4979670,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4979670,_4979672,_4979674,_4979676))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_4973498),_4980064,_4980070,_4980076):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'GrowthClassify.hypothesesOf'(_4973498),['GrowthClassify.SuperEddington','GrowthClassify.Composite']),_4980064,_4980070,_4980076).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Nothing','Prelude.False',_4983350,_4983350):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('FAIL'(_4984244),'FAIL'(_4984244),_4984258,_4984258).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4988244,_4988246,_4988248,_4988250,_4988252):-freeze(_4988250,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4988244,_4988246,_4988248,_4988250,_4988252)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_4988340,_4988358,_4990160,_4990166,_4990172):-hnf(_4988340,_4994470,_4990166,_4994488),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4994470,_4988358,_4990160,_4994488,_4990172).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4995398,_4995400,_4995402,_4995404,_4995406):-freeze(_4995404,freeze(_4995398,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_4995398,_4995400,_4995402,_4995404,_4995406))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_4988474),_4988358,_4995802,_4995808,_4995814):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'Prelude.apply'('Data.List.sort'(partcall(1,'GrowthClassify._inst\'23Prelude.Ord\'23GrowthClassify.Hypothesis\'23',[])),_4988358),'Prelude.apply'('Data.List.sort'(partcall(1,'GrowthClassify._inst\'23Prelude.Ord\'23GrowthClassify.Hypothesis\'23',[])),'GrowthClassify.hypothesesOf'(_4988474))),_4995802,_4995808,_4995814).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Nothing',_4988358,'Prelude.False',_5000256,_5000256):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('FAIL'(_5001296),_4988358,'FAIL'(_5001296),_5001310,_5001310).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_5005712,_5005714,_5005716,_5005718):-freeze(_5005716,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_5005712,_5005714,_5005716,_5005718)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_5005798,_5007420,_5007426,_5007432):-hnf(_5005798,_5012154,_5007426,_5012166),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_5012154,_5007420,_5012166,_5007432).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_5013140,_5013142,_5013144,_5013146):-freeze(_5013144,freeze(_5013140,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_5013140,_5013142,_5013144,_5013146))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_5005914),_5013534,_5013540,_5013546):-makeShare(_5005914,_5013630),hnf('Prelude.&&'('GrowthClassify.counterexample'(_5013630),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'GrowthClassify.hypothesesOf'(_5013630),[])),_5013534,_5013540,_5013546).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Nothing','Prelude.False',_5017058,_5017058):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('FAIL'(_5018096),'FAIL'(_5018096),_5018110,_5018110).

'TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_5022912,_5022914,_5022916,_5022918):-freeze(_5022916,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_5022912,_5022914,_5022916,_5022918)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0'(_5022998,_5025112,_5025118,_5025124):-hnf(_5022998,_5030278,_5025118,_5030290),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_5030278,_5025112,_5030290,_5025124).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_5031336,_5031338,_5031340,_5031342):-freeze(_5031340,freeze(_5031336,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'(_5031336,_5031338,_5031340,_5031342))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Just'(_5023114),_5031730,_5031736,_5031742):-makeShare(_5023114,_5031836),hnf('Prelude.&&'('Prelude.apply'('Prelude.elem'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'GrowthClassify.PrimordialBH'),'GrowthClassify.hypothesesOf'(_5031836)),'Prelude.apply'('Prelude.elem'(partcall(1,'GrowthClassify._inst\'23Prelude.Eq\'23GrowthClassify.Hypothesis\'23',[]),'GrowthClassify.HeavySeed'),'GrowthClassify.hypothesesOf'(_5031836))),_5031730,_5031736,_5031742).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('Prelude.Nothing','Prelude.False',_5036534,_5036534):-!.
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0._\'23caseor0_1'('FAIL'(_5037644),'FAIL'(_5037644),_5037658,_5037658).

'TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0'(_5040050,_5040052,_5040054,_5040056):-freeze(_5040054,'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0'(_5040050,_5040052,_5040054,_5040056)).
'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0'(_5040136,_5046840,_5046846,_5046852):-hnf(_5040136,_5049450,_5046846,_5049462),'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0_1'(_5049450,_5046840,_5049462,_5046852).

'blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0_1'(_5050082,_5050084,_5050086,_5050088):-freeze(_5050086,freeze(_5050082,'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0_1'(_5050082,_5050084,_5050086,_5050088))).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0_1'('Prelude.True',_5050466,_5050472,_5050478):-hnf('Prelude.putStrLn'(['^C','^U','^R','^R','^Y','^_','^G','^R','^O','^W','^T','^H','^_','^D','^O','^N','^E']),_5050466,_5050472,_5050478).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0_1'('Prelude.False',_5055030,_5055036,_5055042):-!,hnf('Prelude.putStrLn'(['^C','^U','^R','^R','^Y','^_','^G','^R','^O','^W','^T','^H','^_','^F','^A','^I','^L','^U','^R','^E','^S']),_5055030,_5055036,_5055042).
'blocked_blocked_TestGrowthClassify.mainAt._\'23lambda9._\'23lambda22._\'23caseor0_1'('FAIL'(_5060110),'FAIL'(_5060110),_5060124,_5060124).

:-costCenters(['']).




%%%%% Number of shared variables: 17

