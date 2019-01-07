test
testMultiArgumentsMethod
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'true ifTrue: [1] ifFalse: [2]'.
	self assert: (interpret interpret: ast) equals: 1. 