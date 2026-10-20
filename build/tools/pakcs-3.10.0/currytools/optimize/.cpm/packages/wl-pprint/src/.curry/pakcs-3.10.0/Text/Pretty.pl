%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').
:-importModule('Text.PrettyImpl').

:-curryModule('Text.Pretty').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Text.Pretty._def\'23pretty\'23Text.Pretty.Pretty','_def#pretty#Text.Pretty.Pretty',1,'Text.Pretty._def\'23pretty\'23Text.Pretty.Pretty',nofix,notype).
functiontype('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty','_def#prettyList#Text.Pretty.Pretty',1,'Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23','_inst#Text.Pretty.Pretty#[]#0##',2,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23','_impl#pretty#Text.Pretty.Pretty#[]#0##',1,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23','_impl#prettyList#Text.Pretty.Pretty#[]#0##',1,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23','_inst#Text.Pretty.Pretty#Text.PrettyImpl.Doc#',1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23','_impl#pretty#Text.Pretty.Pretty#Text.PrettyImpl.Doc#',0,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23','_impl#prettyList#Text.Pretty.Pretty#Text.PrettyImpl.Doc#',0,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23','_inst#Text.Pretty.Pretty#()#',1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23','_impl#pretty#Text.Pretty.Pretty#()#',1,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'29\'23','_impl#prettyList#Text.Pretty.Pretty#()#',0,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'29\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23','_inst#Text.Pretty.Pretty#Prelude.Bool#',1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Bool\'23','_impl#pretty#Text.Pretty.Pretty#Prelude.Bool#',0,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Bool\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Bool\'23','_impl#prettyList#Text.Pretty.Pretty#Prelude.Bool#',0,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Bool\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23','_inst#Text.Pretty.Pretty#Prelude.Char#',1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Char\'23','_impl#pretty#Text.Pretty.Pretty#Prelude.Char#',0,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Char\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Char\'23','_impl#prettyList#Text.Pretty.Pretty#Prelude.Char#',0,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Char\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23','_inst#Text.Pretty.Pretty#Prelude.Int#',1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Int\'23','_impl#pretty#Text.Pretty.Pretty#Prelude.Int#',0,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Int\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Int\'23','_impl#prettyList#Text.Pretty.Pretty#Prelude.Int#',0,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Int\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23','_inst#Text.Pretty.Pretty#Prelude.Float#',1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Float\'23','_impl#pretty#Text.Pretty.Pretty#Prelude.Float#',0,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Float\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Float\'23','_impl#prettyList#Text.Pretty.Pretty#Prelude.Float#',0,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Float\'23',nofix,notype).
functiontype('Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23','_inst#Text.Pretty.Pretty#(,)#0##1##',3,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23','_impl#pretty#Text.Pretty.Pretty#(,)#0##1##',3,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23','_impl#prettyList#Text.Pretty.Pretty#(,)#0##1##',2,'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23',nofix,notype).
functiontype('Text.Pretty.pPrint',pPrint,0,'Text.Pretty.pPrint',nofix,notype).
functiontype('Text.Pretty.empty',empty,0,'Text.Pretty.empty',nofix,notype).
functiontype('Text.Pretty.isEmpty',isEmpty,1,'Text.Pretty.isEmpty',nofix,notype).
functiontype('Text.Pretty.isEmpty.isEmptyText.6','Text.Pretty.isEmpty.isEmptyText.6',1,'Text.Pretty.isEmpty.isEmptyText.6',nofix,notype).
functiontype('Text.Pretty.text',text,1,'Text.Pretty.text',nofix,notype).
functiontype('Text.Pretty.linesep',linesep,0,'Text.Pretty.linesep',nofix,notype).
functiontype('Text.Pretty.hardline',hardline,0,'Text.Pretty.hardline',nofix,notype).
functiontype('Text.Pretty.line',line,0,'Text.Pretty.line',nofix,notype).
functiontype('Text.Pretty.linebreak',linebreak,0,'Text.Pretty.linebreak',nofix,notype).
functiontype('Text.Pretty.softline',softline,0,'Text.Pretty.softline',nofix,notype).
functiontype('Text.Pretty.softbreak',softbreak,0,'Text.Pretty.softbreak',nofix,notype).
functiontype('Text.Pretty.group',group,1,'Text.Pretty.group',nofix,notype).
functiontype('Text.Pretty.nest',nest,2,'Text.Pretty.nest',nofix,notype).
functiontype('Text.Pretty.hang',hang,2,'Text.Pretty.hang',nofix,notype).
functiontype('Text.Pretty.align',align,1,'Text.Pretty.align',nofix,notype).
functiontype('Text.Pretty.indent',indent,2,'Text.Pretty.indent',nofix,notype).
functiontype('Text.Pretty.combine',combine,3,'Text.Pretty.combine',nofix,notype).
functiontype('Text.Pretty.\'3C\'3E',<>,2,'Text.Pretty.\'3C\'3E',nofix,notype).
functiontype('Text.Pretty.\'3C\'2B\'3E',<+>,0,'Text.Pretty.\'3C\'2B\'3E',nofix,notype).
functiontype('Text.Pretty.\'24\'24',$$,0,'Text.Pretty.\'24\'24',nofix,notype).
functiontype('Text.Pretty.\'3C\'24\'2B\'24\'3E',<$+$>,0,'Text.Pretty.\'3C\'24\'2B\'24\'3E',nofix,notype).
functiontype('Text.Pretty.\'3C\'2F\'3E',</>,0,'Text.Pretty.\'3C\'2F\'3E',nofix,notype).
functiontype('Text.Pretty.\'3C\'24\'24\'3E',<$$>,0,'Text.Pretty.\'3C\'24\'24\'3E',nofix,notype).
functiontype('Text.Pretty.\'3C\'2F\'2F\'3E',<//>,0,'Text.Pretty.\'3C\'2F\'2F\'3E',nofix,notype).
functiontype('Text.Pretty.\'3C\'24\'21\'24\'3E','<$!$>',0,'Text.Pretty.\'3C\'24\'21\'24\'3E',nofix,notype).
functiontype('Text.Pretty.compose',compose,2,'Text.Pretty.compose',nofix,notype).
functiontype('Text.Pretty.hsep',hsep,0,'Text.Pretty.hsep',nofix,notype).
functiontype('Text.Pretty.vsep',vsep,0,'Text.Pretty.vsep',nofix,notype).
functiontype('Text.Pretty.vsepBlank',vsepBlank,0,'Text.Pretty.vsepBlank',nofix,notype).
functiontype('Text.Pretty.fillSep',fillSep,0,'Text.Pretty.fillSep',nofix,notype).
functiontype('Text.Pretty.sep',sep,0,'Text.Pretty.sep',nofix,notype).
functiontype('Text.Pretty.hcat',hcat,0,'Text.Pretty.hcat',nofix,notype).
functiontype('Text.Pretty.vcat',vcat,0,'Text.Pretty.vcat',nofix,notype).
functiontype('Text.Pretty.fillCat',fillCat,0,'Text.Pretty.fillCat',nofix,notype).
functiontype('Text.Pretty.cat',cat,0,'Text.Pretty.cat',nofix,notype).
functiontype('Text.Pretty.punctuate',punctuate,2,'Text.Pretty.punctuate',nofix,notype).
functiontype('Text.Pretty.punctuate.go.82','Text.Pretty.punctuate.go.82',2,'Text.Pretty.punctuate.go.82',nofix,notype).
functiontype('Text.Pretty.encloseSep',encloseSep,4,'Text.Pretty.encloseSep',nofix,notype).
functiontype('Text.Pretty.encloseSepSpaced',encloseSepSpaced,3,'Text.Pretty.encloseSepSpaced',nofix,notype).
functiontype('Text.Pretty.hEncloseSep',hEncloseSep,4,'Text.Pretty.hEncloseSep',nofix,notype).
functiontype('Text.Pretty.fillEncloseSep',fillEncloseSep,4,'Text.Pretty.fillEncloseSep',nofix,notype).
functiontype('Text.Pretty.fillEncloseSepSpaced',fillEncloseSepSpaced,3,'Text.Pretty.fillEncloseSepSpaced',nofix,notype).
functiontype('Text.Pretty.list',list,0,'Text.Pretty.list',nofix,notype).
functiontype('Text.Pretty.listSpaced',listSpaced,0,'Text.Pretty.listSpaced',nofix,notype).
functiontype('Text.Pretty.set',set,0,'Text.Pretty.set',nofix,notype).
functiontype('Text.Pretty.setSpaced',setSpaced,0,'Text.Pretty.setSpaced',nofix,notype).
functiontype('Text.Pretty.tupled',tupled,0,'Text.Pretty.tupled',nofix,notype).
functiontype('Text.Pretty.tupledSpaced',tupledSpaced,0,'Text.Pretty.tupledSpaced',nofix,notype).
functiontype('Text.Pretty.semiBraces',semiBraces,0,'Text.Pretty.semiBraces',nofix,notype).
functiontype('Text.Pretty.semiBracesSpaced',semiBracesSpaced,0,'Text.Pretty.semiBracesSpaced',nofix,notype).
functiontype('Text.Pretty.enclose',enclose,3,'Text.Pretty.enclose',nofix,notype).
functiontype('Text.Pretty.squotes',squotes,0,'Text.Pretty.squotes',nofix,notype).
functiontype('Text.Pretty.dquotes',dquotes,0,'Text.Pretty.dquotes',nofix,notype).
functiontype('Text.Pretty.bquotes',bquotes,0,'Text.Pretty.bquotes',nofix,notype).
functiontype('Text.Pretty.parens',parens,0,'Text.Pretty.parens',nofix,notype).
functiontype('Text.Pretty.parensIf',parensIf,2,'Text.Pretty.parensIf',nofix,notype).
functiontype('Text.Pretty.angles',angles,0,'Text.Pretty.angles',nofix,notype).
functiontype('Text.Pretty.braces',braces,0,'Text.Pretty.braces',nofix,notype).
functiontype('Text.Pretty.brackets',brackets,0,'Text.Pretty.brackets',nofix,notype).
functiontype('Text.Pretty.bool',bool,1,'Text.Pretty.bool',nofix,notype).
functiontype('Text.Pretty.char',char,1,'Text.Pretty.char',nofix,notype).
functiontype('Text.Pretty.string',string,0,'Text.Pretty.string',nofix,notype).
functiontype('Text.Pretty.string._\'23lambda2','Text.Pretty.string._#lambda2',1,'Text.Pretty.string._\'23lambda2',nofix,notype).
functiontype('Text.Pretty.int',int,1,'Text.Pretty.int',nofix,notype).
functiontype('Text.Pretty.float',float,1,'Text.Pretty.float',nofix,notype).
functiontype('Text.Pretty.lparen',lparen,0,'Text.Pretty.lparen',nofix,notype).
functiontype('Text.Pretty.rparen',rparen,0,'Text.Pretty.rparen',nofix,notype).
functiontype('Text.Pretty.langle',langle,0,'Text.Pretty.langle',nofix,notype).
functiontype('Text.Pretty.rangle',rangle,0,'Text.Pretty.rangle',nofix,notype).
functiontype('Text.Pretty.lbrace',lbrace,0,'Text.Pretty.lbrace',nofix,notype).
functiontype('Text.Pretty.rbrace',rbrace,0,'Text.Pretty.rbrace',nofix,notype).
functiontype('Text.Pretty.lbracket',lbracket,0,'Text.Pretty.lbracket',nofix,notype).
functiontype('Text.Pretty.rbracket',rbracket,0,'Text.Pretty.rbracket',nofix,notype).
functiontype('Text.Pretty.squote',squote,0,'Text.Pretty.squote',nofix,notype).
functiontype('Text.Pretty.dquote',dquote,0,'Text.Pretty.dquote',nofix,notype).
functiontype('Text.Pretty.bquote','Text.Pretty.bquote',0,'Text.Pretty.bquote',nofix,notype).
functiontype('Text.Pretty.semi',semi,0,'Text.Pretty.semi',nofix,notype).
functiontype('Text.Pretty.colon',colon,0,'Text.Pretty.colon',nofix,notype).
functiontype('Text.Pretty.comma',comma,0,'Text.Pretty.comma',nofix,notype).
functiontype('Text.Pretty.space',space,0,'Text.Pretty.space',nofix,notype).
functiontype('Text.Pretty.spaces','Text.Pretty.spaces',1,'Text.Pretty.spaces',nofix,notype).
functiontype('Text.Pretty.dot',dot,0,'Text.Pretty.dot',nofix,notype).
functiontype('Text.Pretty.backslash',backslash,0,'Text.Pretty.backslash',nofix,notype).
functiontype('Text.Pretty.equals',equals,0,'Text.Pretty.equals',nofix,notype).
functiontype('Text.Pretty.larrow',larrow,0,'Text.Pretty.larrow',nofix,notype).
functiontype('Text.Pretty.rarrow',rarrow,0,'Text.Pretty.rarrow',nofix,notype).
functiontype('Text.Pretty.doubleArrow',doubleArrow,0,'Text.Pretty.doubleArrow',nofix,notype).
functiontype('Text.Pretty.doubleColon',doubleColon,0,'Text.Pretty.doubleColon',nofix,notype).
functiontype('Text.Pretty.bar',bar,0,'Text.Pretty.bar',nofix,notype).
functiontype('Text.Pretty.at',at,0,'Text.Pretty.at',nofix,notype).
functiontype('Text.Pretty.tilde',tilde,0,'Text.Pretty.tilde',nofix,notype).
functiontype('Text.Pretty.fill',fill,2,'Text.Pretty.fill',nofix,notype).
functiontype('Text.Pretty.fillBreak',fillBreak,2,'Text.Pretty.fillBreak',nofix,notype).
functiontype('Text.Pretty.width','Text.Pretty.width',1,'Text.Pretty.width',nofix,notype).
functiontype('Text.Pretty.width.width\'27.216','Text.Pretty.width.width\'.216',2,'Text.Pretty.width.width\'27.216',nofix,notype).
functiontype('Text.Pretty.bold',bold,1,'Text.Pretty.bold',nofix,notype).
functiontype('Text.Pretty.faint',faint,1,'Text.Pretty.faint',nofix,notype).
functiontype('Text.Pretty.blinkSlow',blinkSlow,1,'Text.Pretty.blinkSlow',nofix,notype).
functiontype('Text.Pretty.blinkRapid',blinkRapid,1,'Text.Pretty.blinkRapid',nofix,notype).
functiontype('Text.Pretty.italic',italic,1,'Text.Pretty.italic',nofix,notype).
functiontype('Text.Pretty.underline',underline,1,'Text.Pretty.underline',nofix,notype).
functiontype('Text.Pretty.crossout',crossout,1,'Text.Pretty.crossout',nofix,notype).
functiontype('Text.Pretty.inverse',inverse,1,'Text.Pretty.inverse',nofix,notype).
functiontype('Text.Pretty.black',black,1,'Text.Pretty.black',nofix,notype).
functiontype('Text.Pretty.red',red,1,'Text.Pretty.red',nofix,notype).
functiontype('Text.Pretty.green',green,1,'Text.Pretty.green',nofix,notype).
functiontype('Text.Pretty.yellow',yellow,1,'Text.Pretty.yellow',nofix,notype).
functiontype('Text.Pretty.blue',blue,1,'Text.Pretty.blue',nofix,notype).
functiontype('Text.Pretty.magenta',magenta,1,'Text.Pretty.magenta',nofix,notype).
functiontype('Text.Pretty.cyan',cyan,1,'Text.Pretty.cyan',nofix,notype).
functiontype('Text.Pretty.white',white,1,'Text.Pretty.white',nofix,notype).
functiontype('Text.Pretty.bgBlack',bgBlack,1,'Text.Pretty.bgBlack',nofix,notype).
functiontype('Text.Pretty.bgRed',bgRed,1,'Text.Pretty.bgRed',nofix,notype).
functiontype('Text.Pretty.bgGreen',bgGreen,1,'Text.Pretty.bgGreen',nofix,notype).
functiontype('Text.Pretty.bgYellow',bgYellow,1,'Text.Pretty.bgYellow',nofix,notype).
functiontype('Text.Pretty.bgBlue',bgBlue,1,'Text.Pretty.bgBlue',nofix,notype).
functiontype('Text.Pretty.bgMagenta',bgMagenta,1,'Text.Pretty.bgMagenta',nofix,notype).
functiontype('Text.Pretty.bgCyan',bgCyan,1,'Text.Pretty.bgCyan',nofix,notype).
functiontype('Text.Pretty.bgWhite',bgWhite,1,'Text.Pretty.bgWhite',nofix,notype).
functiontype('Text.Pretty.pretty',pretty,1,'Text.Pretty.pretty',nofix,notype).
functiontype('Text.Pretty.pretty._\'23lambda','Text.Pretty.pretty._#lambda',1,'Text.Pretty.pretty._\'23lambda',nofix,notype).
functiontype('Text.Pretty.prettyList',prettyList,1,'Text.Pretty.prettyList',nofix,notype).
functiontype('Text.Pretty.prettyList._\'23lambda','Text.Pretty.prettyList._#lambda',1,'Text.Pretty.prettyList._\'23lambda',nofix,notype).
functiontype('Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0','Text.Pretty.isEmpty.isEmptyText.6._#caseor0._#caseor0',2,'Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0',nofix,notype).
functiontype('Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0','Text.Pretty.isEmpty.isEmptyText.6._#caseor0',2,'Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0',nofix,notype).
functiontype('Text.Pretty.fill._\'23caseor0','Text.Pretty.fill._#caseor0',3,'Text.Pretty.fill._\'23caseor0',nofix,notype).
functiontype('Text.Pretty.fillBreak._\'23caseor0','Text.Pretty.fillBreak._#caseor0',3,'Text.Pretty.fillBreak._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Text.Pretty._Dict\'23Pretty','_Dict#Pretty',2,'Pretty._Dict#Pretty',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Text.Pretty._def\'23pretty\'23Text.Pretty.Pretty'(_30741808,_30741810,_30741812,_30741814):-freeze(_30741812,'blocked_Text.Pretty._def\'23pretty\'23Text.Pretty.Pretty'(_30741808,_30741810,_30741812,_30741814)).
'blocked_Text.Pretty._def\'23pretty\'23Text.Pretty.Pretty'(_30741894,_30750940,_30750946,_30750952):-hnf('Prelude.error'(['^N','^o','^ ','^i','^n','^s','^t','^a','^n','^c','^e','^ ','^o','^r','^ ','^d','^e','^f','^a','^u','^l','^t','^ ','^m','^e','^t','^h','^o','^d','^ ','^f','^o','^r','^ ','^c','^l','^a','^s','^s','^ ','^o','^p','^e','^r','^a','^t','^i','^o','^n','^ ','^096','^p','^r','^e','^t','^t','^y','^\'']),_30750940,_30750946,_30750952).

'Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(_30765312,_30765314,_30765316,_30765318):-freeze(_30765316,'blocked_Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(_30765312,_30765314,_30765316,_30765318)).
'blocked_Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(_30765398,_30765750,_30765756,_30765762):-hnf('Prelude..'('Text.Pretty.list',partcall(1,'Prelude.map',['Text.Pretty.pretty'(_30765398)])),_30765750,_30765756,_30765762).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30769080,_30769082,_30769084,_30769086,_30769088):-freeze(_30769086,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30769080,_30769082,_30769084,_30769086,_30769088)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30769176,_30769194,_30770064,_30770070,_30770076):-hnf(_30769194,_30772502,_30770070,_30772520),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23_2'(_30772502,_30769176,_30770064,_30772520,_30770076).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23_2'(_30773112,_30773114,_30773116,_30773118,_30773120):-freeze(_30773118,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23_2'(_30773112,_30773114,_30773116,_30773118,_30773120)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23_2'('Prelude.()',_30769176,'Text.Pretty._Dict\'23Pretty'('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30773566),'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30773566)),_30773474,_30773480):-!,makeShare(_30769176,_30773566),_30773474=_30773480.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23_2'('FAIL'(_30775760),_30769176,'FAIL'(_30775760),_30775774,_30775774):-nonvar(_30775760).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30778118,_30778120,_30778122,_30778124):-freeze(_30778122,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30778118,_30778120,_30778122,_30778124)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30778204,_30778304,_30778310,_30778316):-hnf('Text.Pretty.prettyList'(_30778204),_30778304,_30778310,_30778316).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30781610,_30781612,_30781614,_30781616):-freeze(_30781614,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30781610,_30781612,_30781614,_30781616)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23'(_30781696,_30781880,_30781886,_30781892):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'5B\'5D\'230\'23\'23',[_30781696])),_30781880,_30781886,_30781892).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30785810,_30785812,_30785814,_30785816):-freeze(_30785814,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30785810,_30785812,_30785814,_30785816)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30785896,_30786654,_30786660,_30786666):-hnf(_30785896,_30789300,_30786660,_30789312),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23_1'(_30789300,_30786654,_30789312,_30786666).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23_1'(_30789932,_30789934,_30789936,_30789938):-freeze(_30789936,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23_1'(_30789932,_30789934,_30789936,_30789938)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23_1'('Prelude.()','Text.Pretty._Dict\'23Pretty'('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23','Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'),_30790284,_30790284):-!.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23_1'('FAIL'(_30792158),'FAIL'(_30792158),_30792172,_30792172):-nonvar(_30792158).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30794928,_30794930,_30794932):-freeze(_30794930,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30794928,_30794930,_30794932)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30795016,_30795022,_30795028):-hnf(partcall(1,'Prelude.id',[]),_30795016,_30795022,_30795028).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30798542,_30798544,_30798546):-freeze(_30798544,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30798542,_30798544,_30798546)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23'(_30798714,_30798720,_30798726):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Text.PrettyImpl.Doc\'23',[])),_30798714,_30798720,_30798726).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30801956,_30801958,_30801960,_30801962):-freeze(_30801960,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30801956,_30801958,_30801960,_30801962)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30802042,_30802722,_30802728,_30802734):-hnf(_30802042,_30804900,_30802728,_30804912),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'(_30804900,_30802722,_30804912,_30802734).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'(_30805454,_30805456,_30805458,_30805460):-freeze(_30805458,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'(_30805454,_30805456,_30805458,_30805460)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'('Prelude.()','Text.Pretty._Dict\'23Pretty'(partcall(1,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23',[]),'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'29\'23'),_30805806,_30805806):-!.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'('FAIL'(_30807450),'FAIL'(_30807450),_30807464,_30807464):-nonvar(_30807450).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30809630,_30809632,_30809634,_30809636):-freeze(_30809634,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30809630,_30809632,_30809634,_30809636)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30809716,_30810674,_30810680,_30810686):-hnf(_30809716,_30813176,_30810680,_30813188),'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'(_30813176,_30810674,_30813188,_30810686).

'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'(_30813784,_30813786,_30813788,_30813790):-freeze(_30813788,'blocked_blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'(_30813784,_30813786,_30813788,_30813790)).
'blocked_blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'('Prelude.()',_30814130,_30814136,_30814142):-!,hnf('Text.Pretty.text'(['^(','^)']),_30814130,_30814136,_30814142).
'blocked_blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'29\'23_1'('FAIL'(_30815354),'FAIL'(_30815354),_30815368,_30815368):-nonvar(_30815354).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30817686,_30817688,_30817690):-freeze(_30817688,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30817686,_30817688,_30817690)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'29\'23'(_30817858,_30817864,_30817870):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'29\'23',[])),_30817858,_30817864,_30817870).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30821268,_30821270,_30821272,_30821274):-freeze(_30821272,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30821268,_30821270,_30821272,_30821274)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30821354,_30822070,_30822076,_30822082):-hnf(_30821354,_30824464,_30822076,_30824476),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23_1'(_30824464,_30822070,_30824476,_30822082).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23_1'(_30825054,_30825056,_30825058,_30825060):-freeze(_30825058,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23_1'(_30825054,_30825056,_30825058,_30825060)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23_1'('Prelude.()','Text.Pretty._Dict\'23Pretty'('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Bool\'23','Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'),_30825406,_30825406):-!.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23_1'('FAIL'(_30827154),'FAIL'(_30827154),_30827168,_30827168):-nonvar(_30827154).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30829658,_30829660,_30829662):-freeze(_30829660,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30829658,_30829660,_30829662)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30829746,_30829752,_30829758):-hnf(partcall(1,'Text.Pretty.bool',[]),_30829746,_30829752,_30829758).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30833000,_30833002,_30833004):-freeze(_30833002,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30833000,_30833002,_30833004)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Bool\'23'(_30833172,_30833178,_30833184):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Bool\'23',[])),_30833172,_30833178,_30833184).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30836654,_30836656,_30836658,_30836660):-freeze(_30836658,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30836654,_30836656,_30836658,_30836660)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30836740,_30837456,_30837462,_30837468):-hnf(_30836740,_30839850,_30837462,_30839862),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23_1'(_30839850,_30837456,_30839862,_30837468).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23_1'(_30840440,_30840442,_30840444,_30840446):-freeze(_30840444,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23_1'(_30840440,_30840442,_30840444,_30840446)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23_1'('Prelude.()','Text.Pretty._Dict\'23Pretty'('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Char\'23','Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Char\'23'),_30840792,_30840792):-!.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Char\'23_1'('FAIL'(_30842540),'FAIL'(_30842540),_30842554,_30842554):-nonvar(_30842540).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30845044,_30845046,_30845048):-freeze(_30845046,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30845044,_30845046,_30845048)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30845132,_30845138,_30845144):-hnf(partcall(1,'Text.Pretty.char',[]),_30845132,_30845138,_30845144).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30848386,_30848388,_30848390):-freeze(_30848388,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30848386,_30848388,_30848390)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Char\'23'(_30848474,_30848480,_30848486):-hnf('Text.Pretty.string',_30848474,_30848480,_30848486).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30851276,_30851278,_30851280,_30851282):-freeze(_30851280,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30851276,_30851278,_30851280,_30851282)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30851362,_30852072,_30852078,_30852084):-hnf(_30851362,_30854430,_30852078,_30854442),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23_1'(_30854430,_30852072,_30854442,_30852084).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23_1'(_30855014,_30855016,_30855018,_30855020):-freeze(_30855018,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23_1'(_30855014,_30855016,_30855018,_30855020)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23_1'('Prelude.()','Text.Pretty._Dict\'23Pretty'('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Int\'23','Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Int\'23'),_30855366,_30855366):-!.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23_1'('FAIL'(_30857096),'FAIL'(_30857096),_30857110,_30857110):-nonvar(_30857096).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30859562,_30859564,_30859566):-freeze(_30859564,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30859562,_30859564,_30859566)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30859650,_30859656,_30859662):-hnf(partcall(1,'Text.Pretty.int',[]),_30859650,_30859656,_30859662).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30862854,_30862856,_30862858):-freeze(_30862856,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30862854,_30862856,_30862858)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Int\'23'(_30863026,_30863032,_30863038):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Int\'23',[])),_30863026,_30863032,_30863038).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30866534,_30866536,_30866538,_30866540):-freeze(_30866538,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30866534,_30866536,_30866538,_30866540)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30866620,_30867342,_30867348,_30867354):-hnf(_30866620,_30869772,_30867348,_30869784),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23_1'(_30869772,_30867342,_30869784,_30867354).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23_1'(_30870368,_30870370,_30870372,_30870374):-freeze(_30870372,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23_1'(_30870368,_30870370,_30870372,_30870374)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23_1'('Prelude.()','Text.Pretty._Dict\'23Pretty'('Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Float\'23','Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Float\'23'),_30870720,_30870720):-!.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23_1'('FAIL'(_30872486),'FAIL'(_30872486),_30872500,_30872500):-nonvar(_30872486).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30875028,_30875030,_30875032):-freeze(_30875030,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30875028,_30875030,_30875032)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30875116,_30875122,_30875128):-hnf(partcall(1,'Text.Pretty.float',[]),_30875116,_30875122,_30875128).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30878420,_30878422,_30878424):-freeze(_30878422,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30878420,_30878422,_30878424)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23Prelude.Float\'23'(_30878592,_30878598,_30878604):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23Prelude.Float\'23',[])),_30878592,_30878598,_30878604).

