var express = require('express');
var app = express();
var bodyParser = require("body-parser");
var mongoose = require('mongoose');
var port = 8080;

var jsonParser = bodyParser.json()

mongoose.connect('mongodb://localhost:27017/leads_api');
var Schema = mongoose.Schema;

var leadSchema = new Schema ({
        email: String,
        first_name: String,
        last_name: String,
        afi: Number,
});

var Lead = mongoose.model('Lead', leadSchema);
module.exports = Lead;
/*
app.get('/api', function(req, res, next) {
	var person = new Lead();
	person.email = req.param('email');
        console.log(person.email);
        person.save();
	next();
});
*/

app.post('/tasks', jsonParser, function (request, response) {
	var person = new Lead;
	person.email = request.body.email;
	person.first_name = request.body.first_name;
	person.last_name = request.body.last_name;
	person.afi = request.body.afi;
	console.log(person.email);
	person.save();
	response.send();
});
app.listen(port);
