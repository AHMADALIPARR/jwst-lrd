%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Analysis.Types').
:-importModule('Data.List').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').

:-curryModule('Analysis.TypeUsage').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Analysis.TypeUsage.typesInValuesAnalysis',typesInValuesAnalysis,0,'Analysis.TypeUsage.typesInValuesAnalysis',nofix,notype).
functiontype('Analysis.TypeUsage.showTypeNames',showTypeNames,2,'Analysis.TypeUsage.showTypeNames',nofix,notype).
functiontype('Analysis.TypeUsage.showTypeNames._\'23lambda1','Analysis.TypeUsage.showTypeNames._#lambda1',1,'Analysis.TypeUsage.showTypeNames._\'23lambda1',nofix,notype).
functiontype('Analysis.TypeUsage.typesInTypeDecl','Analysis.TypeUsage.typesInTypeDecl',2,'Analysis.TypeUsage.typesInTypeDecl',nofix,notype).
functiontype('Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11','Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11',2,'Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11',nofix,notype).
functiontype('Analysis.TypeUsage.typesInTypeExpr','Analysis.TypeUsage.typesInTypeExpr',2,'Analysis.TypeUsage.typesInTypeExpr',nofix,notype).
functiontype('Analysis.TypeUsage.join','Analysis.TypeUsage.join',2,'Analysis.TypeUsage.join',nofix,notype).
functiontype('Analysis.TypeUsage.join.insert.41','Analysis.TypeUsage.join.insert.41',3,'Analysis.TypeUsage.join.insert.41',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Analysis.TypeUsage.typesInValuesAnalysis'(_19806952,_19806954,_19806956):-freeze(_19806954,'blocked_Analysis.TypeUsage.typesInValuesAnalysis'(_19806952,_19806954,_19806956)).
'blocked_Analysis.TypeUsage.typesInValuesAnalysis'(_19809294,_19809300,_19809306):-hnf('Analysis.Types.dependencyTypeAnalysis'(['^T','^y','^p','^e','^s','^I','^n','^V','^a','^l','^u','^e','^s'],[],partcall(2,'Analysis.TypeUsage.typesInTypeDecl',[])),_19809294,_19809300,_19809306).

'Analysis.TypeUsage.showTypeNames'(_19814430,_19814432,_19814434,_19814436,_19814438):-freeze(_19814436,'blocked_Analysis.TypeUsage.showTypeNames'(_19814430,_19814432,_19814434,_19814436,_19814438)).
'blocked_Analysis.TypeUsage.showTypeNames'(_19814526,_19814544,_19815288,_19815294,_19815300):-hnf('Prelude.$'(partcall(1,'Data.List.intercalate',[['^,','^ ']]),'Prelude.map'(partcall(1,'Analysis.TypeUsage.showTypeNames._\'23lambda1',[]),_19814544)),_19815288,_19815294,_19815300).

'Analysis.TypeUsage.showTypeNames._\'23lambda1'(_19819048,_19819050,_19819052,_19819054):-freeze(_19819052,'blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1'(_19819048,_19819050,_19819052,_19819054)).
'blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1'(_19819134,_19820120,_19820126,_19820132):-hnf(_19819134,_19822082,_19820126,_19822094),'blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1_1'(_19822082,_19820120,_19822094,_19820132).

'blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1_1'(_19822600,_19822602,_19822604,_19822606):-freeze(_19822604,'blocked_blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1_1'(_19822600,_19822602,_19822604,_19822606)).
'blocked_blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1_1'('Prelude.(,)'(_19819250,_19819268),_19822970,_19822976,_19822982):-!,hnf('Prelude.++'(_19819250,'Prelude.++'([^.],_19819268)),_19822970,_19822976,_19822982).
'blocked_blocked_Analysis.TypeUsage.showTypeNames._\'23lambda1_1'('FAIL'(_19824492),'FAIL'(_19824492),_19824506,_19824506):-nonvar(_19824492).

'Analysis.TypeUsage.typesInTypeDecl'(_19825982,_19825984,_19825986,_19825988,_19825990):-freeze(_19825988,'blocked_Analysis.TypeUsage.typesInTypeDecl'(_19825982,_19825984,_19825986,_19825988,_19825990)).
'blocked_Analysis.TypeUsage.typesInTypeDecl'(_19826078,_19826096,_19828016,_19828022,_19828028):-hnf(_19826078,_19829626,_19828022,_19829644),'blocked_Analysis.TypeUsage.typesInTypeDecl_1'(_19829626,_19826096,_19828016,_19829644,_19828028).

'blocked_Analysis.TypeUsage.typesInTypeDecl_1'(_19830098,_19830100,_19830102,_19830104,_19830106):-freeze(_19830104,'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1'(_19830098,_19830100,_19830102,_19830104,_19830106)).
'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1'('FlatCurry.Types.Type'(_19826212,_19826230,_19826248,_19826266),_19826096,_19830616,_19830622,_19830628):-hnf('Prelude.$'(partcall(1,'Prelude.foldr',[[],partcall(2,'Analysis.TypeUsage.join',[])]),'Prelude.map'(partcall(1,'Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11',[_19826096]),_19826266)),_19830616,_19830622,_19830628).
'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1'('FlatCurry.Types.TypeSyn'(_19826968,_19826986,_19827004,_19827022),_19826096,_19833322,_19833328,_19833334):-hnf('Analysis.TypeUsage.typesInTypeExpr'(_19826096,_19827022),_19833322,_19833328,_19833334).
'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1'('FlatCurry.Types.TypeNew'(_19827304,_19827322,_19827340,_19827358),_19826096,_19835342,_19835348,_19835354):-!,hnf(_19827358,_19838032,_19835348,_19838068),'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1_FlatCurry.Types.TypeNew_4'(_19838032,_19827304,_19827322,_19827340,_19826096,_19835342,_19838068,_19835354).

'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1_FlatCurry.Types.TypeNew_4'(_19838768,_19838770,_19838772,_19838774,_19838776,_19838778,_19838780,_19838782):-freeze(_19838780,'blocked_blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1_FlatCurry.Types.TypeNew_4'(_19838768,_19838770,_19838772,_19838774,_19838776,_19838778,_19838780,_19838782)).
'blocked_blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1_FlatCurry.Types.TypeNew_4'('FlatCurry.Types.NewCons'(_19827498,_19827516,_19827534),_19827304,_19827322,_19827340,_19826096,_19839344,_19839350,_19839356):-!,hnf('Analysis.TypeUsage.typesInTypeExpr'(_19826096,_19827534),_19839344,_19839350,_19839356).
'blocked_blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1_FlatCurry.Types.TypeNew_4'('FAIL'(_19840912),_19827304,_19827322,_19827340,_19826096,'FAIL'(_19840912),_19840926,_19840926):-nonvar(_19840912).
'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl_1'('FAIL'(_19841014),_19826096,'FAIL'(_19841014),_19841028,_19841028):-nonvar(_19841014).

'Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11'(_19843234,_19843236,_19843238,_19843240,_19843242):-freeze(_19843240,'blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11'(_19843234,_19843236,_19843238,_19843240,_19843242)).
'blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11'(_19843330,_19843348,_19844542,_19844548,_19844554):-hnf(_19843348,_19846836,_19844548,_19846854),'blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11_2'(_19846836,_19843330,_19844542,_19846854,_19844554).

'blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11_2'(_19847422,_19847424,_19847426,_19847428,_19847430):-freeze(_19847428,'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11_2'(_19847422,_19847424,_19847426,_19847428,_19847430)).
'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11_2'('FlatCurry.Types.Cons'(_19843464,_19843482,_19843500,_19843518),_19843330,_19847940,_19847946,_19847952):-!,hnf('Prelude.$'(partcall(1,'Prelude.foldr',[[],partcall(2,'Analysis.TypeUsage.join',[])]),'Prelude.map'(partcall(1,'Analysis.TypeUsage.typesInTypeExpr',[_19843330]),_19843518)),_19847940,_19847946,_19847952).
'blocked_blocked_Analysis.TypeUsage.typesInTypeDecl.typesInConsDecl.11_2'('FAIL'(_19850200),_19843330,'FAIL'(_19850200),_19850214,_19850214):-nonvar(_19850200).

'Analysis.TypeUsage.typesInTypeExpr'(_19851698,_19851700,_19851702,_19851704,_19851706):-freeze(_19851704,'blocked_Analysis.TypeUsage.typesInTypeExpr'(_19851698,_19851700,_19851702,_19851704,_19851706)).
'blocked_Analysis.TypeUsage.typesInTypeExpr'(_19851794,_19851812,_19854902,_19854908,_19854914):-hnf(_19851812,_19856512,_19854908,_19856530),'blocked_Analysis.TypeUsage.typesInTypeExpr_2'(_19856512,_19851794,_19854902,_19856530,_19854914).

'blocked_Analysis.TypeUsage.typesInTypeExpr_2'(_19856984,_19856986,_19856988,_19856990,_19856992):-freeze(_19856990,'blocked_blocked_Analysis.TypeUsage.typesInTypeExpr_2'(_19856984,_19856986,_19856988,_19856990,_19856992)).
'blocked_blocked_Analysis.TypeUsage.typesInTypeExpr_2'('FlatCurry.Types.TVar'(_19851928),_19851794,[],_19857484,_19857484).
'blocked_blocked_Analysis.TypeUsage.typesInTypeExpr_2'('FlatCurry.Types.FuncType'(_19852052,_19852070),_19851794,_19858506,_19858512,_19858518):-makeShare(_19851794,_19858668),hnf('Analysis.TypeUsage.join'('Analysis.TypeUsage.typesInTypeExpr'(_19858668,_19852052),'Analysis.TypeUsage.typesInTypeExpr'(_19858668,_19852070)),_19858506,_19858512,_19858518).
'blocked_blocked_Analysis.TypeUsage.typesInTypeExpr_2'('FlatCurry.Types.TCons'(_19852648,_19852666),_19851794,_19860996,_19861002,_19861008):-makeShare(_19852648,_19861210),makeShare(_19851794,_19861230),hnf('Prelude.foldr'(partcall(2,'Analysis.TypeUsage.join',[]),'Analysis.TypeUsage.join'([_19861210],'Prelude.maybe'([],partcall(1,'Prelude.id',[]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_19861210,_19861230))),'Prelude.map'(partcall(1,'Analysis.TypeUsage.typesInTypeExpr',[_19861230]),_19852666)),_19860996,_19861002,_19861008).
'blocked_blocked_Analysis.TypeUsage.typesInTypeExpr_2'('FlatCurry.Types.ForallType'(_19854406,_19854424),_19851794,_19867060,_19867066,_19867072):-!,hnf('Analysis.TypeUsage.typesInTypeExpr'(_19851794,_19854424),_19867060,_19867066,_19867072).
'blocked_blocked_Analysis.TypeUsage.typesInTypeExpr_2'('FAIL'(_19868136),_19851794,'FAIL'(_19868136),_19868150,_19868150):-nonvar(_19868136).

'Analysis.TypeUsage.join'(_19869216,_19869218,_19869220,_19869222,_19869224):-freeze(_19869222,'blocked_Analysis.TypeUsage.join'(_19869216,_19869218,_19869220,_19869222,_19869224)).
'blocked_Analysis.TypeUsage.join'(_19869312,_19869330,_19870004,_19870010,_19870016):-hnf('Prelude.foldr'(partcall(2,'Analysis.TypeUsage.join.insert.41',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])]),_19869330,_19869312),_19870004,_19870010,_19870016).

