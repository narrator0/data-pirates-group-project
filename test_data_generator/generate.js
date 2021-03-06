import faker from 'faker';
import firebase from "firebase/app";
import "firebase/firestore";

var firebaseConfig = {
    apiKey: "AIzaSyA5anF7zd0xdtBatIo0UIqf5nzKCsAt0KM",
    authDomain: "ecs189e-data-pirates.firebaseapp.com",
    projectId: "ecs189e-data-pirates",
    storageBucket: "ecs189e-data-pirates.appspot.com",
    messagingSenderId: "600508162520",
    appId: "1:600508162520:web:c98a3bc9c0b4f7d52292ad",
    measurementId: "G-9Z64VWZFQL"
  };

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

let db = firebase.firestore();

let positions = ['Software Development Engineer', 'Software Engineer II', 'Software Engineer III', 'Senior Software Engineer', 'Staff Software Engineer'];
let companies = ['Facebook', 'Amazon', 'Apple', 'Netflix', 'Google', 'Microsoft'];

// create 10 fake users
for (let i = 0; i < 10; i++) {
  let userID = Math.random().toString(36).substring(2, 15);
  let about = faker.lorem.paragraph();
  let avatarURL = 'https://media-exp1.licdn.com/dms/image/C4D03AQEDIwZ03_D3JQ/profile-displayphoto-shrink_400_400/0/1516244324863?e=1620259200&v=beta&t=UohFQX25p2oQw27AbfYI1NajPP6p7ClUc2Y9W4V5J_I';
  let company = companies[Math.floor(Math.random() * companies.length)];
  let email = faker.internet.email();
  let first = faker.name.firstName();
  let last = faker.name.lastName();
  let position = positions[Math.floor(Math.random() * positions.length)];
  let role = 'mentor';

  db.collection('users').doc(userID).set({
    userID,
    about,
    avatarURL,
    company,
    email,
    first,
    last,
    position,
    role,
  })
  .then(res => {
    console.log(res);
  })
  .catch(err => {
    console.log(err);
  });
}

