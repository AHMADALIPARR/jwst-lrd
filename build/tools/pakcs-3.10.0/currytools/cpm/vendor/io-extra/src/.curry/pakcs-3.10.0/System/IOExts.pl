%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Monad').
:-importModule('Prelude').
:-importModule('System.Directory').
:-importModule('System.IO').
:-importModule('System.Process').

:-curryModule('System.IOExts').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.IOExts.execCmd',execCmd,1,'System.IOExts.execCmd',nofix,notype).
functiontype('System.IOExts.prim_execCmd','System.IOExts.prim_execCmd',1,'System.IOExts.prim_execCmd',nofix,notype).
functiontype('System.IOExts.evalCmd',evalCmd,3,'System.IOExts.evalCmd',nofix,notype).
functiontype('System.IOExts.evalCmd.wrapArg.4','System.IOExts.evalCmd.wrapArg.4',1,'System.IOExts.evalCmd.wrapArg.4',nofix,notype).
functiontype('System.IOExts.evalCmd.wrapArg.4.escape.6','System.IOExts.evalCmd.wrapArg.4.escape.6',2,'System.IOExts.evalCmd.wrapArg.4.escape.6',nofix,notype).
functiontype('System.IOExts.evalCmd.wrapArg.4.goodChar.6','System.IOExts.evalCmd.wrapArg.4.goodChar.6',1,'System.IOExts.evalCmd.wrapArg.4.goodChar.6',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6','System.IOExts.evalCmd._#lambda6',4,'System.IOExts.evalCmd._\'23lambda6',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8','System.IOExts.evalCmd._#lambda6._#lambda8',3,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10','System.IOExts.evalCmd._#lambda6._#lambda8._#lambda10',3,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12','System.IOExts.evalCmd._#lambda6._#lambda8._#lambda10._#lambda12',3,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12',nofix,notype).
functiontype('System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14','System.IOExts.evalCmd._#lambda6._#lambda8._#lambda10._#lambda12._#lambda14',4,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14',nofix,notype).
functiontype('System.IOExts.connectToCommand',connectToCommand,1,'System.IOExts.connectToCommand',nofix,notype).
functiontype('System.IOExts.prim_connectToCmd','System.IOExts.prim_connectToCmd',1,'System.IOExts.prim_connectToCmd',nofix,notype).
functiontype('System.IOExts.readCompleteFile',readCompleteFile,1,'System.IOExts.readCompleteFile',nofix,notype).
functiontype('System.IOExts.readCompleteFile.f.21','System.IOExts.readCompleteFile.f.21',2,'System.IOExts.readCompleteFile.f.21',nofix,notype).
functiontype('System.IOExts.readCompleteFile._\'23lambda17','System.IOExts.readCompleteFile._#lambda17',1,'System.IOExts.readCompleteFile._\'23lambda17',nofix,notype).
functiontype('System.IOExts.updateFile',updateFile,2,'System.IOExts.updateFile',nofix,notype).
functiontype('System.IOExts.updateFile._\'23lambda20','System.IOExts.updateFile._#lambda20',3,'System.IOExts.updateFile._\'23lambda20',nofix,notype).
functiontype('System.IOExts.exclusiveIO',exclusiveIO,2,'System.IOExts.exclusiveIO',nofix,notype).
functiontype('System.IOExts.exclusiveIO._\'23lambda23','System.IOExts.exclusiveIO._#lambda23',2,'System.IOExts.exclusiveIO._\'23lambda23',nofix,notype).
functiontype('System.IOExts.exclusiveIO._\'23lambda25','System.IOExts.exclusiveIO._#lambda25',2,'System.IOExts.exclusiveIO._\'23lambda25',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.IOExts.execCmd'(_60267698,_60267700,_60267702,_60267704):-freeze(_60267702,'blocked_System.IOExts.execCmd'(_60267698,_60267700,_60267702,_60267704)).
'blocked_System.IOExts.execCmd'(_60267784,_60267968,_60267974,_60267980):-hnf('Prelude.$##'(partcall(1,'System.IOExts.prim_execCmd',[]),_60267784),_60267968,_60267974,_60267980).

'System.IOExts.prim_execCmd'(_60269054,partcall(1,'System.IOExts.prim_execCmd$WORLD',[_60269054]),_60269438,_60269438).
'System.IOExts.prim_execCmd$WORLD'(_60269782,_60269784,_60269786,_60269788,_60269790):-freeze(_60269788,'blocked_System.IOExts.prim_execCmd$WORLD'(_60269782,_60269784,_60269786,_60269788,_60269790)).
'blocked_System.IOExts.prim_execCmd$WORLD'(_60269872,_60269878,'$io'(_60269890),_60269894,_60269438):-derefAll(_60269872,_60269054),'System.IOExts.prim_execCmd'(_60269054,_60269890),_60269894=_60269438.

'System.IOExts.evalCmd'(_60270956,_60270958,_60270960,_60270962,_60270964,_60270966):-freeze(_60270964,'blocked_System.IOExts.evalCmd'(_60270956,_60270958,_60270960,_60270962,_60270964,_60270966)).
'blocked_System.IOExts.evalCmd'(_60271062,_60271080,_60271098,_60271674,_60271680,_60271686):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Process.getPID'),partcall(1,'System.IOExts.evalCmd._\'23lambda6',[_60271080,_60271098,_60271062])),_60271674,_60271680,_60271686).

