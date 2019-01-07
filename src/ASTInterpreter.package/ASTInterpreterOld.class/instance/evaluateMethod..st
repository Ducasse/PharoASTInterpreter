evaluation
evaluateMethod: aMethod

	aMethod ast statements do: [:sta | 
		self interpret: sta.
		self mustReturn ifTrue: [ ^ self returnValue ]
	].
	^ self stack top receiver.