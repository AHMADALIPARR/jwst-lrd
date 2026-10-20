%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('CASS.ServerFormats').
:-importModule('Data.Char').
:-importModule('Numeric').
:-importModule('Prelude').
:-importModule('System.Console.GetOpt').

:-curryModule('CASS.Options').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23','_inst#Prelude.Data#CASS.Options.Options#',1,'CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23',nofix,notype).
functiontype('CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23','_impl#===#Prelude.Data#CASS.Options.Options#',2,'CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23',nofix,notype).
functiontype('CASS.Options._impl\'23aValue\'23Prelude.Data\'23CASS.Options.Options\'23','_impl#aValue#Prelude.Data#CASS.Options.Options#',0,'CASS.Options._impl\'23aValue\'23Prelude.Data\'23CASS.Options.Options\'23',nofix,notype).
functiontype('CASS.Options.optHelp',optHelp,1,'CASS.Options.optHelp',nofix,notype).
functiontype('CASS.Options.optVerb',optVerb,1,'CASS.Options.optVerb',nofix,notype).
functiontype('CASS.Options.optServer',optServer,1,'CASS.Options.optServer',nofix,notype).
functiontype('CASS.Options.optWorker',optWorker,1,'CASS.Options.optWorker',nofix,notype).
functiontype('CASS.Options.optPort',optPort,1,'CASS.Options.optPort',nofix,notype).
functiontype('CASS.Options.optAll',optAll,1,'CASS.Options.optAll',nofix,notype).
functiontype('CASS.Options.optGenerated',optGenerated,1,'CASS.Options.optGenerated',nofix,notype).
functiontype('CASS.Options.optFormat',optFormat,1,'CASS.Options.optFormat',nofix,notype).
functiontype('CASS.Options.optReAna',optReAna,1,'CASS.Options.optReAna',nofix,notype).
functiontype('CASS.Options.optStats',optStats,1,'CASS.Options.optStats',nofix,notype).
functiontype('CASS.Options.optDelete',optDelete,1,'CASS.Options.optDelete',nofix,notype).
functiontype('CASS.Options.optNoCurryInfo',optNoCurryInfo,1,'CASS.Options.optNoCurryInfo',nofix,notype).
functiontype('CASS.Options.optProp',optProp,1,'CASS.Options.optProp',nofix,notype).
functiontype('CASS.Options.defaultOptions',defaultOptions,0,'CASS.Options.defaultOptions',nofix,notype).
functiontype('CASS.Options.options',options,0,'CASS.Options.options',nofix,notype).
functiontype('CASS.Options.options.safeReadNat.4','CASS.Options.options.safeReadNat.4',3,'CASS.Options.options.safeReadNat.4',nofix,notype).
functiontype('CASS.Options.options.checkVerb.4','CASS.Options.options.checkVerb.4',2,'CASS.Options.options.checkVerb.4',nofix,notype).
functiontype('CASS.Options.options.checkFormat.4','CASS.Options.options.checkFormat.4',2,'CASS.Options.options.checkFormat.4',nofix,notype).
functiontype('CASS.Options.options.checkFormat.4._\'23lambda185','CASS.Options.options.checkFormat.4._#lambda185',2,'CASS.Options.options.checkFormat.4._\'23lambda185',nofix,notype).
functiontype('CASS.Options.options.checkSetProperty.4','CASS.Options.options.checkSetProperty.4',2,'CASS.Options.options.checkSetProperty.4',nofix,notype).
functiontype('CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key','CASS.Options.options.checkSetProperty.4._#selFP2#key',1,'CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key',nofix,notype).
functiontype('CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue','CASS.Options.options.checkSetProperty.4._#selFP3#eqvalue',1,'CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue',nofix,notype).
functiontype('CASS.Options.options._\'23lambda214','CASS.Options.options._#lambda214',1,'CASS.Options.options._\'23lambda214',nofix,notype).
functiontype('CASS.Options.options._\'23lambda229','CASS.Options.options._#lambda229',1,'CASS.Options.options._\'23lambda229',nofix,notype).
functiontype('CASS.Options.options._\'23lambda244','CASS.Options.options._#lambda244',1,'CASS.Options.options._\'23lambda244',nofix,notype).
functiontype('CASS.Options.options._\'23lambda259','CASS.Options.options._#lambda259',1,'CASS.Options.options._\'23lambda259',nofix,notype).
functiontype('CASS.Options.options._\'23lambda274','CASS.Options.options._#lambda274',1,'CASS.Options.options._\'23lambda274',nofix,notype).
functiontype('CASS.Options.options._\'23lambda289','CASS.Options.options._#lambda289',1,'CASS.Options.options._\'23lambda289',nofix,notype).
functiontype('CASS.Options.options._\'23lambda304','CASS.Options.options._#lambda304',1,'CASS.Options.options._\'23lambda304',nofix,notype).
functiontype('CASS.Options.options._\'23lambda319','CASS.Options.options._#lambda319',1,'CASS.Options.options._\'23lambda319',nofix,notype).
functiontype('CASS.Options.options._\'23lambda334','CASS.Options.options._#lambda334',2,'CASS.Options.options._\'23lambda334',nofix,notype).
functiontype('CASS.Options.options._\'23lambda349','CASS.Options.options._#lambda349',1,'CASS.Options.options._\'23lambda349',nofix,notype).
functiontype('CASS.Options.options._\'23lambda364','CASS.Options.options._#lambda364',1,'CASS.Options.options._\'23lambda364',nofix,notype).
functiontype('CASS.Options.options._\'23lambda379','CASS.Options.options._#lambda379',1,'CASS.Options.options._\'23lambda379',nofix,notype).
functiontype('CASS.Options.options._\'23lambda394','CASS.Options.options._#lambda394',2,'CASS.Options.options._\'23lambda394',nofix,notype).
functiontype('CASS.Options.options.checkSetProperty.4._\'23caseor0','CASS.Options.options.checkSetProperty.4._#caseor0',4,'CASS.Options.options.checkSetProperty.4._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('CASS.Options.Options','Options',13,'Options.Options',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23'(_18936168,_18936170,_18936172,_18936174):-freeze(_18936172,'blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23'(_18936168,_18936170,_18936172,_18936174)).
'blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23'(_18936254,_18936988,_18936994,_18937000):-hnf(_18936254,_18939490,_18936994,_18939502),'blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23_1'(_18939490,_18936988,_18939502,_18937000).

'blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23_1'(_18940098,_18940100,_18940102,_18940104):-freeze(_18940102,'blocked_blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23_1'(_18940098,_18940100,_18940102,_18940104)).
'blocked_blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23',[]),'CASS.Options._impl\'23aValue\'23Prelude.Data\'23CASS.Options.Options\'23'),_18940450,_18940450):-!.
'blocked_blocked_CASS.Options._inst\'23Prelude.Data\'23CASS.Options.Options\'23_1'('FAIL'(_18942218),'FAIL'(_18942218),_18942232,_18942232):-nonvar(_18942218).

'CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23'(_18944806,_18944808,_18944810,_18944812,_18944814):-freeze(_18944812,'blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23'(_18944806,_18944808,_18944810,_18944812,_18944814)).
'blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23'(_18944902,_18944920,_18951046,_18951052,_18951058):-hnf(_18944902,_18953988,_18951052,_18954006),'blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1'(_18953988,_18944920,_18951046,_18954006,_18951058).

'blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1'(_18954682,_18954684,_18954686,_18954688,_18954690):-freeze(_18954688,'blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1'(_18954682,_18954684,_18954686,_18954688,_18954690)).
'blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1'('CASS.Options.Options'(_18945036,_18945054,_18945072,_18945090,_18945108,_18945126,_18945144,_18945162,_18945180,_18945198,_18945216,_18945234,_18945252),_18944920,_18955946,_18955952,_18955958):-!,hnf(_18944920,_18959884,_18955952,_18959974),'blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1_CASS.Options.Options_14'(_18959884,_18945036,_18945054,_18945072,_18945090,_18945108,_18945126,_18945144,_18945162,_18945180,_18945198,_18945216,_18945234,_18945252,_18955946,_18959974,_18955958).

'blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1_CASS.Options.Options_14'(_18960956,_18960958,_18960960,_18960962,_18960964,_18960966,_18960968,_18960970,_18960972,_18960974,_18960976,_18960978,_18960980,_18960982,_18960984,_18960986,_18960988):-freeze(_18960986,'blocked_blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1_CASS.Options.Options_14'(_18960956,_18960958,_18960960,_18960962,_18960964,_18960966,_18960968,_18960970,_18960972,_18960974,_18960976,_18960978,_18960980,_18960982,_18960984,_18960986,_18960988)).
'blocked_blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1_CASS.Options.Options_14'('CASS.Options.Options'(_18945446,_18945464,_18945482,_18945500,_18945518,_18945536,_18945554,_18945572,_18945590,_18945608,_18945626,_18945644,_18945662),_18945036,_18945054,_18945072,_18945090,_18945108,_18945126,_18945144,_18945162,_18945180,_18945198,_18945216,_18945234,_18945252,_18961666,_18961672,_18961678):-!,hnf('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945036,_18945446),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_18945054),_18945464)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945072,_18945482)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945090,_18945500)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_18945108),_18945518)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945126,_18945536)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945144,_18945554)),'CASS.ServerFormats._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.ServerFormats.OutputFormat\'23'(_18945162,_18945572)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945180,_18945590)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945198,_18945608)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Bool\'23'(_18945216,_18945626)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),_18945234,_18945644)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])]),_18945252,_18945662)),_18961666,_18961672,_18961678).
'blocked_blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1_CASS.Options.Options_14'('FAIL'(_18983138),_18945036,_18945054,_18945072,_18945090,_18945108,_18945126,_18945144,_18945162,_18945180,_18945198,_18945216,_18945234,_18945252,'FAIL'(_18983138),_18983152,_18983152):-nonvar(_18983138).
'blocked_blocked_CASS.Options._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CASS.Options.Options\'23_1'('FAIL'(_18983312),_18944920,'FAIL'(_18983312),_18983326,_18983326):-nonvar(_18983312).

