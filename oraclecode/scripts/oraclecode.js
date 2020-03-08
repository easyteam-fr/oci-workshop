"use strict";

// Description
//   A hubot script that interact Slack for Oracle Code
//
// Configuration:
//
// Commands:
//   hubot hi: says hi!
//   hubot love: sends a love message
//   hubot start: starts listening you Twitter for #oraclecode
//   hubot stop: stops listening you Twitter for #oraclecode
//   hubot version: displays the oraclecode bot version
//
// Notes:
//   <optional notes required for the script>
//
// Author:
//   Gregory Guillou <gregory.guillou@resetlogs.com>

const Twitter = require("twitter");
const fs = require("fs");
const search = new RegExp(process.env.HUBOT_SEARCH, "i");

const client = new Twitter({
  consumer_key: process.env.TWITTER_CONSUMER_KEY,
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
  access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY,
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
});

module.exports = robot => {
  let display = false;
  let started = false;

  robot.hear(/(.*) hi$/i, message => {
    const sentence = Math.floor(Math.random() * 15);
    const formula = [
      `Hi, so glad you need me...`,
      `Hey, where have you been?`,
      `Hello, sunshine! Are you human?`,
      `Howdy, partner!`,
      `Hey, howdy, hi!`,
      `What’s kickin’, little chicken?`,
      `Peek-a-boo! Yoo-hu`,
      `Howdy-doody!`,
      `Hey there, freshman!`,
      `I'm a bot and I'm a bad guy!!!`,
      `Hi, Mister or is it Madam?`,
      `I come in peace!`,
      `Put that cookie down!`,
      `Ahoy, matey!`,
      `Hiya!`
    ];
    message.reply(formula[sentence]);
  });

  robot.hear(/(.*) (love)$/i, message => {
    message.reply(`Gregory, you rock!!!\n`);
  });

  robot.hear(/(.*) (status)$/i, message => {
    if (started === true) {
      message.reply("I'm currently *ON* Twitter!!!\n");
      return;
    }
    message.reply("I'm *OFF* Twitter, Damn...\n");
  });

  robot.hear(/(.*) start$/i, res => {
    if (started === false) {
      client.stream(
        "statuses/filter",
        { track: process.env.HUBOT_TRACK },
        function(stream) {
          stream.on("data", function(event) {
            console.log(
              `@${event.user.screen_name} has just sent \`${event.id_str}\`...`
            );
            if (display === true) {
              if (event.text.match(search)) {
                res.send(
                  `@${event.user.screen_name} says (see \`${
                    event.id_str
                  }\` or <https://twitter.com/twitter/status/${
                    event.id_str
                  }|link>):\n\`\`\`\n${event.text}\n\`\`\`\n`
                );
              }
            }
          });

          stream.on("error", function(error) {
            console.log("ERROR:The process has crashes!!!");
            res.send("ERROR:The process has crashes!!!");
            throw error;
          });
        }
      );
      started = true;
    }
    display = true;
    res.send(`Starting capture for hashtag #${process.env.HUBOT_TRACK} !!!`);
  });

  robot.hear(/(.*) stop$/i, res => {
    display = false;
    res.send(`Stopping capture for hashtag #${process.env.HUBOT_TRACK} !!!`);
  });

  robot.hear(/(.*) (version)$/i, message => {
    const content = fs.readFileSync("/app/package.json");
    const jsonContent = JSON.parse(content);
    message.reply(`The version deployed is \`${jsonContent.version}\`\n`);
  });
};
