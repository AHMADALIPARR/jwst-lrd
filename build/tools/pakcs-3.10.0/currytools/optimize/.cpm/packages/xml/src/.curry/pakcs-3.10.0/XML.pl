%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Numeric').
:-importModule('Prelude').

:-curryModule('XML').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('XML._inst\'23Prelude.Data\'23XML.XmlExp\'23','_inst#Prelude.Data#XML.XmlExp#',1,'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23','_impl#===#Prelude.Data#XML.XmlExp#',2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23','_impl#aValue#Prelude.Data#XML.XmlExp#',0,'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._inst\'23Prelude.Data\'23XML.Encoding\'23','_inst#Prelude.Data#XML.Encoding#',1,'XML._inst\'23Prelude.Data\'23XML.Encoding\'23',nofix,notype).
functiontype('XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23','_impl#===#Prelude.Data#XML.Encoding#',2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23',nofix,notype).
functiontype('XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23','_impl#aValue#Prelude.Data#XML.Encoding#',0,'XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23',nofix,notype).
functiontype('XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23','_inst#Prelude.Data#XML.XmlDocParams#',1,'XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23',nofix,notype).
functiontype('XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23','_impl#===#Prelude.Data#XML.XmlDocParams#',2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23',nofix,notype).
functiontype('XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23','_impl#aValue#Prelude.Data#XML.XmlDocParams#',0,'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23',nofix,notype).
functiontype('XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23','_inst#Prelude.Eq#XML.XmlExp#',1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23','_impl#==#Prelude.Eq#XML.XmlExp#',2,'XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23','_impl#/=#Prelude.Eq#XML.XmlExp#',0,'XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23','_inst#Prelude.Ord#XML.XmlExp#',1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#compare#Prelude.Ord#XML.XmlExp#',0,'XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#<#Prelude.Ord#XML.XmlExp#',0,'XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#>#Prelude.Ord#XML.XmlExp#',0,'XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#<=#Prelude.Ord#XML.XmlExp#',2,'XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#>=#Prelude.Ord#XML.XmlExp#',0,'XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#min#Prelude.Ord#XML.XmlExp#',0,'XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23','_impl#max#Prelude.Ord#XML.XmlExp#',0,'XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._inst\'23Prelude.Show\'23XML.XmlExp\'23','_inst#Prelude.Show#XML.XmlExp#',1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23','_impl#show#Prelude.Show#XML.XmlExp#',0,'XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23','_impl#showsPrec#Prelude.Show#XML.XmlExp#',2,'XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23','_impl#showList#Prelude.Show#XML.XmlExp#',0,'XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23',nofix,notype).
functiontype('XML.encoding2Attribute','XML.encoding2Attribute',1,'XML.encoding2Attribute',nofix,notype).
functiontype('XML.encoding2EncFunc','XML.encoding2EncFunc',1,'XML.encoding2EncFunc',nofix,notype).
functiontype('XML.standardEncoding','XML.standardEncoding',1,'XML.standardEncoding',nofix,notype).
functiontype('XML.iso88591Encoding','XML.iso88591Encoding',1,'XML.iso88591Encoding',nofix,notype).
functiontype('XML.iso88591list','XML.iso88591list',0,'XML.iso88591list',nofix,notype).
functiontype('XML.lookupEncoding','XML.lookupEncoding',1,'XML.lookupEncoding',nofix,notype).
functiontype('XML.lookupDtdUrl','XML.lookupDtdUrl',1,'XML.lookupDtdUrl',nofix,notype).
functiontype('XML.hasDtdUrl','XML.hasDtdUrl',1,'XML.hasDtdUrl',nofix,notype).
functiontype('XML.tagOf',tagOf,1,'XML.tagOf',nofix,notype).
functiontype('XML.elemsOf',elemsOf,1,'XML.elemsOf',nofix,notype).
functiontype('XML.textOf',textOf,0,'XML.textOf',nofix,notype).
functiontype('XML.textOf.textOfXmlExp.59','XML.textOf.textOfXmlExp.59',1,'XML.textOf.textOfXmlExp.59',nofix,notype).
functiontype('XML.textOfXml',textOfXml,0,'XML.textOfXml',nofix,notype).
functiontype('XML.xtxt',xtxt,1,'XML.xtxt',nofix,notype).
functiontype('XML.xml',xml,2,'XML.xml',nofix,notype).
functiontype('XML.writeXmlFile',writeXmlFile,2,'XML.writeXmlFile',nofix,notype).
functiontype('XML.writeXmlFileWithParams',writeXmlFileWithParams,3,'XML.writeXmlFileWithParams',nofix,notype).
functiontype('XML.showXmlDoc',showXmlDoc,1,'XML.showXmlDoc',nofix,notype).
functiontype('XML.showXmlDocWithParams',showXmlDocWithParams,2,'XML.showXmlDocWithParams',nofix,notype).
functiontype('XML.showXmlExp','XML.showXmlExp',3,'XML.showXmlExp',nofix,notype).
functiontype('XML.showXmlExp._\'23selFP2\'23s','XML.showXmlExp._#selFP2#s',1,'XML.showXmlExp._\'23selFP2\'23s',nofix,notype).
functiontype('XML.xtab','XML.xtab',1,'XML.xtab',nofix,notype).
functiontype('XML.showXmlOpenTag','XML.showXmlOpenTag',3,'XML.showXmlOpenTag',nofix,notype).
functiontype('XML.showXmlOpenTag.attr2string.93','XML.showXmlOpenTag.attr2string.93',2,'XML.showXmlOpenTag.attr2string.93',nofix,notype).
functiontype('XML.showXmlExps','XML.showXmlExps',3,'XML.showXmlExps',nofix,notype).
functiontype('XML.isXText','XML.isXText',1,'XML.isXText',nofix,notype).
functiontype('XML.xmlUnquoteSpecials','XML.xmlUnquoteSpecials',1,'XML.xmlUnquoteSpecials',nofix,notype).
functiontype('XML.xmlUnquoteSpecials._\'23selFP4\'23special','XML.xmlUnquoteSpecials._#selFP4#special',1,'XML.xmlUnquoteSpecials._\'23selFP4\'23special',nofix,notype).
functiontype('XML.xmlUnquoteSpecials._\'23selFP5\'23rest','XML.xmlUnquoteSpecials._#selFP5#rest',1,'XML.xmlUnquoteSpecials._\'23selFP5\'23rest',nofix,notype).
functiontype('XML.xmlUnquoteSpecial','XML.xmlUnquoteSpecial',2,'XML.xmlUnquoteSpecial',nofix,notype).
functiontype('XML.unquoteUnicode','XML.unquoteUnicode',1,'XML.unquoteUnicode',nofix,notype).
functiontype('XML.unquoteUnicode.extr.117','XML.unquoteUnicode.extr.117',3,'XML.unquoteUnicode.extr.117',nofix,notype).
functiontype('XML.readXmlFile',readXmlFile,1,'XML.readXmlFile',nofix,notype).
functiontype('XML.readXmlFile._\'23lambda4','XML.readXmlFile._#lambda4',2,'XML.readXmlFile._\'23lambda4',nofix,notype).
functiontype('XML.readUnsafeXmlFile',readUnsafeXmlFile,1,'XML.readUnsafeXmlFile',nofix,notype).
functiontype('XML.readUnsafeXmlFile._\'23lambda6','XML.readUnsafeXmlFile._#lambda6',1,'XML.readUnsafeXmlFile._\'23lambda6',nofix,notype).
functiontype('XML.showXmlFile','XML.showXmlFile',1,'XML.showXmlFile',nofix,notype).
functiontype('XML.readFileWithXmlDocs',readFileWithXmlDocs,1,'XML.readFileWithXmlDocs',nofix,notype).
functiontype('XML.parseXmlString',parseXmlString,1,'XML.parseXmlString',nofix,notype).
functiontype('XML.parseXmlTokens','XML.parseXmlTokens',2,'XML.parseXmlTokens',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP7\'23xexps','XML.parseXmlTokens._#selFP7#xexps',1,'XML.parseXmlTokens._\'23selFP7\'23xexps',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP8\'23rem_xtokens','XML.parseXmlTokens._#selFP8#rem_xtokens',1,'XML.parseXmlTokens._\'23selFP8\'23rem_xtokens',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP13\'23xexps1','XML.parseXmlTokens._#selFP13#xexps1',1,'XML.parseXmlTokens._\'23selFP13\'23xexps1',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP14\'23xtokens1','XML.parseXmlTokens._#selFP14#xtokens1',1,'XML.parseXmlTokens._\'23selFP14\'23xtokens1',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP11\'23xexps','XML.parseXmlTokens._#selFP11#xexps',1,'XML.parseXmlTokens._\'23selFP11\'23xexps',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP12\'23rem_xtokens','XML.parseXmlTokens._#selFP12#rem_xtokens',1,'XML.parseXmlTokens._\'23selFP12\'23rem_xtokens',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP16\'23xexps','XML.parseXmlTokens._#selFP16#xexps',1,'XML.parseXmlTokens._\'23selFP16\'23xexps',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP17\'23rem_xtokens','XML.parseXmlTokens._#selFP17#rem_xtokens',1,'XML.parseXmlTokens._\'23selFP17\'23rem_xtokens',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP19\'23xexps','XML.parseXmlTokens._#selFP19#xexps',1,'XML.parseXmlTokens._\'23selFP19\'23xexps',nofix,notype).
functiontype('XML.parseXmlTokens._\'23selFP20\'23rem_xtokens','XML.parseXmlTokens._#selFP20#rem_xtokens',1,'XML.parseXmlTokens._\'23selFP20\'23rem_xtokens',nofix,notype).
functiontype('XML.scanXmlString','XML.scanXmlString',1,'XML.scanXmlString',nofix,notype).
functiontype('XML.scanXmlString.scanXml.169','XML.scanXmlString.scanXml.169',1,'XML.scanXmlString.scanXml.169',nofix,notype).
functiontype('XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt','XML.scanXmlString.scanXml.169._#selFP22#initxt',1,'XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt',nofix,notype).
functiontype('XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag','XML.scanXmlString.scanXml.169._#selFP23#remtag',1,'XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag',nofix,notype).
functiontype('XML.scanXmlText','XML.scanXmlText',1,'XML.scanXmlText',nofix,notype).
functiontype('XML.scanXmlText._\'23selFP25\'23txt','XML.scanXmlText._#selFP25#txt',1,'XML.scanXmlText._\'23selFP25\'23txt',nofix,notype).
functiontype('XML.scanXmlText._\'23selFP26\'23rem','XML.scanXmlText._#selFP26#rem',1,'XML.scanXmlText._\'23selFP26\'23rem',nofix,notype).
functiontype('XML.scanXmlText._\'23selFP28\'23txt','XML.scanXmlText._#selFP28#txt',1,'XML.scanXmlText._\'23selFP28\'23txt',nofix,notype).
functiontype('XML.scanXmlText._\'23selFP29\'23rem','XML.scanXmlText._#selFP29#rem',1,'XML.scanXmlText._\'23selFP29\'23rem',nofix,notype).
functiontype('XML.scanXmlElem','XML.scanXmlElem',1,'XML.scanXmlElem',nofix,notype).
functiontype('XML.scanXmlElemName','XML.scanXmlElemName',2,'XML.scanXmlElemName',nofix,notype).
functiontype('XML.scanXmlElemName._\'23selFP31\'23attrs','XML.scanXmlElemName._#selFP31#attrs',1,'XML.scanXmlElemName._\'23selFP31\'23attrs',nofix,notype).
functiontype('XML.scanXmlElemName._\'23selFP32\'23rest','XML.scanXmlElemName._#selFP32#rest',1,'XML.scanXmlElemName._\'23selFP32\'23rest',nofix,notype).
functiontype('XML.scanXmlComment','XML.scanXmlComment',1,'XML.scanXmlComment',nofix,notype).
functiontype('XML.scanXmlCData','XML.scanXmlCData',1,'XML.scanXmlCData',nofix,notype).
functiontype('XML.dropCData','XML.dropCData',1,'XML.dropCData',nofix,notype).
functiontype('XML.scanXmlProcInstr','XML.scanXmlProcInstr',1,'XML.scanXmlProcInstr',nofix,notype).
functiontype('XML.parseAttrs','XML.parseAttrs',1,'XML.parseAttrs',nofix,notype).
functiontype('XML.parseAttrs._\'23selFP40\'23name','XML.parseAttrs._#selFP40#name',1,'XML.parseAttrs._\'23selFP40\'23name',nofix,notype).
functiontype('XML.parseAttrs._\'23selFP41\'23rest1','XML.parseAttrs._#selFP41#rest1',1,'XML.parseAttrs._\'23selFP41\'23rest1',nofix,notype).
functiontype('XML.parseAttrs._\'23selFP38\'23value','XML.parseAttrs._#selFP38#value',1,'XML.parseAttrs._\'23selFP38\'23value',nofix,notype).
functiontype('XML.parseAttrs._\'23selFP39\'23rest2','XML.parseAttrs._#selFP39#rest2',1,'XML.parseAttrs._\'23selFP39\'23rest2',nofix,notype).
functiontype('XML.parseAttrs._\'23selFP36\'23rem_attrs','XML.parseAttrs._#selFP36#rem_attrs',1,'XML.parseAttrs._\'23selFP36\'23rem_attrs',nofix,notype).
functiontype('XML.parseAttrs._\'23selFP37\'23rem_inp','XML.parseAttrs._#selFP37#rem_inp',1,'XML.parseAttrs._\'23selFP37\'23rem_inp',nofix,notype).
functiontype('XML.dropBlanks','XML.dropBlanks',0,'XML.dropBlanks',nofix,notype).
functiontype('XML.splitAtChar','XML.splitAtChar',2,'XML.splitAtChar',nofix,notype).
functiontype('XML.splitAtChar._\'23selFP43\'23first','XML.splitAtChar._#selFP43#first',1,'XML.splitAtChar._\'23selFP43\'23first',nofix,notype).
functiontype('XML.splitAtChar._\'23selFP44\'23rest','XML.splitAtChar._#selFP44#rest',1,'XML.splitAtChar._\'23selFP44\'23rest',nofix,notype).
functiontype('XML.updateXmlFile',updateXmlFile,2,'XML.updateXmlFile',nofix,notype).
functiontype('XML.updateXmlFile._\'23lambda8','XML.updateXmlFile._#lambda8',3,'XML.updateXmlFile._\'23lambda8',nofix,notype).
functiontype('XML.showXmlDocWithParams._\'23caseor0','XML.showXmlDocWithParams._#caseor0',1,'XML.showXmlDocWithParams._\'23caseor0',nofix,notype).
functiontype('XML.showXmlDocWithParams._\'23caseor0._\'23caseor0','XML.showXmlDocWithParams._#caseor0._#caseor0',3,'XML.showXmlDocWithParams._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('XML.showXmlExp._\'23caseor0','XML.showXmlExp._#caseor0',5,'XML.showXmlExp._\'23caseor0',nofix,notype).
functiontype('XML.unquoteUnicode._\'23caseor0','XML.unquoteUnicode._#caseor0',4,'XML.unquoteUnicode._\'23caseor0',nofix,notype).
functiontype('XML.readXmlFile._\'23lambda4._\'23caseor0','XML.readXmlFile._#lambda4._#caseor0',3,'XML.readXmlFile._\'23lambda4._\'23caseor0',nofix,notype).
functiontype('XML.scanXmlText._\'23caseor0','XML.scanXmlText._#caseor0',2,'XML.scanXmlText._\'23caseor0',nofix,notype).
functiontype('XML.scanXmlElemName._\'23caseor0','XML.scanXmlElemName._#caseor0',4,'XML.scanXmlElemName._\'23caseor0',nofix,notype).
functiontype('XML.scanXmlCData._\'23caseor0','XML.scanXmlCData._#caseor0',2,'XML.scanXmlCData._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('XML.XText','XText',1,'XText',0,notype,['XML.XElem'/3]).
constructortype('XML.XElem','XElem',3,'XElem',1,notype,['XML.XText'/1]).
constructortype('XML.StandardEnc','StandardEnc',0,'StandardEnc',0,notype,['XML.Iso88591Enc'/0]).
constructortype('XML.Iso88591Enc','Iso88591Enc',0,'Iso88591Enc',1,notype,['XML.StandardEnc'/0]).
constructortype('XML.Enc','Enc',1,'Enc',0,notype,['XML.DtdUrl'/1]).
constructortype('XML.DtdUrl','DtdUrl',1,'DtdUrl',1,notype,['XML.Enc'/1]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23'(_19544954,_19544956,_19544958,_19544960):-freeze(_19544958,'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23'(_19544954,_19544956,_19544958,_19544960)).
'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23'(_19545040,_19545660,_19545666,_19545672):-hnf(_19545040,_19547478,_19545666,_19547490),'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'(_19547478,_19545660,_19547490,_19545672).

'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'(_19547972,_19547974,_19547976,_19547978):-freeze(_19547976,'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'(_19547972,_19547974,_19547976,_19547978)).
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23',[]),'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'),_19548324,_19548324):-!.
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'('FAIL'(_19549758),'FAIL'(_19549758),_19549772,_19549772):-nonvar(_19549758).

'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23'(_19551628,_19551630,_19551632,_19551634,_19551636):-freeze(_19551634,'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23'(_19551628,_19551630,_19551632,_19551634,_19551636)).
'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23'(_19551724,_19551742,_19554630,_19554636,_19554642):-hnf(_19551724,_19556888,_19554636,_19556906),'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'(_19556888,_19551742,_19554630,_19556906,_19554642).

'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'(_19557468,_19557470,_19557472,_19557474,_19557476):-freeze(_19557474,'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'(_19557468,_19557470,_19557472,_19557474,_19557476)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'('XML.XText'(_19551858),_19551742,_19558288,_19558294,_19558300):-hnf(_19551742,_19561206,_19558294,_19561224),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'(_19561206,_19551858,_19558288,_19561224,_19558300).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'(_19561906,_19561908,_19561910,_19561912,_19561914):-freeze(_19561912,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'(_19561906,_19561908,_19561910,_19561912,_19561914)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XText'(_19551980),_19551858,_19562268,_19562274,_19562280):-hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_19551858,_19551980),_19562268,_19562274,_19562280).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XElem'(_19552328,_19552346,_19552364),_19551858,'Prelude.False',_19564328,_19564328):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'('FAIL'(_19565344),_19551858,'FAIL'(_19565344),_19565358,_19565358):-nonvar(_19565344).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'('XML.XElem'(_19552506,_19552524,_19552542),_19551742,_19566184,_19566190,_19566196):-!,hnf(_19551742,_19569102,_19566190,_19569132),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'(_19569102,_19552506,_19552524,_19552542,_19566184,_19569132,_19566196).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'(_19569848,_19569850,_19569852,_19569854,_19569856,_19569858,_19569860):-freeze(_19569858,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'(_19569848,_19569850,_19569852,_19569854,_19569856,_19569858,_19569860)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XText'(_19552676),_19552506,_19552524,_19552542,'Prelude.False',_19570236,_19570236).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XElem'(_19552800,_19552818,_19552836),_19552506,_19552524,_19552542,_19571544,_19571550,_19571556):-!,hnf('Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_19552506,_19552800),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])]),_19552524,_19552818)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23',[]),_19552542,_19552836)),_19571544,_19571550,_19571556).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'('FAIL'(_19577958),_19552506,_19552524,_19552542,'FAIL'(_19577958),_19577972,_19577972):-nonvar(_19577958).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'('FAIL'(_19578052),_19551742,'FAIL'(_19578052),_19578066,_19578066):-nonvar(_19578052).

'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'(_19579960,_19579962,_19579964):-freeze(_19579962,'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'(_19579960,_19579962,_19579964)).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'('XML.XText'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]))),_19581150,_19581150).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'('XML.XElem'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])),'Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])])),'Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23',[]))),_19582496,_19582496).

'XML._inst\'23Prelude.Data\'23XML.Encoding\'23'(_19588764,_19588766,_19588768,_19588770):-freeze(_19588768,'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23'(_19588764,_19588766,_19588768,_19588770)).
'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23'(_19588850,_19589482,_19589488,_19589494):-hnf(_19588850,_19591372,_19589488,_19591384),'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'(_19591372,_19589482,_19591384,_19589494).

'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'(_19591878,_19591880,_19591882,_19591884):-freeze(_19591882,'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'(_19591878,_19591880,_19591882,_19591884)).
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23',[]),'XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'),_19592230,_19592230):-!.
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'('FAIL'(_19593700),'FAIL'(_19593700),_19593714,_19593714):-nonvar(_19593700).

'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_19595646,_19595648,_19595650,_19595652,_19595654):-freeze(_19595652,'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_19595646,_19595648,_19595650,_19595652,_19595654)).
'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_19595742,_19595760,_19596804,_19596810,_19596816):-hnf(_19595742,_19599134,_19596810,_19599152),'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'(_19599134,_19595760,_19596804,_19599152,_19596816).

'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'(_19599726,_19599728,_19599730,_19599732,_19599734):-freeze(_19599732,'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'(_19599726,_19599728,_19599730,_19599732,_19599734)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'('XML.StandardEnc',_19595760,_19600612,_19600618,_19600624):-hnf(_19595760,_19603782,_19600618,_19603794),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'(_19603782,_19600612,_19603794,_19600624).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'(_19604516,_19604518,_19604520,_19604522):-freeze(_19604520,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'(_19604516,_19604518,_19604520,_19604522)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'('XML.StandardEnc','Prelude.True',_19604936,_19604936).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'('XML.Iso88591Enc','Prelude.False',_19606050,_19606050):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'('FAIL'(_19606842),'FAIL'(_19606842),_19606856,_19606856):-nonvar(_19606842).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'('XML.Iso88591Enc',_19595760,_19607708,_19607714,_19607720):-!,hnf(_19595760,_19610878,_19607714,_19610890),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'(_19610878,_19607708,_19610890,_19607720).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'(_19611630,_19611632,_19611634,_19611636):-freeze(_19611634,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'(_19611630,_19611632,_19611634,_19611636)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'('XML.StandardEnc','Prelude.False',_19612050,_19612050).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'('XML.Iso88591Enc','Prelude.True',_19613170,_19613170):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'('FAIL'(_19613956),'FAIL'(_19613956),_19613970,_19613970):-nonvar(_19613956).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'('FAIL'(_19614026),_19595760,'FAIL'(_19614026),_19614040,_19614040):-nonvar(_19614026).

'XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'(_19616010,_19616012,_19616014):-freeze(_19616012,'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'(_19616010,_19616012,_19616014)).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'('XML.StandardEnc',_19616192,_19616192).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'('XML.Iso88591Enc',_19616742,_19616742).

'XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19619056,_19619058,_19619060,_19619062):-freeze(_19619060,'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19619056,_19619058,_19619060,_19619062)).
'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19619142,_19619798,_19619804,_19619810):-hnf(_19619142,_19621832,_19619804,_19621844),'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_19621832,_19619798,_19621844,_19619810).