'CASS.Options._impl\'23aValue\'23Prelude.Data\'23CASS.Options.Options\'23'(_18985938,_18985940,_18985942):-freeze(_18985940,'blocked_CASS.Options._impl\'23aValue\'23Prelude.Data\'23CASS.Options.Options\'23'(_18985938,_18985940,_18985942)).
'blocked_CASS.Options._impl\'23aValue\'23Prelude.Data\'23CASS.Options.Options\'23'('CASS.Options.Options'('Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','CASS.ServerFormats._impl\'23aValue\'23Prelude.Data\'23CASS.ServerFormats.OutputFormat\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Bool\'23','Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])),'Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])]))),_18987712,_18987712).

'CASS.Options.optHelp'(_18998058,_18998060,_18998062,_18998064):-freeze(_18998062,'blocked_CASS.Options.optHelp'(_18998058,_18998060,_18998062,_18998064)).
'blocked_CASS.Options.optHelp'(_18998144,_18998774,_18998780,_18998786):-hnf(_18998144,_18999872,_18998780,_18999884),'blocked_CASS.Options.optHelp_1'(_18999872,_18998774,_18999884,_18998786).

'blocked_CASS.Options.optHelp_1'(_19000246,_19000248,_19000250,_19000252):-freeze(_19000250,'blocked_blocked_CASS.Options.optHelp_1'(_19000246,_19000248,_19000250,_19000252)).
'blocked_blocked_CASS.Options.optHelp_1'('CASS.Options.Options'(_18998260,_18998278,_18998296,_18998314,_18998332,_18998350,_18998368,_18998386,_18998404,_18998422,_18998440,_18998458,_18998476),_19000826,_19000832,_19000838):-!,hnf(_18998260,_19000826,_19000832,_19000838).
'blocked_blocked_CASS.Options.optHelp_1'('FAIL'(_19002052),'FAIL'(_19002052),_19002066,_19002066):-nonvar(_19002052).

'CASS.Options.optVerb'(_19003010,_19003012,_19003014,_19003016):-freeze(_19003014,'blocked_CASS.Options.optVerb'(_19003010,_19003012,_19003014,_19003016)).
'blocked_CASS.Options.optVerb'(_19003096,_19003726,_19003732,_19003738):-hnf(_19003096,_19004824,_19003732,_19004836),'blocked_CASS.Options.optVerb_1'(_19004824,_19003726,_19004836,_19003738).

'blocked_CASS.Options.optVerb_1'(_19005198,_19005200,_19005202,_19005204):-freeze(_19005202,'blocked_blocked_CASS.Options.optVerb_1'(_19005198,_19005200,_19005202,_19005204)).
'blocked_blocked_CASS.Options.optVerb_1'('CASS.Options.Options'(_19003212,_19003230,_19003248,_19003266,_19003284,_19003302,_19003320,_19003338,_19003356,_19003374,_19003392,_19003410,_19003428),_19005778,_19005784,_19005790):-!,hnf(_19003230,_19005778,_19005784,_19005790).
'blocked_blocked_CASS.Options.optVerb_1'('FAIL'(_19007004),'FAIL'(_19007004),_19007018,_19007018):-nonvar(_19007004).

'CASS.Options.optServer'(_19008038,_19008040,_19008042,_19008044):-freeze(_19008042,'blocked_CASS.Options.optServer'(_19008038,_19008040,_19008042,_19008044)).
'blocked_CASS.Options.optServer'(_19008124,_19008766,_19008772,_19008778):-hnf(_19008124,_19009936,_19008772,_19009948),'blocked_CASS.Options.optServer_1'(_19009936,_19008766,_19009948,_19008778).

'blocked_CASS.Options.optServer_1'(_19010322,_19010324,_19010326,_19010328):-freeze(_19010326,'blocked_blocked_CASS.Options.optServer_1'(_19010322,_19010324,_19010326,_19010328)).
'blocked_blocked_CASS.Options.optServer_1'('CASS.Options.Options'(_19008240,_19008258,_19008276,_19008294,_19008312,_19008330,_19008348,_19008366,_19008384,_19008402,_19008420,_19008438,_19008456),_19010902,_19010908,_19010914):-!,hnf(_19008276,_19010902,_19010908,_19010914).
'blocked_blocked_CASS.Options.optServer_1'('FAIL'(_19012140),'FAIL'(_19012140),_19012154,_19012154):-nonvar(_19012140).

'CASS.Options.optWorker'(_19013174,_19013176,_19013178,_19013180):-freeze(_19013178,'blocked_CASS.Options.optWorker'(_19013174,_19013176,_19013178,_19013180)).
'blocked_CASS.Options.optWorker'(_19013260,_19013902,_19013908,_19013914):-hnf(_19013260,_19015072,_19013908,_19015084),'blocked_CASS.Options.optWorker_1'(_19015072,_19013902,_19015084,_19013914).

'blocked_CASS.Options.optWorker_1'(_19015458,_19015460,_19015462,_19015464):-freeze(_19015462,'blocked_blocked_CASS.Options.optWorker_1'(_19015458,_19015460,_19015462,_19015464)).
'blocked_blocked_CASS.Options.optWorker_1'('CASS.Options.Options'(_19013376,_19013394,_19013412,_19013430,_19013448,_19013466,_19013484,_19013502,_19013520,_19013538,_19013556,_19013574,_19013592),_19016038,_19016044,_19016050):-!,hnf(_19013430,_19016038,_19016044,_19016050).
'blocked_blocked_CASS.Options.optWorker_1'('FAIL'(_19017276),'FAIL'(_19017276),_19017290,_19017290):-nonvar(_19017276).

'CASS.Options.optPort'(_19018234,_19018236,_19018238,_19018240):-freeze(_19018238,'blocked_CASS.Options.optPort'(_19018234,_19018236,_19018238,_19018240)).
'blocked_CASS.Options.optPort'(_19018320,_19018950,_19018956,_19018962):-hnf(_19018320,_19020048,_19018956,_19020060),'blocked_CASS.Options.optPort_1'(_19020048,_19018950,_19020060,_19018962).

'blocked_CASS.Options.optPort_1'(_19020422,_19020424,_19020426,_19020428):-freeze(_19020426,'blocked_blocked_CASS.Options.optPort_1'(_19020422,_19020424,_19020426,_19020428)).
'blocked_blocked_CASS.Options.optPort_1'('CASS.Options.Options'(_19018436,_19018454,_19018472,_19018490,_19018508,_19018526,_19018544,_19018562,_19018580,_19018598,_19018616,_19018634,_19018652),_19021002,_19021008,_19021014):-!,hnf(_19018508,_19021002,_19021008,_19021014).
'blocked_blocked_CASS.Options.optPort_1'('FAIL'(_19022228),'FAIL'(_19022228),_19022242,_19022242):-nonvar(_19022228).

'CASS.Options.optAll'(_19023148,_19023150,_19023152,_19023154):-freeze(_19023152,'blocked_CASS.Options.optAll'(_19023148,_19023150,_19023152,_19023154)).
'blocked_CASS.Options.optAll'(_19023234,_19023858,_19023864,_19023870):-hnf(_19023234,_19024920,_19023864,_19024932),'blocked_CASS.Options.optAll_1'(_19024920,_19023858,_19024932,_19023870).

'blocked_CASS.Options.optAll_1'(_19025288,_19025290,_19025292,_19025294):-freeze(_19025292,'blocked_blocked_CASS.Options.optAll_1'(_19025288,_19025290,_19025292,_19025294)).
'blocked_blocked_CASS.Options.optAll_1'('CASS.Options.Options'(_19023350,_19023368,_19023386,_19023404,_19023422,_19023440,_19023458,_19023476,_19023494,_19023512,_19023530,_19023548,_19023566),_19025868,_19025874,_19025880):-!,hnf(_19023440,_19025868,_19025874,_19025880).
'blocked_blocked_CASS.Options.optAll_1'('FAIL'(_19027088),'FAIL'(_19027088),_19027102,_19027102):-nonvar(_19027088).

'CASS.Options.optGenerated'(_19028236,_19028238,_19028240,_19028242):-freeze(_19028240,'blocked_CASS.Options.optGenerated'(_19028236,_19028238,_19028240,_19028242)).
'blocked_CASS.Options.optGenerated'(_19028322,_19028982,_19028988,_19028994):-hnf(_19028322,_19030260,_19028988,_19030272),'blocked_CASS.Options.optGenerated_1'(_19030260,_19028982,_19030272,_19028994).

