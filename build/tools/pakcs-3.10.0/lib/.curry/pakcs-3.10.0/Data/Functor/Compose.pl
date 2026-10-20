%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.Functor.Compose').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_inst#Prelude.Functor#Data.Functor.Compose.Compose#0##1##',3,'Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23fmap\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#fmap#Prelude.Functor#Data.Functor.Compose.Compose#0##1##',4,'Data.Functor.Compose._impl\'23fmap\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23\'3C\'24\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#<$#Prelude.Functor#Data.Functor.Compose.Compose#0##1##',2,'Data.Functor.Compose._impl\'23\'3C\'24\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_inst#Prelude.Applicative#Data.Functor.Compose.Compose#0##1##',3,'Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23pure\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#pure#Prelude.Applicative#Data.Functor.Compose.Compose#0##1##',3,'Data.Functor.Compose._impl\'23pure\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23\'3C\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#<*>#Prelude.Applicative#Data.Functor.Compose.Compose#0##1##',4,'Data.Functor.Compose._impl\'23\'3C\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#*>#Prelude.Applicative#Data.Functor.Compose.Compose#0##1##',2,'Data.Functor.Compose._impl\'23\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23\'3C\'2A\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#<*#Prelude.Applicative#Data.Functor.Compose.Compose#0##1##',2,'Data.Functor.Compose._impl\'23\'3C\'2A\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose._impl\'23liftA2\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23','_impl#liftA2#Prelude.Applicative#Data.Functor.Compose.Compose#0##1##',5,'Data.Functor.Compose._impl\'23liftA2\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Data.Functor.Compose.getCompose',getCompose,1,'Data.Functor.Compose.getCompose',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3961500,_3961502,_3961504,_3961506,_3961508,_3961510):-freeze(_3961508,'blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3961500,_3961502,_3961504,_3961506,_3961508,_3961510)).
'blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3961606,_3961624,_3961642,_3962870,_3962876,_3962882):-hnf(_3961642,_3966576,_3962876,_3966600),'blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'(_3966576,_3961606,_3961624,_3962870,_3966600,_3962882).

'blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'(_3967410,_3967412,_3967414,_3967416,_3967418,_3967420):-freeze(_3967418,'blocked_blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'(_3967410,_3967412,_3967414,_3967416,_3967418,_3967420)).
'blocked_blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'('Prelude.()',_3961606,_3961624,'Prelude._Dict\'23Functor'(partcall(2,'Data.Functor.Compose._impl\'23fmap\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_3967954,_3967934]),'Data.Functor.Compose._impl\'23\'3C\'24\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3967934,_3967954)),_3967782,_3967788):-!,makeShare(_3961606,_3967934),makeShare(_3961624,_3967954),_3967782=_3967788.
'blocked_blocked_Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'('FAIL'(_3971178),_3961606,_3961624,'FAIL'(_3971178),_3971192,_3971192):-nonvar(_3971178).

'Data.Functor.Compose._impl\'23fmap\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3974798,_3974800,_3974802,_3974804,_3974806,_3974808,_3974810):-freeze(_3974808,'blocked_Data.Functor.Compose._impl\'23fmap\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3974798,_3974800,_3974802,_3974804,_3974806,_3974808,_3974810)).
'blocked_Data.Functor.Compose._impl\'23fmap\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3974914,_3974932,_3974950,_3974968,_3975614,_3975620,_3975626):-hnf('Prelude.apply'('Prelude.apply'('Prelude.fmap'(_3974914),'Prelude.apply'('Prelude.fmap'(_3974932),_3974950)),_3974968),_3975614,_3975620,_3975626).

'Data.Functor.Compose._impl\'23\'3C\'24\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3981456,_3981458,_3981460,_3981462,_3981464):-freeze(_3981462,'blocked_Data.Functor.Compose._impl\'23\'3C\'24\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3981456,_3981458,_3981460,_3981462,_3981464)).
'blocked_Data.Functor.Compose._impl\'23\'3C\'24\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3981552,_3981570,_3981824,_3981830,_3981836):-hnf('Prelude._def\'23\'3C\'24\'23Prelude.Functor'(partcall(1,'Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_3981570,_3981552])),_3981824,_3981830,_3981836).

'Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3987332,_3987334,_3987336,_3987338,_3987340,_3987342):-freeze(_3987340,'blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3987332,_3987334,_3987336,_3987338,_3987340,_3987342)).
'blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3987438,_3987456,_3987474,_3989790,_3989796,_3989802):-hnf(_3987474,_3993640,_3989796,_3993664),'blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'(_3993640,_3987438,_3987456,_3989790,_3993664,_3989802).

'blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'(_3994498,_3994500,_3994502,_3994504,_3994506,_3994508):-freeze(_3994506,'blocked_blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'(_3994498,_3994500,_3994502,_3994504,_3994506,_3994508)).
'blocked_blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'('Prelude.()',_3987438,_3987456,'Prelude._Dict\'23Applicative'(partcall(1,'Data.Functor.Compose._inst\'23Prelude.Functor\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',['Prelude._super\'23Prelude.Applicative\'23Prelude.Functor\'230\'23'(_3995214),'Prelude._super\'23Prelude.Applicative\'23Prelude.Functor\'230\'23'(_3995194)]),partcall(1,'Data.Functor.Compose._impl\'23pure\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_3995214,_3995194]),partcall(2,'Data.Functor.Compose._impl\'23\'3C\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_3995214,_3995194]),'Data.Functor.Compose._impl\'23\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3995194,_3995214),'Data.Functor.Compose._impl\'23\'3C\'2A\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_3995194,_3995214),partcall(3,'Data.Functor.Compose._impl\'23liftA2\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_3995214,_3995194])),_3994870,_3994876):-!,makeShare(_3987438,_3995194),makeShare(_3987456,_3995214),_3994870=_3994876.
'blocked_blocked_Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23_3'('FAIL'(_4003036),_3987438,_3987456,'FAIL'(_4003036),_4003050,_4003050):-nonvar(_4003036).

'Data.Functor.Compose._impl\'23pure\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4006808,_4006810,_4006812,_4006814,_4006816,_4006818):-freeze(_4006816,'blocked_Data.Functor.Compose._impl\'23pure\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4006808,_4006810,_4006812,_4006814,_4006816,_4006818)).
'blocked_Data.Functor.Compose._impl\'23pure\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4006914,_4006932,_4006950,_4007442,_4007448,_4007454):-hnf('Prelude.apply'('Prelude.pure'(_4006914),'Prelude.apply'('Prelude.pure'(_4006932),_4006950)),_4007442,_4007448,_4007454).

'Data.Functor.Compose._impl\'23\'3C\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4013136,_4013138,_4013140,_4013142,_4013144,_4013146,_4013148):-freeze(_4013146,'blocked_Data.Functor.Compose._impl\'23\'3C\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4013136,_4013138,_4013140,_4013142,_4013144,_4013146,_4013148)).
'blocked_Data.Functor.Compose._impl\'23\'3C\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4013252,_4013270,_4013288,_4013306,_4013952,_4013958,_4013964):-hnf('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.liftA2'(_4013252),'Prelude.<*>'(_4013270)),_4013288),_4013306),_4013952,_4013958,_4013964).

'Data.Functor.Compose._impl\'23\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4020094,_4020096,_4020098,_4020100,_4020102):-freeze(_4020100,'blocked_Data.Functor.Compose._impl\'23\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4020094,_4020096,_4020098,_4020100,_4020102)).
'blocked_Data.Functor.Compose._impl\'23\'2A\'3E\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4020190,_4020208,_4020462,_4020468,_4020474):-hnf(partcall(2,'Prelude._def\'23\'2A\'3E\'23Prelude.Applicative',[partcall(1,'Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_4020208,_4020190])]),_4020462,_4020468,_4020474).

'Data.Functor.Compose._impl\'23\'3C\'2A\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4026246,_4026248,_4026250,_4026252,_4026254):-freeze(_4026252,'blocked_Data.Functor.Compose._impl\'23\'3C\'2A\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4026246,_4026248,_4026250,_4026252,_4026254)).
'blocked_Data.Functor.Compose._impl\'23\'3C\'2A\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4026342,_4026360,_4026614,_4026620,_4026626):-hnf('Prelude._def\'23\'3C\'2A\'23Prelude.Applicative'(partcall(1,'Data.Functor.Compose._inst\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23',[_4026360,_4026342])),_4026614,_4026620,_4026626).

'Data.Functor.Compose._impl\'23liftA2\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4032488,_4032490,_4032492,_4032494,_4032496,_4032498,_4032500,_4032502):-freeze(_4032500,'blocked_Data.Functor.Compose._impl\'23liftA2\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4032488,_4032490,_4032492,_4032494,_4032496,_4032498,_4032500,_4032502)).
'blocked_Data.Functor.Compose._impl\'23liftA2\'23Prelude.Applicative\'23Data.Functor.Compose.Compose\'230\'23\'231\'23\'23'(_4032614,_4032632,_4032650,_4032668,_4032686,_4033486,_4033492,_4033498):-hnf('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.liftA2'(_4032614),'Prelude.apply'('Prelude.liftA2'(_4032632),_4032650)),_4032668),_4032686),_4033486,_4033492,_4033498).

'Data.Functor.Compose.getCompose'(_4037582,_4037584,_4037586,_4037588):-freeze(_4037586,'blocked_Data.Functor.Compose.getCompose'(_4037582,_4037584,_4037586,_4037588)).
'blocked_Data.Functor.Compose.getCompose'(_4037668,_4037684,_4037690,_4037696):-hnf(_4037668,_4037684,_4037690,_4037696).

:-costCenters(['']).




%%%%% Number of shared variables: 4