'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_19622362,_19622364,_19622366,_19622368):-freeze(_19622366,'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_19622362,_19622364,_19622366,_19622368)).
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23',[]),'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'),_19622714,_19622714):-!.
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('FAIL'(_19624256),'FAIL'(_19624256),_19624270,_19624270):-nonvar(_19624256).

'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19626354,_19626356,_19626358,_19626360,_19626362):-freeze(_19626360,'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19626354,_19626356,_19626358,_19626360,_19626362)).
'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19626450,_19626468,_19628044,_19628050,_19628056):-hnf(_19626450,_19630518,_19628050,_19630536),'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_19630518,_19626468,_19628044,_19630536,_19628056).

'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_19631134,_19631136,_19631138,_19631140,_19631142):-freeze(_19631140,'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_19631134,_19631136,_19631138,_19631140,_19631142)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('XML.Enc'(_19626584),_19626468,_19631966,_19631972,_19631978):-hnf(_19626468,_19635040,_19631972,_19635058),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'(_19635040,_19626584,_19631966,_19635058,_19631978).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'(_19635764,_19635766,_19635768,_19635770,_19635772):-freeze(_19635770,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'(_19635764,_19635766,_19635768,_19635770,_19635772)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'('XML.Enc'(_19626706),_19626584,_19636102,_19636108,_19636114):-hnf('XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_19626584,_19626706),_19636102,_19636108,_19636114).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'('XML.DtdUrl'(_19626970),_19626584,'Prelude.False',_19637760,_19637760):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'('FAIL'(_19638668),_19626584,'FAIL'(_19638668),_19638682,_19638682):-nonvar(_19638668).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('XML.DtdUrl'(_19627100),_19626468,_19639524,_19639530,_19639536):-!,hnf(_19626468,_19642688,_19639530,_19642706),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'(_19642688,_19627100,_19639524,_19642706,_19639536).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'(_19643448,_19643450,_19643452,_19643454,_19643456):-freeze(_19643454,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'(_19643448,_19643450,_19643452,_19643454,_19643456)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'('XML.Enc'(_19627222),_19627100,'Prelude.False',_19643792,_19643792).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'('XML.DtdUrl'(_19627346),_19627100,_19644990,_19644996,_19645002):-!,hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_19627100,_19627346),_19644990,_19644996,_19645002).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'('FAIL'(_19646816),_19627100,'FAIL'(_19646816),_19646830,_19646830):-nonvar(_19646816).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('FAIL'(_19646894),_19626468,'FAIL'(_19646894),_19646908,_19646908):-nonvar(_19646894).

'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19649030,_19649032,_19649034):-freeze(_19649032,'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'(_19649030,_19649032,_19649034)).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'('XML.Enc'('XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'),_19649464,_19649464).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'('XML.DtdUrl'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]))),_19650410,_19650410).

'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23'(_19653258,_19653260,_19653262,_19653264):-freeze(_19653262,'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23'(_19653258,_19653260,_19653262,_19653264)).
'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23'(_19653344,_19653952,_19653958,_19653964):-hnf(_19653344,_19655698,_19653958,_19655710),'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_19655698,_19653952,_19655710,_19653964).

'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_19656180,_19656182,_19656184,_19656186):-freeze(_19656184,'blocked_blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_19656180,_19656182,_19656184,_19656186)).
'blocked_blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Eq'(partcall(2,'XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23',[]),'XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'),_19656532,_19656532):-!.
'blocked_blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'('FAIL'(_19657900),'FAIL'(_19657900),_19657914,_19657914):-nonvar(_19657900).

'XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_19659628,_19659630,_19659632,_19659634,_19659636):-freeze(_19659634,'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_19659628,_19659630,_19659632,_19659634,_19659636)).
'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_19659724,_19659742,_19662600,_19662606,_19662612):-hnf(_19659724,_19664678,_19662606,_19664696),'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_19664678,_19659742,_19662600,_19664696,_19662612).

'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_19665228,_19665230,_19665232,_19665234,_19665236):-freeze(_19665234,'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_19665228,_19665230,_19665232,_19665234,_19665236)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'('XML.XText'(_19659858),_19659742,_19666018,_19666024,_19666030):-hnf(_19659742,_19668756,_19666024,_19668774),'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'(_19668756,_19659858,_19666018,_19668774,_19666030).

'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'(_19669426,_19669428,_19669430,_19669432,_19669434):-freeze(_19669432,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'(_19669426,_19669428,_19669430,_19669432,_19669434)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XText'(_19659980),_19659858,_19669788,_19669794,_19669800):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_19659858,_19659980),_19669788,_19669794,_19669800).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XElem'(_19660328,_19660346,_19660364),_19659858,'Prelude.False',_19671776,_19671776):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'('FAIL'(_19672762),_19659858,'FAIL'(_19672762),_19672776,_19672776):-nonvar(_19672762).
'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'('XML.XElem'(_19660506,_19660524,_19660542),_19659742,_19673572,_19673578,_19673584):-!,hnf(_19659742,_19676310,_19673578,_19676340),'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'(_19676310,_19660506,_19660524,_19660542,_19673572,_19676340,_19673584).

'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'(_19677026,_19677028,_19677030,_19677032,_19677034,_19677036,_19677038):-freeze(_19677036,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'(_19677026,_19677028,_19677030,_19677032,_19677034,_19677036,_19677038)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XText'(_19660676),_19660506,_19660524,_19660542,'Prelude.False',_19677414,_19677414).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XElem'(_19660800,_19660818,_19660836),_19660506,_19660524,_19660542,_19678692,_19678698,_19678704):-!,hnf('Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_19660506,_19660800),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_19660524,_19660818)),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',[]),_19660542,_19660836)),_19678692,_19678698,_19678704).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'('FAIL'(_19684902),_19660506,_19660524,_19660542,'FAIL'(_19684902),_19684916,_19684916):-nonvar(_19684902).
'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'('FAIL'(_19684996),_19659742,'FAIL'(_19684996),_19685010,_19685010):-nonvar(_19684996).

'XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_19686732,_19686734,_19686736):-freeze(_19686734,'blocked_XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_19686732,_19686734,_19686736)).
'blocked_XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_19686904,_19686910,_19686916):-hnf(partcall(2,'Prelude._def\'23\'2F\'3D\'23Prelude.Eq',[partcall(1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',[])]),_19686904,_19686910,_19686916).

'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23'(_19689422,_19689424,_19689426,_19689428):-freeze(_19689426,'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23'(_19689422,_19689424,_19689426,_19689428)).
'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23'(_19689508,_19690626,_19690632,_19690638):-hnf(_19689508,_19692408,_19690632,_19692420),'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_19692408,_19690626,_19692420,_19690638).

'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_19692896,_19692898,_19692900,_19692902):-freeze(_19692900,'blocked_blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_19692896,_19692898,_19692900,_19692902)).
'blocked_blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Ord'(partcall(1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',[]),'XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23',partcall(2,'XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23',[]),'XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'),_19693248,_19693248):-!.
'blocked_blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'('FAIL'(_19696918),'FAIL'(_19696918),_19696932,_19696932):-nonvar(_19696918).

'XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23'(_19698818,_19698820,_19698822):-freeze(_19698820,'blocked_XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23'(_19698818,_19698820,_19698822)).
'blocked_XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23'(_19698990,_19698996,_19699002):-hnf(partcall(2,'Prelude._def\'23compare\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_19698990,_19698996,_19699002).

'XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23'(_19701670,_19701672,_19701674):-freeze(_19701672,'blocked_XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23'(_19701670,_19701672,_19701674)).
'blocked_XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23'(_19701842,_19701848,_19701854):-hnf(partcall(2,'Prelude._def\'23\'3C\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_19701842,_19701848,_19701854).

'XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23'(_19704474,_19704476,_19704478):-freeze(_19704476,'blocked_XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23'(_19704474,_19704476,_19704478)).
'blocked_XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23'(_19704646,_19704652,_19704658):-hnf(partcall(2,'Prelude._def\'23\'3E\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_19704646,_19704652,_19704658).

'XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_19707344,_19707346,_19707348,_19707350,_19707352):-freeze(_19707350,'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_19707344,_19707346,_19707348,_19707350,_19707352)).
'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_19707440,_19707458,_19712170,_19712176,_19712182):-hnf(_19707440,_19714284,_19712176,_19714302),'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_19714284,_19707458,_19712170,_19714302,_19712182).

'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_19714840,_19714842,_19714844,_19714846,_19714848):-freeze(_19714846,'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_19714840,_19714842,_19714844,_19714846,_19714848)).
'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'('XML.XText'(_19707574),_19707458,_19715636,_19715642,_19715648):-hnf(_19707458,_19718410,_19715642,_19718428),'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'(_19718410,_19707574,_19715636,_19718428,_19715648).

'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'(_19719086,_19719088,_19719090,_19719092,_19719094):-freeze(_19719092,'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'(_19719086,_19719088,_19719090,_19719092,_19719094)).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XText'(_19707696),_19707574,_19719448,_19719454,_19719460):-hnf('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[]),_19707574,_19707696),_19719448,_19719454,_19719460).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XElem'(_19708044,_19708062,_19708080),_19707574,'Prelude.True',_19721454,_19721454):-!.
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'('FAIL'(_19722440),_19707574,'FAIL'(_19722440),_19722454,_19722454):-nonvar(_19722440).
'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'('XML.XElem'(_19708222,_19708240,_19708258),_19707458,_19723256,_19723262,_19723268):-!,hnf(_19707458,_19726030,_19723262,_19726060),'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'(_19726030,_19708222,_19708240,_19708258,_19723256,_19726060,_19723268).

'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'(_19726752,_19726754,_19726756,_19726758,_19726760,_19726762,_19726764):-freeze(_19726762,'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'(_19726752,_19726754,_19726756,_19726758,_19726760,_19726762,_19726764)).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XText'(_19708392),_19708222,_19708240,_19708258,'Prelude.False',_19727140,_19727140).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XElem'(_19708516,_19708534,_19708552),_19708222,_19708240,_19708258,_19728424,_19728430,_19728436):-!,makeShare(_19708222,_19728994),makeShare(_19708516,_19729014),makeShare(_19708240,_19729034),makeShare(_19708534,_19729054),hnf('Prelude.||'('Prelude.||'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])),_19728994),_19729014),'Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_19728994,_19729014),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),_19729034),_19729054))),'Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_19728994,_19729014),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_19729034,_19729054)),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[]),_19708258,_19708552))),_19728424,_19728430,_19728436).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'('FAIL'(_19741774),_19708222,_19708240,_19708258,'FAIL'(_19741774),_19741788,_19741788):-nonvar(_19741774).
'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'('FAIL'(_19741868),_19707458,'FAIL'(_19741868),_19741882,_19741882):-nonvar(_19741868).

'XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_19743642,_19743644,_19743646):-freeze(_19743644,'blocked_XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_19743642,_19743644,_19743646)).
'blocked_XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_19743814,_19743820,_19743826):-hnf(partcall(2,'Prelude._def\'23\'3E\'3D\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_19743814,_19743820,_19743826).

'XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23'(_19746530,_19746532,_19746534):-freeze(_19746532,'blocked_XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23'(_19746530,_19746532,_19746534)).
'blocked_XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23'(_19746702,_19746708,_19746714):-hnf(partcall(2,'Prelude._def\'23min\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_19746702,_19746708,_19746714).

'XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'(_19749382,_19749384,_19749386):-freeze(_19749384,'blocked_XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'(_19749382,_19749384,_19749386)).
'blocked_XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'(_19749554,_19749560,_19749566):-hnf(partcall(2,'Prelude._def\'23max\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_19749554,_19749560,_19749566).

'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23'(_19752092,_19752094,_19752096,_19752098):-freeze(_19752096,'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23'(_19752092,_19752094,_19752096,_19752098)).
'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23'(_19752178,_19752882,_19752888,_19752894):-hnf(_19752178,_19754700,_19752888,_19754712),'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'(_19754700,_19752882,_19754712,_19752894).

'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'(_19755194,_19755196,_19755198,_19755200):-freeze(_19755198,'blocked_blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'(_19755194,_19755196,_19755198,_19755200)).
'blocked_blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Show'('XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23',partcall(2,'XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23',[]),'XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'),_19755546,_19755546):-!.
'blocked_blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'('FAIL'(_19757386),'FAIL'(_19757386),_19757400,_19757400):-nonvar(_19757386).

'XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23'(_19759210,_19759212,_19759214):-freeze(_19759212,'blocked_XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23'(_19759210,_19759212,_19759214)).
'blocked_XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23'(_19759382,_19759388,_19759394):-hnf(partcall(1,'Prelude._def\'23show\'23Prelude.Show',[partcall(1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',[])]),_19759382,_19759388,_19759394).

'XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23'(_19762358,_19762360,_19762362,_19762364,_19762366):-freeze(_19762364,'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23'(_19762358,_19762360,_19762362,_19762364,_19762366)).
'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23'(_19762454,_19762472,_19769220,_19769226,_19769232):-hnf(_19762472,_19771478,_19769226,_19771496),'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'(_19771478,_19762454,_19769220,_19771496,_19769232).

'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'(_19772058,_19772060,_19772062,_19772064,_19772066):-freeze(_19772064,'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'(_19772058,_19772060,_19772062,_19772064,_19772066)).
'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'('XML.XText'(_19762588),_19762454,_19772420,_19772426,_19772432):-hnf('Prelude.showParen'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',10),_19762454),'Prelude..'(partcall(1,'Prelude.showString',[['^X','^T','^e','^x','^t','^ ']]),'Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[]),11),_19762588))),_19772420,_19772426,_19772432).
'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'('XML.XElem'(_19764672,_19764690,_19764708),_19762454,_19777446,_19777452,_19777458):-!,hnf('Prelude.showParen'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',10),_19762454),'Prelude..'(partcall(1,'Prelude.showString',[['^X','^E','^l','^e','^m','^ ']]),'Prelude..'('Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[]),11),_19764672),'Prelude..'(partcall(1,'Prelude.showString',[['^ ']]),'Prelude..'('Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])])]),11),_19764690),'Prelude..'(partcall(1,'Prelude.showString',[['^ ']]),'Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',[]),11),_19764708))))))),_19777446,_19777452,_19777458).
'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'('FAIL'(_19788336),_19762454,'FAIL'(_19788336),_19788350,_19788350):-nonvar(_19788336).

'XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'(_19790320,_19790322,_19790324):-freeze(_19790322,'blocked_XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'(_19790320,_19790322,_19790324)).
'blocked_XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'(_19790492,_19790498,_19790504):-hnf('Prelude._def\'23showList\'23Prelude.Show'(partcall(1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',[])),_19790492,_19790498,_19790504).

'XML.encoding2Attribute'(_19792530,_19792532,_19792534,_19792536):-freeze(_19792534,'blocked_XML.encoding2Attribute'(_19792530,_19792532,_19792534,_19792536)).
'blocked_XML.encoding2Attribute'(_19792616,_19796448,_19796454,_19796460):-hnf(_19792616,_19797618,_19796454,_19797630),'blocked_XML.encoding2Attribute_1'(_19797618,_19796448,_19797630,_19796460).

'blocked_XML.encoding2Attribute_1'(_19798004,_19798006,_19798008,_19798010):-freeze(_19798008,'blocked_blocked_XML.encoding2Attribute_1'(_19798004,_19798006,_19798008,_19798010)).
'blocked_blocked_XML.encoding2Attribute_1'('XML.StandardEnc',[],_19798424,_19798424).
'blocked_blocked_XML.encoding2Attribute_1'('XML.Iso88591Enc',['^e','^n','^c','^o','^d','^i','^n','^g',^=,'^"','^i','^s','^o',^-,'^8','^8','^5','^9',^-,'^1','^"','^ '],_19799114,_19799114):-!.
'blocked_blocked_XML.encoding2Attribute_1'('FAIL'(_19803920),'FAIL'(_19803920),_19803934,_19803934):-nonvar(_19803920).

'XML.encoding2EncFunc'(_19804878,_19804880,_19804882,_19804884):-freeze(_19804882,'blocked_XML.encoding2EncFunc'(_19804878,_19804880,_19804882,_19804884)).
'blocked_XML.encoding2EncFunc'(_19804964,_19805396,_19805402,_19805408):-hnf(_19804964,_19806494,_19805402,_19806506),'blocked_XML.encoding2EncFunc_1'(_19806494,_19805396,_19806506,_19805408).

'blocked_XML.encoding2EncFunc_1'(_19806868,_19806870,_19806872,_19806874):-freeze(_19806872,'blocked_blocked_XML.encoding2EncFunc_1'(_19806868,_19806870,_19806872,_19806874)).
'blocked_blocked_XML.encoding2EncFunc_1'('XML.StandardEnc',_19807282,_19807288,_19807294):-hnf(partcall(1,'XML.standardEncoding',[]),_19807282,_19807288,_19807294).
'blocked_blocked_XML.encoding2EncFunc_1'('XML.Iso88591Enc',_19808106,_19808112,_19808118):-!,hnf(partcall(1,'XML.iso88591Encoding',[]),_19808106,_19808112,_19808118).
'blocked_blocked_XML.encoding2EncFunc_1'('FAIL'(_19808614),'FAIL'(_19808614),_19808628,_19808628):-nonvar(_19808614).

'XML.standardEncoding'(_19809572,_19809574,_19809576,_19809578):-freeze(_19809576,'blocked_XML.standardEncoding'(_19809572,_19809574,_19809576,_19809578)).
'blocked_XML.standardEncoding'(_19809658,_19821514,_19821520,_19821526):-hnf(_19809658,_19822612,_19821520,_19822624),'blocked_XML.standardEncoding_1'(_19822612,_19821514,_19822624,_19821526).

'blocked_XML.standardEncoding_1'(_19822986,_19822988,_19822990,_19822992):-freeze(_19822990,'blocked_blocked_XML.standardEncoding_1'(_19822986,_19822988,_19822990,_19822992)).
'blocked_blocked_XML.standardEncoding_1'([],[],_19823234,_19823234).
'blocked_blocked_XML.standardEncoding_1'([_19809874|_19809892],_19828442,_19828448,_19828454):-!,makeShare(_19809874,_19824398),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_19824398,^<),_19830122,_19828448,_19830088),'blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'(_19830122,_19824398,_19809892,_19828442,_19830088,_19828454).

'blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'(_19830646,_19830648,_19830650,_19830652,_19830654,_19830656):-freeze(_19830654,freeze(_19830646,'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'(_19830646,_19830648,_19830650,_19830652,_19830654,_19830656))).
'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'('Prelude.True',_19824398,_19809892,_19831050,_19831056,_19831062):-hnf('Prelude.++'([^&,'^l','^t','^;'],'XML.standardEncoding'(_19809892)),_19831050,_19831056,_19831062).
'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'('Prelude.False',_19824398,_19809892,_19837802,_19837808,_19837814):-!,makeShare(_19824398,_19833946),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_19833946,^>),_19840662,_19837808,_19840628),'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_19840662,_19833946,_19809892,_19837802,_19840628,_19837814).

'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_19841390,_19841392,_19841394,_19841396,_19841398,_19841400):-freeze(_19841398,freeze(_19841390,'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_19841390,_19841392,_19841394,_19841396,_19841398,_19841400))).
'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19833946,_19809892,_19841794,_19841800,_19841806):-hnf('Prelude.++'([^&,'^g','^t','^;'],'XML.standardEncoding'(_19809892)),_19841794,_19841800,_19841806).
'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19833946,_19809892,_19848554,_19848560,_19848566):-!,makeShare(_19833946,_19844826),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_19844826,^&),_19852638,_19848560,_19852604),'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19852638,_19844826,_19809892,_19848554,_19852604,_19848566).

'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19853570,_19853572,_19853574,_19853576,_19853578,_19853580):-freeze(_19853578,freeze(_19853570,'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19853570,_19853572,_19853574,_19853576,_19853578,_19853580))).
'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19844826,_19809892,_19853974,_19853980,_19853986):-hnf('Prelude.++'([^&,'^a','^m','^p','^;'],'XML.standardEncoding'(_19809892)),_19853974,_19853980,_19853986).
'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19844826,_19809892,_19860916,_19860922,_19860928):-!,makeShare(_19844826,_19857340),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_19857340,'^"'),_19866224,_19860922,_19866190),'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19866224,_19857340,_19809892,_19860916,_19866190,_19860928).

