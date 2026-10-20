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
'Data.Set.empty'(_7732250,_7732252,_7732254):-freeze(_7732252,'blocked_Data.Set.empty'(_7732250,_7732252,_7732254)).
'blocked_Data.Set.empty'(_7732338,_7732344,_7732350):-hnf('Data.Map.empty',_7732338,_7732344,_7732350).

'Data.Set.singleton'(_7733496,_7733498,_7733500,_7733502):-freeze(_7733500,'blocked_Data.Set.singleton'(_7733496,_7733498,_7733500,_7733502)).
'blocked_Data.Set.singleton'(_7733582,_7733766,_7733772,_7733778):-hnf('Data.Map.singleton'(_7733582,'Prelude.()'),_7733766,_7733772,_7733778).

'Data.Set.fromList'(_7735262,_7735264,_7735266,_7735268,_7735270):-freeze(_7735268,'blocked_Data.Set.fromList'(_7735262,_7735264,_7735266,_7735268,_7735270)).
'blocked_Data.Set.fromList'(_7735358,_7735376,_7735714,_7735720,_7735726):-hnf('Data.Map.fromList'(_7735358,'Prelude.map'(partcall(1,'Data.Set.fromList._\'23lambda1',[]),_7735376)),_7735714,_7735720,_7735726).

'Data.Set.fromList._\'23lambda1'(_7738086,_7738088,_7738090,_7738092):-freeze(_7738090,'blocked_Data.Set.fromList._\'23lambda1'(_7738086,_7738088,_7738090,_7738092)).
'blocked_Data.Set.fromList._\'23lambda1'(_7738172,'Prelude.(,)'(_7738172,'Prelude.()'),_7738362,_7738362).

'Data.Set.null'(_7739692,_7739694,_7739696):-freeze(_7739694,'blocked_Data.Set.null'(_7739692,_7739694,_7739696)).
'blocked_Data.Set.null'(_7739780,_7739786,_7739792):-hnf(partcall(1,'Data.Map.null',[]),_7739780,_7739786,_7739792).

'Data.Set.insert'(_7740816,_7740818,_7740820,_7740822,_7740824,_7740826):-freeze(_7740824,'blocked_Data.Set.insert'(_7740816,_7740818,_7740820,_7740822,_7740824,_7740826)).
'blocked_Data.Set.insert'(_7740922,_7740940,_7740958,_7741282,_7741288,_7741294):-hnf('Data.Map.insert'(_7740922,_7740940,'Prelude.()',_7740958),_7741282,_7741288,_7741294).

'Data.Set.delete'(_7743034,_7743036,_7743038,_7743040,_7743042,_7743044):-freeze(_7743042,'blocked_Data.Set.delete'(_7743034,_7743036,_7743038,_7743040,_7743042,_7743044)).
'blocked_Data.Set.delete'(_7743140,_7743158,_7743176,_7743416,_7743422,_7743428):-hnf('Data.Map.delete'(_7743140,_7743158,_7743176),_7743416,_7743422,_7743428).

'Data.Set.deleteAll'(_7745122,_7745124,_7745126,_7745128,_7745130,_7745132):-freeze(_7745130,'blocked_Data.Set.deleteAll'(_7745122,_7745124,_7745126,_7745128,_7745130,_7745132)).
'blocked_Data.Set.deleteAll'(_7745228,_7745246,_7745264,_7745504,_7745510,_7745516):-hnf('Data.Map.deleteAll'(_7745228,_7745246,_7745264),_7745504,_7745510,_7745516).

'Data.Set.size'(_7747056,_7747058,_7747060):-freeze(_7747058,'blocked_Data.Set.size'(_7747056,_7747058,_7747060)).
'blocked_Data.Set.size'(_7747144,_7747150,_7747156):-hnf(partcall(1,'Data.Map.size',[]),_7747144,_7747150,_7747156).

'Data.Set.member'(_7748180,_7748182,_7748184,_7748186):-freeze(_7748184,'blocked_Data.Set.member'(_7748180,_7748182,_7748184,_7748186)).
'blocked_Data.Set.member'(_7748266,_7748366,_7748372,_7748378):-hnf(partcall(2,'Data.Map.member',[_7748266]),_7748366,_7748372,_7748378).

'Data.Set.difference'(_7749748,_7749750,_7749752,_7749754):-freeze(_7749752,'blocked_Data.Set.difference'(_7749748,_7749750,_7749752,_7749754)).
'blocked_Data.Set.difference'(_7749834,_7749934,_7749940,_7749946):-hnf(partcall(2,'Data.Map.difference',[_7749834]),_7749934,_7749940,_7749946).

'Data.Set.toList'(_7751212,_7751214,_7751216):-freeze(_7751214,'blocked_Data.Set.toList'(_7751212,_7751214,_7751216)).
'blocked_Data.Set.toList'(_7751300,_7751306,_7751312):-hnf(partcall(1,'Data.Map.keys',[]),_7751300,_7751306,_7751312).

'Data.Set.union'(_7752310,_7752312,_7752314,_7752316):-freeze(_7752314,'blocked_Data.Set.union'(_7752310,_7752312,_7752314,_7752316)).
'blocked_Data.Set.union'(_7752396,_7752496,_7752502,_7752508):-hnf(partcall(2,'Data.Map.union',[_7752396]),_7752496,_7752502,_7752508).

:-costCenters(['']).




%%%%% Number of shared variables: 0

