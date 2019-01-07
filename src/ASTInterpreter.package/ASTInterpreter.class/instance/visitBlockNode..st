visiting
visitBlockNode: aRBBlockNode
	"| blockContext |"
	^ ASTIntBlockContext new
		receiver: self contextStack top receiver;
		parentASTIntContext: self contextStack top;
		blockASTNode: aRBBlockNode;
		yourself
	
"	blockContext := ASTIntContext new
		parentASTInterpreterContext: self activeContext;
		receiver: nil.
	^ ASTIntBlock new
		context: blockContext;
		astNode: aRBBlockNode;
		yourself."