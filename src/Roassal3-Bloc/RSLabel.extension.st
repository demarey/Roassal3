Extension { #name : #RSLabel }

{ #category : #'*Roassal3-Bloc' }
RSLabel >> asBlElement [

	| result |
	result := BlTextElement new
		          text: self blRopedText;
		          background: Color transparent;
		          yourself.

	"Force calculation of the extent"
	result computeLayout.

	result transformDo: [ :aBuilder | 
		aBuilder transformation addTransformation:
			((BlMatrixTransformation matrix: self matrix asBlMatrix) origin:
				 BlAffineTransformationCenterOrigin new).
		aBuilder translateBy: result extent / -2 ].

	^ result
]

{ #category : #'*Roassal3-Bloc' }
RSLabel >> asBlGeometry [
	^ self shouldNotImplement
]

{ #category : #'*Roassal3-Bloc' }
RSLabel >> blRopedText [

	| result |
	result := self text asRopedText 
		foreground: self blPaint;
		fontSize: self fontSize;
		fontName: self fontName;
		yourself.
		
	self isBold ifTrue: [ 
		result bold ].
	self isItalic ifTrue: [ 
		result italic ].
	
	self isUnderlined ifTrue: [ 
		result underline.
		result underlineColor: self blPaint ].
	
	^ result
]