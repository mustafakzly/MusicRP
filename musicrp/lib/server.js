var express = require('express');
var app = express();

app.get('/callback', function (req, res) {
  res.send('Ana sayfa');
});

app.get('/callback', function (req, res) {
  var code = req.query.code;
  console.log('Code: ' + code);
  res.send('Code alındı: ' + code);
});

app.listen(8080, '127.0.0.1', function () {
  console.log('App listening on port 8080!');
});