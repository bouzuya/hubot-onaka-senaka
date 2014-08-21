# Description
#   A Hubot script that assist onaka and senaka
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  timerId = null

  robot.hear /お(?:なか|腹)/, (res) ->
    # せなか待ち
    timerId = setTimeout ->
      timerId = null
    , 30 * 1000

  robot.hear /(?:せ|背)(?:なか|中)/, (res) ->
    return unless timerId?
    clearTimeout timerId
    timerId = null
    res.send 'くっつくぞ！'
