visiting
initialize
	super initialize.
	contextStack := Stack new.
	contextStack push: ASTIntContext new.
	debugMode := false.
	debugTranscriptTabLevel := 0.