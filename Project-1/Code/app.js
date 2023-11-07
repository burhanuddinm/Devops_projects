const express = require('express');
const bodyParser = require('body-parser');
const moment = require('moment');
const app = express();
const port = 80;

app.use(bodyParser.urlencoded({ extended: true }));
app.set('view engine', 'ejs');

// Render the initial form for users to enter their name and birthday
app.get('/', (req, res) => {
  res.render('index', { daysLeft: null, age: null });
});

// Handle the form submission
app.post('/calculate', (req, res) => {
  const name = req.body.name;
  const birthday = moment(req.body.birthday, 'YYYY-MM-DD');
  const today = moment();
  
  // Calculate the number of days until the next birthday
  const nextBirthday = moment(birthday);
  nextBirthday.year(today.year());
  if (nextBirthday.isBefore(today)) {
    nextBirthday.add(1, 'years');
  }
  
  const daysLeft = nextBirthday.diff(today, 'days');

  // Calculate the age
  const age = today.diff(birthday, 'years');
  
  res.render('index', { name, daysLeft, age });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
