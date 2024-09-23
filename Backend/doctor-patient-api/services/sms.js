const twilio = require("twilio");

const accountSid = "AC435425517d445cdcd3c288f2f0baf61e";
const authToken = "242de2a4e7f0de6cec5d0eb5bc7f81a2";
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
