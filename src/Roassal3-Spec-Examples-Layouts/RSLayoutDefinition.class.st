"
I am group of fields that describe a layout, each field is editable and can be create a presenter that will edit a layout
"
Class {
	#name : #RSLayoutDefinition,
	#superclass : #RSObject,
	#instVars : [
		'fields'
	],
	#category : #'Roassal3-Spec-Examples-Layouts-Core'
}

{ #category : #initialization }
RSLayoutDefinition >> add: aRSLayoutField [
	fields add: aRSLayoutField
]

{ #category : #accessing }
RSLayoutDefinition >> fields [
	^ fields
]

{ #category : #initialization }
RSLayoutDefinition >> initialize [
	super initialize.
	fields := OrderedCollection new
]

{ #category : #updating }
RSLayoutDefinition >> update [
	self fields do: [ :field | 
		field disableEvent; update; enableEvent ].
]