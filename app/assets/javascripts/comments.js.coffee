$ ->
  initCommentForms()

initCommentForms = ->

  # Updating

  $('[data-full-question-container]').on('click', '[data-edit-comment-button]', (event)->
    $this = $(this)
    $comment = $this.closest('[data-comment]')
    $readonly_content = $('[data-readonly-content]', $comment)
    $editable_content = $('[data-editable-content]', $comment)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $readonly_content.hide()
      $editable_content.show()
    else
      $this.text($this.attr('data-show-text'))
      $editable_content.hide()
      $readonly_content.show()
  )

  $('[data-full-question-container]').on('ajax:success', '[data-comment]', (event, data, status, xhr)->
    comment = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).closest('[data-comment]').replaceWith(comment)
  )

  $('[data-full-question-container]').on('ajax:error', '[data-comment]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).find('.error-messages').html(errors)
  )

  # Creating

  $('[data-comments-container]').on('click', '[data-new-comment-button]', (event)->
    $this = $(this)
    $container = $this.closest('[data-comments-container]')
    $new_comment_block = $('[data-new-comment]', $container)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $new_comment_block.show()
    else
      $this.text($this.attr('data-show-text'))
      $new_comment_block.hide()
  )

  $('[data-full-question-container]').on('ajax:success', '[data-new-comment]', (event, data, status, xhr)->
    comment = $.parseJSON(xhr.responseText).html
    $container = $(event.currentTarget).closest('[data-comments-container]')
    $('[data-comments-list]', $container).append(comment)
    $new_comment = $('[data-new-comment]', $container)
    $('[data-body]', $new_comment).val('')
    $('.error-messages', $new_comment).html('')
    $new_comment.hide()
    $new_comment_button = $('[data-new-comment-button]', $container)
    $new_comment_button.text($new_comment_button.attr('data-show-text'))
  )

  $('[data-full-question-container]').on('ajax:error', '[data-new-comment]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).find('.error-messages').html(errors)
  )