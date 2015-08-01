RMMx = {}

stateFromPath = (path, value) ->
    path = path.split('.')
    last = path[-1..][0]

    dct = {}
    dct_ = dct
    for p in path
        if p == last
            dct[p] = {$set: value}
        else
            #p = parseInt(p) or p
            dct[p] = {}
        dct = dct[p]
    return dct_

RMMx.changeDatatMx = {
    changeDataText: (attr) ->
        (e) =>
            dct = stateFromPath(attr, e.target.value)
            @setState(React.addons.update(@state, dct))

    changeDataInteger: (attr) ->
        (e) =>
            v = parseInt(e.target.value) or 0
            dct = stateFromPath(attr, v)
            @setState(React.addons.update(@state, dct))

    changeDataFloat: (attr) ->
        (e) =>
            v = parseFloat(e.target.value) or 0.0
            dct = stateFromPath(attr, v)
            @setState(React.addons.update(@state, dct))

    changeDataCheck: (attr) ->
        (e) =>
            v = if @state[attr] == 'checked' then '' else 'checked'
            dct = stateFromPath(attr, v)
            @setState(React.addons.update(@state, dct))
}

RMMx.stateMx = {
    setStateById: (id) ->
        @replaceState @collection.findOne(id)
}

RMMx.validationMx = {
    validate: ->
        for attr, func of @validations
            if not func @state[attr], @state
                return false
        true
    isValid: ->
        @validate()
    isNotValid: ->
        not @validate()
    isValidAttr: (attr) ->
        @validations()[attr](@state[attr], @state)
}

RMMx.saveMx = {
    save: ->
        if @state._id
            obj = _.omit(@state, '_id')
            @collection.update @state._id, $set:obj
        else
            @collection.insert @state, (err, id) =>
                if not err
                    @setState _id: id
}