'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30882168,_30882170,_30882172,_30882174,_30882176,_30882178):-freeze(_30882176,'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30882168,_30882170,_30882172,_30882174,_30882176,_30882178)).
'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30882274,_30882292,_30882310,_30883388,_30883394,_30883400):-hnf(_30882310,_30886194,_30883394,_30886218),'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'(_30886194,_30882274,_30882292,_30883388,_30886218,_30883400).

'blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'(_30886878,_30886880,_30886882,_30886884,_30886886,_30886888):-freeze(_30886886,'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'(_30886878,_30886880,_30886882,_30886884,_30886886,_30886888)).
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'('Prelude.()',_30882274,_30882292,'Text.Pretty._Dict\'23Pretty'(partcall(1,'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[_30887422,_30887402]),'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30887402,_30887422)),_30887250,_30887256):-!,makeShare(_30882274,_30887402),makeShare(_30882292,_30887422),_30887250=_30887256.
'blocked_blocked_Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'('FAIL'(_30890246),_30882274,_30882292,'FAIL'(_30890246),_30890260,_30890260):-nonvar(_30890246).

'Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30892848,_30892850,_30892852,_30892854,_30892856,_30892858):-freeze(_30892856,'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30892848,_30892850,_30892852,_30892854,_30892856,_30892858)).
'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30892954,_30892972,_30892990,_30894674,_30894680,_30894686):-hnf(_30892990,_30897804,_30894680,_30897828),'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'(_30897804,_30892954,_30892972,_30894674,_30897828,_30894686).

'blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'(_30898542,_30898544,_30898546,_30898548,_30898550,_30898552):-freeze(_30898550,'blocked_blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'(_30898542,_30898544,_30898546,_30898548,_30898550,_30898552)).
'blocked_blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'('Prelude.(,)'(_30893106,_30893124),_30892954,_30892972,_30898932,_30898938,_30898944):-!,hnf('Prelude.apply'('Text.Pretty.tupled',['Prelude.apply'('Text.Pretty.pretty'(_30892954),_30893106),'Prelude.apply'('Text.Pretty.pretty'(_30892972),_30893124)]),_30898932,_30898938,_30898944).
'blocked_blocked_Text.Pretty._impl\'23pretty\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23_3'('FAIL'(_30901804),_30892954,_30892972,'FAIL'(_30901804),_30901818,_30901818):-nonvar(_30901804).

'Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30904558,_30904560,_30904562,_30904564,_30904566):-freeze(_30904564,'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30904558,_30904560,_30904562,_30904564,_30904566)).
'blocked_Text.Pretty._impl\'23prettyList\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23'(_30904654,_30904672,_30904926,_30904932,_30904938):-hnf('Text.Pretty._def\'23prettyList\'23Text.Pretty.Pretty'(partcall(1,'Text.Pretty._inst\'23Text.Pretty.Pretty\'23\'28\'2C\'29\'230\'23\'231\'23\'23',[_30904672,_30904654])),_30904926,_30904932,_30904938).

'Text.Pretty.pPrint'(_30907564,_30907566,_30907568):-freeze(_30907566,'blocked_Text.Pretty.pPrint'(_30907564,_30907566,_30907568)).
'blocked_Text.Pretty.pPrint'(_30907722,_30907728,_30907734):-hnf(partcall(1,'Text.PrettyImpl.showWidth',[80]),_30907722,_30907728,_30907734).

'Text.Pretty.empty'(_30909020,_30909022,_30909024):-freeze(_30909022,'blocked_Text.Pretty.empty'(_30909020,_30909022,_30909024)).
'blocked_Text.Pretty.empty'('Text.PrettyImpl.Doc'('Text.PrettyImpl.Empty'),_30909198,_30909198).

'Text.Pretty.isEmpty'(_30910654,_30910656,_30910658,_30910660):-freeze(_30910658,'blocked_Text.Pretty.isEmpty'(_30910654,_30910656,_30910658,_30910660)).
'blocked_Text.Pretty.isEmpty'(_30910740,_30911328,_30911334,_30911340):-hnf(_30910740,_30912390,_30911334,_30912402),'blocked_Text.Pretty.isEmpty_1'(_30912390,_30911328,_30912402,_30911340).

'blocked_Text.Pretty.isEmpty_1'(_30912758,_30912760,_30912762,_30912764):-freeze(_30912762,'blocked_blocked_Text.Pretty.isEmpty_1'(_30912758,_30912760,_30912762,_30912764)).
'blocked_blocked_Text.Pretty.isEmpty_1'('Text.PrettyImpl.Doc'(_30910856),_30913230,_30913236,_30913242):-!,hnf('Text.Pretty.isEmpty.isEmptyText.6'('Prelude.apply'(_30910856,'Text.PrettyImpl.EOD')),_30913230,_30913236,_30913242).
'blocked_blocked_Text.Pretty.isEmpty_1'('FAIL'(_30914376),'FAIL'(_30914376),_30914390,_30914390):-nonvar(_30914376).

'Text.Pretty.isEmpty.isEmptyText.6'(_30915828,_30915830,_30915832,_30915834):-freeze(_30915832,'blocked_Text.Pretty.isEmpty.isEmptyText.6'(_30915828,_30915830,_30915832,_30915834)).
'blocked_Text.Pretty.isEmpty.isEmptyText.6'(_30915914,_30916440,_30916446,_30916452):-makeShare(_30915942,_30916558),hnf('Prelude.cond'(letrec4PAKCS(_30916558,'Prelude.False'),'Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0'(_30915914,_30916558)),_30916440,_30916446,_30916452).

'Text.Pretty.text'(_30919062,_30919064,_30919066,_30919068):-freeze(_30919066,'blocked_Text.Pretty.text'(_30919062,_30919064,_30919066,_30919068)).
'blocked_Text.Pretty.text'(_30919148,'Text.PrettyImpl.Doc'('Text.PrettyImpl.Text'(_30919148)),_30919338,_30919338).

'Text.Pretty.linesep'(_30920950,_30920952,_30920954):-freeze(_30920952,'blocked_Text.Pretty.linesep'(_30920950,_30920952,_30920954)).
'blocked_Text.Pretty.linesep'(_30921374,_30921380,_30921386):-hnf('Prelude..'('Text.PrettyImpl.Doc','Prelude..'('Text.PrettyImpl.LineBreak','Prelude.Just')),_30921374,_30921380,_30921386).

'Text.Pretty.hardline'(_30923514,_30923516,_30923518):-freeze(_30923516,'blocked_Text.Pretty.hardline'(_30923514,_30923516,_30923518)).
'blocked_Text.Pretty.hardline'('Text.PrettyImpl.Doc'('Text.PrettyImpl.LineBreak'('Prelude.Nothing')),_30923776,_30923776).

'Text.Pretty.line'(_30925360,_30925362,_30925364):-freeze(_30925362,'blocked_Text.Pretty.line'(_30925360,_30925362,_30925364)).
'blocked_Text.Pretty.line'(_30925770,_30925776,_30925782):-hnf('Prelude.apply'('Text.Pretty.linesep',['^ ']),_30925770,_30925776,_30925782).

'Text.Pretty.linebreak'(_30927578,_30927580,_30927582):-freeze(_30927580,'blocked_Text.Pretty.linebreak'(_30927578,_30927580,_30927582)).
'blocked_Text.Pretty.linebreak'(_30927834,_30927840,_30927846):-hnf('Prelude.apply'('Text.Pretty.linesep',[]),_30927834,_30927840,_30927846).

'Text.Pretty.softline'(_30929432,_30929434,_30929436):-freeze(_30929434,'blocked_Text.Pretty.softline'(_30929432,_30929434,_30929436)).
'blocked_Text.Pretty.softline'(_30929604,_30929610,_30929616):-hnf('Text.Pretty.group'('Text.Pretty.line'),_30929604,_30929610,_30929616).

'Text.Pretty.softbreak'(_30931136,_30931138,_30931140):-freeze(_30931138,'blocked_Text.Pretty.softbreak'(_30931136,_30931138,_30931140)).
'blocked_Text.Pretty.softbreak'(_30931308,_30931314,_30931320):-hnf('Text.Pretty.group'('Text.Pretty.linebreak'),_30931308,_30931314,_30931320).

'Text.Pretty.group'(_30932724,_30932726,_30932728,_30932730):-freeze(_30932728,'blocked_Text.Pretty.group'(_30932724,_30932726,_30932728,_30932730)).
'blocked_Text.Pretty.group'(_30932810,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenGroup','Prelude..'('Text.PrettyImpl.deDoc'(_30932810),'Text.PrettyImpl.CloseGroup'))),_30933336,_30933336).

'Text.Pretty.nest'(_30935776,_30935778,_30935780,_30935782,_30935784):-freeze(_30935782,'blocked_Text.Pretty.nest'(_30935776,_30935778,_30935780,_30935782,_30935784)).
'blocked_Text.Pretty.nest'(_30935872,_30935890,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenNest'('Text.PrettyImpl.Inc'(_30935872)),'Prelude..'('Text.PrettyImpl.deDoc'(_30935890),'Text.PrettyImpl.CloseNest'))),_30936570,_30936570).

'Text.Pretty.hang'(_30939396,_30939398,_30939400,_30939402,_30939404):-freeze(_30939402,'blocked_Text.Pretty.hang'(_30939396,_30939398,_30939400,_30939402,_30939404)).
'blocked_Text.Pretty.hang'(_30939492,_30939510,_30939764,_30939770,_30939776):-hnf('Text.Pretty.align'('Text.Pretty.nest'(_30939492,_30939510)),_30939764,_30939770,_30939776).

'Text.Pretty.align'(_30941466,_30941468,_30941470,_30941472):-freeze(_30941470,'blocked_Text.Pretty.align'(_30941466,_30941468,_30941470,_30941472)).
'blocked_Text.Pretty.align'(_30941552,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenNest'('Text.PrettyImpl.Align'),'Prelude..'('Text.PrettyImpl.deDoc'(_30941552),'Text.PrettyImpl.CloseNest'))),_30942162,_30942162).

'Text.Pretty.indent'(_30944902,_30944904,_30944906,_30944908,_30944910):-freeze(_30944908,'blocked_Text.Pretty.indent'(_30944902,_30944904,_30944906,_30944908,_30944910)).
'blocked_Text.Pretty.indent'(_30944998,_30945016,_30945424,_30945430,_30945436):-makeShare(_30944998,_30945548),hnf('Text.Pretty.hang'(_30945548,'Text.Pretty.\'3C\'3E'('Text.Pretty.spaces'(_30945548),_30945016)),_30945424,_30945430,_30945436).

'Text.Pretty.combine'(_30947768,_30947770,_30947772,_30947774,_30947776,_30947778):-freeze(_30947776,'blocked_Text.Pretty.combine'(_30947768,_30947770,_30947772,_30947774,_30947776,_30947778)).
'blocked_Text.Pretty.combine'(_30947874,_30947892,_30947910,_30950912,_30950918,_30950924):-makeShare(_30947892,_30949460),hnf('Text.Pretty.isEmpty'(_30949460),_30952098,_30950918,_30952058),'blocked_Text.Pretty.combine_ComplexCase'(_30952098,_30947874,_30949460,_30947910,_30950912,_30952058,_30950924).

'blocked_Text.Pretty.combine_ComplexCase'(_30952516,_30952518,_30952520,_30952522,_30952524,_30952526,_30952528):-freeze(_30952526,freeze(_30952516,'blocked_blocked_Text.Pretty.combine_ComplexCase'(_30952516,_30952518,_30952520,_30952522,_30952524,_30952526,_30952528))).
'blocked_blocked_Text.Pretty.combine_ComplexCase'('Prelude.True',_30947874,_30949460,_30947910,_30952930,_30952936,_30952942):-hnf(_30947910,_30952930,_30952936,_30952942).
'blocked_blocked_Text.Pretty.combine_ComplexCase'('Prelude.False',_30947874,_30949460,_30947910,_30955418,_30955424,_30955430):-!,makeShare(_30947910,_30954030),hnf('Text.Pretty.isEmpty'(_30954030),_30957752,_30955424,_30957712),'blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase'(_30957752,_30947874,_30949460,_30954030,_30955418,_30957712,_30955430).

'blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase'(_30958392,_30958394,_30958396,_30958398,_30958400,_30958402,_30958404):-freeze(_30958402,freeze(_30958392,'blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase'(_30958392,_30958394,_30958396,_30958398,_30958400,_30958402,_30958404))).
'blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_30947874,_30949460,_30954030,_30958806,_30958812,_30958818):-hnf(_30949460,_30958806,_30958812,_30958818).
'blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_30947874,_30949460,_30954030,_30961160,_30961166,_30961172):-!,hnf('Prelude.otherwise',_30964718,_30961166,_30964678),'blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_30964718,_30947874,_30949460,_30954030,_30961160,_30964678,_30961172).

'blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_30965550,_30965552,_30965554,_30965556,_30965558,_30965560,_30965562):-freeze(_30965560,freeze(_30965550,'blocked_blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_30965550,_30965552,_30965554,_30965556,_30965558,_30965560,_30965562))).
'blocked_blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_30947874,_30949460,_30954030,_30965964,_30965970,_30965976):-hnf('Text.Pretty.enclose'(_30949460,_30954030,_30947874),_30965964,_30965970,_30965976).
'blocked_blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_30947874,_30949460,_30954030,_30967752,_30967758,_30967764):-!,hnf(reportFailure4PAKCS('Text.Pretty.combine',['Prelude.False']),_30967752,_30967758,_30967764).
'blocked_blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_30969556),_30947874,_30949460,_30954030,'FAIL'(_30969556),_30969570,_30969570).
'blocked_blocked_blocked_Text.Pretty.combine_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_30969646),_30947874,_30949460,_30954030,'FAIL'(_30969646),_30969660,_30969660).
'blocked_blocked_Text.Pretty.combine_ComplexCase'('FAIL'(_30969736),_30947874,_30949460,_30947910,'FAIL'(_30969736),_30969750,_30969750).

'Text.Pretty.\'3C\'3E'(_30970570,_30970572,_30970574,_30970576,_30970578):-freeze(_30970576,'blocked_Text.Pretty.\'3C\'3E'(_30970570,_30970572,_30970574,_30970576,_30970578)).
'blocked_Text.Pretty.\'3C\'3E'(_30970666,_30970684,_30973796,_30973802,_30973808):-makeShare(_30970666,_30972384),hnf('Text.Pretty.isEmpty'(_30972384),_30974932,_30973802,_30974898),'blocked_Text.Pretty.\'3C\'3E_ComplexCase'(_30974932,_30972384,_30970684,_30973796,_30974898,_30973808).

'blocked_Text.Pretty.\'3C\'3E_ComplexCase'(_30975342,_30975344,_30975346,_30975348,_30975350,_30975352):-freeze(_30975350,freeze(_30975342,'blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase'(_30975342,_30975344,_30975346,_30975348,_30975350,_30975352))).
'blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase'('Prelude.True',_30972384,_30970684,_30975746,_30975752,_30975758):-hnf(_30970684,_30975746,_30975752,_30975758).
'blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase'('Prelude.False',_30972384,_30970684,_30978082,_30978088,_30978094):-!,makeShare(_30970684,_30976734),hnf('Text.Pretty.isEmpty'(_30976734),_30980366,_30978088,_30980332),'blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase'(_30980366,_30972384,_30976734,_30978082,_30980332,_30978094).

'blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase'(_30980998,_30981000,_30981002,_30981004,_30981006,_30981008):-freeze(_30981006,freeze(_30980998,'blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase'(_30980998,_30981000,_30981002,_30981004,_30981006,_30981008))).
'blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_30972384,_30976734,_30981402,_30981408,_30981414):-hnf(_30972384,_30981402,_30981408,_30981414).
'blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_30972384,_30976734,_30983604,_30983610,_30983616):-!,hnf('Prelude.otherwise',_30987112,_30983610,_30987078),'blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_30987112,_30972384,_30976734,_30983604,_30987078,_30983616).

'blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_30987936,_30987938,_30987940,_30987942,_30987944,_30987946):-freeze(_30987944,freeze(_30987936,'blocked_blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'(_30987936,_30987938,_30987940,_30987942,_30987944,_30987946))).
'blocked_blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_30972384,_30976734,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.deDoc'(_30972384),'Text.PrettyImpl.deDoc'(_30976734))),_30988346,_30988346).
'blocked_blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_30972384,_30976734,_30990590,_30990596,_30990602):-!,hnf(reportFailure4PAKCS('Text.Pretty.\'3C\'3E',['Prelude.False']),_30990590,_30990596,_30990602).
'blocked_blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_30992308),_30972384,_30976734,'FAIL'(_30992308),_30992322,_30992322).
'blocked_blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_30992390),_30972384,_30976734,'FAIL'(_30992390),_30992404,_30992404).
'blocked_blocked_Text.Pretty.\'3C\'3E_ComplexCase'('FAIL'(_30992472),_30972384,_30970684,'FAIL'(_30992472),_30992486,_30992486).

'Text.Pretty.\'3C\'2B\'3E'(_30993364,_30993366,_30993368):-freeze(_30993366,'blocked_Text.Pretty.\'3C\'2B\'3E'(_30993364,_30993366,_30993368)).
'blocked_Text.Pretty.\'3C\'2B\'3E'(_30993536,_30993542,_30993548):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.space']),_30993536,_30993542,_30993548).

'Text.Pretty.\'24\'24'(_30994916,_30994918,_30994920):-freeze(_30994918,'blocked_Text.Pretty.\'24\'24'(_30994916,_30994918,_30994920)).
'blocked_Text.Pretty.\'24\'24'(_30995088,_30995094,_30995100):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.line']),_30995088,_30995094,_30995100).

'Text.Pretty.\'3C\'24\'2B\'24\'3E'(_30996642,_30996644,_30996646):-freeze(_30996644,'blocked_Text.Pretty.\'3C\'24\'2B\'24\'3E'(_30996642,_30996644,_30996646)).
'blocked_Text.Pretty.\'3C\'24\'2B\'24\'3E'(_30996982,_30996988,_30996994):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.\'3C\'3E'('Text.Pretty.line','Text.Pretty.linebreak')]),_30996982,_30996988,_30996994).

'Text.Pretty.\'3C\'2F\'3E'(_30998910,_30998912,_30998914):-freeze(_30998912,'blocked_Text.Pretty.\'3C\'2F\'3E'(_30998910,_30998912,_30998914)).
'blocked_Text.Pretty.\'3C\'2F\'3E'(_30999082,_30999088,_30999094):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.softline']),_30999082,_30999088,_30999094).

'Text.Pretty.\'3C\'24\'24\'3E'(_31000612,_31000614,_31000616):-freeze(_31000614,'blocked_Text.Pretty.\'3C\'24\'24\'3E'(_31000612,_31000614,_31000616)).
'blocked_Text.Pretty.\'3C\'24\'24\'3E'(_31000784,_31000790,_31000796):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.linebreak']),_31000784,_31000790,_31000796).

'Text.Pretty.\'3C\'2F\'2F\'3E'(_31002338,_31002340,_31002342):-freeze(_31002340,'blocked_Text.Pretty.\'3C\'2F\'2F\'3E'(_31002338,_31002340,_31002342)).
'blocked_Text.Pretty.\'3C\'2F\'2F\'3E'(_31002510,_31002516,_31002522):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.softbreak']),_31002510,_31002516,_31002522).

'Text.Pretty.\'3C\'24\'21\'24\'3E'(_31004130,_31004132,_31004134):-freeze(_31004132,'blocked_Text.Pretty.\'3C\'24\'21\'24\'3E'(_31004130,_31004132,_31004134)).
'blocked_Text.Pretty.\'3C\'24\'21\'24\'3E'(_31004302,_31004308,_31004314):-hnf(partcall(2,'Text.Pretty.combine',['Text.Pretty.hardline']),_31004302,_31004308,_31004314).

'Text.Pretty.compose'(_31005842,_31005844,_31005846,_31005848,_31005850):-freeze(_31005848,'blocked_Text.Pretty.compose'(_31005842,_31005844,_31005846,_31005848,_31005850)).
'blocked_Text.Pretty.compose'(_31005938,_31005956,_31007134,_31007140,_31007146):-makeShare(_31005956,_31006388),hnf(_31006388,_31008204,_31007140,_31008228),'blocked_Text.Pretty.compose_2'(_31008204,_31005938,_31008204,_31007134,_31008228,_31007146).

'blocked_Text.Pretty.compose_2'(_31008612,_31008614,_31008616,_31008618,_31008620,_31008622):-freeze(_31008620,'blocked_blocked_Text.Pretty.compose_2'(_31008612,_31008614,_31008616,_31008618,_31008620,_31008622)).
'blocked_blocked_Text.Pretty.compose_2'([],_31005938,_31006388,_31008874,_31008880,_31008886):-hnf('Text.Pretty.empty',_31008874,_31008880,_31008886).
'blocked_blocked_Text.Pretty.compose_2'([_31006172|_31006190],_31005938,_31006388,_31009674,_31009680,_31009686):-!,hnf('Prelude.foldr1'(_31005938,_31006388),_31009674,_31009680,_31009686).
'blocked_blocked_Text.Pretty.compose_2'('FAIL'(_31010614),_31005938,_31006388,'FAIL'(_31010614),_31010628,_31010628):-nonvar(_31010614).

'Text.Pretty.hsep'(_31011436,_31011438,_31011440):-freeze(_31011438,'blocked_Text.Pretty.hsep'(_31011436,_31011438,_31011440)).
'blocked_Text.Pretty.hsep'(_31011608,_31011614,_31011620):-hnf(partcall(1,'Text.Pretty.compose',['Text.Pretty.\'3C\'2B\'3E']),_31011608,_31011614,_31011620).

'Text.Pretty.vsep'(_31012974,_31012976,_31012978):-freeze(_31012976,'blocked_Text.Pretty.vsep'(_31012974,_31012976,_31012978)).
'blocked_Text.Pretty.vsep'(_31013146,_31013152,_31013158):-hnf(partcall(1,'Text.Pretty.compose',['Text.Pretty.\'24\'24']),_31013146,_31013152,_31013158).

'Text.Pretty.vsepBlank'(_31014684,_31014686,_31014688):-freeze(_31014686,'blocked_Text.Pretty.vsepBlank'(_31014684,_31014686,_31014688)).
'blocked_Text.Pretty.vsepBlank'(_31014856,_31014862,_31014868):-hnf(partcall(1,'Text.Pretty.compose',['Text.Pretty.\'3C\'24\'2B\'24\'3E']),_31014856,_31014862,_31014868).

'Text.Pretty.fillSep'(_31016402,_31016404,_31016406):-freeze(_31016404,'blocked_Text.Pretty.fillSep'(_31016402,_31016404,_31016406)).
'blocked_Text.Pretty.fillSep'(_31016574,_31016580,_31016586):-hnf(partcall(1,'Text.Pretty.compose',['Text.Pretty.\'3C\'2F\'3E']),_31016574,_31016580,_31016586).

'Text.Pretty.sep'(_31017920,_31017922,_31017924):-freeze(_31017922,'blocked_Text.Pretty.sep'(_31017920,_31017922,_31017924)).
'blocked_Text.Pretty.sep'(_31018176,_31018182,_31018188):-hnf('Prelude..'(partcall(1,'Text.Pretty.group',[]),'Text.Pretty.vsep'),_31018176,_31018182,_31018188).

'Text.Pretty.hcat'(_31019694,_31019696,_31019698):-freeze(_31019696,'blocked_Text.Pretty.hcat'(_31019694,_31019696,_31019698)).
'blocked_Text.Pretty.hcat'(_31019866,_31019872,_31019878):-hnf(partcall(1,'Text.Pretty.compose',[partcall(2,'Text.Pretty.\'3C\'3E',[])]),_31019866,_31019872,_31019878).

'Text.Pretty.vcat'(_31021218,_31021220,_31021222):-freeze(_31021220,'blocked_Text.Pretty.vcat'(_31021218,_31021220,_31021222)).
'blocked_Text.Pretty.vcat'(_31021390,_31021396,_31021402):-hnf(partcall(1,'Text.Pretty.compose',['Text.Pretty.\'3C\'24\'24\'3E']),_31021390,_31021396,_31021402).

'Text.Pretty.fillCat'(_31022888,_31022890,_31022892):-freeze(_31022890,'blocked_Text.Pretty.fillCat'(_31022888,_31022890,_31022892)).
'blocked_Text.Pretty.fillCat'(_31023060,_31023066,_31023072):-hnf(partcall(1,'Text.Pretty.compose',['Text.Pretty.\'3C\'2F\'2F\'3E']),_31023060,_31023066,_31023072).

'Text.Pretty.cat'(_31024424,_31024426,_31024428):-freeze(_31024426,'blocked_Text.Pretty.cat'(_31024424,_31024426,_31024428)).
'blocked_Text.Pretty.cat'(_31024680,_31024686,_31024692):-hnf('Prelude..'(partcall(1,'Text.Pretty.group',[]),'Text.Pretty.vcat'),_31024680,_31024686,_31024692).

'Text.Pretty.punctuate'(_31026388,_31026390,_31026392,_31026394,_31026396):-freeze(_31026394,'blocked_Text.Pretty.punctuate'(_31026388,_31026390,_31026392,_31026394,_31026396)).
'blocked_Text.Pretty.punctuate'(_31026484,_31026502,_31026672,_31026678,_31026684):-hnf('Text.Pretty.punctuate.go.82'(_31026484,_31026502),_31026672,_31026678,_31026684).

'Text.Pretty.punctuate.go.82'(_31028638,_31028640,_31028642,_31028644,_31028646):-freeze(_31028644,'blocked_Text.Pretty.punctuate.go.82'(_31028638,_31028640,_31028642,_31028644,_31028646)).
'blocked_Text.Pretty.punctuate.go.82'(_31028734,_31028752,_31030136,_31030142,_31030148):-hnf(_31028752,_31031494,_31030142,_31031512),'blocked_Text.Pretty.punctuate.go.82_2'(_31031494,_31028734,_31030136,_31031512,_31030148).

'blocked_Text.Pretty.punctuate.go.82_2'(_31031924,_31031926,_31031928,_31031930,_31031932):-freeze(_31031930,'blocked_blocked_Text.Pretty.punctuate.go.82_2'(_31031924,_31031926,_31031928,_31031930,_31031932)).
'blocked_blocked_Text.Pretty.punctuate.go.82_2'([],_31028734,[],_31032182,_31032182).
'blocked_blocked_Text.Pretty.punctuate.go.82_2'([_31028968|_31028986],_31028734,_31033828,_31033834,_31033840):-!,makeShare(_31028986,_31032836),hnf(_31032836,_31035666,_31033834,_31035696),'blocked_blocked_Text.Pretty.punctuate.go.82_2_[|]_2'(_31035666,_31028968,_31035666,_31028734,_31033828,_31035696,_31033840).

'blocked_blocked_Text.Pretty.punctuate.go.82_2_[|]_2'(_31036238,_31036240,_31036242,_31036244,_31036246,_31036248,_31036250):-freeze(_31036248,'blocked_blocked_blocked_Text.Pretty.punctuate.go.82_2_[|]_2'(_31036238,_31036240,_31036242,_31036244,_31036246,_31036248,_31036250)).
'blocked_blocked_blocked_Text.Pretty.punctuate.go.82_2_[|]_2'([],_31028968,_31032836,_31028734,[_31028968],_31036516,_31036516).
'blocked_blocked_blocked_Text.Pretty.punctuate.go.82_2_[|]_2'([_31029368|_31029386],_31028968,_31032836,_31028734,['Text.Pretty.\'3C\'3E'(_31028968,_31037784)|'Text.Pretty.punctuate.go.82'(_31037784,_31032836)],_31037600,_31037606):-!,makeShare(_31028734,_31037784),_31037600=_31037606.
'blocked_blocked_blocked_Text.Pretty.punctuate.go.82_2_[|]_2'('FAIL'(_31039600),_31028968,_31032836,_31028734,'FAIL'(_31039600),_31039614,_31039614):-nonvar(_31039600).
'blocked_blocked_Text.Pretty.punctuate.go.82_2'('FAIL'(_31039694),_31028734,'FAIL'(_31039694),_31039708,_31039708):-nonvar(_31039694).

'Text.Pretty.encloseSep'(_31040736,_31040738,_31040740,_31040742,_31040744,_31040746,_31040748):-freeze(_31040746,'blocked_Text.Pretty.encloseSep'(_31040736,_31040738,_31040740,_31040742,_31040744,_31040746,_31040748)).
'blocked_Text.Pretty.encloseSep'(_31040852,_31040870,_31040888,_31040906,_31042416,_31042422,_31042428):-hnf(_31040906,_31043610,_31042422,_31043640),'blocked_Text.Pretty.encloseSep_4'(_31043610,_31040852,_31040870,_31040888,_31042416,_31043640,_31042428).

'blocked_Text.Pretty.encloseSep_4'(_31044038,_31044040,_31044042,_31044044,_31044046,_31044048,_31044050):-freeze(_31044048,'blocked_blocked_Text.Pretty.encloseSep_4'(_31044038,_31044040,_31044042,_31044044,_31044046,_31044048,_31044050)).
'blocked_blocked_Text.Pretty.encloseSep_4'([],_31040852,_31040870,_31040888,_31044310,_31044316,_31044322):-hnf('Text.Pretty.\'3C\'3E'(_31040852,_31040870),_31044310,_31044316,_31044322).
'blocked_blocked_Text.Pretty.encloseSep_4'([_31041262|_31041280],_31040852,_31040870,_31040888,_31045406,_31045412,_31045418):-!,hnf('Text.Pretty.align'('Text.Pretty.enclose'(_31040852,_31040870,'Prelude.apply'('Text.Pretty.cat',[_31041262|'Prelude.map'(partcall(1,'Text.Pretty.\'3C\'3E',[_31040888]),_31041280)]))),_31045406,_31045412,_31045418).
'blocked_blocked_Text.Pretty.encloseSep_4'('FAIL'(_31047960),_31040852,_31040870,_31040888,'FAIL'(_31047960),_31047974,_31047974):-nonvar(_31047960).

