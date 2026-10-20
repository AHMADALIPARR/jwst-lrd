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
'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23'(_34302298,_34302300,_34302302,_34302304):-freeze(_34302302,'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23'(_34302298,_34302300,_34302302,_34302304)).
'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23'(_34302384,_34303004,_34303010,_34303016):-hnf(_34302384,_34304822,_34303010,_34304834),'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'(_34304822,_34303004,_34304834,_34303016).

'blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'(_34305316,_34305318,_34305320,_34305322):-freeze(_34305320,'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'(_34305316,_34305318,_34305320,_34305322)).
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23',[]),'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'),_34305668,_34305668):-!.
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlExp\'23_1'('FAIL'(_34307102),'FAIL'(_34307102),_34307116,_34307116):-nonvar(_34307102).

'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23'(_34308972,_34308974,_34308976,_34308978,_34308980):-freeze(_34308978,'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23'(_34308972,_34308974,_34308976,_34308978,_34308980)).
'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23'(_34309068,_34309086,_34311974,_34311980,_34311986):-hnf(_34309068,_34314232,_34311980,_34314250),'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'(_34314232,_34309086,_34311974,_34314250,_34311986).

'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'(_34314812,_34314814,_34314816,_34314818,_34314820):-freeze(_34314818,'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'(_34314812,_34314814,_34314816,_34314818,_34314820)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'('XML.XText'(_34309202),_34309086,_34315632,_34315638,_34315644):-hnf(_34309086,_34318550,_34315638,_34318568),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'(_34318550,_34309202,_34315632,_34318568,_34315644).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'(_34319250,_34319252,_34319254,_34319256,_34319258):-freeze(_34319256,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'(_34319250,_34319252,_34319254,_34319256,_34319258)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XText'(_34309324),_34309202,_34319612,_34319618,_34319624):-hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_34309202,_34309324),_34319612,_34319618,_34319624).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XElem'(_34309672,_34309690,_34309708),_34309202,'Prelude.False',_34321672,_34321672):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XText_2'('FAIL'(_34322688),_34309202,'FAIL'(_34322688),_34322702,_34322702):-nonvar(_34322688).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'('XML.XElem'(_34309850,_34309868,_34309886),_34309086,_34323528,_34323534,_34323540):-!,hnf(_34309086,_34326446,_34323534,_34326476),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'(_34326446,_34309850,_34309868,_34309886,_34323528,_34326476,_34323540).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'(_34327192,_34327194,_34327196,_34327198,_34327200,_34327202,_34327204):-freeze(_34327202,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'(_34327192,_34327194,_34327196,_34327198,_34327200,_34327202,_34327204)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XText'(_34310020),_34309850,_34309868,_34309886,'Prelude.False',_34327580,_34327580).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XElem'(_34310144,_34310162,_34310180),_34309850,_34309868,_34309886,_34328888,_34328894,_34328900):-!,hnf('Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_34309850,_34310144),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])]),_34309868,_34310162)),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23',[]),_34309886,_34310180)),_34328888,_34328894,_34328900).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1_XML.XElem_4'('FAIL'(_34335302),_34309850,_34309868,_34309886,'FAIL'(_34335302),_34335316,_34335316):-nonvar(_34335302).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlExp\'23_1'('FAIL'(_34335396),_34309086,'FAIL'(_34335396),_34335410,_34335410):-nonvar(_34335396).

'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'(_34337304,_34337306,_34337308):-freeze(_34337306,'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'(_34337304,_34337306,_34337308)).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'('XML.XText'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]))),_34338494,_34338494).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlExp\'23'('XML.XElem'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])),'Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[])])])),'Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Data\'23XML.XmlExp\'23',[]))),_34339840,_34339840).

'XML._inst\'23Prelude.Data\'23XML.Encoding\'23'(_34346108,_34346110,_34346112,_34346114):-freeze(_34346112,'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23'(_34346108,_34346110,_34346112,_34346114)).
'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23'(_34346194,_34346826,_34346832,_34346838):-hnf(_34346194,_34348716,_34346832,_34348728),'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'(_34348716,_34346826,_34348728,_34346838).

'blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'(_34349222,_34349224,_34349226,_34349228):-freeze(_34349226,'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'(_34349222,_34349224,_34349226,_34349228)).
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23',[]),'XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'),_34349574,_34349574):-!.
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.Encoding\'23_1'('FAIL'(_34351044),'FAIL'(_34351044),_34351058,_34351058):-nonvar(_34351044).

'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_34352990,_34352992,_34352994,_34352996,_34352998):-freeze(_34352996,'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_34352990,_34352992,_34352994,_34352996,_34352998)).
'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_34353086,_34353104,_34354148,_34354154,_34354160):-hnf(_34353086,_34356478,_34354154,_34356496),'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'(_34356478,_34353104,_34354148,_34356496,_34354160).

'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'(_34357070,_34357072,_34357074,_34357076,_34357078):-freeze(_34357076,'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'(_34357070,_34357072,_34357074,_34357076,_34357078)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'('XML.StandardEnc',_34353104,_34357956,_34357962,_34357968):-hnf(_34353104,_34361126,_34357962,_34361138),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'(_34361126,_34357956,_34361138,_34357968).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'(_34361860,_34361862,_34361864,_34361866):-freeze(_34361864,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'(_34361860,_34361862,_34361864,_34361866)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'('XML.StandardEnc','Prelude.True',_34362280,_34362280).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'('XML.Iso88591Enc','Prelude.False',_34363394,_34363394):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.StandardEnc_1'('FAIL'(_34364186),'FAIL'(_34364186),_34364200,_34364200):-nonvar(_34364186).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'('XML.Iso88591Enc',_34353104,_34365052,_34365058,_34365064):-!,hnf(_34353104,_34368222,_34365058,_34368234),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'(_34368222,_34365052,_34368234,_34365064).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'(_34368974,_34368976,_34368978,_34368980):-freeze(_34368978,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'(_34368974,_34368976,_34368978,_34368980)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'('XML.StandardEnc','Prelude.False',_34369394,_34369394).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'('XML.Iso88591Enc','Prelude.True',_34370514,_34370514):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1_XML.Iso88591Enc_1'('FAIL'(_34371300),'FAIL'(_34371300),_34371314,_34371314):-nonvar(_34371300).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23_1'('FAIL'(_34371370),_34353104,'FAIL'(_34371370),_34371384,_34371384):-nonvar(_34371370).

'XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'(_34373354,_34373356,_34373358):-freeze(_34373356,'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'(_34373354,_34373356,_34373358)).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'('XML.StandardEnc',_34373536,_34373536).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'('XML.Iso88591Enc',_34374086,_34374086).

'XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34376400,_34376402,_34376404,_34376406):-freeze(_34376404,'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34376400,_34376402,_34376404,_34376406)).
'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34376486,_34377142,_34377148,_34377154):-hnf(_34376486,_34379176,_34377148,_34379188),'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_34379176,_34377142,_34379188,_34377154).

'blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_34379706,_34379708,_34379710,_34379712):-freeze(_34379710,'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_34379706,_34379708,_34379710,_34379712)).
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23',[]),'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'),_34380058,_34380058):-!.
'blocked_blocked_XML._inst\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('FAIL'(_34381600),'FAIL'(_34381600),_34381614,_34381614):-nonvar(_34381600).

'XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34383698,_34383700,_34383702,_34383704,_34383706):-freeze(_34383704,'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34383698,_34383700,_34383702,_34383704,_34383706)).
'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34383794,_34383812,_34385388,_34385394,_34385400):-hnf(_34383794,_34387862,_34385394,_34387880),'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_34387862,_34383812,_34385388,_34387880,_34385400).

'blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_34388478,_34388480,_34388482,_34388484,_34388486):-freeze(_34388484,'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'(_34388478,_34388480,_34388482,_34388484,_34388486)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('XML.Enc'(_34383928),_34383812,_34389310,_34389316,_34389322):-hnf(_34383812,_34392384,_34389316,_34392402),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'(_34392384,_34383928,_34389310,_34392402,_34389322).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'(_34393108,_34393110,_34393112,_34393114,_34393116):-freeze(_34393114,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'(_34393108,_34393110,_34393112,_34393114,_34393116)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'('XML.Enc'(_34384050),_34383928,_34393446,_34393452,_34393458):-hnf('XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.Encoding\'23'(_34383928,_34384050),_34393446,_34393452,_34393458).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'('XML.DtdUrl'(_34384314),_34383928,'Prelude.False',_34395104,_34395104):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.Enc_2'('FAIL'(_34396012),_34383928,'FAIL'(_34396012),_34396026,_34396026):-nonvar(_34396012).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('XML.DtdUrl'(_34384444),_34383812,_34396868,_34396874,_34396880):-!,hnf(_34383812,_34400032,_34396874,_34400050),'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'(_34400032,_34384444,_34396868,_34400050,_34396880).

'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'(_34400792,_34400794,_34400796,_34400798,_34400800):-freeze(_34400798,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'(_34400792,_34400794,_34400796,_34400798,_34400800)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'('XML.Enc'(_34384566),_34384444,'Prelude.False',_34401136,_34401136).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'('XML.DtdUrl'(_34384690),_34384444,_34402334,_34402340,_34402346):-!,hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_34384444,_34384690),_34402334,_34402340,_34402346).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1_XML.DtdUrl_2'('FAIL'(_34404160),_34384444,'FAIL'(_34404160),_34404174,_34404174):-nonvar(_34404160).
'blocked_blocked_XML._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23XML.XmlDocParams\'23_1'('FAIL'(_34404238),_34383812,'FAIL'(_34404238),_34404252,_34404252):-nonvar(_34404238).

'XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34406374,_34406376,_34406378):-freeze(_34406376,'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'(_34406374,_34406376,_34406378)).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'('XML.Enc'('XML._impl\'23aValue\'23Prelude.Data\'23XML.Encoding\'23'),_34406808,_34406808).
'blocked_XML._impl\'23aValue\'23Prelude.Data\'23XML.XmlDocParams\'23'('XML.DtdUrl'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]))),_34407754,_34407754).

'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23'(_34410602,_34410604,_34410606,_34410608):-freeze(_34410606,'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23'(_34410602,_34410604,_34410606,_34410608)).
'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23'(_34410688,_34411296,_34411302,_34411308):-hnf(_34410688,_34413042,_34411302,_34413054),'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_34413042,_34411296,_34413054,_34411308).

'blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_34413524,_34413526,_34413528,_34413530):-freeze(_34413528,'blocked_blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_34413524,_34413526,_34413528,_34413530)).
'blocked_blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Eq'(partcall(2,'XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23',[]),'XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'),_34413876,_34413876):-!.
'blocked_blocked_XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23_1'('FAIL'(_34415244),'FAIL'(_34415244),_34415258,_34415258):-nonvar(_34415244).

'XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_34416972,_34416974,_34416976,_34416978,_34416980):-freeze(_34416978,'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_34416972,_34416974,_34416976,_34416978,_34416980)).
'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_34417068,_34417086,_34419944,_34419950,_34419956):-hnf(_34417068,_34422022,_34419950,_34422040),'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_34422022,_34417086,_34419944,_34422040,_34419956).

'blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_34422572,_34422574,_34422576,_34422578,_34422580):-freeze(_34422578,'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'(_34422572,_34422574,_34422576,_34422578,_34422580)).
'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'('XML.XText'(_34417202),_34417086,_34423362,_34423368,_34423374):-hnf(_34417086,_34426100,_34423368,_34426118),'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'(_34426100,_34417202,_34423362,_34426118,_34423374).

'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'(_34426770,_34426772,_34426774,_34426776,_34426778):-freeze(_34426776,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'(_34426770,_34426772,_34426774,_34426776,_34426778)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XText'(_34417324),_34417202,_34427132,_34427138,_34427144):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34417202,_34417324),_34427132,_34427138,_34427144).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XElem'(_34417672,_34417690,_34417708),_34417202,'Prelude.False',_34429120,_34429120):-!.
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XText_2'('FAIL'(_34430106),_34417202,'FAIL'(_34430106),_34430120,_34430120):-nonvar(_34430106).
'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'('XML.XElem'(_34417850,_34417868,_34417886),_34417086,_34430916,_34430922,_34430928):-!,hnf(_34417086,_34433654,_34430922,_34433684),'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'(_34433654,_34417850,_34417868,_34417886,_34430916,_34433684,_34430928).

'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'(_34434370,_34434372,_34434374,_34434376,_34434378,_34434380,_34434382):-freeze(_34434380,'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'(_34434370,_34434372,_34434374,_34434376,_34434378,_34434380,_34434382)).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XText'(_34418020),_34417850,_34417868,_34417886,'Prelude.False',_34434758,_34434758).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XElem'(_34418144,_34418162,_34418180),_34417850,_34417868,_34417886,_34436036,_34436042,_34436048):-!,hnf('Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34417850,_34418144),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_34417868,_34418162)),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',[]),_34417886,_34418180)),_34436036,_34436042,_34436048).
'blocked_blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1_XML.XElem_4'('FAIL'(_34442246),_34417850,_34417868,_34417886,'FAIL'(_34442246),_34442260,_34442260):-nonvar(_34442246).
'blocked_blocked_XML._impl\'23\'3D\'3D\'23Prelude.Eq\'23XML.XmlExp\'23_1'('FAIL'(_34442340),_34417086,'FAIL'(_34442340),_34442354,_34442354):-nonvar(_34442340).

'XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_34444076,_34444078,_34444080):-freeze(_34444078,'blocked_XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_34444076,_34444078,_34444080)).
'blocked_XML._impl\'23\'2F\'3D\'23Prelude.Eq\'23XML.XmlExp\'23'(_34444248,_34444254,_34444260):-hnf(partcall(2,'Prelude._def\'23\'2F\'3D\'23Prelude.Eq',[partcall(1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',[])]),_34444248,_34444254,_34444260).

'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23'(_34446766,_34446768,_34446770,_34446772):-freeze(_34446770,'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23'(_34446766,_34446768,_34446770,_34446772)).
'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23'(_34446852,_34447970,_34447976,_34447982):-hnf(_34446852,_34449752,_34447976,_34449764),'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_34449752,_34447970,_34449764,_34447982).

'blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_34450240,_34450242,_34450244,_34450246):-freeze(_34450244,'blocked_blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_34450240,_34450242,_34450244,_34450246)).
'blocked_blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Ord'(partcall(1,'XML._inst\'23Prelude.Eq\'23XML.XmlExp\'23',[]),'XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23',partcall(2,'XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23',[]),'XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23','XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'),_34450592,_34450592):-!.
'blocked_blocked_XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23_1'('FAIL'(_34454262),'FAIL'(_34454262),_34454276,_34454276):-nonvar(_34454262).

'XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23'(_34456162,_34456164,_34456166):-freeze(_34456164,'blocked_XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23'(_34456162,_34456164,_34456166)).
'blocked_XML._impl\'23compare\'23Prelude.Ord\'23XML.XmlExp\'23'(_34456334,_34456340,_34456346):-hnf(partcall(2,'Prelude._def\'23compare\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_34456334,_34456340,_34456346).

'XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23'(_34459014,_34459016,_34459018):-freeze(_34459016,'blocked_XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23'(_34459014,_34459016,_34459018)).
'blocked_XML._impl\'23\'3C\'23Prelude.Ord\'23XML.XmlExp\'23'(_34459186,_34459192,_34459198):-hnf(partcall(2,'Prelude._def\'23\'3C\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_34459186,_34459192,_34459198).

'XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23'(_34461818,_34461820,_34461822):-freeze(_34461820,'blocked_XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23'(_34461818,_34461820,_34461822)).
'blocked_XML._impl\'23\'3E\'23Prelude.Ord\'23XML.XmlExp\'23'(_34461990,_34461996,_34462002):-hnf(partcall(2,'Prelude._def\'23\'3E\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_34461990,_34461996,_34462002).

'XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_34464688,_34464690,_34464692,_34464694,_34464696):-freeze(_34464694,'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_34464688,_34464690,_34464692,_34464694,_34464696)).
'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_34464784,_34464802,_34469514,_34469520,_34469526):-hnf(_34464784,_34471628,_34469520,_34471646),'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_34471628,_34464802,_34469514,_34471646,_34469526).

'blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_34472184,_34472186,_34472188,_34472190,_34472192):-freeze(_34472190,'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'(_34472184,_34472186,_34472188,_34472190,_34472192)).
'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'('XML.XText'(_34464918),_34464802,_34472980,_34472986,_34472992):-hnf(_34464802,_34475754,_34472986,_34475772),'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'(_34475754,_34464918,_34472980,_34475772,_34472992).

'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'(_34476430,_34476432,_34476434,_34476436,_34476438):-freeze(_34476436,'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'(_34476430,_34476432,_34476434,_34476436,_34476438)).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XText'(_34465040),_34464918,_34476792,_34476798,_34476804):-hnf('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[]),_34464918,_34465040),_34476792,_34476798,_34476804).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'('XML.XElem'(_34465388,_34465406,_34465424),_34464918,'Prelude.True',_34478798,_34478798):-!.
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XText_2'('FAIL'(_34479784),_34464918,'FAIL'(_34479784),_34479798,_34479798):-nonvar(_34479784).
'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'('XML.XElem'(_34465566,_34465584,_34465602),_34464802,_34480600,_34480606,_34480612):-!,hnf(_34464802,_34483374,_34480606,_34483404),'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'(_34483374,_34465566,_34465584,_34465602,_34480600,_34483404,_34480612).

'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'(_34484096,_34484098,_34484100,_34484102,_34484104,_34484106,_34484108):-freeze(_34484106,'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'(_34484096,_34484098,_34484100,_34484102,_34484104,_34484106,_34484108)).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XText'(_34465736),_34465566,_34465584,_34465602,'Prelude.False',_34484484,_34484484).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'('XML.XElem'(_34465860,_34465878,_34465896),_34465566,_34465584,_34465602,_34485768,_34485774,_34485780):-!,makeShare(_34465566,_34486338),makeShare(_34465860,_34486358),makeShare(_34465584,_34486378),makeShare(_34465878,_34486398),hnf('Prelude.||'('Prelude.||'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])),_34486338),_34486358),'Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34486338,_34486358),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Char\'23',[])])])),_34486378),_34486398))),'Prelude.&&'('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34486338,_34486358),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_34486378,_34486398)),'Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[]),_34465602,_34465896))),_34485768,_34485774,_34485780).
'blocked_blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1_XML.XElem_4'('FAIL'(_34499118),_34465566,_34465584,_34465602,'FAIL'(_34499118),_34499132,_34499132):-nonvar(_34499118).
'blocked_blocked_XML._impl\'23\'3C\'3D\'23Prelude.Ord\'23XML.XmlExp\'23_1'('FAIL'(_34499212),_34464802,'FAIL'(_34499212),_34499226,_34499226):-nonvar(_34499212).

'XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_34500986,_34500988,_34500990):-freeze(_34500988,'blocked_XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_34500986,_34500988,_34500990)).
'blocked_XML._impl\'23\'3E\'3D\'23Prelude.Ord\'23XML.XmlExp\'23'(_34501158,_34501164,_34501170):-hnf(partcall(2,'Prelude._def\'23\'3E\'3D\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_34501158,_34501164,_34501170).

'XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23'(_34503874,_34503876,_34503878):-freeze(_34503876,'blocked_XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23'(_34503874,_34503876,_34503878)).
'blocked_XML._impl\'23min\'23Prelude.Ord\'23XML.XmlExp\'23'(_34504046,_34504052,_34504058):-hnf(partcall(2,'Prelude._def\'23min\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_34504046,_34504052,_34504058).

'XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'(_34506726,_34506728,_34506730):-freeze(_34506728,'blocked_XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'(_34506726,_34506728,_34506730)).
'blocked_XML._impl\'23max\'23Prelude.Ord\'23XML.XmlExp\'23'(_34506898,_34506904,_34506910):-hnf(partcall(2,'Prelude._def\'23max\'23Prelude.Ord',[partcall(1,'XML._inst\'23Prelude.Ord\'23XML.XmlExp\'23',[])]),_34506898,_34506904,_34506910).

'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23'(_34509436,_34509438,_34509440,_34509442):-freeze(_34509440,'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23'(_34509436,_34509438,_34509440,_34509442)).
'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23'(_34509522,_34510226,_34510232,_34510238):-hnf(_34509522,_34512044,_34510232,_34512056),'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'(_34512044,_34510226,_34512056,_34510238).

'blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'(_34512538,_34512540,_34512542,_34512544):-freeze(_34512542,'blocked_blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'(_34512538,_34512540,_34512542,_34512544)).
'blocked_blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'('Prelude.()','Prelude._Dict\'23Show'('XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23',partcall(2,'XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23',[]),'XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'),_34512890,_34512890):-!.
'blocked_blocked_XML._inst\'23Prelude.Show\'23XML.XmlExp\'23_1'('FAIL'(_34514730),'FAIL'(_34514730),_34514744,_34514744):-nonvar(_34514730).

'XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23'(_34516554,_34516556,_34516558):-freeze(_34516556,'blocked_XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23'(_34516554,_34516556,_34516558)).
'blocked_XML._impl\'23show\'23Prelude.Show\'23XML.XmlExp\'23'(_34516726,_34516732,_34516738):-hnf(partcall(1,'Prelude._def\'23show\'23Prelude.Show',[partcall(1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',[])]),_34516726,_34516732,_34516738).

'XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23'(_34519702,_34519704,_34519706,_34519708,_34519710):-freeze(_34519708,'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23'(_34519702,_34519704,_34519706,_34519708,_34519710)).
'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23'(_34519798,_34519816,_34526564,_34526570,_34526576):-hnf(_34519816,_34528822,_34526570,_34528840),'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'(_34528822,_34519798,_34526564,_34528840,_34526576).

'blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'(_34529402,_34529404,_34529406,_34529408,_34529410):-freeze(_34529408,'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'(_34529402,_34529404,_34529406,_34529408,_34529410)).
'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'('XML.XText'(_34519932),_34519798,_34529764,_34529770,_34529776):-hnf('Prelude.showParen'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',10),_34519798),'Prelude..'(partcall(1,'Prelude.showString',[['^X','^T','^e','^x','^t','^ ']]),'Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[]),11),_34519932))),_34529764,_34529770,_34529776).
'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'('XML.XElem'(_34522016,_34522034,_34522052),_34519798,_34534790,_34534796,_34534802):-!,hnf('Prelude.showParen'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',10),_34519798),'Prelude..'(partcall(1,'Prelude.showString',[['^X','^E','^l','^e','^m','^ ']]),'Prelude..'('Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[]),11),_34522016),'Prelude..'(partcall(1,'Prelude.showString',[['^ ']]),'Prelude..'('Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Show\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])]),partcall(1,'Prelude._inst\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Show\'23Prelude.Char\'23',[])])]),11),_34522034),'Prelude..'(partcall(1,'Prelude.showString',[['^ ']]),'Prelude.apply'('Prelude._impl\'23showsPrec\'23Prelude.Show\'23\'5B\'5D\'230\'23\'23'(partcall(1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',[]),11),_34522052))))))),_34534790,_34534796,_34534802).
'blocked_blocked_XML._impl\'23showsPrec\'23Prelude.Show\'23XML.XmlExp\'23_2'('FAIL'(_34545680),_34519798,'FAIL'(_34545680),_34545694,_34545694):-nonvar(_34545680).

'XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'(_34547664,_34547666,_34547668):-freeze(_34547666,'blocked_XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'(_34547664,_34547666,_34547668)).
'blocked_XML._impl\'23showList\'23Prelude.Show\'23XML.XmlExp\'23'(_34547836,_34547842,_34547848):-hnf('Prelude._def\'23showList\'23Prelude.Show'(partcall(1,'XML._inst\'23Prelude.Show\'23XML.XmlExp\'23',[])),_34547836,_34547842,_34547848).

'XML.encoding2Attribute'(_34549874,_34549876,_34549878,_34549880):-freeze(_34549878,'blocked_XML.encoding2Attribute'(_34549874,_34549876,_34549878,_34549880)).
'blocked_XML.encoding2Attribute'(_34549960,_34553792,_34553798,_34553804):-hnf(_34549960,_34554962,_34553798,_34554974),'blocked_XML.encoding2Attribute_1'(_34554962,_34553792,_34554974,_34553804).

'blocked_XML.encoding2Attribute_1'(_34555348,_34555350,_34555352,_34555354):-freeze(_34555352,'blocked_blocked_XML.encoding2Attribute_1'(_34555348,_34555350,_34555352,_34555354)).
'blocked_blocked_XML.encoding2Attribute_1'('XML.StandardEnc',[],_34555768,_34555768).
'blocked_blocked_XML.encoding2Attribute_1'('XML.Iso88591Enc',['^e','^n','^c','^o','^d','^i','^n','^g',^=,'^"','^i','^s','^o',^-,'^8','^8','^5','^9',^-,'^1','^"','^ '],_34556458,_34556458):-!.
'blocked_blocked_XML.encoding2Attribute_1'('FAIL'(_34561264),'FAIL'(_34561264),_34561278,_34561278):-nonvar(_34561264).

'XML.encoding2EncFunc'(_34562222,_34562224,_34562226,_34562228):-freeze(_34562226,'blocked_XML.encoding2EncFunc'(_34562222,_34562224,_34562226,_34562228)).
'blocked_XML.encoding2EncFunc'(_34562308,_34562740,_34562746,_34562752):-hnf(_34562308,_34563838,_34562746,_34563850),'blocked_XML.encoding2EncFunc_1'(_34563838,_34562740,_34563850,_34562752).

'blocked_XML.encoding2EncFunc_1'(_34564212,_34564214,_34564216,_34564218):-freeze(_34564216,'blocked_blocked_XML.encoding2EncFunc_1'(_34564212,_34564214,_34564216,_34564218)).
'blocked_blocked_XML.encoding2EncFunc_1'('XML.StandardEnc',_34564626,_34564632,_34564638):-hnf(partcall(1,'XML.standardEncoding',[]),_34564626,_34564632,_34564638).
'blocked_blocked_XML.encoding2EncFunc_1'('XML.Iso88591Enc',_34565450,_34565456,_34565462):-!,hnf(partcall(1,'XML.iso88591Encoding',[]),_34565450,_34565456,_34565462).
'blocked_blocked_XML.encoding2EncFunc_1'('FAIL'(_34565958),'FAIL'(_34565958),_34565972,_34565972):-nonvar(_34565958).

'XML.standardEncoding'(_34566916,_34566918,_34566920,_34566922):-freeze(_34566920,'blocked_XML.standardEncoding'(_34566916,_34566918,_34566920,_34566922)).
'blocked_XML.standardEncoding'(_34567002,_34578858,_34578864,_34578870):-hnf(_34567002,_34579956,_34578864,_34579968),'blocked_XML.standardEncoding_1'(_34579956,_34578858,_34579968,_34578870).

'blocked_XML.standardEncoding_1'(_34580330,_34580332,_34580334,_34580336):-freeze(_34580334,'blocked_blocked_XML.standardEncoding_1'(_34580330,_34580332,_34580334,_34580336)).
'blocked_blocked_XML.standardEncoding_1'([],[],_34580578,_34580578).
'blocked_blocked_XML.standardEncoding_1'([_34567218|_34567236],_34585786,_34585792,_34585798):-!,makeShare(_34567218,_34581742),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_34581742,^<),_34587466,_34585792,_34587432),'blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'(_34587466,_34581742,_34567236,_34585786,_34587432,_34585798).

'blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'(_34587990,_34587992,_34587994,_34587996,_34587998,_34588000):-freeze(_34587998,freeze(_34587990,'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'(_34587990,_34587992,_34587994,_34587996,_34587998,_34588000))).
'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'('Prelude.True',_34581742,_34567236,_34588394,_34588400,_34588406):-hnf('Prelude.++'([^&,'^l','^t','^;'],'XML.standardEncoding'(_34567236)),_34588394,_34588400,_34588406).
'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'('Prelude.False',_34581742,_34567236,_34595146,_34595152,_34595158):-!,makeShare(_34581742,_34591290),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_34591290,^>),_34598006,_34595152,_34597972),'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_34598006,_34591290,_34567236,_34595146,_34597972,_34595158).

'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_34598734,_34598736,_34598738,_34598740,_34598742,_34598744):-freeze(_34598742,freeze(_34598734,'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_34598734,_34598736,_34598738,_34598740,_34598742,_34598744))).
'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34591290,_34567236,_34599138,_34599144,_34599150):-hnf('Prelude.++'([^&,'^g','^t','^;'],'XML.standardEncoding'(_34567236)),_34599138,_34599144,_34599150).
'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34591290,_34567236,_34605898,_34605904,_34605910):-!,makeShare(_34591290,_34602170),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_34602170,^&),_34609982,_34605904,_34609948),'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34609982,_34602170,_34567236,_34605898,_34609948,_34605910).

'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34610914,_34610916,_34610918,_34610920,_34610922,_34610924):-freeze(_34610922,freeze(_34610914,'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34610914,_34610916,_34610918,_34610920,_34610922,_34610924))).
'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34602170,_34567236,_34611318,_34611324,_34611330):-hnf('Prelude.++'([^&,'^a','^m','^p','^;'],'XML.standardEncoding'(_34567236)),_34611318,_34611324,_34611330).
'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34602170,_34567236,_34618260,_34618266,_34618272):-!,makeShare(_34602170,_34614684),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_34614684,'^"'),_34623568,_34618266,_34623534),'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34623568,_34614684,_34567236,_34618260,_34623534,_34618272).

'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34624704,_34624706,_34624708,_34624710,_34624712,_34624714):-freeze(_34624712,freeze(_34624704,'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34624704,_34624706,_34624708,_34624710,_34624712,_34624714))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34614684,_34567236,_34625108,_34625114,_34625120):-hnf('Prelude.++'([^&,'^q','^u','^o','^t','^;'],'XML.standardEncoding'(_34567236)),_34625108,_34625114,_34625120).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34614684,_34567236,_34632204,_34632210,_34632216):-!,makeShare(_34614684,_34628804),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_34628804,'^\''),_34638736,_34632210,_34638702),'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34638736,_34628804,_34567236,_34632204,_34638702,_34632216).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34640076,_34640078,_34640080,_34640082,_34640084,_34640086):-freeze(_34640084,freeze(_34640076,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34640076,_34640078,_34640080,_34640082,_34640084,_34640086))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34628804,_34567236,_34640480,_34640486,_34640492):-hnf('Prelude.++'([^&,'^a','^p','^o','^s','^;'],'XML.standardEncoding'(_34567236)),_34640480,_34640486,_34640492).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34628804,_34567236,_34648000,_34648006,_34648012):-!,makeShare(_34628804,_34644304),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23','Prelude.ord'(_34644304)),32),_34655756,_34648006,_34655722),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34655756,_34644304,_34567236,_34648000,_34655722,_34648012).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34657300,_34657302,_34657304,_34657306,_34657308,_34657310):-freeze(_34657308,freeze(_34657300,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34657300,_34657302,_34657304,_34657306,_34657308,_34657310))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34644304,_34567236,_34657704,_34657710,_34657716):-hnf('Prelude.++'([^&,^#],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23','Prelude.ord'(_34644304)),'Prelude.++'(['^;'],'XML.standardEncoding'(_34567236)))),_34657704,_34657710,_34657716).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34644304,_34567236,_34665950,_34665956,_34665962):-!,makeShare(_34644304,_34662494),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'23Prelude.Ord\'23Prelude.Int\'23','Prelude.ord'(_34662494)),127),_34674930,_34665956,_34674896),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34674930,_34662494,_34567236,_34665950,_34674896,_34665962).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34676678,_34676680,_34676682,_34676684,_34676686,_34676688):-freeze(_34676686,freeze(_34676678,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34676678,_34676680,_34676682,_34676684,_34676686,_34676688))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34662494,_34567236,_34677082,_34677088,_34677094):-hnf('Prelude.++'([^&,^#],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23','Prelude.ord'(_34662494)),'Prelude.++'(['^;'],'XML.standardEncoding'(_34567236)))),_34677082,_34677088,_34677094).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34662494,_34567236,_34684122,_34684128,_34684134):-!,hnf('Prelude.otherwise',_34694326,_34684128,_34694292),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34694326,_34662494,_34567236,_34684122,_34694292,_34684134).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34696266,_34696268,_34696270,_34696272,_34696274,_34696276):-freeze(_34696274,freeze(_34696266,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34696266,_34696268,_34696270,_34696272,_34696274,_34696276))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34662494,_34567236,[_34662494|'XML.standardEncoding'(_34567236)],_34696676,_34696676).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34662494,_34567236,_34699476,_34699482,_34699488):-!,hnf(reportFailure4PAKCS('XML.standardEncoding',['Prelude.False']),_34699476,_34699482,_34699488).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702322),_34662494,_34567236,'FAIL'(_34702322),_34702336,_34702336).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702404),_34662494,_34567236,'FAIL'(_34702404),_34702418,_34702418).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702486),_34644304,_34567236,'FAIL'(_34702486),_34702500,_34702500).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702568),_34628804,_34567236,'FAIL'(_34702568),_34702582,_34702582).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702650),_34614684,_34567236,'FAIL'(_34702650),_34702664,_34702664).
'blocked_blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702732),_34602170,_34567236,'FAIL'(_34702732),_34702746,_34702746).
'blocked_blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34702814),_34591290,_34567236,'FAIL'(_34702814),_34702828,_34702828).
'blocked_blocked_blocked_XML.standardEncoding_1_[|]_ComplexCase'('FAIL'(_34702896),_34581742,_34567236,'FAIL'(_34702896),_34702910,_34702910).
'blocked_blocked_XML.standardEncoding_1'('FAIL'(_34702978),'FAIL'(_34702978),_34702992,_34702992):-nonvar(_34702978).

'XML.iso88591Encoding'(_34703936,_34703938,_34703940,_34703942):-freeze(_34703940,'blocked_XML.iso88591Encoding'(_34703936,_34703938,_34703940,_34703942)).
'blocked_XML.iso88591Encoding'(_34704022,_34705826,_34705832,_34705838):-hnf(_34704022,_34706924,_34705832,_34706936),'blocked_XML.iso88591Encoding_1'(_34706924,_34705826,_34706936,_34705838).

'blocked_XML.iso88591Encoding_1'(_34707298,_34707300,_34707302,_34707304):-freeze(_34707302,'blocked_blocked_XML.iso88591Encoding_1'(_34707298,_34707300,_34707302,_34707304)).
'blocked_blocked_XML.iso88591Encoding_1'([],[],_34707546,_34707546).
'blocked_blocked_XML.iso88591Encoding_1'([_34704238|_34704256],_34710230,_34710236,_34710242):-!,makeShare(_34704238,_34708220),hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),'Prelude.ord'(_34708220)),'XML.iso88591list'),_34711910,_34710236,_34711876),'blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'(_34711910,_34708220,_34704256,_34710230,_34711876,_34710242).

'blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'(_34712434,_34712436,_34712438,_34712440,_34712442,_34712444):-freeze(_34712442,freeze(_34712434,'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'(_34712434,_34712436,_34712438,_34712440,_34712442,_34712444))).
'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'('Prelude.True',_34708220,_34704256,[_34708220|'XML.iso88591Encoding'(_34704256)],_34712844,_34712844).
'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'('Prelude.False',_34708220,_34704256,_34714216,_34714222,_34714228):-!,hnf('Prelude.++'('XML.standardEncoding'([_34708220]),'XML.iso88591Encoding'(_34704256)),_34714216,_34714222,_34714228).
'blocked_blocked_blocked_XML.iso88591Encoding_1_[|]_ComplexCase'('FAIL'(_34715888),_34708220,_34704256,'FAIL'(_34715888),_34715902,_34715902).
'blocked_blocked_XML.iso88591Encoding_1'('FAIL'(_34715970),'FAIL'(_34715970),_34715984,_34715984):-nonvar(_34715970).

'XML.iso88591list'(_34716776,_34716778,_34716780):-freeze(_34716778,'blocked_XML.iso88591list'(_34716776,_34716778,_34716780)).
'blocked_XML.iso88591list'([192,193,194,195,196,197,198,199,200,201,202,203,204,205,207,208,209,210,211,212,214,216,217,218,219,220,221,224,225,228,229,226,227,230,231,233,232,235,234,236,237,239,240,241,248,246,242,243,244,245,250,249,252,251,253,255],_34725494,_34725494).

'XML.lookupEncoding'(_34737192,_34737194,_34737196,_34737198):-freeze(_34737196,'blocked_XML.lookupEncoding'(_34737192,_34737194,_34737196,_34737198)).
'blocked_XML.lookupEncoding'(_34737278,_34738054,_34738060,_34738066):-hnf(_34737278,_34739080,_34738060,_34739092),'blocked_XML.lookupEncoding_1'(_34739080,_34738054,_34739092,_34738066).

'blocked_XML.lookupEncoding_1'(_34739442,_34739444,_34739446,_34739448):-freeze(_34739446,'blocked_blocked_XML.lookupEncoding_1'(_34739442,_34739444,_34739446,_34739448)).
'blocked_blocked_XML.lookupEncoding_1'([_34737394|_34737412],_34739958,_34739964,_34739970):-hnf(_34737394,_34741464,_34739964,_34741482),'blocked_blocked_XML.lookupEncoding_1_[|]_1'(_34741464,_34737412,_34739958,_34741482,_34739970).

'blocked_blocked_XML.lookupEncoding_1_[|]_1'(_34741924,_34741926,_34741928,_34741930,_34741932):-freeze(_34741930,'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'(_34741924,_34741926,_34741928,_34741930,_34741932)).
'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'('XML.Enc'(_34737540),_34737412,_34742262,_34742268,_34742274):-hnf(_34737540,_34742262,_34742268,_34742274).
'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'('XML.DtdUrl'(_34737650),_34737412,_34743108,_34743114,_34743120):-!,hnf('XML.lookupEncoding'(_34737412),_34743108,_34743114,_34743120).
'blocked_blocked_blocked_XML.lookupEncoding_1_[|]_1'('FAIL'(_34743906),_34737412,'FAIL'(_34743906),_34743920,_34743920):-nonvar(_34743906).
'blocked_blocked_XML.lookupEncoding_1'([],'XML.StandardEnc',_34744152,_34744152):-!.
'blocked_blocked_XML.lookupEncoding_1'('FAIL'(_34744584),'FAIL'(_34744584),_34744598,_34744598):-nonvar(_34744584).

'XML.lookupDtdUrl'(_34745390,_34745392,_34745394,_34745396):-freeze(_34745394,'blocked_XML.lookupDtdUrl'(_34745390,_34745392,_34745394,_34745396)).
'blocked_XML.lookupDtdUrl'(_34745476,_34746240,_34746246,_34746252):-hnf(_34745476,_34747194,_34746246,_34747206),'blocked_XML.lookupDtdUrl_1'(_34747194,_34746240,_34747206,_34746252).

'blocked_XML.lookupDtdUrl_1'(_34747544,_34747546,_34747548,_34747550):-freeze(_34747548,'blocked_blocked_XML.lookupDtdUrl_1'(_34747544,_34747546,_34747548,_34747550)).
'blocked_blocked_XML.lookupDtdUrl_1'([],[],_34747792,_34747792).
'blocked_blocked_XML.lookupDtdUrl_1'([_34745692|_34745710],_34748530,_34748536,_34748542):-!,hnf(_34745692,_34749964,_34748536,_34749982),'blocked_blocked_XML.lookupDtdUrl_1_[|]_1'(_34749964,_34745710,_34748530,_34749982,_34748542).

'blocked_blocked_XML.lookupDtdUrl_1_[|]_1'(_34750430,_34750432,_34750434,_34750436,_34750438):-freeze(_34750436,'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'(_34750430,_34750432,_34750434,_34750436,_34750438)).
'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'('XML.Enc'(_34745838),_34745710,_34750768,_34750774,_34750780):-hnf('XML.lookupDtdUrl'(_34745710),_34750768,_34750774,_34750780).
'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'('XML.DtdUrl'(_34746032),_34745710,_34751808,_34751814,_34751820):-!,hnf(_34746032,_34751808,_34751814,_34751820).
'blocked_blocked_blocked_XML.lookupDtdUrl_1_[|]_1'('FAIL'(_34752376),_34745710,'FAIL'(_34752376),_34752390,_34752390):-nonvar(_34752376).
'blocked_blocked_XML.lookupDtdUrl_1'('FAIL'(_34752454),'FAIL'(_34752454),_34752468,_34752468):-nonvar(_34752454).

'XML.hasDtdUrl'(_34753146,_34753148,_34753150,_34753152):-freeze(_34753150,'blocked_XML.hasDtdUrl'(_34753146,_34753148,_34753150,_34753152)).
'blocked_XML.hasDtdUrl'(_34753232,_34753992,_34753998,_34754004):-hnf(_34753232,_34754838,_34753998,_34754850),'blocked_XML.hasDtdUrl_1'(_34754838,_34753992,_34754850,_34754004).

'blocked_XML.hasDtdUrl_1'(_34755170,_34755172,_34755174,_34755176):-freeze(_34755174,'blocked_blocked_XML.hasDtdUrl_1'(_34755170,_34755172,_34755174,_34755176)).
'blocked_blocked_XML.hasDtdUrl_1'([],'Prelude.False',_34755418,_34755418).
'blocked_blocked_XML.hasDtdUrl_1'([_34753448|_34753466],_34756202,_34756208,_34756214):-!,hnf(_34753448,_34757528,_34756208,_34757546),'blocked_blocked_XML.hasDtdUrl_1_[|]_1'(_34757528,_34753466,_34756202,_34757546,_34756214).

'blocked_blocked_XML.hasDtdUrl_1_[|]_1'(_34757976,_34757978,_34757980,_34757982,_34757984):-freeze(_34757982,'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'(_34757976,_34757978,_34757980,_34757982,_34757984)).
'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'('XML.DtdUrl'(_34753594),_34753466,'Prelude.True',_34758356,_34758356).
'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'('XML.Enc'(_34753718),_34753466,_34759200,_34759206,_34759212):-!,hnf('XML.hasDtdUrl'(_34753466),_34759200,_34759206,_34759212).
'blocked_blocked_blocked_XML.hasDtdUrl_1_[|]_1'('FAIL'(_34759938),_34753466,'FAIL'(_34759938),_34759952,_34759952):-nonvar(_34759938).
'blocked_blocked_XML.hasDtdUrl_1'('FAIL'(_34760016),'FAIL'(_34760016),_34760030,_34760030):-nonvar(_34760016).

'XML.tagOf'(_34760556,_34760558,_34760560,_34760562):-freeze(_34760560,'blocked_XML.tagOf'(_34760556,_34760558,_34760560,_34760562)).
'blocked_XML.tagOf'(_34760642,_34761090,_34761096,_34761102):-hnf(_34760642,_34761792,_34761096,_34761804),'blocked_XML.tagOf_1'(_34761792,_34761090,_34761804,_34761102).

'blocked_XML.tagOf_1'(_34762100,_34762102,_34762104,_34762106):-freeze(_34762104,'blocked_blocked_XML.tagOf_1'(_34762100,_34762102,_34762104,_34762106)).
'blocked_blocked_XML.tagOf_1'('XML.XElem'(_34760758,_34760776,_34760794),_34762468,_34762474,_34762480):-hnf(_34760758,_34762468,_34762474,_34762480).
'blocked_blocked_XML.tagOf_1'('XML.XText'(_34760916),[],_34763228,_34763228):-!.
'blocked_blocked_XML.tagOf_1'('FAIL'(_34763578),'FAIL'(_34763578),_34763592,_34763592):-nonvar(_34763578).

