RMMx = {}

RMMx.changeDatatMx = {
    changeDataText: (attr) ->
        (e) =>
            v = e.target.value
            dct = {}
            dct[attr] = v
            @setState dct

    changeDataInteger: (attr) ->
        (e) =>
            v = parseInt(e.target.value) or 0
            dct = {}
            dct[attr] = v
            @setState dct

    changeDataFloat: (attr) ->
        (e) =>
            v = parseFloat(e.target.value) or 0.0
            dct = {}
            dct[attr] = v
            @setState dct
}

RMMx.stateMx = {
    setStateByObjectOrId: (id) ->
        if _.isString(id)
            @replaceState @collection.findOne(id)
        else
            obj = id
            @replaceState obj
}

RMMx.validationMx = {
    validate: ->
        for attr, func of @validations()
            if not func @state[attr]
                return false
        true
    isValid: ->
        @validate()
    isNotValid: ->
        not @validate()
    isValidAttr: (attr) ->
        @validations()[attr](@state[attr])
}

RMMx.saveMx = {
    save: ->
        if @state._id
            obj = _.omit(@state, '_id')
            @collection.update @state._id, $set:obj
        else
            id = @collection.insert @state
            @setState _id: id
}
