%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('CPM.Query.Configuration').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23','_inst#Prelude.Data#CPM.Query.Configuration.CurryEntity#',1,'CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23','_impl#===#Prelude.Data#CPM.Query.Configuration.CurryEntity#',2,'CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23','_impl#aValue#Prelude.Data#CPM.Query.Configuration.CurryEntity#',0,'CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23','_inst#Prelude.Eq#CPM.Query.Configuration.CurryEntity#',1,'CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23','_impl#==#Prelude.Eq#CPM.Query.Configuration.CurryEntity#',2,'CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23\'2F\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23','_impl#/=#Prelude.Eq#CPM.Query.Configuration.CurryEntity#',0,'CPM.Query.Configuration._impl\'23\'2F\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23','_inst#Prelude.Show#CPM.Query.Configuration.CurryEntity#',1,'CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23show\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23','_impl#show#Prelude.Show#CPM.Query.Configuration.CurryEntity#',0,'CPM.Query.Configuration._impl\'23show\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23','_impl#showsPrec#Prelude.Show#CPM.Query.Configuration.CurryEntity#',2,'CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration._impl\'23showList\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23','_impl#showList#Prelude.Show#CPM.Query.Configuration.CurryEntity#',0,'CPM.Query.Configuration._impl\'23showList\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',nofix,notype).
functiontype('CPM.Query.Configuration.defaultShowRequests',defaultShowRequests,1,'CPM.Query.Configuration.defaultShowRequests',nofix,notype).
functiontype('CPM.Query.Configuration.curryInfoURL',curryInfoURL,0,'CPM.Query.Configuration.curryInfoURL',nofix,notype).
functiontype('CPM.Query.Configuration.curryInfoCache',curryInfoCache,0,'CPM.Query.Configuration.curryInfoCache',nofix,notype).
functiontype('CPM.Query.Configuration.packageRequests',packageRequests,0,'CPM.Query.Configuration.packageRequests',nofix,notype).
functiontype('CPM.Query.Configuration.packageVersionRequests',packageVersionRequests,0,'CPM.Query.Configuration.packageVersionRequests',nofix,notype).
functiontype('CPM.Query.Configuration.moduleRequests',moduleRequests,0,'CPM.Query.Configuration.moduleRequests',nofix,notype).
functiontype('CPM.Query.Configuration.classRequests',classRequests,0,'CPM.Query.Configuration.classRequests',nofix,notype).
functiontype('CPM.Query.Configuration.typeRequests',typeRequests,0,'CPM.Query.Configuration.typeRequests',nofix,notype).
functiontype('CPM.Query.Configuration.operationRequests',operationRequests,0,'CPM.Query.Configuration.operationRequests',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('CPM.Query.Configuration.Operation','Operation',0,'Query.Configuration.Operation',0,notype,['CPM.Query.Configuration.Type'/0,'CPM.Query.Configuration.Class'/0,'CPM.Query.Configuration.Unknown'/0]).
constructortype('CPM.Query.Configuration.Type','Type',0,'Query.Configuration.Type',1,notype,['CPM.Query.Configuration.Operation'/0,'CPM.Query.Configuration.Class'/0,'CPM.Query.Configuration.Unknown'/0]).
constructortype('CPM.Query.Configuration.Class','Class',0,'Query.Configuration.Class',2,notype,['CPM.Query.Configuration.Operation'/0,'CPM.Query.Configuration.Type'/0,'CPM.Query.Configuration.Unknown'/0]).
constructortype('CPM.Query.Configuration.Unknown','Unknown',0,'Query.Configuration.Unknown',3,notype,['CPM.Query.Configuration.Operation'/0,'CPM.Query.Configuration.Type'/0,'CPM.Query.Configuration.Class'/0]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19560740,_19560742,_19560744,_19560746):-freeze(_19560744,'blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19560740,_19560742,_19560744,_19560746)).
'blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19560826,_19561716,_19561722,_19561728):-hnf(_19560826,_19565154,_19561722,_19565166),'blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19565154,_19561716,_19565166,_19561728).

'blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19565918,_19565920,_19565922,_19565924):-freeze(_19565922,'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19565918,_19565920,_19565922,_19565924)).
'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23',[]),'CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'),_19566270,_19566270):-!.
'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('FAIL'(_19568506),'FAIL'(_19568506),_19568520,_19568520):-nonvar(_19568506).

'CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19572082,_19572084,_19572086,_19572088,_19572090):-freeze(_19572088,'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19572082,_19572084,_19572086,_19572088,_19572090)).
'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19572178,_19572196,_19574906,_19574912,_19574918):-hnf(_19572178,_19578784,_19574912,_19578802),'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19578784,_19572196,_19574906,_19578802,_19574918).

'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19579634,_19579636,_19579638,_19579640,_19579642):-freeze(_19579640,'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19579634,_19579636,_19579638,_19579640,_19579642)).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Operation',_19572196,_19580994,_19581000,_19581006):-hnf(_19572196,_19586252,_19581000,_19586264),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'(_19586252,_19580994,_19586264,_19581006).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'(_19587352,_19587354,_19587356,_19587358):-freeze(_19587356,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'(_19587352,_19587354,_19587356,_19587358)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Operation','Prelude.True',_19587988,_19587988).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Type','Prelude.False',_19589624,_19589624).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Class','Prelude.False',_19591278,_19591278).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Unknown','Prelude.False',_19592956,_19592956):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('FAIL'(_19594114),'FAIL'(_19594114),_19594128,_19594128):-nonvar(_19594114).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Type',_19572196,_19595394,_19595400,_19595406):-hnf(_19572196,_19600502,_19595400,_19600514),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'(_19600502,_19595394,_19600514,_19595406).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'(_19601572,_19601574,_19601576,_19601578):-freeze(_19601576,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'(_19601572,_19601574,_19601576,_19601578)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Operation','Prelude.False',_19602208,_19602208).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Type','Prelude.True',_19603820,_19603820).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Class','Prelude.False',_19605438,_19605438).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Unknown','Prelude.False',_19607086,_19607086):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('FAIL'(_19608214),'FAIL'(_19608214),_19608228,_19608228):-nonvar(_19608214).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Class',_19572196,_19609506,_19609512,_19609518):-hnf(_19572196,_19614644,_19609512,_19614656),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'(_19614644,_19609506,_19614656,_19609518).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'(_19615720,_19615722,_19615724,_19615726):-freeze(_19615724,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'(_19615720,_19615722,_19615724,_19615726)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Operation','Prelude.False',_19616356,_19616356).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Type','Prelude.False',_19617974,_19617974).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Class','Prelude.True',_19619604,_19619604).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Unknown','Prelude.False',_19621252,_19621252):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('FAIL'(_19622386),'FAIL'(_19622386),_19622400,_19622400):-nonvar(_19622386).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Unknown',_19572196,_19623702,_19623708,_19623714):-!,hnf(_19572196,_19628900,_19623708,_19628912),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'(_19628900,_19623702,_19628912,_19623714).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'(_19630006,_19630008,_19630010,_19630012):-freeze(_19630010,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'(_19630006,_19630008,_19630010,_19630012)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Operation','Prelude.False',_19630642,_19630642).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Type','Prelude.False',_19632272,_19632272).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Class','Prelude.False',_19633914,_19633914).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Unknown','Prelude.True',_19635580,_19635580):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('FAIL'(_19636720),'FAIL'(_19636720),_19636734,_19636734):-nonvar(_19636720).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23_1'('FAIL'(_19636790),_19572196,'FAIL'(_19636790),_19636804,_19636804):-nonvar(_19636790).

'CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19640404,_19640406,_19640408):-freeze(_19640406,'blocked_CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'(_19640404,_19640406,_19640408)).
'blocked_CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'('CPM.Query.Configuration.Operation',_19641050,_19641050).
'blocked_CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'('CPM.Query.Configuration.Type',_19641966,_19641966).
'blocked_CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'('CPM.Query.Configuration.Class',_19642852,_19642852).
'blocked_CPM.Query.Configuration._impl\'23aValue\'23Prelude.Data\'23CPM.Query.Configuration.CurryEntity\'23'('CPM.Query.Configuration.Unknown',_19643744,_19643744).

'CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19647814,_19647816,_19647818,_19647820):-freeze(_19647818,'blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19647814,_19647816,_19647818,_19647820)).
'blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19647900,_19648778,_19648784,_19648790):-hnf(_19647900,_19652144,_19648784,_19652156),'blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19652144,_19648778,_19652156,_19648790).

'blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19652896,_19652898,_19652900,_19652902):-freeze(_19652900,'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19652896,_19652898,_19652900,_19652902)).
'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('Prelude.()','Prelude._Dict\'23Eq'(partcall(2,'CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23',[]),'CPM.Query.Configuration._impl\'23\'2F\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'),_19653248,_19653248):-!.
'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('FAIL'(_19655418),'FAIL'(_19655418),_19655432,_19655432):-nonvar(_19655418).

'CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19658852,_19658854,_19658856,_19658858,_19658860):-freeze(_19658858,'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19658852,_19658854,_19658856,_19658858,_19658860)).
'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19658948,_19658966,_19661646,_19661652,_19661658):-hnf(_19658948,_19665344,_19661652,_19665362),'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19665344,_19658966,_19661646,_19665362,_19661658).

'blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19666164,_19666166,_19666168,_19666170,_19666172):-freeze(_19666170,'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19666164,_19666166,_19666168,_19666170,_19666172)).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Operation',_19658966,_19667494,_19667500,_19667506):-hnf(_19658966,_19672572,_19667500,_19672584),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'(_19672572,_19667494,_19672584,_19667506).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'(_19673642,_19673644,_19673646,_19673648):-freeze(_19673646,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'(_19673642,_19673644,_19673646,_19673648)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Operation','Prelude.True',_19674278,_19674278).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Type','Prelude.False',_19675884,_19675884).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Class','Prelude.False',_19677508,_19677508).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('CPM.Query.Configuration.Unknown','Prelude.False',_19679156,_19679156):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Operation_1'('FAIL'(_19680284),'FAIL'(_19680284),_19680298,_19680298):-nonvar(_19680284).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Type',_19658966,_19681534,_19681540,_19681546):-hnf(_19658966,_19686462,_19681540,_19686474),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'(_19686462,_19681534,_19686474,_19681546).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'(_19687502,_19687504,_19687506,_19687508):-freeze(_19687506,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'(_19687502,_19687504,_19687506,_19687508)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Operation','Prelude.False',_19688138,_19688138).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Type','Prelude.True',_19689720,_19689720).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Class','Prelude.False',_19691308,_19691308).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('CPM.Query.Configuration.Unknown','Prelude.False',_19692926,_19692926):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Type_1'('FAIL'(_19694024),'FAIL'(_19694024),_19694038,_19694038):-nonvar(_19694024).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Class',_19658966,_19695286,_19695292,_19695298):-hnf(_19658966,_19700244,_19695292,_19700256),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'(_19700244,_19695286,_19700256,_19695298).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'(_19701290,_19701292,_19701294,_19701296):-freeze(_19701294,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'(_19701290,_19701292,_19701294,_19701296)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Operation','Prelude.False',_19701926,_19701926).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Type','Prelude.False',_19703514,_19703514).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Class','Prelude.True',_19705114,_19705114).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('CPM.Query.Configuration.Unknown','Prelude.False',_19706732,_19706732):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Class_1'('FAIL'(_19707836),'FAIL'(_19707836),_19707850,_19707850):-nonvar(_19707836).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('CPM.Query.Configuration.Unknown',_19658966,_19709122,_19709128,_19709134):-!,hnf(_19658966,_19714140,_19709128,_19714152),'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'(_19714140,_19709122,_19714152,_19709134).

'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'(_19715216,_19715218,_19715220,_19715222):-freeze(_19715220,'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'(_19715216,_19715218,_19715220,_19715222)).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Operation','Prelude.False',_19715852,_19715852).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Type','Prelude.False',_19717452,_19717452).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Class','Prelude.False',_19719064,_19719064).
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('CPM.Query.Configuration.Unknown','Prelude.True',_19720700,_19720700):-!.
'blocked_blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1_CPM.Query.Configuration.Unknown_1'('FAIL'(_19721810),'FAIL'(_19721810),_19721824,_19721824):-nonvar(_19721810).
'blocked_blocked_CPM.Query.Configuration._impl\'23\'3D\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23_1'('FAIL'(_19721880),_19658966,'FAIL'(_19721880),_19721894,_19721894):-nonvar(_19721880).