'blocked_CASS.Options.optGenerated_1'(_19030664,_19030666,_19030668,_19030670):-freeze(_19030668,'blocked_blocked_CASS.Options.optGenerated_1'(_19030664,_19030666,_19030668,_19030670)).
'blocked_blocked_CASS.Options.optGenerated_1'('CASS.Options.Options'(_19028438,_19028456,_19028474,_19028492,_19028510,_19028528,_19028546,_19028564,_19028582,_19028600,_19028618,_19028636,_19028654),_19031244,_19031250,_19031256):-!,hnf(_19028546,_19031244,_19031250,_19031256).
'blocked_blocked_CASS.Options.optGenerated_1'('FAIL'(_19032500),'FAIL'(_19032500),_19032514,_19032514):-nonvar(_19032500).

'CASS.Options.optFormat'(_19033534,_19033536,_19033538,_19033540):-freeze(_19033538,'blocked_CASS.Options.optFormat'(_19033534,_19033536,_19033538,_19033540)).
'blocked_CASS.Options.optFormat'(_19033620,_19034262,_19034268,_19034274):-hnf(_19033620,_19035432,_19034268,_19035444),'blocked_CASS.Options.optFormat_1'(_19035432,_19034262,_19035444,_19034274).

'blocked_CASS.Options.optFormat_1'(_19035818,_19035820,_19035822,_19035824):-freeze(_19035822,'blocked_blocked_CASS.Options.optFormat_1'(_19035818,_19035820,_19035822,_19035824)).
'blocked_blocked_CASS.Options.optFormat_1'('CASS.Options.Options'(_19033736,_19033754,_19033772,_19033790,_19033808,_19033826,_19033844,_19033862,_19033880,_19033898,_19033916,_19033934,_19033952),_19036398,_19036404,_19036410):-!,hnf(_19033862,_19036398,_19036404,_19036410).
'blocked_blocked_CASS.Options.optFormat_1'('FAIL'(_19037636),'FAIL'(_19037636),_19037650,_19037650):-nonvar(_19037636).

'CASS.Options.optReAna'(_19038632,_19038634,_19038636,_19038638):-freeze(_19038636,'blocked_CASS.Options.optReAna'(_19038632,_19038634,_19038636,_19038638)).
'blocked_CASS.Options.optReAna'(_19038718,_19039354,_19039360,_19039366):-hnf(_19038718,_19040488,_19039360,_19040500),'blocked_CASS.Options.optReAna_1'(_19040488,_19039354,_19040500,_19039366).

'blocked_CASS.Options.optReAna_1'(_19040868,_19040870,_19040872,_19040874):-freeze(_19040872,'blocked_blocked_CASS.Options.optReAna_1'(_19040868,_19040870,_19040872,_19040874)).
'blocked_blocked_CASS.Options.optReAna_1'('CASS.Options.Options'(_19038834,_19038852,_19038870,_19038888,_19038906,_19038924,_19038942,_19038960,_19038978,_19038996,_19039014,_19039032,_19039050),_19041448,_19041454,_19041460):-!,hnf(_19038978,_19041448,_19041454,_19041460).
'blocked_blocked_CASS.Options.optReAna_1'('FAIL'(_19042680),'FAIL'(_19042680),_19042694,_19042694):-nonvar(_19042680).

'CASS.Options.optStats'(_19043676,_19043678,_19043680,_19043682):-freeze(_19043680,'blocked_CASS.Options.optStats'(_19043676,_19043678,_19043680,_19043682)).
'blocked_CASS.Options.optStats'(_19043762,_19044398,_19044404,_19044410):-hnf(_19043762,_19045532,_19044404,_19045544),'blocked_CASS.Options.optStats_1'(_19045532,_19044398,_19045544,_19044410).

'blocked_CASS.Options.optStats_1'(_19045912,_19045914,_19045916,_19045918):-freeze(_19045916,'blocked_blocked_CASS.Options.optStats_1'(_19045912,_19045914,_19045916,_19045918)).
'blocked_blocked_CASS.Options.optStats_1'('CASS.Options.Options'(_19043878,_19043896,_19043914,_19043932,_19043950,_19043968,_19043986,_19044004,_19044022,_19044040,_19044058,_19044076,_19044094),_19046492,_19046498,_19046504):-!,hnf(_19044040,_19046492,_19046498,_19046504).
'blocked_blocked_CASS.Options.optStats_1'('FAIL'(_19047724),'FAIL'(_19047724),_19047738,_19047738):-nonvar(_19047724).

'CASS.Options.optDelete'(_19048758,_19048760,_19048762,_19048764):-freeze(_19048762,'blocked_CASS.Options.optDelete'(_19048758,_19048760,_19048762,_19048764)).
'blocked_CASS.Options.optDelete'(_19048844,_19049486,_19049492,_19049498):-hnf(_19048844,_19050656,_19049492,_19050668),'blocked_CASS.Options.optDelete_1'(_19050656,_19049486,_19050668,_19049498).

'blocked_CASS.Options.optDelete_1'(_19051042,_19051044,_19051046,_19051048):-freeze(_19051046,'blocked_blocked_CASS.Options.optDelete_1'(_19051042,_19051044,_19051046,_19051048)).
'blocked_blocked_CASS.Options.optDelete_1'('CASS.Options.Options'(_19048960,_19048978,_19048996,_19049014,_19049032,_19049050,_19049068,_19049086,_19049104,_19049122,_19049140,_19049158,_19049176),_19051622,_19051628,_19051634):-!,hnf(_19049140,_19051622,_19051628,_19051634).
'blocked_blocked_CASS.Options.optDelete_1'('FAIL'(_19052860),'FAIL'(_19052860),_19052874,_19052874):-nonvar(_19052860).

'CASS.Options.optNoCurryInfo'(_19054084,_19054086,_19054088,_19054090):-freeze(_19054088,'blocked_CASS.Options.optNoCurryInfo'(_19054084,_19054086,_19054088,_19054090)).
'blocked_CASS.Options.optNoCurryInfo'(_19054170,_19054842,_19054848,_19054854):-hnf(_19054170,_19056192,_19054848,_19056204),'blocked_CASS.Options.optNoCurryInfo_1'(_19056192,_19054842,_19056204,_19054854).

'blocked_CASS.Options.optNoCurryInfo_1'(_19056608,_19056610,_19056612,_19056614):-freeze(_19056612,'blocked_blocked_CASS.Options.optNoCurryInfo_1'(_19056608,_19056610,_19056612,_19056614)).
'blocked_blocked_CASS.Options.optNoCurryInfo_1'('CASS.Options.Options'(_19054286,_19054304,_19054322,_19054340,_19054358,_19054376,_19054394,_19054412,_19054430,_19054448,_19054466,_19054484,_19054502),_19057188,_19057194,_19057200):-!,hnf(_19054484,_19057188,_19057194,_19057200).
'blocked_blocked_CASS.Options.optNoCurryInfo_1'('FAIL'(_19058456),'FAIL'(_19058456),_19058470,_19058470):-nonvar(_19058456).

'CASS.Options.optProp'(_19059414,_19059416,_19059418,_19059420):-freeze(_19059418,'blocked_CASS.Options.optProp'(_19059414,_19059416,_19059418,_19059420)).
'blocked_CASS.Options.optProp'(_19059500,_19060130,_19060136,_19060142):-hnf(_19059500,_19061228,_19060136,_19061240),'blocked_CASS.Options.optProp_1'(_19061228,_19060130,_19061240,_19060142).

'blocked_CASS.Options.optProp_1'(_19061602,_19061604,_19061606,_19061608):-freeze(_19061606,'blocked_blocked_CASS.Options.optProp_1'(_19061602,_19061604,_19061606,_19061608)).
'blocked_blocked_CASS.Options.optProp_1'('CASS.Options.Options'(_19059616,_19059634,_19059652,_19059670,_19059688,_19059706,_19059724,_19059742,_19059760,_19059778,_19059796,_19059814,_19059832),_19062182,_19062188,_19062194):-!,hnf(_19059832,_19062182,_19062188,_19062194).
'blocked_blocked_CASS.Options.optProp_1'('FAIL'(_19063408),'FAIL'(_19063408),_19063422,_19063422):-nonvar(_19063408).

'CASS.Options.defaultOptions'(_19064632,_19064634,_19064636):-freeze(_19064634,'blocked_CASS.Options.defaultOptions'(_19064632,_19064634,_19064636)).
'blocked_CASS.Options.defaultOptions'('CASS.Options.Options'('Prelude.False','Prelude._impl\'23negate\'23Prelude.Num\'23Prelude.Int\'23'(1),'Prelude.False','Prelude.False',0,'Prelude.False','Prelude.True','CASS.ServerFormats.FormatText','Prelude.False','Prelude.False','Prelude.False',[],[]),_19065874,_19065874).

