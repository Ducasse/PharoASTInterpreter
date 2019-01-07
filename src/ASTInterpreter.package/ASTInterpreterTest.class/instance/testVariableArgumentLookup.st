test
testVariableArgumentLookup
"{ argg == 'argg'. varg == 'varg'. argb == 'argb'. varb == 'varb' }"
	| interpret ast testArray |
	interpret := ASTInterpreter new.
	interpret debugMode: true.
	ast := RBParser parseExpression: 'ASTInterpreterTest variableArgumentLookupHelper1: ''argf'''.
	testArray := (interpret interpret: ast). 
	self assert: (testArray at: 1) equals: true.
	self assert: (testArray at: 2) equals: true.
	self assert: (testArray at: 3) equals: true.
	self assert: (testArray at: 4) equals: true.