'CPM.Query.Configuration._impl\'23\'2F\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19725322,_19725324,_19725326):-freeze(_19725324,'blocked_CPM.Query.Configuration._impl\'23\'2F\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19725322,_19725324,_19725326)).
'blocked_CPM.Query.Configuration._impl\'23\'2F\'3D\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23'(_19725494,_19725500,_19725506):-hnf(partcall(2,'Prelude._def\'23\'2F\'3D\'23Prelude.Eq',[partcall(1,'CPM.Query.Configuration._inst\'23Prelude.Eq\'23CPM.Query.Configuration.CurryEntity\'23',[])]),_19725494,_19725500,_19725506).

'CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19730292,_19730294,_19730296,_19730298):-freeze(_19730296,'blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19730292,_19730294,_19730296,_19730298)).
'blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19730378,_19731352,_19731358,_19731364):-hnf(_19730378,_19734790,_19731358,_19734802),'blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19734790,_19731352,_19734802,_19731364).

'blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19735554,_19735556,_19735558,_19735560):-freeze(_19735558,'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_1'(_19735554,_19735556,_19735558,_19735560)).
'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_1'('Prelude.()','Prelude._Dict\'23Show'('CPM.Query.Configuration._impl\'23show\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',partcall(2,'CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',[]),'CPM.Query.Configuration._impl\'23showList\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'),_19735906,_19735906):-!.
'blocked_blocked_CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_1'('FAIL'(_19738814),'FAIL'(_19738814),_19738828,_19738828):-nonvar(_19738814).

'CPM.Query.Configuration._impl\'23show\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19742344,_19742346,_19742348):-freeze(_19742346,'blocked_CPM.Query.Configuration._impl\'23show\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19742344,_19742346,_19742348)).
'blocked_CPM.Query.Configuration._impl\'23show\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19742516,_19742522,_19742528):-hnf(partcall(1,'Prelude._def\'23show\'23Prelude.Show',[partcall(1,'CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',[])]),_19742516,_19742522,_19742528).

'CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19747734,_19747736,_19747738,_19747740,_19747742):-freeze(_19747740,'blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19747734,_19747736,_19747738,_19747740,_19747742)).
'blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19747830,_19747848,_19753136,_19753142,_19753148):-hnf(_19747848,_19757014,_19753142,_19757032),'blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'(_19757014,_19747830,_19753136,_19757032,_19753148).

'blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'(_19757864,_19757866,_19757868,_19757870,_19757872):-freeze(_19757870,'blocked_blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'(_19757864,_19757866,_19757868,_19757870,_19757872)).
'blocked_blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'('CPM.Query.Configuration.Operation',_19747830,_19758504,_19758510,_19758516):-hnf(partcall(1,'Prelude.showString',[['^O','^p','^e','^r','^a','^t','^i','^o','^n']]),_19758504,_19758510,_19758516).
'blocked_blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'('CPM.Query.Configuration.Type',_19747830,_19761934,_19761940,_19761946):-hnf(partcall(1,'Prelude.showString',[['^T','^y','^p','^e']]),_19761934,_19761940,_19761946).
'blocked_blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'('CPM.Query.Configuration.Class',_19747830,_19764366,_19764372,_19764378):-hnf(partcall(1,'Prelude.showString',[['^C','^l','^a','^s','^s']]),_19764366,_19764372,_19764378).
'blocked_blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'('CPM.Query.Configuration.Unknown',_19747830,_19767024,_19767030,_19767036):-!,hnf(partcall(1,'Prelude.showString',[['^U','^n','^k','^n','^o','^w','^n']]),_19767024,_19767030,_19767036).
'blocked_blocked_CPM.Query.Configuration._impl\'23showsPrec\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23_2'('FAIL'(_19769578),_19747830,'FAIL'(_19769578),_19769592,_19769592):-nonvar(_19769578).