'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19867360,_19867362,_19867364,_19867366,_19867368,_19867370):-freeze(_19867368,freeze(_19867360,'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19867360,_19867362,_19867364,_19867366,_19867368,_19867370))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19857340,_19809892,_19867764,_19867770,_19867776):-hnf('Prelude.++'([^&,'^q','^u','^o','^t','^;'],'XML.standardEncoding'(_19809892)),_19867764,_19867770,_19867776).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19857340,_19809892,_19874860,_19874866,_19874872):-!,makeShare(_19857340,_19871460),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_19871460,'^\''),_19881392,_19874866,_19881358),'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19881392,_19871460,_19809892,_19874860,_19881358,_19874872).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19882732,_19882734,_19882736,_19882738,_19882740,_19882742):-freeze(_19882740,freeze(_19882732,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19882732,_19882734,_19882736,_19882738,_19882740,_19882742))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19871460,_19809892,_19883136,_19883142,_19883148):-hnf('Prelude.++'([^&,'^a','^p','^o','^s','^;'],'XML.standardEncoding'(_19809892)),_19883136,_19883142,_19883148).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19871460,_19809892,_19890656,_19890662,_19890668):-!,makeShare(_19871460,_19886960),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23','Prelude.ord'(_19886960)),32),_19898412,_19890662,_19898378),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19898412,_19886960,_19809892,_19890656,_19898378,_19890668).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19899956,_19899958,_19899960,_19899962,_19899964,_19899966):-freeze(_19899964,freeze(_19899956,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19899956,_19899958,_19899960,_19899962,_19899964,_19899966))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19886960,_19809892,_19900360,_19900366,_19900372):-hnf('Prelude.++'([^&,^#],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23','Prelude.ord'(_19886960)),'Prelude.++'(['^;'],'XML.standardEncoding'(_19809892)))),_19900360,_19900366,_19900372).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19886960,_19809892,_19908606,_19908612,_19908618):-!,makeShare(_19886960,_19905150),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'23Prelude.Ord\'23Prelude.Int\'23','Prelude.ord'(_19905150)),127),_19917586,_19908612,_19917552),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19917586,_19905150,_19809892,_19908606,_19917552,_19908618).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19919334,_19919336,_19919338,_19919340,_19919342,_19919344):-freeze(_19919342,freeze(_19919334,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19919334,_19919336,_19919338,_19919340,_19919342,_19919344))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19905150,_19809892,_19919738,_19919744,_19919750):-hnf('Prelude.++'([^&,^#],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23','Prelude.ord'(_19905150)),'Prelude.++'(['^;'],'XML.standardEncoding'(_19809892)))),_19919738,_19919744,_19919750).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19905150,_19809892,_19926778,_19926784,_19926790):-!,hnf('Prelude.otherwise',_19936982,_19926784,_19936948),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19936982,_19905150,_19809892,_19926778,_19936948,_19926790).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19938922,_19938924,_19938926,_19938928,_19938930,_19938932):-freeze(_19938930,freeze(_19938922,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_19938922,_19938924,_19938926,_19938928,_19938930,_19938932))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_19905150,_19809892,[_19905150|'XML.standardEncoding'(_19809892)],_19939332,_19939332).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_19905150,_19809892,_19942132,_19942138,_19942144):-!,hnf(reportFailure4PAKCS('XML.standardEncoding',['Prelude.False']),_19942132,_19942138,_19942144).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19944978),_19905150,_19809892,'FAIL'(_19944978),_19944992,_19944992).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19945060),_19905150,_19809892,'FAIL'(_19945060),_19945074,_19945074).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19945142),_19886960,_19809892,'FAIL'(_19945142),_19945156,_19945156).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19945224),_19871460,_19809892,'FAIL'(_19945224),_19945238,_19945238).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19945306),_19857340,_19809892,'FAIL'(_19945306),_19945320,_19945320).
'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19945388),_19844826,_19809892,'FAIL'(_19945388),_19945402,_19945402).
'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_19945470),_19833946,_19809892,'FAIL'(_19945470),_19945484,_19945484).
'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'('FAIL'(_19945552),_19824398,_19809892,'FAIL'(_19945552),_19945566,_19945566).
'blocked_blocked_XML.standardEncoding_1'('FAIL'(_19945634),'FAIL'(_19945634),_19945648,_19945648):-nonvar(_19945634).

'XML.iso88591Encoding'(_19946592,_19946594,_19946596,_19946598):-freeze(_19946596,'blocked_XML.iso88591Encoding'(_19946592,_19946594,_19946596,_19946598)).
'blocked_XML.iso88591Encoding'(_19946678,_19948482,_19948488,_19948494):-hnf(_19946678,_19949580,_19948488,_19949592),'blocked_XML.iso88591Encoding_1'(_19949580,_19948482,_19949592,_19948494).

'blocked_XML.iso88591Encoding_1'(_19949954,_19949956,_19949958,_19949960):-freeze(_19949958,'blocked_blocked_XML.iso88591Encoding_1'(_19949954,_19949956,_19949958,_19949960)).
'blocked_blocked_XML.iso88591Encoding_1'([],[],_19950202,_19950202).
'blocked_blocked_XML.iso88591Encoding_1'([_19946894|_19946912],_19952886,_19952892,_19952898):-!,makeShare(_19946894,_19950876),hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Prelude.ord'(_19950876)),'XML.iso88591list'),_19954566,_19952892,_19954532),'blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'(_19954566,_19950876,_19946912,_19952886,_19954532,_19952898).

'blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'(_19955090,_19955092,_19955094,_19955096,_19955098,_19955100):-freeze(_19955098,freeze(_19955090,'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'(_19955090,_19955092,_19955094,_19955096,_19955098,_19955100))).
'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'('Prelude.True',_19950876,_19946912,[_19950876|'XML.iso88591Encoding'(_19946912)],_19955500,_19955500).
'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'('Prelude.False',_19950876,_19946912,_19956872,_19956878,_19956884):-!,hnf('Prelude.++'('XML.standardEncoding'([_19950876]),'XML.iso88591Encoding'(_19946912)),_19956872,_19956878,_19956884).
'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'('FAIL'(_19958544),_19950876,_19946912,'FAIL'(_19958544),_19958558,_19958558).
'blocked_blocked_XML.iso88591Encoding_1'('FAIL'(_19958626),'FAIL'(_19958626),_19958640,_19958640):-nonvar(_19958626).

'XML.iso88591list'(_19959432,_19959434,_19959436):-freeze(_19959434,'blocked_XML.iso88591list'(_19959432,_19959434,_19959436)).
'blocked_XML.iso88591list'([192,193,194,195,196,197,198,199,200,201,202,203,204,205,207,208,209,210,211,212,214,216,217,218,219,220,221,224,225,228,229,226,227,230,231,233,232,235,234,236,237,239,240,241,248,246,242,243,244,245,250,249,252,251,253,255],_19968150,_19968150).

'XML.lookupEncoding'(_19979848,_19979850,_19979852,_19979854):-freeze(_19979852,'blocked_XML.lookupEncoding'(_19979848,_19979850,_19979852,_19979854)).
'blocked_XML.lookupEncoding'(_19979934,_19980710,_19980716,_19980722):-hnf(_19979934,_19981736,_19980716,_19981748),'blocked_XML.lookupEncoding_1'(_19981736,_19980710,_19981748,_19980722).

'blocked_XML.lookupEncoding_1'(_19982098,_19982100,_19982102,_19982104):-freeze(_19982102,'blocked_blocked_XML.lookupEncoding_1'(_19982098,_19982100,_19982102,_19982104)).
'blocked_blocked_XML.lookupEncoding_1'([_19980050|_19980068],_19982614,_19982620,_19982626):-hnf(_19980050,_19984120,_19982620,_19984138),'blocked_blocked_XML.lookupEncoding_1_[|]_1'(_19984120,_19980068,_19982614,_19984138,_19982626).

'blocked_blocked_XML.lookupEncoding_1_[|]_1'(_19984580,_19984582,_19984584,_19984586,_19984588):-freeze(_19984586,'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'(_19984580,_19984582,_19984584,_19984586,_19984588)).
'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'('XML.Enc'(_19980196),_19980068,_19984918,_19984924,_19984930):-hnf(_19980196,_19984918,_19984924,_19984930).
'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'('XML.DtdUrl'(_19980306),_19980068,_19985764,_19985770,_19985776):-!,hnf('XML.lookupEncoding'(_19980068),_19985764,_19985770,_19985776).
'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'('FAIL'(_19986562),_19980068,'FAIL'(_19986562),_19986576,_19986576):-nonvar(_19986562).
'blocked_blocked_XML.lookupEncoding_1'([],'XML.StandardEnc',_19986808,_19986808):-!.
'blocked_blocked_XML.lookupEncoding_1'('FAIL'(_19987240),'FAIL'(_19987240),_19987254,_19987254):-nonvar(_19987240).

'XML.lookupDtdUrl'(_19988046,_19988048,_19988050,_19988052):-freeze(_19988050,'blocked_XML.lookupDtdUrl'(_19988046,_19988048,_19988050,_19988052)).
'blocked_XML.lookupDtdUrl'(_19988132,_19988896,_19988902,_19988908):-hnf(_19988132,_19989850,_19988902,_19989862),'blocked_XML.lookupDtdUrl_1'(_19989850,_19988896,_19989862,_19988908).

'blocked_XML.lookupDtdUrl_1'(_19990200,_19990202,_19990204,_19990206):-freeze(_19990204,'blocked_blocked_XML.lookupDtdUrl_1'(_19990200,_19990202,_19990204,_19990206)).
'blocked_blocked_XML.lookupDtdUrl_1'([],[],_19990448,_19990448).
'blocked_blocked_XML.lookupDtdUrl_1'([_19988348|_19988366],_19991186,_19991192,_19991198):-!,hnf(_19988348,_19992620,_19991192,_19992638),'blocked_blocked_XML.lookupDtdUrl_1_[|]_1'(_19992620,_19988366,_19991186,_19992638,_19991198).

'blocked_blocked_XML.lookupDtdUrl_1_[|]_1'(_19993086,_19993088,_19993090,_19993092,_19993094):-freeze(_19993092,'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'(_19993086,_19993088,_19993090,_19993092,_19993094)).
'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'('XML.Enc'(_19988494),_19988366,_19993424,_19993430,_19993436):-hnf('XML.lookupDtdUrl'(_19988366),_19993424,_19993430,_19993436).
'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'('XML.DtdUrl'(_19988688),_19988366,_19994464,_19994470,_19994476):-!,hnf(_19988688,_19994464,_19994470,_19994476).
'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'('FAIL'(_19995032),_19988366,'FAIL'(_19995032),_19995046,_19995046):-nonvar(_19995032).
'blocked_blocked_XML.lookupDtdUrl_1'('FAIL'(_19995110),'FAIL'(_19995110),_19995124,_19995124):-nonvar(_19995110).

'XML.hasDtdUrl'(_19995802,_19995804,_19995806,_19995808):-freeze(_19995806,'blocked_XML.hasDtdUrl'(_19995802,_19995804,_19995806,_19995808)).
'blocked_XML.hasDtdUrl'(_19995888,_19996648,_19996654,_19996660):-hnf(_19995888,_19997494,_19996654,_19997506),'blocked_XML.hasDtdUrl_1'(_19997494,_19996648,_19997506,_19996660).

'blocked_XML.hasDtdUrl_1'(_19997826,_19997828,_19997830,_19997832):-freeze(_19997830,'blocked_blocked_XML.hasDtdUrl_1'(_19997826,_19997828,_19997830,_19997832)).
'blocked_blocked_XML.hasDtdUrl_1'([],'Prelude.False',_19998074,_19998074).
'blocked_blocked_XML.hasDtdUrl_1'([_19996104|_19996122],_19998858,_19998864,_19998870):-!,hnf(_19996104,_20000184,_19998864,_20000202),'blocked_blocked_XML.hasDtdUrl_1_[|]_1'(_20000184,_19996122,_19998858,_20000202,_19998870).

'blocked_blocked_XML.hasDtdUrl_1_[|]_1'(_20000632,_20000634,_20000636,_20000638,_20000640):-freeze(_20000638,'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'(_20000632,_20000634,_20000636,_20000638,_20000640)).
'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'('XML.DtdUrl'(_19996250),_19996122,'Prelude.True',_20001012,_20001012).
'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'('XML.Enc'(_19996374),_19996122,_20001856,_20001862,_20001868):-!,hnf('XML.hasDtdUrl'(_19996122),_20001856,_20001862,_20001868).
'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'('FAIL'(_20002594),_19996122,'FAIL'(_20002594),_20002608,_20002608):-nonvar(_20002594).
'blocked_blocked_XML.hasDtdUrl_1'('FAIL'(_20002672),'FAIL'(_20002672),_20002686,_20002686):-nonvar(_20002672).

'XML.tagOf'(_20003212,_20003214,_20003216,_20003218):-freeze(_20003216,'blocked_XML.tagOf'(_20003212,_20003214,_20003216,_20003218)).
'blocked_XML.tagOf'(_20003298,_20003746,_20003752,_20003758):-hnf(_20003298,_20004448,_20003752,_20004460),'blocked_XML.tagOf_1'(_20004448,_20003746,_20004460,_20003758).

'blocked_XML.tagOf_1'(_20004756,_20004758,_20004760,_20004762):-freeze(_20004760,'blocked_blocked_XML.tagOf_1'(_20004756,_20004758,_20004760,_20004762)).
'blocked_blocked_XML.tagOf_1'('XML.XElem'(_20003414,_20003432,_20003450),_20005124,_20005130,_20005136):-hnf(_20003414,_20005124,_20005130,_20005136).
'blocked_blocked_XML.tagOf_1'('XML.XText'(_20003572),[],_20005884,_20005884):-!.
'blocked_blocked_XML.tagOf_1'('FAIL'(_20006234),'FAIL'(_20006234),_20006248,_20006248):-nonvar(_20006234).

'XML.elemsOf'(_20006850,_20006852,_20006854,_20006856):-freeze(_20006854,'blocked_XML.elemsOf'(_20006850,_20006852,_20006854,_20006856)).
'blocked_XML.elemsOf'(_20006936,_20007396,_20007402,_20007408):-hnf(_20006936,_20008170,_20007402,_20008182),'blocked_XML.elemsOf_1'(_20008170,_20007396,_20008182,_20007408).

'blocked_XML.elemsOf_1'(_20008490,_20008492,_20008494,_20008496):-freeze(_20008494,'blocked_blocked_XML.elemsOf_1'(_20008490,_20008492,_20008494,_20008496)).
'blocked_blocked_XML.elemsOf_1'('XML.XElem'(_20007052,_20007070,_20007088),_20008858,_20008864,_20008870):-hnf(_20007088,_20008858,_20008864,_20008870).
'blocked_blocked_XML.elemsOf_1'('XML.XText'(_20007210),[],_20009630,_20009630):-!.
'blocked_blocked_XML.elemsOf_1'('FAIL'(_20009992),'FAIL'(_20009992),_20010006,_20010006):-nonvar(_20009992).

'XML.textOf'(_20010570,_20010572,_20010574):-freeze(_20010572,'blocked_XML.textOf'(_20010570,_20010572,_20010574)).
'blocked_XML.textOf'(_20011330,_20011336,_20011342):-hnf('Prelude..'(partcall(1,'Prelude.unwords',[]),'Prelude..'(partcall(1,'Prelude.filter',['Prelude..'(partcall(1,'Prelude.not',[]),partcall(1,'Prelude.null',[]))]),partcall(1,'Prelude.map',[partcall(1,'XML.textOf.textOfXmlExp.59',[])]))),_20011330,_20011336,_20011342).

'XML.textOf.textOfXmlExp.59'(_20014402,_20014404,_20014406,_20014408):-freeze(_20014406,'blocked_XML.textOf.textOfXmlExp.59'(_20014402,_20014404,_20014406,_20014408)).
'blocked_XML.textOf.textOfXmlExp.59'(_20014488,_20015192,_20015198,_20015204):-hnf(_20014488,_20016506,_20015198,_20016518),'blocked_XML.textOf.textOfXmlExp.59_1'(_20016506,_20015192,_20016518,_20015204).

'blocked_XML.textOf.textOfXmlExp.59_1'(_20016916,_20016918,_20016920,_20016922):-freeze(_20016920,'blocked_blocked_XML.textOf.textOfXmlExp.59_1'(_20016916,_20016918,_20016920,_20016922)).
'blocked_blocked_XML.textOf.textOfXmlExp.59_1'('XML.XText'(_20014604),_20017268,_20017274,_20017280):-hnf(_20014604,_20017268,_20017274,_20017280).
'blocked_blocked_XML.textOf.textOfXmlExp.59_1'('XML.XElem'(_20014714,_20014732,_20014750),_20018008,_20018014,_20018020):-!,hnf('Prelude.apply'('XML.textOf',_20014750),_20018008,_20018014,_20018020).
'blocked_blocked_XML.textOf.textOfXmlExp.59_1'('FAIL'(_20018966),'FAIL'(_20018966),_20018980,_20018980):-nonvar(_20018966).

'XML.textOfXml'(_20019658,_20019660,_20019662):-freeze(_20019660,'blocked_XML.textOfXml'(_20019658,_20019660,_20019662)).
'blocked_XML.textOfXml'(_20019746,_20019752,_20019758):-hnf('XML.textOf',_20019746,_20019752,_20019758).

'XML.xtxt'(_20020494,_20020496,_20020498,_20020500):-freeze(_20020498,'blocked_XML.xtxt'(_20020494,_20020496,_20020498,_20020500)).
'blocked_XML.xtxt'(_20020580,'XML.XText'(_20020580),_20020686,_20020686).

'XML.xml'(_20021504,_20021506,_20021508,_20021510,_20021512):-freeze(_20021510,'blocked_XML.xml'(_20021504,_20021506,_20021508,_20021510,_20021512)).
'blocked_XML.xml'(_20021600,_20021618,'XML.XElem'(_20021600,[],_20021618),_20021878,_20021878).

'XML.writeXmlFile'(_20023314,_20023316,_20023318,_20023320,_20023322):-freeze(_20023320,'blocked_XML.writeXmlFile'(_20023314,_20023316,_20023318,_20023320,_20023322)).
'blocked_XML.writeXmlFile'(_20023410,_20023428,_20023934,_20023940,_20023946):-hnf('XML.writeXmlFileWithParams'(_20023410,['XML.Enc'('XML.StandardEnc')],_20023428),_20023934,_20023940,_20023946).

'XML.writeXmlFileWithParams'(_20026390,_20026392,_20026394,_20026396,_20026398,_20026400):-freeze(_20026398,'blocked_XML.writeXmlFileWithParams'(_20026390,_20026392,_20026394,_20026396,_20026398,_20026400)).
'blocked_XML.writeXmlFileWithParams'(_20026496,_20026514,_20026532,_20026856,_20026862,_20026868):-hnf('Prelude.writeFile'(_20026496,'XML.showXmlDocWithParams'(_20026514,_20026532)),_20026856,_20026862,_20026868).

'XML.showXmlDoc'(_20028742,_20028744,_20028746,_20028748):-freeze(_20028746,'blocked_XML.showXmlDoc'(_20028742,_20028744,_20028746,_20028748)).
'blocked_XML.showXmlDoc'(_20028828,_20029012,_20029018,_20029024):-hnf('XML.showXmlDocWithParams'([],_20028828),_20029012,_20029018,_20029024).

'XML.showXmlDocWithParams'(_20030730,_20030732,_20030734,_20030736,_20030738):-freeze(_20030736,'blocked_XML.showXmlDocWithParams'(_20030730,_20030732,_20030734,_20030736,_20030738)).
'blocked_XML.showXmlDocWithParams'(_20030826,_20030844,_20046636,_20046642,_20046648):-hnf(_20030844,_20047886,_20046642,_20047904),'blocked_XML.showXmlDocWithParams_2'(_20047886,_20030826,_20046636,_20047904,_20046648).

'blocked_XML.showXmlDocWithParams_2'(_20048298,_20048300,_20048302,_20048304,_20048306):-freeze(_20048304,'blocked_blocked_XML.showXmlDocWithParams_2'(_20048298,_20048300,_20048302,_20048304,_20048306)).
'blocked_blocked_XML.showXmlDocWithParams_2'('XML.XElem'(_20030960,_20030978,_20030996),_20030826,_20048676,_20048682,_20048688):-makeShare(_20030826,_20049138),makeShare(_20030960,_20049158),hnf('Prelude.++'([^<,^?,'^x','^m','^l','^ ','^v','^e','^r','^s','^i','^o','^n',^=,'^"','^1',^.,'^0','^"','^ '],'Prelude.++'('XML.encoding2Attribute'('XML.lookupEncoding'(_20049138)),'Prelude.++'(['^s','^t','^a','^n','^d','^a','^l','^o','^n','^e',^=,'^"'],'Prelude.++'('XML.showXmlDocWithParams._\'23caseor0'('XML.hasDtdUrl'(_20049138)),'Prelude.++'(['^"',^?,^>,'^010','^010'],'Prelude.++'('XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'('XML.hasDtdUrl'(_20049138),_20049158,_20049138),'XML.showXmlExp'(0,'XML.encoding2EncFunc'('XML.lookupEncoding'(_20049138)),'XML.XElem'(_20049158,_20030978,_20030996)))))))),_20048676,_20048682,_20048688).
'blocked_blocked_XML.showXmlDocWithParams_2'('XML.XText'(_20039042),_20030826,_20062550,_20062556,_20062562):-!,hnf('Prelude.error'(['^X','^M','^L',^.,'^s','^h','^o','^w','^X','^m','^l','^D','^o','^c','^W','^i','^t','^h','^P','^a','^r','^a','^m','^s',^:,'^ ','^d','^o','^c','^u','^m','^e','^n','^t','^ ','^w','^i','^t','^h','^o','^u','^t','^ ','^t','^a','^g','^s']),_20062550,_20062556,_20062562).
'blocked_blocked_XML.showXmlDocWithParams_2'('FAIL'(_20072776),_20030826,'FAIL'(_20072776),_20072790,_20072790):-nonvar(_20072776).

'XML.showXmlExp'(_20073514,_20073516,_20073518,_20073520,_20073522,_20073524):-freeze(_20073522,'blocked_XML.showXmlExp'(_20073514,_20073516,_20073518,_20073520,_20073522,_20073524)).
'blocked_XML.showXmlExp'(_20073620,_20073638,_20073656,_20075914,_20075920,_20075926):-hnf(_20073656,_20076812,_20075920,_20076836),'blocked_XML.showXmlExp_3'(_20076812,_20073620,_20073638,_20075914,_20076836,_20075926).

'blocked_XML.showXmlExp_3'(_20077178,_20077180,_20077182,_20077184,_20077186,_20077188):-freeze(_20077186,'blocked_blocked_XML.showXmlExp_3'(_20077178,_20077180,_20077182,_20077184,_20077186,_20077188)).
'blocked_blocked_XML.showXmlExp_3'('XML.XText'(_20073772),_20073620,_20073638,_20077550,_20077556,_20077562):-hnf('Prelude.++'('XML.xtab'(_20073620),'Prelude.++'('Prelude.apply'(_20073638,_20073772),['^010'])),_20077550,_20077556,_20077562).
'blocked_blocked_XML.showXmlExp_3'('XML.XElem'(_20074596,_20074614,_20074632),_20073620,_20073638,_20079718,_20079724,_20079730):-!,makeShare(_20073620,_20080144),makeShare(_20074596,_20080164),makeShare(_20073638,_20080184),makeShare(_20074632,_20080204),hnf('Prelude.++'('XML.xtab'(_20080144),'Prelude.++'('XML.showXmlOpenTag'(_20080164,_20074614,_20080184),'XML.showXmlExp._\'23caseor0'('Prelude.null'(_20080204),_20080204,_20080184,_20080144,_20080164))),_20079718,_20079724,_20079730).
'blocked_blocked_XML.showXmlExp_3'('FAIL'(_20083592),_20073620,_20073638,'FAIL'(_20083592),_20083606,_20083606):-nonvar(_20083592).

'XML.showXmlExp._\'23selFP2\'23s'(_20084826,_20084828,_20084830,_20084832):-freeze(_20084830,'blocked_XML.showXmlExp._\'23selFP2\'23s'(_20084826,_20084828,_20084830,_20084832)).
'blocked_XML.showXmlExp._\'23selFP2\'23s'(_20084912,_20087342,_20087348,_20087354):-hnf(_20084912,_20088764,_20087348,_20088776),'blocked_XML.showXmlExp._\'23selFP2\'23s_1'(_20088764,_20087342,_20088776,_20087354).

'blocked_XML.showXmlExp._\'23selFP2\'23s_1'(_20089192,_20089194,_20089196,_20089198):-freeze(_20089196,'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'(_20089192,_20089194,_20089196,_20089198)).
'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'([_20085028|_20085046],_20089976,_20089982,_20089988):-!,hnf(_20085028,_20091878,_20089982,_20091896),'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'(_20091878,_20085046,_20089976,_20091896,_20089988).

'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'(_20092422,_20092424,_20092426,_20092428,_20092430):-freeze(_20092428,'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'(_20092422,_20092424,_20092426,_20092428,_20092430)).
'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'('XML.XText'(_20085174),_20085046,_20093390,_20093396,_20093402):-!,hnf(_20085046,_20095984,_20093396,_20096002),'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'(_20095984,_20085174,_20093390,_20096002,_20093402).

'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'(_20096648,_20096650,_20096652,_20096654,_20096656):-freeze(_20096654,'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'(_20096648,_20096650,_20096652,_20096654,_20096656)).
'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'([],_20085174,_20097102,_20097108,_20097114):-!,hnf(_20085174,_20097102,_20097108,_20097114).
'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'([_20085382|_20085400],_20085174,_20097992,_20097998,_20098004):-!,hnf(reportFailure4PAKCS('XML.showXmlExp._\'23selFP2\'23s',[[_20085382|_20085400]]),_20097992,_20097998,_20098004).
'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'('FAIL'(_20099756),_20085174,'FAIL'(_20099756),_20099770,_20099770).
'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'('XML.XElem'(_20086012,_20086030,_20086048),_20085046,_20100118,_20100124,_20100130):-!,hnf(reportFailure4PAKCS('XML.showXmlExp._\'23selFP2\'23s',['XML.XElem'(_20086012,_20086030,_20086048)]),_20100118,_20100124,_20100130).
'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'('FAIL'(_20101998),_20085046,'FAIL'(_20101998),_20102012,_20102012).
'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'([],_20102234,_20102240,_20102246):-!,hnf(reportFailure4PAKCS('XML.showXmlExp._\'23selFP2\'23s',[[]]),_20102234,_20102240,_20102246).
'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'('FAIL'(_20103386),'FAIL'(_20103386),_20103400,_20103400).

'XML.xtab'(_20103884,_20103886,_20103888,_20103890):-freeze(_20103888,'blocked_XML.xtab'(_20103884,_20103886,_20103888,_20103890)).
'blocked_XML.xtab'(_20103970,_20104224,_20104230,_20104236):-hnf('Prelude.take'(_20103970,'Prelude.repeat'('^ ')),_20104224,_20104230,_20104236).

'XML.showXmlOpenTag'(_20105788,_20105790,_20105792,_20105794,_20105796,_20105798):-freeze(_20105796,'blocked_XML.showXmlOpenTag'(_20105788,_20105790,_20105792,_20105794,_20105796,_20105798)).
'blocked_XML.showXmlOpenTag'(_20105894,_20105912,_20105930,_20107234,_20107240,_20107246):-hnf('Prelude.++'([^<],'Prelude.++'(_20105894,'Prelude.apply'('Prelude.concat','Prelude.map'('Prelude..'(partcall(1,'Prelude.++',[['^ ']]),partcall(1,'XML.showXmlOpenTag.attr2string.93',[_20105930])),_20105912)))),_20107234,_20107240,_20107246).

'XML.showXmlOpenTag.attr2string.93'(_20111722,_20111724,_20111726,_20111728,_20111730):-freeze(_20111728,'blocked_XML.showXmlOpenTag.attr2string.93'(_20111722,_20111724,_20111726,_20111728,_20111730)).
'blocked_XML.showXmlOpenTag.attr2string.93'(_20111818,_20111836,_20113394,_20113400,_20113406):-hnf(_20111836,_20114968,_20113400,_20114986),'blocked_XML.showXmlOpenTag.attr2string.93_2'(_20114968,_20111818,_20113394,_20114986,_20113406).

'blocked_XML.showXmlOpenTag.attr2string.93_2'(_20115434,_20115436,_20115438,_20115440,_20115442):-freeze(_20115440,'blocked_blocked_XML.showXmlOpenTag.attr2string.93_2'(_20115434,_20115436,_20115438,_20115440,_20115442)).
'blocked_blocked_XML.showXmlOpenTag.attr2string.93_2'('Prelude.(,)'(_20111952,_20111970),_20111818,_20115814,_20115820,_20115826):-!,hnf('Prelude.++'(_20111952,'Prelude.++'([^=,'^"'],'Prelude.++'('Prelude.apply'(_20111818,_20111970),['^"']))),_20115814,_20115820,_20115826).
'blocked_blocked_XML.showXmlOpenTag.attr2string.93_2'('FAIL'(_20118390),_20111818,'FAIL'(_20118390),_20118404,_20118404):-nonvar(_20118390).

'XML.showXmlExps'(_20119166,_20119168,_20119170,_20119172,_20119174,_20119176):-freeze(_20119174,'blocked_XML.showXmlExps'(_20119166,_20119168,_20119170,_20119172,_20119174,_20119176)).
'blocked_XML.showXmlExps'(_20119272,_20119290,_20119308,_20119716,_20119722,_20119728):-hnf('Prelude.apply'('Prelude.concatMap'(partcall(1,'XML.showXmlExp',[_20119308,_20119272])),_20119290),_20119716,_20119722,_20119728).

'XML.isXText'(_20121560,_20121562,_20121564,_20121566):-freeze(_20121564,'blocked_XML.isXText'(_20121560,_20121562,_20121564,_20121566)).
'blocked_XML.isXText'(_20121646,_20122120,_20122126,_20122132):-hnf(_20121646,_20122894,_20122126,_20122906),'blocked_XML.isXText_1'(_20122894,_20122120,_20122906,_20122132).

'blocked_XML.isXText_1'(_20123214,_20123216,_20123218,_20123220):-freeze(_20123218,'blocked_blocked_XML.isXText_1'(_20123214,_20123216,_20123218,_20123220)).
'blocked_blocked_XML.isXText_1'('XML.XText'(_20121762),'Prelude.True',_20123572,_20123572).
'blocked_blocked_XML.isXText_1'('XML.XElem'(_20121886,_20121904,_20121922),'Prelude.False',_20124292,_20124292):-!.
'blocked_blocked_XML.isXText_1'('FAIL'(_20124868),'FAIL'(_20124868),_20124882,_20124882):-nonvar(_20124868).

'XML.xmlUnquoteSpecials'(_20125902,_20125904,_20125906,_20125908):-freeze(_20125906,'blocked_XML.xmlUnquoteSpecials'(_20125902,_20125904,_20125906,_20125908)).
'blocked_XML.xmlUnquoteSpecials'(_20125988,_20129084,_20129090,_20129096):-hnf(_20125988,_20130254,_20129090,_20130266),'blocked_XML.xmlUnquoteSpecials_1'(_20130254,_20129084,_20130266,_20129096).

'blocked_XML.xmlUnquoteSpecials_1'(_20130640,_20130642,_20130644,_20130646):-freeze(_20130644,'blocked_blocked_XML.xmlUnquoteSpecials_1'(_20130640,_20130642,_20130644,_20130646)).
'blocked_blocked_XML.xmlUnquoteSpecials_1'([],[],_20130888,_20130888).
'blocked_blocked_XML.xmlUnquoteSpecials_1'([_20126204|_20126222],_20133922,_20133928,_20133934):-!,makeShare(_20126204,_20131906),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20131906,^&),_20135674,_20133928,_20135640),'blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'(_20135674,_20131906,_20126222,_20133922,_20135640,_20133934).

'blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'(_20136210,_20136212,_20136214,_20136216,_20136218,_20136220):-freeze(_20136218,freeze(_20136210,'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'(_20136210,_20136212,_20136214,_20136216,_20136218,_20136220))).
'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'('Prelude.True',_20131906,_20126222,_20136614,_20136620,_20136626):-makeShare(_20126514,_20136952),makeShare(_20126532,_20136972),makeShare(_20126550,_20136992),hnf('Prelude.cond'(letrec4PAKCS(_20136952,'XML.splitAtChar'('^;',_20126222)),'Prelude.cond'(letrec4PAKCS(_20136972,'XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_20136952)),'Prelude.cond'(letrec4PAKCS(_20136992,'XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_20136952)),'XML.xmlUnquoteSpecial'(_20136972,_20136992)))),_20136614,_20136620,_20136626).
'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'('Prelude.False',_20131906,_20126222,_20142642,_20142648,_20142654):-!,hnf('Prelude.otherwise',_20145574,_20142648,_20145540),'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20145574,_20131906,_20126222,_20142642,_20145540,_20142654).

