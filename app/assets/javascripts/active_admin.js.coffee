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
