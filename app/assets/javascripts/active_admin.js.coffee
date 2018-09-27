#= require active_admin/base
#= require activeadmin_addons/all
#= require active_admin/permission
#= require jquery-ui
#= require autocomplete-rails

$ ->
  $('.js-keepers').on 'change', '.js-keeper_select', (e) ->
    keeper = $(e.target).val().split('#')
    $(e.target).parents('.js-keeper_wrapper').find('.js-keeper_type').val(keeper[0])
    $(e.target).parents('.js-keeper_wrapper').find('.js-keeper_id').val(keeper[1])

  if ($('#webhook_kind').val() != "scores_achieved")
    $('#webhook_scores_input').hide()
  else
    $('#webhook_scores_input').show()

  $('#webhook_kind').on 'change', (e) ->
    if ($('#webhook_kind').val() != "scores_achieved")
      $('#webhook_scores_input').hide()
    else
      $('#webhook_scores_input').show()

  $('#doorkeeper_application_current_logo_image').hide()

  note_add_func = (body = $('#mail_body_mail_type'), insert_note_before = $('#mail_body_greetings_text_input'), index = "empty") ->
    $(".beach_api_core_#{index}_note").remove();
    note_text = "NOTE: You can use next type of constant for Greetings text, Body Text, Button Text, Signature Text and Footer Text"
    note = "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
    note_text = " - [APPLICATION_NAME] - using this constant in text it will be replaced by the name of your application."
    note += "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
    if (body.val() == 'invitation' )
      note_text = " - [INVITEE_NAME] - using this constant in text it will be replaced by invitee name in email."
      note += "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
      note_text = " - [GROUP_NAME] - using this constant in text it will be replaced by team/organisation name in email."
      note += "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
      note_text = " - [INVITATION_FROM_USER] - using this constant in text it will be replaced by the name of the user who sent the invitation."
      note += "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
      insert_note_before.prepend(note)
    else if (body.val() == 'forgot_password' || body.val() == 'confirm_account')
      note_text = " - [USER_NAME] - using this constant in text it will be replaced with the username to whom the password recovery email will be sent."
      note += "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
      if body.val() == 'forgot_password'
        note_text = " - [RESET_TOKEN] - using this constant in text it will be replaced with the reset_token to restore the password."
        note += "<div class='beach_api_core_note beach_api_core_#{index}_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_note'>"
      insert_note_before.prepend(note)

  text_for_invitation = () ->
    "You have been invited to join [GROUP_NAME] by [INVITATION_FROM_USER]. \n\n" +
      "If you do not currently have an [APPLICATION_NAME] account, you will be given the opportunity to sign up," +
      " otherwise you can login and link your existing account to this organisation."

  text_for_accept = () ->
    "Thank you for registering with [APPLICATION_NAME]. \n\n" +
      "In order to complete your registration and activate your account, you need to verify \nyour email address."
  text_for_restore = () ->
    "We recently received a request for a forgotten password. \n\n" +
      "You can use this token [RESET_TOKEN] to restore the password"

  show_elements = (index) ->
    if index == ""
      $("#mail_body_button_text_color_input").show();
      $("#mail_body_button_color_input").show();
      $("#mail_body_button_text_input").show();
    else
      $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_text_color_input").show();
      $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_color_input").show();
      $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_text_input").show();

  add_placeholder_text = (body= $('#mail_body_body_text'), type = $('#mail_body_mail_type'), index = "") ->
    body.removeAttr("placeholder")
    if type.val() == 'invitation'
      show_elements(index)
      body.attr('placeholder', text_for_invitation())
    else if type.val() == 'forgot_password'
      if index == ""
        $("#mail_body_button_text_color_input").hide();
        $("#mail_body_button_color_input").hide();
        $("#mail_body_button_text_input").hide();
      else
        $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_text_color_input").hide();
        $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_color_input").hide();
        $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_text_input").hide();
      body.attr('placeholder', text_for_restore())
    else if type.val() == 'confirm_account'
      show_elements(index)
      body.attr('placeholder', text_for_accept())


  if ($('#mail_body_mail_type').val() != "" && $('#mail_body_mail_type').val() != undefined)
    note_add_func()
    add_placeholder_text()

  $('#mail_body_mail_type').on 'change', (e) ->
    note_add_func()
    add_placeholder_text()

  $('.application_mail_type').each (index) ->
    note_add_func($("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_greetings_text_input"), index )
    add_placeholder_text($("#doorkeeper_application_mail_bodies_attributes_#{index}_body_text"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"))

  $('#new_doorkeeper_application, #edit_doorkeeper_application').on 'change', '.application_mail_type', (e) ->
    index = this.id.split('_')[5]
    note_add_func($("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_greetings_text_input"), index )
    add_placeholder_text($("#doorkeeper_application_mail_bodies_attributes_#{index}_body_text"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), index)