'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20146302,_20146304,_20146306,_20146308,_20146310,_20146312):-freeze(_20146310,freeze(_20146302,'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20146302,_20146304,_20146306,_20146308,_20146310,_20146312))).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20131906,_20126222,[_20131906|'XML.xmlUnquoteSpecials'(_20126222)],_20146712,_20146712).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20131906,_20126222,_20148312,_20148318,_20148324):-!,hnf(reportFailure4PAKCS('XML.xmlUnquoteSpecials',['Prelude.False']),_20148312,_20148318,_20148324).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20149958),_20131906,_20126222,'FAIL'(_20149958),_20149972,_20149972).
'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'('FAIL'(_20150040),_20131906,_20126222,'FAIL'(_20150040),_20150054,_20150054).
'blocked_blocked_XML.xmlUnquoteSpecials_1'('FAIL'(_20150122),'FAIL'(_20150122),_20150136,_20150136):-nonvar(_20150122).

'XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_20151858,_20151860,_20151862,_20151864):-freeze(_20151862,'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_20151858,_20151860,_20151862,_20151864)).
'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_20151944,_20152448,_20152454,_20152460):-hnf(_20151944,_20154374,_20152454,_20154386),'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'(_20154374,_20152448,_20154386,_20152460).

'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'(_20154886,_20154888,_20154890,_20154892):-freeze(_20154890,'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'(_20154886,_20154888,_20154890,_20154892)).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'('Prelude.(,)'(_20152060,_20152078),_20155256,_20155262,_20155268):-!,hnf(_20152060,_20155256,_20155262,_20155268).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'('FAIL'(_20155894),'FAIL'(_20155894),_20155908,_20155908):-nonvar(_20155894).

'XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_20157516,_20157518,_20157520,_20157522):-freeze(_20157520,'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_20157516,_20157518,_20157520,_20157522)).
'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_20157602,_20158088,_20158094,_20158100):-hnf(_20157602,_20159906,_20158094,_20159918),'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'(_20159906,_20158088,_20159918,_20158100).

'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'(_20160400,_20160402,_20160404,_20160406):-freeze(_20160404,'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'(_20160400,_20160402,_20160404,_20160406)).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'('Prelude.(,)'(_20157718,_20157736),_20160770,_20160776,_20160782):-!,hnf(_20157736,_20160770,_20160776,_20160782).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'('FAIL'(_20161390),'FAIL'(_20161390),_20161404,_20161404):-nonvar(_20161390).

'XML.xmlUnquoteSpecial'(_20162386,_20162388,_20162390,_20162392,_20162394):-freeze(_20162392,'blocked_XML.xmlUnquoteSpecial'(_20162386,_20162388,_20162390,_20162392,_20162394)).
'blocked_XML.xmlUnquoteSpecial'(_20162482,_20162500,_20185356,_20185362,_20185368):-makeShare(_20162482,_20179238),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20179238,['^l','^t']),_20186600,_20185362,_20186566),'blocked_XML.xmlUnquoteSpecial_ComplexCase'(_20186600,_20179238,_20162500,_20185356,_20186566,_20185368).

'blocked_XML.xmlUnquoteSpecial_ComplexCase'(_20187028,_20187030,_20187032,_20187034,_20187036,_20187038):-freeze(_20187036,freeze(_20187028,'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'(_20187028,_20187030,_20187032,_20187034,_20187036,_20187038))).
'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'('Prelude.True',_20179238,_20162500,[^<|'XML.xmlUnquoteSpecials'(_20162500)],_20187438,_20187438).
'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'('Prelude.False',_20179238,_20162500,_20195520,_20195526,_20195532):-!,makeShare(_20179238,_20189580),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20189580,['^g','^t']),_20197912,_20195526,_20197878),'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'(_20197912,_20189580,_20162500,_20195520,_20197878,_20195532).

'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'(_20198562,_20198564,_20198566,_20198568,_20198570,_20198572):-freeze(_20198570,freeze(_20198562,'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'(_20198562,_20198564,_20198566,_20198568,_20198570,_20198572))).
'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20189580,_20162500,[^>|'XML.xmlUnquoteSpecials'(_20162500)],_20198972,_20198972).
'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20189580,_20162500,_20207276,_20207282,_20207288):-!,makeShare(_20189580,_20201256),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20201256,['^a','^m','^p']),_20210892,_20207282,_20210858),'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20210892,_20201256,_20162500,_20207276,_20210858,_20207288).

'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20211746,_20211748,_20211750,_20211752,_20211754,_20211756):-freeze(_20211754,freeze(_20211746,'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20211746,_20211748,_20211750,_20211752,_20211754,_20211756))).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20201256,_20162500,[^&|'XML.xmlUnquoteSpecials'(_20162500)],_20212156,_20212156).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20201256,_20162500,_20220654,_20220660,_20220666):-!,makeShare(_20201256,_20214578),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20214578,['^q','^u','^o','^t']),_20225494,_20220660,_20225460),'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20225494,_20214578,_20162500,_20220654,_20225460,_20220666).

'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20226552,_20226554,_20226556,_20226558,_20226560,_20226562):-freeze(_20226560,freeze(_20226552,'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20226552,_20226554,_20226556,_20226558,_20226560,_20226562))).
'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20214578,_20162500,['^"'|'XML.xmlUnquoteSpecials'(_20162500)],_20226962,_20226962).
'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20214578,_20162500,_20235452,_20235458,_20235464):-!,makeShare(_20214578,_20229518),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20229518,['^a','^p','^o','^s']),_20241516,_20235458,_20241482),'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20241516,_20229518,_20162500,_20235452,_20241482,_20235464).

'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20242778,_20242780,_20242782,_20242784,_20242786,_20242788):-freeze(_20242786,freeze(_20242778,'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20242778,_20242780,_20242782,_20242784,_20242786,_20242788))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20229518,_20162500,['^\''|'XML.xmlUnquoteSpecials'(_20162500)],_20243188,_20243188).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20229518,_20162500,_20251670,_20251676,_20251682):-!,makeShare(_20229518,_20245878),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20245878,['^a','^u','^m','^l']),_20258958,_20251676,_20258924),'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20258958,_20245878,_20162500,_20251670,_20258924,_20251682).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20260424,_20260426,_20260428,_20260430,_20260432,_20260434):-freeze(_20260432,freeze(_20260424,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20260424,_20260426,_20260428,_20260430,_20260432,_20260434))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20245878,_20162500,['^228'|'XML.xmlUnquoteSpecials'(_20162500)],_20260834,_20260834).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20245878,_20162500,_20269320,_20269326,_20269332):-!,makeShare(_20245878,_20263670),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20263670,['^o','^u','^m','^l']),_20277832,_20269326,_20277798),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20277832,_20263670,_20162500,_20269320,_20277798,_20269332).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20279502,_20279504,_20279506,_20279508,_20279510,_20279512):-freeze(_20279510,freeze(_20279502,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20279502,_20279504,_20279506,_20279508,_20279510,_20279512))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20263670,_20162500,['^246'|'XML.xmlUnquoteSpecials'(_20162500)],_20279912,_20279912).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20263670,_20162500,_20288390,_20288396,_20288402):-!,makeShare(_20263670,_20282882),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20282882,['^u','^u','^m','^l']),_20298126,_20288396,_20298092),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20298126,_20282882,_20162500,_20288390,_20298092,_20288402).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20300000,_20300002,_20300004,_20300006,_20300008,_20300010):-freeze(_20300008,freeze(_20300000,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20300000,_20300002,_20300004,_20300006,_20300008,_20300010))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20282882,_20162500,['^252'|'XML.xmlUnquoteSpecials'(_20162500)],_20300410,_20300410).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20282882,_20162500,_20308880,_20308886,_20308892):-!,makeShare(_20282882,_20303514),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20303514,['^A','^u','^m','^l']),_20319840,_20308886,_20319806),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20319840,_20303514,_20162500,_20308880,_20319806,_20308892).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20321918,_20321920,_20321922,_20321924,_20321926,_20321928):-freeze(_20321926,freeze(_20321918,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20321918,_20321920,_20321922,_20321924,_20321926,_20321928))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20303514,_20162500,['^196'|'XML.xmlUnquoteSpecials'(_20162500)],_20322328,_20322328).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20303514,_20162500,_20330790,_20330796,_20330802):-!,makeShare(_20303514,_20325566),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20325566,['^O','^u','^m','^l']),_20342974,_20330796,_20342940),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20342974,_20325566,_20162500,_20330790,_20342940,_20330802).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20345256,_20345258,_20345260,_20345262,_20345264,_20345266):-freeze(_20345264,freeze(_20345256,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20345256,_20345258,_20345260,_20345262,_20345264,_20345266))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20325566,_20162500,['^214'|'XML.xmlUnquoteSpecials'(_20162500)],_20345666,_20345666).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20325566,_20162500,_20354120,_20354126,_20354132):-!,makeShare(_20325566,_20349038),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20349038,['^U','^u','^m','^l']),_20367528,_20354126,_20367494),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20367528,_20349038,_20162500,_20354120,_20367494,_20354132).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20370014,_20370016,_20370018,_20370020,_20370022,_20370024):-freeze(_20370022,freeze(_20370014,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20370014,_20370016,_20370018,_20370020,_20370022,_20370024))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20349038,_20162500,['^220'|'XML.xmlUnquoteSpecials'(_20162500)],_20370424,_20370424).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20349038,_20162500,_20379044,_20379050,_20379056):-!,makeShare(_20349038,_20373930),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_20373930,['^s','^z','^l','^i','^g']),_20393676,_20379050,_20393642),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20393676,_20373930,_20162500,_20379044,_20393642,_20379056).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20396366,_20396368,_20396370,_20396372,_20396374,_20396376):-freeze(_20396374,freeze(_20396366,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20396366,_20396368,_20396370,_20396372,_20396374,_20396376))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20373930,_20162500,['^223'|'XML.xmlUnquoteSpecials'(_20162500)],_20396776,_20396776).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20373930,_20162500,_20403510,_20403516,_20403522):-!,hnf('Prelude.otherwise',_20419366,_20403516,_20419332),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20419366,_20373930,_20162500,_20403510,_20419332,_20403522).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20422248,_20422250,_20422252,_20422254,_20422256,_20422258):-freeze(_20422256,freeze(_20422248,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20422248,_20422250,_20422252,_20422254,_20422256,_20422258))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20373930,_20162500,_20422652,_20422658,_20422664):-hnf('Prelude.++'('XML.unquoteUnicode'(_20373930),'XML.xmlUnquoteSpecials'(_20162500)),_20422652,_20422658,_20422664).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20373930,_20162500,_20426772,_20426778,_20426784):-!,hnf(reportFailure4PAKCS('XML.xmlUnquoteSpecial',['Prelude.False']),_20426772,_20426778,_20426784).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20430566),_20373930,_20162500,'FAIL'(_20430566),_20430580,_20430580).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20430648),_20373930,_20162500,'FAIL'(_20430648),_20430662,_20430662).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20430730),_20349038,_20162500,'FAIL'(_20430730),_20430744,_20430744).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20430812),_20325566,_20162500,'FAIL'(_20430812),_20430826,_20430826).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20430894),_20303514,_20162500,'FAIL'(_20430894),_20430908,_20430908).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20430976),_20282882,_20162500,'FAIL'(_20430976),_20430990,_20430990).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20431058),_20263670,_20162500,'FAIL'(_20431058),_20431072,_20431072).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20431140),_20245878,_20162500,'FAIL'(_20431140),_20431154,_20431154).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20431222),_20229518,_20162500,'FAIL'(_20431222),_20431236,_20431236).
'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20431304),_20214578,_20162500,'FAIL'(_20431304),_20431318,_20431318).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20431386),_20201256,_20162500,'FAIL'(_20431386),_20431400,_20431400).
'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20431468),_20189580,_20162500,'FAIL'(_20431468),_20431482,_20431482).
'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'('FAIL'(_20431550),_20179238,_20162500,'FAIL'(_20431550),_20431564,_20431564).

'XML.unquoteUnicode'(_20432444,_20432446,_20432448,_20432450):-freeze(_20432448,'blocked_XML.unquoteUnicode'(_20432444,_20432446,_20432448,_20432450)).
'blocked_XML.unquoteUnicode'(_20432530,_20435148,_20435154,_20435160):-hnf(_20432530,_20436174,_20435154,_20436186),'blocked_XML.unquoteUnicode_1'(_20436174,_20435148,_20436186,_20435160).

'blocked_XML.unquoteUnicode_1'(_20436536,_20436538,_20436540,_20436542):-freeze(_20436540,'blocked_blocked_XML.unquoteUnicode_1'(_20436536,_20436538,_20436540,_20436542)).
'blocked_blocked_XML.unquoteUnicode_1'([],[],_20436784,_20436784).
'blocked_blocked_XML.unquoteUnicode_1'([_20432746|_20432764],_20439394,_20439400,_20439406):-!,makeShare(_20432746,_20437600),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20437600,^#),_20441002,_20439400,_20440968),'blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'(_20441002,_20437600,_20432764,_20439394,_20440968,_20439406).

'blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'(_20441514,_20441516,_20441518,_20441520,_20441522,_20441524):-freeze(_20441522,freeze(_20441514,'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'(_20441514,_20441516,_20441518,_20441520,_20441522,_20441524))).
'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'('Prelude.True',_20437600,_20432764,_20441918,_20441924,_20441930):-makeShare(_20433056,_20442128),makeShare(_20432764,_20442148),hnf('Prelude.cond'(letrec4PAKCS(_20442128,_20442148),'XML.unquoteUnicode._\'23caseor0'(_20442128,_20437600,_20442148,_20442128)),_20441918,_20441924,_20441930).
'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'('Prelude.False',_20437600,_20432764,_20445652,_20445658,_20445664):-!,hnf('Prelude.otherwise',_20448440,_20445658,_20448406),'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20448440,_20437600,_20432764,_20445652,_20448406,_20445664).

'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20449144,_20449146,_20449148,_20449150,_20449152,_20449154):-freeze(_20449152,freeze(_20449144,'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20449144,_20449146,_20449148,_20449150,_20449152,_20449154))).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20437600,_20432764,[^&|'Prelude.++'([_20437600|_20432764],['^;'])],_20449554,_20449554).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20437600,_20432764,_20451630,_20451636,_20451642):-!,hnf(reportFailure4PAKCS('XML.unquoteUnicode',['Prelude.False']),_20451630,_20451636,_20451642).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20453228),_20437600,_20432764,'FAIL'(_20453228),_20453242,_20453242).
'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'('FAIL'(_20453310),_20437600,_20432764,'FAIL'(_20453310),_20453324,_20453324).
'blocked_blocked_XML.unquoteUnicode_1'('FAIL'(_20453392),'FAIL'(_20453392),_20453406,_20453406):-nonvar(_20453392).

'XML.unquoteUnicode.extr.117'(_20454616,_20454618,_20454620,_20454622,_20454624,_20454626):-freeze(_20454624,'blocked_XML.unquoteUnicode.extr.117'(_20454616,_20454618,_20454620,_20454622,_20454624,_20454626)).
'blocked_XML.unquoteUnicode.extr.117'(_20454722,_20454740,_20454758,_20474502,_20474508,_20474514):-hnf(_20454758,_20475868,_20474508,_20475892),'blocked_XML.unquoteUnicode.extr.117_3'(_20475868,_20454722,_20454740,_20474502,_20475892,_20474514).