'System.IOExts.evalCmd.wrapArg.4'(_60275096,_60275098,_60275100,_60275102):-freeze(_60275100,'blocked_System.IOExts.evalCmd.wrapArg.4'(_60275096,_60275098,_60275100,_60275102)).
'blocked_System.IOExts.evalCmd.wrapArg.4'(_60275182,_60278968,_60278974,_60278980):-makeShare(_60275182,_60277482),hnf('Prelude.null'(_60277482),_60280558,_60278974,_60280530),'blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'(_60280558,_60277482,_60278968,_60280530,_60278980).

'blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'(_60281044,_60281046,_60281048,_60281050,_60281052):-freeze(_60281050,freeze(_60281044,'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'(_60281044,_60281046,_60281048,_60281050,_60281052))).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'('Prelude.True',_60277482,['^\'','^\''],_60281444,_60281444).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'('Prelude.False',_60277482,_60284684,_60284690,_60284696):-!,makeShare(_60277482,_60282800),hnf('Prelude.apply'('Prelude.all'(partcall(1,'System.IOExts.evalCmd.wrapArg.4.goodChar.6',[])),_60282800),_60287422,_60284690,_60287394),'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'(_60287422,_60282800,_60284684,_60287394,_60284696).

'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'(_60288130,_60288132,_60288134,_60288136,_60288138):-freeze(_60288136,freeze(_60288130,'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'(_60288130,_60288132,_60288134,_60288136,_60288138))).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_60282800,_60288524,_60288530,_60288536):-hnf(_60282800,_60288524,_60288530,_60288536).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_60282800,_60290746,_60290752,_60290758):-!,hnf('Prelude.otherwise',_60294708,_60290752,_60294680),'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_60294708,_60282800,_60290746,_60294680,_60290758).

'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_60295608,_60295610,_60295612,_60295614,_60295616):-freeze(_60295614,freeze(_60295608,'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_60295608,_60295610,_60295612,_60295614,_60295616))).
'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_60282800,['^\''|'Prelude.foldr'(partcall(2,'System.IOExts.evalCmd.wrapArg.4.escape.6',[]),['^\''],_60282800)],_60296008,_60296008).
'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_60282800,_60298300,_60298306,_60298312):-!,hnf(reportFailure4PAKCS('System.IOExts.evalCmd.wrapArg.4',['Prelude.False']),_60298300,_60298306,_60298312).
'blocked_blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_60300100),_60282800,'FAIL'(_60300100),_60300114,_60300114).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_60300174),_60282800,'FAIL'(_60300174),_60300188,_60300188).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4_ComplexCase'('FAIL'(_60300248),_60277482,'FAIL'(_60300248),_60300262,_60300262).

