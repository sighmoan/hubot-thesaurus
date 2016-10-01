# Description:
#   allows hubot to look up synonyms and antonyms for a given word.
#
# Configuration:
#   HUBOT_THESAURUS_API_TOKEN = must be a valid BigHugeLab's Thesaurus API token: https://words.bighugelabs.com/api.php
#
# Commands:
#   hubot what is a synonym for <word> - lists synonyms
#   hubot what is an antonym for <word> - lists synonyms
#
# Author:
#   sighmoan

pluralize = (word) ->
  if(word.slice[-1] != 's')
    return word+'s'
  return word

module.exports = (robot) ->
  THESAURUS_API_TOKEN = process.env.HUBOT_THESAURUS_API_TOKEN
  word_types = {"synonym":"syn", "synonyms":"syn", "antonym":"ant", "antonyms":"ant"}

  synonym_request = new RegExp("(what is an? |give me )?(synonym|antonym)s? for ([a-z]+)", 'i')

  robot.respond synonym_request, (msg) ->
    word_type = msg.match[2]
    api_type = word_types[msg.match[2]]
    word = msg.match[3].toLowerCase();
    
    msg.http("http://words.bighugelabs.com/api/2/"+THESAURUS_API_TOKEN+"/"+word+"/json")
        .get() (err, res, body) ->
          if(err)
            msg.send "Eh, I don't really feel like it right now."
            return

          if(body)
            words = JSON.parse(body)
            
            Object.keys(words).forEach (key, id) ->
              if(words[key][api_type])
                synonyms = words[key][api_type].join(' ')
                msg.send key+":"
                msg.send synonyms
              else
                msg.send "I know that word, but I can't think of any right now. Sorry!"
            
          else
            msg.send "Is that a real word? Never heard of it, and I know everything."