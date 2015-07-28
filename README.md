react-model-mixins
==================

Model mixins for Meteor React.

API
---

* changeDatatMx
    * changeDataText
    * changeDataInteger
    * changeDataFloat
    * changeDataCheck
* stateMx
    * setStateById
      replace the state with the object obtained with findOne
* validationMx
    * validate
      validate the object
    * isValid
      same as validate
    * isNotValid
    * isValidAttr   
      checks if an attr is valid or not  
* saveMx   
    * save    
      saves the state to Mongo
      
Examples
--------

```coffee
...
getInitialState: ->
    x: 0
...
<input type='text' value=@state.x onChange=@changeDataInteger('x')  />

```      

given the validations in the *lib* folder:
```coffee
@AValidations = (self) ->
  text1: (x) ->
    if Meteor.isClient
      self.isValidAutocomplete('myTag')
    else
      authors.findOne(value:x)
  text2: (x) ->
    if Meteor.isClient
      self.isValidAutocomplete('myTag2')
    else
      authors.findOne(value:x)
  x: (x) -> x >= 5
```
  
client side:
```coffee
A = ReactMeteor.createClass
    mixins: [RAC.changeDataMx, RAC.validationMx, RAC.stateMx, RMMx.saveMx, RMMx.validationMx, RMMx.changeDatatMx]
    autocompleteIds: ['myTag', 'myTag2']
    collection: myCollection
    validations: -> AValidations(this)
    getInitialState: ->
        text1: ''
        text2: ''
        x: 0
    getMeteorState: ->
        error_text1: => if not @isValidAttr('text1') then 'error autocomplete' else ''
    error_x: -> if not @isValidAttr('x') then 'x>=5' else ''
    random: -> Math.random()
    render: ->
        <div>
            <RAC.Autocomplete value=@state.text1 call='autocomplete' reference='value' renderTemplate=renT tag='myTag' changeData=@changeDataAutocomplete('text1') />
            <span className='red'>{@state.error_text1()}</span>
            <RAC.Autocomplete value=@state.text2 call='autocomplete' reference='value' tag='myTag2' changeData=@changeDataAutocomplete('text2') />
            <input type='text' value=@state.x onChange=@changeDataInteger('x')  />
            <span className='red'>{@error_x()}</span>
            <button disabled=@isNotValid() onClick=@save >save</button>
            <span>{@random()}</span>
        </div>
```
  
server side with ```ongoworks:security```:
```coffee
Security.defineMethod "ifIsValid",
  fetch: [],
  transform: null,
  deny: (type, arg, userId, doc, fields, modifier) ->
    if type == 'update'
      doc = modifier['$set']

    for attr, func of arg()
      if not func doc[attr], doc
        return true
    false

myCollection.permit(['insert', 'update']).ifIsValid(AValidations).apply()  
```  
  
Another example with nested model (and array support):

```coffee
getInitialState: ->
    a:
        b: [{x:8}, {y:9}]

render: ->
    <div>
        <input type='text'value=@state.a.b[1].y  onChange=@changeDataText('a.b.1.y') />
```              