'System.IOExts.evalCmd.wrapArg.4.escape.6'(_60301970,_60301972,_60301974,_60301976,_60301978):-freeze(_60301976,'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6'(_60301970,_60301972,_60301974,_60301976,_60301978)).
'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6'(_60302066,_60302084,_60305824,_60305830,_60305836):-makeShare(_60302066,_60304084),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_60304084,'^\''),_60307752,_60305830,_60307718),'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'(_60307752,_60304084,_60302084,_60305824,_60307718,_60305836).

'blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'(_60308294,_60308296,_60308298,_60308300,_60308302,_60308304):-freeze(_60308302,freeze(_60308294,'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'(_60308294,_60308296,_60308298,_60308300,_60308302,_60308304))).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'('Prelude.True',_60304084,_60302084,_60308698,_60308704,_60308710):-hnf('Prelude.++'(['^\'',^\,'^\'','^\''],_60302084),_60308698,_60308704,_60308710).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'('Prelude.False',_60304084,_60302084,_60311854,_60311860,_60311866):-!,hnf('Prelude.otherwise',_60314930,_60311860,_60314896),'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'(_60314930,_60304084,_60302084,_60311854,_60314896,_60311866).

'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'(_60315682,_60315684,_60315686,_60315688,_60315690,_60315692):-freeze(_60315690,freeze(_60315682,'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'(_60315682,_60315684,_60315686,_60315688,_60315690,_60315692))).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_60304084,_60302084,[_60304084|_60302084],_60316092,_60316092).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_60304084,_60302084,_60317474,_60317480,_60317486):-!,hnf(reportFailure4PAKCS('System.IOExts.evalCmd.wrapArg.4.escape.6',['Prelude.False']),_60317474,_60317480,_60317486).
'blocked_blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_60319252),_60304084,_60302084,'FAIL'(_60319252),_60319266,_60319266).
'blocked_blocked_System.IOExts.evalCmd.wrapArg.4.escape.6_ComplexCase'('FAIL'(_60319334),_60304084,_60302084,'FAIL'(_60319334),_60319348,_60319348).

