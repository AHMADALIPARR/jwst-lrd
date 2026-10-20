%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.IORef').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23','_inst#Prelude.Data#Data.IORef.IORef#0##',2,'Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23',nofix,notype).
functiontype('Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23','_impl#===#Prelude.Data#Data.IORef.IORef#0##',3,'Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23',nofix,notype).
functiontype('Data.IORef._impl\'23aValue\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23','_impl#aValue#Prelude.Data#Data.IORef.IORef#0##',1,'Data.IORef._impl\'23aValue\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23',nofix,notype).
functiontype('Data.IORef.newIORef',newIORef,1,prim_newIORef,nofix,notype).
functiontype('Data.IORef.readIORef',readIORef,1,'Data.IORef.readIORef',nofix,notype).
functiontype('Data.IORef.prim_readIORef','Data.IORef.prim_readIORef',1,prim_readIORef,nofix,notype).
functiontype('Data.IORef.writeIORef',writeIORef,2,'Data.IORef.writeIORef',nofix,notype).
functiontype('Data.IORef.prim_writeIORef','Data.IORef.prim_writeIORef',2,prim_writeIORef,nofix,notype).
functiontype('Data.IORef.modifyIORef',modifyIORef,2,'Data.IORef.modifyIORef',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Data.IORef.IORef','Data.IORef.IORef',1,'IORef.IORef',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3513860,_3513862,_3513864,_3513866,_3513868):-freeze(_3513866,'blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3513860,_3513862,_3513864,_3513866,_3513868)).
'blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3513956,_3513974,_3514862,_3514868,_3514874):-hnf(_3513974,_3517408,_3514868,_3517426),'blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'(_3517408,_3513956,_3514862,_3517426,_3514874).

'blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'(_3518036,_3518038,_3518040,_3518042,_3518044):-freeze(_3518042,'blocked_blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'(_3518036,_3518038,_3518040,_3518042,_3518044)).
'blocked_blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'('Prelude.()',_3513956,'Prelude._Dict\'23Data'(partcall(2,'Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23',[_3518490]),'Data.IORef._impl\'23aValue\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3518490)),_3518398,_3518404):-!,makeShare(_3513956,_3518490),_3518398=_3518404.
'blocked_blocked_Data.IORef._inst\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'('FAIL'(_3520706),_3513956,'FAIL'(_3520706),_3520720,_3520720):-nonvar(_3520706).

'Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3523244,_3523246,_3523248,_3523250,_3523252,_3523254):-freeze(_3523252,'blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3523244,_3523246,_3523248,_3523250,_3523252,_3523254)).
'blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3523350,_3523368,_3523386,_3524568,_3524574,_3524580):-hnf(_3523368,_3527554,_3524574,_3527578),'blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'(_3527554,_3523350,_3523386,_3524568,_3527578,_3524580).

'blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'(_3528268,_3528270,_3528272,_3528274,_3528276,_3528278):-freeze(_3528276,'blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'(_3528268,_3528270,_3528272,_3528274,_3528276,_3528278)).
'blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'('Data.IORef.IORef'(_3523502),_3523350,_3523386,_3529310,_3529316,_3529322):-!,hnf(_3523386,_3533166,_3529316,_3533190),'blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2_Data.IORef.IORef_3'(_3533166,_3523502,_3523350,_3529310,_3533190,_3529322).

'blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2_Data.IORef.IORef_3'(_3534060,_3534062,_3534064,_3534066,_3534068,_3534070):-freeze(_3534068,'blocked_blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2_Data.IORef.IORef_3'(_3534060,_3534062,_3534064,_3534066,_3534068,_3534070)).
'blocked_blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2_Data.IORef.IORef_3'('Data.IORef.IORef'(_3523624),_3523502,_3523350,_3534516,_3534522,_3534528):-!,hnf('Prelude.apply'('Prelude.apply'('Prelude.==='(_3523350),_3523502),_3523624),_3534516,_3534522,_3534528).
'blocked_blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2_Data.IORef.IORef_3'('FAIL'(_3536432),_3523502,_3523350,'FAIL'(_3536432),_3536446,_3536446):-nonvar(_3536432).
'blocked_blocked_Data.IORef._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23_2'('FAIL'(_3536518),_3523350,_3523386,'FAIL'(_3536518),_3536532,_3536532):-nonvar(_3536518).

'Data.IORef._impl\'23aValue\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3539094,_3539096,_3539098,_3539100):-freeze(_3539098,'blocked_Data.IORef._impl\'23aValue\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3539094,_3539096,_3539098,_3539100)).
'blocked_Data.IORef._impl\'23aValue\'23Prelude.Data\'23Data.IORef.IORef\'230\'23\'23'(_3539180,'Data.IORef.IORef'('Prelude.aValue'(_3539180)),_3539370,_3539370).