'blocked_XML.unquoteUnicode.extr.117_3'(_20476318,_20476320,_20476322,_20476324,_20476326,_20476328):-freeze(_20476326,freeze(_20476318,'blocked_blocked_XML.unquoteUnicode.extr.117_3'(_20476318,_20476320,_20476322,_20476324,_20476326,_20476328))).
'blocked_blocked_XML.unquoteUnicode.extr.117_3'([_20454874|_20454892],_20454722,_20454740,_20476914,_20476920,_20476926):-hnf(_20454874,_20478760,_20476920,_20478790),'blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'(_20478760,_20454892,_20454722,_20454740,_20476914,_20478790,_20476926).

'blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'(_20479308,_20479310,_20479312,_20479314,_20479316,_20479318,_20479320):-freeze(_20479318,freeze(_20479308,'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'(_20479308,_20479310,_20479312,_20479314,_20479316,_20479318,_20479320))).
'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'('Prelude.(,)'(_20455020,_20455038),_20454892,_20454722,_20454740,_20480106,_20480112,_20480118):-!,hnf(_20455038,_20482704,_20480112,_20482740),'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'(_20482704,_20455020,_20454892,_20454722,_20454740,_20480106,_20482740,_20480118).

'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'(_20483416,_20483418,_20483420,_20483422,_20483424,_20483426,_20483428,_20483430):-freeze(_20483428,freeze(_20483416,'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'(_20483416,_20483418,_20483420,_20483422,_20483424,_20483426,_20483428,_20483430))).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'([],_20455020,_20454892,_20454722,_20454740,_20484228,_20484234,_20484240):-hnf(_20454892,_20487356,_20484234,_20487386),'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'(_20487356,_20455020,_20454722,_20454740,_20484228,_20487386,_20484240).

'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'(_20488114,_20488116,_20488118,_20488120,_20488122,_20488124,_20488126):-freeze(_20488124,freeze(_20488114,'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'(_20488114,_20488116,_20488118,_20488120,_20488122,_20488124,_20488126))).
'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'([],_20455020,_20454722,_20454740,_20488392,_20488398,_20488404):-hnf(_20455020,_20488392,_20488398,_20488404).
'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'([_20455350|_20455368],_20455020,_20454722,_20454740,_20489490,_20489496,_20489502):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^X','^M','^L',^.,'^u','^n','^q','^o','^t','^e','^U','^n','^i','^c','^o','^d','^e',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^s','^t','^r','^i','^n','^g','^ ','^\''],[_20454722|'Prelude.++'(_20454740,['^\''])])),_20489490,_20489496,_20489502).
'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'('FAIL'(_20499104),_20455020,_20454722,_20454740,'FAIL'(_20499104),_20499118,_20499118).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'([_20461692|_20461710],_20455020,_20454892,_20454722,_20454740,_20499384,_20499390,_20499396):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^X','^M','^L',^.,'^u','^n','^q','^o','^t','^e','^U','^n','^i','^c','^o','^d','^e',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^s','^t','^r','^i','^n','^g','^ ','^\''],[_20454722|'Prelude.++'(_20454740,['^\''])])),_20499384,_20499390,_20499396).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'('FAIL'(_20508994),_20455020,_20454892,_20454722,_20454740,'FAIL'(_20508994),_20509008,_20509008).
'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'('FAIL'(_20509092),_20454892,_20454722,_20454740,'FAIL'(_20509092),_20509106,_20509106).
'blocked_blocked_XML.unquoteUnicode.extr.117_3'([],_20454722,_20454740,_20509344,_20509350,_20509356):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^X','^M','^L',^.,'^u','^n','^q','^o','^t','^e','^U','^n','^i','^c','^o','^d','^e',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^s','^t','^r','^i','^n','^g','^ ','^\''],[_20454722|'Prelude.++'(_20454740,['^\''])])),_20509344,_20509350,_20509356).
'blocked_blocked_XML.unquoteUnicode.extr.117_3'('FAIL'(_20518458),_20454722,_20454740,'FAIL'(_20518458),_20518472,_20518472).

'XML.readXmlFile'(_20519238,_20519240,_20519242,_20519244):-freeze(_20519242,'blocked_XML.readXmlFile'(_20519238,_20519240,_20519242,_20519244)).
'blocked_XML.readXmlFile'(_20519324,_20519830,_20519836,_20519842):-makeShare(_20519324,_20519924),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_20519924)),partcall(1,'XML.readXmlFile._\'23lambda4',[_20519924])),_20519830,_20519836,_20519842).

'XML.readXmlFile._\'23lambda4'(_20522906,_20522908,_20522910,_20522912,_20522914):-freeze(_20522912,'blocked_XML.readXmlFile._\'23lambda4'(_20522906,_20522908,_20522910,_20522912,_20522914)).
'blocked_XML.readXmlFile._\'23lambda4'(_20523002,_20523020,_20524102,_20524108,_20524114):-makeShare(_20523048,_20524398),makeShare(_20523066,_20524418),hnf('Prelude.cond'(letrec4PAKCS(_20524398,_20523020),'Prelude.cond'(letrec4PAKCS(_20524418,'XML.parseXmlString'(_20524398)),'XML.readXmlFile._\'23lambda4._\'23caseor0'('Prelude.null'(_20524418),_20524418,_20523002))),_20524102,_20524108,_20524114).

'XML.readUnsafeXmlFile'(_20528278,_20528280,_20528282,_20528284):-freeze(_20528282,'blocked_XML.readUnsafeXmlFile'(_20528278,_20528280,_20528282,_20528284)).
'blocked_XML.readUnsafeXmlFile'(_20528364,_20529136,_20529142,_20529148):-hnf('Prelude.catch'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','XML.readXmlFile'(_20528364)),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Just')),partcall(1,'XML.readUnsafeXmlFile._\'23lambda6',[])),_20529136,_20529142,_20529148).

'XML.readUnsafeXmlFile._\'23lambda6'(_20533180,_20533182,_20533184,_20533186):-freeze(_20533184,'blocked_XML.readUnsafeXmlFile._\'23lambda6'(_20533180,_20533182,_20533184,_20533186)).
'blocked_XML.readUnsafeXmlFile._\'23lambda6'(_20533266,_20533464,_20533470,_20533476):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Nothing'),_20533464,_20533470,_20533476).

'XML.showXmlFile'(_20535326,_20535328,_20535330,_20535332):-freeze(_20535330,'blocked_XML.showXmlFile'(_20535326,_20535328,_20535330,_20535332)).
'blocked_XML.showXmlFile'(_20535412,_20536016,_20536022,_20536028):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','XML.readXmlFile'(_20535412)),'Prelude..'(partcall(1,'Prelude.putStr',[]),partcall(1,'XML.showXmlDoc',[]))),_20536016,_20536022,_20536028).

'XML.readFileWithXmlDocs'(_20538970,_20538972,_20538974,_20538976):-freeze(_20538974,'blocked_XML.readFileWithXmlDocs'(_20538970,_20538972,_20538974,_20538976)).
'blocked_XML.readFileWithXmlDocs'(_20539056,_20539660,_20539666,_20539672):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_20539056)),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',partcall(1,'XML.parseXmlString',[]))),_20539660,_20539666,_20539672).

'XML.parseXmlString'(_20542742,_20542744,_20542746,_20542748):-freeze(_20542746,'blocked_XML.parseXmlString'(_20542742,_20542744,_20542746,_20542748)).
'blocked_XML.parseXmlString'(_20542828,_20543180,_20543186,_20543192):-hnf('Prelude.fst'('XML.parseXmlTokens'('XML.scanXmlString'(_20542828),'Prelude.Nothing')),_20543180,_20543186,_20543192).

'XML.parseXmlTokens'(_20545140,_20545142,_20545144,_20545146,_20545148):-freeze(_20545146,'blocked_XML.parseXmlTokens'(_20545140,_20545142,_20545144,_20545146,_20545148)).
'blocked_XML.parseXmlTokens'(_20545236,_20545254,_20569964,_20569970,_20569976):-hnf(_20545236,_20570998,_20569970,_20571016),'blocked_XML.parseXmlTokens_1'(_20570998,_20545254,_20569964,_20571016,_20569976).

'blocked_XML.parseXmlTokens_1'(_20571374,_20571376,_20571378,_20571380,_20571382):-freeze(_20571380,'blocked_blocked_XML.parseXmlTokens_1'(_20571374,_20571376,_20571378,_20571380,_20571382)).
'blocked_blocked_XML.parseXmlTokens_1'([],_20545254,_20571872,_20571878,_20571884):-hnf(_20545254,_20573356,_20571878,_20573368),'blocked_blocked_XML.parseXmlTokens_1_[]_1'(_20573356,_20571872,_20573368,_20571884).

'blocked_blocked_XML.parseXmlTokens_1_[]_1'(_20573796,_20573798,_20573800,_20573802):-freeze(_20573800,'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'(_20573796,_20573798,_20573800,_20573802)).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'('Prelude.Nothing','Prelude.(,)'([],[]),_20574216,_20574216).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'('Prelude.Just'(_20545736),_20575194,_20575200,_20575206):-!,hnf('Prelude.error'(['^X','^M','^L',^.,'^p','^a','^r','^s','^e','^X','^m','^l','^T','^o','^k','^e','^n','^s',^:,'^ ','^i','^n','^c','^o','^m','^p','^l','^e','^t','^e','^ ','^p','^a','^r','^s','^e']),_20575194,_20575200,_20575206).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'('FAIL'(_20583166),'FAIL'(_20583166),_20583180,_20583180):-nonvar(_20583166).
'blocked_blocked_XML.parseXmlTokens_1'([_20551494|_20551512],_20545254,_20583672,_20583678,_20583684):-!,hnf(_20551494,_20585186,_20583678,_20585210),'blocked_blocked_XML.parseXmlTokens_1_[|]_1'(_20585186,_20551512,_20545254,_20583672,_20585210,_20583684).

'blocked_blocked_XML.parseXmlTokens_1_[|]_1'(_20585678,_20585680,_20585682,_20585684,_20585686,_20585688):-freeze(_20585686,'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'(_20585678,_20585680,_20585682,_20585684,_20585686,_20585688)).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'('XML.XText'(_20551640),_20551512,_20545254,_20586050,_20586056,_20586062):-makeShare(_20551674,_20586552),makeShare(_20551692,_20586572),makeShare(_20551710,_20586592),hnf('Prelude.cond'(letrec4PAKCS(_20586552,'XML.parseXmlTokens'(_20551512,_20545254)),'Prelude.cond'(letrec4PAKCS(_20586572,'XML.parseXmlTokens._\'23selFP7\'23xexps'(_20586552)),'Prelude.cond'(letrec4PAKCS(_20586592,'XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_20586552)),'Prelude.(,)'(['XML.XText'('XML.xmlUnquoteSpecials'(_20551640))|_20586572],_20586592)))),_20586050,_20586056,_20586062).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'('XML.XElem'(_20553554,_20553572,_20553590),_20551512,_20545254,_20592026,_20592032,_20592038):-!,hnf(_20553554,_20594232,_20592032,_20594268),'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'(_20594232,_20553572,_20553590,_20551512,_20545254,_20592026,_20594268,_20592038).

'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'(_20594872,_20594874,_20594876,_20594878,_20594880,_20594882,_20594884,_20594886):-freeze(_20594884,'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'(_20594872,_20594874,_20594876,_20594878,_20594880,_20594882,_20594884,_20594886)).
'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'([_20553724|_20553742],_20553572,_20553590,_20551512,_20545254,_20606636,_20606642,_20606648):-makeShare(_20553724,_20600586),makeShare(_20553742,_20600606),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20600586,^<),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23Prelude.Char\'23','Prelude.head'(_20600606)),^/)),_20609524,_20606642,_20609466),'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'(_20609524,_20600586,_20600606,_20553572,_20553590,_20551512,_20545254,_20606636,_20609466,_20606648).

'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'(_20610242,_20610244,_20610246,_20610248,_20610250,_20610252,_20610254,_20610256,_20610258,_20610260):-freeze(_20610258,freeze(_20610242,'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'(_20610242,_20610244,_20610246,_20610248,_20610250,_20610252,_20610254,_20610256,_20610258,_20610260))).
'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'('Prelude.True',_20600586,_20600606,_20553572,_20553590,_20551512,_20545254,_20610686,_20610692,_20610698):-makeShare(_20554594,_20612048),makeShare(_20600606,_20612068),makeShare(_20554612,_20612088),makeShare(_20554630,_20612108),makeShare(_20554648,_20612128),makeShare(_20554666,_20612148),makeShare(_20554684,_20612168),hnf('Prelude.cond'(letrec4PAKCS(_20612048,'XML.parseXmlTokens'(_20551512,'Prelude.Just'(_20612068))),'Prelude.cond'(letrec4PAKCS(_20612088,'XML.parseXmlTokens._\'23selFP13\'23xexps1'(_20612048)),'Prelude.cond'(letrec4PAKCS(_20612108,'XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_20612048)),'Prelude.cond'(letrec4PAKCS(_20612128,'XML.parseXmlTokens'(_20612108,_20545254)),'Prelude.cond'(letrec4PAKCS(_20612148,'XML.parseXmlTokens._\'23selFP11\'23xexps'(_20612128)),'Prelude.cond'(letrec4PAKCS(_20612168,'XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_20612128)),'Prelude.(,)'(['XML.XElem'(_20612068,_20553572,_20612088)|_20612148],_20612168))))))),_20610686,_20610692,_20610698).
'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'('Prelude.False',_20600586,_20600606,_20553572,_20553590,_20551512,_20545254,_20628524,_20628530,_20628536):-!,makeShare(_20600586,_20623856),makeShare(_20600606,_20623876),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20623856,^<),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_20623876),^/)),_20632592,_20628530,_20632534),'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20632592,_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,_20628524,_20632534,_20628536).

'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20633532,_20633534,_20633536,_20633538,_20633540,_20633542,_20633544,_20633546,_20633548,_20633550):-freeze(_20633548,freeze(_20633532,'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20633532,_20633534,_20633536,_20633538,_20633540,_20633542,_20633544,_20633546,_20633548,_20633550))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,_20638778,_20638784,_20638790):-makeShare(_20623876,_20634812),makeShare(_20545254,_20634832),hnf('Prelude.maybe'('Prelude.False',partcall(1,'Prelude.flip',['Prelude.tail'(_20634812),partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_20634832),_20644040,_20638784,_20643982),'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'(_20644040,_20623856,_20634812,_20553572,_20553590,_20551512,_20634832,_20638778,_20643982,_20638790).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'(_20645160,_20645162,_20645164,_20645166,_20645168,_20645170,_20645172,_20645174,_20645176,_20645178):-freeze(_20645176,freeze(_20645160,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'(_20645160,_20645162,_20645164,_20645166,_20645168,_20645170,_20645172,_20645174,_20645176,_20645178))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_20623856,_20634812,_20553572,_20553590,_20551512,_20634832,'Prelude.(,)'([],_20551512),_20645610,_20645610).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_20623856,_20634812,_20553572,_20553590,_20551512,_20634832,_20647694,_20647700,_20647706):-!,makeShare(_20559512,_20648410),makeShare(_20559530,_20648430),makeShare(_20559548,_20648450),hnf('Prelude.cond'(letrec4PAKCS(_20648410,'XML.parseXmlTokens'(_20551512,_20634832)),'Prelude.cond'(letrec4PAKCS(_20648430,'XML.parseXmlTokens._\'23selFP16\'23xexps'(_20648410)),'Prelude.cond'(letrec4PAKCS(_20648450,'XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_20648410)),'Prelude.(,)'(['XML.XElem'(_20634812,_20553572,_20553590)|_20648430],_20648450)))),_20647694,_20647700,_20647706).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_20654094),_20623856,_20634812,_20553572,_20553590,_20551512,_20634832,'FAIL'(_20654094),_20654108,_20654108).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,_20657338,_20657344,_20657350):-!,hnf('Prelude.otherwise',_20662630,_20657344,_20662572),'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20662630,_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,_20657338,_20662572,_20657350).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20663750,_20663752,_20663754,_20663756,_20663758,_20663760,_20663762,_20663764,_20663766,_20663768):-freeze(_20663766,freeze(_20663750,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20663750,_20663752,_20663754,_20663756,_20663758,_20663760,_20663762,_20663764,_20663766,_20663768))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,_20664194,_20664200,_20664206):-makeShare(_20561576,_20665022),makeShare(_20561594,_20665042),makeShare(_20561612,_20665062),hnf('Prelude.cond'(letrec4PAKCS(_20665022,'XML.parseXmlTokens'(_20551512,_20545254)),'Prelude.cond'(letrec4PAKCS(_20665042,'XML.parseXmlTokens._\'23selFP19\'23xexps'(_20665022)),'Prelude.cond'(letrec4PAKCS(_20665062,'XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_20665022)),'Prelude.(,)'(['XML.XElem'([_20623856|_20623876],_20553572,_20553590)|_20665042],_20665062)))),_20664194,_20664200,_20664206).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,_20671190,_20671196,_20671202):-!,hnf(reportFailure4PAKCS('XML.parseXmlTokens',['Prelude.False']),_20671190,_20671196,_20671202).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20673492),_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,'FAIL'(_20673492),_20673506,_20673506).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20673606),_20623856,_20623876,_20553572,_20553590,_20551512,_20545254,'FAIL'(_20673606),_20673620,_20673620).
'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'('FAIL'(_20673720),_20600586,_20600606,_20553572,_20553590,_20551512,_20545254,'FAIL'(_20673720),_20673734,_20673734).
'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'([],_20553572,_20553590,_20551512,_20545254,_20673996,_20674002,_20674008):-!,hnf('Prelude.error'(['^X','^M','^L',^.,'^p','^a','^r','^s','^e','^X','^m','^l','^T','^o','^k','^e','^n','^s',^:,'^ ','^i','^n','^c','^o','^m','^p','^l','^e','^t','^e','^ ','^p','^a','^r','^s','^e']),_20673996,_20674002,_20674008).
'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'('FAIL'(_20682324),_20553572,_20553590,_20551512,_20545254,'FAIL'(_20682324),_20682338,_20682338):-nonvar(_20682324).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'('FAIL'(_20682426),_20551512,_20545254,'FAIL'(_20682426),_20682440,_20682440):-nonvar(_20682426).
'blocked_blocked_XML.parseXmlTokens_1'('FAIL'(_20682512),_20545254,'FAIL'(_20682512),_20682526,_20682526):-nonvar(_20682512).

'XML.parseXmlTokens._\'23selFP7\'23xexps'(_20684028,_20684030,_20684032,_20684034):-freeze(_20684032,'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps'(_20684028,_20684030,_20684032,_20684034)).
'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps'(_20684114,_20684582,_20684588,_20684594):-hnf(_20684114,_20686292,_20684588,_20686304),'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'(_20686292,_20684582,_20686304,_20684594).

'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'(_20686768,_20686770,_20686772,_20686774):-freeze(_20686772,'blocked_blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'(_20686768,_20686770,_20686772,_20686774)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'('Prelude.(,)'(_20684230,_20684248),_20687138,_20687144,_20687150):-!,hnf(_20684230,_20687138,_20687144,_20687150).
'blocked_blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'('FAIL'(_20687740),'FAIL'(_20687740),_20687754,_20687754):-nonvar(_20687740).

'XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_20689476,_20689478,_20689480,_20689482):-freeze(_20689480,'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_20689476,_20689478,_20689480,_20689482)).
'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_20689562,_20690066,_20690072,_20690078):-hnf(_20689562,_20691992,_20690072,_20692004),'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'(_20691992,_20690066,_20692004,_20690078).

'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'(_20692504,_20692506,_20692508,_20692510):-freeze(_20692508,'blocked_blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'(_20692504,_20692506,_20692508,_20692510)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'('Prelude.(,)'(_20689678,_20689696),_20692874,_20692880,_20692886):-!,hnf(_20689696,_20692874,_20692880,_20692886).
'blocked_blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'('FAIL'(_20693512),'FAIL'(_20693512),_20693526,_20693526):-nonvar(_20693512).

'XML.parseXmlTokens._\'23selFP13\'23xexps1'(_20695096,_20695098,_20695100,_20695102):-freeze(_20695100,'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1'(_20695096,_20695098,_20695100,_20695102)).
'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1'(_20695182,_20695662,_20695668,_20695674):-hnf(_20695182,_20697444,_20695668,_20697456),'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'(_20697444,_20695662,_20697456,_20695674).

'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'(_20697932,_20697934,_20697936,_20697938):-freeze(_20697936,'blocked_blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'(_20697932,_20697934,_20697936,_20697938)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'('Prelude.(,)'(_20695298,_20695316),_20698302,_20698308,_20698314):-!,hnf(_20695298,_20698302,_20698308,_20698314).
'blocked_blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'('FAIL'(_20698916),'FAIL'(_20698916),_20698930,_20698930):-nonvar(_20698916).

'XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_20700576,_20700578,_20700580,_20700582):-freeze(_20700580,'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_20700576,_20700578,_20700580,_20700582)).
'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_20700662,_20701154,_20701160,_20701166):-hnf(_20700662,_20703008,_20701160,_20703020),'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'(_20703008,_20701154,_20703020,_20701166).

'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'(_20703508,_20703510,_20703512,_20703514):-freeze(_20703512,'blocked_blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'(_20703508,_20703510,_20703512,_20703514)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'('Prelude.(,)'(_20700778,_20700796),_20703878,_20703884,_20703890):-!,hnf(_20700796,_20703878,_20703884,_20703890).
'blocked_blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'('FAIL'(_20704504),'FAIL'(_20704504),_20704518,_20704518):-nonvar(_20704504).

'XML.parseXmlTokens._\'23selFP11\'23xexps'(_20706050,_20706052,_20706054,_20706056):-freeze(_20706054,'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps'(_20706050,_20706052,_20706054,_20706056)).
'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps'(_20706136,_20706610,_20706616,_20706622):-hnf(_20706136,_20708356,_20706616,_20708368),'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'(_20708356,_20706610,_20708368,_20706622).

'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'(_20708838,_20708840,_20708842,_20708844):-freeze(_20708842,'blocked_blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'(_20708838,_20708840,_20708842,_20708844)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'('Prelude.(,)'(_20706252,_20706270),_20709208,_20709214,_20709220):-!,hnf(_20706252,_20709208,_20709214,_20709220).
'blocked_blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'('FAIL'(_20709816),'FAIL'(_20709816),_20709830,_20709830):-nonvar(_20709816).

'XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_20711590,_20711592,_20711594,_20711596):-freeze(_20711594,'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_20711590,_20711592,_20711594,_20711596)).
'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_20711676,_20712186,_20712192,_20712198):-hnf(_20711676,_20714148,_20712192,_20714160),'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'(_20714148,_20712186,_20714160,_20712198).

'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'(_20714666,_20714668,_20714670,_20714672):-freeze(_20714670,'blocked_blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'(_20714666,_20714668,_20714670,_20714672)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'('Prelude.(,)'(_20711792,_20711810),_20715036,_20715042,_20715048):-!,hnf(_20711810,_20715036,_20715042,_20715048).
'blocked_blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'('FAIL'(_20715680),'FAIL'(_20715680),_20715694,_20715694):-nonvar(_20715680).

'XML.parseXmlTokens._\'23selFP16\'23xexps'(_20717226,_20717228,_20717230,_20717232):-freeze(_20717230,'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps'(_20717226,_20717228,_20717230,_20717232)).
'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps'(_20717312,_20717786,_20717792,_20717798):-hnf(_20717312,_20719532,_20717792,_20719544),'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'(_20719532,_20717786,_20719544,_20717798).

'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'(_20720014,_20720016,_20720018,_20720020):-freeze(_20720018,'blocked_blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'(_20720014,_20720016,_20720018,_20720020)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'('Prelude.(,)'(_20717428,_20717446),_20720384,_20720390,_20720396):-!,hnf(_20717428,_20720384,_20720390,_20720396).
'blocked_blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'('FAIL'(_20720992),'FAIL'(_20720992),_20721006,_20721006):-nonvar(_20720992).

'XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_20722766,_20722768,_20722770,_20722772):-freeze(_20722770,'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_20722766,_20722768,_20722770,_20722772)).
'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_20722852,_20723362,_20723368,_20723374):-hnf(_20722852,_20725324,_20723368,_20725336),'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'(_20725324,_20723362,_20725336,_20723374).

'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'(_20725842,_20725844,_20725846,_20725848):-freeze(_20725846,'blocked_blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'(_20725842,_20725844,_20725846,_20725848)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'('Prelude.(,)'(_20722968,_20722986),_20726212,_20726218,_20726224):-!,hnf(_20722986,_20726212,_20726218,_20726224).
'blocked_blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'('FAIL'(_20726856),'FAIL'(_20726856),_20726870,_20726870):-nonvar(_20726856).

'XML.parseXmlTokens._\'23selFP19\'23xexps'(_20728402,_20728404,_20728406,_20728408):-freeze(_20728406,'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps'(_20728402,_20728404,_20728406,_20728408)).
'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps'(_20728488,_20728962,_20728968,_20728974):-hnf(_20728488,_20730708,_20728968,_20730720),'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'(_20730708,_20728962,_20730720,_20728974).

'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'(_20731190,_20731192,_20731194,_20731196):-freeze(_20731194,'blocked_blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'(_20731190,_20731192,_20731194,_20731196)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'('Prelude.(,)'(_20728604,_20728622),_20731560,_20731566,_20731572):-!,hnf(_20728604,_20731560,_20731566,_20731572).
'blocked_blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'('FAIL'(_20732168),'FAIL'(_20732168),_20732182,_20732182):-nonvar(_20732168).

'XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_20733942,_20733944,_20733946,_20733948):-freeze(_20733946,'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_20733942,_20733944,_20733946,_20733948)).
'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_20734028,_20734538,_20734544,_20734550):-hnf(_20734028,_20736500,_20734544,_20736512),'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'(_20736500,_20734538,_20736512,_20734550).

'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'(_20737018,_20737020,_20737022,_20737024):-freeze(_20737022,'blocked_blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'(_20737018,_20737020,_20737022,_20737024)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'('Prelude.(,)'(_20734144,_20734162),_20737388,_20737394,_20737400):-!,hnf(_20734162,_20737388,_20737394,_20737400).
'blocked_blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'('FAIL'(_20738032),'FAIL'(_20738032),_20738046,_20738046):-nonvar(_20738032).

'XML.scanXmlString'(_20738876,_20738878,_20738880,_20738882):-freeze(_20738880,'blocked_XML.scanXmlString'(_20738876,_20738878,_20738880,_20738882)).
'blocked_XML.scanXmlString'(_20738962,_20739230,_20739236,_20739242):-hnf('XML.scanXmlString.scanXml.169'('Prelude.apply'('XML.dropBlanks',_20738962)),_20739230,_20739236,_20739242).

'XML.scanXmlString.scanXml.169'(_20741462,_20741464,_20741466,_20741468):-freeze(_20741466,'blocked_XML.scanXmlString.scanXml.169'(_20741462,_20741464,_20741466,_20741468)).
'blocked_XML.scanXmlString.scanXml.169'(_20741548,_20744230,_20744236,_20744242):-hnf(_20741548,_20745652,_20744236,_20745664),'blocked_XML.scanXmlString.scanXml.169_1'(_20745652,_20744230,_20745664,_20744242).

'blocked_XML.scanXmlString.scanXml.169_1'(_20746080,_20746082,_20746084,_20746086):-freeze(_20746084,'blocked_blocked_XML.scanXmlString.scanXml.169_1'(_20746080,_20746082,_20746084,_20746086)).
'blocked_blocked_XML.scanXmlString.scanXml.169_1'([],[],_20746328,_20746328).
'blocked_blocked_XML.scanXmlString.scanXml.169_1'([_20741764|_20741782],_20749230,_20749236,_20749242):-!,makeShare(_20741764,_20747388),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20747388,^<),_20751234,_20749236,_20751200),'blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'(_20751234,_20747388,_20741782,_20749230,_20751200,_20749242).

'blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'(_20751812,_20751814,_20751816,_20751818,_20751820,_20751822):-freeze(_20751820,freeze(_20751812,'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'(_20751812,_20751814,_20751816,_20751818,_20751820,_20751822))).
'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'('Prelude.True',_20747388,_20741782,_20752216,_20752222,_20752228):-hnf('XML.scanXmlElem'(_20741782),_20752216,_20752222,_20752228).
'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'('Prelude.False',_20747388,_20741782,_20753422,_20753428,_20753434):-!,makeShare(_20742244,_20753850),makeShare(_20742262,_20753870),makeShare(_20742280,_20753890),hnf('Prelude.cond'(letrec4PAKCS(_20753850,'XML.scanXmlText'([_20747388|_20741782])),'Prelude.cond'(letrec4PAKCS(_20753870,'XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_20753850)),'Prelude.cond'(letrec4PAKCS(_20753890,'XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_20753850)),['XML.XText'(_20753870)|'XML.scanXmlString.scanXml.169'(_20753890)]))),_20753422,_20753428,_20753434).
'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'('FAIL'(_20758792),_20747388,_20741782,'FAIL'(_20758792),_20758806,_20758806).
'blocked_blocked_XML.scanXmlString.scanXml.169_1'('FAIL'(_20758874),'FAIL'(_20758874),_20758888,_20758888):-nonvar(_20758874).

'XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_20760876,_20760878,_20760880,_20760882):-freeze(_20760880,'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_20760876,_20760878,_20760880,_20760882)).
'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_20760962,_20761508,_20761514,_20761520):-hnf(_20760962,_20763686,_20761514,_20763698),'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'(_20763686,_20761508,_20763698,_20761520).

'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'(_20764240,_20764242,_20764244,_20764246):-freeze(_20764244,'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'(_20764240,_20764242,_20764244,_20764246)).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'('Prelude.(,)'(_20761078,_20761096),_20764610,_20764616,_20764622):-!,hnf(_20761078,_20764610,_20764616,_20764622).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'('FAIL'(_20765290),'FAIL'(_20765290),_20765304,_20765304):-nonvar(_20765290).

'XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_20767292,_20767294,_20767296,_20767298):-freeze(_20767296,'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_20767292,_20767294,_20767296,_20767298)).
'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_20767378,_20767924,_20767930,_20767936):-hnf(_20767378,_20770102,_20767930,_20770114),'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'(_20770102,_20767924,_20770114,_20767936).

