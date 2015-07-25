Demo = ReactMeteor.createClass
    mixins : [RMMx.changeDatatMx]
    templateName: 'demo'
    getInitialState: ->
        a:
            b: [{x:8}, {y:9}]
    console: ->
        console.log @state
    render: ->
        <div>
            <input type='text'value=@state.a.b[1].y  onChange=@changeDataText('a.b.1.y') />
            <button onClick=@console>console</button>
        </div>