'Data.IORef.readIORef'(_3541428,_3541430,_3541432,_3541434):-freeze(_3541432,'blocked_Data.IORef.readIORef'(_3541428,_3541430,_3541432,_3541434)).
'blocked_Data.IORef.readIORef'(_3541514,_3541698,_3541704,_3541710):-hnf('Prelude.$#'(partcall(1,'Data.IORef.prim_readIORef',[]),_3541514),_3541698,_3541704,_3541710).

'Data.IORef.writeIORef'(_3543626,_3543628,_3543630,_3543632,_3543634):-freeze(_3543632,'blocked_Data.IORef.writeIORef'(_3543626,_3543628,_3543630,_3543632,_3543634)).
'blocked_Data.IORef.writeIORef'(_3543722,_3543740,_3544078,_3544084,_3544090):-hnf('Prelude.apply'('Prelude.$#'(partcall(2,'Data.IORef.prim_writeIORef',[]),_3543722),_3543740),_3544078,_3544084,_3544090).

'Data.IORef.modifyIORef'(_3546428,_3546430,_3546432,_3546434,_3546436):-freeze(_3546434,'blocked_Data.IORef.modifyIORef'(_3546428,_3546430,_3546432,_3546434,_3546436)).
'blocked_Data.IORef.modifyIORef'(_3546524,_3546542,_3547202,_3547208,_3547214):-makeShare(_3546524,_3547332),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Data.IORef.readIORef'(_3547332)),'Prelude..'(partcall(1,'Data.IORef.writeIORef',[_3547332]),_3546542)),_3547202,_3547208,_3547214).

:-costCenters(['']).




%%%%% Number of shared variables: 2

:-style_check(-singleton).
prim_newIORef(_3549872,_3549874,_3549876,_3549878):-freeze(_3549876,blocked_prim_newIORef(_3549872,_3549874,_3549876,_3549878)).
blocked_prim_newIORef(_3549950,partcall(1,exec_newIORef,[_3549950]),_3549968,_3549968).
exec_newIORef(_3550282,_3550284,_3550286,_3550288,_3550290):-freeze(_3550288,blocked_exec_newIORef(_3550282,_3550284,_3550286,_3550288,_3550290)).
blocked_exec_newIORef(_3550380,_3550382,'$io'('IOExts.IORef'(share(_3550368))),_3550386,_3550388):-var(_3550380),!,create_mutable('$eval'(_3550380),_3550368),_3550386=_3550388.
blocked_exec_newIORef(_3550516,_3550518,'$io'('IOExts.IORef'(share(_3550504))),_3550522,_3550524):-create_mutable(_3550516,_3550504),_3550522=_3550524.
prim_readIORef(_3550878,_3550880,_3550882,_3550884):-freeze(_3550882,blocked_prim_readIORef(_3550878,_3550880,_3550882,_3550884)).
blocked_prim_readIORef(_3550956,partcall(1,exec_readIORef,[_3550956]),_3550974,_3550974).
exec_readIORef(_3551294,_3551296,_3551298,_3551300,_3551302):-freeze(_3551300,blocked_exec_readIORef(_3551294,_3551296,_3551298,_3551300,_3551302)).
blocked_exec_readIORef(_3551384,_3551386,'$io'(_3551380),_3551390,_3551392):-user:derefRoot(_3551384,'IOExts.IORef'(share(_3551396))),get_mutable(_3551416,_3551396),(_3551416='$eval'(_3551380)->true;create_mutable(_3551416,_3551440),update_mutable(share(_3551440),_3551396),_3551380=share(_3551440)),_3551390=_3551392.
prim_writeIORef(_3551846,_3551848,_3551850,_3551852,_3551854):-freeze(_3551852,blocked_prim_writeIORef(_3551846,_3551848,_3551850,_3551852,_3551854)).
blocked_prim_writeIORef(_3551940,_3551934,partcall(1,exec_writeIORef,[_3551934,_3551940]),_3551960,_3551960).
exec_writeIORef(_3552296,_3552298,_3552300,_3552302,_3552304,_3552306):-freeze(_3552304,blocked_exec_writeIORef(_3552296,_3552298,_3552300,_3552302,_3552304,_3552306)).
blocked_exec_writeIORef(_3552392,_3552394,_3552396,_3552398,_3552400,_3552402):-user:derefRoot(_3552392,_3552408),prim_writeIORef_exec(_3552408,_3552394,_3552398),_3552400=_3552402.
prim_writeIORef_exec('IOExts.IORef'(share(_3552526)),_3552540,'$io'('Prelude.()')):-var(_3552540),!,update_mutable('$eval'(_3552540),_3552526).
prim_writeIORef_exec('IOExts.IORef'(share(_3552630)),_3552644,'$io'('Prelude.()')):-update_mutable(_3552644,_3552630).