'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'(_20770656,_20770658,_20770660,_20770662):-freeze(_20770660,'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'(_20770656,_20770658,_20770660,_20770662)).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'('Prelude.(,)'(_20767494,_20767512),_20771026,_20771032,_20771038):-!,hnf(_20767512,_20771026,_20771032,_20771038).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'('FAIL'(_20771706),'FAIL'(_20771706),_20771720,_20771720):-nonvar(_20771706).

'XML.scanXmlText'(_20772474,_20772476,_20772478,_20772480):-freeze(_20772478,'blocked_XML.scanXmlText'(_20772474,_20772476,_20772478,_20772480)).
'blocked_XML.scanXmlText'(_20772560,_20778042,_20778048,_20778054):-hnf(_20772560,_20778960,_20778048,_20778972),'blocked_XML.scanXmlText_1'(_20778960,_20778042,_20778972,_20778054).

'blocked_XML.scanXmlText_1'(_20779304,_20779306,_20779308,_20779310):-freeze(_20779308,'blocked_blocked_XML.scanXmlText_1'(_20779304,_20779306,_20779308,_20779310)).
'blocked_blocked_XML.scanXmlText_1'([],'Prelude.(,)'([],[]),_20779552,_20779552).
'blocked_blocked_XML.scanXmlText_1'([_20772944|_20772962],_20784210,_20784216,_20784222):-!,makeShare(_20772944,_20781534),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20781534,^<),_20785710,_20784216,_20785676),'blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'(_20785710,_20781534,_20772962,_20784210,_20785676,_20784222).

'blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'(_20786204,_20786206,_20786208,_20786210,_20786212,_20786214):-freeze(_20786212,freeze(_20786204,'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'(_20786204,_20786206,_20786208,_20786210,_20786212,_20786214))).
'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'('Prelude.True',_20781534,_20772962,'Prelude.(,)'([],[_20781534|_20772962]),_20786614,_20786614).
'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'('Prelude.False',_20781534,_20772962,_20791394,_20791400,_20791406):-!,makeShare(_20781534,_20789132),hnf('Prelude.isSpace'(_20789132),_20794074,_20791400,_20794040),'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20794074,_20789132,_20772962,_20791394,_20794040,_20791406).

'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20794772,_20794774,_20794776,_20794778,_20794780,_20794782):-freeze(_20794780,freeze(_20794772,'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20794772,_20794774,_20794776,_20794778,_20794780,_20794782))).
'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20789132,_20772962,_20795176,_20795182,_20795188):-makeShare(_20773844,_20795558),makeShare(_20773862,_20795578),makeShare(_20773880,_20795598),hnf('Prelude.cond'(letrec4PAKCS(_20795558,'XML.scanXmlText'('Prelude.apply'('XML.dropBlanks',_20772962))),'Prelude.cond'(letrec4PAKCS(_20795578,'XML.scanXmlText._\'23selFP25\'23txt'(_20795558)),'Prelude.cond'(letrec4PAKCS(_20795598,'XML.scanXmlText._\'23selFP26\'23rem'(_20795558)),'Prelude.(,)'('XML.scanXmlText._\'23caseor0'('Prelude.null'(_20795578),_20795578),_20795598)))),_20795176,_20795182,_20795188).
'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20789132,_20772962,_20802904,_20802910,_20802916):-!,hnf('Prelude.otherwise',_20806808,_20802910,_20806774),'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20806808,_20789132,_20772962,_20802904,_20806774,_20802916).

'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20807698,_20807700,_20807702,_20807704,_20807706,_20807708):-freeze(_20807706,freeze(_20807698,'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20807698,_20807700,_20807702,_20807704,_20807706,_20807708))).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20789132,_20772962,_20808102,_20808108,_20808114):-makeShare(_20775860,_20808502),makeShare(_20775878,_20808522),makeShare(_20775896,_20808542),hnf('Prelude.cond'(letrec4PAKCS(_20808502,'XML.scanXmlText'(_20772962)),'Prelude.cond'(letrec4PAKCS(_20808522,'XML.scanXmlText._\'23selFP28\'23txt'(_20808502)),'Prelude.cond'(letrec4PAKCS(_20808542,'XML.scanXmlText._\'23selFP29\'23rem'(_20808502)),'Prelude.(,)'([_20789132|_20808522],_20808542)))),_20808102,_20808108,_20808114).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20789132,_20772962,_20813464,_20813470,_20813476):-!,hnf(reportFailure4PAKCS('XML.scanXmlText',['Prelude.False']),_20813464,_20813470,_20813476).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20815230),_20789132,_20772962,'FAIL'(_20815230),_20815244,_20815244).
'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20815312),_20789132,_20772962,'FAIL'(_20815312),_20815326,_20815326).
'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'('FAIL'(_20815394),_20781534,_20772962,'FAIL'(_20815394),_20815408,_20815408).
'blocked_blocked_XML.scanXmlText_1'('FAIL'(_20815476),'FAIL'(_20815476),_20815490,_20815490):-nonvar(_20815476).

'XML.scanXmlText._\'23selFP25\'23txt'(_20816832,_20816834,_20816836,_20816838):-freeze(_20816836,'blocked_XML.scanXmlText._\'23selFP25\'23txt'(_20816832,_20816834,_20816836,_20816838)).
'blocked_XML.scanXmlText._\'23selFP25\'23txt'(_20816918,_20817362,_20817368,_20817374):-hnf(_20816918,_20818928,_20817368,_20818940),'blocked_XML.scanXmlText._\'23selFP25\'23txt_1'(_20818928,_20817362,_20818940,_20817374).

'blocked_XML.scanXmlText._\'23selFP25\'23txt_1'(_20819380,_20819382,_20819384,_20819386):-freeze(_20819384,'blocked_blocked_XML.scanXmlText._\'23selFP25\'23txt_1'(_20819380,_20819382,_20819384,_20819386)).
'blocked_blocked_XML.scanXmlText._\'23selFP25\'23txt_1'('Prelude.(,)'(_20817034,_20817052),_20819750,_20819756,_20819762):-!,hnf(_20817034,_20819750,_20819756,_20819762).
'blocked_blocked_XML.scanXmlText._\'23selFP25\'23txt_1'('FAIL'(_20820328),'FAIL'(_20820328),_20820342,_20820342):-nonvar(_20820328).

'XML.scanXmlText._\'23selFP26\'23rem'(_20821684,_20821686,_20821688,_20821690):-freeze(_20821688,'blocked_XML.scanXmlText._\'23selFP26\'23rem'(_20821684,_20821686,_20821688,_20821690)).
'blocked_XML.scanXmlText._\'23selFP26\'23rem'(_20821770,_20822214,_20822220,_20822226):-hnf(_20821770,_20823780,_20822220,_20823792),'blocked_XML.scanXmlText._\'23selFP26\'23rem_1'(_20823780,_20822214,_20823792,_20822226).

'blocked_XML.scanXmlText._\'23selFP26\'23rem_1'(_20824232,_20824234,_20824236,_20824238):-freeze(_20824236,'blocked_blocked_XML.scanXmlText._\'23selFP26\'23rem_1'(_20824232,_20824234,_20824236,_20824238)).
'blocked_blocked_XML.scanXmlText._\'23selFP26\'23rem_1'('Prelude.(,)'(_20821886,_20821904),_20824602,_20824608,_20824614):-!,hnf(_20821904,_20824602,_20824608,_20824614).
'blocked_blocked_XML.scanXmlText._\'23selFP26\'23rem_1'('FAIL'(_20825180),'FAIL'(_20825180),_20825194,_20825194):-nonvar(_20825180).

'XML.scanXmlText._\'23selFP28\'23txt'(_20826536,_20826538,_20826540,_20826542):-freeze(_20826540,'blocked_XML.scanXmlText._\'23selFP28\'23txt'(_20826536,_20826538,_20826540,_20826542)).
'blocked_XML.scanXmlText._\'23selFP28\'23txt'(_20826622,_20827066,_20827072,_20827078):-hnf(_20826622,_20828632,_20827072,_20828644),'blocked_XML.scanXmlText._\'23selFP28\'23txt_1'(_20828632,_20827066,_20828644,_20827078).

'blocked_XML.scanXmlText._\'23selFP28\'23txt_1'(_20829084,_20829086,_20829088,_20829090):-freeze(_20829088,'blocked_blocked_XML.scanXmlText._\'23selFP28\'23txt_1'(_20829084,_20829086,_20829088,_20829090)).
'blocked_blocked_XML.scanXmlText._\'23selFP28\'23txt_1'('Prelude.(,)'(_20826738,_20826756),_20829454,_20829460,_20829466):-!,hnf(_20826738,_20829454,_20829460,_20829466).
'blocked_blocked_XML.scanXmlText._\'23selFP28\'23txt_1'('FAIL'(_20830032),'FAIL'(_20830032),_20830046,_20830046):-nonvar(_20830032).

'XML.scanXmlText._\'23selFP29\'23rem'(_20831388,_20831390,_20831392,_20831394):-freeze(_20831392,'blocked_XML.scanXmlText._\'23selFP29\'23rem'(_20831388,_20831390,_20831392,_20831394)).
'blocked_XML.scanXmlText._\'23selFP29\'23rem'(_20831474,_20831918,_20831924,_20831930):-hnf(_20831474,_20833484,_20831924,_20833496),'blocked_XML.scanXmlText._\'23selFP29\'23rem_1'(_20833484,_20831918,_20833496,_20831930).

'blocked_XML.scanXmlText._\'23selFP29\'23rem_1'(_20833936,_20833938,_20833940,_20833942):-freeze(_20833940,'blocked_blocked_XML.scanXmlText._\'23selFP29\'23rem_1'(_20833936,_20833938,_20833940,_20833942)).
'blocked_blocked_XML.scanXmlText._\'23selFP29\'23rem_1'('Prelude.(,)'(_20831590,_20831608),_20834306,_20834312,_20834318):-!,hnf(_20831608,_20834306,_20834312,_20834318).
'blocked_blocked_XML.scanXmlText._\'23selFP29\'23rem_1'('FAIL'(_20834884),'FAIL'(_20834884),_20834898,_20834898):-nonvar(_20834884).

'XML.scanXmlElem'(_20835652,_20835654,_20835656,_20835658):-freeze(_20835656,'blocked_XML.scanXmlElem'(_20835652,_20835654,_20835656,_20835658)).
'blocked_XML.scanXmlElem'(_20835738,_20839048,_20839054,_20839060):-hnf(_20835738,_20839966,_20839054,_20839978),'blocked_XML.scanXmlElem_1'(_20839966,_20839048,_20839978,_20839060).

'blocked_XML.scanXmlElem_1'(_20840310,_20840312,_20840314,_20840316):-freeze(_20840314,'blocked_blocked_XML.scanXmlElem_1'(_20840310,_20840312,_20840314,_20840316)).
'blocked_blocked_XML.scanXmlElem_1'([],[],_20840558,_20840558).
'blocked_blocked_XML.scanXmlElem_1'([_20835954|_20835972],_20843414,_20843420,_20843426):-!,makeShare(_20835954,_20841316),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20841316,'^!'),_20844914,_20843420,_20844880),'blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'(_20844914,_20841316,_20835972,_20843414,_20844880,_20843426).

'blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'(_20845408,_20845410,_20845412,_20845414,_20845416,_20845418):-freeze(_20845416,freeze(_20845408,'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'(_20845408,_20845410,_20845412,_20845414,_20845416,_20845418))).
'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'('Prelude.True',_20841316,_20835972,_20848422,_20848428,_20848434):-makeShare(_20835972,_20845908),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),'Prelude.take'(2,_20845908),[^-,^-]),_20851072,_20848428,_20851038),'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'(_20851072,_20841316,_20845908,_20848422,_20851038,_20848434).

'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'(_20851746,_20851748,_20851750,_20851752,_20851754,_20851756):-freeze(_20851754,freeze(_20851746,'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'(_20851746,_20851748,_20851750,_20851752,_20851754,_20851756))).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_20841316,_20845908,_20852150,_20852156,_20852162):-hnf('XML.scanXmlComment'('Prelude.drop'(2,_20845908)),_20852150,_20852156,_20852162).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_20841316,_20845908,_20853750,_20853756,_20853762):-!,hnf('XML.scanXmlCData'(_20845908),_20853750,_20853756,_20853762).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_20854784),_20841316,_20845908,'FAIL'(_20854784),_20854798,_20854798).
'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'('Prelude.False',_20841316,_20835972,_20857022,_20857028,_20857034):-!,makeShare(_20841316,_20855310),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20855310,^?),_20859702,_20857028,_20859668),'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20859702,_20855310,_20835972,_20857022,_20859668,_20857034).

'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20860400,_20860402,_20860404,_20860406,_20860408,_20860410):-freeze(_20860408,freeze(_20860400,'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20860400,_20860402,_20860404,_20860406,_20860408,_20860410))).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20855310,_20835972,_20860804,_20860810,_20860816):-hnf('XML.scanXmlProcInstr'(_20835972),_20860804,_20860810,_20860816).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20855310,_20835972,_20863352,_20863358,_20863364):-!,hnf('Prelude.otherwise',_20867256,_20863358,_20867222),'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20867256,_20855310,_20835972,_20863352,_20867222,_20863364).

'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20868146,_20868148,_20868150,_20868152,_20868154,_20868156):-freeze(_20868154,freeze(_20868146,'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20868146,_20868148,_20868150,_20868152,_20868154,_20868156))).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20855310,_20835972,_20868550,_20868556,_20868562):-hnf('XML.scanXmlElemName'([_20855310],_20835972),_20868550,_20868556,_20868562).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20855310,_20835972,_20870422,_20870428,_20870434):-!,hnf(reportFailure4PAKCS('XML.scanXmlElem',['Prelude.False']),_20870422,_20870428,_20870434).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20872188),_20855310,_20835972,'FAIL'(_20872188),_20872202,_20872202).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20872270),_20855310,_20835972,'FAIL'(_20872270),_20872284,_20872284).
'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'('FAIL'(_20872352),_20841316,_20835972,'FAIL'(_20872352),_20872366,_20872366).
'blocked_blocked_XML.scanXmlElem_1'('FAIL'(_20872434),'FAIL'(_20872434),_20872448,_20872448):-nonvar(_20872434).

'XML.scanXmlElemName'(_20873354,_20873356,_20873358,_20873360,_20873362):-freeze(_20873360,'blocked_XML.scanXmlElemName'(_20873354,_20873356,_20873358,_20873360,_20873362)).
'blocked_XML.scanXmlElemName'(_20873450,_20873468,_20880056,_20880062,_20880068):-hnf(_20873468,_20881126,_20880062,_20881144),'blocked_XML.scanXmlElemName_2'(_20881126,_20873450,_20880056,_20881144,_20880068).

'blocked_XML.scanXmlElemName_2'(_20881508,_20881510,_20881512,_20881514,_20881516):-freeze(_20881514,'blocked_blocked_XML.scanXmlElemName_2'(_20881508,_20881510,_20881512,_20881514,_20881516)).
'blocked_blocked_XML.scanXmlElemName_2'([],_20873450,['XML.XElem'([^<|_20873450],[],[])],_20881766,_20881766).
'blocked_blocked_XML.scanXmlElemName_2'([_20874244|_20874262],_20873450,_20886928,_20886934,_20886940):-!,makeShare(_20874244,_20884112),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20884112,^>),_20888586,_20886934,_20888546),'blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'(_20888586,_20884112,_20874262,_20873450,_20886928,_20888546,_20886940).

'blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'(_20889106,_20889108,_20889110,_20889112,_20889114,_20889116,_20889118):-freeze(_20889116,freeze(_20889106,'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'(_20889106,_20889108,_20889110,_20889112,_20889114,_20889116,_20889118))).
'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'('Prelude.True',_20884112,_20874262,_20873450,['XML.XElem'([^<|_20873450],[],[])|'XML.scanXmlString'(_20874262)],_20889526,_20889526).
'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'('Prelude.False',_20884112,_20874262,_20873450,_20894760,_20894766,_20894772):-!,makeShare(_20884112,_20892410),hnf('Prelude.isSpace'(_20892410),_20897598,_20894766,_20897558),'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'(_20897598,_20892410,_20874262,_20873450,_20894760,_20897558,_20894772).

