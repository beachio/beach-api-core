$ ->
  load_config = () ->
    hide_fields()
    url = window.location.pathname;
    split_array = url.split('/');
    reward_id = 0;
    if (split_array[split_array.length - 1] == "edit")
      reward_id = split_array[split_array.length - 2 ];
    if reward_id > 0
      path = "/admin/rewards/get_reward_config?achievement_id=" + $('#reward_achievement_id').val() + "&&reward_id=" + reward_id
    else
      path = "/admin/rewards/get_reward_config?achievement_id=" + $('#reward_achievement_id').val()
    $.get path, (data) ->
      reward_to = $('select[name=reward_to]')
      reward_to.find('option').remove();
      reward_to.append($('<option></option>'))
      for  i in [0...data["reward_to"].length]
        reward_to.append($('<option></option>').attr("value", data["reward_to"][i][1]).text(data["reward_to"][i][0]))
        if (data["reward_to"][i][2] == true)
          reward_to.find("option[value = '" + data["reward_to"][i][1] + "']").attr('selected', 'selected').change();
      $('#reward_reward_to_input').show()
      gifts = $('#reward_giftbit_brand_id')
      gifts.find('option').remove()
      gifts.append($('<option></option>'))
      for i in [0...data['gifts'].length]
        gifts.append($('<option></option>').attr("value", data["gifts"][i][1]).text(data["gifts"][i][0]))
        if (data["gifts"][i][2] == true)
          gifts.find("option[value = '" + data["gifts"][i][1] + "']").attr('selected', 'selected').change();
      if data['gifts'].length > 0
        $('#reward_giftbit_brand_input').show()

  if ($("#edit_reward").val() != undefined || $('#new_reward').val() != undefined )
    hide_fields = () ->
      $('#reward_reward_to_input').hide()
      $('#reward_giftbit_brand_input').hide()
    hide_fields()

    if $('#reward_achievement_id').val() != ""
      load_config()

    $('#reward_achievement_id').on 'change', (e) ->
      load_config()