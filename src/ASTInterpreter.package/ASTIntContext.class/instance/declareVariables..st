as yet unclassified
declareVariables: anOrderedCollectionOfRBVariableNodes
	anOrderedCollectionOfRBVariableNodes do: [ :aRBVariableNode |
		self variables add: (Association key: aRBVariableNode name value: nil).	 
	].