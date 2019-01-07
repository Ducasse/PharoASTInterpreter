test
testVariableRedefinitionInMethodCalled
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '|n| n:=1. ASTInterpreterTest variableRedefinitionInMethodCalledHelper. n'.
	self assert: (interpret interpret: ast) equals: 1. 