'Text.Pretty.encloseSepSpaced'(_31049246,_31049248,_31049250,_31049252,_31049254,_31049256):-freeze(_31049254,'blocked_Text.Pretty.encloseSepSpaced'(_31049246,_31049248,_31049250,_31049252,_31049254,_31049256)).
'blocked_Text.Pretty.encloseSepSpaced'(_31049352,_31049370,_31049388,_31050132,_31050138,_31050144):-hnf(partcall(1,'Text.Pretty.encloseSep',['Text.Pretty.\'3C\'3E'(_31049388,'Text.Pretty.space'),'Text.Pretty.\'3C\'3E'('Text.Pretty.space',_31049370),'Text.Pretty.\'3C\'3E'(_31049352,'Text.Pretty.space')]),_31050132,_31050138,_31050144).

'Text.Pretty.hEncloseSep'(_31053446,_31053448,_31053450,_31053452,_31053454,_31053456,_31053458):-freeze(_31053456,'blocked_Text.Pretty.hEncloseSep'(_31053446,_31053448,_31053450,_31053452,_31053454,_31053456,_31053458)).
'blocked_Text.Pretty.hEncloseSep'(_31053562,_31053580,_31053598,_31053616,_31055132,_31055138,_31055144):-hnf(_31053616,_31056362,_31055138,_31056392),'blocked_Text.Pretty.hEncloseSep_4'(_31056362,_31053562,_31053580,_31053598,_31055132,_31056392,_31055144).

'blocked_Text.Pretty.hEncloseSep_4'(_31056796,_31056798,_31056800,_31056802,_31056804,_31056806,_31056808):-freeze(_31056806,'blocked_blocked_Text.Pretty.hEncloseSep_4'(_31056796,_31056798,_31056800,_31056802,_31056804,_31056806,_31056808)).
'blocked_blocked_Text.Pretty.hEncloseSep_4'([],_31053562,_31053580,_31053598,_31057068,_31057074,_31057080):-hnf('Text.Pretty.\'3C\'3E'(_31053562,_31053580),_31057068,_31057074,_31057080).
'blocked_blocked_Text.Pretty.hEncloseSep_4'([_31053972|_31053990],_31053562,_31053580,_31053598,_31058170,_31058176,_31058182):-!,hnf('Text.Pretty.align'('Text.Pretty.enclose'(_31053562,_31053580,'Prelude.apply'('Text.Pretty.hcat',[_31053972|'Prelude.map'(partcall(1,'Text.Pretty.\'3C\'3E',[_31053598]),_31053990)]))),_31058170,_31058176,_31058182).
'blocked_blocked_Text.Pretty.hEncloseSep_4'('FAIL'(_31060736),_31053562,_31053580,_31053598,'FAIL'(_31060736),_31060750,_31060750):-nonvar(_31060736).

'Text.Pretty.fillEncloseSep'(_31061946,_31061948,_31061950,_31061952,_31061954,_31061956,_31061958):-freeze(_31061956,'blocked_Text.Pretty.fillEncloseSep'(_31061946,_31061948,_31061950,_31061952,_31061954,_31061956,_31061958)).
'blocked_Text.Pretty.fillEncloseSep'(_31062062,_31062080,_31062098,_31062116,_31063650,_31063656,_31063662):-hnf(_31062116,_31064988,_31063656,_31065018),'blocked_Text.Pretty.fillEncloseSep_4'(_31064988,_31062062,_31062080,_31062098,_31063650,_31065018,_31063662).

'blocked_Text.Pretty.fillEncloseSep_4'(_31065440,_31065442,_31065444,_31065446,_31065448,_31065450,_31065452):-freeze(_31065450,'blocked_blocked_Text.Pretty.fillEncloseSep_4'(_31065440,_31065442,_31065444,_31065446,_31065448,_31065450,_31065452)).
'blocked_blocked_Text.Pretty.fillEncloseSep_4'([],_31062062,_31062080,_31062098,_31065712,_31065718,_31065724):-hnf('Text.Pretty.\'3C\'3E'(_31062062,_31062080),_31065712,_31065718,_31065724).
'blocked_blocked_Text.Pretty.fillEncloseSep_4'([_31062472|_31062490],_31062062,_31062080,_31062098,_31066832,_31066838,_31066844):-!,hnf('Text.Pretty.align'('Text.Pretty.enclose'(_31062062,_31062080,'Prelude.apply'('Text.Pretty.fillCat',[_31062472|'Prelude.map'(partcall(1,'Text.Pretty.\'3C\'3E',[_31062098]),_31062490)]))),_31066832,_31066838,_31066844).
'blocked_blocked_Text.Pretty.fillEncloseSep_4'('FAIL'(_31069434),_31062062,_31062080,_31062098,'FAIL'(_31069434),_31069448,_31069448):-nonvar(_31069434).

'Text.Pretty.fillEncloseSepSpaced'(_31070872,_31070874,_31070876,_31070878,_31070880,_31070882):-freeze(_31070880,'blocked_Text.Pretty.fillEncloseSepSpaced'(_31070872,_31070874,_31070876,_31070878,_31070880,_31070882)).
'blocked_Text.Pretty.fillEncloseSepSpaced'(_31070978,_31070996,_31071014,_31071758,_31071764,_31071770):-hnf(partcall(1,'Text.Pretty.fillEncloseSep',['Text.Pretty.\'3C\'3E'(_31071014,'Text.Pretty.space'),'Text.Pretty.\'3C\'3E'('Text.Pretty.space',_31070996),'Text.Pretty.\'3C\'3E'(_31070978,'Text.Pretty.space')]),_31071758,_31071764,_31071770).

'Text.Pretty.list'(_31074854,_31074856,_31074858):-freeze(_31074856,'blocked_Text.Pretty.list'(_31074854,_31074856,_31074858)).
'blocked_Text.Pretty.list'(_31075194,_31075200,_31075206):-hnf(partcall(1,'Text.Pretty.encloseSep',['Text.Pretty.comma','Text.Pretty.rbracket','Text.Pretty.lbracket']),_31075194,_31075200,_31075206).

'Text.Pretty.listSpaced'(_31077246,_31077248,_31077250):-freeze(_31077248,'blocked_Text.Pretty.listSpaced'(_31077246,_31077248,_31077250)).
'blocked_Text.Pretty.listSpaced'(_31077586,_31077592,_31077598):-hnf('Text.Pretty.encloseSepSpaced'('Text.Pretty.lbracket','Text.Pretty.rbracket','Text.Pretty.comma'),_31077586,_31077592,_31077598).

'Text.Pretty.set'(_31079430,_31079432,_31079434):-freeze(_31079432,'blocked_Text.Pretty.set'(_31079430,_31079432,_31079434)).
'blocked_Text.Pretty.set'(_31079770,_31079776,_31079782):-hnf(partcall(1,'Text.Pretty.encloseSep',['Text.Pretty.comma','Text.Pretty.rbrace','Text.Pretty.lbrace']),_31079770,_31079776,_31079782).

'Text.Pretty.setSpaced'(_31081754,_31081756,_31081758):-freeze(_31081756,'blocked_Text.Pretty.setSpaced'(_31081754,_31081756,_31081758)).
'blocked_Text.Pretty.setSpaced'(_31082094,_31082100,_31082106):-hnf('Text.Pretty.encloseSepSpaced'('Text.Pretty.lbrace','Text.Pretty.rbrace','Text.Pretty.comma'),_31082094,_31082100,_31082106).

'Text.Pretty.tupled'(_31084022,_31084024,_31084026):-freeze(_31084024,'blocked_Text.Pretty.tupled'(_31084022,_31084024,_31084026)).
'blocked_Text.Pretty.tupled'(_31084362,_31084368,_31084374):-hnf(partcall(1,'Text.Pretty.encloseSep',['Text.Pretty.comma','Text.Pretty.rparen','Text.Pretty.lparen']),_31084362,_31084368,_31084374).

'Text.Pretty.tupledSpaced'(_31086478,_31086480,_31086482):-freeze(_31086480,'blocked_Text.Pretty.tupledSpaced'(_31086478,_31086480,_31086482)).
'blocked_Text.Pretty.tupledSpaced'(_31086818,_31086824,_31086830):-hnf('Text.Pretty.encloseSepSpaced'('Text.Pretty.lparen','Text.Pretty.rparen','Text.Pretty.comma'),_31086818,_31086824,_31086830).

'Text.Pretty.semiBraces'(_31088916,_31088918,_31088920):-freeze(_31088918,'blocked_Text.Pretty.semiBraces'(_31088916,_31088918,_31088920)).
'blocked_Text.Pretty.semiBraces'(_31089256,_31089262,_31089268):-hnf(partcall(1,'Text.Pretty.encloseSep',['Text.Pretty.semi','Text.Pretty.rbrace','Text.Pretty.lbrace']),_31089256,_31089262,_31089268).

'Text.Pretty.semiBracesSpaced'(_31091542,_31091544,_31091546):-freeze(_31091544,'blocked_Text.Pretty.semiBracesSpaced'(_31091542,_31091544,_31091546)).
'blocked_Text.Pretty.semiBracesSpaced'(_31091882,_31091888,_31091894):-hnf('Text.Pretty.encloseSepSpaced'('Text.Pretty.lbrace','Text.Pretty.rbrace','Text.Pretty.semi'),_31091882,_31091888,_31091894).

'Text.Pretty.enclose'(_31093884,_31093886,_31093888,_31093890,_31093892,_31093894):-freeze(_31093892,'blocked_Text.Pretty.enclose'(_31093884,_31093886,_31093888,_31093890,_31093892,_31093894)).
'blocked_Text.Pretty.enclose'(_31093990,_31094008,_31094026,_31094350,_31094356,_31094362):-hnf('Text.Pretty.\'3C\'3E'('Text.Pretty.\'3C\'3E'(_31093990,_31094026),_31094008),_31094350,_31094356,_31094362).

'Text.Pretty.squotes'(_31096354,_31096356,_31096358):-freeze(_31096356,'blocked_Text.Pretty.squotes'(_31096354,_31096356,_31096358)).
'blocked_Text.Pretty.squotes'(_31096610,_31096616,_31096622):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.squote','Text.Pretty.squote']),_31096610,_31096616,_31096622).

'Text.Pretty.dquotes'(_31098310,_31098312,_31098314):-freeze(_31098312,'blocked_Text.Pretty.dquotes'(_31098310,_31098312,_31098314)).
'blocked_Text.Pretty.dquotes'(_31098566,_31098572,_31098578):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.dquote','Text.Pretty.dquote']),_31098566,_31098572,_31098578).

'Text.Pretty.bquotes'(_31100266,_31100268,_31100270):-freeze(_31100268,'blocked_Text.Pretty.bquotes'(_31100266,_31100268,_31100270)).
'blocked_Text.Pretty.bquotes'(_31100522,_31100528,_31100534):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.bquote','Text.Pretty.bquote']),_31100522,_31100528,_31100534).

'Text.Pretty.parens'(_31102184,_31102186,_31102188):-freeze(_31102186,'blocked_Text.Pretty.parens'(_31102184,_31102186,_31102188)).
'blocked_Text.Pretty.parens'(_31102440,_31102446,_31102452):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.rparen','Text.Pretty.lparen']),_31102440,_31102446,_31102452).

'Text.Pretty.parensIf'(_31104172,_31104174,_31104176,_31104178,_31104180):-freeze(_31104178,'blocked_Text.Pretty.parensIf'(_31104172,_31104174,_31104176,_31104178,_31104180)).
'blocked_Text.Pretty.parensIf'(_31104268,_31104286,_31104858,_31104864,_31104870):-hnf(_31104268,_31105964,_31104864,_31105982),'blocked_Text.Pretty.parensIf_1'(_31105964,_31104286,_31104858,_31105982,_31104870).

'blocked_Text.Pretty.parensIf_1'(_31106358,_31106360,_31106362,_31106364,_31106366):-freeze(_31106364,freeze(_31106358,'blocked_blocked_Text.Pretty.parensIf_1'(_31106358,_31106360,_31106362,_31106364,_31106366))).
'blocked_blocked_Text.Pretty.parensIf_1'('Prelude.True',_31104286,_31106752,_31106758,_31106764):-hnf('Prelude.apply'('Text.Pretty.parens',_31104286),_31106752,_31106758,_31106764).
'blocked_blocked_Text.Pretty.parensIf_1'('Prelude.False',_31104286,_31107890,_31107896,_31107902):-!,hnf(_31104286,_31107890,_31107896,_31107902).
'blocked_blocked_Text.Pretty.parensIf_1'('FAIL'(_31108332),_31104286,'FAIL'(_31108332),_31108346,_31108346).

'Text.Pretty.angles'(_31109218,_31109220,_31109222):-freeze(_31109220,'blocked_Text.Pretty.angles'(_31109218,_31109220,_31109222)).
'blocked_Text.Pretty.angles'(_31109474,_31109480,_31109486):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.rangle','Text.Pretty.langle']),_31109474,_31109480,_31109486).

'Text.Pretty.braces'(_31111130,_31111132,_31111134):-freeze(_31111132,'blocked_Text.Pretty.braces'(_31111130,_31111132,_31111134)).
'blocked_Text.Pretty.braces'(_31111386,_31111392,_31111398):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.rbrace','Text.Pretty.lbrace']),_31111386,_31111392,_31111398).

'Text.Pretty.brackets'(_31113118,_31113120,_31113122):-freeze(_31113120,'blocked_Text.Pretty.brackets'(_31113118,_31113120,_31113122)).
'blocked_Text.Pretty.brackets'(_31113374,_31113380,_31113386):-hnf(partcall(1,'Text.Pretty.enclose',['Text.Pretty.rbracket','Text.Pretty.lbracket']),_31113374,_31113380,_31113386).

'Text.Pretty.bool'(_31114990,_31114992,_31114994,_31114996):-freeze(_31114994,'blocked_Text.Pretty.bool'(_31114990,_31114992,_31114994,_31114996)).
'blocked_Text.Pretty.bool'(_31115076,_31115344,_31115350,_31115356):-hnf('Text.Pretty.text'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Bool\'23',_31115076)),_31115344,_31115350,_31115356).

'Text.Pretty.char'(_31117236,_31117238,_31117240,_31117242):-freeze(_31117240,'blocked_Text.Pretty.char'(_31117236,_31117238,_31117240,_31117242)).
'blocked_Text.Pretty.char'(_31117322,_31117590,_31117596,_31117602):-hnf('Text.Pretty.text'([_31117322]),_31117590,_31117596,_31117602).

