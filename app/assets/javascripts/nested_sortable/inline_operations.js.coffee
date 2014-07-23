$ ->
  # Adding new item to the list
  $('#new-category-form').on 'ajax:success', (event, data, status, xhr) ->
    sortable_tree = $(this).siblings('ol.sortable_tree')
    $(this).find('#category_title').val('')
    list_item = sortable_tree.children('li:first').clone()
    list_item.find('ol.nested_set').remove()
    list_item.find('h4 > a').text(data.name)
    list_item.find('a.delete').attr 'href', (index, attr) ->
      attr.replace(list_item.data('node-id'), data.id)
    list_item.data('node-id', data.id)
    list_item.appendTo('ol.sortable_tree')

  # remove items that deleted
  $('a.delete').on 'ajax:success', -> $('div.item').has($(this)).parent().remove()

  # edit clicked item
  $('ol.sortable_tree h4 > a.edit').on 'click', (event) ->
    event.preventDefault()
    sortable_tree = $(this).parents('ol.sortable_tree')
    edit_link = $(this)
    h4 = $(this).parent()
    $(this).hide()
    url = $(this).attr('href')
    text = $(this).text()
    edit_box = $('<input type="text" id="#edit_box" data-url="' +
      url + '" value="' + text + '" style="width: 200px;" class="form-control"/>')
    edit_box.appendTo(h4.parent())
    edit_box.focus()

    edit_done = ->
      console.log edit_box.val().trim().length

      hide_input_box = ->
        edit_link.show()
        edit_box.remove()

      if edit_box.val().trim().length > 0
        data = {}
        attributes = {}
        title_field = 'title'
        title_field = sortable_tree.data('title-field') if sortable_tree.data('title-field')
        attributes[title_field] = edit_box.val()
        data[sortable_tree.data('model')] = attributes
        $.ajax(
          type: 'PUT'
          data: data
          url: edit_link.attr('href')
          success: ->
            edit_link.text(edit_box.val())
            hide_input_box()
          error: hide_input_box
        )
      else
        hide_input_box()

    edit_box.on 'keypress', (event)->
      $(this).trigger('focusout') if event.which == 13

    edit_box.on 'focusout', edit_done