'System.IOExts.evalCmd.wrapArg.4.goodChar.6'(_60321140,_60321142,_60321144,_60321146):-freeze(_60321144,'blocked_System.IOExts.evalCmd.wrapArg.4.goodChar.6'(_60321140,_60321142,_60321144,_60321146)).
'blocked_System.IOExts.evalCmd.wrapArg.4.goodChar.6'(_60321226,_60322586,_60322592,_60322598):-makeShare(_60321226,_60322702),hnf('Prelude.||'('Prelude.isAlphaNum'(_60322702),'Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_60322702),[^-,'^_',^.,'^,',^/])),_60322586,_60322592,_60322598).

'System.IOExts.evalCmd._\'23lambda6'(_60327054,_60327056,_60327058,_60327060,_60327062,_60327064,_60327066):-freeze(_60327064,'blocked_System.IOExts.evalCmd._\'23lambda6'(_60327054,_60327056,_60327058,_60327060,_60327062,_60327064,_60327066)).
'blocked_System.IOExts.evalCmd._\'23lambda6'(_60327170,_60327188,_60327206,_60327224,_60334788,_60334794,_60334800):-makeShare(_60327252,_60335398),makeShare(_60327270,_60335418),hnf('Prelude.cond'(letrec4PAKCS(_60335398,_60327224),'Prelude.cond'(letrec4PAKCS(_60335418,'Prelude.++'([^/,'^t','^m','^p',^/,'^P','^A','^K','^C','^S','^_','^e','^v','^a','^l','^C','^M','^D'],'Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_60335398))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IOExts.execCmd'('Prelude.++'('Prelude.unwords'('Prelude.map'(partcall(1,'System.IOExts.evalCmd.wrapArg.4',[]),[_60327170|_60327206])),'Prelude.++'(['^ ','^;','^ ','^(','^e','^c','^h','^o','^ ',^$,^?,'^ ',^>,'^ '],'Prelude.++'(_60335418,['^)']))))),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8',[_60335418,_60327188])))),_60334788,_60334794,_60334800).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8'(_60350290,_60350292,_60350294,_60350296,_60350298,_60350300):-freeze(_60350298,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8'(_60350290,_60350292,_60350294,_60350296,_60350298,_60350300)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8'(_60350396,_60350414,_60350432,_60352752,_60352758,_60352764):-hnf(_60350432,_60354766,_60352758,_60354790),'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'(_60354766,_60350396,_60350414,_60352752,_60354790,_60352764).

'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'(_60355324,_60355326,_60355328,_60355330,_60355332,_60355334):-freeze(_60355332,freeze(_60355324,'blocked_blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'(_60355324,_60355326,_60355328,_60355330,_60355332,_60355334))).
'blocked_blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'('Prelude.(,,)'(_60350548,_60350566,_60350584),_60350396,_60350414,_60355734,_60355740,_60355746):-!,makeShare(_60350396,_60356068),makeShare(_60350548,_60356088),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Control.Monad.unless'(partcall(1,'Prelude._inst\'23Prelude.Applicative\'23Prelude.IO\'23',[]),'Prelude.null'(_60356068),'System.IO.hPutStrLn'(_60356088,_60356068))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hClose'(_60356088)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetContents'(_60350566)),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10',[_60350414,_60350584])))),_60355734,_60355740,_60355746).
'blocked_blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8_3'('FAIL'(_60362186),_60350396,_60350414,'FAIL'(_60362186),_60362200,_60362200).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10'(_60364456,_60364458,_60364460,_60364462,_60364464,_60364466):-freeze(_60364464,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10'(_60364456,_60364458,_60364460,_60364462,_60364464,_60364466)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10'(_60364562,_60364580,_60364598,_60365516,_60365522,_60365528):-makeShare(_60364626,_60365744),hnf('Prelude.cond'(letrec4PAKCS(_60365744,_60364598),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetContents'(_60364562)),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12',[_60364580,_60365744]))),_60365516,_60365522,_60365528).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12'(_60371642,_60371644,_60371646,_60371648,_60371650,_60371652):-freeze(_60371650,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12'(_60371642,_60371644,_60371646,_60371648,_60371650,_60371652)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12'(_60371748,_60371766,_60371784,_60372772,_60372778,_60372784):-makeShare(_60371812,_60373038),makeShare(_60371766,_60373058),hnf('Prelude.cond'(letrec4PAKCS(_60373038,_60371784),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IOExts.readCompleteFile'(_60373058)),partcall(1,'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14',[_60373058,_60371748,_60373038]))),_60372772,_60372778,_60372784).

'System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14'(_60379906,_60379908,_60379910,_60379912,_60379914,_60379916,_60379918):-freeze(_60379916,'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14'(_60379906,_60379908,_60379910,_60379912,_60379914,_60379916,_60379918)).
'blocked_System.IOExts.evalCmd._\'23lambda6._\'23lambda8._\'23lambda10._\'23lambda12._\'23lambda14'(_60380022,_60380040,_60380058,_60380076,_60381400,_60381406,_60381412):-makeShare(_60380104,_60381706),hnf('Prelude.cond'(letrec4PAKCS(_60381706,_60380076),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.removeFile'(_60380058)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.(,,)'('Prelude.read'(partcall(1,'Prelude._inst\'23Prelude.Read\'23Prelude.Int\'23',[]),_60381706),_60380040,_60380022)))),_60381400,_60381406,_60381412).

'System.IOExts.connectToCommand'(_60387356,_60387358,_60387360,_60387362):-freeze(_60387360,'blocked_System.IOExts.connectToCommand'(_60387356,_60387358,_60387360,_60387362)).
'blocked_System.IOExts.connectToCommand'(_60387442,_60387626,_60387632,_60387638):-hnf('Prelude.$##'(partcall(1,'System.IOExts.prim_connectToCmd',[]),_60387442),_60387626,_60387632,_60387638).

'System.IOExts.prim_connectToCmd'(_60388826,partcall(1,'System.IOExts.prim_connectToCmd$WORLD',[_60388826]),_60389270,_60389270).
'System.IOExts.prim_connectToCmd$WORLD'(_60389644,_60389646,_60389648,_60389650,_60389652):-freeze(_60389650,'blocked_System.IOExts.prim_connectToCmd$WORLD'(_60389644,_60389646,_60389648,_60389650,_60389652)).
'blocked_System.IOExts.prim_connectToCmd$WORLD'(_60389734,_60389740,'$io'(_60389752),_60389756,_60389270):-derefAll(_60389734,_60388826),'System.IOExts.prim_connectToCmd'(_60388826,_60389752),_60389756=_60389270.

'System.IOExts.readCompleteFile'(_60391160,_60391162,_60391164,_60391166):-freeze(_60391164,'blocked_System.IOExts.readCompleteFile'(_60391160,_60391162,_60391164,_60391166)).
'blocked_System.IOExts.readCompleteFile'(_60391246,_60391682,_60391688,_60391694):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_60391246)),partcall(1,'System.IOExts.readCompleteFile._\'23lambda17',[])),_60391682,_60391688,_60391694).

