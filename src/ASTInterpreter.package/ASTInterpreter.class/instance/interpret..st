main
interpret: aNode
	|retVal|
	debugMode ifTrue: [
		debugTranscriptTabLevel timesRepeat: [ Transcript tab. ].
		Transcript show: 'Interpreting: '.
		Transcript show: aNode; cr.
		debugTranscriptTabLevel := debugTranscriptTabLevel + 1.
	].
	retVal := aNode acceptVisitor: self.
	debugMode ifTrue: [ 
		debugTranscriptTabLevel := debugTranscriptTabLevel - 1.
		debugTranscriptTabLevel timesRepeat: [ Transcript tab. ].
		Transcript show: 'Value: '.
		Transcript show: retVal; cr.
	].
	^ retVal.