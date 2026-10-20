%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.Maybe').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Maybe.isJust',isJust,1,'Data.Maybe.isJust',nofix,notype).
functiontype('Data.Maybe.isNothing',isNothing,1,'Data.Maybe.isNothing',nofix,notype).
functiontype('Data.Maybe.fromJust',fromJust,1,'Data.Maybe.fromJust',nofix,notype).
functiontype('Data.Maybe.fromMaybe',fromMaybe,2,'Data.Maybe.fromMaybe',nofix,notype).
functiontype('Data.Maybe.listToMaybe',listToMaybe,1,'Data.Maybe.listToMaybe',nofix,notype).
functiontype('Data.Maybe.maybeToList',maybeToList,1,'Data.Maybe.maybeToList',nofix,notype).
functiontype('Data.Maybe.catMaybes',catMaybes,1,'Data.Maybe.catMaybes',nofix,notype).
functiontype('Data.Maybe.catMaybes._\'23lambda3','Data.Maybe.catMaybes._#lambda3',2,'Data.Maybe.catMaybes._\'23lambda3',nofix,notype).
functiontype('Data.Maybe.mapMaybe',mapMaybe,1,'Data.Maybe.mapMaybe',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Maybe.isJust'(_13031208,_13031210,_13031212,_13031214):-freeze(_13031212,'blocked_Data.Maybe.isJust'(_13031208,_13031210,_13031212,_13031214)).
'blocked_Data.Maybe.isJust'(_13031294,_13031732,_13031738,_13031744):-hnf(_13031294,_13032722,_13031738,_13032734),'blocked_Data.Maybe.isJust_1'(_13032722,_13031732,_13032734,_13031744).

'blocked_Data.Maybe.isJust_1'(_13033078,_13033080,_13033082,_13033084):-freeze(_13033082,'blocked_blocked_Data.Maybe.isJust_1'(_13033078,_13033080,_13033082,_13033084)).
'blocked_blocked_Data.Maybe.isJust_1'('Prelude.Just'(_13031410),'Prelude.True',_13033472,_13033472).
'blocked_blocked_Data.Maybe.isJust_1'('Prelude.Nothing','Prelude.False',_13034274,_13034274):-!.
'blocked_blocked_Data.Maybe.isJust_1'('FAIL'(_13034688),'FAIL'(_13034688),_13034702,_13034702):-nonvar(_13034688).

'Data.Maybe.isNothing'(_13035646,_13035648,_13035650,_13035652):-freeze(_13035650,'blocked_Data.Maybe.isNothing'(_13035646,_13035648,_13035650,_13035652)).
'blocked_Data.Maybe.isNothing'(_13035732,_13036188,_13036194,_13036200):-hnf(_13035732,_13037286,_13036194,_13037298),'blocked_Data.Maybe.isNothing_1'(_13037286,_13036188,_13037298,_13036200).

'blocked_Data.Maybe.isNothing_1'(_13037660,_13037662,_13037664,_13037666):-freeze(_13037664,'blocked_blocked_Data.Maybe.isNothing_1'(_13037660,_13037662,_13037664,_13037666)).
'blocked_blocked_Data.Maybe.isNothing_1'('Prelude.Nothing','Prelude.True',_13038080,_13038080).
'blocked_blocked_Data.Maybe.isNothing_1'('Prelude.Just'(_13035948),'Prelude.False',_13038808,_13038808):-!.
'blocked_blocked_Data.Maybe.isNothing_1'('FAIL'(_13039306),'FAIL'(_13039306),_13039320,_13039320):-nonvar(_13039306).

'Data.Maybe.fromJust'(_13040226,_13040228,_13040230,_13040232):-freeze(_13040230,'blocked_Data.Maybe.fromJust'(_13040226,_13040228,_13040230,_13040232)).
'blocked_Data.Maybe.fromJust'(_13040312,_13044374,_13044380,_13044386):-hnf(_13040312,_13045436,_13044380,_13045448),'blocked_Data.Maybe.fromJust_1'(_13045436,_13044374,_13045448,_13044386).

'blocked_Data.Maybe.fromJust_1'(_13045804,_13045806,_13045808,_13045810):-freeze(_13045808,'blocked_blocked_Data.Maybe.fromJust_1'(_13045804,_13045806,_13045808,_13045810)).
'blocked_blocked_Data.Maybe.fromJust_1'('Prelude.Just'(_13040428),_13046192,_13046198,_13046204):-hnf(_13040428,_13046192,_13046198,_13046204).
'blocked_blocked_Data.Maybe.fromJust_1'('Prelude.Nothing',_13046936,_13046942,_13046948):-!,hnf('Prelude.error'(['^M','^a','^y','^b','^e',^.,'^f','^r','^o','^m','^J','^u','^s','^t',^:,'^ ','^N','^o','^t','^h','^i','^n','^g']),_13046936,_13046942,_13046948).
'blocked_blocked_Data.Maybe.fromJust_1'('FAIL'(_13052144),'FAIL'(_13052144),_13052158,_13052158):-nonvar(_13052144).

'Data.Maybe.fromMaybe'(_13053102,_13053104,_13053106,_13053108,_13053110):-freeze(_13053108,'blocked_Data.Maybe.fromMaybe'(_13053102,_13053104,_13053106,_13053108,_13053110)).
'blocked_Data.Maybe.fromMaybe'(_13053198,_13053216,_13053652,_13053658,_13053664):-hnf(_13053216,_13054758,_13053658,_13054776),'blocked_Data.Maybe.fromMaybe_2'(_13054758,_13053198,_13053652,_13054776,_13053664).

'blocked_Data.Maybe.fromMaybe_2'(_13055146,_13055148,_13055150,_13055152,_13055154):-freeze(_13055152,'blocked_blocked_Data.Maybe.fromMaybe_2'(_13055146,_13055148,_13055150,_13055152,_13055154)).
'blocked_blocked_Data.Maybe.fromMaybe_2'('Prelude.Nothing',_13053198,_13055570,_13055576,_13055582):-hnf(_13053198,_13055570,_13055576,_13055582).
'blocked_blocked_Data.Maybe.fromMaybe_2'('Prelude.Just'(_13053418),_13053198,_13056302,_13056308,_13056314):-!,hnf(_13053418,_13056302,_13056308,_13056314).
'blocked_blocked_Data.Maybe.fromMaybe_2'('FAIL'(_13056810),_13053198,'FAIL'(_13056810),_13056824,_13056824):-nonvar(_13056810).

'Data.Maybe.listToMaybe'(_13057852,_13057854,_13057856,_13057858):-freeze(_13057856,'blocked_Data.Maybe.listToMaybe'(_13057852,_13057854,_13057856,_13057858)).
'blocked_Data.Maybe.listToMaybe'(_13057938,_13058500,_13058506,_13058512):-hnf(_13057938,_13059670,_13058506,_13059682),'blocked_Data.Maybe.listToMaybe_1'(_13059670,_13058500,_13059682,_13058512).

'blocked_Data.Maybe.listToMaybe_1'(_13060056,_13060058,_13060060,_13060062):-freeze(_13060060,'blocked_blocked_Data.Maybe.listToMaybe_1'(_13060056,_13060058,_13060060,_13060062)).
'blocked_blocked_Data.Maybe.listToMaybe_1'([],'Prelude.Nothing',_13060304,_13060304).
'blocked_blocked_Data.Maybe.listToMaybe_1'([_13058154|_13058172],'Prelude.Just'(_13058154),_13060944,_13060944):-!.
'blocked_blocked_Data.Maybe.listToMaybe_1'('FAIL'(_13061608),'FAIL'(_13061608),_13061622,_13061622):-nonvar(_13061608).

'Data.Maybe.maybeToList'(_13062642,_13062644,_13062646,_13062648):-freeze(_13062646,'blocked_Data.Maybe.maybeToList'(_13062642,_13062644,_13062646,_13062648)).
'blocked_Data.Maybe.maybeToList'(_13062728,_13063350,_13063356,_13063362):-hnf(_13062728,_13064520,_13063356,_13064532),'blocked_Data.Maybe.maybeToList_1'(_13064520,_13063350,_13064532,_13063362).

'blocked_Data.Maybe.maybeToList_1'(_13064906,_13064908,_13064910,_13064912):-freeze(_13064910,'blocked_blocked_Data.Maybe.maybeToList_1'(_13064906,_13064908,_13064910,_13064912)).
'blocked_blocked_Data.Maybe.maybeToList_1'('Prelude.Nothing',[],_13065326,_13065326).
'blocked_blocked_Data.Maybe.maybeToList_1'('Prelude.Just'(_13062944),[_13062944],_13065990,_13065990):-!.
'blocked_blocked_Data.Maybe.maybeToList_1'('FAIL'(_13066620),'FAIL'(_13066620),_13066634,_13066634):-nonvar(_13066620).

'Data.Maybe.catMaybes'(_13067578,_13067580,_13067582,_13067584):-freeze(_13067582,'blocked_Data.Maybe.catMaybes'(_13067578,_13067580,_13067582,_13067584)).
'blocked_Data.Maybe.catMaybes'(_13067664,_13067932,_13067938,_13067944):-hnf('Prelude.foldr'(partcall(2,'Data.Maybe.catMaybes._\'23lambda3',[]),[],_13067664),_13067932,_13067938,_13067944).

'Data.Maybe.catMaybes._\'23lambda3'(_13070180,_13070182,_13070184,_13070186,_13070188):-freeze(_13070186,'blocked_Data.Maybe.catMaybes._\'23lambda3'(_13070180,_13070182,_13070184,_13070186,_13070188)).
'blocked_Data.Maybe.catMaybes._\'23lambda3'(_13070276,_13070294,_13070948,_13070954,_13070960):-hnf(_13070276,_13072486,_13070954,_13072504),'blocked_Data.Maybe.catMaybes._\'23lambda3_1'(_13072486,_13070294,_13070948,_13072504,_13070960).

'blocked_Data.Maybe.catMaybes._\'23lambda3_1'(_13072952,_13072954,_13072956,_13072958,_13072960):-freeze(_13072958,freeze(_13072952,'blocked_blocked_Data.Maybe.catMaybes._\'23lambda3_1'(_13072952,_13072954,_13072956,_13072958,_13072960))).
'blocked_blocked_Data.Maybe.catMaybes._\'23lambda3_1'('Prelude.Just'(_13070410),_13070294,[_13070410|_13070294],_13073362,_13073362).
'blocked_blocked_Data.Maybe.catMaybes._\'23lambda3_1'('Prelude.Nothing',_13070294,_13074448,_13074454,_13074460):-!,hnf(_13070294,_13074448,_13074454,_13074460).
'blocked_blocked_Data.Maybe.catMaybes._\'23lambda3_1'('FAIL'(_13074962),_13070294,'FAIL'(_13074962),_13074976,_13074976).

'Data.Maybe.mapMaybe'(_13075886,_13075888,_13075890,_13075892):-freeze(_13075890,'blocked_Data.Maybe.mapMaybe'(_13075886,_13075888,_13075890,_13075892)).
'blocked_Data.Maybe.mapMaybe'(_13075972,_13076240,_13076246,_13076252):-hnf('Prelude..'(partcall(1,'Data.Maybe.catMaybes',[]),partcall(1,'Prelude.map',[_13075972])),_13076240,_13076246,_13076252).

:-costCenters(['']).




%%%%% Number of shared variables: 0