'System.IOExts.readCompleteFile.f.21'(_60394962,_60394964,_60394966,_60394968,_60394970):-freeze(_60394968,'blocked_System.IOExts.readCompleteFile.f.21'(_60394962,_60394964,_60394966,_60394968,_60394970)).
'blocked_System.IOExts.readCompleteFile.f.21'(_60395058,_60395076,_60395772,_60395778,_60395784):-hnf(_60395058,_60397418,_60395778,_60397436),'blocked_System.IOExts.readCompleteFile.f.21_1'(_60397418,_60395076,_60395772,_60397436,_60395784).

'blocked_System.IOExts.readCompleteFile.f.21_1'(_60397896,_60397898,_60397900,_60397902,_60397904):-freeze(_60397902,'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'(_60397896,_60397898,_60397900,_60397902,_60397904)).
'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'([],_60395076,_60398148,_60398154,_60398160):-hnf(_60395076,_60398148,_60398154,_60398160).
'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'([_60395278|_60395296],_60395076,_60398852,_60398858,_60398864):-!,hnf('System.IOExts.readCompleteFile.f.21'(_60395296,_60395076),_60398852,_60398858,_60398864).
'blocked_blocked_System.IOExts.readCompleteFile.f.21_1'('FAIL'(_60399940),_60395076,'FAIL'(_60399940),_60399954,_60399954):-nonvar(_60399940).

'System.IOExts.readCompleteFile._\'23lambda17'(_60401732,_60401734,_60401736,_60401738):-freeze(_60401736,'blocked_System.IOExts.readCompleteFile._\'23lambda17'(_60401732,_60401734,_60401736,_60401738)).
'blocked_System.IOExts.readCompleteFile._\'23lambda17'(_60401818,_60402498,_60402504,_60402510):-makeShare(_60401846,_60402632),hnf('Prelude.cond'(letrec4PAKCS(_60402632,_60401818),'System.IOExts.readCompleteFile.f.21'(_60402632,'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_60402632))),_60402498,_60402504,_60402510).

'System.IOExts.updateFile'(_60405954,_60405956,_60405958,_60405960,_60405962):-freeze(_60405960,'blocked_System.IOExts.updateFile'(_60405954,_60405956,_60405958,_60405960,_60405962)).
'blocked_System.IOExts.updateFile'(_60406050,_60406068,_60406644,_60406650,_60406656):-makeShare(_60406068,_60406772),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IOExts.readCompleteFile'(_60406772)),partcall(1,'System.IOExts.updateFile._\'23lambda20',[_60406050,_60406772])),_60406644,_60406650,_60406656).

