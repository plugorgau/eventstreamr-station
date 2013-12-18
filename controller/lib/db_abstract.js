var events = require('events');
var feed = new events.EventEmitter();
var request = require('request')

// datastore connection
var Datastore = require('nedb')
  , db = {
    stations: new Datastore({ filename: 'storage/stations.db' , autoload: true}),
    rooms: new Datastore({ filename: 'storage/rooms.db' , autoload: true})
  }

var callback = function(error, success) {
  if (err) callback(err)
  if (success) {
    callback(null, success)
  }
}

exports.insert = function(table, document, callback) {
  db[table].insert(document, function (error, success) {
    if (error) callback(err)
    if (success) {
      feed.emit('change', {type: 'insert', content: success})
      callback(null, success)
    }
  })
}

exports.remove = function(table, query, callback) {
  db[table].remove(query, {}, function(error, success) {
    if (error) callback(err)
    if (success) {
      feed.emit('change', {type: 'remove', content: query._id})
      callback(null, success)
    }
  })
}

exports.update = function(table, query, partial, callback)  {
  db[table].update(query, { $set: partial }, {}, function(error, success) {
    if (error) callback(err)
    if (success) {
      feed.emit('change', {type: 'update', content: success})
      callback(null, success)
    }
  })
}

exports.updateRaw = function(table, query, partial, callback) {
  db[table].update(query, partial, {}, function(error, success) {
    if (error) callback(err)
    if (success) {
      feed.emit('change', {type: 'update', content: success})
      callback(null, success)
    }
  })
}

exports.get = function(table, query, callback) {
  db[table].findOne(query, callback)
}

exports.list = function(table, query, callback) {
  db[table].find(query, callback)
}

feed.on('change', function(content) {
  request.post({
    uri: 'http://localhost:5001/feed',
    json: content
  }, function(error) {
    if (error) {
      console.log(error)
    }
  })
})