%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.Char').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Char.isAscii',isAscii,1,'Data.Char.isAscii',nofix,notype).
functiontype('Data.Char.isLatin1',isLatin1,1,'Data.Char.isLatin1',nofix,notype).
functiontype('Data.Char.isAsciiLower',isAsciiLower,1,'Data.Char.isAsciiLower',nofix,notype).
functiontype('Data.Char.isAsciiUpper',isAsciiUpper,1,'Data.Char.isAsciiUpper',nofix,notype).
functiontype('Data.Char.isControl',isControl,1,'Data.Char.isControl',nofix,notype).
functiontype('Data.Char.toUpper',toUpper,1,'Data.Char.toUpper',nofix,notype).
functiontype('Data.Char.toLower',toLower,1,'Data.Char.toLower',nofix,notype).
functiontype('Data.Char.digitToInt',digitToInt,1,'Data.Char.digitToInt',nofix,notype).
functiontype('Data.Char.intToDigit',intToDigit,1,'Data.Char.intToDigit',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Char.isAscii'(_5853752,_5853754,_5853756,_5853758):-freeze(_5853756,'blocked_Data.Char.isAscii'(_5853752,_5853754,_5853756,_5853758)).
'blocked_Data.Char.isAscii'(_5853838,_5854176,_5854182,_5854188):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Char\'23',_5853838),'^128'),_5854176,_5854182,_5854188).

'Data.Char.isLatin1'(_5856224,_5856226,_5856228,_5856230):-freeze(_5856228,'blocked_Data.Char.isLatin1'(_5856224,_5856226,_5856228,_5856230)).
'blocked_Data.Char.isLatin1'(_5856310,_5856648,_5856654,_5856660):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Char\'23',_5856310),'^255'),_5856648,_5856654,_5856660).

'Data.Char.isAsciiLower'(_5858854,_5858856,_5858858,_5858860):-freeze(_5858858,'blocked_Data.Char.isAsciiLower'(_5858854,_5858856,_5858858,_5858860)).
'blocked_Data.Char.isAsciiLower'(_5858940,_5859586,_5859592,_5859598):-makeShare(_5858940,_5859684),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Char\'23',_5859684),'^a'),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Char\'23'(_5859684,'^z')),_5859586,_5859592,_5859598).

'Data.Char.isAsciiUpper'(_5862916,_5862918,_5862920,_5862922):-freeze(_5862920,'blocked_Data.Char.isAsciiUpper'(_5862916,_5862918,_5862920,_5862922)).
'blocked_Data.Char.isAsciiUpper'(_5863002,_5863648,_5863654,_5863660):-makeShare(_5863002,_5863746),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Char\'23',_5863746),'^A'),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Char\'23'(_5863746,'^Z')),_5863648,_5863654,_5863660).

'Data.Char.isControl'(_5866864,_5866866,_5866868,_5866870):-freeze(_5866868,'blocked_Data.Char.isControl'(_5866864,_5866866,_5866868,_5866870)).
'blocked_Data.Char.isControl'(_5866950,_5868072,_5868078,_5868084):-makeShare(_5866950,_5868194),hnf('Prelude.||'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Char\'23',_5868194),'^ '),'Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Char\'23',_5868194),'^127'),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Char\'23'(_5868194,'^159'))),_5868072,_5868078,_5868084).

'Data.Char.toUpper'(_5872430,_5872432,_5872434,_5872436):-freeze(_5872434,'blocked_Data.Char.toUpper'(_5872430,_5872432,_5872434,_5872436)).
'blocked_Data.Char.toUpper'(_5872516,_5875276,_5875282,_5875288):-makeShare(_5872516,_5874106),hnf('Prelude.isLower'(_5874106),_5876362,_5875282,_5876334),'blocked_Data.Char.toUpper_ComplexCase'(_5876362,_5874106,_5875276,_5876334,_5875288).