'XML.elemsOf'(_34764194,_34764196,_34764198,_34764200):-freeze(_34764198,'blocked_XML.elemsOf'(_34764194,_34764196,_34764198,_34764200)).
'blocked_XML.elemsOf'(_34764280,_34764740,_34764746,_34764752):-hnf(_34764280,_34765514,_34764746,_34765526),'blocked_XML.elemsOf_1'(_34765514,_34764740,_34765526,_34764752).

'blocked_XML.elemsOf_1'(_34765834,_34765836,_34765838,_34765840):-freeze(_34765838,'blocked_blocked_XML.elemsOf_1'(_34765834,_34765836,_34765838,_34765840)).
'blocked_blocked_XML.elemsOf_1'('XML.XElem'(_34764396,_34764414,_34764432),_34766202,_34766208,_34766214):-hnf(_34764432,_34766202,_34766208,_34766214).
'blocked_blocked_XML.elemsOf_1'('XML.XText'(_34764554),[],_34766974,_34766974):-!.
'blocked_blocked_XML.elemsOf_1'('FAIL'(_34767336),'FAIL'(_34767336),_34767350,_34767350):-nonvar(_34767336).

'XML.textOf'(_34767914,_34767916,_34767918):-freeze(_34767916,'blocked_XML.textOf'(_34767914,_34767916,_34767918)).
'blocked_XML.textOf'(_34768674,_34768680,_34768686):-hnf('Prelude..'(partcall(1,'Prelude.unwords',[]),'Prelude..'(partcall(1,'Prelude.filter',['Prelude..'(partcall(1,'Prelude.not',[]),partcall(1,'Prelude.null',[]))]),partcall(1,'Prelude.map',[partcall(1,'XML.textOf.textOfXmlExp.59',[])]))),_34768674,_34768680,_34768686).

'XML.textOf.textOfXmlExp.59'(_34771746,_34771748,_34771750,_34771752):-freeze(_34771750,'blocked_XML.textOf.textOfXmlExp.59'(_34771746,_34771748,_34771750,_34771752)).
'blocked_XML.textOf.textOfXmlExp.59'(_34771832,_34772536,_34772542,_34772548):-hnf(_34771832,_34773850,_34772542,_34773862),'blocked_XML.textOf.textOfXmlExp.59_1'(_34773850,_34772536,_34773862,_34772548).

'blocked_XML.textOf.textOfXmlExp.59_1'(_34774260,_34774262,_34774264,_34774266):-freeze(_34774264,'blocked_blocked_XML.textOf.textOfXmlExp.59_1'(_34774260,_34774262,_34774264,_34774266)).
'blocked_blocked_XML.textOf.textOfXmlExp.59_1'('XML.XText'(_34771948),_34774612,_34774618,_34774624):-hnf(_34771948,_34774612,_34774618,_34774624).
'blocked_blocked_XML.textOf.textOfXmlExp.59_1'('XML.XElem'(_34772058,_34772076,_34772094),_34775352,_34775358,_34775364):-!,hnf('Prelude.apply'('XML.textOf',_34772094),_34775352,_34775358,_34775364).
'blocked_blocked_XML.textOf.textOfXmlExp.59_1'('FAIL'(_34776310),'FAIL'(_34776310),_34776324,_34776324):-nonvar(_34776310).

'XML.textOfXml'(_34777002,_34777004,_34777006):-freeze(_34777004,'blocked_XML.textOfXml'(_34777002,_34777004,_34777006)).
'blocked_XML.textOfXml'(_34777090,_34777096,_34777102):-hnf('XML.textOf',_34777090,_34777096,_34777102).

'XML.xtxt'(_34777838,_34777840,_34777842,_34777844):-freeze(_34777842,'blocked_XML.xtxt'(_34777838,_34777840,_34777842,_34777844)).
'blocked_XML.xtxt'(_34777924,'XML.XText'(_34777924),_34778030,_34778030).

'XML.xml'(_34778848,_34778850,_34778852,_34778854,_34778856):-freeze(_34778854,'blocked_XML.xml'(_34778848,_34778850,_34778852,_34778854,_34778856)).
'blocked_XML.xml'(_34778944,_34778962,'XML.XElem'(_34778944,[],_34778962),_34779222,_34779222).

'XML.writeXmlFile'(_34780658,_34780660,_34780662,_34780664,_34780666):-freeze(_34780664,'blocked_XML.writeXmlFile'(_34780658,_34780660,_34780662,_34780664,_34780666)).
'blocked_XML.writeXmlFile'(_34780754,_34780772,_34781278,_34781284,_34781290):-hnf('XML.writeXmlFileWithParams'(_34780754,['XML.Enc'('XML.StandardEnc')],_34780772),_34781278,_34781284,_34781290).

'XML.writeXmlFileWithParams'(_34783734,_34783736,_34783738,_34783740,_34783742,_34783744):-freeze(_34783742,'blocked_XML.writeXmlFileWithParams'(_34783734,_34783736,_34783738,_34783740,_34783742,_34783744)).
'blocked_XML.writeXmlFileWithParams'(_34783840,_34783858,_34783876,_34784200,_34784206,_34784212):-hnf('Prelude.writeFile'(_34783840,'XML.showXmlDocWithParams'(_34783858,_34783876)),_34784200,_34784206,_34784212).

'XML.showXmlDoc'(_34786086,_34786088,_34786090,_34786092):-freeze(_34786090,'blocked_XML.showXmlDoc'(_34786086,_34786088,_34786090,_34786092)).
'blocked_XML.showXmlDoc'(_34786172,_34786356,_34786362,_34786368):-hnf('XML.showXmlDocWithParams'([],_34786172),_34786356,_34786362,_34786368).

'XML.showXmlDocWithParams'(_34788074,_34788076,_34788078,_34788080,_34788082):-freeze(_34788080,'blocked_XML.showXmlDocWithParams'(_34788074,_34788076,_34788078,_34788080,_34788082)).
'blocked_XML.showXmlDocWithParams'(_34788170,_34788188,_34803980,_34803986,_34803992):-hnf(_34788188,_34805230,_34803986,_34805248),'blocked_XML.showXmlDocWithParams_2'(_34805230,_34788170,_34803980,_34805248,_34803992).

'blocked_XML.showXmlDocWithParams_2'(_34805642,_34805644,_34805646,_34805648,_34805650):-freeze(_34805648,'blocked_blocked_XML.showXmlDocWithParams_2'(_34805642,_34805644,_34805646,_34805648,_34805650)).
'blocked_blocked_XML.showXmlDocWithParams_2'('XML.XElem'(_34788304,_34788322,_34788340),_34788170,_34806020,_34806026,_34806032):-makeShare(_34788170,_34806482),makeShare(_34788304,_34806502),hnf('Prelude.++'([^<,^?,'^x','^m','^l','^ ','^v','^e','^r','^s','^i','^o','^n',^=,'^"','^1',^.,'^0','^"','^ '],'Prelude.++'('XML.encoding2Attribute'('XML.lookupEncoding'(_34806482)),'Prelude.++'(['^s','^t','^a','^n','^d','^a','^l','^o','^n','^e',^=,'^"'],'Prelude.++'('XML.showXmlDocWithParams._\'23caseor0'('XML.hasDtdUrl'(_34806482)),'Prelude.++'(['^"',^?,^>,'^010','^010'],'Prelude.++'('XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'('XML.hasDtdUrl'(_34806482),_34806502,_34806482),'XML.showXmlExp'(0,'XML.encoding2EncFunc'('XML.lookupEncoding'(_34806482)),'XML.XElem'(_34806502,_34788322,_34788340)))))))),_34806020,_34806026,_34806032).
'blocked_blocked_XML.showXmlDocWithParams_2'('XML.XText'(_34796386),_34788170,_34819894,_34819900,_34819906):-!,hnf('Prelude.error'(['^X','^M','^L',^.,'^s','^h','^o','^w','^X','^m','^l','^D','^o','^c','^W','^i','^t','^h','^P','^a','^r','^a','^m','^s',^:,'^ ','^d','^o','^c','^u','^m','^e','^n','^t','^ ','^w','^i','^t','^h','^o','^u','^t','^ ','^t','^a','^g','^s']),_34819894,_34819900,_34819906).
'blocked_blocked_XML.showXmlDocWithParams_2'('FAIL'(_34830120),_34788170,'FAIL'(_34830120),_34830134,_34830134):-nonvar(_34830120).

'XML.showXmlExp'(_34830858,_34830860,_34830862,_34830864,_34830866,_34830868):-freeze(_34830866,'blocked_XML.showXmlExp'(_34830858,_34830860,_34830862,_34830864,_34830866,_34830868)).
'blocked_XML.showXmlExp'(_34830964,_34830982,_34831000,_34833258,_34833264,_34833270):-hnf(_34831000,_34834156,_34833264,_34834180),'blocked_XML.showXmlExp_3'(_34834156,_34830964,_34830982,_34833258,_34834180,_34833270).

'blocked_XML.showXmlExp_3'(_34834522,_34834524,_34834526,_34834528,_34834530,_34834532):-freeze(_34834530,'blocked_blocked_XML.showXmlExp_3'(_34834522,_34834524,_34834526,_34834528,_34834530,_34834532)).
'blocked_blocked_XML.showXmlExp_3'('XML.XText'(_34831116),_34830964,_34830982,_34834894,_34834900,_34834906):-hnf('Prelude.++'('XML.xtab'(_34830964),'Prelude.++'('Prelude.apply'(_34830982,_34831116),['^010'])),_34834894,_34834900,_34834906).
'blocked_blocked_XML.showXmlExp_3'('XML.XElem'(_34831940,_34831958,_34831976),_34830964,_34830982,_34837062,_34837068,_34837074):-!,makeShare(_34830964,_34837488),makeShare(_34831940,_34837508),makeShare(_34830982,_34837528),makeShare(_34831976,_34837548),hnf('Prelude.++'('XML.xtab'(_34837488),'Prelude.++'('XML.showXmlOpenTag'(_34837508,_34831958,_34837528),'XML.showXmlExp._\'23caseor0'('Prelude.null'(_34837548),_34837548,_34837528,_34837488,_34837508))),_34837062,_34837068,_34837074).
'blocked_blocked_XML.showXmlExp_3'('FAIL'(_34840936),_34830964,_34830982,'FAIL'(_34840936),_34840950,_34840950):-nonvar(_34840936).

'XML.showXmlExp._\'23selFP2\'23s'(_34842170,_34842172,_34842174,_34842176):-freeze(_34842174,'blocked_XML.showXmlExp._\'23selFP2\'23s'(_34842170,_34842172,_34842174,_34842176)).
'blocked_XML.showXmlExp._\'23selFP2\'23s'(_34842256,_34844686,_34844692,_34844698):-hnf(_34842256,_34846108,_34844692,_34846120),'blocked_XML.showXmlExp._\'23selFP2\'23s_1'(_34846108,_34844686,_34846120,_34844698).

'blocked_XML.showXmlExp._\'23selFP2\'23s_1'(_34846536,_34846538,_34846540,_34846542):-freeze(_34846540,'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'(_34846536,_34846538,_34846540,_34846542)).
'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'([_34842372|_34842390],_34847320,_34847326,_34847332):-!,hnf(_34842372,_34849222,_34847326,_34849240),'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'(_34849222,_34842390,_34847320,_34849240,_34847332).

'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'(_34849766,_34849768,_34849770,_34849772,_34849774):-freeze(_34849772,'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'(_34849766,_34849768,_34849770,_34849772,_34849774)).
'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'('XML.XText'(_34842518),_34842390,_34850734,_34850740,_34850746):-!,hnf(_34842390,_34853328,_34850740,_34853346),'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'(_34853328,_34842518,_34850734,_34853346,_34850746).

'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'(_34853992,_34853994,_34853996,_34853998,_34854000):-freeze(_34853998,'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'(_34853992,_34853994,_34853996,_34853998,_34854000)).
'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'([],_34842518,_34854446,_34854452,_34854458):-!,hnf(_34842518,_34854446,_34854452,_34854458).
'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'([_34842726|_34842744],_34842518,_34855336,_34855342,_34855348):-!,hnf(reportFailure4PAKCS('XML.showXmlExp._\'23selFP2\'23s',[[_34842726|_34842744]]),_34855336,_34855342,_34855348).
'blocked_blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1_XML.XText_2'('FAIL'(_34857100),_34842518,'FAIL'(_34857100),_34857114,_34857114).
'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'('XML.XElem'(_34843356,_34843374,_34843392),_34842390,_34857462,_34857468,_34857474):-!,hnf(reportFailure4PAKCS('XML.showXmlExp._\'23selFP2\'23s',['XML.XElem'(_34843356,_34843374,_34843392)]),_34857462,_34857468,_34857474).
'blocked_blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1_[|]_1'('FAIL'(_34859342),_34842390,'FAIL'(_34859342),_34859356,_34859356).
'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'([],_34859578,_34859584,_34859590):-!,hnf(reportFailure4PAKCS('XML.showXmlExp._\'23selFP2\'23s',[[]]),_34859578,_34859584,_34859590).
'blocked_blocked_XML.showXmlExp._\'23selFP2\'23s_1'('FAIL'(_34860730),'FAIL'(_34860730),_34860744,_34860744).

'XML.xtab'(_34861228,_34861230,_34861232,_34861234):-freeze(_34861232,'blocked_XML.xtab'(_34861228,_34861230,_34861232,_34861234)).
'blocked_XML.xtab'(_34861314,_34861568,_34861574,_34861580):-hnf('Prelude.take'(_34861314,'Prelude.repeat'('^ ')),_34861568,_34861574,_34861580).

'XML.showXmlOpenTag'(_34863132,_34863134,_34863136,_34863138,_34863140,_34863142):-freeze(_34863140,'blocked_XML.showXmlOpenTag'(_34863132,_34863134,_34863136,_34863138,_34863140,_34863142)).
'blocked_XML.showXmlOpenTag'(_34863238,_34863256,_34863274,_34864578,_34864584,_34864590):-hnf('Prelude.++'([^<],'Prelude.++'(_34863238,'Prelude.apply'('Prelude.concat','Prelude.map'('Prelude..'(partcall(1,'Prelude.++',[['^ ']]),partcall(1,'XML.showXmlOpenTag.attr2string.93',[_34863274])),_34863256)))),_34864578,_34864584,_34864590).

'XML.showXmlOpenTag.attr2string.93'(_34869066,_34869068,_34869070,_34869072,_34869074):-freeze(_34869072,'blocked_XML.showXmlOpenTag.attr2string.93'(_34869066,_34869068,_34869070,_34869072,_34869074)).
'blocked_XML.showXmlOpenTag.attr2string.93'(_34869162,_34869180,_34870738,_34870744,_34870750):-hnf(_34869180,_34872312,_34870744,_34872330),'blocked_XML.showXmlOpenTag.attr2string.93_2'(_34872312,_34869162,_34870738,_34872330,_34870750).

'blocked_XML.showXmlOpenTag.attr2string.93_2'(_34872778,_34872780,_34872782,_34872784,_34872786):-freeze(_34872784,'blocked_blocked_XML.showXmlOpenTag.attr2string.93_2'(_34872778,_34872780,_34872782,_34872784,_34872786)).
'blocked_blocked_XML.showXmlOpenTag.attr2string.93_2'('Prelude.(,)'(_34869296,_34869314),_34869162,_34873158,_34873164,_34873170):-!,hnf('Prelude.++'(_34869296,'Prelude.++'([^=,'^"'],'Prelude.++'('Prelude.apply'(_34869162,_34869314),['^"']))),_34873158,_34873164,_34873170).
'blocked_blocked_XML.showXmlOpenTag.attr2string.93_2'('FAIL'(_34875734),_34869162,'FAIL'(_34875734),_34875748,_34875748):-nonvar(_34875734).

'XML.showXmlExps'(_34876510,_34876512,_34876514,_34876516,_34876518,_34876520):-freeze(_34876518,'blocked_XML.showXmlExps'(_34876510,_34876512,_34876514,_34876516,_34876518,_34876520)).
'blocked_XML.showXmlExps'(_34876616,_34876634,_34876652,_34877060,_34877066,_34877072):-hnf('Prelude.apply'('Prelude.concatMap'(partcall(1,'XML.showXmlExp',[_34876652,_34876616])),_34876634),_34877060,_34877066,_34877072).

'XML.isXText'(_34878904,_34878906,_34878908,_34878910):-freeze(_34878908,'blocked_XML.isXText'(_34878904,_34878906,_34878908,_34878910)).
'blocked_XML.isXText'(_34878990,_34879464,_34879470,_34879476):-hnf(_34878990,_34880238,_34879470,_34880250),'blocked_XML.isXText_1'(_34880238,_34879464,_34880250,_34879476).

'blocked_XML.isXText_1'(_34880558,_34880560,_34880562,_34880564):-freeze(_34880562,'blocked_blocked_XML.isXText_1'(_34880558,_34880560,_34880562,_34880564)).
'blocked_blocked_XML.isXText_1'('XML.XText'(_34879106),'Prelude.True',_34880916,_34880916).
'blocked_blocked_XML.isXText_1'('XML.XElem'(_34879230,_34879248,_34879266),'Prelude.False',_34881636,_34881636):-!.
'blocked_blocked_XML.isXText_1'('FAIL'(_34882212),'FAIL'(_34882212),_34882226,_34882226):-nonvar(_34882212).

'XML.xmlUnquoteSpecials'(_34883246,_34883248,_34883250,_34883252):-freeze(_34883250,'blocked_XML.xmlUnquoteSpecials'(_34883246,_34883248,_34883250,_34883252)).
'blocked_XML.xmlUnquoteSpecials'(_34883332,_34886428,_34886434,_34886440):-hnf(_34883332,_34887598,_34886434,_34887610),'blocked_XML.xmlUnquoteSpecials_1'(_34887598,_34886428,_34887610,_34886440).

'blocked_XML.xmlUnquoteSpecials_1'(_34887984,_34887986,_34887988,_34887990):-freeze(_34887988,'blocked_blocked_XML.xmlUnquoteSpecials_1'(_34887984,_34887986,_34887988,_34887990)).
'blocked_blocked_XML.xmlUnquoteSpecials_1'([],[],_34888232,_34888232).
'blocked_blocked_XML.xmlUnquoteSpecials_1'([_34883548|_34883566],_34891266,_34891272,_34891278):-!,makeShare(_34883548,_34889250),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_34889250,^&),_34893018,_34891272,_34892984),'blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'(_34893018,_34889250,_34883566,_34891266,_34892984,_34891278).

'blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'(_34893554,_34893556,_34893558,_34893560,_34893562,_34893564):-freeze(_34893562,freeze(_34893554,'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'(_34893554,_34893556,_34893558,_34893560,_34893562,_34893564))).
'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'('Prelude.True',_34889250,_34883566,_34893958,_34893964,_34893970):-makeShare(_34883858,_34894296),makeShare(_34883876,_34894316),makeShare(_34883894,_34894336),hnf('Prelude.cond'(letrec4PAKCS(_34894296,'XML.splitAtChar'('^;',_34883566)),'Prelude.cond'(letrec4PAKCS(_34894316,'XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_34894296)),'Prelude.cond'(letrec4PAKCS(_34894336,'XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_34894296)),'XML.xmlUnquoteSpecial'(_34894316,_34894336)))),_34893958,_34893964,_34893970).
'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'('Prelude.False',_34889250,_34883566,_34899986,_34899992,_34899998):-!,hnf('Prelude.otherwise',_34902918,_34899992,_34902884),'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_34902918,_34889250,_34883566,_34899986,_34902884,_34899998).

'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_34903646,_34903648,_34903650,_34903652,_34903654,_34903656):-freeze(_34903654,freeze(_34903646,'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_34903646,_34903648,_34903650,_34903652,_34903654,_34903656))).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34889250,_34883566,[_34889250|'XML.xmlUnquoteSpecials'(_34883566)],_34904056,_34904056).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34889250,_34883566,_34905656,_34905662,_34905668):-!,hnf(reportFailure4PAKCS('XML.xmlUnquoteSpecials',['Prelude.False']),_34905656,_34905662,_34905668).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_34907302),_34889250,_34883566,'FAIL'(_34907302),_34907316,_34907316).
'blocked_blocked_blocked_XML.xmlUnquoteSpecials_1_[|]_ComplexCase'('FAIL'(_34907384),_34889250,_34883566,'FAIL'(_34907384),_34907398,_34907398).
'blocked_blocked_XML.xmlUnquoteSpecials_1'('FAIL'(_34907466),'FAIL'(_34907466),_34907480,_34907480):-nonvar(_34907466).

'XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_34909202,_34909204,_34909206,_34909208):-freeze(_34909206,'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_34909202,_34909204,_34909206,_34909208)).
'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special'(_34909288,_34909792,_34909798,_34909804):-hnf(_34909288,_34911718,_34909798,_34911730),'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'(_34911718,_34909792,_34911730,_34909804).

'blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'(_34912230,_34912232,_34912234,_34912236):-freeze(_34912234,'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'(_34912230,_34912232,_34912234,_34912236)).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'('Prelude.(,)'(_34909404,_34909422),_34912600,_34912606,_34912612):-!,hnf(_34909404,_34912600,_34912606,_34912612).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP4\'23special_1'('FAIL'(_34913238),'FAIL'(_34913238),_34913252,_34913252):-nonvar(_34913238).

'XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_34914860,_34914862,_34914864,_34914866):-freeze(_34914864,'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_34914860,_34914862,_34914864,_34914866)).
'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest'(_34914946,_34915432,_34915438,_34915444):-hnf(_34914946,_34917250,_34915438,_34917262),'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'(_34917250,_34915432,_34917262,_34915444).

'blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'(_34917744,_34917746,_34917748,_34917750):-freeze(_34917748,'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'(_34917744,_34917746,_34917748,_34917750)).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'('Prelude.(,)'(_34915062,_34915080),_34918114,_34918120,_34918126):-!,hnf(_34915080,_34918114,_34918120,_34918126).
'blocked_blocked_XML.xmlUnquoteSpecials._\'23selFP5\'23rest_1'('FAIL'(_34918734),'FAIL'(_34918734),_34918748,_34918748):-nonvar(_34918734).

'XML.xmlUnquoteSpecial'(_34919730,_34919732,_34919734,_34919736,_34919738):-freeze(_34919736,'blocked_XML.xmlUnquoteSpecial'(_34919730,_34919732,_34919734,_34919736,_34919738)).
'blocked_XML.xmlUnquoteSpecial'(_34919826,_34919844,_34942700,_34942706,_34942712):-makeShare(_34919826,_34936582),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34936582,['^l','^t']),_34943944,_34942706,_34943910),'blocked_XML.xmlUnquoteSpecial_ComplexCase'(_34943944,_34936582,_34919844,_34942700,_34943910,_34942712).

'blocked_XML.xmlUnquoteSpecial_ComplexCase'(_34944372,_34944374,_34944376,_34944378,_34944380,_34944382):-freeze(_34944380,freeze(_34944372,'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'(_34944372,_34944374,_34944376,_34944378,_34944380,_34944382))).
'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'('Prelude.True',_34936582,_34919844,[^<|'XML.xmlUnquoteSpecials'(_34919844)],_34944782,_34944782).
'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'('Prelude.False',_34936582,_34919844,_34952864,_34952870,_34952876):-!,makeShare(_34936582,_34946924),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34946924,['^g','^t']),_34955256,_34952870,_34955222),'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'(_34955256,_34946924,_34919844,_34952864,_34955222,_34952876).

'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'(_34955906,_34955908,_34955910,_34955912,_34955914,_34955916):-freeze(_34955914,freeze(_34955906,'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'(_34955906,_34955908,_34955910,_34955912,_34955914,_34955916))).
'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34946924,_34919844,[^>|'XML.xmlUnquoteSpecials'(_34919844)],_34956316,_34956316).
'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34946924,_34919844,_34964620,_34964626,_34964632):-!,makeShare(_34946924,_34958600),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34958600,['^a','^m','^p']),_34968236,_34964626,_34968202),'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34968236,_34958600,_34919844,_34964620,_34968202,_34964632).

'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34969090,_34969092,_34969094,_34969096,_34969098,_34969100):-freeze(_34969098,freeze(_34969090,'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34969090,_34969092,_34969094,_34969096,_34969098,_34969100))).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34958600,_34919844,[^&|'XML.xmlUnquoteSpecials'(_34919844)],_34969500,_34969500).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34958600,_34919844,_34977998,_34978004,_34978010):-!,makeShare(_34958600,_34971922),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34971922,['^q','^u','^o','^t']),_34982838,_34978004,_34982804),'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34982838,_34971922,_34919844,_34977998,_34982804,_34978010).

'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34983896,_34983898,_34983900,_34983902,_34983904,_34983906):-freeze(_34983904,freeze(_34983896,'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34983896,_34983898,_34983900,_34983902,_34983904,_34983906))).
'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34971922,_34919844,['^"'|'XML.xmlUnquoteSpecials'(_34919844)],_34984306,_34984306).
'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34971922,_34919844,_34992796,_34992802,_34992808):-!,makeShare(_34971922,_34986862),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_34986862,['^a','^p','^o','^s']),_34998860,_34992802,_34998826),'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_34998860,_34986862,_34919844,_34992796,_34998826,_34992808).

'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35000122,_35000124,_35000126,_35000128,_35000130,_35000132):-freeze(_35000130,freeze(_35000122,'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35000122,_35000124,_35000126,_35000128,_35000130,_35000132))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_34986862,_34919844,['^\''|'XML.xmlUnquoteSpecials'(_34919844)],_35000532,_35000532).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_34986862,_34919844,_35009014,_35009020,_35009026):-!,makeShare(_34986862,_35003222),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35003222,['^a','^u','^m','^l']),_35016302,_35009020,_35016268),'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35016302,_35003222,_34919844,_35009014,_35016268,_35009026).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35017768,_35017770,_35017772,_35017774,_35017776,_35017778):-freeze(_35017776,freeze(_35017768,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35017768,_35017770,_35017772,_35017774,_35017776,_35017778))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35003222,_34919844,['^228'|'XML.xmlUnquoteSpecials'(_34919844)],_35018178,_35018178).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35003222,_34919844,_35026664,_35026670,_35026676):-!,makeShare(_35003222,_35021014),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35021014,['^o','^u','^m','^l']),_35035176,_35026670,_35035142),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35035176,_35021014,_34919844,_35026664,_35035142,_35026676).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35036846,_35036848,_35036850,_35036852,_35036854,_35036856):-freeze(_35036854,freeze(_35036846,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35036846,_35036848,_35036850,_35036852,_35036854,_35036856))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35021014,_34919844,['^246'|'XML.xmlUnquoteSpecials'(_34919844)],_35037256,_35037256).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35021014,_34919844,_35045734,_35045740,_35045746):-!,makeShare(_35021014,_35040226),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35040226,['^u','^u','^m','^l']),_35055470,_35045740,_35055436),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35055470,_35040226,_34919844,_35045734,_35055436,_35045746).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35057344,_35057346,_35057348,_35057350,_35057352,_35057354):-freeze(_35057352,freeze(_35057344,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35057344,_35057346,_35057348,_35057350,_35057352,_35057354))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35040226,_34919844,['^252'|'XML.xmlUnquoteSpecials'(_34919844)],_35057754,_35057754).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35040226,_34919844,_35066224,_35066230,_35066236):-!,makeShare(_35040226,_35060858),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35060858,['^A','^u','^m','^l']),_35077184,_35066230,_35077150),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35077184,_35060858,_34919844,_35066224,_35077150,_35066236).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35079262,_35079264,_35079266,_35079268,_35079270,_35079272):-freeze(_35079270,freeze(_35079262,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35079262,_35079264,_35079266,_35079268,_35079270,_35079272))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35060858,_34919844,['^196'|'XML.xmlUnquoteSpecials'(_34919844)],_35079672,_35079672).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35060858,_34919844,_35088134,_35088140,_35088146):-!,makeShare(_35060858,_35082910),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35082910,['^O','^u','^m','^l']),_35100318,_35088140,_35100284),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35100318,_35082910,_34919844,_35088134,_35100284,_35088146).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35102600,_35102602,_35102604,_35102606,_35102608,_35102610):-freeze(_35102608,freeze(_35102600,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35102600,_35102602,_35102604,_35102606,_35102608,_35102610))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35082910,_34919844,['^214'|'XML.xmlUnquoteSpecials'(_34919844)],_35103010,_35103010).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35082910,_34919844,_35111464,_35111470,_35111476):-!,makeShare(_35082910,_35106382),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35106382,['^U','^u','^m','^l']),_35124872,_35111470,_35124838),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35124872,_35106382,_34919844,_35111464,_35124838,_35111476).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35127358,_35127360,_35127362,_35127364,_35127366,_35127368):-freeze(_35127366,freeze(_35127358,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35127358,_35127360,_35127362,_35127364,_35127366,_35127368))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35106382,_34919844,['^220'|'XML.xmlUnquoteSpecials'(_34919844)],_35127768,_35127768).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35106382,_34919844,_35136388,_35136394,_35136400):-!,makeShare(_35106382,_35131274),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_35131274,['^s','^z','^l','^i','^g']),_35151020,_35136394,_35150986),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35151020,_35131274,_34919844,_35136388,_35150986,_35136400).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35153710,_35153712,_35153714,_35153716,_35153718,_35153720):-freeze(_35153718,freeze(_35153710,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35153710,_35153712,_35153714,_35153716,_35153718,_35153720))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35131274,_34919844,['^223'|'XML.xmlUnquoteSpecials'(_34919844)],_35154120,_35154120).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35131274,_34919844,_35160854,_35160860,_35160866):-!,hnf('Prelude.otherwise',_35176710,_35160860,_35176676),'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35176710,_35131274,_34919844,_35160854,_35176676,_35160866).

'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35179592,_35179594,_35179596,_35179598,_35179600,_35179602):-freeze(_35179600,freeze(_35179592,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35179592,_35179594,_35179596,_35179598,_35179600,_35179602))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35131274,_34919844,_35179996,_35180002,_35180008):-hnf('Prelude.++'('XML.unquoteUnicode'(_35131274),'XML.xmlUnquoteSpecials'(_34919844)),_35179996,_35180002,_35180008).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35131274,_34919844,_35184116,_35184122,_35184128):-!,hnf(reportFailure4PAKCS('XML.xmlUnquoteSpecial',['Prelude.False']),_35184116,_35184122,_35184128).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35187910),_35131274,_34919844,'FAIL'(_35187910),_35187924,_35187924).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35187992),_35131274,_34919844,'FAIL'(_35187992),_35188006,_35188006).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188074),_35106382,_34919844,'FAIL'(_35188074),_35188088,_35188088).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188156),_35082910,_34919844,'FAIL'(_35188156),_35188170,_35188170).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188238),_35060858,_34919844,'FAIL'(_35188238),_35188252,_35188252).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188320),_35040226,_34919844,'FAIL'(_35188320),_35188334,_35188334).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188402),_35021014,_34919844,'FAIL'(_35188402),_35188416,_35188416).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188484),_35003222,_34919844,'FAIL'(_35188484),_35188498,_35188498).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188566),_34986862,_34919844,'FAIL'(_35188566),_35188580,_35188580).
'blocked_blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188648),_34971922,_34919844,'FAIL'(_35188648),_35188662,_35188662).
'blocked_blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188730),_34958600,_34919844,'FAIL'(_35188730),_35188744,_35188744).
'blocked_blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35188812),_34946924,_34919844,'FAIL'(_35188812),_35188826,_35188826).
'blocked_blocked_XML.xmlUnquoteSpecial_ComplexCase'('FAIL'(_35188894),_34936582,_34919844,'FAIL'(_35188894),_35188908,_35188908).

'XML.unquoteUnicode'(_35189788,_35189790,_35189792,_35189794):-freeze(_35189792,'blocked_XML.unquoteUnicode'(_35189788,_35189790,_35189792,_35189794)).
'blocked_XML.unquoteUnicode'(_35189874,_35192492,_35192498,_35192504):-hnf(_35189874,_35193518,_35192498,_35193530),'blocked_XML.unquoteUnicode_1'(_35193518,_35192492,_35193530,_35192504).

'blocked_XML.unquoteUnicode_1'(_35193880,_35193882,_35193884,_35193886):-freeze(_35193884,'blocked_blocked_XML.unquoteUnicode_1'(_35193880,_35193882,_35193884,_35193886)).
'blocked_blocked_XML.unquoteUnicode_1'([],[],_35194128,_35194128).
'blocked_blocked_XML.unquoteUnicode_1'([_35190090|_35190108],_35196738,_35196744,_35196750):-!,makeShare(_35190090,_35194944),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35194944,^#),_35198346,_35196744,_35198312),'blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'(_35198346,_35194944,_35190108,_35196738,_35198312,_35196750).

'blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'(_35198858,_35198860,_35198862,_35198864,_35198866,_35198868):-freeze(_35198866,freeze(_35198858,'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'(_35198858,_35198860,_35198862,_35198864,_35198866,_35198868))).
'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'('Prelude.True',_35194944,_35190108,_35199262,_35199268,_35199274):-makeShare(_35190400,_35199472),makeShare(_35190108,_35199492),hnf('Prelude.cond'(letrec4PAKCS(_35199472,_35199492),'XML.unquoteUnicode._\'23caseor0'(_35199472,_35194944,_35199492,_35199472)),_35199262,_35199268,_35199274).
'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'('Prelude.False',_35194944,_35190108,_35202996,_35203002,_35203008):-!,hnf('Prelude.otherwise',_35205784,_35203002,_35205750),'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35205784,_35194944,_35190108,_35202996,_35205750,_35203008).

'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35206488,_35206490,_35206492,_35206494,_35206496,_35206498):-freeze(_35206496,freeze(_35206488,'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35206488,_35206490,_35206492,_35206494,_35206496,_35206498))).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35194944,_35190108,[^&|'Prelude.++'([_35194944|_35190108],['^;'])],_35206898,_35206898).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35194944,_35190108,_35208974,_35208980,_35208986):-!,hnf(reportFailure4PAKCS('XML.unquoteUnicode',['Prelude.False']),_35208974,_35208980,_35208986).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35210572),_35194944,_35190108,'FAIL'(_35210572),_35210586,_35210586).
'blocked_blocked_blocked_XML.unquoteUnicode_1_[|]_ComplexCase'('FAIL'(_35210654),_35194944,_35190108,'FAIL'(_35210654),_35210668,_35210668).
'blocked_blocked_XML.unquoteUnicode_1'('FAIL'(_35210736),'FAIL'(_35210736),_35210750,_35210750):-nonvar(_35210736).

'XML.unquoteUnicode.extr.117'(_35211960,_35211962,_35211964,_35211966,_35211968,_35211970):-freeze(_35211968,'blocked_XML.unquoteUnicode.extr.117'(_35211960,_35211962,_35211964,_35211966,_35211968,_35211970)).
'blocked_XML.unquoteUnicode.extr.117'(_35212066,_35212084,_35212102,_35231846,_35231852,_35231858):-hnf(_35212102,_35233212,_35231852,_35233236),'blocked_XML.unquoteUnicode.extr.117_3'(_35233212,_35212066,_35212084,_35231846,_35233236,_35231858).

'blocked_XML.unquoteUnicode.extr.117_3'(_35233662,_35233664,_35233666,_35233668,_35233670,_35233672):-freeze(_35233670,freeze(_35233662,'blocked_blocked_XML.unquoteUnicode.extr.117_3'(_35233662,_35233664,_35233666,_35233668,_35233670,_35233672))).
'blocked_blocked_XML.unquoteUnicode.extr.117_3'([_35212218|_35212236],_35212066,_35212084,_35234258,_35234264,_35234270):-hnf(_35212218,_35236104,_35234264,_35236134),'blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'(_35236104,_35212236,_35212066,_35212084,_35234258,_35236134,_35234270).

'blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'(_35236652,_35236654,_35236656,_35236658,_35236660,_35236662,_35236664):-freeze(_35236662,freeze(_35236652,'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'(_35236652,_35236654,_35236656,_35236658,_35236660,_35236662,_35236664))).
'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'('Prelude.(,)'(_35212364,_35212382),_35212236,_35212066,_35212084,_35237450,_35237456,_35237462):-!,hnf(_35212382,_35240048,_35237456,_35240084),'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'(_35240048,_35212364,_35212236,_35212066,_35212084,_35237450,_35240084,_35237462).

'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'(_35240760,_35240762,_35240764,_35240766,_35240768,_35240770,_35240772,_35240774):-freeze(_35240772,freeze(_35240760,'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'(_35240760,_35240762,_35240764,_35240766,_35240768,_35240770,_35240772,_35240774))).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'([],_35212364,_35212236,_35212066,_35212084,_35241572,_35241578,_35241584):-hnf(_35212236,_35244700,_35241578,_35244730),'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'(_35244700,_35212364,_35212066,_35212084,_35241572,_35244730,_35241584).

'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'(_35245458,_35245460,_35245462,_35245464,_35245466,_35245468,_35245470):-freeze(_35245468,freeze(_35245458,'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'(_35245458,_35245460,_35245462,_35245464,_35245466,_35245468,_35245470))).
'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'([],_35212364,_35212066,_35212084,_35245736,_35245742,_35245748):-hnf(_35212364,_35245736,_35245742,_35245748).
'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'([_35212694|_35212712],_35212364,_35212066,_35212084,_35246834,_35246840,_35246846):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^X','^M','^L',^.,'^u','^n','^q','^o','^t','^e','^U','^n','^i','^c','^o','^d','^e',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^s','^t','^r','^i','^n','^g','^ ','^\''],[_35212066|'Prelude.++'(_35212084,['^\''])])),_35246834,_35246840,_35246846).
'blocked_blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2_[]_2'('FAIL'(_35256448),_35212364,_35212066,_35212084,'FAIL'(_35256448),_35256462,_35256462).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'([_35219036|_35219054],_35212364,_35212236,_35212066,_35212084,_35256728,_35256734,_35256740):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^X','^M','^L',^.,'^u','^n','^q','^o','^t','^e','^U','^n','^i','^c','^o','^d','^e',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^s','^t','^r','^i','^n','^g','^ ','^\''],[_35212066|'Prelude.++'(_35212084,['^\''])])),_35256728,_35256734,_35256740).
'blocked_blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1_Prelude.(,)_2'('FAIL'(_35266338),_35212364,_35212236,_35212066,_35212084,'FAIL'(_35266338),_35266352,_35266352).
'blocked_blocked_blocked_XML.unquoteUnicode.extr.117_3_[|]_1'('FAIL'(_35266436),_35212236,_35212066,_35212084,'FAIL'(_35266436),_35266450,_35266450).
'blocked_blocked_XML.unquoteUnicode.extr.117_3'([],_35212066,_35212084,_35266688,_35266694,_35266700):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^X','^M','^L',^.,'^u','^n','^q','^o','^t','^e','^U','^n','^i','^c','^o','^d','^e',^:,'^ ','^i','^l','^l','^e','^g','^a','^l','^ ','^s','^t','^r','^i','^n','^g','^ ','^\''],[_35212066|'Prelude.++'(_35212084,['^\''])])),_35266688,_35266694,_35266700).
'blocked_blocked_XML.unquoteUnicode.extr.117_3'('FAIL'(_35275802),_35212066,_35212084,'FAIL'(_35275802),_35275816,_35275816).

'XML.readXmlFile'(_35276582,_35276584,_35276586,_35276588):-freeze(_35276586,'blocked_XML.readXmlFile'(_35276582,_35276584,_35276586,_35276588)).
'blocked_XML.readXmlFile'(_35276668,_35277174,_35277180,_35277186):-makeShare(_35276668,_35277268),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_35277268)),partcall(1,'XML.readXmlFile._\'23lambda4',[_35277268])),_35277174,_35277180,_35277186).

'XML.readXmlFile._\'23lambda4'(_35280250,_35280252,_35280254,_35280256,_35280258):-freeze(_35280256,'blocked_XML.readXmlFile._\'23lambda4'(_35280250,_35280252,_35280254,_35280256,_35280258)).
'blocked_XML.readXmlFile._\'23lambda4'(_35280346,_35280364,_35281446,_35281452,_35281458):-makeShare(_35280392,_35281742),makeShare(_35280410,_35281762),hnf('Prelude.cond'(letrec4PAKCS(_35281742,_35280364),'Prelude.cond'(letrec4PAKCS(_35281762,'XML.parseXmlString'(_35281742)),'XML.readXmlFile._\'23lambda4._\'23caseor0'('Prelude.null'(_35281762),_35281762,_35280346))),_35281446,_35281452,_35281458).

'XML.readUnsafeXmlFile'(_35285622,_35285624,_35285626,_35285628):-freeze(_35285626,'blocked_XML.readUnsafeXmlFile'(_35285622,_35285624,_35285626,_35285628)).
'blocked_XML.readUnsafeXmlFile'(_35285708,_35286480,_35286486,_35286492):-hnf('Prelude.catch'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','XML.readXmlFile'(_35285708)),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Just')),partcall(1,'XML.readUnsafeXmlFile._\'23lambda6',[])),_35286480,_35286486,_35286492).

'XML.readUnsafeXmlFile._\'23lambda6'(_35290524,_35290526,_35290528,_35290530):-freeze(_35290528,'blocked_XML.readUnsafeXmlFile._\'23lambda6'(_35290524,_35290526,_35290528,_35290530)).
'blocked_XML.readUnsafeXmlFile._\'23lambda6'(_35290610,_35290808,_35290814,_35290820):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Nothing'),_35290808,_35290814,_35290820).

'XML.showXmlFile'(_35292670,_35292672,_35292674,_35292676):-freeze(_35292674,'blocked_XML.showXmlFile'(_35292670,_35292672,_35292674,_35292676)).
'blocked_XML.showXmlFile'(_35292756,_35293360,_35293366,_35293372):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','XML.readXmlFile'(_35292756)),'Prelude..'(partcall(1,'Prelude.putStr',[]),partcall(1,'XML.showXmlDoc',[]))),_35293360,_35293366,_35293372).

'XML.readFileWithXmlDocs'(_35296314,_35296316,_35296318,_35296320):-freeze(_35296318,'blocked_XML.readFileWithXmlDocs'(_35296314,_35296316,_35296318,_35296320)).
'blocked_XML.readFileWithXmlDocs'(_35296400,_35297004,_35297010,_35297016):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_35296400)),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',partcall(1,'XML.parseXmlString',[]))),_35297004,_35297010,_35297016).

'XML.parseXmlString'(_35300086,_35300088,_35300090,_35300092):-freeze(_35300090,'blocked_XML.parseXmlString'(_35300086,_35300088,_35300090,_35300092)).
'blocked_XML.parseXmlString'(_35300172,_35300524,_35300530,_35300536):-hnf('Prelude.fst'('XML.parseXmlTokens'('XML.scanXmlString'(_35300172),'Prelude.Nothing')),_35300524,_35300530,_35300536).

'XML.parseXmlTokens'(_35302484,_35302486,_35302488,_35302490,_35302492):-freeze(_35302490,'blocked_XML.parseXmlTokens'(_35302484,_35302486,_35302488,_35302490,_35302492)).
'blocked_XML.parseXmlTokens'(_35302580,_35302598,_35327308,_35327314,_35327320):-hnf(_35302580,_35328342,_35327314,_35328360),'blocked_XML.parseXmlTokens_1'(_35328342,_35302598,_35327308,_35328360,_35327320).