'Text.Pretty.string'(_31119154,_31119156,_31119158):-freeze(_31119156,'blocked_Text.Pretty.string'(_31119154,_31119156,_31119158)).
'blocked_Text.Pretty.string'(_31119494,_31119500,_31119506):-hnf('Prelude..'('Text.Pretty.hcat',partcall(1,'Prelude.map',[partcall(1,'Text.Pretty.string._\'23lambda2',[])])),_31119494,_31119500,_31119506).

'Text.Pretty.string._\'23lambda2'(_31121774,_31121776,_31121778,_31121780):-freeze(_31121778,'blocked_Text.Pretty.string._\'23lambda2'(_31121774,_31121776,_31121778,_31121780)).
'blocked_Text.Pretty.string._\'23lambda2'(_31121860,_31124880,_31124886,_31124892):-makeShare(_31121860,_31122884),hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_31122884),['^010','^013']),_31126434,_31124886,_31126406),'blocked_Text.Pretty.string._\'23lambda2_ComplexCase'(_31126434,_31122884,_31124880,_31126406,_31124892).

'blocked_Text.Pretty.string._\'23lambda2_ComplexCase'(_31126914,_31126916,_31126918,_31126920,_31126922):-freeze(_31126920,freeze(_31126914,'blocked_blocked_Text.Pretty.string._\'23lambda2_ComplexCase'(_31126914,_31126916,_31126918,_31126920,_31126922))).
'blocked_blocked_Text.Pretty.string._\'23lambda2_ComplexCase'('Prelude.True',_31122884,_31127308,_31127314,_31127320):-hnf('Text.Pretty.line',_31127308,_31127314,_31127320).
'blocked_blocked_Text.Pretty.string._\'23lambda2_ComplexCase'('Prelude.False',_31122884,_31128274,_31128280,_31128286):-!,hnf('Text.Pretty.char'(_31122884),_31128274,_31128280,_31128286).
'blocked_blocked_Text.Pretty.string._\'23lambda2_ComplexCase'('FAIL'(_31129042),_31122884,'FAIL'(_31129042),_31129056,_31129056).

'Text.Pretty.int'(_31129814,_31129816,_31129818,_31129820):-freeze(_31129818,'blocked_Text.Pretty.int'(_31129814,_31129816,_31129818,_31129820)).
'blocked_Text.Pretty.int'(_31129900,_31130168,_31130174,_31130180):-hnf('Text.Pretty.text'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_31129900)),_31130168,_31130174,_31130180).

'Text.Pretty.float'(_31132086,_31132088,_31132090,_31132092):-freeze(_31132090,'blocked_Text.Pretty.float'(_31132086,_31132088,_31132090,_31132092)).
'blocked_Text.Pretty.float'(_31132172,_31132440,_31132446,_31132452):-hnf('Text.Pretty.text'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Float\'23',_31132172)),_31132440,_31132446,_31132452).

'Text.Pretty.lparen'(_31134420,_31134422,_31134424):-freeze(_31134422,'blocked_Text.Pretty.lparen'(_31134420,_31134422,_31134424)).
'blocked_Text.Pretty.lparen'(_31134578,_31134584,_31134590):-hnf('Text.Pretty.char'('^('),_31134578,_31134584,_31134590).

'Text.Pretty.rparen'(_31135866,_31135868,_31135870):-freeze(_31135868,'blocked_Text.Pretty.rparen'(_31135866,_31135868,_31135870)).
'blocked_Text.Pretty.rparen'(_31136024,_31136030,_31136036):-hnf('Text.Pretty.char'('^)'),_31136024,_31136030,_31136036).

'Text.Pretty.langle'(_31137312,_31137314,_31137316):-freeze(_31137314,'blocked_Text.Pretty.langle'(_31137312,_31137314,_31137316)).
'blocked_Text.Pretty.langle'(_31137470,_31137476,_31137482):-hnf('Text.Pretty.char'(^<),_31137470,_31137476,_31137482).

'Text.Pretty.rangle'(_31138758,_31138760,_31138762):-freeze(_31138760,'blocked_Text.Pretty.rangle'(_31138758,_31138760,_31138762)).
'blocked_Text.Pretty.rangle'(_31138916,_31138922,_31138928):-hnf('Text.Pretty.char'(^>),_31138916,_31138922,_31138928).

'Text.Pretty.lbrace'(_31140204,_31140206,_31140208):-freeze(_31140206,'blocked_Text.Pretty.lbrace'(_31140204,_31140206,_31140208)).
'blocked_Text.Pretty.lbrace'(_31140362,_31140368,_31140374):-hnf('Text.Pretty.char'('^{'),_31140362,_31140368,_31140374).

'Text.Pretty.rbrace'(_31141650,_31141652,_31141654):-freeze(_31141652,'blocked_Text.Pretty.rbrace'(_31141650,_31141652,_31141654)).
'blocked_Text.Pretty.rbrace'(_31141808,_31141814,_31141820):-hnf('Text.Pretty.char'('^}'),_31141808,_31141814,_31141820).

'Text.Pretty.lbracket'(_31143172,_31143174,_31143176):-freeze(_31143174,'blocked_Text.Pretty.lbracket'(_31143172,_31143174,_31143176)).
'blocked_Text.Pretty.lbracket'(_31143330,_31143336,_31143342):-hnf('Text.Pretty.char'('^['),_31143330,_31143336,_31143342).

'Text.Pretty.rbracket'(_31144706,_31144708,_31144710):-freeze(_31144708,'blocked_Text.Pretty.rbracket'(_31144706,_31144708,_31144710)).
'blocked_Text.Pretty.rbracket'(_31144864,_31144870,_31144876):-hnf('Text.Pretty.char'('^]'),_31144864,_31144870,_31144876).

'Text.Pretty.squote'(_31146164,_31146166,_31146168):-freeze(_31146166,'blocked_Text.Pretty.squote'(_31146164,_31146166,_31146168)).
'blocked_Text.Pretty.squote'(_31146322,_31146328,_31146334):-hnf('Text.Pretty.char'('^\''),_31146322,_31146328,_31146334).

'Text.Pretty.dquote'(_31147610,_31147612,_31147614):-freeze(_31147612,'blocked_Text.Pretty.dquote'(_31147610,_31147612,_31147614)).
'blocked_Text.Pretty.dquote'(_31147768,_31147774,_31147780):-hnf('Text.Pretty.char'('^"'),_31147768,_31147774,_31147780).

'Text.Pretty.bquote'(_31149056,_31149058,_31149060):-freeze(_31149058,'blocked_Text.Pretty.bquote'(_31149056,_31149058,_31149060)).
'blocked_Text.Pretty.bquote'(_31149214,_31149220,_31149226):-hnf('Text.Pretty.char'('^096'),_31149214,_31149220,_31149226).

'Text.Pretty.semi'(_31150438,_31150440,_31150442):-freeze(_31150440,'blocked_Text.Pretty.semi'(_31150438,_31150440,_31150442)).
'blocked_Text.Pretty.semi'(_31150596,_31150602,_31150608):-hnf('Text.Pretty.char'('^;'),_31150596,_31150602,_31150608).

'Text.Pretty.colon'(_31151834,_31151836,_31151838):-freeze(_31151836,'blocked_Text.Pretty.colon'(_31151834,_31151836,_31151838)).
'blocked_Text.Pretty.colon'(_31151992,_31151998,_31152004):-hnf('Text.Pretty.char'(^:),_31151992,_31151998,_31152004).

'Text.Pretty.comma'(_31153236,_31153238,_31153240):-freeze(_31153238,'blocked_Text.Pretty.comma'(_31153236,_31153238,_31153240)).
'blocked_Text.Pretty.comma'(_31153394,_31153400,_31153406):-hnf('Text.Pretty.char'('^,'),_31153394,_31153400,_31153406).

'Text.Pretty.space'(_31154638,_31154640,_31154642):-freeze(_31154640,'blocked_Text.Pretty.space'(_31154638,_31154640,_31154642)).
'blocked_Text.Pretty.space'(_31154796,_31154802,_31154808):-hnf('Text.Pretty.char'('^ '),_31154796,_31154802,_31154808).

'Text.Pretty.spaces'(_31156078,_31156080,_31156082,_31156084):-freeze(_31156082,'blocked_Text.Pretty.spaces'(_31156078,_31156080,_31156082,_31156084)).
'blocked_Text.Pretty.spaces'(_31156164,_31158936,_31158942,_31158948):-makeShare(_31156164,_31157498),hnf('Prelude._impl\'23\'3C\'3D\'23Prelude.Ord\'23Prelude.Int\'23'(_31157498,0),_31160058,_31158942,_31160030),'blocked_Text.Pretty.spaces_ComplexCase'(_31160058,_31157498,_31158936,_31160030,_31158948).

'blocked_Text.Pretty.spaces_ComplexCase'(_31160466,_31160468,_31160470,_31160472,_31160474):-freeze(_31160472,freeze(_31160466,'blocked_blocked_Text.Pretty.spaces_ComplexCase'(_31160466,_31160468,_31160470,_31160472,_31160474))).
'blocked_blocked_Text.Pretty.spaces_ComplexCase'('Prelude.True',_31157498,_31160860,_31160866,_31160872):-hnf('Text.Pretty.empty',_31160860,_31160866,_31160872).
'blocked_blocked_Text.Pretty.spaces_ComplexCase'('Prelude.False',_31157498,_31162592,_31162598,_31162604):-!,hnf('Prelude.otherwise',_31164862,_31162598,_31164834),'blocked_blocked_Text.Pretty.spaces_ComplexCase_Prelude.False_ComplexCase'(_31164862,_31157498,_31162592,_31164834,_31162604).

'blocked_blocked_Text.Pretty.spaces_ComplexCase_Prelude.False_ComplexCase'(_31165480,_31165482,_31165484,_31165486,_31165488):-freeze(_31165486,freeze(_31165480,'blocked_blocked_blocked_Text.Pretty.spaces_ComplexCase_Prelude.False_ComplexCase'(_31165480,_31165482,_31165484,_31165486,_31165488))).
'blocked_blocked_blocked_Text.Pretty.spaces_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_31157498,_31165874,_31165880,_31165886):-hnf('Prelude.$'(partcall(1,'Text.Pretty.text',[]),'Prelude.replicate'(_31157498,'^ ')),_31165874,_31165880,_31165886).
'blocked_blocked_blocked_Text.Pretty.spaces_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_31157498,_31167576,_31167582,_31167588):-!,hnf(reportFailure4PAKCS('Text.Pretty.spaces',['Prelude.False']),_31167576,_31167582,_31167588).
'blocked_blocked_blocked_Text.Pretty.spaces_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_31169016),_31157498,'FAIL'(_31169016),_31169030,_31169030).
'blocked_blocked_Text.Pretty.spaces_ComplexCase'('FAIL'(_31169090),_31157498,'FAIL'(_31169090),_31169104,_31169104).

'Text.Pretty.dot'(_31169862,_31169864,_31169866):-freeze(_31169864,'blocked_Text.Pretty.dot'(_31169862,_31169864,_31169866)).
'blocked_Text.Pretty.dot'(_31170020,_31170026,_31170032):-hnf('Text.Pretty.char'(^.),_31170020,_31170026,_31170032).

'Text.Pretty.backslash'(_31171404,_31171406,_31171408):-freeze(_31171406,'blocked_Text.Pretty.backslash'(_31171404,_31171406,_31171408)).
'blocked_Text.Pretty.backslash'(_31171562,_31171568,_31171574):-hnf('Text.Pretty.char'(^\),_31171562,_31171568,_31171574).

'Text.Pretty.equals'(_31172868,_31172870,_31172872):-freeze(_31172870,'blocked_Text.Pretty.equals'(_31172868,_31172870,_31172872)).
'blocked_Text.Pretty.equals'(_31173026,_31173032,_31173038):-hnf('Text.Pretty.char'(^=),_31173026,_31173032,_31173038).

'Text.Pretty.larrow'(_31174314,_31174316,_31174318):-freeze(_31174316,'blocked_Text.Pretty.larrow'(_31174314,_31174316,_31174318)).
'blocked_Text.Pretty.larrow'(_31174794,_31174800,_31174806):-hnf('Text.Pretty.text'([^<,^-]),_31174794,_31174800,_31174806).

'Text.Pretty.rarrow'(_31176498,_31176500,_31176502):-freeze(_31176500,'blocked_Text.Pretty.rarrow'(_31176498,_31176500,_31176502)).
'blocked_Text.Pretty.rarrow'(_31176978,_31176984,_31176990):-hnf('Text.Pretty.text'([^-,^>]),_31176978,_31176984,_31176990).

'Text.Pretty.doubleArrow'(_31178872,_31178874,_31178876):-freeze(_31178874,'blocked_Text.Pretty.doubleArrow'(_31178872,_31178874,_31178876)).
'blocked_Text.Pretty.doubleArrow'(_31179352,_31179358,_31179364):-hnf('Text.Pretty.text'([^=,^>]),_31179352,_31179358,_31179364).

'Text.Pretty.doubleColon'(_31181276,_31181278,_31181280):-freeze(_31181278,'blocked_Text.Pretty.doubleColon'(_31181276,_31181278,_31181280)).
'blocked_Text.Pretty.doubleColon'(_31181756,_31181762,_31181768):-hnf('Text.Pretty.text'([^:,^:]),_31181756,_31181762,_31181768).

'Text.Pretty.bar'(_31183376,_31183378,_31183380):-freeze(_31183378,'blocked_Text.Pretty.bar'(_31183376,_31183378,_31183380)).
'blocked_Text.Pretty.bar'(_31183534,_31183540,_31183546):-hnf('Text.Pretty.char'('^|'),_31183534,_31183540,_31183546).

'Text.Pretty.at'(_31184652,_31184654,_31184656):-freeze(_31184654,'blocked_Text.Pretty.at'(_31184652,_31184654,_31184656)).
'blocked_Text.Pretty.at'(_31184810,_31184816,_31184822):-hnf('Text.Pretty.char'(^@),_31184810,_31184816,_31184822).

'Text.Pretty.tilde'(_31186036,_31186038,_31186040):-freeze(_31186038,'blocked_Text.Pretty.tilde'(_31186036,_31186038,_31186040)).
'blocked_Text.Pretty.tilde'(_31186194,_31186200,_31186206):-hnf('Text.Pretty.char'(^~),_31186194,_31186200,_31186206).