'CASS.Options.options'(_19069764,_19069766,_19069768):-freeze(_19069766,'blocked_CASS.Options.options'(_19069764,_19069766,_19069768)).
'blocked_CASS.Options.options'(['System.Console.GetOpt.Option'(['^h',^?],[['^h','^e','^l','^p']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda214',[])),['^p','^r','^i','^n','^t','^ ','^h','^e','^l','^p','^ ','^a','^n','^d','^ ','^e','^x','^i','^t']),'System.Console.GetOpt.Option'(['^q'],[['^q','^u','^i','^e','^t']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda229',[])),['^r','^u','^n','^ ','^q','^u','^i','^e','^t','^l','^y','^ ','^(','^n','^o','^ ','^o','^u','^t','^p','^u','^t','^)']),'System.Console.GetOpt.Option'(['^v'],[['^v','^e','^r','^b','^o','^s','^i','^t','^y']],'System.Console.GetOpt.ReqArg'(partcall(2,'CASS.Options.options.safeReadNat.4',[partcall(2,'CASS.Options.options.checkVerb.4',[])]),[^<,'^n',^>]),['^v','^e','^r','^b','^o','^s','^i','^t','^y',^/,'^d','^e','^b','^u','^g','^ ','^l','^e','^v','^e','^l',^:,'^010','^0',^:,'^ ','^q','^u','^i','^e','^t','^ ','^(','^d','^e','^f','^a','^u','^l','^t','^;','^ ','^s','^a','^m','^e','^ ','^a','^s','^ ','^096',^-,'^q','^\'','^)','^010','^1',^:,'^ ','^s','^h','^o','^w','^ ','^w','^o','^r','^k','^e','^r','^ ','^a','^c','^t','^i','^v','^i','^t','^y','^,','^ ','^e',^.,'^g',^.,'^,','^ ','^t','^i','^m','^i','^n','^g','^s','^010','^2',^:,'^ ','^s','^h','^o','^w','^ ','^s','^e','^r','^v','^e','^r','^ ','^c','^o','^m','^m','^u','^n','^i','^c','^a','^t','^i','^o','^n','^010','^3',^:,'^ ',^.,^.,^.,'^a','^n','^d','^ ','^s','^h','^o','^w','^ ','^r','^e','^a','^d',^/,'^s','^t','^o','^r','^e','^ ','^i','^n','^f','^o','^r','^m','^a','^t','^i','^o','^n','^010','^4',^:,'^ ',^.,^.,^.,'^s','^h','^o','^w','^ ','^a','^l','^s','^o','^ ','^s','^t','^o','^r','^e','^d',^/,'^c','^o','^m','^p','^u','^t','^e','^d','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^d','^a','^t','^a','^010','^(','^d','^e','^f','^a','^u','^l','^t',^:,'^ ','^s','^e','^e','^ ','^d','^e','^b','^u','^g','^L','^e','^v','^e','^l','^ ','^i','^n','^ ',^~,^/,^.,'^c','^a','^s','^s','^r','^c','^)']),'System.Console.GetOpt.Option'(['^a'],[['^a','^l','^l']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda244',[])),['^s','^h','^o','^w','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^r','^e','^s','^u','^l','^t','^s','^ ','^f','^o','^r','^ ','^a','^l','^l','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n','^s','^010','^(','^i',^.,'^e',^.,'^,','^ ','^a','^l','^s','^o','^ ','^f','^o','^r','^ ','^n','^o','^n',^-,'^e','^x','^p','^o','^r','^t','^e','^d','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n','^s','^)']),'System.Console.GetOpt.Option'(['^f'],[['^f','^o','^r','^m','^a','^t']],'System.Console.GetOpt.ReqArg'(partcall(2,'CASS.Options.options.checkFormat.4',[]),[^<,'^f',^>]),['^o','^u','^t','^p','^u','^t','^ ','^f','^o','^r','^m','^a','^t','^ ','^(','^d','^e','^f','^a','^u','^l','^t',^:,'^ ','^T','^e','^x','^t','^)',^:,'^010','^T','^e','^x','^t','^|','^S','^h','^o','^r','^t','^|','^C','^u','^r','^r','^y','^T','^e','^r','^m','^|','^J','^S','^O','^N','^|','^J','^S','^O','^N','^T','^e','^r','^m','^|','^X','^M','^L']),'System.Console.GetOpt.Option'([],[['^n','^o','^g','^e','^n','^e','^r','^a','^t','^e','^d']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda259',[])),['^d','^o','^ ','^n','^o','^t','^ ','^s','^h','^o','^w','^ ','^r','^e','^s','^u','^l','^t','^s','^ ','^o','^f','^ ','^g','^e','^n','^e','^r','^a','^t','^e','^d','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n','^s','^010','^(','^e',^.,'^g',^.,'^,','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n','^s','^ ','^d','^e','^r','^i','^v','^e','^d','^ ','^f','^o','^r','^ ','^c','^l','^a','^s','^s','^ ','^i','^n','^s','^t','^a','^n','^c','^e','^s','^)']),'System.Console.GetOpt.Option'(['^r'],[['^r','^e','^a','^n','^a','^l','^y','^z','^e']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda274',[])),['^f','^o','^r','^c','^e','^ ','^r','^e',^-,'^a','^n','^a','^l','^y','^s','^i','^s','^ ','^010','^(','^i',^.,'^e',^.,'^,','^ ','^i','^g','^n','^o','^r','^e','^ ','^o','^l','^d','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^i','^n','^f','^o','^r','^m','^a','^t','^i','^o','^n','^)']),'System.Console.GetOpt.Option'([],[['^s','^t','^a','^t','^i','^s','^t','^i','^c','^s']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda289',[])),['^s','^h','^o','^w','^ ','^s','^t','^a','^t','^i','^s','^t','^i','^c','^s','^ ','^a','^b','^o','^u','^t','^ ','^n','^u','^m','^b','^e','^r','^ ','^o','^f','^ ','^m','^o','^d','^u','^l','^e','^s']),'System.Console.GetOpt.Option'([],[['^c','^u','^r','^r','^y','^i','^n','^f','^o']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda304',[])),['^u','^s','^e','^ ','^096','^c','^u','^r','^r','^y',^-,'^i','^n','^f','^o','^096','^ ','^t','^o','^ ','^i','^m','^p','^o','^r','^t','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^i','^n','^f','^o','^s']),'System.Console.GetOpt.Option'([],[['^c','^u','^r','^r','^y','^i','^n','^f','^o','^w','^e','^b']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda319',[])),['^u','^s','^e','^ ','^096','^c','^u','^r','^r','^y',^-,'^i','^n','^f','^o','^096','^ ','^w','^e','^b','^ ','^s','^e','^r','^v','^e','^r','^ ','^f','^o','^r','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^i','^n','^f','^o','^s']),'System.Console.GetOpt.Option'([],[['^n','^o','^c','^u','^r','^r','^y','^i','^n','^f','^o']],'System.Console.GetOpt.ReqArg'(partcall(2,'CASS.Options.options._\'23lambda334',[]),[^<,'^m',^>]),['^d','^o','^ ','^n','^o','^t','^ ','^u','^s','^e','^ ','^096','^c','^u','^r','^r','^y',^-,'^i','^n','^f','^o','^096','^ ','^f','^o','^r','^ ','^m','^o','^d','^u','^l','^e','^ ',^<,'^m',^>]),'System.Console.GetOpt.Option'(['^d'],[['^d','^e','^l','^e','^t','^e']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda349',[])),['^d','^e','^l','^e','^t','^e','^ ','^e','^x','^i','^s','^t','^i','^n','^g','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^r','^e','^s','^u','^l','^t','^s']),'System.Console.GetOpt.Option'(['^s'],[['^s','^e','^r','^v','^e','^r']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda364',[])),['^s','^t','^a','^r','^t','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^s','^y','^s','^t','^e','^m','^ ','^i','^n','^ ','^s','^e','^r','^v','^e','^r','^ ','^m','^o','^d','^e']),'System.Console.GetOpt.Option'(['^w'],[['^w','^o','^r','^k','^e','^r']],'System.Console.GetOpt.NoArg'(partcall(1,'CASS.Options.options._\'23lambda379',[])),['^s','^t','^a','^r','^t','^ ','^a','^n','^a','^l','^y','^s','^i','^s','^ ','^s','^y','^s','^t','^e','^m','^ ','^i','^n','^ ','^w','^o','^r','^k','^e','^r','^ ','^m','^o','^d','^e']),'System.Console.GetOpt.Option'(['^p'],[['^p','^o','^r','^t']],'System.Console.GetOpt.ReqArg'(partcall(2,'CASS.Options.options.safeReadNat.4',[partcall(2,'CASS.Options.options._\'23lambda394',[])]),[^<,'^n',^>]),['^p','^o','^r','^t','^ ','^n','^u','^m','^b','^e','^r','^ ','^f','^o','^r','^ ','^c','^o','^m','^m','^u','^n','^i','^c','^a','^t','^i','^o','^n','^010','^(','^o','^n','^l','^y','^ ','^f','^o','^r','^ ','^s','^e','^r','^v','^e','^r','^ ','^m','^o','^d','^e','^;','^010','^ ','^i','^f','^ ','^o','^m','^i','^t','^t','^e','^d','^,','^ ','^a','^ ','^f','^r','^e','^e','^ ','^p','^o','^r','^t','^ ','^n','^u','^m','^b','^e','^r','^ ','^i','^s','^ ','^s','^e','^l','^e','^c','^t','^e','^d','^)']),'System.Console.GetOpt.Option'(['^D'],[],'System.Console.GetOpt.ReqArg'(partcall(2,'CASS.Options.options.checkSetProperty.4',[]),['^n','^a','^m','^e',^=,'^v']),['^s','^e','^t','^ ','^p','^r','^o','^p','^e','^r','^t','^y','^ ','^(','^o','^f','^ ',^~,^/,^.,'^c','^a','^s','^s','^r','^c','^)','^010','^096','^n','^a','^m','^e','^\'','^ ','^a','^s','^ ','^096','^v','^\''])],_19256856,_19256856).

