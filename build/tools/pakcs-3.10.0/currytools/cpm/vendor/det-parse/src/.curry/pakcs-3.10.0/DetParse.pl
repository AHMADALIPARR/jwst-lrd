%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('DetParse').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('DetParse.parse',parse,2,'DetParse.parse',nofix,notype).
functiontype('DetParse.failure',failure,0,'DetParse.failure',nofix,notype).
functiontype('DetParse.failure._\'23lambda2','DetParse.failure._#lambda2',1,'DetParse.failure._\'23lambda2',nofix,notype).
functiontype('DetParse.yield',yield,1,'DetParse.yield',nofix,notype).
functiontype('DetParse.yield._\'23lambda3','DetParse.yield._#lambda3',2,'DetParse.yield._\'23lambda3',nofix,notype).
functiontype('DetParse.empty',empty,0,'DetParse.empty',nofix,notype).
functiontype('DetParse.anyChar',anyChar,0,'DetParse.anyChar',nofix,notype).
functiontype('DetParse.anyChar._\'23lambda4','DetParse.anyChar._#lambda4',1,'DetParse.anyChar._\'23lambda4',nofix,notype).
functiontype('DetParse.check',check,2,'DetParse.check',nofix,notype).
functiontype('DetParse.char',char,1,'DetParse.char',nofix,notype).
functiontype('DetParse.word',word,1,'DetParse.word',nofix,notype).
functiontype('DetParse.<|>','<|>',2,'DetParse.<|>',nofix,notype).
functiontype('DetParse.\'3C\'7C\'3E._\'23lambda6','DetParse.<|>._#lambda6',3,'DetParse.\'3C\'7C\'3E._\'23lambda6',nofix,notype).
functiontype('DetParse.<!>','<!>',2,'DetParse.<!>',nofix,notype).
functiontype('DetParse.\'3C\'21\'3E._\'23lambda7','DetParse.<!>._#lambda7',3,'DetParse.\'3C\'21\'3E._\'23lambda7',nofix,notype).
functiontype('DetParse.<$>',<$>,2,'DetParse.<$>',nofix,notype).
functiontype('DetParse.\'3C\'24\'3E._\'23lambda9','DetParse.<$>._#lambda9',2,'DetParse.\'3C\'24\'3E._\'23lambda9',nofix,notype).
functiontype('DetParse.<*>',<*>,2,'DetParse.<*>',nofix,notype).
functiontype('DetParse.\'3C\'2A\'3E._\'23lambda10','DetParse.<*>._#lambda10',3,'DetParse.\'3C\'2A\'3E._\'23lambda10',nofix,notype).
functiontype('DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13','DetParse.<*>._#lambda10._#lambda13',3,'DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13',nofix,notype).
functiontype('DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17','DetParse.<*>._#lambda10._#lambda13._#lambda17',3,'DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17',nofix,notype).
functiontype('DetParse.<*',<*,2,'DetParse.<*',nofix,notype).
functiontype('DetParse.\'3C\'2A._\'23lambda19','DetParse.<*._#lambda19',2,'DetParse.\'3C\'2A._\'23lambda19',nofix,notype).
functiontype('DetParse.*>',*>,2,'DetParse.*>',nofix,notype).
functiontype('DetParse.\'2A\'3E._\'23lambda20','DetParse.*>._#lambda20',2,'DetParse.\'2A\'3E._\'23lambda20',nofix,notype).
functiontype('DetParse.*>=',*>=,2,'DetParse.*>=',nofix,notype).
functiontype('DetParse.\'2A\'3E\'3D._\'23lambda21','DetParse.*>=._#lambda21',3,'DetParse.\'2A\'3E\'3D._\'23lambda21',nofix,notype).
functiontype('DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24','DetParse.*>=._#lambda21._#lambda24',3,'DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24',nofix,notype).
functiontype('DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28','DetParse.*>=._#lambda21._#lambda24._#lambda28',2,'DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28',nofix,notype).
functiontype('DetParse.many',many,1,'DetParse.many',nofix,notype).
functiontype('DetParse.some',some,1,'DetParse.some',nofix,notype).
functiontype('DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0','DetParse.<!>._#lambda7._#caseor0',4,'DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'DetParse.parse'(_60031660,_60031662,_60031664,_60031666,_60031668):-freeze(_60031666,'blocked_DetParse.parse'(_60031660,_60031662,_60031664,_60031666,_60031668)).
'blocked_DetParse.parse'(_60031756,_60031774,_60034824,_60034830,_60034836):-hnf('Prelude.$'(partcall(1,'Prelude.filter',['Prelude..'(partcall(1,'Prelude.null',[]),partcall(1,'Prelude.snd',[]))]),'Prelude.apply'(_60031756,_60031774)),_60035816,_60034830,_60035782),'blocked_DetParse.parse_ComplexCase'(_60035816,_60031756,_60031774,_60034824,_60035782,_60034836).

'blocked_DetParse.parse_ComplexCase'(_60036190,_60036192,_60036194,_60036196,_60036198,_60036200):-freeze(_60036198,freeze(_60036190,'blocked_blocked_DetParse.parse_ComplexCase'(_60036190,_60036192,_60036194,_60036196,_60036198,_60036200))).
'blocked_blocked_DetParse.parse_ComplexCase'([_60032464|_60032482],_60031756,_60031774,_60036768,_60036774,_60036780):-hnf(_60032464,_60038506,_60036774,_60038536),'blocked_blocked_DetParse.parse_ComplexCase_[|]_1'(_60038506,_60032482,_60031756,_60031774,_60036768,_60038536,_60036780).

'blocked_blocked_DetParse.parse_ComplexCase_[|]_1'(_60039036,_60039038,_60039040,_60039042,_60039044,_60039046,_60039048):-freeze(_60039046,freeze(_60039036,'blocked_blocked_blocked_DetParse.parse_ComplexCase_[|]_1'(_60039036,_60039038,_60039040,_60039042,_60039044,_60039046,_60039048))).
'blocked_blocked_blocked_DetParse.parse_ComplexCase_[|]_1'('Prelude.(,)'(_60032610,_60032628),_60032482,_60031756,_60031774,'Prelude.Just'(_60032610),_60039448,_60039448):-!.
'blocked_blocked_blocked_DetParse.parse_ComplexCase_[|]_1'('FAIL'(_60040430),_60032482,_60031756,_60031774,'FAIL'(_60040430),_60040444,_60040444).
'blocked_blocked_DetParse.parse_ComplexCase'([],_60031756,_60031774,'Prelude.Nothing',_60040688,_60040688):-!.
'blocked_blocked_DetParse.parse_ComplexCase'('FAIL'(_60041304),_60031756,_60031774,'FAIL'(_60041304),_60041318,_60041318).

'DetParse.failure'(_60042122,_60042124,_60042126):-freeze(_60042124,'blocked_DetParse.failure'(_60042122,_60042124,_60042126)).
'blocked_DetParse.failure'(_60042210,_60042216,_60042222):-hnf(partcall(1,'DetParse.failure._\'23lambda2',[]),_60042210,_60042216,_60042222).

'DetParse.failure._\'23lambda2'(_60043800,_60043802,_60043804,_60043806):-freeze(_60043804,'blocked_DetParse.failure._\'23lambda2'(_60043800,_60043802,_60043804,_60043806)).
'blocked_DetParse.failure._\'23lambda2'(_60043886,[],_60043922,_60043922).

'DetParse.yield'(_60044974,_60044976,_60044978,_60044980):-freeze(_60044978,'blocked_DetParse.yield'(_60044974,_60044976,_60044978,_60044980)).
'blocked_DetParse.yield'(_60045060,_60045160,_60045166,_60045172):-hnf(partcall(1,'DetParse.yield._\'23lambda3',[_60045060]),_60045160,_60045166,_60045172).

'DetParse.yield._\'23lambda3'(_60046820,_60046822,_60046824,_60046826,_60046828):-freeze(_60046826,'blocked_DetParse.yield._\'23lambda3'(_60046820,_60046822,_60046824,_60046826,_60046828)).
'blocked_DetParse.yield._\'23lambda3'(_60046916,_60046934,['Prelude.(,)'(_60046916,_60046934)],_60047278,_60047278).

'DetParse.empty'(_60048860,_60048862,_60048864):-freeze(_60048862,'blocked_DetParse.empty'(_60048860,_60048862,_60048864)).
'blocked_DetParse.empty'(_60049032,_60049038,_60049044):-hnf('DetParse.yield'('Prelude.()'),_60049032,_60049038,_60049044).

'DetParse.anyChar'(_60050276,_60050278,_60050280):-freeze(_60050278,'blocked_DetParse.anyChar'(_60050276,_60050278,_60050280)).
'blocked_DetParse.anyChar'(_60050364,_60050370,_60050376):-hnf(partcall(1,'DetParse.anyChar._\'23lambda4',[]),_60050364,_60050370,_60050376).

'DetParse.anyChar._\'23lambda4'(_60051954,_60051956,_60051958,_60051960):-freeze(_60051958,'blocked_DetParse.anyChar._\'23lambda4'(_60051954,_60051956,_60051958,_60051960)).
'blocked_DetParse.anyChar._\'23lambda4'(_60052040,_60052876,_60052882,_60052888):-hnf(_60052040,_60054262,_60052882,_60054274),'blocked_DetParse.anyChar._\'23lambda4_1'(_60054262,_60052876,_60054274,_60052888).

'blocked_DetParse.anyChar._\'23lambda4_1'(_60054690,_60054692,_60054694,_60054696):-freeze(_60054694,freeze(_60054690,'blocked_blocked_DetParse.anyChar._\'23lambda4_1'(_60054690,_60054692,_60054694,_60054696))).
'blocked_blocked_DetParse.anyChar._\'23lambda4_1'([],[],_60054944,_60054944).
'blocked_blocked_DetParse.anyChar._\'23lambda4_1'([_60052256|_60052274],['Prelude.(,)'(_60052256,_60052274)],_60055526,_60055526):-!.
'blocked_blocked_DetParse.anyChar._\'23lambda4_1'('FAIL'(_60056524),'FAIL'(_60056524),_60056538,_60056538).

'DetParse.check'(_60057250,_60057252,_60057254,_60057256,_60057258):-freeze(_60057256,'blocked_DetParse.check'(_60057250,_60057252,_60057254,_60057256,_60057258)).
'blocked_DetParse.check'(_60057346,_60057364,_60057786,_60057792,_60057798):-hnf('Prelude..'(partcall(1,'Prelude.filter',['Prelude..'(_60057346,partcall(1,'Prelude.fst',[]))]),_60057364),_60057786,_60057792,_60057798).

'DetParse.char'(_60059692,_60059694,_60059696,_60059698):-freeze(_60059696,'blocked_DetParse.char'(_60059692,_60059694,_60059696,_60059698)).
'blocked_DetParse.char'(_60059778,_60060298,_60060304,_60060310):-hnf('DetParse.*>'('DetParse.check'(partcall(1,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23',[_60059778]),'DetParse.anyChar'),'DetParse.yield'('Prelude.()')),_60060298,_60060304,_60060310).

'DetParse.word'(_60062664,_60062666,_60062668,_60062670):-freeze(_60062668,'blocked_DetParse.word'(_60062664,_60062666,_60062668,_60062670)).
'blocked_DetParse.word'(_60062750,_60063496,_60063502,_60063508):-hnf(_60062750,_60064342,_60063502,_60064354),'blocked_DetParse.word_1'(_60064342,_60063496,_60064354,_60063508).

'blocked_DetParse.word_1'(_60064674,_60064676,_60064678,_60064680):-freeze(_60064678,'blocked_blocked_DetParse.word_1'(_60064674,_60064676,_60064678,_60064680)).
'blocked_blocked_DetParse.word_1'([],_60064916,_60064922,_60064928):-hnf('DetParse.empty',_60064916,_60064922,_60064928).
'blocked_blocked_DetParse.word_1'([_60062966|_60062984],_60065514,_60065520,_60065526):-!,hnf('DetParse.*>'('DetParse.char'(_60062966),'DetParse.word'(_60062984)),_60065514,_60065520,_60065526).
'blocked_blocked_DetParse.word_1'('FAIL'(_60066692),'FAIL'(_60066692),_60066706,_60066706):-nonvar(_60066692).

'DetParse.<|>'(_60067434,_60067436,_60067438,_60067440,_60067442):-freeze(_60067440,'blocked_DetParse.<|>'(_60067434,_60067436,_60067438,_60067440,_60067442)).
'blocked_DetParse.<|>'(_60067530,_60067548,_60067718,_60067724,_60067730):-hnf(partcall(1,'DetParse.\'3C\'7C\'3E._\'23lambda6',[_60067548,_60067530]),_60067718,_60067724,_60067730).

'DetParse.\'3C\'7C\'3E._\'23lambda6'(_60069588,_60069590,_60069592,_60069594,_60069596,_60069598):-freeze(_60069596,'blocked_DetParse.\'3C\'7C\'3E._\'23lambda6'(_60069588,_60069590,_60069592,_60069594,_60069596,_60069598)).
'blocked_DetParse.\'3C\'7C\'3E._\'23lambda6'(_60069694,_60069712,_60069730,_60070208,_60070214,_60070220):-makeShare(_60069730,_60070390),hnf('Prelude.++'('Prelude.apply'(_60069694,_60070390),'Prelude.apply'(_60069712,_60070390)),_60070208,_60070214,_60070220).

'DetParse.<!>'(_60072616,_60072618,_60072620,_60072622,_60072624):-freeze(_60072622,'blocked_DetParse.<!>'(_60072616,_60072618,_60072620,_60072622,_60072624)).
'blocked_DetParse.<!>'(_60072712,_60072730,_60072900,_60072906,_60072912):-hnf(partcall(1,'DetParse.\'3C\'21\'3E._\'23lambda7',[_60072730,_60072712]),_60072900,_60072906,_60072912).

'DetParse.\'3C\'21\'3E._\'23lambda7'(_60074770,_60074772,_60074774,_60074776,_60074778,_60074780):-freeze(_60074778,'blocked_DetParse.\'3C\'21\'3E._\'23lambda7'(_60074770,_60074772,_60074774,_60074776,_60074778,_60074780)).
'blocked_DetParse.\'3C\'21\'3E._\'23lambda7'(_60074876,_60074894,_60074912,_60075718,_60075724,_60075730):-makeShare(_60074940,_60075992),makeShare(_60074912,_60076012),hnf('Prelude.cond'(letrec4PAKCS(_60075992,'Prelude.apply'(_60074876,_60076012)),'DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0'(_60075992,_60074894,_60076012,_60075992)),_60075718,_60075724,_60075730).

'DetParse.<$>'(_60079096,_60079098,_60079100,_60079102,_60079104):-freeze(_60079102,'blocked_DetParse.<$>'(_60079096,_60079098,_60079100,_60079102,_60079104)).
'blocked_DetParse.<$>'(_60079192,_60079210,_60079548,_60079554,_60079560):-hnf('Prelude..'(partcall(1,'Prelude.map',[partcall(1,'DetParse.\'3C\'24\'3E._\'23lambda9',[_60079192])]),_60079210),_60079548,_60079554,_60079560).

'DetParse.\'3C\'24\'3E._\'23lambda9'(_60081800,_60081802,_60081804,_60081806,_60081808):-freeze(_60081806,'blocked_DetParse.\'3C\'24\'3E._\'23lambda9'(_60081800,_60081802,_60081804,_60081806,_60081808)).
'blocked_DetParse.\'3C\'24\'3E._\'23lambda9'(_60081896,_60081914,_60082656,_60082662,_60082668):-hnf(_60081914,_60084122,_60082662,_60084140),'blocked_DetParse.\'3C\'24\'3E._\'23lambda9_2'(_60084122,_60081896,_60082656,_60084140,_60082668).

'blocked_DetParse.\'3C\'24\'3E._\'23lambda9_2'(_60084570,_60084572,_60084574,_60084576,_60084578):-freeze(_60084576,'blocked_blocked_DetParse.\'3C\'24\'3E._\'23lambda9_2'(_60084570,_60084572,_60084574,_60084576,_60084578)).
'blocked_blocked_DetParse.\'3C\'24\'3E._\'23lambda9_2'('Prelude.(,)'(_60082030,_60082048),_60081896,'Prelude.(,)'('Prelude.apply'(_60081896,_60082030),_60082048),_60084956,_60084956):-!.
'blocked_blocked_DetParse.\'3C\'24\'3E._\'23lambda9_2'('FAIL'(_60086130),_60081896,'FAIL'(_60086130),_60086144,_60086144):-nonvar(_60086130).

'DetParse.<*>'(_60086880,_60086882,_60086884,_60086886,_60086888):-freeze(_60086886,'blocked_DetParse.<*>'(_60086880,_60086882,_60086884,_60086886,_60086888)).
'blocked_DetParse.<*>'(_60086976,_60086994,_60087164,_60087170,_60087176):-hnf(partcall(1,'DetParse.\'3C\'2A\'3E._\'23lambda10',[_60086976,_60086994]),_60087164,_60087170,_60087176).

'DetParse.\'3C\'2A\'3E._\'23lambda10'(_60089078,_60089080,_60089082,_60089084,_60089086,_60089088):-freeze(_60089086,'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10'(_60089078,_60089080,_60089082,_60089084,_60089086,_60089088)).
'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10'(_60089184,_60089202,_60089220,_60089712,_60089718,_60089724):-hnf('Prelude.foldr'(partcall(2,'DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13',[_60089184]),[],'Prelude.apply'(_60089202,_60089220)),_60089712,_60089718,_60089724).

'DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13'(_60092930,_60092932,_60092934,_60092936,_60092938,_60092940):-freeze(_60092938,'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13'(_60092930,_60092932,_60092934,_60092936,_60092938,_60092940)).
'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13'(_60093036,_60093054,_60093072,_60094220,_60094226,_60094232):-hnf(_60093054,_60096198,_60094226,_60096222),'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13_2'(_60096198,_60093036,_60093072,_60094220,_60096222,_60094232).

'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13_2'(_60096750,_60096752,_60096754,_60096756,_60096758,_60096760):-freeze(_60096758,freeze(_60096750,'blocked_blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13_2'(_60096750,_60096752,_60096754,_60096756,_60096758,_60096760))).
'blocked_blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13_2'('Prelude.(,)'(_60093188,_60093206),_60093036,_60093072,_60097146,_60097152,_60097158):-!,hnf('Prelude.++'('Prelude.foldr'(partcall(2,'DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17',[_60093188]),[],'Prelude.apply'(_60093036,_60093206)),_60093072),_60097146,_60097152,_60097158).
'blocked_blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13_2'('FAIL'(_60099462),_60093036,_60093072,'FAIL'(_60099462),_60099476,_60099476).

'DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17'(_60101554,_60101556,_60101558,_60101560,_60101562,_60101564):-freeze(_60101562,'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17'(_60101554,_60101556,_60101558,_60101560,_60101562,_60101564)).
'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17'(_60101660,_60101678,_60101696,_60102754,_60102760,_60102766):-hnf(_60101678,_60105200,_60102760,_60105224),'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17_2'(_60105200,_60101660,_60101696,_60102754,_60105224,_60102766).

'blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17_2'(_60105830,_60105832,_60105834,_60105836,_60105838,_60105840):-freeze(_60105838,freeze(_60105830,'blocked_blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17_2'(_60105830,_60105832,_60105834,_60105836,_60105838,_60105840))).
'blocked_blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17_2'('Prelude.(,)'(_60101812,_60101830),_60101660,_60101696,['Prelude.(,)'('Prelude.apply'(_60101660,_60101812),_60101830)|_60101696],_60106232,_60106232):-!.
'blocked_blocked_DetParse.\'3C\'2A\'3E._\'23lambda10._\'23lambda13._\'23lambda17_2'('FAIL'(_60107880),_60101660,_60101696,'FAIL'(_60107880),_60107894,_60107894).

'DetParse.<*'(_60108572,_60108574,_60108576,_60108578,_60108580):-freeze(_60108578,'blocked_DetParse.<*'(_60108572,_60108574,_60108576,_60108578,_60108580)).
'blocked_DetParse.<*'(_60108668,_60108686,_60109024,_60109030,_60109036):-hnf('DetParse.<*>'('DetParse.<$>'(partcall(2,'DetParse.\'3C\'2A._\'23lambda19',[]),_60108668),_60108686),_60109024,_60109030,_60109036).

'DetParse.\'3C\'2A._\'23lambda19'(_60111380,_60111382,_60111384,_60111386,_60111388):-freeze(_60111386,'blocked_DetParse.\'3C\'2A._\'23lambda19'(_60111380,_60111382,_60111384,_60111386,_60111388)).
'blocked_DetParse.\'3C\'2A._\'23lambda19'(_60111476,_60111494,_60111510,_60111516,_60111522):-hnf(_60111476,_60111510,_60111516,_60111522).

'DetParse.*>'(_60112598,_60112600,_60112602,_60112604,_60112606):-freeze(_60112604,'blocked_DetParse.*>'(_60112598,_60112600,_60112602,_60112604,_60112606)).
'blocked_DetParse.*>'(_60112694,_60112712,_60113050,_60113056,_60113062):-hnf('DetParse.<*>'('DetParse.<$>'(partcall(2,'DetParse.\'2A\'3E._\'23lambda20',[]),_60112694),_60112712),_60113050,_60113056,_60113062).

'DetParse.\'2A\'3E._\'23lambda20'(_60115406,_60115408,_60115410,_60115412,_60115414):-freeze(_60115412,'blocked_DetParse.\'2A\'3E._\'23lambda20'(_60115406,_60115408,_60115410,_60115412,_60115414)).
'blocked_DetParse.\'2A\'3E._\'23lambda20'(_60115502,_60115520,_60115536,_60115542,_60115548):-hnf(_60115520,_60115536,_60115542,_60115548).

'DetParse.*>='(_60116686,_60116688,_60116690,_60116692,_60116694):-freeze(_60116692,'blocked_DetParse.*>='(_60116686,_60116688,_60116690,_60116692,_60116694)).
'blocked_DetParse.*>='(_60116782,_60116800,_60116970,_60116976,_60116982):-hnf(partcall(1,'DetParse.\'2A\'3E\'3D._\'23lambda21',[_60116782,_60116800]),_60116970,_60116976,_60116982).

'DetParse.\'2A\'3E\'3D._\'23lambda21'(_60118884,_60118886,_60118888,_60118890,_60118892,_60118894):-freeze(_60118892,'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21'(_60118884,_60118886,_60118888,_60118890,_60118892,_60118894)).
'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21'(_60118990,_60119008,_60119026,_60119518,_60119524,_60119530):-hnf('Prelude.foldr'(partcall(2,'DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24',[_60118990]),[],'Prelude.apply'(_60119008,_60119026)),_60119518,_60119524,_60119530).

'DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24'(_60122736,_60122738,_60122740,_60122742,_60122744,_60122746):-freeze(_60122744,'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24'(_60122736,_60122738,_60122740,_60122742,_60122744,_60122746)).
'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24'(_60122842,_60122860,_60122878,_60124110,_60124116,_60124122):-hnf(_60122860,_60126088,_60124116,_60126112),'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24_2'(_60126088,_60122842,_60122878,_60124110,_60126112,_60124122).

'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24_2'(_60126640,_60126642,_60126644,_60126646,_60126648,_60126650):-freeze(_60126648,freeze(_60126640,'blocked_blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24_2'(_60126640,_60126642,_60126644,_60126646,_60126648,_60126650))).
'blocked_blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24_2'('Prelude.(,)'(_60122994,_60123012),_60122842,_60122878,_60127036,_60127042,_60127048):-!,hnf('Prelude.++'('Prelude.foldr'(partcall(2,'DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28',[]),[],'Prelude.apply'('Prelude.apply'(_60122842,_60122994),_60123012)),_60122878),_60127036,_60127042,_60127048).
'blocked_blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24_2'('FAIL'(_60129536),_60122842,_60122878,'FAIL'(_60129536),_60129550,_60129550).

'DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28'(_60131628,_60131630,_60131632,_60131634,_60131636):-freeze(_60131634,'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28'(_60131628,_60131630,_60131632,_60131634,_60131636)).
'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28'(_60131724,_60131742,_60132638,_60132644,_60132650):-hnf(_60131724,_60135076,_60132644,_60135094),'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28_1'(_60135076,_60131742,_60132638,_60135094,_60132650).

'blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28_1'(_60135692,_60135694,_60135696,_60135698,_60135700):-freeze(_60135698,freeze(_60135692,'blocked_blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28_1'(_60135692,_60135694,_60135696,_60135698,_60135700))).
'blocked_blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28_1'('Prelude.(,)'(_60131858,_60131876),_60131742,['Prelude.(,)'(_60131858,_60131876)|_60131742],_60136084,_60136084):-!.
'blocked_blocked_DetParse.\'2A\'3E\'3D._\'23lambda21._\'23lambda24._\'23lambda28_1'('FAIL'(_60137342),_60131742,'FAIL'(_60137342),_60137356,_60137356).

'DetParse.many'(_60138038,_60138040,_60138042,_60138044):-freeze(_60138042,'blocked_DetParse.many'(_60138038,_60138040,_60138042,_60138044)).
'blocked_DetParse.many'(_60138124,_60138476,_60138482,_60138488):-hnf('DetParse.<|>'('DetParse.some'(_60138124),'DetParse.yield'([])),_60138476,_60138482,_60138488).

'DetParse.some'(_60140168,_60140170,_60140172,_60140174):-freeze(_60140172,'blocked_DetParse.some'(_60140168,_60140170,_60140172,_60140174)).
'blocked_DetParse.some'(_60140254,_60140676,_60140682,_60140688):-makeShare(_60140254,_60140768),hnf('DetParse.<*>'('DetParse.<$>'('[|]',_60140768),'DetParse.many'(_60140768)),_60140676,_60140682,_60140688).

'DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0'(_60143644,_60143646,_60143648,_60143650,_60143652,_60143654,_60143656):-freeze(_60143654,'blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0'(_60143644,_60143646,_60143648,_60143650,_60143652,_60143654,_60143656)).
'blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0'(_60143760,_60143778,_60143796,_60143814,_60144552,_60144558,_60144564):-hnf(_60143760,_60146466,_60144558,_60146496),'blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0_1'(_60146466,_60143778,_60143796,_60143814,_60144552,_60146496,_60144564).

'blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0_1'(_60147020,_60147022,_60147024,_60147026,_60147028,_60147030,_60147032):-freeze(_60147030,freeze(_60147020,'blocked_blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0_1'(_60147020,_60147022,_60147024,_60147026,_60147028,_60147030,_60147032))).
'blocked_blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0_1'([],_60143778,_60143796,_60143814,_60147298,_60147304,_60147310):-hnf('Prelude.apply'(_60143778,_60143796),_60147298,_60147304,_60147310).
'blocked_blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0_1'([_60144170|_60144188],_60143778,_60143796,_60143814,_60148484,_60148490,_60148496):-!,hnf(_60143814,_60148484,_60148490,_60148496).
'blocked_blocked_DetParse.\'3C\'21\'3E._\'23lambda7._\'23caseor0_1'('FAIL'(_60149338),_60143778,_60143796,_60143814,'FAIL'(_60149338),_60149352,_60149352).

:-costCenters(['']).




%%%%% Number of shared variables: 4