'blocked_Data.Char.toUpper_ComplexCase'(_5876764,_5876766,_5876768,_5876770,_5876772):-freeze(_5876770,freeze(_5876764,'blocked_blocked_Data.Char.toUpper_ComplexCase'(_5876764,_5876766,_5876768,_5876770,_5876772))).
'blocked_blocked_Data.Char.toUpper_ComplexCase'('Prelude.True',_5874106,_5877158,_5877164,_5877170):-hnf('Prelude.chr'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'(_5874106),'Prelude.ord'('^a')),'Prelude.ord'('^A'))),_5877158,_5877164,_5877170).
'blocked_blocked_Data.Char.toUpper_ComplexCase'('Prelude.False',_5874106,_5880416,_5880422,_5880428):-!,hnf('Prelude.otherwise',_5882650,_5880422,_5882622),'blocked_blocked_Data.Char.toUpper_ComplexCase_Prelude.False_ComplexCase'(_5882650,_5874106,_5880416,_5882622,_5880428).

'blocked_blocked_Data.Char.toUpper_ComplexCase_Prelude.False_ComplexCase'(_5883262,_5883264,_5883266,_5883268,_5883270):-freeze(_5883268,freeze(_5883262,'blocked_blocked_blocked_Data.Char.toUpper_ComplexCase_Prelude.False_ComplexCase'(_5883262,_5883264,_5883266,_5883268,_5883270))).
'blocked_blocked_blocked_Data.Char.toUpper_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5874106,_5883656,_5883662,_5883668):-hnf(_5874106,_5883656,_5883662,_5883668).
'blocked_blocked_blocked_Data.Char.toUpper_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5874106,_5884636,_5884642,_5884648):-!,hnf(reportFailure4PAKCS('Data.Char.toUpper',['Prelude.False']),_5884636,_5884642,_5884648).
'blocked_blocked_blocked_Data.Char.toUpper_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5886064),_5874106,'FAIL'(_5886064),_5886078,_5886078).
'blocked_blocked_Data.Char.toUpper_ComplexCase'('FAIL'(_5886138),_5874106,'FAIL'(_5886138),_5886152,_5886152).

'Data.Char.toLower'(_5886986,_5886988,_5886990,_5886992):-freeze(_5886990,'blocked_Data.Char.toLower'(_5886986,_5886988,_5886990,_5886992)).
'blocked_Data.Char.toLower'(_5887072,_5889832,_5889838,_5889844):-makeShare(_5887072,_5888662),hnf('Prelude.isUpper'(_5888662),_5890918,_5889838,_5890890),'blocked_Data.Char.toLower_ComplexCase'(_5890918,_5888662,_5889832,_5890890,_5889844).

'blocked_Data.Char.toLower_ComplexCase'(_5891320,_5891322,_5891324,_5891326,_5891328):-freeze(_5891326,freeze(_5891320,'blocked_blocked_Data.Char.toLower_ComplexCase'(_5891320,_5891322,_5891324,_5891326,_5891328))).
'blocked_blocked_Data.Char.toLower_ComplexCase'('Prelude.True',_5888662,_5891714,_5891720,_5891726):-hnf('Prelude.chr'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'(_5888662),'Prelude.ord'('^A')),'Prelude.ord'('^a'))),_5891714,_5891720,_5891726).
'blocked_blocked_Data.Char.toLower_ComplexCase'('Prelude.False',_5888662,_5894972,_5894978,_5894984):-!,hnf('Prelude.otherwise',_5897206,_5894978,_5897178),'blocked_blocked_Data.Char.toLower_ComplexCase_Prelude.False_ComplexCase'(_5897206,_5888662,_5894972,_5897178,_5894984).

'blocked_blocked_Data.Char.toLower_ComplexCase_Prelude.False_ComplexCase'(_5897818,_5897820,_5897822,_5897824,_5897826):-freeze(_5897824,freeze(_5897818,'blocked_blocked_blocked_Data.Char.toLower_ComplexCase_Prelude.False_ComplexCase'(_5897818,_5897820,_5897822,_5897824,_5897826))).
'blocked_blocked_blocked_Data.Char.toLower_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5888662,_5898212,_5898218,_5898224):-hnf(_5888662,_5898212,_5898218,_5898224).
'blocked_blocked_blocked_Data.Char.toLower_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5888662,_5899192,_5899198,_5899204):-!,hnf(reportFailure4PAKCS('Data.Char.toLower',['Prelude.False']),_5899192,_5899198,_5899204).
'blocked_blocked_blocked_Data.Char.toLower_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5900620),_5888662,'FAIL'(_5900620),_5900634,_5900634).
'blocked_blocked_Data.Char.toLower_ComplexCase'('FAIL'(_5900694),_5888662,'FAIL'(_5900694),_5900708,_5900708).

'Data.Char.digitToInt'(_5901656,_5901658,_5901660,_5901662):-freeze(_5901660,'blocked_Data.Char.digitToInt'(_5901656,_5901658,_5901660,_5901662)).
'blocked_Data.Char.digitToInt'(_5901742,_5915748,_5915754,_5915760):-makeShare(_5901742,_5912830),hnf('Prelude.isDigit'(_5912830),_5916942,_5915754,_5916914),'blocked_Data.Char.digitToInt_ComplexCase'(_5916942,_5912830,_5915748,_5916914,_5915760).

'blocked_Data.Char.digitToInt_ComplexCase'(_5917362,_5917364,_5917366,_5917368,_5917370):-freeze(_5917368,freeze(_5917362,'blocked_blocked_Data.Char.digitToInt_ComplexCase'(_5917362,_5917364,_5917366,_5917368,_5917370))).
'blocked_blocked_Data.Char.digitToInt_ComplexCase'('Prelude.True',_5912830,_5917756,_5917762,_5917768):-hnf('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'(_5912830),'Prelude.ord'('^0')),_5917756,_5917762,_5917768).
'blocked_blocked_Data.Char.digitToInt_ComplexCase'('Prelude.False',_5912830,_5924646,_5924652,_5924658):-!,makeShare(_5912830,_5919768),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23','Prelude.ord'(_5919768)),'Prelude.ord'('^A')),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'('Prelude.ord'(_5919768),'Prelude.ord'('^F'))),_5926988,_5924652,_5926960),'blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase'(_5926988,_5919768,_5924646,_5926960,_5924658).

'blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase'(_5927630,_5927632,_5927634,_5927636,_5927638):-freeze(_5927636,freeze(_5927630,'blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase'(_5927630,_5927632,_5927634,_5927636,_5927638))).
'blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5919768,_5928024,_5928030,_5928036):-hnf('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'(_5919768),'Prelude.ord'('^A')),10),_5928024,_5928030,_5928036).
'blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5919768,_5935336,_5935342,_5935348):-!,makeShare(_5919768,_5930656),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23','Prelude.ord'(_5930656)),'Prelude.ord'('^a')),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'('Prelude.ord'(_5930656),'Prelude.ord'('^f'))),_5938902,_5935342,_5938874),'blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5938902,_5930656,_5935336,_5938874,_5935348).

'blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5939748,_5939750,_5939752,_5939754,_5939756):-freeze(_5939754,freeze(_5939748,'blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5939748,_5939750,_5939752,_5939754,_5939756))).
'blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5930656,_5940142,_5940148,_5940154):-hnf('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'(_5930656),'Prelude.ord'('^a')),10),_5940142,_5940148,_5940154).
'blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5930656,_5945016,_5945022,_5945028):-!,hnf('Prelude.otherwise',_5949806,_5945022,_5949778),'blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5949806,_5930656,_5945016,_5949778,_5945028).

'blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5950844,_5950846,_5950848,_5950850,_5950852):-freeze(_5950850,freeze(_5950844,'blocked_blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5950844,_5950846,_5950848,_5950850,_5950852))).
'blocked_blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5930656,_5951238,_5951244,_5951250):-hnf('Prelude.error'(['^C','^h','^a','^r',^.,'^d','^i','^g','^i','^t','^T','^o','^I','^n','^t',^:,'^ ','^a','^r','^g','^u','^m','^e','^n','^t','^ ','^i','^s','^ ','^n','^o','^t','^ ','^a','^ ','^d','^i','^g','^i','^t']),_5951238,_5951244,_5951250).
'blocked_blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5930656,_5960924,_5960930,_5960936):-!,hnf(reportFailure4PAKCS('Data.Char.digitToInt',['Prelude.False']),_5960924,_5960930,_5960936).
'blocked_blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5962796),_5930656,'FAIL'(_5962796),_5962810,_5962810).
'blocked_blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5962870),_5930656,'FAIL'(_5962870),_5962884,_5962884).
'blocked_blocked_blocked_Data.Char.digitToInt_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_5962944),_5919768,'FAIL'(_5962944),_5962958,_5962958).
'blocked_blocked_Data.Char.digitToInt_ComplexCase'('FAIL'(_5963018),_5912830,'FAIL'(_5963018),_5963032,_5963032).