'CASS.Options.options.safeReadNat.4'(_19512702,_19512704,_19512706,_19512708,_19512710,_19512712):-freeze(_19512710,'blocked_CASS.Options.options.safeReadNat.4'(_19512702,_19512704,_19512706,_19512708,_19512710,_19512712)).
'blocked_CASS.Options.options.safeReadNat.4'(_19512808,_19512826,_19512844,_19539668,_19539674,_19539680):-hnf('Numeric.readNat'(_19512826),_19541394,_19539674,_19541354),'blocked_CASS.Options.options.safeReadNat.4_ComplexCase'(_19541394,_19512808,_19512826,_19512844,_19539668,_19541354,_19539680).

'blocked_CASS.Options.options.safeReadNat.4_ComplexCase'(_19541890,_19541892,_19541894,_19541896,_19541898,_19541900,_19541902):-freeze(_19541900,freeze(_19541890,'blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase'(_19541890,_19541892,_19541894,_19541896,_19541898,_19541900,_19541902))).
'blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase'([_19513044|_19513062],_19512808,_19512826,_19512844,_19542598,_19542604,_19542610):-hnf(_19513044,_19545064,_19542604,_19545100),'blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1'(_19545064,_19513062,_19512808,_19512826,_19512844,_19542598,_19545100,_19542610).

'blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1'(_19545728,_19545730,_19545732,_19545734,_19545736,_19545738,_19545740,_19545742):-freeze(_19545740,freeze(_19545728,'blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1'(_19545728,_19545730,_19545732,_19545734,_19545736,_19545738,_19545740,_19545742))).
'blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1'('Prelude.(,)'(_19513190,_19513208),_19513062,_19512808,_19512826,_19512844,_19546638,_19546644,_19546650):-!,hnf(_19513208,_19549856,_19546644,_19549898),'blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2'(_19549856,_19513190,_19513062,_19512808,_19512826,_19512844,_19546638,_19549898,_19546650).

'blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2'(_19550684,_19550686,_19550688,_19550690,_19550692,_19550694,_19550696,_19550698,_19550700):-freeze(_19550698,freeze(_19550684,'blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2'(_19550684,_19550686,_19550688,_19550690,_19550692,_19550694,_19550696,_19550698,_19550700))).
'blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2'([],_19513190,_19513062,_19512808,_19512826,_19512844,_19551608,_19551614,_19551620):-hnf(_19513062,_19555356,_19551614,_19555392),'blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2_[]_2'(_19555356,_19513190,_19512808,_19512826,_19512844,_19551608,_19555392,_19551620).

'blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2_[]_2'(_19556230,_19556232,_19556234,_19556236,_19556238,_19556240,_19556242,_19556244):-freeze(_19556242,freeze(_19556230,'blocked_blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2_[]_2'(_19556230,_19556232,_19556234,_19556236,_19556238,_19556240,_19556242,_19556244))).
'blocked_blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2_[]_2'([],_19513190,_19512808,_19512826,_19512844,_19556518,_19556524,_19556530):-hnf('Prelude.apply'('Prelude.apply'(_19512808,_19513190),_19512844),_19556518,_19556524,_19556530).
'blocked_blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2_[]_2'([_19513828|_19513846],_19513190,_19512808,_19512826,_19512844,_19558388,_19558394,_19558400):-!,hnf('Prelude.error'(['^I','^l','^l','^e','^g','^a','^l','^ ','^n','^u','^m','^b','^e','^r','^ ','^a','^r','^g','^u','^m','^e','^n','^t','^ ','^(','^t','^r','^y','^ ','^096',^-,'^h','^\'','^ ','^f','^o','^r','^ ','^h','^e','^l','^p','^)']),_19558388,_19558394,_19558400).
'blocked_blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2_[]_2'('FAIL'(_19568520),_19513190,_19512808,_19512826,_19512844,'FAIL'(_19568520),_19568534,_19568534).
'blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2'([_19520688|_19520706],_19513190,_19513062,_19512808,_19512826,_19512844,_19568808,_19568814,_19568820):-!,hnf('Prelude.error'(['^I','^l','^l','^e','^g','^a','^l','^ ','^n','^u','^m','^b','^e','^r','^ ','^a','^r','^g','^u','^m','^e','^n','^t','^ ','^(','^t','^r','^y','^ ','^096',^-,'^h','^\'','^ ','^f','^o','^r','^ ','^h','^e','^l','^p','^)']),_19568808,_19568814,_19568820).
'blocked_blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1_Prelude.(,)_2'('FAIL'(_19578936),_19513190,_19513062,_19512808,_19512826,_19512844,'FAIL'(_19578936),_19578950,_19578950).
'blocked_blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase_[|]_1'('FAIL'(_19579042),_19513062,_19512808,_19512826,_19512844,'FAIL'(_19579042),_19579056,_19579056).
'blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase'([],_19512808,_19512826,_19512844,_19579302,_19579308,_19579314):-!,hnf('Prelude.error'(['^I','^l','^l','^e','^g','^a','^l','^ ','^n','^u','^m','^b','^e','^r','^ ','^a','^r','^g','^u','^m','^e','^n','^t','^ ','^(','^t','^r','^y','^ ','^096',^-,'^h','^\'','^ ','^f','^o','^r','^ ','^h','^e','^l','^p','^)']),_19579302,_19579308,_19579314).
'blocked_blocked_CASS.Options.options.safeReadNat.4_ComplexCase'('FAIL'(_19588934),_19512808,_19512826,_19512844,'FAIL'(_19588934),_19588948,_19588948).

'CASS.Options.options.checkVerb.4'(_19590368,_19590370,_19590372,_19590374,_19590376):-freeze(_19590374,'blocked_CASS.Options.options.checkVerb.4'(_19590368,_19590370,_19590372,_19590374,_19590376)).
'blocked_CASS.Options.options.checkVerb.4'(_19590464,_19590482,_19605204,_19605210,_19605216):-makeShare(_19590464,_19601088),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23',_19601088),0),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',_19601088),5)),_19606844,_19605210,_19606810),'blocked_CASS.Options.options.checkVerb.4_ComplexCase'(_19606844,_19601088,_19590482,_19605204,_19606810,_19605216).

'blocked_CASS.Options.options.checkVerb.4_ComplexCase'(_19607338,_19607340,_19607342,_19607344,_19607346,_19607348):-freeze(_19607346,freeze(_19607338,'blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase'(_19607338,_19607340,_19607342,_19607344,_19607346,_19607348))).
'blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase'('Prelude.True',_19601088,_19590482,_19608140,_19608146,_19608152):-hnf(_19590482,_19610796,_19608146,_19610814),'blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase_Prelude.True_2'(_19610796,_19601088,_19608140,_19610814,_19608152).

'blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase_Prelude.True_2'(_19611454,_19611456,_19611458,_19611460,_19611462):-freeze(_19611460,'blocked_blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase_Prelude.True_2'(_19611454,_19611456,_19611458,_19611460,_19611462)).
'blocked_blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase_Prelude.True_2'('CASS.Options.Options'(_19591494,_19591512,_19591530,_19591548,_19591566,_19591584,_19591602,_19591620,_19591638,_19591656,_19591674,_19591692,_19591710),_19601088,'CASS.Options.Options'(_19591494,_19601088,_19591530,_19591548,_19591566,_19591584,_19591602,_19591620,_19591638,_19591656,_19591674,_19591692,_19591710),_19612050,_19612050):-!.
'blocked_blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase_Prelude.True_2'('FAIL'(_19615860),_19601088,'FAIL'(_19615860),_19615874,_19615874):-nonvar(_19615860).
'blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase'('Prelude.False',_19601088,_19590482,_19616248,_19616254,_19616260):-!,hnf('Prelude.error'(['^I','^l','^l','^e','^g','^a','^l','^ ','^v','^e','^r','^b','^o','^s','^i','^t','^y','^ ','^l','^e','^v','^e','^l','^ ','^(','^t','^r','^y','^ ','^096',^-,'^h','^\'','^ ','^f','^o','^r','^ ','^h','^e','^l','^p','^)']),_19616248,_19616254,_19616260).
'blocked_blocked_CASS.Options.options.checkVerb.4_ComplexCase'('FAIL'(_19625794),_19601088,_19590482,'FAIL'(_19625794),_19625808,_19625808).