'CPM.Query.Configuration._impl\'23showList\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19773268,_19773270,_19773272):-freeze(_19773270,'blocked_CPM.Query.Configuration._impl\'23showList\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19773268,_19773270,_19773272)).
'blocked_CPM.Query.Configuration._impl\'23showList\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23'(_19773440,_19773446,_19773452):-hnf('Prelude._def\'23showList\'23Prelude.Show'(partcall(1,'CPM.Query.Configuration._inst\'23Prelude.Show\'23CPM.Query.Configuration.CurryEntity\'23',[])),_19773440,_19773446,_19773452).

'CPM.Query.Configuration.defaultShowRequests'(_19776812,_19776814,_19776816,_19776818):-freeze(_19776816,'blocked_CPM.Query.Configuration.defaultShowRequests'(_19776812,_19776814,_19776816,_19776818)).
'blocked_CPM.Query.Configuration.defaultShowRequests'(_19776898,_19796596,_19796602,_19796608):-hnf(_19776898,_19798522,_19796602,_19798534),'blocked_CPM.Query.Configuration.defaultShowRequests_1'(_19798522,_19796596,_19798534,_19796608).

'blocked_CPM.Query.Configuration.defaultShowRequests_1'(_19799040,_19799042,_19799044,_19799046):-freeze(_19799044,freeze(_19799040,'blocked_blocked_CPM.Query.Configuration.defaultShowRequests_1'(_19799040,_19799042,_19799044,_19799046))).
'blocked_blocked_CPM.Query.Configuration.defaultShowRequests_1'('CPM.Query.Configuration.Operation',[['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],['^t','^o','^t','^a','^l','^l','^y',^-,'^d','^e','^f','^i','^n','^e','^d'],['^t','^e','^r','^m','^i','^n','^a','^t','^i','^n','^g'],['^d','^e','^m','^a','^n','^d'],['^f','^a','^i','^l','^f','^r','^e','^e']],_19799682,_19799682).
'blocked_blocked_CPM.Query.Configuration.defaultShowRequests_1'('CPM.Query.Configuration.Type',[['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^d','^e','^f','^i','^n','^i','^t','^i','^o','^n']],_19815270,_19815270).
'blocked_blocked_CPM.Query.Configuration.defaultShowRequests_1'('CPM.Query.Configuration.Class',[['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^d','^e','^f','^i','^n','^i','^t','^i','^o','^n']],_19821328,_19821328).
'blocked_blocked_CPM.Query.Configuration.defaultShowRequests_1'('CPM.Query.Configuration.Unknown',[],_19827410,_19827410):-!.
'blocked_blocked_CPM.Query.Configuration.defaultShowRequests_1'('FAIL'(_19827898),'FAIL'(_19827898),_19827912,_19827912).

'CPM.Query.Configuration.curryInfoURL'(_19829460,_19829462,_19829464):-freeze(_19829462,'blocked_CPM.Query.Configuration.curryInfoURL'(_19829460,_19829462,_19829464)).
'blocked_CPM.Query.Configuration.curryInfoURL'(['^h','^t','^t','^p','^s',^:,^/,^/,'^c','^p','^m',^.,'^c','^u','^r','^r','^y',^-,'^l','^a','^n','^g',^.,'^o','^r','^g',^/,'^c','^u','^r','^r','^y',^-,'^i','^n','^f','^o',^/,'^r','^u','^n',^.,'^c','^g','^i'],_19836484,_19836484).

'CPM.Query.Configuration.curryInfoCache'(_19847512,_19847514,_19847516):-freeze(_19847514,'blocked_CPM.Query.Configuration.curryInfoCache'(_19847512,_19847514,_19847516)).
'blocked_CPM.Query.Configuration.curryInfoCache'([],_19847606,_19847606).

'CPM.Query.Configuration.packageRequests'(_19849594,_19849596,_19849598):-freeze(_19849596,'blocked_CPM.Query.Configuration.packageRequests'(_19849594,_19849596,_19849598)).
'blocked_CPM.Query.Configuration.packageRequests'([['^n','^a','^m','^e'],['^v','^e','^r','^s','^i','^o','^n','^s']],_19851872,_19851872).

'CPM.Query.Configuration.packageVersionRequests'(_19856984,_19856986,_19856988):-freeze(_19856986,'blocked_CPM.Query.Configuration.packageVersionRequests'(_19856984,_19856986,_19856988)).
'blocked_CPM.Query.Configuration.packageVersionRequests'([['^v','^e','^r','^s','^i','^o','^n'],['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^c','^a','^t','^e','^g','^o','^r','^i','^e','^s'],['^d','^e','^p','^e','^n','^d','^e','^n','^c','^i','^e','^s'],['^m','^o','^d','^u','^l','^e','^s'],['^e','^x','^p','^o','^r','^t','^e','^d','^m','^o','^d','^u','^l','^e','^s']],_19867942,_19867942).

'CPM.Query.Configuration.moduleRequests'(_19884152,_19884154,_19884156):-freeze(_19884154,'blocked_CPM.Query.Configuration.moduleRequests'(_19884152,_19884154,_19884156)).
'blocked_CPM.Query.Configuration.moduleRequests'([['^n','^a','^m','^e'],['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^s','^o','^u','^r','^c','^e','^c','^o','^d','^e'],['^u','^n','^s','^a','^f','^e'],['^c','^l','^a','^s','^s','^e','^s'],['^t','^y','^p','^e','^s'],['^o','^p','^e','^r','^a','^t','^i','^o','^n','^s']],_19893892,_19893892).

'CPM.Query.Configuration.classRequests'(_19908412,_19908414,_19908416):-freeze(_19908414,'blocked_CPM.Query.Configuration.classRequests'(_19908412,_19908414,_19908416)).
'blocked_CPM.Query.Configuration.classRequests'([['^n','^a','^m','^e'],['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^d','^e','^f','^i','^n','^i','^t','^i','^o','^n'],['^m','^e','^t','^h','^o','^d','^s']],_19914414,_19914414).

'CPM.Query.Configuration.typeRequests'(_19924006,_19924008,_19924010):-freeze(_19924008,'blocked_CPM.Query.Configuration.typeRequests'(_19924006,_19924008,_19924010)).
'blocked_CPM.Query.Configuration.typeRequests'([['^n','^a','^m','^e'],['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^d','^e','^f','^i','^n','^i','^t','^i','^o','^n'],['^c','^o','^n','^s','^t','^r','^u','^c','^t','^o','^r','^s']],_19930778,_19930778).

'CPM.Query.Configuration.operationRequests'(_19941564,_19941566,_19941568):-freeze(_19941566,'blocked_CPM.Query.Configuration.operationRequests'(_19941564,_19941566,_19941568)).
'blocked_CPM.Query.Configuration.operationRequests'([['^n','^a','^m','^e'],['^d','^o','^c','^u','^m','^e','^n','^t','^a','^t','^i','^o','^n'],['^d','^e','^f','^i','^n','^i','^t','^i','^o','^n'],['^s','^i','^g','^n','^a','^t','^u','^r','^e'],['^i','^n','^f','^i','^x'],['^p','^r','^e','^c','^e','^d','^e','^n','^c','^e'],['^d','^e','^m','^a','^n','^d'],['^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],['^i','^n','^d','^e','^t','^e','^r','^m','^i','^n','^i','^s','^t','^i','^c'],['^s','^o','^l','^u','^t','^i','^o','^n',^-,'^c','^o','^m','^p','^l','^e','^t','^e'],['^t','^e','^r','^m','^i','^n','^a','^t','^i','^n','^g'],['^t','^o','^t','^a','^l','^l','^y',^-,'^d','^e','^f','^i','^n','^e','^d'],['^r','^e','^s','^u','^l','^t',^-,'^v','^a','^l','^u','^e','^s'],['^f','^a','^i','^l','^f','^r','^e','^e'],['^i','^o','^t','^y','^p','^e']],_19968048,_19968048).

:-costCenters(['']).




%%%%% Number of shared variables: 0

