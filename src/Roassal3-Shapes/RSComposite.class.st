"
I am a composite shapes. I can therefore contain other shapes.

Here is a simple example:
-=-=-=
c := RSCanvas new.

box := RSBox new width: 40; height: 10; color: Color blue.
label := RSLabel new text: 'Hello Roassal3'.
RSLocation new above; move: box on: label.
composite := RSComposite new.
composite shapes: { label . box }.
composite @ RSDraggable.

c add: composite.
c
-=-=-=

A composite can also have a background color. Simply use #color: for this:
-=-=-=
c := RSCanvas new.

box := RSBox new width: 40; height: 10; color: Color blue.
label := RSLabel new text: 'Hello Roassal3'.
RSLocation new above; move: box on: label.
composite := RSComposite new.
composite color: Color gray.
composite shapes: { label . box }.
composite @ RSDraggable.

c add: composite.
c
-=-=-=

A padding describes a space between the border of the composite element and the inner shapes. It can be adjusted using the message #padding:

-=-=-=
c := RSCanvas new.

box := RSBox new width: 40; height: 10; color: Color blue.
label := RSLabel new text: 'Hello Roassal3'.
RSLocation new above; move: box on: label.
composite := RSComposite new.
composite color: Color gray.
composite shapes: { label . box }.
composite @ RSDraggable.
composite padding: 10.

c add: composite.
c
-=-=-=

Inner nodes can be layouted:
-=-=-=
classes := RSObject withAllSubclasses.

c := RSCanvas new.

classes do: [ :cls |
	label := RSLabel new text: cls name.
	methods := 
		cls methods collect: [ :m |
			RSBox new model: m; size: m sourceCode size sqrt; color: Color blue ] as: RSGroup.
	RSGridLayout on: methods.
	methods @ RSPopup.
	RSLocation new above; move: label on: methods.
	composite := RSComposite new.
	composite color: Color gray.
	composite shapes: { label }, methods.
	composite @ RSDraggable.
	composite padding: 10.
	c add: composite.
].

RSFlowLayout on: c shapes.

c @ RSControlsCanvas
-=-=-=

Lines can be added between composite. Here is an example:
-=-=-=
classes := RSObject withAllSubclasses.

c := RSCanvas new.

classes do: [ :cls |
	label := RSLabel new text: cls name.
	methods := 
		cls methods collect: [ :m |
			RSBox new model: m; size: m sourceCode size sqrt; color: Color blue ] as: RSGroup.
	RSGridLayout on: methods.
	methods @ RSPopup.
	RSLocation new above; move: label on: methods.
	composite := RSComposite new.
	composite model: cls.
	composite color: Color gray.
	composite shapes: { label }, methods.
	composite @ RSDraggable.
	composite padding: 10.
	c add: composite.
].

RSEdgeBuilder orthoVertical
	canvas: c;
	withVerticalAttachPoint;
	connectFrom: #superclass.

RSTreeLayout on: c nodes.

c @ RSControlsCanvas
-=-=-=
"
Class {
	#name : #RSComposite,
	#superclass : #RSBoundingShape,
	#instVars : [
		'shapes'
	],
	#category : #'Roassal3-Shapes-Bounding'
}

{ #category : #adding }
RSComposite >> add: aShape [
	"Add a shape in a composite shape"
	aShape addedIn: self
]

{ #category : #adding }
RSComposite >> addAll: aCollection [
	shapes ifNil: [ shapes := RSGroup new: aCollection size ].
	aCollection do: [ :s| self add: s shape ].
]

{ #category : #adding }
RSComposite >> addBasicShape: aShape [
	self shapes add: aShape
]

{ #category : #adding }
RSComposite >> addFixedShape: aShape [
	self error: 'Composite can not add a fixed shape'
]

{ #category : #adding }
RSComposite >> addShape: aShape [
	"Add a shape in a composite shape"
	aShape addedIn: self
]

{ #category : #public }
RSComposite >> adjustToChildren [
	| rect delta |
	shapes ifNil: [ ^ self ].
	rect := shapes encompassingRectangle.
	delta := rect rsCenter negated.
	shapes do: [ :s | s basicTranslateBy: delta ].
	self 
		extent: rect extent;
		translateTo: delta.
]

{ #category : #accessing }
RSComposite >> camera [
	^ parent camera
]

{ #category : #testing }
RSComposite >> hasChildren [
	^ shapes notNil and: [ shapes isNotEmpty ]
]

{ #category : #initialization }
RSComposite >> initialize [
	super initialize.
	paint := nil.
	self resetPath.
	
]

{ #category : #accessing }
RSComposite >> padding: anObject [
	"anObject can be a number, a point or Margin"
	"Shapes should be set in the composite before calling #padding:"
	
	| margin rect center temp |
	temp := shapes 
		ifNil: [ RSGroup new: 0 ]
		ifNotNil: [shapes].
	margin := anObject asMargin. 
	rect := temp encompassingRectangle.
	rect := margin expandRectangle: rect.
	self extent: rect extent.
	
	(center := rect rsCenter) = (0@0) ifTrue: [ ^ self ].
	center := center negated.
	temp do: [ :s | s translateBy: center ].
]

{ #category : #removing }
RSComposite >> removeShape: shape [
	| evt |
	shapes remove: shape.
	shape parent: nil.
	evt := RSShapeRemovedEvent new shape: shape.
	self announce: evt.
	shape announce: evt.
	
]

{ #category : #path }
RSComposite >> resetPath [
	path := baseRectangle
]

{ #category : #path }
RSComposite >> sessionChanged [
	self resetPath.
	shapes ifNil: [ ^ self ].
	shapes do: #sessionChanged
]

{ #category : #'accessing - computed' }
RSComposite >> shapeWithAction: eventClass forPosition: position [
	| res pos |
	pos := self matrix inverseTransform: position.
	self shapes reverseDo: [ :s |
		res := s shapeWithAction: eventClass forPosition: pos.
		res ifNotNil: [ ^ res] ].
	
	^ super shapeWithAction: eventClass forPosition: position.
]

{ #category : #'accessing - computed' }
RSComposite >> shapeWithActionForPosition: position [
	| res pos |
	pos := self matrix inverseTransform: position.
	self shapes reverseDo: [ :s |
		res := s shapeWithActionForPosition: pos.
		res ifNotNil: [ ^ res] ].
	^ super shapeWithActionForPosition: position.
]

{ #category : #accessing }
RSComposite >> shapes [
	^ shapes ifNil: [ shapes := RSGroup new ]
]

{ #category : #accessing }
RSComposite >> shapes: aTSGroup [
	"
	create a groups of elements or trachel shapes, then added them to this composite shape
	this method changes the position of the shapes and set the position of this composite shape
	to the center of the encompassingRectangle.
	"
	aTSGroup do: [ :s | 
		s isInACanvas 
			ifTrue: [ s remove ] ].
	self addAll: aTSGroup.
	self adjustToChildren.

	
]

{ #category : #accessing }
RSComposite >> view [
	^ parent view
]