'CASS.Options.options.checkFormat.4'(_19627296,_19627298,_19627300,_19627302,_19627304):-freeze(_19627302,'blocked_CASS.Options.options.checkFormat.4'(_19627296,_19627298,_19627300,_19627302,_19627304)).
'blocked_CASS.Options.options.checkFormat.4'(_19627392,_19627410,_19631962,_19631968,_19631974):-makeShare(_19627392,_19632192),hnf('Prelude.maybe'('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^I','^l','^l','^e','^g','^a','^l','^ ','^f','^o','^r','^m','^a','^t','^ ','^v','^a','^l','^u','^e',^:,'^ '],_19632192)),partcall(1,'CASS.Options.options.checkFormat.4._\'23lambda185',[_19627410]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),'Prelude.map'(partcall(1,'Data.Char.toLower',[]),_19632192),'CASS.ServerFormats.serverFormatNames')),_19631962,_19631968,_19631974).

'CASS.Options.options.checkFormat.4._\'23lambda185'(_19642260,_19642262,_19642264,_19642266,_19642268):-freeze(_19642266,'blocked_CASS.Options.options.checkFormat.4._\'23lambda185'(_19642260,_19642262,_19642264,_19642266,_19642268)).
'blocked_CASS.Options.options.checkFormat.4._\'23lambda185'(_19642356,_19642374,_19644096,_19644102,_19644108):-hnf(_19642356,_19646210,_19644102,_19646228),'blocked_CASS.Options.options.checkFormat.4._\'23lambda185_1'(_19646210,_19642374,_19644096,_19646228,_19644108).

'blocked_CASS.Options.options.checkFormat.4._\'23lambda185_1'(_19646766,_19646768,_19646770,_19646772,_19646774):-freeze(_19646772,'blocked_blocked_CASS.Options.options.checkFormat.4._\'23lambda185_1'(_19646766,_19646768,_19646770,_19646772,_19646774)).
'blocked_blocked_CASS.Options.options.checkFormat.4._\'23lambda185_1'('CASS.Options.Options'(_19642490,_19642508,_19642526,_19642544,_19642562,_19642580,_19642598,_19642616,_19642634,_19642652,_19642670,_19642688,_19642706),_19642374,'CASS.Options.Options'(_19642490,_19642508,_19642526,_19642544,_19642562,_19642580,_19642598,_19642374,_19642634,_19642652,_19642670,_19642688,_19642706),_19647362,_19647362):-!.
'blocked_blocked_CASS.Options.options.checkFormat.4._\'23lambda185_1'('FAIL'(_19651070),_19642374,'FAIL'(_19651070),_19651084,_19651084):-nonvar(_19651070).

