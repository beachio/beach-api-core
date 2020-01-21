$ ->
  $('#owner_user_input').parent().hide()
  $('#owner_organisation_input').parent().hide()

  $('#subscription_owner_type').on 'change', (e)->
    console.log $(e.target).val()

    if $(e.target).val() == 'BeachApiCore::User'
      $('#owner_user_input').parent().show()
      $('#owner_organisation_input').parent().hide()

    if $(e.target).val() == 'BeachApiCore::Organisation'
      $('#owner_user_input').parent().hide()
      $('#owner_organisation_input').parent().show()

  $('#subscription_cvc').on 'keyup', (e)->
    if $(e.target).val().length>3
      $(e.target).val($(e.target).val().slice(0,-1))
      e.preventDefault()