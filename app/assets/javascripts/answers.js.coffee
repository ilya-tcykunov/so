$ ->
  initAnswerEditForms()

initAnswerEditForms = ->

  # Updating

  $('[data-answers-list]').on('click', '[data-edit-answer-button]', (event)->
    $this = $(this)
    $answer = $this.closest('[data-answer]')
    $readonly_content = $('[data-readonly-content]', $answer)
    $editable_content = $('[data-editable-content]', $answer)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $readonly_content.hide()
      $editable_content.show()
    else
      $this.text($this.attr('data-show-text'))
      $editable_content.hide()
      $readonly_content.show()
  )

  $('[data-full-question-container]').on('ajax:success', '[data-answer]', (event, data, status, xhr)->
    answer = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).closest('[data-answer]').replaceWith(answer)
  )

  $('[data-full-question-container]').on('ajax:error', '[data-answer]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).find('.error-messages').html(errors)
  )

  # Creating

  $('[data-full-question-container]').on('ajax:success', '[data-new-answer]', (event, data, status, xhr)->
    answer = $.parseJSON(xhr.responseText).html
    $('[data-answers-list]').append(answer)

    $new_answer_form = $(event.currentTarget)
    $('[data-body]', $new_answer_form).val('')
    $('.error-messages', $new_answer_form).html('')
  )

  $('[data-full-question-container]').on('ajax:error', '[data-new-answer]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).find('.error-messages').html(errors)
  )