'CASS.Options.options.checkSetProperty.4'(_19652758,_19652760,_19652762,_19652764,_19652766):-freeze(_19652764,'blocked_CASS.Options.options.checkSetProperty.4'(_19652758,_19652760,_19652762,_19652764,_19652766)).
'blocked_CASS.Options.options.checkSetProperty.4'(_19652854,_19652872,_19654846,_19654852,_19654858):-makeShare(_19652900,_19655296),makeShare(_19652918,_19655316),makeShare(_19652936,_19655336),hnf('Prelude.cond'(letrec4PAKCS(_19655296,'Prelude.apply'('Prelude.break'(partcall(1,'Prelude.flip',[^=,partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_19652854)),'Prelude.cond'(letrec4PAKCS(_19655316,'CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key'(_19655296)),'Prelude.cond'(letrec4PAKCS(_19655336,'CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue'(_19655296)),'CASS.Options.options.checkSetProperty.4._\'23caseor0'('Prelude.null'(_19655336),_19652872,_19655316,_19655336)))),_19654846,_19654852,_19654858).

'CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key'(_19663230,_19663232,_19663234,_19663236):-freeze(_19663234,'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key'(_19663230,_19663232,_19663234,_19663236)).
'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key'(_19663316,_19663898,_19663904,_19663910):-hnf(_19663316,_19666292,_19663904,_19666304),'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key_1'(_19666292,_19663898,_19666304,_19663910).

'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key_1'(_19666882,_19666884,_19666886,_19666888):-freeze(_19666886,'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key_1'(_19666882,_19666884,_19666886,_19666888)).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key_1'('Prelude.(,)'(_19663432,_19663450),_19667252,_19667258,_19667264):-!,hnf(_19663432,_19667252,_19667258,_19667264).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23selFP2\'23key_1'('FAIL'(_19667968),'FAIL'(_19667968),_19667982,_19667982):-nonvar(_19667968).

'CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue'(_19670350,_19670352,_19670354,_19670356):-freeze(_19670354,'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue'(_19670350,_19670352,_19670354,_19670356)).
'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue'(_19670436,_19671042,_19671048,_19671054):-hnf(_19670436,_19673580,_19671048,_19673592),'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue_1'(_19673580,_19671042,_19673592,_19671054).

'blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue_1'(_19674194,_19674196,_19674198,_19674200):-freeze(_19674198,'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue_1'(_19674194,_19674196,_19674198,_19674200)).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue_1'('Prelude.(,)'(_19670552,_19670570),_19674564,_19674570,_19674576):-!,hnf(_19670570,_19674564,_19674570,_19674576).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23selFP3\'23eqvalue_1'('FAIL'(_19675304),'FAIL'(_19675304),_19675318,_19675318):-nonvar(_19675304).

'CASS.Options.options._\'23lambda214'(_19676746,_19676748,_19676750,_19676752):-freeze(_19676750,'blocked_CASS.Options.options._\'23lambda214'(_19676746,_19676748,_19676750,_19676752)).
'blocked_CASS.Options.options._\'23lambda214'(_19676832,_19678484,_19678490,_19678496):-hnf(_19676832,_19680086,_19678490,_19680098),'blocked_CASS.Options.options._\'23lambda214_1'(_19680086,_19678484,_19680098,_19678496).

'blocked_CASS.Options.options._\'23lambda214_1'(_19680544,_19680546,_19680548,_19680550):-freeze(_19680548,'blocked_blocked_CASS.Options.options._\'23lambda214_1'(_19680544,_19680546,_19680548,_19680550)).
'blocked_blocked_CASS.Options.options._\'23lambda214_1'('CASS.Options.Options'(_19676948,_19676966,_19676984,_19677002,_19677020,_19677038,_19677056,_19677074,_19677092,_19677110,_19677128,_19677146,_19677164),'CASS.Options.Options'('Prelude.True',_19676966,_19676984,_19677002,_19677020,_19677038,_19677056,_19677074,_19677092,_19677110,_19677128,_19677146,_19677164),_19681130,_19681130):-!.
'blocked_blocked_CASS.Options.options._\'23lambda214_1'('FAIL'(_19684624),'FAIL'(_19684624),_19684638,_19684638):-nonvar(_19684624).

'CASS.Options.options._\'23lambda229'(_19686066,_19686068,_19686070,_19686072):-freeze(_19686070,'blocked_CASS.Options.options._\'23lambda229'(_19686066,_19686068,_19686070,_19686072)).
'blocked_CASS.Options.options._\'23lambda229'(_19686152,_19687790,_19687796,_19687802):-hnf(_19686152,_19689392,_19687796,_19689404),'blocked_CASS.Options.options._\'23lambda229_1'(_19689392,_19687790,_19689404,_19687802).

'blocked_CASS.Options.options._\'23lambda229_1'(_19689850,_19689852,_19689854,_19689856):-freeze(_19689854,'blocked_blocked_CASS.Options.options._\'23lambda229_1'(_19689850,_19689852,_19689854,_19689856)).
'blocked_blocked_CASS.Options.options._\'23lambda229_1'('CASS.Options.Options'(_19686268,_19686286,_19686304,_19686322,_19686340,_19686358,_19686376,_19686394,_19686412,_19686430,_19686448,_19686466,_19686484),'CASS.Options.Options'(_19686268,0,_19686304,_19686322,_19686340,_19686358,_19686376,_19686394,_19686412,_19686430,_19686448,_19686466,_19686484),_19690436,_19690436):-!.
'blocked_blocked_CASS.Options.options._\'23lambda229_1'('FAIL'(_19693830),'FAIL'(_19693830),_19693844,_19693844):-nonvar(_19693830).

'CASS.Options.options._\'23lambda244'(_19695272,_19695274,_19695276,_19695278):-freeze(_19695276,'blocked_CASS.Options.options._\'23lambda244'(_19695272,_19695274,_19695276,_19695278)).
'blocked_CASS.Options.options._\'23lambda244'(_19695358,_19697010,_19697016,_19697022):-hnf(_19695358,_19698612,_19697016,_19698624),'blocked_CASS.Options.options._\'23lambda244_1'(_19698612,_19697010,_19698624,_19697022).

'blocked_CASS.Options.options._\'23lambda244_1'(_19699070,_19699072,_19699074,_19699076):-freeze(_19699074,'blocked_blocked_CASS.Options.options._\'23lambda244_1'(_19699070,_19699072,_19699074,_19699076)).
'blocked_blocked_CASS.Options.options._\'23lambda244_1'('CASS.Options.Options'(_19695474,_19695492,_19695510,_19695528,_19695546,_19695564,_19695582,_19695600,_19695618,_19695636,_19695654,_19695672,_19695690),'CASS.Options.Options'(_19695474,_19695492,_19695510,_19695528,_19695546,'Prelude.True',_19695582,_19695600,_19695618,_19695636,_19695654,_19695672,_19695690),_19699656,_19699656):-!.
'blocked_blocked_CASS.Options.options._\'23lambda244_1'('FAIL'(_19703150),'FAIL'(_19703150),_19703164,_19703164):-nonvar(_19703150).

'CASS.Options.options._\'23lambda259'(_19704592,_19704594,_19704596,_19704598):-freeze(_19704596,'blocked_CASS.Options.options._\'23lambda259'(_19704592,_19704594,_19704596,_19704598)).
'blocked_CASS.Options.options._\'23lambda259'(_19704678,_19706330,_19706336,_19706342):-hnf(_19704678,_19707932,_19706336,_19707944),'blocked_CASS.Options.options._\'23lambda259_1'(_19707932,_19706330,_19707944,_19706342).

'blocked_CASS.Options.options._\'23lambda259_1'(_19708390,_19708392,_19708394,_19708396):-freeze(_19708394,'blocked_blocked_CASS.Options.options._\'23lambda259_1'(_19708390,_19708392,_19708394,_19708396)).
'blocked_blocked_CASS.Options.options._\'23lambda259_1'('CASS.Options.Options'(_19704794,_19704812,_19704830,_19704848,_19704866,_19704884,_19704902,_19704920,_19704938,_19704956,_19704974,_19704992,_19705010),'CASS.Options.Options'(_19704794,_19704812,_19704830,_19704848,_19704866,_19704884,'Prelude.False',_19704920,_19704938,_19704956,_19704974,_19704992,_19705010),_19708976,_19708976):-!.
'blocked_blocked_CASS.Options.options._\'23lambda259_1'('FAIL'(_19712476),'FAIL'(_19712476),_19712490,_19712490):-nonvar(_19712476).

'CASS.Options.options._\'23lambda274'(_19713918,_19713920,_19713922,_19713924):-freeze(_19713922,'blocked_CASS.Options.options._\'23lambda274'(_19713918,_19713920,_19713922,_19713924)).
'blocked_CASS.Options.options._\'23lambda274'(_19714004,_19715656,_19715662,_19715668):-hnf(_19714004,_19717258,_19715662,_19717270),'blocked_CASS.Options.options._\'23lambda274_1'(_19717258,_19715656,_19717270,_19715668).

'blocked_CASS.Options.options._\'23lambda274_1'(_19717716,_19717718,_19717720,_19717722):-freeze(_19717720,'blocked_blocked_CASS.Options.options._\'23lambda274_1'(_19717716,_19717718,_19717720,_19717722)).
'blocked_blocked_CASS.Options.options._\'23lambda274_1'('CASS.Options.Options'(_19714120,_19714138,_19714156,_19714174,_19714192,_19714210,_19714228,_19714246,_19714264,_19714282,_19714300,_19714318,_19714336),'CASS.Options.Options'(_19714120,_19714138,_19714156,_19714174,_19714192,_19714210,_19714228,_19714246,'Prelude.True',_19714282,_19714300,_19714318,_19714336),_19718302,_19718302):-!.
'blocked_blocked_CASS.Options.options._\'23lambda274_1'('FAIL'(_19721796),'FAIL'(_19721796),_19721810,_19721810):-nonvar(_19721796).

'CASS.Options.options._\'23lambda289'(_19723238,_19723240,_19723242,_19723244):-freeze(_19723242,'blocked_CASS.Options.options._\'23lambda289'(_19723238,_19723240,_19723242,_19723244)).
'blocked_CASS.Options.options._\'23lambda289'(_19723324,_19724976,_19724982,_19724988):-hnf(_19723324,_19726578,_19724982,_19726590),'blocked_CASS.Options.options._\'23lambda289_1'(_19726578,_19724976,_19726590,_19724988).

'blocked_CASS.Options.options._\'23lambda289_1'(_19727036,_19727038,_19727040,_19727042):-freeze(_19727040,'blocked_blocked_CASS.Options.options._\'23lambda289_1'(_19727036,_19727038,_19727040,_19727042)).
'blocked_blocked_CASS.Options.options._\'23lambda289_1'('CASS.Options.Options'(_19723440,_19723458,_19723476,_19723494,_19723512,_19723530,_19723548,_19723566,_19723584,_19723602,_19723620,_19723638,_19723656),'CASS.Options.Options'(_19723440,_19723458,_19723476,_19723494,_19723512,_19723530,_19723548,_19723566,_19723584,'Prelude.True',_19723620,_19723638,_19723656),_19727622,_19727622):-!.
'blocked_blocked_CASS.Options.options._\'23lambda289_1'('FAIL'(_19731116),'FAIL'(_19731116),_19731130,_19731130):-nonvar(_19731116).

'CASS.Options.options._\'23lambda304'(_19732558,_19732560,_19732562,_19732564):-freeze(_19732562,'blocked_CASS.Options.options._\'23lambda304'(_19732558,_19732560,_19732562,_19732564)).
'blocked_CASS.Options.options._\'23lambda304'(_19732644,_19737980,_19737986,_19737992):-makeShare(_19732644,_19736746),hnf(_19736746,_19739582,_19737986,_19739600),'blocked_CASS.Options.options._\'23lambda304_1'(_19739582,_19739582,_19737980,_19739600,_19737992).

'blocked_CASS.Options.options._\'23lambda304_1'(_19740066,_19740068,_19740070,_19740072,_19740074):-freeze(_19740072,'blocked_blocked_CASS.Options.options._\'23lambda304_1'(_19740066,_19740068,_19740070,_19740072,_19740074)).
'blocked_blocked_CASS.Options.options._\'23lambda304_1'('CASS.Options.Options'(_19732760,_19732778,_19732796,_19732814,_19732832,_19732850,_19732868,_19732886,_19732904,_19732922,_19732940,_19732958,_19732976),_19736746,'CASS.Options.Options'(_19732760,_19732778,_19732796,_19732814,_19732832,_19732850,_19732868,_19732886,_19732904,_19732922,_19732940,_19732958,'Prelude.++'('CASS.Options.optProp'(_19736746),['Prelude.(,)'(['^c','^u','^r','^r','^y','^i','^n','^f','^o'],['^l','^o','^c','^a','^l'])])),_19740662,_19740662):-!.
'blocked_blocked_CASS.Options.options._\'23lambda304_1'('FAIL'(_19748162),_19736746,'FAIL'(_19748162),_19748176,_19748176):-nonvar(_19748162).

'CASS.Options.options._\'23lambda319'(_19749612,_19749614,_19749616,_19749618):-freeze(_19749616,'blocked_CASS.Options.options._\'23lambda319'(_19749612,_19749614,_19749616,_19749618)).
'blocked_CASS.Options.options._\'23lambda319'(_19749698,_19755212,_19755218,_19755224):-makeShare(_19749698,_19753954),hnf(_19753954,_19756814,_19755218,_19756832),'blocked_CASS.Options.options._\'23lambda319_1'(_19756814,_19756814,_19755212,_19756832,_19755224).

'blocked_CASS.Options.options._\'23lambda319_1'(_19757298,_19757300,_19757302,_19757304,_19757306):-freeze(_19757304,'blocked_blocked_CASS.Options.options._\'23lambda319_1'(_19757298,_19757300,_19757302,_19757304,_19757306)).
'blocked_blocked_CASS.Options.options._\'23lambda319_1'('CASS.Options.Options'(_19749814,_19749832,_19749850,_19749868,_19749886,_19749904,_19749922,_19749940,_19749958,_19749976,_19749994,_19750012,_19750030),_19753954,'CASS.Options.Options'(_19749814,_19749832,_19749850,_19749868,_19749886,_19749904,_19749922,_19749940,_19749958,_19749976,_19749994,_19750012,'Prelude.++'('CASS.Options.optProp'(_19753954),['Prelude.(,)'(['^c','^u','^r','^r','^y','^i','^n','^f','^o'],['^r','^e','^m','^o','^t','^e'])])),_19757894,_19757894):-!.
'blocked_blocked_CASS.Options.options._\'23lambda319_1'('FAIL'(_19765596),_19753954,'FAIL'(_19765596),_19765610,_19765610):-nonvar(_19765596).

'CASS.Options.options._\'23lambda334'(_19767046,_19767048,_19767050,_19767052,_19767054):-freeze(_19767052,'blocked_CASS.Options.options._\'23lambda334'(_19767046,_19767048,_19767050,_19767052,_19767054)).
'blocked_CASS.Options.options._\'23lambda334'(_19767142,_19767160,_19769668,_19769674,_19769680):-makeShare(_19767160,_19768764),hnf(_19768764,_19771278,_19769674,_19771302),'blocked_CASS.Options.options._\'23lambda334_2'(_19771278,_19767142,_19771278,_19769668,_19771302,_19769680).

'blocked_CASS.Options.options._\'23lambda334_2'(_19771776,_19771778,_19771780,_19771782,_19771784,_19771786):-freeze(_19771784,'blocked_blocked_CASS.Options.options._\'23lambda334_2'(_19771776,_19771778,_19771780,_19771782,_19771784,_19771786)).
'blocked_blocked_CASS.Options.options._\'23lambda334_2'('CASS.Options.Options'(_19767276,_19767294,_19767312,_19767330,_19767348,_19767366,_19767384,_19767402,_19767420,_19767438,_19767456,_19767474,_19767492),_19767142,_19768764,'CASS.Options.Options'(_19767276,_19767294,_19767312,_19767330,_19767348,_19767366,_19767384,_19767402,_19767420,_19767438,_19767456,[_19767142|'CASS.Options.optNoCurryInfo'(_19768764)],_19767492),_19772382,_19772382):-!.
'blocked_blocked_CASS.Options.options._\'23lambda334_2'('FAIL'(_19776710),_19767142,_19768764,'FAIL'(_19776710),_19776724,_19776724):-nonvar(_19776710).

'CASS.Options.options._\'23lambda349'(_19778168,_19778170,_19778172,_19778174):-freeze(_19778172,'blocked_CASS.Options.options._\'23lambda349'(_19778168,_19778170,_19778172,_19778174)).
'blocked_CASS.Options.options._\'23lambda349'(_19778254,_19779906,_19779912,_19779918):-hnf(_19778254,_19781508,_19779912,_19781520),'blocked_CASS.Options.options._\'23lambda349_1'(_19781508,_19779906,_19781520,_19779918).

'blocked_CASS.Options.options._\'23lambda349_1'(_19781966,_19781968,_19781970,_19781972):-freeze(_19781970,'blocked_blocked_CASS.Options.options._\'23lambda349_1'(_19781966,_19781968,_19781970,_19781972)).
'blocked_blocked_CASS.Options.options._\'23lambda349_1'('CASS.Options.Options'(_19778370,_19778388,_19778406,_19778424,_19778442,_19778460,_19778478,_19778496,_19778514,_19778532,_19778550,_19778568,_19778586),'CASS.Options.Options'(_19778370,_19778388,_19778406,_19778424,_19778442,_19778460,_19778478,_19778496,_19778514,_19778532,'Prelude.True',_19778568,_19778586),_19782552,_19782552):-!.
'blocked_blocked_CASS.Options.options._\'23lambda349_1'('FAIL'(_19786046),'FAIL'(_19786046),_19786060,_19786060):-nonvar(_19786046).

'CASS.Options.options._\'23lambda364'(_19787488,_19787490,_19787492,_19787494):-freeze(_19787492,'blocked_CASS.Options.options._\'23lambda364'(_19787488,_19787490,_19787492,_19787494)).
'blocked_CASS.Options.options._\'23lambda364'(_19787574,_19789226,_19789232,_19789238):-hnf(_19787574,_19790828,_19789232,_19790840),'blocked_CASS.Options.options._\'23lambda364_1'(_19790828,_19789226,_19790840,_19789238).

'blocked_CASS.Options.options._\'23lambda364_1'(_19791286,_19791288,_19791290,_19791292):-freeze(_19791290,'blocked_blocked_CASS.Options.options._\'23lambda364_1'(_19791286,_19791288,_19791290,_19791292)).
'blocked_blocked_CASS.Options.options._\'23lambda364_1'('CASS.Options.Options'(_19787690,_19787708,_19787726,_19787744,_19787762,_19787780,_19787798,_19787816,_19787834,_19787852,_19787870,_19787888,_19787906),'CASS.Options.Options'(_19787690,_19787708,'Prelude.True',_19787744,_19787762,_19787780,_19787798,_19787816,_19787834,_19787852,_19787870,_19787888,_19787906),_19791872,_19791872):-!.
'blocked_blocked_CASS.Options.options._\'23lambda364_1'('FAIL'(_19795366),'FAIL'(_19795366),_19795380,_19795380):-nonvar(_19795366).

'CASS.Options.options._\'23lambda379'(_19796808,_19796810,_19796812,_19796814):-freeze(_19796812,'blocked_CASS.Options.options._\'23lambda379'(_19796808,_19796810,_19796812,_19796814)).
'blocked_CASS.Options.options._\'23lambda379'(_19796894,_19798546,_19798552,_19798558):-hnf(_19796894,_19800148,_19798552,_19800160),'blocked_CASS.Options.options._\'23lambda379_1'(_19800148,_19798546,_19800160,_19798558).

'blocked_CASS.Options.options._\'23lambda379_1'(_19800606,_19800608,_19800610,_19800612):-freeze(_19800610,'blocked_blocked_CASS.Options.options._\'23lambda379_1'(_19800606,_19800608,_19800610,_19800612)).
'blocked_blocked_CASS.Options.options._\'23lambda379_1'('CASS.Options.Options'(_19797010,_19797028,_19797046,_19797064,_19797082,_19797100,_19797118,_19797136,_19797154,_19797172,_19797190,_19797208,_19797226),'CASS.Options.Options'(_19797010,_19797028,_19797046,'Prelude.True',_19797082,_19797100,_19797118,_19797136,_19797154,_19797172,_19797190,_19797208,_19797226),_19801192,_19801192):-!.
'blocked_blocked_CASS.Options.options._\'23lambda379_1'('FAIL'(_19804686),'FAIL'(_19804686),_19804700,_19804700):-nonvar(_19804686).

'CASS.Options.options._\'23lambda394'(_19806128,_19806130,_19806132,_19806134,_19806136):-freeze(_19806134,'blocked_CASS.Options.options._\'23lambda394'(_19806128,_19806130,_19806132,_19806134,_19806136)).
'blocked_CASS.Options.options._\'23lambda394'(_19806224,_19806242,_19807888,_19807894,_19807900):-hnf(_19806242,_19809498,_19807894,_19809516),'blocked_CASS.Options.options._\'23lambda394_2'(_19809498,_19806224,_19807888,_19809516,_19807900).

'blocked_CASS.Options.options._\'23lambda394_2'(_19809970,_19809972,_19809974,_19809976,_19809978):-freeze(_19809976,'blocked_blocked_CASS.Options.options._\'23lambda394_2'(_19809970,_19809972,_19809974,_19809976,_19809978)).
'blocked_blocked_CASS.Options.options._\'23lambda394_2'('CASS.Options.Options'(_19806358,_19806376,_19806394,_19806412,_19806430,_19806448,_19806466,_19806484,_19806502,_19806520,_19806538,_19806556,_19806574),_19806224,'CASS.Options.Options'(_19806358,_19806376,_19806394,_19806412,_19806224,_19806448,_19806466,_19806484,_19806502,_19806520,_19806538,_19806556,_19806574),_19810566,_19810566):-!.
'blocked_blocked_CASS.Options.options._\'23lambda394_2'('FAIL'(_19814190),_19806224,'FAIL'(_19814190),_19814204,_19814204):-nonvar(_19814190).

'CASS.Options.options.checkSetProperty.4._\'23caseor0'(_19816286,_19816288,_19816290,_19816292,_19816294,_19816296,_19816298):-freeze(_19816296,'blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0'(_19816286,_19816288,_19816290,_19816292,_19816294,_19816296,_19816298)).
'blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0'(_19816402,_19816420,_19816438,_19816456,_19825904,_19825910,_19825916):-hnf(_19816402,_19828142,_19825910,_19828172),'blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1'(_19828142,_19816420,_19816438,_19816456,_19825904,_19828172,_19825916).

'blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1'(_19828750,_19828752,_19828754,_19828756,_19828758,_19828760,_19828762):-freeze(_19828760,freeze(_19828750,'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1'(_19828750,_19828752,_19828754,_19828756,_19828758,_19828760,_19828762))).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1'('Prelude.True',_19816420,_19816438,_19816456,_19829164,_19829170,_19829176):-hnf('Prelude.error'(['^I','^l','^l','^e','^g','^a','^l','^ ','^p','^r','^o','^p','^e','^r','^t','^y','^ ','^s','^e','^t','^t','^i','^n','^g','^ ','^(','^t','^r','^y','^ ','^096',^-,'^h','^\'','^ ','^f','^o','^r','^ ','^h','^e','^l','^p','^)']),_19829164,_19829170,_19829176).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1'('Prelude.False',_19816420,_19816438,_19816456,_19840532,_19840538,_19840544):-!,makeShare(_19816420,_19839334),hnf(_19839334,_19843550,_19840538,_19843580),'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1_Prelude.False_1'(_19843550,_19843550,_19816438,_19816456,_19840532,_19843580,_19840544).

'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1_Prelude.False_1'(_19844326,_19844328,_19844330,_19844332,_19844334,_19844336,_19844338):-freeze(_19844336,'blocked_blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1_Prelude.False_1'(_19844326,_19844328,_19844330,_19844332,_19844334,_19844336,_19844338)).
'blocked_blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1_Prelude.False_1'('CASS.Options.Options'(_19823630,_19823648,_19823666,_19823684,_19823702,_19823720,_19823738,_19823756,_19823774,_19823792,_19823810,_19823828,_19823846),_19839334,_19816438,_19816456,'CASS.Options.Options'(_19823630,_19823648,_19823666,_19823684,_19823702,_19823720,_19823738,_19823756,_19823774,_19823792,_19823810,_19823828,'Prelude.++'('CASS.Options.optProp'(_19839334),['Prelude.(,)'(_19816438,'Prelude.tail'(_19816456))])),_19844942,_19844942):-!.
'blocked_blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1_Prelude.False_1'('FAIL'(_19850490),_19839334,_19816438,_19816456,'FAIL'(_19850490),_19850504,_19850504):-nonvar(_19850490).
'blocked_blocked_CASS.Options.options.checkSetProperty.4._\'23caseor0_1'('FAIL'(_19850584),_19816420,_19816438,_19816456,'FAIL'(_19850584),_19850598,_19850598).

:-costCenters(['']).




%%%%% Number of shared variables: 5