'Text.Pretty.fill'(_31187400,_31187402,_31187404,_31187406,_31187408):-freeze(_31187406,'blocked_Text.Pretty.fill'(_31187400,_31187402,_31187404,_31187406,_31187408)).
'blocked_Text.Pretty.fill'(_31187496,_31187514,_31188988,_31188994,_31189000):-makeShare(_31187542,_31189342),makeShare(_31187514,_31189362),makeShare(_31187560,_31189382),makeShare(_31187496,_31189402),hnf('Prelude.cond'(letrec4PAKCS(_31189342,'Text.Pretty.width'(_31189362)),'Prelude.cond'(letrec4PAKCS(_31189382,'Text.Pretty.fill._\'23caseor0'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23',_31189342),_31189402),_31189402,_31189342)),'Text.Pretty.\'3C\'3E'(_31189362,_31189382))),_31188988,_31188994,_31189000).

'Text.Pretty.fillBreak'(_31194552,_31194554,_31194556,_31194558,_31194560):-freeze(_31194558,'blocked_Text.Pretty.fillBreak'(_31194552,_31194554,_31194556,_31194558,_31194560)).
'blocked_Text.Pretty.fillBreak'(_31194648,_31194666,_31196140,_31196146,_31196152):-makeShare(_31194694,_31196494),makeShare(_31194666,_31196514),makeShare(_31194712,_31196534),makeShare(_31194648,_31196554),hnf('Prelude.cond'(letrec4PAKCS(_31196494,'Text.Pretty.width'(_31196514)),'Prelude.cond'(letrec4PAKCS(_31196534,'Text.Pretty.fillBreak._\'23caseor0'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3D\'23Prelude.Ord\'23Prelude.Int\'23',_31196494),_31196554),_31196554,_31196494)),'Text.Pretty.\'3C\'3E'(_31196514,_31196534))),_31196140,_31196146,_31196152).

'Text.Pretty.width'(_31201612,_31201614,_31201616,_31201618):-freeze(_31201616,'blocked_Text.Pretty.width'(_31201612,_31201614,_31201616,_31201618)).
'blocked_Text.Pretty.width'(_31201698,_31202344,_31202350,_31202356):-hnf(_31201698,_31203334,_31202350,_31203346),'blocked_Text.Pretty.width_1'(_31203334,_31202344,_31203346,_31202356).

'blocked_Text.Pretty.width_1'(_31203690,_31203692,_31203694,_31203696):-freeze(_31203694,'blocked_blocked_Text.Pretty.width_1'(_31203690,_31203692,_31203694,_31203696)).
'blocked_blocked_Text.Pretty.width_1'('Text.PrettyImpl.Doc'(_31201814),_31204162,_31204168,_31204174):-!,hnf('Text.Pretty.width.width\'27.216'(0,'Prelude.apply'(_31201814,'Text.PrettyImpl.EOD')),_31204162,_31204168,_31204174).
'blocked_blocked_Text.Pretty.width_1'('FAIL'(_31205358),'FAIL'(_31205358),_31205372,_31205372):-nonvar(_31205358).

'Text.Pretty.width.width\'27.216'(_31206648,_31206650,_31206652,_31206654,_31206656):-freeze(_31206654,'blocked_Text.Pretty.width.width\'27.216'(_31206648,_31206650,_31206652,_31206654,_31206656)).
'blocked_Text.Pretty.width.width\'27.216'(_31206744,_31206762,_31210632,_31210638,_31210644):-hnf(_31206762,_31212098,_31210638,_31212116),'blocked_Text.Pretty.width.width\'27.216_2'(_31212098,_31206744,_31210632,_31212116,_31210644).

'blocked_Text.Pretty.width.width\'27.216_2'(_31212546,_31212548,_31212550,_31212552,_31212554):-freeze(_31212552,'blocked_blocked_Text.Pretty.width.width\'27.216_2'(_31212546,_31212548,_31212550,_31212552,_31212554)).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.EOD',_31206744,_31213018,_31213024,_31213030):-hnf(_31206744,_31213018,_31213024,_31213030).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.Empty'(_31206964),_31206744,_31213918,_31213924,_31213930):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31206964),_31213918,_31213924,_31213930).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.Text'(_31207228,_31207246),_31206744,_31215274,_31215280,_31215286):-hnf('Text.Pretty.width.width\'27.216'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31206744,'Prelude.apply'('Text.PrettyImpl.lengthVis',_31207228)),_31207246),_31215274,_31215280,_31215286).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.LineBreak'(_31207838,_31207856),_31206744,_31218050,_31218056,_31218062):-hnf(_31207838,_31220656,_31218056,_31220680),'blocked_blocked_Text.Pretty.width.width\'27.216_2_Text.PrettyImpl.LineBreak_1'(_31220656,_31207856,_31206744,_31218050,_31220680,_31218062).

'blocked_blocked_Text.Pretty.width.width\'27.216_2_Text.PrettyImpl.LineBreak_1'(_31221334,_31221336,_31221338,_31221340,_31221342,_31221344):-freeze(_31221342,'blocked_blocked_blocked_Text.Pretty.width.width\'27.216_2_Text.PrettyImpl.LineBreak_1'(_31221334,_31221336,_31221338,_31221340,_31221342,_31221344)).
'blocked_blocked_blocked_Text.Pretty.width.width\'27.216_2_Text.PrettyImpl.LineBreak_1'('Prelude.Nothing',_31207856,_31206744,_31221768,_31221774,_31221780):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31207856),_31221768,_31221774,_31221780).
'blocked_blocked_blocked_Text.Pretty.width.width\'27.216_2_Text.PrettyImpl.LineBreak_1'('Prelude.Just'(_31208224),_31207856,_31206744,_31223244,_31223250,_31223256):-!,hnf('Text.Pretty.width.width\'27.216'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_31206744,'Prelude.apply'('Text.PrettyImpl.lengthVis',_31208224)),_31207856),_31223244,_31223250,_31223256).
'blocked_blocked_blocked_Text.Pretty.width.width\'27.216_2_Text.PrettyImpl.LineBreak_1'('FAIL'(_31225472),_31207856,_31206744,'FAIL'(_31225472),_31225486,_31225486):-nonvar(_31225472).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.OpenGroup'(_31208816),_31206744,_31226022,_31226028,_31226034):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31208816),_31226022,_31226028,_31226034).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.CloseGroup'(_31209080),_31206744,_31227442,_31227448,_31227454):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31209080),_31227442,_31227448,_31227454).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.OpenNest'(_31209344,_31209362),_31206744,_31228846,_31228852,_31228858):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31209362),_31228846,_31228852,_31228858).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.CloseNest'(_31209632),_31206744,_31230320,_31230326,_31230332):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31209632),_31230320,_31230326,_31230332).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.OpenFormat'(_31209896,_31209914),_31206744,_31231748,_31231754,_31231760):-hnf('Text.Pretty.width.width\'27.216'(_31206744,_31209914),_31231748,_31231754,_31231760).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('Text.PrettyImpl.CloseFormat'(_31210184),_31206744,_31233246,_31233252,_31233258):-!,hnf('Text.Pretty.width.width\'27.216'(_31206744,_31210184),_31233246,_31233252,_31233258).
'blocked_blocked_Text.Pretty.width.width\'27.216_2'('FAIL'(_31234208),_31206744,'FAIL'(_31234208),_31234222,_31234222):-nonvar(_31234208).