'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'(_20898322,_20898324,_20898326,_20898328,_20898330,_20898332,_20898334):-freeze(_20898332,freeze(_20898322,'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'(_20898322,_20898324,_20898326,_20898328,_20898330,_20898332,_20898334))).
'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20892410,_20874262,_20873450,_20898736,_20898742,_20898748):-makeShare(_20875466,_20899202),makeShare(_20875484,_20899222),makeShare(_20875502,_20899242),hnf('Prelude.cond'(letrec4PAKCS(_20899202,'XML.parseAttrs'('Prelude.apply'('XML.dropBlanks',_20874262))),'Prelude.cond'(letrec4PAKCS(_20899222,'XML.scanXmlElemName._\'23selFP31\'23attrs'(_20899202)),'Prelude.cond'(letrec4PAKCS(_20899242,'XML.scanXmlElemName._\'23selFP32\'23rest'(_20899202)),'XML.scanXmlElemName._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_20899242),^/),_20873450,_20899222,_20899242)))),_20898736,_20898742,_20898748).
'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20892410,_20874262,_20873450,_20908904,_20908910,_20908916):-!,makeShare(_20892410,_20905558),makeShare(_20874262,_20905578),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20905558,^/),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_20905578),^>)),_20912966,_20908910,_20912926),'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20912966,_20905558,_20905578,_20873450,_20908904,_20912926,_20908916).

'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20913906,_20913908,_20913910,_20913912,_20913914,_20913916,_20913918):-freeze(_20913916,freeze(_20913906,'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20913906,_20913908,_20913910,_20913912,_20913914,_20913916,_20913918))).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20905558,_20905578,_20873450,['XML.XElem'(_20873450,[],[])|'XML.scanXmlString'('Prelude.tail'(_20905578))],_20914326,_20914326).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20905558,_20905578,_20873450,_20918260,_20918266,_20918272):-!,hnf('Prelude.otherwise',_20923546,_20918266,_20923506),'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20923546,_20905558,_20905578,_20873450,_20918260,_20923506,_20918272).

'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20924666,_20924668,_20924670,_20924672,_20924674,_20924676,_20924678):-freeze(_20924676,freeze(_20924666,'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20924666,_20924668,_20924670,_20924672,_20924674,_20924676,_20924678))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20905558,_20905578,_20873450,_20925080,_20925086,_20925092):-hnf('XML.scanXmlElemName'('Prelude.++'(_20873450,[_20905558]),_20905578),_20925080,_20925086,_20925092).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20905558,_20905578,_20873450,_20927604,_20927610,_20927616):-!,hnf(reportFailure4PAKCS('XML.scanXmlElemName',['Prelude.False']),_20927604,_20927610,_20927616).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20929696),_20905558,_20905578,_20873450,'FAIL'(_20929696),_20929710,_20929710).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20929786),_20905558,_20905578,_20873450,'FAIL'(_20929786),_20929800,_20929800).
'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20929876),_20892410,_20874262,_20873450,'FAIL'(_20929876),_20929890,_20929890).
'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'('FAIL'(_20929966),_20884112,_20874262,_20873450,'FAIL'(_20929966),_20929980,_20929980).
'blocked_blocked_XML.scanXmlElemName_2'('FAIL'(_20930056),_20873450,'FAIL'(_20930056),_20930070,_20930070):-nonvar(_20930056).

'XML.scanXmlElemName._\'23selFP31\'23attrs'(_20931648,_20931650,_20931652,_20931654):-freeze(_20931652,'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs'(_20931648,_20931650,_20931652,_20931654)).
'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs'(_20931734,_20932214,_20932220,_20932226):-hnf(_20931734,_20933996,_20932220,_20934008),'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'(_20933996,_20932214,_20934008,_20932226).

'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'(_20934484,_20934486,_20934488,_20934490):-freeze(_20934488,'blocked_blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'(_20934484,_20934486,_20934488,_20934490)).
'blocked_blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'('Prelude.(,)'(_20931850,_20931868),_20934854,_20934860,_20934866):-!,hnf(_20931850,_20934854,_20934860,_20934866).
'blocked_blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'('FAIL'(_20935468),'FAIL'(_20935468),_20935482,_20935482):-nonvar(_20935468).

'XML.scanXmlElemName._\'23selFP32\'23rest'(_20937014,_20937016,_20937018,_20937020):-freeze(_20937018,'blocked_XML.scanXmlElemName._\'23selFP32\'23rest'(_20937014,_20937016,_20937018,_20937020)).
'blocked_XML.scanXmlElemName._\'23selFP32\'23rest'(_20937100,_20937574,_20937580,_20937586):-hnf(_20937100,_20939320,_20937580,_20939332),'blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'(_20939320,_20937574,_20939332,_20937586).

'blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'(_20939802,_20939804,_20939806,_20939808):-freeze(_20939806,'blocked_blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'(_20939802,_20939804,_20939806,_20939808)).
'blocked_blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'('Prelude.(,)'(_20937216,_20937234),_20940172,_20940178,_20940184):-!,hnf(_20937234,_20940172,_20940178,_20940184).
'blocked_blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'('FAIL'(_20940780),'FAIL'(_20940780),_20940794,_20940794):-nonvar(_20940780).

'XML.scanXmlComment'(_20941662,_20941664,_20941666,_20941668):-freeze(_20941666,'blocked_XML.scanXmlComment'(_20941662,_20941664,_20941666,_20941668)).
'blocked_XML.scanXmlComment'(_20941748,_20943736,_20943742,_20943748):-hnf(_20941748,_20944762,_20943742,_20944774),'blocked_XML.scanXmlComment_1'(_20944762,_20943736,_20944774,_20943748).

'blocked_XML.scanXmlComment_1'(_20945124,_20945126,_20945128,_20945130):-freeze(_20945128,'blocked_blocked_XML.scanXmlComment_1'(_20945124,_20945126,_20945128,_20945130)).
'blocked_blocked_XML.scanXmlComment_1'([],[],_20945372,_20945372).
'blocked_blocked_XML.scanXmlComment_1'([_20941964|_20941982],_20949264,_20949270,_20949276):-!,makeShare(_20941982,_20946046),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20941964,^-),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),'Prelude.take'(2,_20946046),[^-,^>])),_20950872,_20949270,_20950838),'blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'(_20950872,_20941964,_20946046,_20949264,_20950838,_20949276).

'blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'(_20951384,_20951386,_20951388,_20951390,_20951392,_20951394):-freeze(_20951392,freeze(_20951384,'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'(_20951384,_20951386,_20951388,_20951390,_20951392,_20951394))).
'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'('Prelude.True',_20941964,_20946046,_20951788,_20951794,_20951800):-hnf('XML.scanXmlString'('Prelude.drop'(2,_20946046)),_20951788,_20951794,_20951800).
'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'('Prelude.False',_20941964,_20946046,_20953202,_20953208,_20953214):-!,hnf('XML.scanXmlComment'(_20946046),_20953202,_20953208,_20953214).
'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'('FAIL'(_20954068),_20941964,_20946046,'FAIL'(_20954068),_20954082,_20954082).
'blocked_blocked_XML.scanXmlComment_1'('FAIL'(_20954150),'FAIL'(_20954150),_20954164,_20954164):-nonvar(_20954150).

'XML.scanXmlCData'(_20954956,_20954958,_20954960,_20954962):-freeze(_20954960,'blocked_XML.scanXmlCData'(_20954956,_20954958,_20954960,_20954962)).
'blocked_XML.scanXmlCData'(_20955042,_20955876,_20955882,_20955888):-makeShare(_20955070,_20956014),hnf('Prelude.cond'(letrec4PAKCS(_20956014,'XML.dropCData'(_20955042)),'XML.scanXmlCData._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_20956014),^>),_20956014)),_20955876,_20955882,_20955888).

'XML.dropCData'(_20958980,_20958982,_20958984,_20958986):-freeze(_20958984,'blocked_XML.dropCData'(_20958980,_20958982,_20958984,_20958986)).
'blocked_XML.dropCData'(_20959066,_20961376,_20961382,_20961388):-hnf(_20959066,_20962222,_20961382,_20962234),'blocked_XML.dropCData_1'(_20962222,_20961376,_20962234,_20961388).

'blocked_XML.dropCData_1'(_20962554,_20962556,_20962558,_20962560):-freeze(_20962558,'blocked_blocked_XML.dropCData_1'(_20962554,_20962556,_20962558,_20962560)).
'blocked_blocked_XML.dropCData_1'([],[],_20962802,_20962802).
'blocked_blocked_XML.dropCData_1'([_20959282|_20959300],_20965262,_20965268,_20965274):-!,makeShare(_20959282,_20963474),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20963474,'^['),_20966690,_20965268,_20966656),'blocked_blocked_XML.dropCData_1_[|]_ComplexCase'(_20966690,_20963474,_20959300,_20965262,_20966656,_20965274).

'blocked_blocked_XML.dropCData_1_[|]_ComplexCase'(_20967172,_20967174,_20967176,_20967178,_20967180,_20967182):-freeze(_20967180,freeze(_20967172,'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'(_20967172,_20967174,_20967176,_20967178,_20967180,_20967182))).
'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'('Prelude.True',_20963474,_20959300,_20967576,_20967582,_20967588):-hnf('Prelude.tail'('Prelude.dropWhile'(partcall(1,'Prelude.flip',['^]','Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23Prelude.Char\'23']),_20959300)),_20967576,_20967582,_20967588).
'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'('Prelude.False',_20963474,_20959300,_20971396,_20971402,_20971408):-!,makeShare(_20963474,_20969724),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20969724,^>),_20974004,_20971402,_20973970),'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20974004,_20969724,_20959300,_20971396,_20973970,_20971408).

'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20974690,_20974692,_20974694,_20974696,_20974698,_20974700):-freeze(_20974698,freeze(_20974690,'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_20974690,_20974692,_20974694,_20974696,_20974698,_20974700))).
'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20969724,_20959300,[_20969724|_20959300],_20975100,_20975100).
'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20969724,_20959300,_20977516,_20977522,_20977528):-!,hnf('Prelude.otherwise',_20981348,_20977522,_20981314),'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20981348,_20969724,_20959300,_20977516,_20981314,_20977528).

'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20982226,_20982228,_20982230,_20982232,_20982234,_20982236):-freeze(_20982234,freeze(_20982226,'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_20982226,_20982228,_20982230,_20982232,_20982234,_20982236))).
'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_20969724,_20959300,_20982630,_20982636,_20982642):-hnf('XML.dropCData'(_20959300),_20982630,_20982636,_20982642).
'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_20969724,_20959300,_20984136,_20984142,_20984148):-!,hnf(reportFailure4PAKCS('XML.dropCData',['Prelude.False']),_20984136,_20984142,_20984148).
'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20985878),_20969724,_20959300,'FAIL'(_20985878),_20985892,_20985892).
'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_20985960),_20969724,_20959300,'FAIL'(_20985960),_20985974,_20985974).
'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'('FAIL'(_20986042),_20963474,_20959300,'FAIL'(_20986042),_20986056,_20986056).
'blocked_blocked_XML.dropCData_1'('FAIL'(_20986124),'FAIL'(_20986124),_20986138,_20986138):-nonvar(_20986124).

'XML.scanXmlProcInstr'(_20987082,_20987084,_20987086,_20987088):-freeze(_20987086,'blocked_XML.scanXmlProcInstr'(_20987082,_20987084,_20987086,_20987088)).
'blocked_XML.scanXmlProcInstr'(_20987168,_20988622,_20988628,_20988634):-hnf(_20987168,_20989720,_20988628,_20989732),'blocked_XML.scanXmlProcInstr_1'(_20989720,_20988622,_20989732,_20988634).

'blocked_XML.scanXmlProcInstr_1'(_20990094,_20990096,_20990098,_20990100):-freeze(_20990098,'blocked_blocked_XML.scanXmlProcInstr_1'(_20990094,_20990096,_20990098,_20990100)).
'blocked_blocked_XML.scanXmlProcInstr_1'([],[],_20990342,_20990342).
'blocked_blocked_XML.scanXmlProcInstr_1'([_20987384|_20987402],_20993364,_20993370,_20993376):-!,makeShare(_20987402,_20991014),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_20987384,^?),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_20991014),^>)),_20995044,_20993370,_20995010),'blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'(_20995044,_20987384,_20991014,_20993364,_20995010,_20993376).

'blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'(_20995568,_20995570,_20995572,_20995574,_20995576,_20995578):-freeze(_20995576,freeze(_20995568,'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'(_20995568,_20995570,_20995572,_20995574,_20995576,_20995578))).
'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'('Prelude.True',_20987384,_20991014,_20995972,_20995978,_20995984):-hnf('XML.scanXmlString'('Prelude.tail'(_20991014)),_20995972,_20995978,_20995984).
'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'('Prelude.False',_20987384,_20991014,_20997318,_20997324,_20997330):-!,hnf('XML.scanXmlProcInstr'(_20991014),_20997318,_20997324,_20997330).
'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'('FAIL'(_20998208),_20987384,_20991014,'FAIL'(_20998208),_20998222,_20998222).
'blocked_blocked_XML.scanXmlProcInstr_1'('FAIL'(_20998290),'FAIL'(_20998290),_20998304,_20998304):-nonvar(_20998290).

'XML.parseAttrs'(_20999020,_20999022,_20999024,_20999026):-freeze(_20999024,'blocked_XML.parseAttrs'(_20999020,_20999022,_20999024,_20999026)).
'blocked_XML.parseAttrs'(_20999106,_21005700,_21005706,_21005712):-hnf(_20999106,_21006582,_21005706,_21006594),'blocked_XML.parseAttrs_1'(_21006582,_21005700,_21006594,_21005712).

'blocked_XML.parseAttrs_1'(_21006920,_21006922,_21006924,_21006926):-freeze(_21006924,'blocked_blocked_XML.parseAttrs_1'(_21006920,_21006922,_21006924,_21006926)).
'blocked_blocked_XML.parseAttrs_1'([],'Prelude.(,)'([],[]),_21007168,_21007168).
'blocked_blocked_XML.parseAttrs_1'([_20999490|_20999508],_21012468,_21012474,_21012480):-!,makeShare(_20999490,_21009902),hnf('Prelude.isAlpha'(_21009902),_21013932,_21012474,_21013898),'blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'(_21013932,_21009902,_20999508,_21012468,_21013898,_21012480).

'blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'(_21014420,_21014422,_21014424,_21014426,_21014428,_21014430):-freeze(_21014428,freeze(_21014420,'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'(_21014420,_21014422,_21014424,_21014426,_21014428,_21014430))).
'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'('Prelude.True',_21009902,_20999508,_21014824,_21014830,_21014836):-makeShare(_20999730,_21016732),makeShare(_20999748,_21016752),makeShare(_20999766,_21016772),makeShare(_20999784,_21016792),makeShare(_20999802,_21016812),makeShare(_20999820,_21016832),makeShare(_20999838,_21016852),makeShare(_20999856,_21016872),makeShare(_20999874,_21016892),hnf('Prelude.cond'(letrec4PAKCS(_21016732,'XML.splitAtChar'(^=,[_21009902|_20999508])),'Prelude.cond'(letrec4PAKCS(_21016752,'XML.parseAttrs._\'23selFP40\'23name'(_21016732)),'Prelude.cond'(letrec4PAKCS(_21016772,'XML.parseAttrs._\'23selFP41\'23rest1'(_21016732)),'Prelude.cond'(letrec4PAKCS(_21016792,'XML.splitAtChar'('^"','Prelude.tail'(_21016772))),'Prelude.cond'(letrec4PAKCS(_21016812,'XML.parseAttrs._\'23selFP38\'23value'(_21016792)),'Prelude.cond'(letrec4PAKCS(_21016832,'XML.parseAttrs._\'23selFP39\'23rest2'(_21016792)),'Prelude.cond'(letrec4PAKCS(_21016852,'XML.parseAttrs'('Prelude.apply'('XML.dropBlanks',_21016832))),'Prelude.cond'(letrec4PAKCS(_21016872,'XML.parseAttrs._\'23selFP36\'23rem_attrs'(_21016852)),'Prelude.cond'(letrec4PAKCS(_21016892,'XML.parseAttrs._\'23selFP37\'23rem_inp'(_21016852)),'Prelude.(,)'(['Prelude.(,)'(_21016752,'XML.xmlUnquoteSpecials'(_21016812))|_21016872],_21016892)))))))))),_21014824,_21014830,_21014836).
'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'('Prelude.False',_21009902,_20999508,_21030250,_21030256,_21030262):-!,hnf('Prelude.otherwise',_21032894,_21030256,_21032860),'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_21032894,_21009902,_20999508,_21030250,_21032860,_21030262).

'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_21033574,_21033576,_21033578,_21033580,_21033582,_21033584):-freeze(_21033582,freeze(_21033574,'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_21033574,_21033576,_21033578,_21033580,_21033582,_21033584))).
'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_21009902,_20999508,'Prelude.(,)'([],[_21009902|_20999508]),_21033984,_21033984).
'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_21009902,_20999508,_21035560,_21035566,_21035572):-!,hnf(reportFailure4PAKCS('XML.parseAttrs',['Prelude.False']),_21035560,_21035566,_21035572).
'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_21037110),_21009902,_20999508,'FAIL'(_21037110),_21037124,_21037124).
'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'('FAIL'(_21037192),_21009902,_20999508,'FAIL'(_21037192),_21037206,_21037206).
'blocked_blocked_XML.parseAttrs_1'('FAIL'(_21037274),'FAIL'(_21037274),_21037288,_21037288):-nonvar(_21037274).

'XML.parseAttrs._\'23selFP40\'23name'(_21038630,_21038632,_21038634,_21038636):-freeze(_21038634,'blocked_XML.parseAttrs._\'23selFP40\'23name'(_21038630,_21038632,_21038634,_21038636)).
'blocked_XML.parseAttrs._\'23selFP40\'23name'(_21038716,_21039160,_21039166,_21039172):-hnf(_21038716,_21040726,_21039166,_21040738),'blocked_XML.parseAttrs._\'23selFP40\'23name_1'(_21040726,_21039160,_21040738,_21039172).

'blocked_XML.parseAttrs._\'23selFP40\'23name_1'(_21041178,_21041180,_21041182,_21041184):-freeze(_21041182,'blocked_blocked_XML.parseAttrs._\'23selFP40\'23name_1'(_21041178,_21041180,_21041182,_21041184)).
'blocked_blocked_XML.parseAttrs._\'23selFP40\'23name_1'('Prelude.(,)'(_21038832,_21038850),_21041548,_21041554,_21041560):-!,hnf(_21038832,_21041548,_21041554,_21041560).
'blocked_blocked_XML.parseAttrs._\'23selFP40\'23name_1'('FAIL'(_21042126),'FAIL'(_21042126),_21042140,_21042140):-nonvar(_21042126).

'XML.parseAttrs._\'23selFP41\'23rest1'(_21043520,_21043522,_21043524,_21043526):-freeze(_21043524,'blocked_XML.parseAttrs._\'23selFP41\'23rest1'(_21043520,_21043522,_21043524,_21043526)).
'blocked_XML.parseAttrs._\'23selFP41\'23rest1'(_21043606,_21044056,_21044062,_21044068):-hnf(_21043606,_21045658,_21044062,_21045670),'blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'(_21045658,_21044056,_21045670,_21044068).

'blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'(_21046116,_21046118,_21046120,_21046122):-freeze(_21046120,'blocked_blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'(_21046116,_21046118,_21046120,_21046122)).
'blocked_blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'('Prelude.(,)'(_21043722,_21043740),_21046486,_21046492,_21046498):-!,hnf(_21043740,_21046486,_21046492,_21046498).
'blocked_blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'('FAIL'(_21047070),'FAIL'(_21047070),_21047084,_21047084):-nonvar(_21047070).

'XML.parseAttrs._\'23selFP38\'23value'(_21048464,_21048466,_21048468,_21048470):-freeze(_21048468,'blocked_XML.parseAttrs._\'23selFP38\'23value'(_21048464,_21048466,_21048468,_21048470)).
'blocked_XML.parseAttrs._\'23selFP38\'23value'(_21048550,_21049000,_21049006,_21049012):-hnf(_21048550,_21050602,_21049006,_21050614),'blocked_XML.parseAttrs._\'23selFP38\'23value_1'(_21050602,_21049000,_21050614,_21049012).

'blocked_XML.parseAttrs._\'23selFP38\'23value_1'(_21051060,_21051062,_21051064,_21051066):-freeze(_21051064,'blocked_blocked_XML.parseAttrs._\'23selFP38\'23value_1'(_21051060,_21051062,_21051064,_21051066)).
'blocked_blocked_XML.parseAttrs._\'23selFP38\'23value_1'('Prelude.(,)'(_21048666,_21048684),_21051430,_21051436,_21051442):-!,hnf(_21048666,_21051430,_21051436,_21051442).
'blocked_blocked_XML.parseAttrs._\'23selFP38\'23value_1'('FAIL'(_21052014),'FAIL'(_21052014),_21052028,_21052028):-nonvar(_21052014).

'XML.parseAttrs._\'23selFP39\'23rest2'(_21053408,_21053410,_21053412,_21053414):-freeze(_21053412,'blocked_XML.parseAttrs._\'23selFP39\'23rest2'(_21053408,_21053410,_21053412,_21053414)).
'blocked_XML.parseAttrs._\'23selFP39\'23rest2'(_21053494,_21053944,_21053950,_21053956):-hnf(_21053494,_21055546,_21053950,_21055558),'blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'(_21055546,_21053944,_21055558,_21053956).

'blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'(_21056004,_21056006,_21056008,_21056010):-freeze(_21056008,'blocked_blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'(_21056004,_21056006,_21056008,_21056010)).
'blocked_blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'('Prelude.(,)'(_21053610,_21053628),_21056374,_21056380,_21056386):-!,hnf(_21053628,_21056374,_21056380,_21056386).
'blocked_blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'('FAIL'(_21056958),'FAIL'(_21056958),_21056972,_21056972):-nonvar(_21056958).

'XML.parseAttrs._\'23selFP36\'23rem_attrs'(_21058504,_21058506,_21058508,_21058510):-freeze(_21058508,'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs'(_21058504,_21058506,_21058508,_21058510)).
'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs'(_21058590,_21059064,_21059070,_21059076):-hnf(_21058590,_21060810,_21059070,_21060822),'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'(_21060810,_21059064,_21060822,_21059076).

'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'(_21061292,_21061294,_21061296,_21061298):-freeze(_21061296,'blocked_blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'(_21061292,_21061294,_21061296,_21061298)).
'blocked_blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'('Prelude.(,)'(_21058706,_21058724),_21061662,_21061668,_21061674):-!,hnf(_21058706,_21061662,_21061668,_21061674).
'blocked_blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'('FAIL'(_21062270),'FAIL'(_21062270),_21062284,_21062284):-nonvar(_21062270).

