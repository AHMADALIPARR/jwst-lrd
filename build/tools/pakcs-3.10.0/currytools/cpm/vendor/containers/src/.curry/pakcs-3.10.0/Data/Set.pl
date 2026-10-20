%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Data.Map').
:-importModule('Prelude').

:-curryModule('Data.Set').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Set.empty',empty,0,'Data.Set.empty',nofix,notype).
functiontype('Data.Set.singleton',singleton,1,'Data.Set.singleton',nofix,notype).
functiontype('Data.Set.fromList',fromList,2,'Data.Set.fromList',nofix,notype).
functiontype('Data.Set.fromList._\'23lambda1','Data.Set.fromList._#lambda1',1,'Data.Set.fromList._\'23lambda1',nofix,notype).
functiontype('Data.Set.null',null,0,'Data.Set.null',nofix,notype).
functiontype('Data.Set.insert',insert,3,'Data.Set.insert',nofix,notype).
functiontype('Data.Set.delete',delete,3,'Data.Set.delete',nofix,notype).
functiontype('Data.Set.deleteAll',deleteAll,3,'Data.Set.deleteAll',nofix,notype).
functiontype('Data.Set.size',size,0,'Data.Set.size',nofix,notype).
functiontype('Data.Set.member',member,1,'Data.Set.member',nofix,notype).
functiontype('Data.Set.difference',difference,1,'Data.Set.difference',nofix,notype).
functiontype('Data.Set.toList',toList,0,'Data.Set.toList',nofix,notype).
functiontype('Data.Set.union',union,1,'Data.Set.union',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Set.empty'(_51501266,_51501268,_51501270):-freeze(_51501268,'blocked_Data.Set.empty'(_51501266,_51501268,_51501270)).
'blocked_Data.Set.empty'(_51501354,_51501360,_51501366):-hnf('Data.Map.empty',_51501354,_51501360,_51501366).

'Data.Set.singleton'(_51502512,_51502514,_51502516,_51502518):-freeze(_51502516,'blocked_Data.Set.singleton'(_51502512,_51502514,_51502516,_51502518)).
'blocked_Data.Set.singleton'(_51502598,_51502782,_51502788,_51502794):-hnf('Data.Map.singleton'(_51502598,'Prelude.()'),_51502782,_51502788,_51502794).

'Data.Set.fromList'(_51504278,_51504280,_51504282,_51504284,_51504286):-freeze(_51504284,'blocked_Data.Set.fromList'(_51504278,_51504280,_51504282,_51504284,_51504286)).
'blocked_Data.Set.fromList'(_51504374,_51504392,_51504730,_51504736,_51504742):-hnf('Data.Map.fromList'(_51504374,'Prelude.map'(partcall(1,'Data.Set.fromList._\'23lambda1',[]),_51504392)),_51504730,_51504736,_51504742).

'Data.Set.fromList._\'23lambda1'(_51507102,_51507104,_51507106,_51507108):-freeze(_51507106,'blocked_Data.Set.fromList._\'23lambda1'(_51507102,_51507104,_51507106,_51507108)).
'blocked_Data.Set.fromList._\'23lambda1'(_51507188,'Prelude.(,)'(_51507188,'Prelude.()'),_51507378,_51507378).

'Data.Set.null'(_51508708,_51508710,_51508712):-freeze(_51508710,'blocked_Data.Set.null'(_51508708,_51508710,_51508712)).
'blocked_Data.Set.null'(_51508796,_51508802,_51508808):-hnf(partcall(1,'Data.Map.null',[]),_51508796,_51508802,_51508808).

'Data.Set.insert'(_51509832,_51509834,_51509836,_51509838,_51509840,_51509842):-freeze(_51509840,'blocked_Data.Set.insert'(_51509832,_51509834,_51509836,_51509838,_51509840,_51509842)).
'blocked_Data.Set.insert'(_51509938,_51509956,_51509974,_51510298,_51510304,_51510310):-hnf('Data.Map.insert'(_51509938,_51509956,'Prelude.()',_51509974),_51510298,_51510304,_51510310).

'Data.Set.delete'(_51512050,_51512052,_51512054,_51512056,_51512058,_51512060):-freeze(_51512058,'blocked_Data.Set.delete'(_51512050,_51512052,_51512054,_51512056,_51512058,_51512060)).
'blocked_Data.Set.delete'(_51512156,_51512174,_51512192,_51512432,_51512438,_51512444):-hnf('Data.Map.delete'(_51512156,_51512174,_51512192),_51512432,_51512438,_51512444).

'Data.Set.deleteAll'(_51514138,_51514140,_51514142,_51514144,_51514146,_51514148):-freeze(_51514146,'blocked_Data.Set.deleteAll'(_51514138,_51514140,_51514142,_51514144,_51514146,_51514148)).
'blocked_Data.Set.deleteAll'(_51514244,_51514262,_51514280,_51514520,_51514526,_51514532):-hnf('Data.Map.deleteAll'(_51514244,_51514262,_51514280),_51514520,_51514526,_51514532).

'Data.Set.size'(_51516072,_51516074,_51516076):-freeze(_51516074,'blocked_Data.Set.size'(_51516072,_51516074,_51516076)).
'blocked_Data.Set.size'(_51516160,_51516166,_51516172):-hnf(partcall(1,'Data.Map.size',[]),_51516160,_51516166,_51516172).

'Data.Set.member'(_51517196,_51517198,_51517200,_51517202):-freeze(_51517200,'blocked_Data.Set.member'(_51517196,_51517198,_51517200,_51517202)).
'blocked_Data.Set.member'(_51517282,_51517382,_51517388,_51517394):-hnf(partcall(2,'Data.Map.member',[_51517282]),_51517382,_51517388,_51517394).

'Data.Set.difference'(_51518764,_51518766,_51518768,_51518770):-freeze(_51518768,'blocked_Data.Set.difference'(_51518764,_51518766,_51518768,_51518770)).
'blocked_Data.Set.difference'(_51518850,_51518950,_51518956,_51518962):-hnf(partcall(2,'Data.Map.difference',[_51518850]),_51518950,_51518956,_51518962).

'Data.Set.toList'(_51520228,_51520230,_51520232):-freeze(_51520230,'blocked_Data.Set.toList'(_51520228,_51520230,_51520232)).
'blocked_Data.Set.toList'(_51520316,_51520322,_51520328):-hnf(partcall(1,'Data.Map.keys',[]),_51520316,_51520322,_51520328).

'Data.Set.union'(_51521326,_51521328,_51521330,_51521332):-freeze(_51521330,'blocked_Data.Set.union'(_51521326,_51521328,_51521330,_51521332)).
'blocked_Data.Set.union'(_51521412,_51521512,_51521518,_51521524):-hnf(partcall(2,'Data.Map.union',[_51521412]),_51521512,_51521518,_51521524).

:-costCenters(['']).




%%%%% Number of shared variables: 0