'blocked_XML.parseXmlTokens_1'(_35328718,_35328720,_35328722,_35328724,_35328726):-freeze(_35328724,'blocked_blocked_XML.parseXmlTokens_1'(_35328718,_35328720,_35328722,_35328724,_35328726)).
'blocked_blocked_XML.parseXmlTokens_1'([],_35302598,_35329216,_35329222,_35329228):-hnf(_35302598,_35330700,_35329222,_35330712),'blocked_blocked_XML.parseXmlTokens_1_[]_1'(_35330700,_35329216,_35330712,_35329228).

'blocked_blocked_XML.parseXmlTokens_1_[]_1'(_35331140,_35331142,_35331144,_35331146):-freeze(_35331144,'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'(_35331140,_35331142,_35331144,_35331146)).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'('Prelude.Nothing','Prelude.(,)'([],[]),_35331560,_35331560).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'('Prelude.Just'(_35303080),_35332538,_35332544,_35332550):-!,hnf('Prelude.error'(['^X','^M','^L',^.,'^p','^a','^r','^s','^e','^X','^m','^l','^T','^o','^k','^e','^n','^s',^:,'^ ','^i','^n','^c','^o','^m','^p','^l','^e','^t','^e','^ ','^p','^a','^r','^s','^e']),_35332538,_35332544,_35332550).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[]_1'('FAIL'(_35340510),'FAIL'(_35340510),_35340524,_35340524):-nonvar(_35340510).
'blocked_blocked_XML.parseXmlTokens_1'([_35308838|_35308856],_35302598,_35341016,_35341022,_35341028):-!,hnf(_35308838,_35342530,_35341022,_35342554),'blocked_blocked_XML.parseXmlTokens_1_[|]_1'(_35342530,_35308856,_35302598,_35341016,_35342554,_35341028).

'blocked_blocked_XML.parseXmlTokens_1_[|]_1'(_35343022,_35343024,_35343026,_35343028,_35343030,_35343032):-freeze(_35343030,'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'(_35343022,_35343024,_35343026,_35343028,_35343030,_35343032)).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'('XML.XText'(_35308984),_35308856,_35302598,_35343394,_35343400,_35343406):-makeShare(_35309018,_35343896),makeShare(_35309036,_35343916),makeShare(_35309054,_35343936),hnf('Prelude.cond'(letrec4PAKCS(_35343896,'XML.parseXmlTokens'(_35308856,_35302598)),'Prelude.cond'(letrec4PAKCS(_35343916,'XML.parseXmlTokens._\'23selFP7\'23xexps'(_35343896)),'Prelude.cond'(letrec4PAKCS(_35343936,'XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_35343896)),'Prelude.(,)'(['XML.XText'('XML.xmlUnquoteSpecials'(_35308984))|_35343916],_35343936)))),_35343394,_35343400,_35343406).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'('XML.XElem'(_35310898,_35310916,_35310934),_35308856,_35302598,_35349370,_35349376,_35349382):-!,hnf(_35310898,_35351576,_35349376,_35351612),'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'(_35351576,_35310916,_35310934,_35308856,_35302598,_35349370,_35351612,_35349382).

'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'(_35352216,_35352218,_35352220,_35352222,_35352224,_35352226,_35352228,_35352230):-freeze(_35352228,'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'(_35352216,_35352218,_35352220,_35352222,_35352224,_35352226,_35352228,_35352230)).
'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'([_35311068|_35311086],_35310916,_35310934,_35308856,_35302598,_35363980,_35363986,_35363992):-makeShare(_35311068,_35357930),makeShare(_35311086,_35357950),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35357930,^<),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23Prelude.Char\'23','Prelude.head'(_35357950)),^/)),_35366868,_35363986,_35366810),'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'(_35366868,_35357930,_35357950,_35310916,_35310934,_35308856,_35302598,_35363980,_35366810,_35363992).

'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'(_35367586,_35367588,_35367590,_35367592,_35367594,_35367596,_35367598,_35367600,_35367602,_35367604):-freeze(_35367602,freeze(_35367586,'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'(_35367586,_35367588,_35367590,_35367592,_35367594,_35367596,_35367598,_35367600,_35367602,_35367604))).
'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'('Prelude.True',_35357930,_35357950,_35310916,_35310934,_35308856,_35302598,_35368030,_35368036,_35368042):-makeShare(_35311938,_35369392),makeShare(_35357950,_35369412),makeShare(_35311956,_35369432),makeShare(_35311974,_35369452),makeShare(_35311992,_35369472),makeShare(_35312010,_35369492),makeShare(_35312028,_35369512),hnf('Prelude.cond'(letrec4PAKCS(_35369392,'XML.parseXmlTokens'(_35308856,'Prelude.Just'(_35369412))),'Prelude.cond'(letrec4PAKCS(_35369432,'XML.parseXmlTokens._\'23selFP13\'23xexps1'(_35369392)),'Prelude.cond'(letrec4PAKCS(_35369452,'XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_35369392)),'Prelude.cond'(letrec4PAKCS(_35369472,'XML.parseXmlTokens'(_35369452,_35302598)),'Prelude.cond'(letrec4PAKCS(_35369492,'XML.parseXmlTokens._\'23selFP11\'23xexps'(_35369472)),'Prelude.cond'(letrec4PAKCS(_35369512,'XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_35369472)),'Prelude.(,)'(['XML.XElem'(_35369412,_35310916,_35369432)|_35369492],_35369512))))))),_35368030,_35368036,_35368042).
'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'('Prelude.False',_35357930,_35357950,_35310916,_35310934,_35308856,_35302598,_35385868,_35385874,_35385880):-!,makeShare(_35357930,_35381200),makeShare(_35357950,_35381220),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35381200,^<),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_35381220),^/)),_35389936,_35385874,_35389878),'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35389936,_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,_35385868,_35389878,_35385880).

'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35390876,_35390878,_35390880,_35390882,_35390884,_35390886,_35390888,_35390890,_35390892,_35390894):-freeze(_35390892,freeze(_35390876,'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35390876,_35390878,_35390880,_35390882,_35390884,_35390886,_35390888,_35390890,_35390892,_35390894))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,_35396122,_35396128,_35396134):-makeShare(_35381220,_35392156),makeShare(_35302598,_35392176),hnf('Prelude.maybe'('Prelude.False',partcall(1,'Prelude.flip',['Prelude.tail'(_35392156),partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),_35392176),_35401384,_35396128,_35401326),'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'(_35401384,_35381200,_35392156,_35310916,_35310934,_35308856,_35392176,_35396122,_35401326,_35396134).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'(_35402504,_35402506,_35402508,_35402510,_35402512,_35402514,_35402516,_35402518,_35402520,_35402522):-freeze(_35402520,freeze(_35402504,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'(_35402504,_35402506,_35402508,_35402510,_35402512,_35402514,_35402516,_35402518,_35402520,_35402522))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_35381200,_35392156,_35310916,_35310934,_35308856,_35392176,'Prelude.(,)'([],_35308856),_35402954,_35402954).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_35381200,_35392156,_35310916,_35310934,_35308856,_35392176,_35405038,_35405044,_35405050):-!,makeShare(_35316856,_35405754),makeShare(_35316874,_35405774),makeShare(_35316892,_35405794),hnf('Prelude.cond'(letrec4PAKCS(_35405754,'XML.parseXmlTokens'(_35308856,_35392176)),'Prelude.cond'(letrec4PAKCS(_35405774,'XML.parseXmlTokens._\'23selFP16\'23xexps'(_35405754)),'Prelude.cond'(letrec4PAKCS(_35405794,'XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_35405754)),'Prelude.(,)'(['XML.XElem'(_35392156,_35310916,_35310934)|_35405774],_35405794)))),_35405038,_35405044,_35405050).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_35411438),_35381200,_35392156,_35310916,_35310934,_35308856,_35392176,'FAIL'(_35411438),_35411452,_35411452).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,_35414682,_35414688,_35414694):-!,hnf('Prelude.otherwise',_35419974,_35414688,_35419916),'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35419974,_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,_35414682,_35419916,_35414694).

'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35421094,_35421096,_35421098,_35421100,_35421102,_35421104,_35421106,_35421108,_35421110,_35421112):-freeze(_35421110,freeze(_35421094,'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35421094,_35421096,_35421098,_35421100,_35421102,_35421104,_35421106,_35421108,_35421110,_35421112))).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,_35421538,_35421544,_35421550):-makeShare(_35318920,_35422366),makeShare(_35318938,_35422386),makeShare(_35318956,_35422406),hnf('Prelude.cond'(letrec4PAKCS(_35422366,'XML.parseXmlTokens'(_35308856,_35302598)),'Prelude.cond'(letrec4PAKCS(_35422386,'XML.parseXmlTokens._\'23selFP19\'23xexps'(_35422366)),'Prelude.cond'(letrec4PAKCS(_35422406,'XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_35422366)),'Prelude.(,)'(['XML.XElem'([_35381200|_35381220],_35310916,_35310934)|_35422386],_35422406)))),_35421538,_35421544,_35421550).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,_35428534,_35428540,_35428546):-!,hnf(reportFailure4PAKCS('XML.parseXmlTokens',['Prelude.False']),_35428534,_35428540,_35428546).
'blocked_blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35430836),_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,'FAIL'(_35430836),_35430850,_35430850).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35430950),_35381200,_35381220,_35310916,_35310934,_35308856,_35302598,'FAIL'(_35430950),_35430964,_35430964).
'blocked_blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1_[|]_ComplexCase'('FAIL'(_35431064),_35357930,_35357950,_35310916,_35310934,_35308856,_35302598,'FAIL'(_35431064),_35431078,_35431078).
'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'([],_35310916,_35310934,_35308856,_35302598,_35431340,_35431346,_35431352):-!,hnf('Prelude.error'(['^X','^M','^L',^.,'^p','^a','^r','^s','^e','^X','^m','^l','^T','^o','^k','^e','^n','^s',^:,'^ ','^i','^n','^c','^o','^m','^p','^l','^e','^t','^e','^ ','^p','^a','^r','^s','^e']),_35431340,_35431346,_35431352).
'blocked_blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1_XML.XElem_1'('FAIL'(_35439668),_35310916,_35310934,_35308856,_35302598,'FAIL'(_35439668),_35439682,_35439682):-nonvar(_35439668).
'blocked_blocked_blocked_XML.parseXmlTokens_1_[|]_1'('FAIL'(_35439770),_35308856,_35302598,'FAIL'(_35439770),_35439784,_35439784):-nonvar(_35439770).
'blocked_blocked_XML.parseXmlTokens_1'('FAIL'(_35439856),_35302598,'FAIL'(_35439856),_35439870,_35439870):-nonvar(_35439856).

'XML.parseXmlTokens._\'23selFP7\'23xexps'(_35441372,_35441374,_35441376,_35441378):-freeze(_35441376,'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps'(_35441372,_35441374,_35441376,_35441378)).
'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps'(_35441458,_35441926,_35441932,_35441938):-hnf(_35441458,_35443636,_35441932,_35443648),'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'(_35443636,_35441926,_35443648,_35441938).

'blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'(_35444112,_35444114,_35444116,_35444118):-freeze(_35444116,'blocked_blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'(_35444112,_35444114,_35444116,_35444118)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'('Prelude.(,)'(_35441574,_35441592),_35444482,_35444488,_35444494):-!,hnf(_35441574,_35444482,_35444488,_35444494).
'blocked_blocked_XML.parseXmlTokens._\'23selFP7\'23xexps_1'('FAIL'(_35445084),'FAIL'(_35445084),_35445098,_35445098):-nonvar(_35445084).

'XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_35446820,_35446822,_35446824,_35446826):-freeze(_35446824,'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_35446820,_35446822,_35446824,_35446826)).
'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens'(_35446906,_35447410,_35447416,_35447422):-hnf(_35446906,_35449336,_35447416,_35449348),'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'(_35449336,_35447410,_35449348,_35447422).

'blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'(_35449848,_35449850,_35449852,_35449854):-freeze(_35449852,'blocked_blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'(_35449848,_35449850,_35449852,_35449854)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'('Prelude.(,)'(_35447022,_35447040),_35450218,_35450224,_35450230):-!,hnf(_35447040,_35450218,_35450224,_35450230).
'blocked_blocked_XML.parseXmlTokens._\'23selFP8\'23rem_xtokens_1'('FAIL'(_35450856),'FAIL'(_35450856),_35450870,_35450870):-nonvar(_35450856).

'XML.parseXmlTokens._\'23selFP13\'23xexps1'(_35452440,_35452442,_35452444,_35452446):-freeze(_35452444,'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1'(_35452440,_35452442,_35452444,_35452446)).
'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1'(_35452526,_35453006,_35453012,_35453018):-hnf(_35452526,_35454788,_35453012,_35454800),'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'(_35454788,_35453006,_35454800,_35453018).

'blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'(_35455276,_35455278,_35455280,_35455282):-freeze(_35455280,'blocked_blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'(_35455276,_35455278,_35455280,_35455282)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'('Prelude.(,)'(_35452642,_35452660),_35455646,_35455652,_35455658):-!,hnf(_35452642,_35455646,_35455652,_35455658).
'blocked_blocked_XML.parseXmlTokens._\'23selFP13\'23xexps1_1'('FAIL'(_35456260),'FAIL'(_35456260),_35456274,_35456274):-nonvar(_35456260).

'XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_35457920,_35457922,_35457924,_35457926):-freeze(_35457924,'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_35457920,_35457922,_35457924,_35457926)).
'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1'(_35458006,_35458498,_35458504,_35458510):-hnf(_35458006,_35460352,_35458504,_35460364),'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'(_35460352,_35458498,_35460364,_35458510).

'blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'(_35460852,_35460854,_35460856,_35460858):-freeze(_35460856,'blocked_blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'(_35460852,_35460854,_35460856,_35460858)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'('Prelude.(,)'(_35458122,_35458140),_35461222,_35461228,_35461234):-!,hnf(_35458140,_35461222,_35461228,_35461234).
'blocked_blocked_XML.parseXmlTokens._\'23selFP14\'23xtokens1_1'('FAIL'(_35461848),'FAIL'(_35461848),_35461862,_35461862):-nonvar(_35461848).

'XML.parseXmlTokens._\'23selFP11\'23xexps'(_35463394,_35463396,_35463398,_35463400):-freeze(_35463398,'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps'(_35463394,_35463396,_35463398,_35463400)).
'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps'(_35463480,_35463954,_35463960,_35463966):-hnf(_35463480,_35465700,_35463960,_35465712),'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'(_35465700,_35463954,_35465712,_35463966).

'blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'(_35466182,_35466184,_35466186,_35466188):-freeze(_35466186,'blocked_blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'(_35466182,_35466184,_35466186,_35466188)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'('Prelude.(,)'(_35463596,_35463614),_35466552,_35466558,_35466564):-!,hnf(_35463596,_35466552,_35466558,_35466564).
'blocked_blocked_XML.parseXmlTokens._\'23selFP11\'23xexps_1'('FAIL'(_35467160),'FAIL'(_35467160),_35467174,_35467174):-nonvar(_35467160).

'XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_35468934,_35468936,_35468938,_35468940):-freeze(_35468938,'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_35468934,_35468936,_35468938,_35468940)).
'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens'(_35469020,_35469530,_35469536,_35469542):-hnf(_35469020,_35471492,_35469536,_35471504),'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'(_35471492,_35469530,_35471504,_35469542).

'blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'(_35472010,_35472012,_35472014,_35472016):-freeze(_35472014,'blocked_blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'(_35472010,_35472012,_35472014,_35472016)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'('Prelude.(,)'(_35469136,_35469154),_35472380,_35472386,_35472392):-!,hnf(_35469154,_35472380,_35472386,_35472392).
'blocked_blocked_XML.parseXmlTokens._\'23selFP12\'23rem_xtokens_1'('FAIL'(_35473024),'FAIL'(_35473024),_35473038,_35473038):-nonvar(_35473024).

'XML.parseXmlTokens._\'23selFP16\'23xexps'(_35474570,_35474572,_35474574,_35474576):-freeze(_35474574,'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps'(_35474570,_35474572,_35474574,_35474576)).
'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps'(_35474656,_35475130,_35475136,_35475142):-hnf(_35474656,_35476876,_35475136,_35476888),'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'(_35476876,_35475130,_35476888,_35475142).

'blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'(_35477358,_35477360,_35477362,_35477364):-freeze(_35477362,'blocked_blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'(_35477358,_35477360,_35477362,_35477364)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'('Prelude.(,)'(_35474772,_35474790),_35477728,_35477734,_35477740):-!,hnf(_35474772,_35477728,_35477734,_35477740).
'blocked_blocked_XML.parseXmlTokens._\'23selFP16\'23xexps_1'('FAIL'(_35478336),'FAIL'(_35478336),_35478350,_35478350):-nonvar(_35478336).

'XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_35480110,_35480112,_35480114,_35480116):-freeze(_35480114,'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_35480110,_35480112,_35480114,_35480116)).
'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens'(_35480196,_35480706,_35480712,_35480718):-hnf(_35480196,_35482668,_35480712,_35482680),'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'(_35482668,_35480706,_35482680,_35480718).

'blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'(_35483186,_35483188,_35483190,_35483192):-freeze(_35483190,'blocked_blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'(_35483186,_35483188,_35483190,_35483192)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'('Prelude.(,)'(_35480312,_35480330),_35483556,_35483562,_35483568):-!,hnf(_35480330,_35483556,_35483562,_35483568).
'blocked_blocked_XML.parseXmlTokens._\'23selFP17\'23rem_xtokens_1'('FAIL'(_35484200),'FAIL'(_35484200),_35484214,_35484214):-nonvar(_35484200).

'XML.parseXmlTokens._\'23selFP19\'23xexps'(_35485746,_35485748,_35485750,_35485752):-freeze(_35485750,'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps'(_35485746,_35485748,_35485750,_35485752)).
'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps'(_35485832,_35486306,_35486312,_35486318):-hnf(_35485832,_35488052,_35486312,_35488064),'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'(_35488052,_35486306,_35488064,_35486318).

'blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'(_35488534,_35488536,_35488538,_35488540):-freeze(_35488538,'blocked_blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'(_35488534,_35488536,_35488538,_35488540)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'('Prelude.(,)'(_35485948,_35485966),_35488904,_35488910,_35488916):-!,hnf(_35485948,_35488904,_35488910,_35488916).
'blocked_blocked_XML.parseXmlTokens._\'23selFP19\'23xexps_1'('FAIL'(_35489512),'FAIL'(_35489512),_35489526,_35489526):-nonvar(_35489512).

'XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_35491286,_35491288,_35491290,_35491292):-freeze(_35491290,'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_35491286,_35491288,_35491290,_35491292)).
'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens'(_35491372,_35491882,_35491888,_35491894):-hnf(_35491372,_35493844,_35491888,_35493856),'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'(_35493844,_35491882,_35493856,_35491894).

'blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'(_35494362,_35494364,_35494366,_35494368):-freeze(_35494366,'blocked_blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'(_35494362,_35494364,_35494366,_35494368)).
'blocked_blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'('Prelude.(,)'(_35491488,_35491506),_35494732,_35494738,_35494744):-!,hnf(_35491506,_35494732,_35494738,_35494744).
'blocked_blocked_XML.parseXmlTokens._\'23selFP20\'23rem_xtokens_1'('FAIL'(_35495376),'FAIL'(_35495376),_35495390,_35495390):-nonvar(_35495376).

'XML.scanXmlString'(_35496220,_35496222,_35496224,_35496226):-freeze(_35496224,'blocked_XML.scanXmlString'(_35496220,_35496222,_35496224,_35496226)).
'blocked_XML.scanXmlString'(_35496306,_35496574,_35496580,_35496586):-hnf('XML.scanXmlString.scanXml.169'('Prelude.apply'('XML.dropBlanks',_35496306)),_35496574,_35496580,_35496586).

'XML.scanXmlString.scanXml.169'(_35498806,_35498808,_35498810,_35498812):-freeze(_35498810,'blocked_XML.scanXmlString.scanXml.169'(_35498806,_35498808,_35498810,_35498812)).
'blocked_XML.scanXmlString.scanXml.169'(_35498892,_35501574,_35501580,_35501586):-hnf(_35498892,_35502996,_35501580,_35503008),'blocked_XML.scanXmlString.scanXml.169_1'(_35502996,_35501574,_35503008,_35501586).

'blocked_XML.scanXmlString.scanXml.169_1'(_35503424,_35503426,_35503428,_35503430):-freeze(_35503428,'blocked_blocked_XML.scanXmlString.scanXml.169_1'(_35503424,_35503426,_35503428,_35503430)).
'blocked_blocked_XML.scanXmlString.scanXml.169_1'([],[],_35503672,_35503672).
'blocked_blocked_XML.scanXmlString.scanXml.169_1'([_35499108|_35499126],_35506574,_35506580,_35506586):-!,makeShare(_35499108,_35504732),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35504732,^<),_35508578,_35506580,_35508544),'blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'(_35508578,_35504732,_35499126,_35506574,_35508544,_35506586).

'blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'(_35509156,_35509158,_35509160,_35509162,_35509164,_35509166):-freeze(_35509164,freeze(_35509156,'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'(_35509156,_35509158,_35509160,_35509162,_35509164,_35509166))).
'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'('Prelude.True',_35504732,_35499126,_35509560,_35509566,_35509572):-hnf('XML.scanXmlElem'(_35499126),_35509560,_35509566,_35509572).
'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'('Prelude.False',_35504732,_35499126,_35510766,_35510772,_35510778):-!,makeShare(_35499588,_35511194),makeShare(_35499606,_35511214),makeShare(_35499624,_35511234),hnf('Prelude.cond'(letrec4PAKCS(_35511194,'XML.scanXmlText'([_35504732|_35499126])),'Prelude.cond'(letrec4PAKCS(_35511214,'XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_35511194)),'Prelude.cond'(letrec4PAKCS(_35511234,'XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_35511194)),['XML.XText'(_35511214)|'XML.scanXmlString.scanXml.169'(_35511234)]))),_35510766,_35510772,_35510778).
'blocked_blocked_blocked_XML.scanXmlString.scanXml.169_1_[|]_ComplexCase'('FAIL'(_35516136),_35504732,_35499126,'FAIL'(_35516136),_35516150,_35516150).
'blocked_blocked_XML.scanXmlString.scanXml.169_1'('FAIL'(_35516218),'FAIL'(_35516218),_35516232,_35516232):-nonvar(_35516218).

'XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_35518220,_35518222,_35518224,_35518226):-freeze(_35518224,'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_35518220,_35518222,_35518224,_35518226)).
'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt'(_35518306,_35518852,_35518858,_35518864):-hnf(_35518306,_35521030,_35518858,_35521042),'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'(_35521030,_35518852,_35521042,_35518864).

'blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'(_35521584,_35521586,_35521588,_35521590):-freeze(_35521588,'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'(_35521584,_35521586,_35521588,_35521590)).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'('Prelude.(,)'(_35518422,_35518440),_35521954,_35521960,_35521966):-!,hnf(_35518422,_35521954,_35521960,_35521966).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP22\'23initxt_1'('FAIL'(_35522634),'FAIL'(_35522634),_35522648,_35522648):-nonvar(_35522634).

'XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_35524636,_35524638,_35524640,_35524642):-freeze(_35524640,'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_35524636,_35524638,_35524640,_35524642)).
'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag'(_35524722,_35525268,_35525274,_35525280):-hnf(_35524722,_35527446,_35525274,_35527458),'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'(_35527446,_35525268,_35527458,_35525280).

'blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'(_35528000,_35528002,_35528004,_35528006):-freeze(_35528004,'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'(_35528000,_35528002,_35528004,_35528006)).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'('Prelude.(,)'(_35524838,_35524856),_35528370,_35528376,_35528382):-!,hnf(_35524856,_35528370,_35528376,_35528382).
'blocked_blocked_XML.scanXmlString.scanXml.169._\'23selFP23\'23remtag_1'('FAIL'(_35529050),'FAIL'(_35529050),_35529064,_35529064):-nonvar(_35529050).

'XML.scanXmlText'(_35529818,_35529820,_35529822,_35529824):-freeze(_35529822,'blocked_XML.scanXmlText'(_35529818,_35529820,_35529822,_35529824)).
'blocked_XML.scanXmlText'(_35529904,_35535386,_35535392,_35535398):-hnf(_35529904,_35536304,_35535392,_35536316),'blocked_XML.scanXmlText_1'(_35536304,_35535386,_35536316,_35535398).

'blocked_XML.scanXmlText_1'(_35536648,_35536650,_35536652,_35536654):-freeze(_35536652,'blocked_blocked_XML.scanXmlText_1'(_35536648,_35536650,_35536652,_35536654)).
'blocked_blocked_XML.scanXmlText_1'([],'Prelude.(,)'([],[]),_35536896,_35536896).
'blocked_blocked_XML.scanXmlText_1'([_35530288|_35530306],_35541554,_35541560,_35541566):-!,makeShare(_35530288,_35538878),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35538878,^<),_35543054,_35541560,_35543020),'blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'(_35543054,_35538878,_35530306,_35541554,_35543020,_35541566).

'blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'(_35543548,_35543550,_35543552,_35543554,_35543556,_35543558):-freeze(_35543556,freeze(_35543548,'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'(_35543548,_35543550,_35543552,_35543554,_35543556,_35543558))).
'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'('Prelude.True',_35538878,_35530306,'Prelude.(,)'([],[_35538878|_35530306]),_35543958,_35543958).
'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'('Prelude.False',_35538878,_35530306,_35548738,_35548744,_35548750):-!,makeShare(_35538878,_35546476),hnf('Prelude.isSpace'(_35546476),_35551418,_35548744,_35551384),'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35551418,_35546476,_35530306,_35548738,_35551384,_35548750).

'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35552116,_35552118,_35552120,_35552122,_35552124,_35552126):-freeze(_35552124,freeze(_35552116,'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35552116,_35552118,_35552120,_35552122,_35552124,_35552126))).
'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35546476,_35530306,_35552520,_35552526,_35552532):-makeShare(_35531188,_35552902),makeShare(_35531206,_35552922),makeShare(_35531224,_35552942),hnf('Prelude.cond'(letrec4PAKCS(_35552902,'XML.scanXmlText'('Prelude.apply'('XML.dropBlanks',_35530306))),'Prelude.cond'(letrec4PAKCS(_35552922,'XML.scanXmlText._\'23selFP25\'23txt'(_35552902)),'Prelude.cond'(letrec4PAKCS(_35552942,'XML.scanXmlText._\'23selFP26\'23rem'(_35552902)),'Prelude.(,)'('XML.scanXmlText._\'23caseor0'('Prelude.null'(_35552922),_35552922),_35552942)))),_35552520,_35552526,_35552532).
'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35546476,_35530306,_35560248,_35560254,_35560260):-!,hnf('Prelude.otherwise',_35564152,_35560254,_35564118),'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35564152,_35546476,_35530306,_35560248,_35564118,_35560260).

'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35565042,_35565044,_35565046,_35565048,_35565050,_35565052):-freeze(_35565050,freeze(_35565042,'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35565042,_35565044,_35565046,_35565048,_35565050,_35565052))).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35546476,_35530306,_35565446,_35565452,_35565458):-makeShare(_35533204,_35565846),makeShare(_35533222,_35565866),makeShare(_35533240,_35565886),hnf('Prelude.cond'(letrec4PAKCS(_35565846,'XML.scanXmlText'(_35530306)),'Prelude.cond'(letrec4PAKCS(_35565866,'XML.scanXmlText._\'23selFP28\'23txt'(_35565846)),'Prelude.cond'(letrec4PAKCS(_35565886,'XML.scanXmlText._\'23selFP29\'23rem'(_35565846)),'Prelude.(,)'([_35546476|_35565866],_35565886)))),_35565446,_35565452,_35565458).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35546476,_35530306,_35570808,_35570814,_35570820):-!,hnf(reportFailure4PAKCS('XML.scanXmlText',['Prelude.False']),_35570808,_35570814,_35570820).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35572574),_35546476,_35530306,'FAIL'(_35572574),_35572588,_35572588).
'blocked_blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35572656),_35546476,_35530306,'FAIL'(_35572656),_35572670,_35572670).
'blocked_blocked_blocked_XML.scanXmlText_1_[|]_ComplexCase'('FAIL'(_35572738),_35538878,_35530306,'FAIL'(_35572738),_35572752,_35572752).
'blocked_blocked_XML.scanXmlText_1'('FAIL'(_35572820),'FAIL'(_35572820),_35572834,_35572834):-nonvar(_35572820).

'XML.scanXmlText._\'23selFP25\'23txt'(_35574176,_35574178,_35574180,_35574182):-freeze(_35574180,'blocked_XML.scanXmlText._\'23selFP25\'23txt'(_35574176,_35574178,_35574180,_35574182)).
'blocked_XML.scanXmlText._\'23selFP25\'23txt'(_35574262,_35574706,_35574712,_35574718):-hnf(_35574262,_35576272,_35574712,_35576284),'blocked_XML.scanXmlText._\'23selFP25\'23txt_1'(_35576272,_35574706,_35576284,_35574718).

'blocked_XML.scanXmlText._\'23selFP25\'23txt_1'(_35576724,_35576726,_35576728,_35576730):-freeze(_35576728,'blocked_blocked_XML.scanXmlText._\'23selFP25\'23txt_1'(_35576724,_35576726,_35576728,_35576730)).
'blocked_blocked_XML.scanXmlText._\'23selFP25\'23txt_1'('Prelude.(,)'(_35574378,_35574396),_35577094,_35577100,_35577106):-!,hnf(_35574378,_35577094,_35577100,_35577106).
'blocked_blocked_XML.scanXmlText._\'23selFP25\'23txt_1'('FAIL'(_35577672),'FAIL'(_35577672),_35577686,_35577686):-nonvar(_35577672).

'XML.scanXmlText._\'23selFP26\'23rem'(_35579028,_35579030,_35579032,_35579034):-freeze(_35579032,'blocked_XML.scanXmlText._\'23selFP26\'23rem'(_35579028,_35579030,_35579032,_35579034)).
'blocked_XML.scanXmlText._\'23selFP26\'23rem'(_35579114,_35579558,_35579564,_35579570):-hnf(_35579114,_35581124,_35579564,_35581136),'blocked_XML.scanXmlText._\'23selFP26\'23rem_1'(_35581124,_35579558,_35581136,_35579570).

'blocked_XML.scanXmlText._\'23selFP26\'23rem_1'(_35581576,_35581578,_35581580,_35581582):-freeze(_35581580,'blocked_blocked_XML.scanXmlText._\'23selFP26\'23rem_1'(_35581576,_35581578,_35581580,_35581582)).
'blocked_blocked_XML.scanXmlText._\'23selFP26\'23rem_1'('Prelude.(,)'(_35579230,_35579248),_35581946,_35581952,_35581958):-!,hnf(_35579248,_35581946,_35581952,_35581958).
'blocked_blocked_XML.scanXmlText._\'23selFP26\'23rem_1'('FAIL'(_35582524),'FAIL'(_35582524),_35582538,_35582538):-nonvar(_35582524).

'XML.scanXmlText._\'23selFP28\'23txt'(_35583880,_35583882,_35583884,_35583886):-freeze(_35583884,'blocked_XML.scanXmlText._\'23selFP28\'23txt'(_35583880,_35583882,_35583884,_35583886)).
'blocked_XML.scanXmlText._\'23selFP28\'23txt'(_35583966,_35584410,_35584416,_35584422):-hnf(_35583966,_35585976,_35584416,_35585988),'blocked_XML.scanXmlText._\'23selFP28\'23txt_1'(_35585976,_35584410,_35585988,_35584422).

'blocked_XML.scanXmlText._\'23selFP28\'23txt_1'(_35586428,_35586430,_35586432,_35586434):-freeze(_35586432,'blocked_blocked_XML.scanXmlText._\'23selFP28\'23txt_1'(_35586428,_35586430,_35586432,_35586434)).
'blocked_blocked_XML.scanXmlText._\'23selFP28\'23txt_1'('Prelude.(,)'(_35584082,_35584100),_35586798,_35586804,_35586810):-!,hnf(_35584082,_35586798,_35586804,_35586810).
'blocked_blocked_XML.scanXmlText._\'23selFP28\'23txt_1'('FAIL'(_35587376),'FAIL'(_35587376),_35587390,_35587390):-nonvar(_35587376).

'XML.scanXmlText._\'23selFP29\'23rem'(_35588732,_35588734,_35588736,_35588738):-freeze(_35588736,'blocked_XML.scanXmlText._\'23selFP29\'23rem'(_35588732,_35588734,_35588736,_35588738)).
'blocked_XML.scanXmlText._\'23selFP29\'23rem'(_35588818,_35589262,_35589268,_35589274):-hnf(_35588818,_35590828,_35589268,_35590840),'blocked_XML.scanXmlText._\'23selFP29\'23rem_1'(_35590828,_35589262,_35590840,_35589274).

'blocked_XML.scanXmlText._\'23selFP29\'23rem_1'(_35591280,_35591282,_35591284,_35591286):-freeze(_35591284,'blocked_blocked_XML.scanXmlText._\'23selFP29\'23rem_1'(_35591280,_35591282,_35591284,_35591286)).
'blocked_blocked_XML.scanXmlText._\'23selFP29\'23rem_1'('Prelude.(,)'(_35588934,_35588952),_35591650,_35591656,_35591662):-!,hnf(_35588952,_35591650,_35591656,_35591662).
'blocked_blocked_XML.scanXmlText._\'23selFP29\'23rem_1'('FAIL'(_35592228),'FAIL'(_35592228),_35592242,_35592242):-nonvar(_35592228).

'XML.scanXmlElem'(_35592996,_35592998,_35593000,_35593002):-freeze(_35593000,'blocked_XML.scanXmlElem'(_35592996,_35592998,_35593000,_35593002)).
'blocked_XML.scanXmlElem'(_35593082,_35596392,_35596398,_35596404):-hnf(_35593082,_35597310,_35596398,_35597322),'blocked_XML.scanXmlElem_1'(_35597310,_35596392,_35597322,_35596404).

'blocked_XML.scanXmlElem_1'(_35597654,_35597656,_35597658,_35597660):-freeze(_35597658,'blocked_blocked_XML.scanXmlElem_1'(_35597654,_35597656,_35597658,_35597660)).
'blocked_blocked_XML.scanXmlElem_1'([],[],_35597902,_35597902).
'blocked_blocked_XML.scanXmlElem_1'([_35593298|_35593316],_35600758,_35600764,_35600770):-!,makeShare(_35593298,_35598660),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35598660,'^!'),_35602258,_35600764,_35602224),'blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'(_35602258,_35598660,_35593316,_35600758,_35602224,_35600770).

'blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'(_35602752,_35602754,_35602756,_35602758,_35602760,_35602762):-freeze(_35602760,freeze(_35602752,'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'(_35602752,_35602754,_35602756,_35602758,_35602760,_35602762))).
'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'('Prelude.True',_35598660,_35593316,_35605766,_35605772,_35605778):-makeShare(_35593316,_35603252),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),'Prelude.take'(2,_35603252),[^-,^-]),_35608416,_35605772,_35608382),'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'(_35608416,_35598660,_35603252,_35605766,_35608382,_35605778).

'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'(_35609090,_35609092,_35609094,_35609096,_35609098,_35609100):-freeze(_35609098,freeze(_35609090,'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'(_35609090,_35609092,_35609094,_35609096,_35609098,_35609100))).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'('Prelude.True',_35598660,_35603252,_35609494,_35609500,_35609506):-hnf('XML.scanXmlComment'('Prelude.drop'(2,_35603252)),_35609494,_35609500,_35609506).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'('Prelude.False',_35598660,_35603252,_35611094,_35611100,_35611106):-!,hnf('XML.scanXmlCData'(_35603252),_35611094,_35611100,_35611106).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.True_ComplexCase'('FAIL'(_35612128),_35598660,_35603252,'FAIL'(_35612128),_35612142,_35612142).
'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'('Prelude.False',_35598660,_35593316,_35614366,_35614372,_35614378):-!,makeShare(_35598660,_35612654),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35612654,^?),_35617046,_35614372,_35617012),'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35617046,_35612654,_35593316,_35614366,_35617012,_35614378).

'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35617744,_35617746,_35617748,_35617750,_35617752,_35617754):-freeze(_35617752,freeze(_35617744,'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35617744,_35617746,_35617748,_35617750,_35617752,_35617754))).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35612654,_35593316,_35618148,_35618154,_35618160):-hnf('XML.scanXmlProcInstr'(_35593316),_35618148,_35618154,_35618160).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35612654,_35593316,_35620696,_35620702,_35620708):-!,hnf('Prelude.otherwise',_35624600,_35620702,_35624566),'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35624600,_35612654,_35593316,_35620696,_35624566,_35620708).

'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35625490,_35625492,_35625494,_35625496,_35625498,_35625500):-freeze(_35625498,freeze(_35625490,'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35625490,_35625492,_35625494,_35625496,_35625498,_35625500))).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35612654,_35593316,_35625894,_35625900,_35625906):-hnf('XML.scanXmlElemName'([_35612654],_35593316),_35625894,_35625900,_35625906).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35612654,_35593316,_35627766,_35627772,_35627778):-!,hnf(reportFailure4PAKCS('XML.scanXmlElem',['Prelude.False']),_35627766,_35627772,_35627778).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35629532),_35612654,_35593316,'FAIL'(_35629532),_35629546,_35629546).
'blocked_blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35629614),_35612654,_35593316,'FAIL'(_35629614),_35629628,_35629628).
'blocked_blocked_blocked_XML.scanXmlElem_1_[|]_ComplexCase'('FAIL'(_35629696),_35598660,_35593316,'FAIL'(_35629696),_35629710,_35629710).
'blocked_blocked_XML.scanXmlElem_1'('FAIL'(_35629778),'FAIL'(_35629778),_35629792,_35629792):-nonvar(_35629778).

'XML.scanXmlElemName'(_35630698,_35630700,_35630702,_35630704,_35630706):-freeze(_35630704,'blocked_XML.scanXmlElemName'(_35630698,_35630700,_35630702,_35630704,_35630706)).
'blocked_XML.scanXmlElemName'(_35630794,_35630812,_35637400,_35637406,_35637412):-hnf(_35630812,_35638470,_35637406,_35638488),'blocked_XML.scanXmlElemName_2'(_35638470,_35630794,_35637400,_35638488,_35637412).

'blocked_XML.scanXmlElemName_2'(_35638852,_35638854,_35638856,_35638858,_35638860):-freeze(_35638858,'blocked_blocked_XML.scanXmlElemName_2'(_35638852,_35638854,_35638856,_35638858,_35638860)).
'blocked_blocked_XML.scanXmlElemName_2'([],_35630794,['XML.XElem'([^<|_35630794],[],[])],_35639110,_35639110).
'blocked_blocked_XML.scanXmlElemName_2'([_35631588|_35631606],_35630794,_35644272,_35644278,_35644284):-!,makeShare(_35631588,_35641456),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35641456,^>),_35645930,_35644278,_35645890),'blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'(_35645930,_35641456,_35631606,_35630794,_35644272,_35645890,_35644284).

'blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'(_35646450,_35646452,_35646454,_35646456,_35646458,_35646460,_35646462):-freeze(_35646460,freeze(_35646450,'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'(_35646450,_35646452,_35646454,_35646456,_35646458,_35646460,_35646462))).
'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'('Prelude.True',_35641456,_35631606,_35630794,['XML.XElem'([^<|_35630794],[],[])|'XML.scanXmlString'(_35631606)],_35646870,_35646870).
'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'('Prelude.False',_35641456,_35631606,_35630794,_35652104,_35652110,_35652116):-!,makeShare(_35641456,_35649754),hnf('Prelude.isSpace'(_35649754),_35654942,_35652110,_35654902),'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'(_35654942,_35649754,_35631606,_35630794,_35652104,_35654902,_35652116).

'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'(_35655666,_35655668,_35655670,_35655672,_35655674,_35655676,_35655678):-freeze(_35655676,freeze(_35655666,'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'(_35655666,_35655668,_35655670,_35655672,_35655674,_35655676,_35655678))).
'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35649754,_35631606,_35630794,_35656080,_35656086,_35656092):-makeShare(_35632810,_35656546),makeShare(_35632828,_35656566),makeShare(_35632846,_35656586),hnf('Prelude.cond'(letrec4PAKCS(_35656546,'XML.parseAttrs'('Prelude.apply'('XML.dropBlanks',_35631606))),'Prelude.cond'(letrec4PAKCS(_35656566,'XML.scanXmlElemName._\'23selFP31\'23attrs'(_35656546)),'Prelude.cond'(letrec4PAKCS(_35656586,'XML.scanXmlElemName._\'23selFP32\'23rest'(_35656546)),'XML.scanXmlElemName._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_35656586),^/),_35630794,_35656566,_35656586)))),_35656080,_35656086,_35656092).
'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35649754,_35631606,_35630794,_35666248,_35666254,_35666260):-!,makeShare(_35649754,_35662902),makeShare(_35631606,_35662922),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35662902,^/),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_35662922),^>)),_35670310,_35666254,_35670270),'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35670310,_35662902,_35662922,_35630794,_35666248,_35670270,_35666260).

'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35671250,_35671252,_35671254,_35671256,_35671258,_35671260,_35671262):-freeze(_35671260,freeze(_35671250,'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35671250,_35671252,_35671254,_35671256,_35671258,_35671260,_35671262))).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35662902,_35662922,_35630794,['XML.XElem'(_35630794,[],[])|'XML.scanXmlString'('Prelude.tail'(_35662922))],_35671670,_35671670).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35662902,_35662922,_35630794,_35675604,_35675610,_35675616):-!,hnf('Prelude.otherwise',_35680890,_35675610,_35680850),'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35680890,_35662902,_35662922,_35630794,_35675604,_35680850,_35675616).

'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35682010,_35682012,_35682014,_35682016,_35682018,_35682020,_35682022):-freeze(_35682020,freeze(_35682010,'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35682010,_35682012,_35682014,_35682016,_35682018,_35682020,_35682022))).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35662902,_35662922,_35630794,_35682424,_35682430,_35682436):-hnf('XML.scanXmlElemName'('Prelude.++'(_35630794,[_35662902]),_35662922),_35682424,_35682430,_35682436).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35662902,_35662922,_35630794,_35684948,_35684954,_35684960):-!,hnf(reportFailure4PAKCS('XML.scanXmlElemName',['Prelude.False']),_35684948,_35684954,_35684960).
'blocked_blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35687040),_35662902,_35662922,_35630794,'FAIL'(_35687040),_35687054,_35687054).
'blocked_blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35687130),_35662902,_35662922,_35630794,'FAIL'(_35687130),_35687144,_35687144).
'blocked_blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35687220),_35649754,_35631606,_35630794,'FAIL'(_35687220),_35687234,_35687234).
'blocked_blocked_blocked_XML.scanXmlElemName_2_[|]_ComplexCase'('FAIL'(_35687310),_35641456,_35631606,_35630794,'FAIL'(_35687310),_35687324,_35687324).
'blocked_blocked_XML.scanXmlElemName_2'('FAIL'(_35687400),_35630794,'FAIL'(_35687400),_35687414,_35687414):-nonvar(_35687400).

'XML.scanXmlElemName._\'23selFP31\'23attrs'(_35688992,_35688994,_35688996,_35688998):-freeze(_35688996,'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs'(_35688992,_35688994,_35688996,_35688998)).
'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs'(_35689078,_35689558,_35689564,_35689570):-hnf(_35689078,_35691340,_35689564,_35691352),'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'(_35691340,_35689558,_35691352,_35689570).

'blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'(_35691828,_35691830,_35691832,_35691834):-freeze(_35691832,'blocked_blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'(_35691828,_35691830,_35691832,_35691834)).
'blocked_blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'('Prelude.(,)'(_35689194,_35689212),_35692198,_35692204,_35692210):-!,hnf(_35689194,_35692198,_35692204,_35692210).
'blocked_blocked_XML.scanXmlElemName._\'23selFP31\'23attrs_1'('FAIL'(_35692812),'FAIL'(_35692812),_35692826,_35692826):-nonvar(_35692812).

'XML.scanXmlElemName._\'23selFP32\'23rest'(_35694358,_35694360,_35694362,_35694364):-freeze(_35694362,'blocked_XML.scanXmlElemName._\'23selFP32\'23rest'(_35694358,_35694360,_35694362,_35694364)).
'blocked_XML.scanXmlElemName._\'23selFP32\'23rest'(_35694444,_35694918,_35694924,_35694930):-hnf(_35694444,_35696664,_35694924,_35696676),'blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'(_35696664,_35694918,_35696676,_35694930).

'blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'(_35697146,_35697148,_35697150,_35697152):-freeze(_35697150,'blocked_blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'(_35697146,_35697148,_35697150,_35697152)).
'blocked_blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'('Prelude.(,)'(_35694560,_35694578),_35697516,_35697522,_35697528):-!,hnf(_35694578,_35697516,_35697522,_35697528).
'blocked_blocked_XML.scanXmlElemName._\'23selFP32\'23rest_1'('FAIL'(_35698124),'FAIL'(_35698124),_35698138,_35698138):-nonvar(_35698124).

'XML.scanXmlComment'(_35699006,_35699008,_35699010,_35699012):-freeze(_35699010,'blocked_XML.scanXmlComment'(_35699006,_35699008,_35699010,_35699012)).
'blocked_XML.scanXmlComment'(_35699092,_35701080,_35701086,_35701092):-hnf(_35699092,_35702106,_35701086,_35702118),'blocked_XML.scanXmlComment_1'(_35702106,_35701080,_35702118,_35701092).

'blocked_XML.scanXmlComment_1'(_35702468,_35702470,_35702472,_35702474):-freeze(_35702472,'blocked_blocked_XML.scanXmlComment_1'(_35702468,_35702470,_35702472,_35702474)).
'blocked_blocked_XML.scanXmlComment_1'([],[],_35702716,_35702716).
'blocked_blocked_XML.scanXmlComment_1'([_35699308|_35699326],_35706608,_35706614,_35706620):-!,makeShare(_35699326,_35703390),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35699308,^-),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),'Prelude.take'(2,_35703390),[^-,^>])),_35708216,_35706614,_35708182),'blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'(_35708216,_35699308,_35703390,_35706608,_35708182,_35706620).

'blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'(_35708728,_35708730,_35708732,_35708734,_35708736,_35708738):-freeze(_35708736,freeze(_35708728,'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'(_35708728,_35708730,_35708732,_35708734,_35708736,_35708738))).
'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'('Prelude.True',_35699308,_35703390,_35709132,_35709138,_35709144):-hnf('XML.scanXmlString'('Prelude.drop'(2,_35703390)),_35709132,_35709138,_35709144).
'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'('Prelude.False',_35699308,_35703390,_35710546,_35710552,_35710558):-!,hnf('XML.scanXmlComment'(_35703390),_35710546,_35710552,_35710558).
'blocked_blocked_blocked_XML.scanXmlComment_1_[|]_ComplexCase'('FAIL'(_35711412),_35699308,_35703390,'FAIL'(_35711412),_35711426,_35711426).
'blocked_blocked_XML.scanXmlComment_1'('FAIL'(_35711494),'FAIL'(_35711494),_35711508,_35711508):-nonvar(_35711494).

'XML.scanXmlCData'(_35712300,_35712302,_35712304,_35712306):-freeze(_35712304,'blocked_XML.scanXmlCData'(_35712300,_35712302,_35712304,_35712306)).
'blocked_XML.scanXmlCData'(_35712386,_35713220,_35713226,_35713232):-makeShare(_35712414,_35713358),hnf('Prelude.cond'(letrec4PAKCS(_35713358,'XML.dropCData'(_35712386)),'XML.scanXmlCData._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_35713358),^>),_35713358)),_35713220,_35713226,_35713232).

'XML.dropCData'(_35716324,_35716326,_35716328,_35716330):-freeze(_35716328,'blocked_XML.dropCData'(_35716324,_35716326,_35716328,_35716330)).
'blocked_XML.dropCData'(_35716410,_35718720,_35718726,_35718732):-hnf(_35716410,_35719566,_35718726,_35719578),'blocked_XML.dropCData_1'(_35719566,_35718720,_35719578,_35718732).

'blocked_XML.dropCData_1'(_35719898,_35719900,_35719902,_35719904):-freeze(_35719902,'blocked_blocked_XML.dropCData_1'(_35719898,_35719900,_35719902,_35719904)).
'blocked_blocked_XML.dropCData_1'([],[],_35720146,_35720146).
'blocked_blocked_XML.dropCData_1'([_35716626|_35716644],_35722606,_35722612,_35722618):-!,makeShare(_35716626,_35720818),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35720818,'^['),_35724034,_35722612,_35724000),'blocked_blocked_XML.dropCData_1_[|]_ComplexCase'(_35724034,_35720818,_35716644,_35722606,_35724000,_35722618).

'blocked_blocked_XML.dropCData_1_[|]_ComplexCase'(_35724516,_35724518,_35724520,_35724522,_35724524,_35724526):-freeze(_35724524,freeze(_35724516,'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'(_35724516,_35724518,_35724520,_35724522,_35724524,_35724526))).
'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'('Prelude.True',_35720818,_35716644,_35724920,_35724926,_35724932):-hnf('Prelude.tail'('Prelude.dropWhile'(partcall(1,'Prelude.flip',['^]','Prelude._impl\'23\'2F\'3D\'23Prelude.Eq\'23Prelude.Char\'23']),_35716644)),_35724920,_35724926,_35724932).
'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'('Prelude.False',_35720818,_35716644,_35728740,_35728746,_35728752):-!,makeShare(_35720818,_35727068),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35727068,^>),_35731348,_35728746,_35731314),'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35731348,_35727068,_35716644,_35728740,_35731314,_35728752).

'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35732034,_35732036,_35732038,_35732040,_35732042,_35732044):-freeze(_35732042,freeze(_35732034,'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35732034,_35732036,_35732038,_35732040,_35732042,_35732044))).
'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35727068,_35716644,[_35727068|_35716644],_35732444,_35732444).
'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35727068,_35716644,_35734860,_35734866,_35734872):-!,hnf('Prelude.otherwise',_35738692,_35734866,_35738658),'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35738692,_35727068,_35716644,_35734860,_35738658,_35734872).

'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35739570,_35739572,_35739574,_35739576,_35739578,_35739580):-freeze(_35739578,freeze(_35739570,'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_35739570,_35739572,_35739574,_35739576,_35739578,_35739580))).
'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35727068,_35716644,_35739974,_35739980,_35739986):-hnf('XML.dropCData'(_35716644),_35739974,_35739980,_35739986).
'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35727068,_35716644,_35741480,_35741486,_35741492):-!,hnf(reportFailure4PAKCS('XML.dropCData',['Prelude.False']),_35741480,_35741486,_35741492).
'blocked_blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35743222),_35727068,_35716644,'FAIL'(_35743222),_35743236,_35743236).
'blocked_blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35743304),_35727068,_35716644,'FAIL'(_35743304),_35743318,_35743318).
'blocked_blocked_blocked_XML.dropCData_1_[|]_ComplexCase'('FAIL'(_35743386),_35720818,_35716644,'FAIL'(_35743386),_35743400,_35743400).
'blocked_blocked_XML.dropCData_1'('FAIL'(_35743468),'FAIL'(_35743468),_35743482,_35743482):-nonvar(_35743468).

'XML.scanXmlProcInstr'(_35744426,_35744428,_35744430,_35744432):-freeze(_35744430,'blocked_XML.scanXmlProcInstr'(_35744426,_35744428,_35744430,_35744432)).
'blocked_XML.scanXmlProcInstr'(_35744512,_35745966,_35745972,_35745978):-hnf(_35744512,_35747064,_35745972,_35747076),'blocked_XML.scanXmlProcInstr_1'(_35747064,_35745966,_35747076,_35745978).

'blocked_XML.scanXmlProcInstr_1'(_35747438,_35747440,_35747442,_35747444):-freeze(_35747442,'blocked_blocked_XML.scanXmlProcInstr_1'(_35747438,_35747440,_35747442,_35747444)).
'blocked_blocked_XML.scanXmlProcInstr_1'([],[],_35747686,_35747686).
'blocked_blocked_XML.scanXmlProcInstr_1'([_35744728|_35744746],_35750708,_35750714,_35750720):-!,makeShare(_35744746,_35748358),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35744728,^?),'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'('Prelude.head'(_35748358),^>)),_35752388,_35750714,_35752354),'blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'(_35752388,_35744728,_35748358,_35750708,_35752354,_35750720).

'blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'(_35752912,_35752914,_35752916,_35752918,_35752920,_35752922):-freeze(_35752920,freeze(_35752912,'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'(_35752912,_35752914,_35752916,_35752918,_35752920,_35752922))).
'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'('Prelude.True',_35744728,_35748358,_35753316,_35753322,_35753328):-hnf('XML.scanXmlString'('Prelude.tail'(_35748358)),_35753316,_35753322,_35753328).
'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'('Prelude.False',_35744728,_35748358,_35754662,_35754668,_35754674):-!,hnf('XML.scanXmlProcInstr'(_35748358),_35754662,_35754668,_35754674).
'blocked_blocked_blocked_XML.scanXmlProcInstr_1_[|]_ComplexCase'('FAIL'(_35755552),_35744728,_35748358,'FAIL'(_35755552),_35755566,_35755566).
'blocked_blocked_XML.scanXmlProcInstr_1'('FAIL'(_35755634),'FAIL'(_35755634),_35755648,_35755648):-nonvar(_35755634).

'XML.parseAttrs'(_35756364,_35756366,_35756368,_35756370):-freeze(_35756368,'blocked_XML.parseAttrs'(_35756364,_35756366,_35756368,_35756370)).
'blocked_XML.parseAttrs'(_35756450,_35763044,_35763050,_35763056):-hnf(_35756450,_35763926,_35763050,_35763938),'blocked_XML.parseAttrs_1'(_35763926,_35763044,_35763938,_35763056).

'blocked_XML.parseAttrs_1'(_35764264,_35764266,_35764268,_35764270):-freeze(_35764268,'blocked_blocked_XML.parseAttrs_1'(_35764264,_35764266,_35764268,_35764270)).
'blocked_blocked_XML.parseAttrs_1'([],'Prelude.(,)'([],[]),_35764512,_35764512).
'blocked_blocked_XML.parseAttrs_1'([_35756834|_35756852],_35769812,_35769818,_35769824):-!,makeShare(_35756834,_35767246),hnf('Prelude.isAlpha'(_35767246),_35771276,_35769818,_35771242),'blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'(_35771276,_35767246,_35756852,_35769812,_35771242,_35769824).

'blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'(_35771764,_35771766,_35771768,_35771770,_35771772,_35771774):-freeze(_35771772,freeze(_35771764,'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'(_35771764,_35771766,_35771768,_35771770,_35771772,_35771774))).
'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'('Prelude.True',_35767246,_35756852,_35772168,_35772174,_35772180):-makeShare(_35757074,_35774076),makeShare(_35757092,_35774096),makeShare(_35757110,_35774116),makeShare(_35757128,_35774136),makeShare(_35757146,_35774156),makeShare(_35757164,_35774176),makeShare(_35757182,_35774196),makeShare(_35757200,_35774216),makeShare(_35757218,_35774236),hnf('Prelude.cond'(letrec4PAKCS(_35774076,'XML.splitAtChar'(^=,[_35767246|_35756852])),'Prelude.cond'(letrec4PAKCS(_35774096,'XML.parseAttrs._\'23selFP40\'23name'(_35774076)),'Prelude.cond'(letrec4PAKCS(_35774116,'XML.parseAttrs._\'23selFP41\'23rest1'(_35774076)),'Prelude.cond'(letrec4PAKCS(_35774136,'XML.splitAtChar'('^"','Prelude.tail'(_35774116))),'Prelude.cond'(letrec4PAKCS(_35774156,'XML.parseAttrs._\'23selFP38\'23value'(_35774136)),'Prelude.cond'(letrec4PAKCS(_35774176,'XML.parseAttrs._\'23selFP39\'23rest2'(_35774136)),'Prelude.cond'(letrec4PAKCS(_35774196,'XML.parseAttrs'('Prelude.apply'('XML.dropBlanks',_35774176))),'Prelude.cond'(letrec4PAKCS(_35774216,'XML.parseAttrs._\'23selFP36\'23rem_attrs'(_35774196)),'Prelude.cond'(letrec4PAKCS(_35774236,'XML.parseAttrs._\'23selFP37\'23rem_inp'(_35774196)),'Prelude.(,)'(['Prelude.(,)'(_35774096,'XML.xmlUnquoteSpecials'(_35774156))|_35774216],_35774236)))))))))),_35772168,_35772174,_35772180).
'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'('Prelude.False',_35767246,_35756852,_35787594,_35787600,_35787606):-!,hnf('Prelude.otherwise',_35790238,_35787600,_35790204),'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35790238,_35767246,_35756852,_35787594,_35790204,_35787606).

'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35790918,_35790920,_35790922,_35790924,_35790926,_35790928):-freeze(_35790926,freeze(_35790918,'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'(_35790918,_35790920,_35790922,_35790924,_35790926,_35790928))).
'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_35767246,_35756852,'Prelude.(,)'([],[_35767246|_35756852]),_35791328,_35791328).
'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_35767246,_35756852,_35792904,_35792910,_35792916):-!,hnf(reportFailure4PAKCS('XML.parseAttrs',['Prelude.False']),_35792904,_35792910,_35792916).
'blocked_blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_35794454),_35767246,_35756852,'FAIL'(_35794454),_35794468,_35794468).
'blocked_blocked_blocked_XML.parseAttrs_1_[|]_ComplexCase'('FAIL'(_35794536),_35767246,_35756852,'FAIL'(_35794536),_35794550,_35794550).
'blocked_blocked_XML.parseAttrs_1'('FAIL'(_35794618),'FAIL'(_35794618),_35794632,_35794632):-nonvar(_35794618).

'XML.parseAttrs._\'23selFP40\'23name'(_35795974,_35795976,_35795978,_35795980):-freeze(_35795978,'blocked_XML.parseAttrs._\'23selFP40\'23name'(_35795974,_35795976,_35795978,_35795980)).
'blocked_XML.parseAttrs._\'23selFP40\'23name'(_35796060,_35796504,_35796510,_35796516):-hnf(_35796060,_35798070,_35796510,_35798082),'blocked_XML.parseAttrs._\'23selFP40\'23name_1'(_35798070,_35796504,_35798082,_35796516).

'blocked_XML.parseAttrs._\'23selFP40\'23name_1'(_35798522,_35798524,_35798526,_35798528):-freeze(_35798526,'blocked_blocked_XML.parseAttrs._\'23selFP40\'23name_1'(_35798522,_35798524,_35798526,_35798528)).
'blocked_blocked_XML.parseAttrs._\'23selFP40\'23name_1'('Prelude.(,)'(_35796176,_35796194),_35798892,_35798898,_35798904):-!,hnf(_35796176,_35798892,_35798898,_35798904).
'blocked_blocked_XML.parseAttrs._\'23selFP40\'23name_1'('FAIL'(_35799470),'FAIL'(_35799470),_35799484,_35799484):-nonvar(_35799470).

'XML.parseAttrs._\'23selFP41\'23rest1'(_35800864,_35800866,_35800868,_35800870):-freeze(_35800868,'blocked_XML.parseAttrs._\'23selFP41\'23rest1'(_35800864,_35800866,_35800868,_35800870)).
'blocked_XML.parseAttrs._\'23selFP41\'23rest1'(_35800950,_35801400,_35801406,_35801412):-hnf(_35800950,_35803002,_35801406,_35803014),'blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'(_35803002,_35801400,_35803014,_35801412).

'blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'(_35803460,_35803462,_35803464,_35803466):-freeze(_35803464,'blocked_blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'(_35803460,_35803462,_35803464,_35803466)).
'blocked_blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'('Prelude.(,)'(_35801066,_35801084),_35803830,_35803836,_35803842):-!,hnf(_35801084,_35803830,_35803836,_35803842).
'blocked_blocked_XML.parseAttrs._\'23selFP41\'23rest1_1'('FAIL'(_35804414),'FAIL'(_35804414),_35804428,_35804428):-nonvar(_35804414).

'XML.parseAttrs._\'23selFP38\'23value'(_35805808,_35805810,_35805812,_35805814):-freeze(_35805812,'blocked_XML.parseAttrs._\'23selFP38\'23value'(_35805808,_35805810,_35805812,_35805814)).
'blocked_XML.parseAttrs._\'23selFP38\'23value'(_35805894,_35806344,_35806350,_35806356):-hnf(_35805894,_35807946,_35806350,_35807958),'blocked_XML.parseAttrs._\'23selFP38\'23value_1'(_35807946,_35806344,_35807958,_35806356).

'blocked_XML.parseAttrs._\'23selFP38\'23value_1'(_35808404,_35808406,_35808408,_35808410):-freeze(_35808408,'blocked_blocked_XML.parseAttrs._\'23selFP38\'23value_1'(_35808404,_35808406,_35808408,_35808410)).
'blocked_blocked_XML.parseAttrs._\'23selFP38\'23value_1'('Prelude.(,)'(_35806010,_35806028),_35808774,_35808780,_35808786):-!,hnf(_35806010,_35808774,_35808780,_35808786).
'blocked_blocked_XML.parseAttrs._\'23selFP38\'23value_1'('FAIL'(_35809358),'FAIL'(_35809358),_35809372,_35809372):-nonvar(_35809358).

'XML.parseAttrs._\'23selFP39\'23rest2'(_35810752,_35810754,_35810756,_35810758):-freeze(_35810756,'blocked_XML.parseAttrs._\'23selFP39\'23rest2'(_35810752,_35810754,_35810756,_35810758)).
'blocked_XML.parseAttrs._\'23selFP39\'23rest2'(_35810838,_35811288,_35811294,_35811300):-hnf(_35810838,_35812890,_35811294,_35812902),'blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'(_35812890,_35811288,_35812902,_35811300).

'blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'(_35813348,_35813350,_35813352,_35813354):-freeze(_35813352,'blocked_blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'(_35813348,_35813350,_35813352,_35813354)).
'blocked_blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'('Prelude.(,)'(_35810954,_35810972),_35813718,_35813724,_35813730):-!,hnf(_35810972,_35813718,_35813724,_35813730).
'blocked_blocked_XML.parseAttrs._\'23selFP39\'23rest2_1'('FAIL'(_35814302),'FAIL'(_35814302),_35814316,_35814316):-nonvar(_35814302).

'XML.parseAttrs._\'23selFP36\'23rem_attrs'(_35815848,_35815850,_35815852,_35815854):-freeze(_35815852,'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs'(_35815848,_35815850,_35815852,_35815854)).
'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs'(_35815934,_35816408,_35816414,_35816420):-hnf(_35815934,_35818154,_35816414,_35818166),'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'(_35818154,_35816408,_35818166,_35816420).

'blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'(_35818636,_35818638,_35818640,_35818642):-freeze(_35818640,'blocked_blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'(_35818636,_35818638,_35818640,_35818642)).
'blocked_blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'('Prelude.(,)'(_35816050,_35816068),_35819006,_35819012,_35819018):-!,hnf(_35816050,_35819006,_35819012,_35819018).
'blocked_blocked_XML.parseAttrs._\'23selFP36\'23rem_attrs_1'('FAIL'(_35819614),'FAIL'(_35819614),_35819628,_35819628):-nonvar(_35819614).

'XML.parseAttrs._\'23selFP37\'23rem_inp'(_35821084,_35821086,_35821088,_35821090):-freeze(_35821088,'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp'(_35821084,_35821086,_35821088,_35821090)).
'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp'(_35821170,_35821632,_35821638,_35821644):-hnf(_35821170,_35823306,_35821638,_35823318),'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'(_35823306,_35821632,_35823318,_35821644).

'blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'(_35823776,_35823778,_35823780,_35823782):-freeze(_35823780,'blocked_blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'(_35823776,_35823778,_35823780,_35823782)).
'blocked_blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'('Prelude.(,)'(_35821286,_35821304),_35824146,_35824152,_35824158):-!,hnf(_35821304,_35824146,_35824152,_35824158).
'blocked_blocked_XML.parseAttrs._\'23selFP37\'23rem_inp_1'('FAIL'(_35824742),'FAIL'(_35824742),_35824756,_35824756):-nonvar(_35824742).

'XML.dropBlanks'(_35825472,_35825474,_35825476):-freeze(_35825474,'blocked_XML.dropBlanks'(_35825472,_35825474,_35825476)).
'blocked_XML.dropBlanks'(_35825644,_35825650,_35825656):-hnf(partcall(1,'Prelude.dropWhile',[partcall(1,'Prelude.isSpace',[])]),_35825644,_35825650,_35825656).

'XML.splitAtChar'(_35826916,_35826918,_35826920,_35826922,_35826924):-freeze(_35826922,'blocked_XML.splitAtChar'(_35826916,_35826918,_35826920,_35826922,_35826924)).
'blocked_XML.splitAtChar'(_35827012,_35827030,_35829790,_35829796,_35829802):-hnf(_35827030,_35830716,_35829796,_35830734),'blocked_XML.splitAtChar_2'(_35830716,_35827012,_35829790,_35830734,_35829802).

