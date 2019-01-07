test
testBlockThatDeclareVariables
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '[|n| n:= 2. n] value'.
	self assert: (interpret interpret: ast) equals: 2.