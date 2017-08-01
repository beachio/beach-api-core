NEW_ACTION_MARKUP = "<li class='js-action-wrapper boolean input optional' id='permission_action_{action}_input'>" +
                    "<input type='hidden' name='permission[action_{action}]' value='false'>" +
                    "<label for='permission_action_{action}'>" +
                    "<input type='checkbox' name='permission[action_{action}]' id='permission_action_{action}' value='true'>{action}</label>" +
                    "<a href='#'>Remove</a></li>"
$ ->
  $('.js-action-wrapper').each (index, item) ->
    $(item).append("<a href='#'>Remove</a>")

  $('.permission').on 'click', '.js-action-wrapper a', (e) ->
    e.preventDefault()
    if confirm('Are you sure?')
      $(e.target).parents('.js-action-wrapper').remove()

  $('#js-add-action').on 'click', (e) ->
    e.preventDefault()
    return unless $('#new_action').val().length
    $(NEW_ACTION_MARKUP.replace(/\{action\}/g, $('#new_action').val())).insertBefore($('#js-action-placeholder'))
    $('#new_action').val('')
