#= require active_admin/base
#= require activeadmin_addons/all
#= require active_admin/permission
#= require jquery-ui
#= require autocomplete-rails
#= require active_admin/achievement
#= require active_admin/reward

$ ->
  COUNT = -1;
  $('.js-keepers').on 'change', '.js-keeper_select', (e) ->
    keeper = $(e.target).val().split('#')
    $(e.target).parents('.js-keeper_wrapper').find('.js-keeper_type').val(keeper[0])
    $(e.target).parents('.js-keeper_wrapper').find('.js-keeper_id').val(keeper[1])

  $('.js-modes').on 'change', '.js-mode_select', (e) ->
    mode = $(e.target).val().split('#')
    $(e.target).parents('.js-mode_wrapper').find('.js-mode_type').val(mode[0])
    $(e.target).parents('.js-mode_wrapper').find('.js-mode_id').val(mode[1])
    
  $('.js-reward_to').on 'change', '.js-reward_to_select', (e) ->
    mode = $(e.target).val().split('#')
    $(e.target).parents('.js-reward_to_wrapper').find('.js-reward_to_type').val(mode[0])
    $(e.target).parents('.js-reward_to_wrapper').find('.js-reward_to_id').val(mode[1])

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

  $('#doorkeeper_application_current_application_logo').hide()
  
  $('#doorkeeper_application_current_background_image').hide()

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
    else if (body.val() == 'forgot_password' || body.val() == 'confirm_account' || body.val() == 'webhook_reward_achieved')
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

  add_placeholder_text = (body= $('#mail_body_body_text'), type = $('#mail_body_mail_type'), index = "") ->
    body.removeAttr("placeholder")
    if type.val() == 'invitation'
      body.attr('placeholder', text_for_invitation())
    else if type.val() == 'forgot_password'
      body.attr('placeholder', text_for_restore())
    else if type.val() == 'confirm_account'
      body.attr('placeholder', text_for_accept())

  show_hide_button_fields = (type = $('#mail_body_mail_type'), button_color = $('#mail_body_button_color_input'), text_color = $('#mail_body_button_text_color_input') ) ->
    if type.val() == 'webhook_reward_achieved'
      button_color.hide()
      text_color.hide()
    else
      button_color.show()
      text_color.show()

  if ($('#mail_body_mail_type').val() != "" && $('#mail_body_mail_type').val() != undefined)
    note_add_func()
    show_hide_button_fields()
    add_placeholder_text()

  $('#mail_body_mail_type').on 'change', (e) ->
    note_add_func()
    show_hide_button_fields()
    add_placeholder_text()

  $('.application_mail_type').each (index) ->
    note_add_func($("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_greetings_text_input"), index )
    add_placeholder_text($("#doorkeeper_application_mail_bodies_attributes_#{index}_body_text"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"))
    show_hide_button_fields($("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_color_input"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_text_color_input"))


  $('#new_doorkeeper_application, #edit_doorkeeper_application').on 'change', '.application_mail_type', (e) ->
    index = this.id.split('_')[5]
    note_add_func($("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_greetings_text_input"), index )
    add_placeholder_text($("#doorkeeper_application_mail_bodies_attributes_#{index}_body_text"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), index)
    show_hide_button_fields($("#doorkeeper_application_mail_bodies_attributes_#{index}_mail_type"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_color_input"), $("#doorkeeper_application_mail_bodies_attributes_#{index}_button_text_color_input"))


  header_text_for_invitation_view = () ->
    "Please complete your registration to accept the invitation to [GROUP_NAME]"
  success_text_for_invitation_view = () ->
    "Success! Welcome to the [GROUP_TYPE] [GROUP_NAME]. \n You can now log in with your Mineful ID."
  header_text_for_forgot_view = () ->
    "Please enter a new password"
  success_text_for_forgot_view = () ->
    "Success! Your password has been changed.\n\n You can now log in with your Mineful ID"
  header_text_for_confirm_view = () ->
    "Please set your new password to complete your account setup"
  success_text_for_confirm_view = () ->
    "Success! Your account has been verified. \n\n You can now log in with your Mineful ID."


  add_view_placeholder_text = (type = $('#custom_view_view_type'), index = "", header = $('#custom_view_header_text'), success = $('#custom_view_success_text')) ->
    header.removeAttr("placeholder")
    success.removeAttr("placeholder")
    if type.val() == 'invitation'
      header.attr('placeholder', header_text_for_invitation_view())
      success.attr('placeholder', success_text_for_invitation_view())
    else if type.val() == 'forgot_password'
      header.attr('placeholder', header_text_for_forgot_view())
      success.attr('placeholder', success_text_for_forgot_view())
    else if type.val() == 'confirm_account'
      header.attr('placeholder', header_text_for_confirm_view())
      success.attr('placeholder', success_text_for_confirm_view())

  show_hide_button_element = (button, index = "", type) ->
    if (index == "")
      base = "#custom_view_"
    else
      base = "#doorkeeper_application_custom_views_attributes_#{index}_"
    if (type == true )
      $("#{base}success_button_#{button}_link_input").show()
      $("#{base}success_button_#{button}_icon_type_input").show()
      $("#{base}success_button_#{button}_text_input").show()
    else
      $("#{base}success_button_#{button}_link_input").hide()
      $("#{base}success_button_#{button}_icon_type_input").hide()
      $("#{base}success_button_#{button}_text_input").hide()

  show_hide_element = (type = $('#custom_view_view_type'), index = "") ->
    if (index == "")
      base = "#custom_view_"
    else
      base = "#doorkeeper_application_custom_views_attributes_#{index}_"
    if (type.val() == 'invitation')
      $("#{base}success_button_style_input").show()
      $("#{base}success_button_first_available_input").show()
      $("#{base}success_button_second_available_input").show()
      $("#{base}success_button_third_available_input").show()
      show_hide_button_element("first", index, $("#{base}success_button_first_available").prop("checked"))
      show_hide_button_element("second", index, $("#{base}success_button_second_available").prop("checked"))
      show_hide_button_element("third", index, $("#{base}success_button_third_available").prop("checked"))
    else
      $("#{base}success_button_style_input").hide()
      $("#{base}success_button_first_available_input").hide()
      $("#{base}success_button_first_link_input").hide()
      $("#{base}success_button_first_icon_type_input").hide()
      $("#{base}success_button_first_text_input").hide()
      $("#{base}success_button_second_available_input").hide()
      $("#{base}success_button_second_link_input").hide()
      $("#{base}success_button_second_icon_type_input").hide()
      $("#{base}success_button_second_text_input").hide()
      $("#{base}success_button_third_available_input").hide()
      $("#{base}success_button_third_link_input").hide()
      $("#{base}success_button_third_icon_type_input").hide()
      $("#{base}success_button_third_text_input").hide()


  add_view_note_for_invitations = (type = $('#custom_view_view_type'), insert_before = $('#custom_view_header_text_input'), index= "empty") ->
    $(".beach_api_core_#{index}_view_note").remove();
    if (type.val() == 'invitation' )
      note_text = "NOTE: You can use next type of constant for Greetings text, Body Text, Button Text, Signature Text and Footer Text"
      note = "<div class='beach_api_core_note beach_api_core_#{index}_view_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_view_note'>"
      note_text = " - [GROUP_TYPE] - using this constant in text it will be replaced by group type (team/organisation)."
      note += "<div class='beach_api_core_note beach_api_core_#{index}_view_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_view_note'>"
      note_text = " - [GROUP_NAME] - using this constant in text it will be replaced by team/organisation name in email."
      note += "<div class='beach_api_core_note beach_api_core_#{index}_view_note'>#{note_text}</div><br class='beach_api_core_note beach_api_core_#{index}_view_note'>"
      insert_before.prepend(note)

  add_view_note_for_success = (type = $('#custom_view_view_type'), insert_before = $('#custom_view_success_button_first_available_input'), index= "empty") ->
    $(".beach_api_core_#{index}_view_note_success").remove();
    if (type.val() == 'invitation' )
      note_text = "NOTE: For icon type you can use only icon classes from this list for Font Awesome: <a style='color:orange' href=\"https://fontawesome.com/v4.7.0/icons/\">Icons.</a>  Example of icon input: fa fa-apple "
      note = "<div class='beach_api_core_note beach_api_core_#{index}_view_note_success'>#{note_text}</div><br class='beach_api_core_#{index}_view_note_success'><br class='beach_api_core_#{index}_view_note_success'>"
      insert_before.prepend(note)

  $('#custom_view_view_type').on 'change', (e) ->
    add_view_placeholder_text();
    add_view_note_for_invitations();
    add_view_note_for_success();
    show_hide_element();

  if ($('#custom_view_view_type').val() != undefined || $('#custom_view_view_type').val() != "" )
    add_view_placeholder_text();
    add_view_note_for_invitations();
    add_view_note_for_success();
    show_hide_element()

  $('.custom_button_available').on 'change', (e) ->
    show_hide_element();

  $('.application_view_type').each (index) ->
    COUNT += 1;
    type = $("#doorkeeper_application_custom_views_attributes_#{index}_view_type")
    success = $("#doorkeeper_application_custom_views_attributes_#{index}_success_text")
    header = $("#doorkeeper_application_custom_views_attributes_#{index}_header_text")
    add_view_placeholder_text(type, index, header, success)
    show_hide_element(type, index)
    add_view_note_for_invitations(type, $("#doorkeeper_application_custom_views_attributes_#{index}_header_text_input"), index)
    add_view_note_for_success(type, $("#doorkeeper_application_custom_views_attributes_#{index}_success_button_first_available_input"), index);

  $("a.button.has_many_add").on 'click', (e) ->
    COUNT += 1
    setTimeout ->
      show_hide_element($("#doorkeeper_application_custom_views_attributes_#{COUNT}_view_type"), COUNT)
      add_view_note_for_success($("#doorkeeper_application_custom_views_attributes_#{COUNT}_view_type"), $("#doorkeeper_application_custom_views_attributes_#{COUNT}_success_button_first_available_input"), COUNT);
    , 500

  $('#new_doorkeeper_application, #edit_doorkeeper_application').on 'change', '.button_available', (e) ->
    index = this.id.split("_")[5]
    type = $("##{this.id}").prop('checked')
    show_hide_button_element(this.id.substr("doorkeeper_application_custom_views_attributes_#{index}_success_button_".length).split('_')[0], index, type)

  $('#new_doorkeeper_application, #edit_doorkeeper_application').on 'change', '.application_view_type', (e) ->
    index = this.id.split('_')[5]
    type = $("#doorkeeper_application_custom_views_attributes_#{index}_view_type")
    success = $("#doorkeeper_application_custom_views_attributes_#{index}_success_text")
    header = $("#doorkeeper_application_custom_views_attributes_#{index}_header_text")
    add_view_placeholder_text(type, index, header, success)
    show_hide_element(type, index)
    add_view_note_for_success(type, $("#doorkeeper_application_custom_views_attributes_#{index}_success_button_first_available_input"), index);
    add_view_note_for_invitations(type, $("#doorkeeper_application_custom_views_attributes_#{index}_header_text_input"), index)