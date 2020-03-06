$ ->
  show_hide = (target) ->
    $('#subscription_application_input').hide()

    if $(target).val() == 'BeachApiCore::User'
      $('#owner_user_input').parent().show()
      $('#owner_organisation_input').parent().hide()
      $('#subscription_application_input').show()

    if $(target).val() == 'BeachApiCore::Organisation'
      $('#owner_user_input').parent().hide()
      $('#owner_organisation_input').parent().show()

    if ($('#subscription_owner_type').val().length == 0)
      $('#owner_user_input').parent().hide()
      $('#owner_organisation_input').parent().hide()
      $('#subscription_application_input').hide()

  owner_type_val = $('#subscription_owner_type').val()
  if (owner_type_val != undefined && owner_type_val.length > 0)
    show_hide(($('#subscription_owner_type')))
  else
    $('#owner_user_input').parent().hide()
    $('#owner_organisation_input').parent().hide()
    $('#subscription_application_input').hide()

  $('#subscription_owner_type').on 'change', (e)->
    show_hide(e.target)

  $('#subscription_cvc').on 'keyup', (e)->
    if $(e.target).val().length>3
      $(e.target).val($(e.target).val().slice(0,-1))
      e.preventDefault()