'Data.Char.intToDigit'(_5963980,_5963982,_5963984,_5963986):-freeze(_5963984,'blocked_Data.Char.intToDigit'(_5963980,_5963982,_5963984,_5963986)).
'blocked_Data.Char.intToDigit'(_5964066,_5978176,_5978182,_5978188):-makeShare(_5964066,_5974146),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23',_5974146),0),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'(_5974146,9)),_5979370,_5978182,_5979342),'blocked_Data.Char.intToDigit_ComplexCase'(_5979370,_5974146,_5978176,_5979342,_5978188).

'blocked_Data.Char.intToDigit_ComplexCase'(_5979790,_5979792,_5979794,_5979796,_5979798):-freeze(_5979796,freeze(_5979790,'blocked_blocked_Data.Char.intToDigit_ComplexCase'(_5979790,_5979792,_5979794,_5979796,_5979798))).
'blocked_blocked_Data.Char.intToDigit_ComplexCase'('Prelude.True',_5974146,_5980184,_5980190,_5980196):-hnf('Prelude.chr'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'('^0'),_5974146)),_5980184,_5980190,_5980196).
'blocked_blocked_Data.Char.intToDigit_ComplexCase'('Prelude.False',_5974146,_5985950,_5985956,_5985962):-!,makeShare(_5974146,_5982122),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23',_5982122),10),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'(_5982122,15)),_5988292,_5985956,_5988264),'blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase'(_5988292,_5982122,_5985950,_5988264,_5985962).

'blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase'(_5988934,_5988936,_5988938,_5988940,_5988942):-freeze(_5988940,freeze(_5988934,'blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase'(_5988934,_5988936,_5988938,_5988940,_5988942))).
'blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5982122,_5989328,_5989334,_5989340):-hnf('Prelude.chr'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude.ord'('^A'),_5982122),10)),_5989328,_5989334,_5989340).
'blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5982122,_5993878,_5993884,_5993890):-!,hnf('Prelude.otherwise',_5997444,_5993884,_5997416),'blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5997444,_5982122,_5993878,_5997416,_5993890).

'blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5998278,_5998280,_5998282,_5998284,_5998286):-freeze(_5998284,freeze(_5998278,'blocked_blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_5998278,_5998280,_5998282,_5998284,_5998286))).
'blocked_blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_5982122,_5998672,_5998678,_5998684):-hnf('Prelude.error'(['^C','^h','^a','^r',^.,'^i','^n','^t','^T','^o','^D','^i','^g','^i','^t',^:,'^ ','^a','^r','^g','^u','^m','^e','^n','^t','^ ','^n','^o','^t','^ ','^a','^ ','^d','^i','^g','^i','^t','^ ','^v','^a','^l','^u','^e']),_5998672,_5998678,_5998684).
'blocked_blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_5982122,_6008760,_6008766,_6008772):-!,hnf(reportFailure4PAKCS('Data.Char.intToDigit',['Prelude.False']),_6008760,_6008766,_6008772).
'blocked_blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_6010428),_5982122,'FAIL'(_6010428),_6010442,_6010442).
'blocked_blocked_blocked_Data.Char.intToDigit_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_6010502),_5982122,'FAIL'(_6010502),_6010516,_6010516).
'blocked_blocked_Data.Char.intToDigit_ComplexCase'('FAIL'(_6010576),_5974146,'FAIL'(_6010576),_6010590,_6010590).

:-costCenters(['']).




%%%%% Number of shared variables: 10

