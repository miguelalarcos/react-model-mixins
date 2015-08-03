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
    * setStateById: replace the state with the object obtained with findOne
* validationMx
    * validate: validate the object
    * isValid: same as validate
    * isNotValid
    * isValidAttr: checks if an attr is valid or not  
* saveMx   
    * save: saves the state to Mongo
      
Examples
--------

```coffee
...
getInitialState: ->
    x: 0
...
<input type='text' value=@state.x onChange=@changeDataInteger('x')  />

```      
  
Another example with nested model (and array support):

```coffee
getInitialState: ->
    a:
        b: [{x:8}, {y:9}]

render: ->
    <div>
        <input type='text' value=@state.a.b[1].y  onChange=@changeDataInteger('a.b.1.y') />
        {if @isValid()
            <button onClick=@save ...
        }
        ...        
```              