'XML.parseAttrs._\'23selFP37\'23rem_inp'(_21063740,_21063742,_21063744,_21063746):-freeze(_21063744,'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp'(_21063740,_21063742,_21063744,_21063746)).
'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp'(_21063826,_21064288,_21064294,_21064300):-hnf(_21063826,_21065962,_21064294,_21065974),'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'(_21065962,_21064288,_21065974,_21064300).

'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'(_21066432,_21066434,_21066436,_21066438):-freeze(_21066436,'blocked_blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'(_21066432,_21066434,_21066436,_21066438)).
'blocked_blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'('Prelude.(,)'(_21063942,_21063960),_21066802,_21066808,_21066814):-!,hnf(_21063960,_21066802,_21066808,_21066814).
'blocked_blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'('FAIL'(_21067398),'FAIL'(_21067398),_21067412,_21067412):-nonvar(_21067398).

'XML.dropBlanks'(_21068128,_21068130,_21068132):-freeze(_21068130,'blocked_XML.dropBlanks'(_21068128,_21068130,_21068132)).
'blocked_XML.dropBlanks'(_21068300,_21068306,_21068312):-hnf(partcall(1,'Prelude.dropWhile',[partcall(1,'Prelude.isSpace',[])]),_21068300,_21068306,_21068312).

'XML.splitAtChar'(_21069572,_21069574,_21069576,_21069578,_21069580):-freeze(_21069578,'blocked_XML.splitAtChar'(_21069572,_21069574,_21069576,_21069578,_21069580)).
'blocked_XML.splitAtChar'(_21069668,_21069686,_21072446,_21072452,_21072458):-hnf(_21069686,_21073372,_21072452,_21073390),'blocked_XML.splitAtChar_2'(_21073372,_21069668,_21072446,_21073390,_21072458).

'blocked_XML.splitAtChar_2'(_21073730,_21073732,_21073734,_21073736,_21073738):-freeze(_21073736,'blocked_blocked_XML.splitAtChar_2'(_21073730,_21073732,_21073734,_21073736,_21073738)).
'blocked_blocked_XML.splitAtChar_2'([],_21069668,'Prelude.(,)'([],[]),_21073988,_21073988).
'blocked_blocked_XML.splitAtChar_2'([_21070070|_21070088],_21069668,_21077500,_21077506,_21077512):-!,makeShare(_21070070,_21075466),makeShare(_21069668,_21075486),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_21075466,_21075486),_21079014,_21077506,_21078974),'blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'(_21079014,_21075466,_21070088,_21075486,_21077500,_21078974,_21077512).

'blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'(_21079522,_21079524,_21079526,_21079528,_21079530,_21079532,_21079534):-freeze(_21079532,freeze(_21079522,'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'(_21079522,_21079524,_21079526,_21079528,_21079530,_21079532,_21079534))).
'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'('Prelude.True',_21075466,_21070088,_21075486,'Prelude.(,)'([],_21070088),_21079942,_21079942).
'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'('Prelude.False',_21075466,_21070088,_21075486,_21081180,_21081186,_21081192):-!,makeShare(_21070634,_21081686),makeShare(_21070652,_21081706),makeShare(_21070670,_21081726),hnf('Prelude.cond'(letrec4PAKCS(_21081686,'XML.splitAtChar'(_21075486,_21070088)),'Prelude.cond'(letrec4PAKCS(_21081706,'XML.splitAtChar._\'23selFP43\'23first'(_21081686)),'Prelude.cond'(letrec4PAKCS(_21081726,'XML.splitAtChar._\'23selFP44\'23rest'(_21081686)),'Prelude.(,)'([_21075466|_21081706],_21081726)))),_21081180,_21081186,_21081192).
'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'('FAIL'(_21086116),_21075466,_21070088,_21075486,'FAIL'(_21086116),_21086130,_21086130).
'blocked_blocked_XML.splitAtChar_2'('FAIL'(_21086206),_21069668,'FAIL'(_21086206),_21086220,_21086220):-nonvar(_21086206).

'XML.splitAtChar._\'23selFP43\'23first'(_21087646,_21087648,_21087650,_21087652):-freeze(_21087650,'blocked_XML.splitAtChar._\'23selFP43\'23first'(_21087646,_21087648,_21087650,_21087652)).
'blocked_XML.splitAtChar._\'23selFP43\'23first'(_21087732,_21088188,_21088194,_21088200):-hnf(_21087732,_21089826,_21088194,_21089838),'blocked_XML.splitAtChar._\'23selFP43\'23first_1'(_21089826,_21088188,_21089838,_21088200).

'blocked_XML.splitAtChar._\'23selFP43\'23first_1'(_21090290,_21090292,_21090294,_21090296):-freeze(_21090294,'blocked_blocked_XML.splitAtChar._\'23selFP43\'23first_1'(_21090290,_21090292,_21090294,_21090296)).
'blocked_blocked_XML.splitAtChar._\'23selFP43\'23first_1'('Prelude.(,)'(_21087848,_21087866),_21090660,_21090666,_21090672):-!,hnf(_21087848,_21090660,_21090666,_21090672).
'blocked_blocked_XML.splitAtChar._\'23selFP43\'23first_1'('FAIL'(_21091250),'FAIL'(_21091250),_21091264,_21091264):-nonvar(_21091250).

'XML.splitAtChar._\'23selFP44\'23rest'(_21092644,_21092646,_21092648,_21092650):-freeze(_21092648,'blocked_XML.splitAtChar._\'23selFP44\'23rest'(_21092644,_21092646,_21092648,_21092650)).
'blocked_XML.splitAtChar._\'23selFP44\'23rest'(_21092730,_21093180,_21093186,_21093192):-hnf(_21092730,_21094782,_21093186,_21094794),'blocked_XML.splitAtChar._\'23selFP44\'23rest_1'(_21094782,_21093180,_21094794,_21093192).

'blocked_XML.splitAtChar._\'23selFP44\'23rest_1'(_21095240,_21095242,_21095244,_21095246):-freeze(_21095244,'blocked_blocked_XML.splitAtChar._\'23selFP44\'23rest_1'(_21095240,_21095242,_21095244,_21095246)).
'blocked_blocked_XML.splitAtChar._\'23selFP44\'23rest_1'('Prelude.(,)'(_21092846,_21092864),_21095610,_21095616,_21095622):-!,hnf(_21092864,_21095610,_21095616,_21095622).
'blocked_blocked_XML.splitAtChar._\'23selFP44\'23rest_1'('FAIL'(_21096194),'FAIL'(_21096194),_21096208,_21096208):-nonvar(_21096194).

'XML.updateXmlFile'(_21097038,_21097040,_21097042,_21097044,_21097046):-freeze(_21097044,'blocked_XML.updateXmlFile'(_21097038,_21097040,_21097042,_21097044,_21097046)).
'blocked_XML.updateXmlFile'(_21097134,_21097152,_21097728,_21097734,_21097740):-makeShare(_21097152,_21097856),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','XML.readXmlFile'(_21097856)),partcall(1,'XML.updateXmlFile._\'23lambda8',[_21097134,_21097856])),_21097728,_21097734,_21097740).

'XML.updateXmlFile._\'23lambda8'(_21101080,_21101082,_21101084,_21101086,_21101088,_21101090):-freeze(_21101088,'blocked_XML.updateXmlFile._\'23lambda8'(_21101080,_21101082,_21101084,_21101086,_21101088,_21101090)).
'blocked_XML.updateXmlFile._\'23lambda8'(_21101186,_21101204,_21101222,_21101972,_21101978,_21101984):-makeShare(_21101250,_21102196),hnf('Prelude.cond'(letrec4PAKCS(_21102196,_21101222),'Prelude.$!!'(partcall(1,'XML.writeXmlFile',[_21101186]),'Prelude.apply'(_21101204,_21102196))),_21101972,_21101978,_21101984).

'XML.showXmlDocWithParams._\'23caseor0'(_21105784,_21105786,_21105788,_21105790):-freeze(_21105788,'blocked_XML.showXmlDocWithParams._\'23caseor0'(_21105784,_21105786,_21105788,_21105790)).
'blocked_XML.showXmlDocWithParams._\'23caseor0'(_21105870,_21107168,_21107174,_21107180):-hnf(_21105870,_21108842,_21107174,_21108854),'blocked_XML.showXmlDocWithParams._\'23caseor0_1'(_21108842,_21107168,_21108854,_21107180).

'blocked_XML.showXmlDocWithParams._\'23caseor0_1'(_21109318,_21109320,_21109322,_21109324):-freeze(_21109322,freeze(_21109318,'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'(_21109318,_21109320,_21109322,_21109324))).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'('Prelude.True',['^n','^o'],_21109708,_21109708).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'('Prelude.False',['^y','^e','^s'],_21110862,_21110862):-!.
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'('FAIL'(_21111914),'FAIL'(_21111914),_21111928,_21111928).

'XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'(_21113836,_21113838,_21113840,_21113842,_21113844,_21113846):-freeze(_21113844,'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'(_21113836,_21113838,_21113840,_21113842,_21113844,_21113846)).
'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'(_21113942,_21113960,_21113978,_21118848,_21118854,_21118860):-hnf(_21113942,_21120970,_21118854,_21120994),'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'(_21120970,_21113960,_21113978,_21118848,_21120994,_21118860).

'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'(_21121546,_21121548,_21121550,_21121552,_21121554,_21121556):-freeze(_21121554,freeze(_21121546,'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'(_21121546,_21121548,_21121550,_21121552,_21121554,_21121556))).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'('Prelude.True',_21113960,_21113978,_21121950,_21121956,_21121962):-hnf('Prelude.++'([^<,'^!','^D','^O','^C','^T','^Y','^P','^E','^ '],'Prelude.++'(_21113960,'Prelude.++'(['^ ','^S','^Y','^S','^T','^E','^M','^ ','^"'],'Prelude.++'('XML.lookupDtdUrl'(_21113978),['^"',^>,'^010','^010'])))),_21121950,_21121956,_21121962).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'('Prelude.False',_21113960,_21113978,[],_21129160,_21129160):-!.
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'('FAIL'(_21129826),_21113960,_21113978,'FAIL'(_21129826),_21129840,_21129840).

'XML.showXmlExp._\'23caseor0'(_21130976,_21130978,_21130980,_21130982,_21130984,_21130986,_21130988,_21130990):-freeze(_21130988,'blocked_XML.showXmlExp._\'23caseor0'(_21130976,_21130978,_21130980,_21130982,_21130984,_21130986,_21130988,_21130990)).
'blocked_XML.showXmlExp._\'23caseor0'(_21131102,_21131120,_21131138,_21131156,_21131174,_21137200,_21137206,_21137212):-hnf(_21131102,_21138546,_21137206,_21138582),'blocked_XML.showXmlExp._\'23caseor0_1'(_21138546,_21131120,_21131138,_21131156,_21131174,_21137200,_21138582,_21137212).

'blocked_XML.showXmlExp._\'23caseor0_1'(_21139018,_21139020,_21139022,_21139024,_21139026,_21139028,_21139030,_21139032):-freeze(_21139030,freeze(_21139018,'blocked_blocked_XML.showXmlExp._\'23caseor0_1'(_21139018,_21139020,_21139022,_21139024,_21139026,_21139028,_21139030,_21139032))).
'blocked_blocked_XML.showXmlExp._\'23caseor0_1'('Prelude.True',_21131120,_21131138,_21131156,_21131174,['^ ',^/,^>,'^010'],_21139448,_21139448).
'blocked_blocked_XML.showXmlExp._\'23caseor0_1'('Prelude.False',_21131120,_21131138,_21131156,_21131174,_21144834,_21144840,_21144846):-!,makeShare(_21131120,_21141786),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude.length'(_21141786),1),'XML.isXText'('Prelude.head'(_21141786))),_21147074,_21144840,_21147028),'blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'(_21147074,_21141786,_21131138,_21131156,_21131174,_21144834,_21147028,_21144846).

'blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'(_21147698,_21147700,_21147702,_21147704,_21147706,_21147708,_21147710,_21147712):-freeze(_21147710,freeze(_21147698,'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'(_21147698,_21147700,_21147702,_21147704,_21147706,_21147708,_21147710,_21147712))).
'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_21141786,_21131138,_21131156,_21131174,_21148122,_21148128,_21148134):-makeShare(_21132674,_21148394),hnf('Prelude.cond'(letrec4PAKCS(_21148394,'XML.showXmlExp._\'23selFP2\'23s'(_21141786)),'Prelude.++'([^>],'Prelude.++'('Prelude.apply'(_21131138,_21148394),'Prelude.++'([^<,^/],'Prelude.++'(_21131174,[^>,'^010']))))),_21148122,_21148128,_21148134).
'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_21141786,_21131138,_21131156,_21131174,_21153208,_21153214,_21153220):-!,makeShare(_21131156,_21153486),hnf('Prelude.++'([^>,'^010'],'Prelude.++'('XML.showXmlExps'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_21153486,2),_21141786,_21131138),'Prelude.++'('XML.xtab'(_21153486),'Prelude.++'([^<,^/],'Prelude.++'(_21131174,[^>,'^010']))))),_21153208,_21153214,_21153220).
'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_21158360),_21141786,_21131138,_21131156,_21131174,'FAIL'(_21158360),_21158374,_21158374).
'blocked_blocked_XML.showXmlExp._\'23caseor0_1'('FAIL'(_21158458),_21131120,_21131138,_21131156,_21131174,'FAIL'(_21158458),_21158472,_21158472).

'XML.unquoteUnicode._\'23caseor0'(_21159776,_21159778,_21159780,_21159782,_21159784,_21159786,_21159788):-freeze(_21159786,'blocked_XML.unquoteUnicode._\'23caseor0'(_21159776,_21159778,_21159780,_21159782,_21159784,_21159786,_21159788)).
'blocked_XML.unquoteUnicode._\'23caseor0'(_21159892,_21159910,_21159928,_21159946,_21162482,_21162488,_21162494):-hnf(_21159892,_21163964,_21162488,_21163994),'blocked_XML.unquoteUnicode._\'23caseor0_1'(_21163964,_21159910,_21159928,_21159946,_21162482,_21163994,_21162494).

'blocked_XML.unquoteUnicode._\'23caseor0_1'(_21164446,_21164448,_21164450,_21164452,_21164454,_21164456,_21164458):-freeze(_21164456,freeze(_21164446,'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'(_21164446,_21164448,_21164450,_21164452,_21164454,_21164456,_21164458))).
'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'([_21160062|_21160080],_21159910,_21159928,_21159946,_21166568,_21166574,_21166580):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_21160062,'^x'),_21168650,_21166574,_21168598),'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'(_21168650,_21160062,_21160080,_21159910,_21159928,_21159946,_21166568,_21168598,_21166580).

'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'(_21169210,_21169212,_21169214,_21169216,_21169218,_21169220,_21169222,_21169224,_21169226):-freeze(_21169224,freeze(_21169210,'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'(_21169210,_21169212,_21169214,_21169216,_21169218,_21169220,_21169222,_21169224,_21169226))).
'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'('Prelude.True',_21160062,_21160080,_21159910,_21159928,_21159946,['Prelude.chr'('XML.unquoteUnicode.extr.117'(_21159910,_21159928,'Numeric.readHex'(_21160080)))],_21169650,_21169650).
'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'('Prelude.False',_21160062,_21160080,_21159910,_21159928,_21159946,['Prelude.chr'('XML.unquoteUnicode.extr.117'(_21159910,_21159928,'Numeric.readInt'(_21159946)))],_21171948,_21171948):-!.
'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'('FAIL'(_21173942),_21160062,_21160080,_21159910,_21159928,_21159946,'FAIL'(_21173942),_21173956,_21173956).
'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'([],_21159910,_21159928,_21159946,['Prelude.chr'('XML.unquoteUnicode.extr.117'(_21159910,_21159928,'Numeric.readInt'(_21159946)))],_21174216,_21174216):-!.
'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'('FAIL'(_21175918),_21159910,_21159928,_21159946,'FAIL'(_21175918),_21175932,_21175932).

'XML.readXmlFile._\'23lambda4._\'23caseor0'(_21177522,_21177524,_21177526,_21177528,_21177530,_21177532):-freeze(_21177530,'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0'(_21177522,_21177524,_21177526,_21177528,_21177530,_21177532)).
'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0'(_21177628,_21177646,_21177664,_21190874,_21190880,_21190886):-hnf(_21177628,_21192672,_21190880,_21192696),'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'(_21192672,_21177646,_21177664,_21190874,_21192696,_21190886).

'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'(_21193194,_21193196,_21193198,_21193200,_21193202,_21193204):-freeze(_21193202,freeze(_21193194,'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'(_21193194,_21193196,_21193198,_21193200,_21193202,_21193204))).
'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'('Prelude.True',_21177646,_21177664,_21193598,_21193604,_21193610):-hnf('Prelude.error'('Prelude.++'(['^F','^i','^l','^e','^ '],'Prelude.++'(_21177664,['^ ','^c','^o','^n','^t','^a','^i','^n','^s','^ ','^n','^o','^ ','^X','^M','^L','^ ','^d','^o','^c','^u','^m','^e','^n','^t','^!']))),_21193598,_21193604,_21193610).
'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'('Prelude.False',_21177646,_21177664,_21204288,_21204294,_21204300):-!,makeShare(_21177646,_21201916),hnf('Prelude.null'('Prelude.tail'(_21201916)),_21206968,_21204294,_21206934),'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'(_21206968,_21201916,_21177664,_21204288,_21206934,_21204300).

'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'(_21207666,_21207668,_21207670,_21207672,_21207674,_21207676):-freeze(_21207674,freeze(_21207666,'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'(_21207666,_21207668,_21207670,_21207672,_21207674,_21207676))).
'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_21201916,_21177664,_21208070,_21208076,_21208082):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.head'(_21201916)),_21208070,_21208076,_21208082).
'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_21201916,_21177664,_21210002,_21210008,_21210014):-!,hnf('Prelude.error'('Prelude.++'(['^F','^i','^l','^e','^ '],'Prelude.++'(_21177664,['^ ','^c','^o','^n','^t','^a','^i','^n','^s','^ ','^m','^o','^r','^e','^ ','^t','^h','^a','^n','^ ','^o','^n','^e','^ ','^X','^M','^L','^ ','^d','^o','^c','^u','^m','^e','^n','^t','^!']))),_21210002,_21210008,_21210014).
'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_21220184),_21201916,_21177664,'FAIL'(_21220184),_21220198,_21220198).
'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'('FAIL'(_21220266),_21177646,_21177664,'FAIL'(_21220266),_21220280,_21220280).

'XML.scanXmlText._\'23caseor0'(_21221454,_21221456,_21221458,_21221460,_21221462):-freeze(_21221460,'blocked_XML.scanXmlText._\'23caseor0'(_21221454,_21221456,_21221458,_21221460,_21221462)).
'blocked_XML.scanXmlText._\'23caseor0'(_21221550,_21221568,_21222168,_21222174,_21222180):-hnf(_21221550,_21223526,_21222174,_21223544),'blocked_XML.scanXmlText._\'23caseor0_1'(_21223526,_21221568,_21222168,_21223544,_21222180).

'blocked_XML.scanXmlText._\'23caseor0_1'(_21223962,_21223964,_21223966,_21223968,_21223970):-freeze(_21223968,freeze(_21223962,'blocked_blocked_XML.scanXmlText._\'23caseor0_1'(_21223962,_21223964,_21223966,_21223968,_21223970))).
'blocked_blocked_XML.scanXmlText._\'23caseor0_1'('Prelude.True',_21221568,_21224356,_21224362,_21224368):-hnf(_21221568,_21224356,_21224362,_21224368).
'blocked_blocked_XML.scanXmlText._\'23caseor0_1'('Prelude.False',_21221568,['^ '|_21221568],_21225138,_21225138):-!.
'blocked_blocked_XML.scanXmlText._\'23caseor0_1'('FAIL'(_21225794),_21221568,'FAIL'(_21225794),_21225808,_21225808).

'XML.scanXmlElemName._\'23caseor0'(_21227126,_21227128,_21227130,_21227132,_21227134,_21227136,_21227138):-freeze(_21227136,'blocked_XML.scanXmlElemName._\'23caseor0'(_21227126,_21227128,_21227130,_21227132,_21227134,_21227136,_21227138)).
'blocked_XML.scanXmlElemName._\'23caseor0'(_21227242,_21227260,_21227278,_21227296,_21229110,_21229116,_21229122):-hnf(_21227242,_21230628,_21229116,_21230658),'blocked_XML.scanXmlElemName._\'23caseor0_1'(_21230628,_21227260,_21227278,_21227296,_21229110,_21230658,_21229122).

'blocked_XML.scanXmlElemName._\'23caseor0_1'(_21231116,_21231118,_21231120,_21231122,_21231124,_21231126,_21231128):-freeze(_21231126,freeze(_21231116,'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'(_21231116,_21231118,_21231120,_21231122,_21231124,_21231126,_21231128))).
'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'('Prelude.True',_21227260,_21227278,_21227296,['XML.XElem'(_21227260,_21227278,[])|'XML.scanXmlString'('Prelude.drop'(2,_21227296))],_21231536,_21231536).
'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'('Prelude.False',_21227260,_21227278,_21227296,['XML.XElem'([^<|_21227260],_21227278,[])|'XML.scanXmlString'('Prelude.tail'(_21227296))],_21233538,_21233538):-!.
'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'('FAIL'(_21235358),_21227260,_21227278,_21227296,'FAIL'(_21235358),_21235372,_21235372).

'XML.scanXmlCData._\'23caseor0'(_21236592,_21236594,_21236596,_21236598,_21236600):-freeze(_21236598,'blocked_XML.scanXmlCData._\'23caseor0'(_21236592,_21236594,_21236596,_21236598,_21236600)).
'blocked_XML.scanXmlCData._\'23caseor0'(_21236688,_21236706,_21237410,_21237416,_21237422):-hnf(_21236688,_21238804,_21237416,_21238822),'blocked_XML.scanXmlCData._\'23caseor0_1'(_21238804,_21236706,_21237410,_21238822,_21237422).

'blocked_XML.scanXmlCData._\'23caseor0_1'(_21239246,_21239248,_21239250,_21239252,_21239254):-freeze(_21239252,freeze(_21239246,'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'(_21239246,_21239248,_21239250,_21239252,_21239254))).
'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'('Prelude.True',_21236706,_21239640,_21239646,_21239652):-hnf('XML.scanXmlString'('Prelude.tail'(_21236706)),_21239640,_21239646,_21239652).
'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'('Prelude.False',_21236706,_21240816,_21240822,_21240828):-!,hnf('XML.scanXmlCData'(_21236706),_21240816,_21240822,_21240828).
'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'('FAIL'(_21241512),_21236706,'FAIL'(_21241512),_21241526,_21241526).

:-costCenters(['']).




%%%%% Number of shared variables: 110

