const twilio = require("twilio");
require('dotenv').config();


const accountSid = process.env.SID;
const authToken = process.env.TOKEN;


const client = twilio(accountSid, authToken);

function sendSMS(to, body) {
  return client.messages.create({
    body,
    from: "+15418728835",
    to,
  });
}

module.exports = {
  sendSMS,
};
// call this function whenever you want
//await smsService.sendSMS(to, message);