'Text.Pretty.bold'(_31235022,_31235024,_31235026,_31235028):-freeze(_31235026,'blocked_Text.Pretty.bold'(_31235022,_31235024,_31235026,_31235028)).
'blocked_Text.Pretty.bold'(_31235108,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetIntensity'('Text.PrettyImpl.Bold')),'Prelude..'('Text.PrettyImpl.deDoc'(_31235108),'Text.PrettyImpl.CloseFormat'))),_31235802,_31235802).

'Text.Pretty.faint'(_31238794,_31238796,_31238798,_31238800):-freeze(_31238798,'blocked_Text.Pretty.faint'(_31238794,_31238796,_31238798,_31238800)).
'blocked_Text.Pretty.faint'(_31238880,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetIntensity'('Text.PrettyImpl.Faint')),'Prelude..'('Text.PrettyImpl.deDoc'(_31238880),'Text.PrettyImpl.CloseFormat'))),_31239574,_31239574).

'Text.Pretty.blinkSlow'(_31242730,_31242732,_31242734,_31242736):-freeze(_31242734,'blocked_Text.Pretty.blinkSlow'(_31242730,_31242732,_31242734,_31242736)).
'blocked_Text.Pretty.blinkSlow'(_31242816,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBlinkMode'('Text.PrettyImpl.Slow')),'Prelude..'('Text.PrettyImpl.deDoc'(_31242816),'Text.PrettyImpl.CloseFormat'))),_31243510,_31243510).

'Text.Pretty.blinkRapid'(_31246722,_31246724,_31246726,_31246728):-freeze(_31246726,'blocked_Text.Pretty.blinkRapid'(_31246722,_31246724,_31246726,_31246728)).
'blocked_Text.Pretty.blinkRapid'(_31246808,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBlinkMode'('Text.PrettyImpl.Rapid')),'Prelude..'('Text.PrettyImpl.deDoc'(_31246808),'Text.PrettyImpl.CloseFormat'))),_31247502,_31247502).

'Text.Pretty.italic'(_31250574,_31250576,_31250578,_31250580):-freeze(_31250578,'blocked_Text.Pretty.italic'(_31250574,_31250576,_31250578,_31250580)).
'blocked_Text.Pretty.italic'(_31250660,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetItalicized'('Prelude.True')),'Prelude..'('Text.PrettyImpl.deDoc'(_31250660),'Text.PrettyImpl.CloseFormat'))),_31251354,_31251354).

'Text.Pretty.underline'(_31254468,_31254470,_31254472,_31254474):-freeze(_31254472,'blocked_Text.Pretty.underline'(_31254468,_31254470,_31254472,_31254474)).
'blocked_Text.Pretty.underline'(_31254554,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetUnderlined'('Prelude.True')),'Prelude..'('Text.PrettyImpl.deDoc'(_31254554),'Text.PrettyImpl.CloseFormat'))),_31255248,_31255248).

'Text.Pretty.crossout'(_31258342,_31258344,_31258346,_31258348):-freeze(_31258346,'blocked_Text.Pretty.crossout'(_31258342,_31258344,_31258346,_31258348)).
'blocked_Text.Pretty.crossout'(_31258428,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetCrossedout'('Prelude.True')),'Prelude..'('Text.PrettyImpl.deDoc'(_31258428),'Text.PrettyImpl.CloseFormat'))),_31259122,_31259122).

'Text.Pretty.inverse'(_31262172,_31262174,_31262176,_31262178):-freeze(_31262176,'blocked_Text.Pretty.inverse'(_31262172,_31262174,_31262176,_31262178)).
'blocked_Text.Pretty.inverse'(_31262258,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.InverseColoring'('Prelude.True')),'Prelude..'('Text.PrettyImpl.deDoc'(_31262258),'Text.PrettyImpl.CloseFormat'))),_31262952,_31262952).

'Text.Pretty.black'(_31265932,_31265934,_31265936,_31265938):-freeze(_31265936,'blocked_Text.Pretty.black'(_31265932,_31265934,_31265936,_31265938)).
'blocked_Text.Pretty.black'(_31266018,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Black')),'Prelude..'('Text.PrettyImpl.deDoc'(_31266018),'Text.PrettyImpl.CloseFormat'))),_31266712,_31266712).

'Text.Pretty.red'(_31269646,_31269648,_31269650,_31269652):-freeze(_31269650,'blocked_Text.Pretty.red'(_31269646,_31269648,_31269650,_31269652)).
'blocked_Text.Pretty.red'(_31269732,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Red')),'Prelude..'('Text.PrettyImpl.deDoc'(_31269732),'Text.PrettyImpl.CloseFormat'))),_31270426,_31270426).

'Text.Pretty.green'(_31273412,_31273414,_31273416,_31273418):-freeze(_31273416,'blocked_Text.Pretty.green'(_31273412,_31273414,_31273416,_31273418)).
'blocked_Text.Pretty.green'(_31273498,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Green')),'Prelude..'('Text.PrettyImpl.deDoc'(_31273498),'Text.PrettyImpl.CloseFormat'))),_31274192,_31274192).

'Text.Pretty.yellow'(_31277240,_31277242,_31277244,_31277246):-freeze(_31277244,'blocked_Text.Pretty.yellow'(_31277240,_31277242,_31277244,_31277246)).
'blocked_Text.Pretty.yellow'(_31277326,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Yellow')),'Prelude..'('Text.PrettyImpl.deDoc'(_31277326),'Text.PrettyImpl.CloseFormat'))),_31278020,_31278020).

'Text.Pretty.blue'(_31281004,_31281006,_31281008,_31281010):-freeze(_31281008,'blocked_Text.Pretty.blue'(_31281004,_31281006,_31281008,_31281010)).
'blocked_Text.Pretty.blue'(_31281090,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Blue')),'Prelude..'('Text.PrettyImpl.deDoc'(_31281090),'Text.PrettyImpl.CloseFormat'))),_31281784,_31281784).

'Text.Pretty.magenta'(_31284858,_31284860,_31284862,_31284864):-freeze(_31284862,'blocked_Text.Pretty.magenta'(_31284858,_31284860,_31284862,_31284864)).
'blocked_Text.Pretty.magenta'(_31284944,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Magenta')),'Prelude..'('Text.PrettyImpl.deDoc'(_31284944),'Text.PrettyImpl.CloseFormat'))),_31285638,_31285638).

'Text.Pretty.cyan'(_31288634,_31288636,_31288638,_31288640):-freeze(_31288638,'blocked_Text.Pretty.cyan'(_31288634,_31288636,_31288638,_31288640)).
'blocked_Text.Pretty.cyan'(_31288720,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.Cyan')),'Prelude..'('Text.PrettyImpl.deDoc'(_31288720),'Text.PrettyImpl.CloseFormat'))),_31289414,_31289414).

'Text.Pretty.white'(_31292412,_31292414,_31292416,_31292418):-freeze(_31292416,'blocked_Text.Pretty.white'(_31292412,_31292414,_31292416,_31292418)).
'blocked_Text.Pretty.white'(_31292498,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetForeground'('Text.PrettyImpl.White')),'Prelude..'('Text.PrettyImpl.deDoc'(_31292498),'Text.PrettyImpl.CloseFormat'))),_31293192,_31293192).

'Text.Pretty.bgBlack'(_31296278,_31296280,_31296282,_31296284):-freeze(_31296282,'blocked_Text.Pretty.bgBlack'(_31296278,_31296280,_31296282,_31296284)).
'blocked_Text.Pretty.bgBlack'(_31296364,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Black')),'Prelude..'('Text.PrettyImpl.deDoc'(_31296364),'Text.PrettyImpl.CloseFormat'))),_31297058,_31297058).

'Text.Pretty.bgRed'(_31300080,_31300082,_31300084,_31300086):-freeze(_31300084,'blocked_Text.Pretty.bgRed'(_31300080,_31300082,_31300084,_31300086)).
'blocked_Text.Pretty.bgRed'(_31300166,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Red')),'Prelude..'('Text.PrettyImpl.deDoc'(_31300166),'Text.PrettyImpl.CloseFormat'))),_31300860,_31300860).

'Text.Pretty.bgGreen'(_31303934,_31303936,_31303938,_31303940):-freeze(_31303938,'blocked_Text.Pretty.bgGreen'(_31303934,_31303936,_31303938,_31303940)).
'blocked_Text.Pretty.bgGreen'(_31304020,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Green')),'Prelude..'('Text.PrettyImpl.deDoc'(_31304020),'Text.PrettyImpl.CloseFormat'))),_31304714,_31304714).

'Text.Pretty.bgYellow'(_31307850,_31307852,_31307854,_31307856):-freeze(_31307854,'blocked_Text.Pretty.bgYellow'(_31307850,_31307852,_31307854,_31307856)).
'blocked_Text.Pretty.bgYellow'(_31307936,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Yellow')),'Prelude..'('Text.PrettyImpl.deDoc'(_31307936),'Text.PrettyImpl.CloseFormat'))),_31308630,_31308630).

'Text.Pretty.bgBlue'(_31311702,_31311704,_31311706,_31311708):-freeze(_31311706,'blocked_Text.Pretty.bgBlue'(_31311702,_31311704,_31311706,_31311708)).
'blocked_Text.Pretty.bgBlue'(_31311788,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Blue')),'Prelude..'('Text.PrettyImpl.deDoc'(_31311788),'Text.PrettyImpl.CloseFormat'))),_31312482,_31312482).

'Text.Pretty.bgMagenta'(_31315644,_31315646,_31315648,_31315650):-freeze(_31315648,'blocked_Text.Pretty.bgMagenta'(_31315644,_31315646,_31315648,_31315650)).
'blocked_Text.Pretty.bgMagenta'(_31315730,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Magenta')),'Prelude..'('Text.PrettyImpl.deDoc'(_31315730),'Text.PrettyImpl.CloseFormat'))),_31316424,_31316424).

'Text.Pretty.bgCyan'(_31319508,_31319510,_31319512,_31319514):-freeze(_31319512,'blocked_Text.Pretty.bgCyan'(_31319508,_31319510,_31319512,_31319514)).
'blocked_Text.Pretty.bgCyan'(_31319594,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.Cyan')),'Prelude..'('Text.PrettyImpl.deDoc'(_31319594),'Text.PrettyImpl.CloseFormat'))),_31320288,_31320288).

'Text.Pretty.bgWhite'(_31323374,_31323376,_31323378,_31323380):-freeze(_31323378,'blocked_Text.Pretty.bgWhite'(_31323374,_31323376,_31323378,_31323380)).
'blocked_Text.Pretty.bgWhite'(_31323460,'Text.PrettyImpl.Doc'('Prelude..'('Text.PrettyImpl.OpenFormat'('Text.PrettyImpl.SetBackground'('Text.PrettyImpl.White')),'Prelude..'('Text.PrettyImpl.deDoc'(_31323460),'Text.PrettyImpl.CloseFormat'))),_31324154,_31324154).

'Text.Pretty.pretty'(_31327214,_31327216,_31327218,_31327220):-freeze(_31327218,'blocked_Text.Pretty.pretty'(_31327214,_31327216,_31327218,_31327220)).
'blocked_Text.Pretty.pretty'(_31327300,_31327568,_31327574,_31327580):-hnf('Text.Pretty.pretty._\'23lambda'('Prelude.apply'(_31327300,'Prelude.()')),_31327568,_31327574,_31327580).

'Text.Pretty.pretty._\'23lambda'(_31329726,_31329728,_31329730,_31329732):-freeze(_31329730,'blocked_Text.Pretty.pretty._\'23lambda'(_31329726,_31329728,_31329730,_31329732)).
'blocked_Text.Pretty.pretty._\'23lambda'(_31329812,_31330232,_31330238,_31330244):-hnf(_31329812,_31331654,_31330238,_31331666),'blocked_Text.Pretty.pretty._\'23lambda_1'(_31331654,_31330232,_31331666,_31330244).

'blocked_Text.Pretty.pretty._\'23lambda_1'(_31332082,_31332084,_31332086,_31332088):-freeze(_31332086,'blocked_blocked_Text.Pretty.pretty._\'23lambda_1'(_31332082,_31332084,_31332086,_31332088)).
'blocked_blocked_Text.Pretty.pretty._\'23lambda_1'('Text.Pretty._Dict\'23Pretty'(_31329928,_31329946),_31332646,_31332652,_31332658):-!,hnf(_31329928,_31332646,_31332652,_31332658).
'blocked_blocked_Text.Pretty.pretty._\'23lambda_1'('FAIL'(_31333200),'FAIL'(_31333200),_31333214,_31333214):-nonvar(_31333200).

'Text.Pretty.prettyList'(_31334234,_31334236,_31334238,_31334240):-freeze(_31334238,'blocked_Text.Pretty.prettyList'(_31334234,_31334236,_31334238,_31334240)).
'blocked_Text.Pretty.prettyList'(_31334320,_31334588,_31334594,_31334600):-hnf('Text.Pretty.prettyList._\'23lambda'('Prelude.apply'(_31334320,'Prelude.()')),_31334588,_31334594,_31334600).

'Text.Pretty.prettyList._\'23lambda'(_31336946,_31336948,_31336950,_31336952):-freeze(_31336950,'blocked_Text.Pretty.prettyList._\'23lambda'(_31336946,_31336948,_31336950,_31336952)).
'blocked_Text.Pretty.prettyList._\'23lambda'(_31337032,_31337476,_31337482,_31337488):-hnf(_31337032,_31339042,_31337482,_31339054),'blocked_Text.Pretty.prettyList._\'23lambda_1'(_31339042,_31337476,_31339054,_31337488).

'blocked_Text.Pretty.prettyList._\'23lambda_1'(_31339494,_31339496,_31339498,_31339500):-freeze(_31339498,'blocked_blocked_Text.Pretty.prettyList._\'23lambda_1'(_31339494,_31339496,_31339498,_31339500)).
'blocked_blocked_Text.Pretty.prettyList._\'23lambda_1'('Text.Pretty._Dict\'23Pretty'(_31337148,_31337166),_31340058,_31340064,_31340070):-!,hnf(_31337166,_31340058,_31340064,_31340070).
'blocked_blocked_Text.Pretty.prettyList._\'23lambda_1'('FAIL'(_31340636),'FAIL'(_31340636),_31340650,_31340650):-nonvar(_31340636).

'Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0'(_31342904,_31342906,_31342908,_31342910,_31342912):-freeze(_31342910,'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0'(_31342904,_31342906,_31342908,_31342910,_31342912)).
'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0'(_31343000,_31343018,_31344658,_31344664,_31344670):-hnf(_31343000,_31347096,_31344664,_31347114),'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'(_31347096,_31343018,_31344658,_31347114,_31344670).

'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'(_31347712,_31347714,_31347716,_31347718,_31347720):-freeze(_31347718,freeze(_31347712,'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'(_31347712,_31347714,_31347716,_31347718,_31347720))).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.EOD',_31343018,'Prelude.True',_31348196,_31348196).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.Empty'(_31343234),_31343018,_31349322,_31349328,_31349334):-hnf(_31343018,_31349322,_31349328,_31349334).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.Text'(_31343344,_31343362),_31343018,_31350446,_31350452,_31350458):-hnf(_31343018,_31350446,_31350452,_31350458).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.LineBreak'(_31343478,_31343496),_31343018,_31351696,_31351702,_31351708):-hnf(_31343018,_31351696,_31351702,_31351708).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.OpenGroup'(_31343612),_31343018,_31352938,_31352944,_31352950):-hnf(_31343018,_31352938,_31352944,_31352950).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.CloseGroup'(_31343722),_31343018,_31354126,_31354132,_31354138):-hnf(_31343018,_31354126,_31354132,_31354138).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.OpenNest'(_31343832,_31343850),_31343018,_31355298,_31355304,_31355310):-hnf(_31343018,_31355298,_31355304,_31355310).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.CloseNest'(_31343966),_31343018,_31356540,_31356546,_31356552):-hnf(_31343018,_31356540,_31356546,_31356552).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.OpenFormat'(_31344076,_31344094),_31343018,_31357736,_31357742,_31357748):-hnf(_31343018,_31357736,_31357742,_31357748).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('Text.PrettyImpl.CloseFormat'(_31344210),_31343018,_31359002,_31359008,_31359014):-!,hnf(_31343018,_31359002,_31359008,_31359014).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0_1'('FAIL'(_31359732),_31343018,'FAIL'(_31359732),_31359746,_31359746).

'Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0'(_31361596,_31361598,_31361600,_31361602,_31361604):-freeze(_31361602,'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0'(_31361596,_31361598,_31361600,_31361602,_31361604)).
'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0'(_31361692,_31361710,_31363774,_31363780,_31363786):-hnf(_31361692,_31365780,_31363780,_31365798),'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'(_31365780,_31361710,_31363774,_31365798,_31363786).

'blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'(_31366324,_31366326,_31366328,_31366330,_31366332):-freeze(_31366330,freeze(_31366324,'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'(_31366324,_31366326,_31366328,_31366330,_31366332))).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.Empty'(_31361826),_31361710,_31366836,_31366842,_31366848):-makeShare(_31361860,_31366962),hnf('Prelude.cond'(letrec4PAKCS(_31366962,'Prelude.False'),'Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0._\'23caseor0'(_31361826,_31366962)),_31366836,_31366842,_31366848).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.EOD',_31361710,_31369388,_31369394,_31369400):-hnf(_31361710,_31369388,_31369394,_31369400).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.Text'(_31362532,_31362550),_31361710,_31370374,_31370380,_31370386):-hnf(_31361710,_31370374,_31370380,_31370386).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.LineBreak'(_31362666,_31362684),_31361710,_31371552,_31371558,_31371564):-hnf(_31361710,_31371552,_31371558,_31371564).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.OpenGroup'(_31362800),_31361710,_31372722,_31372728,_31372734):-hnf(_31361710,_31372722,_31372728,_31372734).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.CloseGroup'(_31362910),_31361710,_31373838,_31373844,_31373850):-hnf(_31361710,_31373838,_31373844,_31373850).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.OpenNest'(_31363020,_31363038),_31361710,_31374938,_31374944,_31374950):-hnf(_31361710,_31374938,_31374944,_31374950).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.CloseNest'(_31363154),_31361710,_31376108,_31376114,_31376120):-hnf(_31361710,_31376108,_31376114,_31376120).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.OpenFormat'(_31363264,_31363282),_31361710,_31377232,_31377238,_31377244):-hnf(_31361710,_31377232,_31377238,_31377244).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('Text.PrettyImpl.CloseFormat'(_31363398),_31361710,_31378426,_31378432,_31378438):-!,hnf(_31361710,_31378426,_31378432,_31378438).
'blocked_blocked_Text.Pretty.isEmpty.isEmptyText.6._\'23caseor0_1'('FAIL'(_31379084),_31361710,'FAIL'(_31379084),_31379098,_31379098).

'Text.Pretty.fill._\'23caseor0'(_31380302,_31380304,_31380306,_31380308,_31380310,_31380312):-freeze(_31380310,'blocked_Text.Pretty.fill._\'23caseor0'(_31380302,_31380304,_31380306,_31380308,_31380310,_31380312)).
'blocked_Text.Pretty.fill._\'23caseor0'(_31380408,_31380426,_31380444,_31381148,_31381154,_31381160):-hnf(_31380408,_31382550,_31381154,_31382574),'blocked_Text.Pretty.fill._\'23caseor0_1'(_31382550,_31380426,_31380444,_31381148,_31382574,_31381160).

'blocked_Text.Pretty.fill._\'23caseor0_1'(_31383006,_31383008,_31383010,_31383012,_31383014,_31383016):-freeze(_31383014,freeze(_31383006,'blocked_blocked_Text.Pretty.fill._\'23caseor0_1'(_31383006,_31383008,_31383010,_31383012,_31383014,_31383016))).
'blocked_blocked_Text.Pretty.fill._\'23caseor0_1'('Prelude.True',_31380426,_31380444,_31383410,_31383416,_31383422):-hnf('Text.Pretty.empty',_31383410,_31383416,_31383422).
'blocked_blocked_Text.Pretty.fill._\'23caseor0_1'('Prelude.False',_31380426,_31380444,_31384384,_31384390,_31384396):-!,hnf('Text.Pretty.spaces'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31380426,_31380444)),_31384384,_31384390,_31384396).
'blocked_blocked_Text.Pretty.fill._\'23caseor0_1'('FAIL'(_31385684),_31380426,_31380444,'FAIL'(_31385684),_31385698,_31385698).

'Text.Pretty.fillBreak._\'23caseor0'(_31387100,_31387102,_31387104,_31387106,_31387108,_31387110):-freeze(_31387108,'blocked_Text.Pretty.fillBreak._\'23caseor0'(_31387100,_31387102,_31387104,_31387106,_31387108,_31387110)).
'blocked_Text.Pretty.fillBreak._\'23caseor0'(_31387206,_31387224,_31387242,_31388130,_31388136,_31388142):-hnf(_31387206,_31389712,_31388136,_31389736),'blocked_Text.Pretty.fillBreak._\'23caseor0_1'(_31389712,_31387224,_31387242,_31388130,_31389736,_31388142).

'blocked_Text.Pretty.fillBreak._\'23caseor0_1'(_31390198,_31390200,_31390202,_31390204,_31390206,_31390208):-freeze(_31390206,freeze(_31390198,'blocked_blocked_Text.Pretty.fillBreak._\'23caseor0_1'(_31390198,_31390200,_31390202,_31390204,_31390206,_31390208))).
'blocked_blocked_Text.Pretty.fillBreak._\'23caseor0_1'('Prelude.True',_31387224,_31387242,_31390602,_31390608,_31390614):-hnf('Text.Pretty.nest'(_31387224,'Text.Pretty.linebreak'),_31390602,_31390608,_31390614).
'blocked_blocked_Text.Pretty.fillBreak._\'23caseor0_1'('Prelude.False',_31387224,_31387242,_31391928,_31391934,_31391940):-!,hnf('Text.Pretty.spaces'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_31387224,_31387242)),_31391928,_31391934,_31391940).
'blocked_blocked_Text.Pretty.fillBreak._\'23caseor0_1'('FAIL'(_31393258),_31387224,_31387242,'FAIL'(_31393258),_31393272,_31393272).

:-costCenters(['']).




%%%%% Number of shared variables: 21

