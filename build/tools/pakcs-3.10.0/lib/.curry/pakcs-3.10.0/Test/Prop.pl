%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').
:-importModule('Test.Prop.Types').

:-curryModule('Test.Prop').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Test.Prop.returns',returns,4,'Test.Prop.returns',nofix,notype).
functiontype('Test.Prop.sameReturns',sameReturns,4,'Test.Prop.sameReturns',nofix,notype).
functiontype('Test.Prop.toError',toError,1,'Test.Prop.toError',nofix,notype).
functiontype('Test.Prop.toIOError',toIOError,1,'Test.Prop.toIOError',nofix,notype).
functiontype('Test.Prop.\'2D\'3D\'2D',-=-,4,'Test.Prop.\'2D\'3D\'2D',nofix,notype).
functiontype('Test.Prop.\'3C\'7E\'3E',<~>,4,'Test.Prop.\'3C\'7E\'3E',nofix,notype).
functiontype('Test.Prop.\'7E\'3E',~>,4,'Test.Prop.\'7E\'3E',nofix,notype).
functiontype('Test.Prop.\'3C\'7E',<~,4,'Test.Prop.\'3C\'7E',nofix,notype).
functiontype('Test.Prop.\'3C\'7E\'7E\'3E',<~~>,4,'Test.Prop.\'3C\'7E\'7E\'3E',nofix,notype).
functiontype('Test.Prop.\'3D\'3D\'3E',==>,2,'Test.Prop.\'3D\'3D\'3E',nofix,notype).
functiontype('Test.Prop.solutionOf',solutionOf,2,'Test.Prop.solutionOf',nofix,notype).
functiontype('Test.Prop.is',is,3,'Test.Prop.is',nofix,notype).
functiontype('Test.Prop.isAlways',isAlways,2,'Test.Prop.isAlways',nofix,notype).
functiontype('Test.Prop.isEventually',isEventually,2,'Test.Prop.isEventually',nofix,notype).
functiontype('Test.Prop.uniquely',uniquely,1,'Test.Prop.uniquely',nofix,notype).
functiontype('Test.Prop.always',always,1,'Test.Prop.always',nofix,notype).
functiontype('Test.Prop.eventually',eventually,1,'Test.Prop.eventually',nofix,notype).
functiontype('Test.Prop.failing',failing,2,'Test.Prop.failing',nofix,notype).
functiontype('Test.Prop.successful',successful,2,'Test.Prop.successful',nofix,notype).
functiontype('Test.Prop.deterministic',deterministic,2,'Test.Prop.deterministic',nofix,notype).
functiontype('Test.Prop.\'23',#,4,'Test.Prop.\'23',nofix,notype).
functiontype('Test.Prop.\'23\'3C',#<,4,'Test.Prop.\'23\'3C',nofix,notype).
functiontype('Test.Prop.\'23\'3E',#>,4,'Test.Prop.\'23\'3E',nofix,notype).
functiontype('Test.Prop.for',for,3,'Test.Prop.for',nofix,notype).
functiontype('Test.Prop.forAll',forAll,3,'Test.Prop.forAll',nofix,notype).
functiontype('Test.Prop.\'3C\'3D\'3E',<=>,2,'Test.Prop.\'3C\'3D\'3E',nofix,notype).
functiontype('Test.Prop.label',label,2,'Test.Prop.label',nofix,notype).
functiontype('Test.Prop.classify',classify,3,'Test.Prop.classify',nofix,notype).
functiontype('Test.Prop.trivial',trivial,2,'Test.Prop.trivial',nofix,notype).
functiontype('Test.Prop.collect',collect,3,'Test.Prop.collect',nofix,notype).
functiontype('Test.Prop.collectAs',collectAs,4,'Test.Prop.collectAs',nofix,notype).
functiontype('Test.Prop.valuesOf',valuesOf,0,'Test.Prop.valuesOf',nofix,notype).
functiontype('Test.Prop.propUndefinedError','Test.Prop.propUndefinedError',1,'Test.Prop.propUndefinedError',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Test.Prop.returns'(_6770700,_6770702,_6770704,_6770706,_6770708,_6770710,_6770712):-freeze(_6770710,'blocked_Test.Prop.returns'(_6770700,_6770702,_6770704,_6770706,_6770708,_6770710,_6770712)).
'blocked_Test.Prop.returns'(_6770816,_6770834,_6770852,_6770870,_6772062,_6772068,_6772074):-hnf('Test.Prop.propUndefinedError'(['^r','^e','^t','^u','^r','^n','^s']),_6772062,_6772068,_6772074).

'Test.Prop.sameReturns'(_6775252,_6775254,_6775256,_6775258,_6775260,_6775262,_6775264):-freeze(_6775262,'blocked_Test.Prop.sameReturns'(_6775252,_6775254,_6775256,_6775258,_6775260,_6775262,_6775264)).
'blocked_Test.Prop.sameReturns'(_6775368,_6775386,_6775404,_6775422,_6777230,_6777236,_6777242):-hnf('Test.Prop.propUndefinedError'(['^s','^a','^m','^e','^R','^e','^t','^u','^r','^n','^s']),_6777230,_6777236,_6777242).

'Test.Prop.toError'(_6781100,_6781102,_6781104,_6781106):-freeze(_6781104,'blocked_Test.Prop.toError'(_6781100,_6781102,_6781104,_6781106)).
'blocked_Test.Prop.toError'(_6781186,_6782378,_6782384,_6782390):-hnf('Test.Prop.propUndefinedError'(['^t','^o','^E','^r','^r','^o','^r']),_6782378,_6782384,_6782390).

'Test.Prop.toIOError'(_6785270,_6785272,_6785274,_6785276):-freeze(_6785274,'blocked_Test.Prop.toIOError'(_6785270,_6785272,_6785274,_6785276)).
'blocked_Test.Prop.toIOError'(_6785356,_6786856,_6786862,_6786868):-hnf('Test.Prop.propUndefinedError'(['^t','^o','^I','^O','^E','^r','^r','^o','^r']),_6786856,_6786862,_6786868).

'Test.Prop.\'2D\'3D\'2D'(_6790048,_6790050,_6790052,_6790054,_6790056,_6790058,_6790060):-freeze(_6790058,'blocked_Test.Prop.\'2D\'3D\'2D'(_6790048,_6790050,_6790052,_6790054,_6790056,_6790058,_6790060)).
'blocked_Test.Prop.\'2D\'3D\'2D'(_6790164,_6790182,_6790200,_6790218,_6790794,_6790800,_6790806):-hnf('Test.Prop.propUndefinedError'([^-,^=,^-]),_6790794,_6790800,_6790806).

'Test.Prop.\'3C\'7E\'3E'(_6792996,_6792998,_6793000,_6793002,_6793004,_6793006,_6793008):-freeze(_6793006,'blocked_Test.Prop.\'3C\'7E\'3E'(_6792996,_6792998,_6793000,_6793002,_6793004,_6793006,_6793008)).
'blocked_Test.Prop.\'3C\'7E\'3E'(_6793112,_6793130,_6793148,_6793166,_6793742,_6793748,_6793754):-hnf('Test.Prop.propUndefinedError'([^<,^~,^>]),_6793742,_6793748,_6793754).

'Test.Prop.\'7E\'3E'(_6795878,_6795880,_6795882,_6795884,_6795886,_6795888,_6795890):-freeze(_6795888,'blocked_Test.Prop.\'7E\'3E'(_6795878,_6795880,_6795882,_6795884,_6795886,_6795888,_6795890)).
'blocked_Test.Prop.\'7E\'3E'(_6795994,_6796012,_6796030,_6796048,_6796470,_6796476,_6796482):-hnf('Test.Prop.propUndefinedError'([^~,^>]),_6796470,_6796476,_6796482).

'Test.Prop.\'3C\'7E'(_6798386,_6798388,_6798390,_6798392,_6798394,_6798396,_6798398):-freeze(_6798396,'blocked_Test.Prop.\'3C\'7E'(_6798386,_6798388,_6798390,_6798392,_6798394,_6798396,_6798398)).
'blocked_Test.Prop.\'3C\'7E'(_6798502,_6798520,_6798538,_6798556,_6798978,_6798984,_6798990):-hnf('Test.Prop.propUndefinedError'([^<,^~]),_6798978,_6798984,_6798990).

'Test.Prop.\'3C\'7E\'7E\'3E'(_6801026,_6801028,_6801030,_6801032,_6801034,_6801036,_6801038):-freeze(_6801036,'blocked_Test.Prop.\'3C\'7E\'7E\'3E'(_6801026,_6801028,_6801030,_6801032,_6801034,_6801036,_6801038)).
'blocked_Test.Prop.\'3C\'7E\'7E\'3E'(_6801142,_6801160,_6801178,_6801196,_6801926,_6801932,_6801938):-hnf('Test.Prop.propUndefinedError'([^<,^~,^~,^>]),_6801926,_6801932,_6801938).

'Test.Prop.\'3D\'3D\'3E'(_6804348,_6804350,_6804352,_6804354,_6804356):-freeze(_6804354,'blocked_Test.Prop.\'3D\'3D\'3E'(_6804348,_6804350,_6804352,_6804354,_6804356)).
'blocked_Test.Prop.\'3D\'3D\'3E'(_6804444,_6804462,_6805038,_6805044,_6805050):-hnf('Test.Prop.propUndefinedError'([^=,^=,^>]),_6805038,_6805044,_6805050).

'Test.Prop.solutionOf'(_6807246,_6807248,_6807250,_6807252,_6807254):-freeze(_6807252,'blocked_Test.Prop.solutionOf'(_6807246,_6807248,_6807250,_6807252,_6807254)).
'blocked_Test.Prop.solutionOf'(_6807342,_6807360,_6807718,_6807724,_6807730):-makeShare(_6807388,_6807852),hnf('Prelude.&>'('Prelude.apply'(_6807360,_6807852),_6807852),_6807718,_6807724,_6807730).

'Test.Prop.is'(_6809696,_6809698,_6809700,_6809702,_6809704,_6809706):-freeze(_6809704,'blocked_Test.Prop.is'(_6809696,_6809698,_6809700,_6809702,_6809704,_6809706)).
'blocked_Test.Prop.is'(_6809802,_6809820,_6809838,_6810260,_6810266,_6810272):-hnf('Test.Prop.propUndefinedError'(['^i','^s']),_6810260,_6810266,_6810272).

'Test.Prop.isAlways'(_6812222,_6812224,_6812226,_6812228,_6812230):-freeze(_6812228,'blocked_Test.Prop.isAlways'(_6812222,_6812224,_6812226,_6812228,_6812230)).
'blocked_Test.Prop.isAlways'(_6812318,_6812336,_6813682,_6813688,_6813694):-hnf('Test.Prop.propUndefinedError'(['^i','^s','^A','^l','^w','^a','^y','^s']),_6813682,_6813688,_6813694).

'Test.Prop.isEventually'(_6816970,_6816972,_6816974,_6816976,_6816978):-freeze(_6816976,'blocked_Test.Prop.isEventually'(_6816970,_6816972,_6816974,_6816976,_6816978)).
'blocked_Test.Prop.isEventually'(_6817066,_6817084,_6819046,_6819052,_6819058):-hnf('Test.Prop.propUndefinedError'(['^i','^s','^E','^v','^e','^n','^t','^u','^a','^l','^l','^y']),_6819046,_6819052,_6819058).

'Test.Prop.uniquely'(_6823014,_6823016,_6823018,_6823020):-freeze(_6823018,'blocked_Test.Prop.uniquely'(_6823014,_6823016,_6823018,_6823020)).
'blocked_Test.Prop.uniquely'(_6823100,_6824446,_6824452,_6824458):-hnf('Test.Prop.propUndefinedError'(['^u','^n','^i','^q','^u','^e','^l','^y']),_6824446,_6824452,_6824458).

'Test.Prop.always'(_6827432,_6827434,_6827436,_6827438):-freeze(_6827436,'blocked_Test.Prop.always'(_6827432,_6827434,_6827436,_6827438)).
'blocked_Test.Prop.always'(_6827518,_6828556,_6828562,_6828568):-hnf('Test.Prop.propUndefinedError'(['^a','^l','^w','^a','^y','^s']),_6828556,_6828562,_6828568).

'Test.Prop.eventually'(_6831278,_6831280,_6831282,_6831284):-freeze(_6831282,'blocked_Test.Prop.eventually'(_6831278,_6831280,_6831282,_6831284)).
'blocked_Test.Prop.eventually'(_6831364,_6833018,_6833024,_6833030):-hnf('Test.Prop.propUndefinedError'(['^e','^v','^e','^n','^t','^u','^a','^l','^l','^y']),_6833018,_6833024,_6833030).

'Test.Prop.failing'(_6836458,_6836460,_6836462,_6836464,_6836466):-freeze(_6836464,'blocked_Test.Prop.failing'(_6836458,_6836460,_6836462,_6836464,_6836466)).
'blocked_Test.Prop.failing'(_6836554,_6836572,_6837764,_6837770,_6837776):-hnf('Test.Prop.propUndefinedError'(['^f','^a','^i','^l','^i','^n','^g']),_6837764,_6837770,_6837776).

'Test.Prop.successful'(_6840768,_6840770,_6840772,_6840774,_6840776):-freeze(_6840774,'blocked_Test.Prop.successful'(_6840768,_6840770,_6840772,_6840774,_6840776)).
'blocked_Test.Prop.successful'(_6840864,_6840882,_6842536,_6842542,_6842548):-hnf('Test.Prop.propUndefinedError'(['^s','^u','^c','^c','^e','^s','^s','^f','^u','^l']),_6842536,_6842542,_6842548).

'Test.Prop.deterministic'(_6846278,_6846280,_6846282,_6846284,_6846286):-freeze(_6846284,'blocked_Test.Prop.deterministic'(_6846278,_6846280,_6846282,_6846284,_6846286)).
'blocked_Test.Prop.deterministic'(_6846374,_6846392,_6848508,_6848514,_6848520):-hnf('Test.Prop.propUndefinedError'(['^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c']),_6848508,_6848514,_6848520).

'Test.Prop.\'23'(_6852474,_6852476,_6852478,_6852480,_6852482,_6852484,_6852486):-freeze(_6852484,'blocked_Test.Prop.\'23'(_6852474,_6852476,_6852478,_6852480,_6852482,_6852484,_6852486)).
'blocked_Test.Prop.\'23'(_6852590,_6852608,_6852626,_6852644,_6852912,_6852918,_6852924):-hnf('Test.Prop.propUndefinedError'([^#]),_6852912,_6852918,_6852924).

'Test.Prop.\'23\'3C'(_6854608,_6854610,_6854612,_6854614,_6854616,_6854618,_6854620):-freeze(_6854618,'blocked_Test.Prop.\'23\'3C'(_6854608,_6854610,_6854612,_6854614,_6854616,_6854618,_6854620)).
'blocked_Test.Prop.\'23\'3C'(_6854724,_6854742,_6854760,_6854778,_6855200,_6855206,_6855212):-hnf('Test.Prop.propUndefinedError'([^#,^<]),_6855200,_6855206,_6855212).

'Test.Prop.\'23\'3E'(_6857116,_6857118,_6857120,_6857122,_6857124,_6857126,_6857128):-freeze(_6857126,'blocked_Test.Prop.\'23\'3E'(_6857116,_6857118,_6857120,_6857122,_6857124,_6857126,_6857128)).
'blocked_Test.Prop.\'23\'3E'(_6857232,_6857250,_6857268,_6857286,_6857708,_6857714,_6857720):-hnf('Test.Prop.propUndefinedError'([^#,^>]),_6857708,_6857714,_6857720).

'Test.Prop.for'(_6859578,_6859580,_6859582,_6859584,_6859586,_6859588):-freeze(_6859586,'blocked_Test.Prop.for'(_6859578,_6859580,_6859582,_6859584,_6859586,_6859588)).
'blocked_Test.Prop.for'(_6859684,_6859702,_6859720,_6860296,_6860302,_6860308):-hnf('Test.Prop.propUndefinedError'(['^f','^o','^r']),_6860296,_6860302,_6860308).

'Test.Prop.forAll'(_6862390,_6862392,_6862394,_6862396,_6862398,_6862400):-freeze(_6862398,'blocked_Test.Prop.forAll'(_6862390,_6862392,_6862394,_6862396,_6862398,_6862400)).
'blocked_Test.Prop.forAll'(_6862496,_6862514,_6862532,_6863570,_6863576,_6863582):-hnf('Test.Prop.propUndefinedError'(['^f','^o','^r','^A','^l','^l']),_6863570,_6863576,_6863582).

'Test.Prop.\'3C\'3D\'3E'(_6866286,_6866288,_6866290,_6866292,_6866294):-freeze(_6866292,'blocked_Test.Prop.\'3C\'3D\'3E'(_6866286,_6866288,_6866290,_6866292,_6866294)).
'blocked_Test.Prop.\'3C\'3D\'3E'(_6866382,_6866400,_6866668,_6866674,_6866680):-hnf('Test.Prop.propUndefinedError'([^#]),_6866668,_6866674,_6866680).

'Test.Prop.label'(_6868282,_6868284,_6868286,_6868288,_6868290):-freeze(_6868288,'blocked_Test.Prop.label'(_6868282,_6868284,_6868286,_6868288,_6868290)).
'blocked_Test.Prop.label'(_6868378,_6868396,_6869280,_6869286,_6869292):-hnf('Test.Prop.propUndefinedError'(['^l','^a','^b','^e','^l']),_6869280,_6869286,_6869292).

'Test.Prop.classify'(_6871792,_6871794,_6871796,_6871798,_6871800,_6871802):-freeze(_6871800,'blocked_Test.Prop.classify'(_6871792,_6871794,_6871796,_6871798,_6871800,_6871802)).
'blocked_Test.Prop.classify'(_6871898,_6871916,_6871934,_6873280,_6873286,_6873292):-hnf('Test.Prop.propUndefinedError'(['^c','^l','^a','^s','^s','^i','^f','^y']),_6873280,_6873286,_6873292).

'Test.Prop.trivial'(_6876452,_6876454,_6876456,_6876458,_6876460):-freeze(_6876458,'blocked_Test.Prop.trivial'(_6876452,_6876454,_6876456,_6876458,_6876460)).
'blocked_Test.Prop.trivial'(_6876548,_6876566,_6877758,_6877764,_6877770):-hnf('Test.Prop.propUndefinedError'(['^t','^r','^i','^v','^i','^a','^l']),_6877758,_6877764,_6877770).

'Test.Prop.collect'(_6880648,_6880650,_6880652,_6880654,_6880656,_6880658):-freeze(_6880656,'blocked_Test.Prop.collect'(_6880648,_6880650,_6880652,_6880654,_6880656,_6880658)).
'blocked_Test.Prop.collect'(_6880754,_6880772,_6880790,_6881982,_6881988,_6881994):-hnf('Test.Prop.propUndefinedError'(['^c','^o','^l','^l','^e','^c','^t']),_6881982,_6881988,_6881994).

'Test.Prop.collectAs'(_6885022,_6885024,_6885026,_6885028,_6885030,_6885032,_6885034):-freeze(_6885032,'blocked_Test.Prop.collectAs'(_6885022,_6885024,_6885026,_6885028,_6885030,_6885032,_6885034)).
'blocked_Test.Prop.collectAs'(_6885138,_6885156,_6885174,_6885192,_6886692,_6886698,_6886704):-hnf('Test.Prop.propUndefinedError'(['^c','^o','^l','^l','^e','^c','^t','^A','^s']),_6886692,_6886698,_6886704).

'Test.Prop.valuesOf'(_6890184,_6890186,_6890188):-freeze(_6890186,'blocked_Test.Prop.valuesOf'(_6890184,_6890186,_6890188)).
'blocked_Test.Prop.valuesOf'(_6900828,_6900834,_6900840):-hnf('Prelude.error'(['^T','^e','^s','^t',^.,'^P','^r','^o','^p',^.,'^v','^a','^l','^u','^e','^s','^O','^f','^ ','^u','^n','^d','^e','^f','^i','^n','^e','^d',^.,'^ ','^U','^s','^e','^ ','^T','^e','^s','^t',^.,'^E','^a','^s','^y','^C','^h','^e','^c','^k','^ ','^t','^o','^ ','^a','^c','^t','^u','^a','^l','^l','^y','^ ','^r','^u','^n','^ ','^i','^t','^!']),_6900828,_6900834,_6900840).

'Test.Prop.propUndefinedError'(_6916226,_6916228,_6916230,_6916232):-freeze(_6916230,'blocked_Test.Prop.propUndefinedError'(_6916226,_6916228,_6916230,_6916232)).
'blocked_Test.Prop.propUndefinedError'(_6916312,_6926072,_6926078,_6926084):-hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^T','^e','^s','^t',^.,'^P','^r','^o','^p',^.],'Prelude.++'(_6916312,['^ ','^u','^n','^d','^e','^f','^i','^n','^e','^d',^.,'^ ','^U','^s','^e','^ ','^T','^e','^s','^t',^.,'^E','^a','^s','^y','^C','^h','^e','^c','^k','^ ','^t','^o','^ ','^a','^c','^t','^u','^a','^l','^l','^y','^ ','^r','^u','^n','^ ','^i','^t','^!']))),_6926072,_6926078,_6926084).

:-costCenters(['']).




%%%%% Number of shared variables: 1