'Analysis.TypeUsage.join.insert.41'(_19874464,_19874466,_19874468,_19874470,_19874472,_19874474):-freeze(_19874472,'blocked_Analysis.TypeUsage.join.insert.41'(_19874464,_19874466,_19874468,_19874470,_19874472,_19874474)).
'blocked_Analysis.TypeUsage.join.insert.41'(_19874570,_19874588,_19874606,_19877962,_19877968,_19877974):-hnf(_19874606,_19879544,_19877968,_19879568),'blocked_Analysis.TypeUsage.join.insert.41_3'(_19879544,_19874570,_19874588,_19877962,_19879568,_19877974).

'blocked_Analysis.TypeUsage.join.insert.41_3'(_19880024,_19880026,_19880028,_19880030,_19880032,_19880034):-freeze(_19880032,'blocked_blocked_Analysis.TypeUsage.join.insert.41_3'(_19880024,_19880026,_19880028,_19880030,_19880032,_19880034)).
'blocked_blocked_Analysis.TypeUsage.join.insert.41_3'([],_19874570,_19874588,[_19874588],_19880292,_19880292).
'blocked_blocked_Analysis.TypeUsage.join.insert.41_3'([_19874976|_19874994],_19874570,_19874588,_19885010,_19885016,_19885022):-!,makeShare(_19874570,_19881814),makeShare(_19874588,_19881834),makeShare(_19874976,_19881854),hnf('Prelude.apply'('Prelude.apply'('Prelude.=='('Prelude._super\'23Prelude.Ord\'23Prelude.Eq\'230\'23'(_19881814)),_19881834),_19881854),_19887186,_19885016,_19887140),'blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase'(_19887186,_19881854,_19874994,_19881814,_19881834,_19885010,_19887140,_19885022).

'blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase'(_19887816,_19887818,_19887820,_19887822,_19887824,_19887826,_19887828,_19887830):-freeze(_19887828,freeze(_19887816,'blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase'(_19887816,_19887818,_19887820,_19887822,_19887824,_19887826,_19887828,_19887830))).
'blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase'('Prelude.True',_19881854,_19874994,_19881814,_19881834,[_19881854|_19874994],_19888246,_19888246).
'blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase'('Prelude.False',_19881854,_19874994,_19881814,_19881834,_19892656,_19892662,_19892668):-!,makeShare(_19881814,_19890002),makeShare(_19881834,_19890022),makeShare(_19881854,_19890042),hnf('Prelude.apply'('Prelude.apply'('Prelude.<'(_19890002),_19890022),_19890042),_19896012,_19892662,_19895966),'blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase'(_19896012,_19890042,_19874994,_19890002,_19890022,_19892656,_19895966,_19892668).

'blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase'(_19896846,_19896848,_19896850,_19896852,_19896854,_19896856,_19896858,_19896860):-freeze(_19896858,freeze(_19896846,'blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase'(_19896846,_19896848,_19896850,_19896852,_19896854,_19896856,_19896858,_19896860))).
'blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19890042,_19874994,_19890002,_19890022,[_19890022,_19890042|_19874994],_19897276,_19897276).
'blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19890042,_19874994,_19890002,_19890022,_19900598,_19900604,_19900610):-!,hnf('Prelude.otherwise',_19905178,_19900604,_19905132),'blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19905178,_19890042,_19874994,_19890002,_19890022,_19900598,_19905132,_19900610).

'blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19906180,_19906182,_19906184,_19906186,_19906188,_19906190,_19906192,_19906194):-freeze(_19906192,freeze(_19906180,'blocked_blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19906180,_19906182,_19906184,_19906186,_19906188,_19906190,_19906192,_19906194))).
'blocked_blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19890042,_19874994,_19890002,_19890022,[_19890042|'Analysis.TypeUsage.join.insert.41'(_19890002,_19890022,_19874994)],_19906610,_19906610).
'blocked_blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19890042,_19874994,_19890002,_19890022,_19908938,_19908944,_19908950):-!,hnf(reportFailure4PAKCS('Analysis.TypeUsage.join.insert.41',['Prelude.False']),_19908938,_19908944,_19908950).
'blocked_blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19911068),_19890042,_19874994,_19890002,_19890022,'FAIL'(_19911068),_19911082,_19911082).
'blocked_blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19911166),_19890042,_19874994,_19890002,_19890022,'FAIL'(_19911166),_19911180,_19911180).
'blocked_blocked_blocked_Analysis.TypeUsage.join.insert.41_3_[|]_ComplexCase'('FAIL'(_19911264),_19881854,_19874994,_19881814,_19881834,'FAIL'(_19911264),_19911278,_19911278).
'blocked_blocked_Analysis.TypeUsage.join.insert.41_3'('FAIL'(_19911362),_19874570,_19874588,'FAIL'(_19911362),_19911376,_19911376):-nonvar(_19911362).

:-costCenters(['']).




%%%%% Number of shared variables: 9

