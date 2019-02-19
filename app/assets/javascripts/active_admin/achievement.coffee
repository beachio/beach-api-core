$ ->
  if ($("#edit_achievement").val() != undefined || $('#new_achievement').val() != undefined )
    hide_config = () ->
      $('#achievement_mode_input').hide()
      $('#achievement_giftbit_brands_input').hide()
      $('#achievement_use_all_config_brands_input').hide()
      $('#achievement_available_for_input').hide()
      $('#achievement_notify_by_email_input').hide()

    show_hide_brands = () ->
      patt = new RegExp("BeachApiCore::GiftbitConfig")
      config = $('select[name=mode]').val()
      if $('#achievement_use_all_config_brands').prop('checked') || !patt.test(config)
        $('#achievement_giftbit_brands_input').hide()
      else
        $('#achievement_giftbit_brands_input').show()

    fill_available_for_select = (all) ->
      available_for = $('#achievement_available_for')
      available_array = [["Users", "users"],["Devices", "devices"],["Users and devices", "users and devices"]]
      if (all)
        array_length = 3
      else
        array_length = 2
      if available_for.val() == available_array[2][1] && !all
        available_for.find('option').remove();
      else
        available_for.find('option').not(':selected').remove();
      for i in [0...array_length]
        if available_for.val() != available_array[i][1]
          available_for.append($('<option></option>').attr("value", available_array[i][1]).text(available_array[i][0]))
      $('#achievement_available_for_input').show()

    load_config = () ->
      url = window.location.pathname;
      split_array = url.split('/');
      achievement_id = 0;
      if (split_array[split_array.length - 1] == "edit")
        achievement_id = split_array[split_array.length - 2 ];
      if achievement_id > 0
        path = "/admin/achievements/get_configs?application_id=" + $("#achievement_application_id").val() + "&&achievement_id=" + achievement_id
      else
        path = "/admin/achievements/get_configs?application_id=" + $("#achievement_application_id").val()
      $.ajax path,
        type: "GET",
        success: (data, textStatus) ->
          achievement_mode = $('select[name=mode]')
          achievement_mode.find('option').remove();
          achievement_mode.append($('<option></option>'))
          for  i in [0...data["configs"].length]
            achievement_mode.append($('<option></option>').attr("value", data["configs"][i][1]).text(data["configs"][i][0]))
            if (data["configs"][i][2] != undefined)
              achievement_mode.find("option[value = '" + data["configs"][i][1] + "']").attr('selected', 'selected').change();
          $('#achievement_mode_input').show()

    if $('#achievement_application_id').val() == ""
      hide_config()
    else
      hide_config()
      load_config()

    $('#achievement_application_id').on 'change', (e) ->
      hide_config()
      load_config()

    $('select[name=mode]').on 'change', (e) ->
      $('#achievement_available_for_input').hide()
      $('#achievement_giftbit_brands_input').hide()
      patt = new RegExp("BeachApiCore::GiftbitConfig")
      config = $('select[name=mode]').val()
      webhook_patt = new RegExp("BeachApiCore::WebhookConfig")
      if patt.test(config)
        url = window.location.pathname;
        split_array = url.split('/');
        achievement_id = 0;
        if (split_array[split_array.length - 1] == "edit")
          achievement_id = split_array[split_array.length - 2 ];
        if achievement_id > 0
          path = "/admin/achievements/get_brands?giftbit_config_id=" + config.split("#")[1] + "&&achievement_id=" + achievement_id
        else
          path = "/admin/achievements/get_brands?giftbit_config_id=" + config.split("#")[1]
        
        $.get path, (data) ->
          brands = $('#achievement_giftbit_brand_ids')
          brands.find('option').remove();
          for  i in [0...data["brands"].length]
            brands.append($('<option></option>'))
            brands.append($('<option></option>').attr("value", data["brands"][i][1]).text(data["brands"][i][0]))
            if (data["brands"][i][2] != undefined)
              brands.find("option[value = '" + data["brands"][i][1] + "']").attr('selected', 'selected').change();
          $('#achievement_use_all_config_brands_input').show()
          show_hide_brands()
          $('#achievement_notify_by_email_input').show()
          fill_available_for_select(true)
      else
        if webhook_patt.test(config)
          show_hide_brands()
          fill_available_for_select(false)
          $('#achievement_use_all_config_brands_input').hide()

    $('#achievement_use_all_config_brands').on 'change', (e) ->
      show_hide_brands()

    if $('#achievement_available_for').val() == 'devices'
      $('#achievement_notify_by_email_input').hide()
    else
      $('#achievement_notify_by_email_input').show()

    $('#achievement_available_for').on 'change', (e) ->
      if $('#achievement_available_for').val() == 'devices'
        $('#achievement_notify_by_email_input').hide()
      else
        $('#achievement_notify_by_email_input').show()