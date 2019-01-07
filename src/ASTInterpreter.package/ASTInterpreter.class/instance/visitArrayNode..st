evaluation
visitArrayNode: aRBArrayNode 
	^ (aRBArrayNode statements collect: [ :statement | self interpret: statement ]) asArray.