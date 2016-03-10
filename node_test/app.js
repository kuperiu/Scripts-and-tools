var express = require('express');
var app = express();
var mongoose = require('mongoose');
var port    =   process.env.PORT || 8080;


mongoose.connect('mongodb://localhost:27017/leads_api');
var Schema = mongoose.Schema;

var leadSchema = new Schema ({
	emal: String,
	first_name: String,
	last_name: String,
	afi: Number,
});

var Lead = mongoose.model('Lead', leadSchema);
module.exports = Lead;

var lior = new Lead ({
	email: 'kuperi111111111111u@gmail.com',
	first_name: 'lior',
	last_name: 'kuperiu',
	afi: 1009,
})

lior.save(function (err) {
	if (err) throw err;
});

//app.get('/sample', function(req, res) {
//    res.send('this is a sample!');  
//});

app.get('/api', function(req, res) {
    var max = new Lead();   
 //   max.email = req.param('email');
 //   max.name = req.param('name');
    
    max.email = req.params.email;
    max.first_name = req.params.name;
    max.last_name = "lal";
    max.afi = 20;
console.log(max.email);
max.save(function () {
    res.send("dfrfr");
  });

    if (max.email === undefined) {
    // res.send("email is missing");
    }
    else {
    // res.send("Email: " + max.email + "</br>" + "Name: " + max.name);
    


     }
});




// get an instance of router
var router = express.Router();


// route middleware that will happen on every request
router.use(function(req, res, next) {

    // log each request to the console
         console.log(req.method, req.url);

             // continue doing what we were doing and go to the route
                 next(); 
                 });

router.param('name', function(req, res, next, name) {
  console.log('doing name validations on ' + name);
  req.name = name;
  next();
});



router.get('/hello/:name', function(req, res) {
    res.send('hello ' + req.params.name + '!');
});


// // home page route (http://localhost:8080)
router.get('/', function(req, res) {
     res.send('im the home page!');  
     });

//     // about page route (http://localhost:8080/about)
router.get('/about', function(req, res) {
         res.send('im the about page!'); 
         });

//         // apply the routes to our application
         app.use('/', router);

app.route('/login')
 .get(function(req, res) {
   res.send('this is the login form');
});

app.listen(port);
console.log('Magic happens on port ' + port);
