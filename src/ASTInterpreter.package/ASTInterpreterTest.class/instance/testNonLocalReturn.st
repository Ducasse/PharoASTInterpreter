test
testNonLocalReturn
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest nonLocalReturnHelper'.
	self assert: (interpret interpret: ast) equals: 2.