'blocked_XML.splitAtChar_2'(_35831074,_35831076,_35831078,_35831080,_35831082):-freeze(_35831080,'blocked_blocked_XML.splitAtChar_2'(_35831074,_35831076,_35831078,_35831080,_35831082)).
'blocked_blocked_XML.splitAtChar_2'([],_35827012,'Prelude.(,)'([],[]),_35831332,_35831332).
'blocked_blocked_XML.splitAtChar_2'([_35827414|_35827432],_35827012,_35834844,_35834850,_35834856):-!,makeShare(_35827414,_35832810),makeShare(_35827012,_35832830),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35832810,_35832830),_35836358,_35834850,_35836318),'blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'(_35836358,_35832810,_35827432,_35832830,_35834844,_35836318,_35834856).

'blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'(_35836866,_35836868,_35836870,_35836872,_35836874,_35836876,_35836878):-freeze(_35836876,freeze(_35836866,'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'(_35836866,_35836868,_35836870,_35836872,_35836874,_35836876,_35836878))).
'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'('Prelude.True',_35832810,_35827432,_35832830,'Prelude.(,)'([],_35827432),_35837286,_35837286).
'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'('Prelude.False',_35832810,_35827432,_35832830,_35838524,_35838530,_35838536):-!,makeShare(_35827978,_35839030),makeShare(_35827996,_35839050),makeShare(_35828014,_35839070),hnf('Prelude.cond'(letrec4PAKCS(_35839030,'XML.splitAtChar'(_35832830,_35827432)),'Prelude.cond'(letrec4PAKCS(_35839050,'XML.splitAtChar._\'23selFP43\'23first'(_35839030)),'Prelude.cond'(letrec4PAKCS(_35839070,'XML.splitAtChar._\'23selFP44\'23rest'(_35839030)),'Prelude.(,)'([_35832810|_35839050],_35839070)))),_35838524,_35838530,_35838536).
'blocked_blocked_blocked_XML.splitAtChar_2_[|]_ComplexCase'('FAIL'(_35843460),_35832810,_35827432,_35832830,'FAIL'(_35843460),_35843474,_35843474).
'blocked_blocked_XML.splitAtChar_2'('FAIL'(_35843550),_35827012,'FAIL'(_35843550),_35843564,_35843564):-nonvar(_35843550).

'XML.splitAtChar._\'23selFP43\'23first'(_35844990,_35844992,_35844994,_35844996):-freeze(_35844994,'blocked_XML.splitAtChar._\'23selFP43\'23first'(_35844990,_35844992,_35844994,_35844996)).
'blocked_XML.splitAtChar._\'23selFP43\'23first'(_35845076,_35845532,_35845538,_35845544):-hnf(_35845076,_35847170,_35845538,_35847182),'blocked_XML.splitAtChar._\'23selFP43\'23first_1'(_35847170,_35845532,_35847182,_35845544).

'blocked_XML.splitAtChar._\'23selFP43\'23first_1'(_35847634,_35847636,_35847638,_35847640):-freeze(_35847638,'blocked_blocked_XML.splitAtChar._\'23selFP43\'23first_1'(_35847634,_35847636,_35847638,_35847640)).
'blocked_blocked_XML.splitAtChar._\'23selFP43\'23first_1'('Prelude.(,)'(_35845192,_35845210),_35848004,_35848010,_35848016):-!,hnf(_35845192,_35848004,_35848010,_35848016).
'blocked_blocked_XML.splitAtChar._\'23selFP43\'23first_1'('FAIL'(_35848594),'FAIL'(_35848594),_35848608,_35848608):-nonvar(_35848594).

'XML.splitAtChar._\'23selFP44\'23rest'(_35849988,_35849990,_35849992,_35849994):-freeze(_35849992,'blocked_XML.splitAtChar._\'23selFP44\'23rest'(_35849988,_35849990,_35849992,_35849994)).
'blocked_XML.splitAtChar._\'23selFP44\'23rest'(_35850074,_35850524,_35850530,_35850536):-hnf(_35850074,_35852126,_35850530,_35852138),'blocked_XML.splitAtChar._\'23selFP44\'23rest_1'(_35852126,_35850524,_35852138,_35850536).

'blocked_XML.splitAtChar._\'23selFP44\'23rest_1'(_35852584,_35852586,_35852588,_35852590):-freeze(_35852588,'blocked_blocked_XML.splitAtChar._\'23selFP44\'23rest_1'(_35852584,_35852586,_35852588,_35852590)).
'blocked_blocked_XML.splitAtChar._\'23selFP44\'23rest_1'('Prelude.(,)'(_35850190,_35850208),_35852954,_35852960,_35852966):-!,hnf(_35850208,_35852954,_35852960,_35852966).
'blocked_blocked_XML.splitAtChar._\'23selFP44\'23rest_1'('FAIL'(_35853538),'FAIL'(_35853538),_35853552,_35853552):-nonvar(_35853538).

'XML.updateXmlFile'(_35854382,_35854384,_35854386,_35854388,_35854390):-freeze(_35854388,'blocked_XML.updateXmlFile'(_35854382,_35854384,_35854386,_35854388,_35854390)).
'blocked_XML.updateXmlFile'(_35854478,_35854496,_35855072,_35855078,_35855084):-makeShare(_35854496,_35855200),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','XML.readXmlFile'(_35855200)),partcall(1,'XML.updateXmlFile._\'23lambda8',[_35854478,_35855200])),_35855072,_35855078,_35855084).

'XML.updateXmlFile._\'23lambda8'(_35858424,_35858426,_35858428,_35858430,_35858432,_35858434):-freeze(_35858432,'blocked_XML.updateXmlFile._\'23lambda8'(_35858424,_35858426,_35858428,_35858430,_35858432,_35858434)).
'blocked_XML.updateXmlFile._\'23lambda8'(_35858530,_35858548,_35858566,_35859316,_35859322,_35859328):-makeShare(_35858594,_35859540),hnf('Prelude.cond'(letrec4PAKCS(_35859540,_35858566),'Prelude.$!!'(partcall(1,'XML.writeXmlFile',[_35858530]),'Prelude.apply'(_35858548,_35859540))),_35859316,_35859322,_35859328).

'XML.showXmlDocWithParams._\'23caseor0'(_35863128,_35863130,_35863132,_35863134):-freeze(_35863132,'blocked_XML.showXmlDocWithParams._\'23caseor0'(_35863128,_35863130,_35863132,_35863134)).
'blocked_XML.showXmlDocWithParams._\'23caseor0'(_35863214,_35864512,_35864518,_35864524):-hnf(_35863214,_35866186,_35864518,_35866198),'blocked_XML.showXmlDocWithParams._\'23caseor0_1'(_35866186,_35864512,_35866198,_35864524).

'blocked_XML.showXmlDocWithParams._\'23caseor0_1'(_35866662,_35866664,_35866666,_35866668):-freeze(_35866666,freeze(_35866662,'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'(_35866662,_35866664,_35866666,_35866668))).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'('Prelude.True',['^n','^o'],_35867052,_35867052).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'('Prelude.False',['^y','^e','^s'],_35868206,_35868206):-!.
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0_1'('FAIL'(_35869258),'FAIL'(_35869258),_35869272,_35869272).

'XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'(_35871180,_35871182,_35871184,_35871186,_35871188,_35871190):-freeze(_35871188,'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'(_35871180,_35871182,_35871184,_35871186,_35871188,_35871190)).
'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0'(_35871286,_35871304,_35871322,_35876192,_35876198,_35876204):-hnf(_35871286,_35878314,_35876198,_35878338),'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'(_35878314,_35871304,_35871322,_35876192,_35878338,_35876204).

'blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'(_35878890,_35878892,_35878894,_35878896,_35878898,_35878900):-freeze(_35878898,freeze(_35878890,'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'(_35878890,_35878892,_35878894,_35878896,_35878898,_35878900))).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'('Prelude.True',_35871304,_35871322,_35879294,_35879300,_35879306):-hnf('Prelude.++'([^<,'^!','^D','^O','^C','^T','^Y','^P','^E','^ '],'Prelude.++'(_35871304,'Prelude.++'(['^ ','^S','^Y','^S','^T','^E','^M','^ ','^"'],'Prelude.++'('XML.lookupDtdUrl'(_35871322),['^"',^>,'^010','^010'])))),_35879294,_35879300,_35879306).
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'('Prelude.False',_35871304,_35871322,[],_35886504,_35886504):-!.
'blocked_blocked_XML.showXmlDocWithParams._\'23caseor0._\'23caseor0_1'('FAIL'(_35887170),_35871304,_35871322,'FAIL'(_35887170),_35887184,_35887184).

'XML.showXmlExp._\'23caseor0'(_35888320,_35888322,_35888324,_35888326,_35888328,_35888330,_35888332,_35888334):-freeze(_35888332,'blocked_XML.showXmlExp._\'23caseor0'(_35888320,_35888322,_35888324,_35888326,_35888328,_35888330,_35888332,_35888334)).
'blocked_XML.showXmlExp._\'23caseor0'(_35888446,_35888464,_35888482,_35888500,_35888518,_35894544,_35894550,_35894556):-hnf(_35888446,_35895890,_35894550,_35895926),'blocked_XML.showXmlExp._\'23caseor0_1'(_35895890,_35888464,_35888482,_35888500,_35888518,_35894544,_35895926,_35894556).

'blocked_XML.showXmlExp._\'23caseor0_1'(_35896362,_35896364,_35896366,_35896368,_35896370,_35896372,_35896374,_35896376):-freeze(_35896374,freeze(_35896362,'blocked_blocked_XML.showXmlExp._\'23caseor0_1'(_35896362,_35896364,_35896366,_35896368,_35896370,_35896372,_35896374,_35896376))).
'blocked_blocked_XML.showXmlExp._\'23caseor0_1'('Prelude.True',_35888464,_35888482,_35888500,_35888518,['^ ',^/,^>,'^010'],_35896792,_35896792).
'blocked_blocked_XML.showXmlExp._\'23caseor0_1'('Prelude.False',_35888464,_35888482,_35888500,_35888518,_35902178,_35902184,_35902190):-!,makeShare(_35888464,_35899130),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Int\'23'('Prelude.length'(_35899130),1),'XML.isXText'('Prelude.head'(_35899130))),_35904418,_35902184,_35904372),'blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'(_35904418,_35899130,_35888482,_35888500,_35888518,_35902178,_35904372,_35902190).

'blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'(_35905042,_35905044,_35905046,_35905048,_35905050,_35905052,_35905054,_35905056):-freeze(_35905054,freeze(_35905042,'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'(_35905042,_35905044,_35905046,_35905048,_35905050,_35905052,_35905054,_35905056))).
'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_35899130,_35888482,_35888500,_35888518,_35905466,_35905472,_35905478):-makeShare(_35890018,_35905738),hnf('Prelude.cond'(letrec4PAKCS(_35905738,'XML.showXmlExp._\'23selFP2\'23s'(_35899130)),'Prelude.++'([^>],'Prelude.++'('Prelude.apply'(_35888482,_35905738),'Prelude.++'([^<,^/],'Prelude.++'(_35888518,[^>,'^010']))))),_35905466,_35905472,_35905478).
'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_35899130,_35888482,_35888500,_35888518,_35910552,_35910558,_35910564):-!,makeShare(_35888500,_35910830),hnf('Prelude.++'([^>,'^010'],'Prelude.++'('XML.showXmlExps'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_35910830,2),_35899130,_35888482),'Prelude.++'('XML.xtab'(_35910830),'Prelude.++'([^<,^/],'Prelude.++'(_35888518,[^>,'^010']))))),_35910552,_35910558,_35910564).
'blocked_blocked_blocked_XML.showXmlExp._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_35915704),_35899130,_35888482,_35888500,_35888518,'FAIL'(_35915704),_35915718,_35915718).
'blocked_blocked_XML.showXmlExp._\'23caseor0_1'('FAIL'(_35915802),_35888464,_35888482,_35888500,_35888518,'FAIL'(_35915802),_35915816,_35915816).

'XML.unquoteUnicode._\'23caseor0'(_35917120,_35917122,_35917124,_35917126,_35917128,_35917130,_35917132):-freeze(_35917130,'blocked_XML.unquoteUnicode._\'23caseor0'(_35917120,_35917122,_35917124,_35917126,_35917128,_35917130,_35917132)).
'blocked_XML.unquoteUnicode._\'23caseor0'(_35917236,_35917254,_35917272,_35917290,_35919826,_35919832,_35919838):-hnf(_35917236,_35921308,_35919832,_35921338),'blocked_XML.unquoteUnicode._\'23caseor0_1'(_35921308,_35917254,_35917272,_35917290,_35919826,_35921338,_35919838).

'blocked_XML.unquoteUnicode._\'23caseor0_1'(_35921790,_35921792,_35921794,_35921796,_35921798,_35921800,_35921802):-freeze(_35921800,freeze(_35921790,'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'(_35921790,_35921792,_35921794,_35921796,_35921798,_35921800,_35921802))).
'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'([_35917406|_35917424],_35917254,_35917272,_35917290,_35923912,_35923918,_35923924):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_35917406,'^x'),_35925994,_35923918,_35925942),'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'(_35925994,_35917406,_35917424,_35917254,_35917272,_35917290,_35923912,_35925942,_35923924).

'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'(_35926554,_35926556,_35926558,_35926560,_35926562,_35926564,_35926566,_35926568,_35926570):-freeze(_35926568,freeze(_35926554,'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'(_35926554,_35926556,_35926558,_35926560,_35926562,_35926564,_35926566,_35926568,_35926570))).
'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'('Prelude.True',_35917406,_35917424,_35917254,_35917272,_35917290,['Prelude.chr'('XML.unquoteUnicode.extr.117'(_35917254,_35917272,'Numeric.readHex'(_35917424)))],_35926994,_35926994).
'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'('Prelude.False',_35917406,_35917424,_35917254,_35917272,_35917290,['Prelude.chr'('XML.unquoteUnicode.extr.117'(_35917254,_35917272,'Numeric.readInt'(_35917290)))],_35929292,_35929292):-!.
'blocked_blocked_blocked_XML.unquoteUnicode._\'23caseor0_1_[|]_ComplexCase'('FAIL'(_35931286),_35917406,_35917424,_35917254,_35917272,_35917290,'FAIL'(_35931286),_35931300,_35931300).
'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'([],_35917254,_35917272,_35917290,['Prelude.chr'('XML.unquoteUnicode.extr.117'(_35917254,_35917272,'Numeric.readInt'(_35917290)))],_35931560,_35931560):-!.
'blocked_blocked_XML.unquoteUnicode._\'23caseor0_1'('FAIL'(_35933262),_35917254,_35917272,_35917290,'FAIL'(_35933262),_35933276,_35933276).

'XML.readXmlFile._\'23lambda4._\'23caseor0'(_35934866,_35934868,_35934870,_35934872,_35934874,_35934876):-freeze(_35934874,'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0'(_35934866,_35934868,_35934870,_35934872,_35934874,_35934876)).
'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0'(_35934972,_35934990,_35935008,_35948218,_35948224,_35948230):-hnf(_35934972,_35950016,_35948224,_35950040),'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'(_35950016,_35934990,_35935008,_35948218,_35950040,_35948230).

'blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'(_35950538,_35950540,_35950542,_35950544,_35950546,_35950548):-freeze(_35950546,freeze(_35950538,'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'(_35950538,_35950540,_35950542,_35950544,_35950546,_35950548))).
'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'('Prelude.True',_35934990,_35935008,_35950942,_35950948,_35950954):-hnf('Prelude.error'('Prelude.++'(['^F','^i','^l','^e','^ '],'Prelude.++'(_35935008,['^ ','^c','^o','^n','^t','^a','^i','^n','^s','^ ','^n','^o','^ ','^X','^M','^L','^ ','^d','^o','^c','^u','^m','^e','^n','^t','^!']))),_35950942,_35950948,_35950954).
'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'('Prelude.False',_35934990,_35935008,_35961632,_35961638,_35961644):-!,makeShare(_35934990,_35959260),hnf('Prelude.null'('Prelude.tail'(_35959260)),_35964312,_35961638,_35964278),'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'(_35964312,_35959260,_35935008,_35961632,_35964278,_35961644).

'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'(_35965010,_35965012,_35965014,_35965016,_35965018,_35965020):-freeze(_35965018,freeze(_35965010,'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'(_35965010,_35965012,_35965014,_35965016,_35965018,_35965020))).
'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_35959260,_35935008,_35965414,_35965420,_35965426):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.head'(_35959260)),_35965414,_35965420,_35965426).
'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_35959260,_35935008,_35967346,_35967352,_35967358):-!,hnf('Prelude.error'('Prelude.++'(['^F','^i','^l','^e','^ '],'Prelude.++'(_35935008,['^ ','^c','^o','^n','^t','^a','^i','^n','^s','^ ','^m','^o','^r','^e','^ ','^t','^h','^a','^n','^ ','^o','^n','^e','^ ','^X','^M','^L','^ ','^d','^o','^c','^u','^m','^e','^n','^t','^!']))),_35967346,_35967352,_35967358).
'blocked_blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_35977528),_35959260,_35935008,'FAIL'(_35977528),_35977542,_35977542).
'blocked_blocked_XML.readXmlFile._\'23lambda4._\'23caseor0_1'('FAIL'(_35977610),_35934990,_35935008,'FAIL'(_35977610),_35977624,_35977624).

'XML.scanXmlText._\'23caseor0'(_35978798,_35978800,_35978802,_35978804,_35978806):-freeze(_35978804,'blocked_XML.scanXmlText._\'23caseor0'(_35978798,_35978800,_35978802,_35978804,_35978806)).
'blocked_XML.scanXmlText._\'23caseor0'(_35978894,_35978912,_35979512,_35979518,_35979524):-hnf(_35978894,_35980870,_35979518,_35980888),'blocked_XML.scanXmlText._\'23caseor0_1'(_35980870,_35978912,_35979512,_35980888,_35979524).

'blocked_XML.scanXmlText._\'23caseor0_1'(_35981306,_35981308,_35981310,_35981312,_35981314):-freeze(_35981312,freeze(_35981306,'blocked_blocked_XML.scanXmlText._\'23caseor0_1'(_35981306,_35981308,_35981310,_35981312,_35981314))).
'blocked_blocked_XML.scanXmlText._\'23caseor0_1'('Prelude.True',_35978912,_35981700,_35981706,_35981712):-hnf(_35978912,_35981700,_35981706,_35981712).
'blocked_blocked_XML.scanXmlText._\'23caseor0_1'('Prelude.False',_35978912,['^ '|_35978912],_35982482,_35982482):-!.
'blocked_blocked_XML.scanXmlText._\'23caseor0_1'('FAIL'(_35983138),_35978912,'FAIL'(_35983138),_35983152,_35983152).

'XML.scanXmlElemName._\'23caseor0'(_35984470,_35984472,_35984474,_35984476,_35984478,_35984480,_35984482):-freeze(_35984480,'blocked_XML.scanXmlElemName._\'23caseor0'(_35984470,_35984472,_35984474,_35984476,_35984478,_35984480,_35984482)).
'blocked_XML.scanXmlElemName._\'23caseor0'(_35984586,_35984604,_35984622,_35984640,_35986454,_35986460,_35986466):-hnf(_35984586,_35987972,_35986460,_35988002),'blocked_XML.scanXmlElemName._\'23caseor0_1'(_35987972,_35984604,_35984622,_35984640,_35986454,_35988002,_35986466).

'blocked_XML.scanXmlElemName._\'23caseor0_1'(_35988460,_35988462,_35988464,_35988466,_35988468,_35988470,_35988472):-freeze(_35988470,freeze(_35988460,'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'(_35988460,_35988462,_35988464,_35988466,_35988468,_35988470,_35988472))).
'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'('Prelude.True',_35984604,_35984622,_35984640,['XML.XElem'(_35984604,_35984622,[])|'XML.scanXmlString'('Prelude.drop'(2,_35984640))],_35988880,_35988880).
'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'('Prelude.False',_35984604,_35984622,_35984640,['XML.XElem'([^<|_35984604],_35984622,[])|'XML.scanXmlString'('Prelude.tail'(_35984640))],_35990882,_35990882):-!.
'blocked_blocked_XML.scanXmlElemName._\'23caseor0_1'('FAIL'(_35992702),_35984604,_35984622,_35984640,'FAIL'(_35992702),_35992716,_35992716).

'XML.scanXmlCData._\'23caseor0'(_35993936,_35993938,_35993940,_35993942,_35993944):-freeze(_35993942,'blocked_XML.scanXmlCData._\'23caseor0'(_35993936,_35993938,_35993940,_35993942,_35993944)).
'blocked_XML.scanXmlCData._\'23caseor0'(_35994032,_35994050,_35994754,_35994760,_35994766):-hnf(_35994032,_35996148,_35994760,_35996166),'blocked_XML.scanXmlCData._\'23caseor0_1'(_35996148,_35994050,_35994754,_35996166,_35994766).

'blocked_XML.scanXmlCData._\'23caseor0_1'(_35996590,_35996592,_35996594,_35996596,_35996598):-freeze(_35996596,freeze(_35996590,'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'(_35996590,_35996592,_35996594,_35996596,_35996598))).
'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'('Prelude.True',_35994050,_35996984,_35996990,_35996996):-hnf('XML.scanXmlString'('Prelude.tail'(_35994050)),_35996984,_35996990,_35996996).
'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'('Prelude.False',_35994050,_35998160,_35998166,_35998172):-!,hnf('XML.scanXmlCData'(_35994050),_35998160,_35998166,_35998172).
'blocked_blocked_XML.scanXmlCData._\'23caseor0_1'('FAIL'(_35998856),_35994050,'FAIL'(_35998856),_35998870,_35998870).

:-costCenters(['']).




%%%%% Number of shared variables: 110