'System.IOExts.updateFile._\'23lambda20'(_60410480,_60410482,_60410484,_60410486,_60410488,_60410490):-freeze(_60410488,'blocked_System.IOExts.updateFile._\'23lambda20'(_60410480,_60410482,_60410484,_60410486,_60410488,_60410490)).
'blocked_System.IOExts.updateFile._\'23lambda20'(_60410586,_60410604,_60410622,_60411288,_60411294,_60411300):-makeShare(_60410650,_60411510),hnf('Prelude.cond'(letrec4PAKCS(_60411510,_60410622),'Prelude.writeFile'(_60410586,'Prelude.apply'(_60410604,_60411510))),_60411288,_60411294,_60411300).

'System.IOExts.exclusiveIO'(_60414514,_60414516,_60414518,_60414520,_60414522):-freeze(_60414520,'blocked_System.IOExts.exclusiveIO'(_60414514,_60414516,_60414518,_60414520,_60414522)).
'blocked_System.IOExts.exclusiveIO'(_60414610,_60414628,_60425248,_60425254,_60425260):-makeShare(_60414656,_60425706),makeShare(_60414610,_60425726),hnf('Prelude.cond'(letrec4PAKCS(_60425706,'Prelude.$'(partcall(1,'System.Process.system',[]),'Prelude.++'(['^l','^o','^c','^k','^f','^i','^l','^e',^-,'^r','^e','^m','^o','^v','^e','^ ',^-,^-,'^l','^o','^c','^k',^-,'^n','^a','^m','^e','^ '],_60425726))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'System.Process.system',[]),'Prelude.++'(['^l','^o','^c','^k','^f','^i','^l','^e',^-,'^c','^r','^e','^a','^t','^e','^ ',^-,^-,'^l','^o','^c','^k',^-,'^n','^a','^m','^e','^ '],_60425726))),'Prelude.catch'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23',_60414628),partcall(1,'System.IOExts.exclusiveIO._\'23lambda23',[_60425706])),partcall(1,'System.IOExts.exclusiveIO._\'23lambda25',[_60425706])))),_60425248,_60425254,_60425260).

'System.IOExts.exclusiveIO._\'23lambda23'(_60444064,_60444066,_60444068,_60444070,_60444072):-freeze(_60444070,'blocked_System.IOExts.exclusiveIO._\'23lambda23'(_60444064,_60444066,_60444068,_60444070,_60444072)).
'blocked_System.IOExts.exclusiveIO._\'23lambda23'(_60444160,_60444178,_60445026,_60445032,_60445038):-makeShare(_60444206,_60445196),hnf('Prelude.cond'(letrec4PAKCS(_60445196,_60444178),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23',_60444160),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_60445196))),_60445026,_60445032,_60445038).

'System.IOExts.exclusiveIO._\'23lambda25'(_60449532,_60449534,_60449536,_60449538,_60449540):-freeze(_60449538,'blocked_System.IOExts.exclusiveIO._\'23lambda25'(_60449532,_60449534,_60449536,_60449538,_60449540)).
'blocked_System.IOExts.exclusiveIO._\'23lambda25'(_60449628,_60449646,_60450068,_60450074,_60450080):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23',_60449628),'Prelude.ioError'(_60449646)),_60450068,_60450074,_60450080).

:-costCenters(['']).




%%%%% Number of shared variables: 18

:-style_check(-singleton).
'System.IOExts.prim_execCmd'(_60451754,'Prelude.(,,)'(_60451746,_60451748,_60451750)):-string2Atom(_60451754,_60451762),execCommand(_60451762,_60451746,_60451748,_60451750).
'System.IOExts.prim_connectToCmd'(_60451854,'$stream'('$inoutstream'(_60451844,_60451846))):-string2Atom(_60451854,_60451862),execCommand(_60451862,_60451846,_60451844,std).
