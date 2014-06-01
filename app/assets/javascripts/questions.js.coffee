# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(->
  initQuestionEditForm()
  initAnswerEditForms()
  initCommentForms()
)

initQuestionEditForm = ->
  $('[data-question-container]').on('click', '[data-question-edit-button-for-id]', (event)->
    $this = $(this)

    if $this.text() == $this.attr('data-edit-value')
      $this.text($this.attr('data-cancel-value'))
      $this.siblings('[data-question-edit-form-for-id]').slideDown('fast')
    else
      $this.text($this.attr('data-edit-value'))
      $this.siblings('[data-question-edit-form-for-id]').slideUp('fast')
  )

  $('[data-question-container]').on('ajax:success', '[data-question-edit-form-for-id]', (event, data, status, xhr)->
    question = $.parseJSON(xhr.responseText).question
    $('.question_container').html(question)
  )

  $('[data-question-container]').on('ajax:error', '[data-question-edit-form-for-id]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).errors
    $(this).find('.error-messages').html(errors)
  )

initAnswerEditForms = ->
  $('[data-answers-container]').on('click', '[data-answer-edit-button-for-id]', (event)->
    $this = $(this)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $this.siblings('[data-answer-edit-form-for-id]').slideDown('fast')
    else
      $this.text($this.attr('data-show-text'))
      $this.siblings('[data-answer-edit-form-for-id]').slideUp('fast')
  )

initCommentForms = ->
  $('[data-question-container], [data-answers-container]').on('click', '[data-comment-new-button-for-id]', (event)->
    $this = $(this)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $this.siblings('[data-comment-form-for-id]').slideDown('fast')
    else
      $this.text($this.attr('data-show-text'))
      $this.siblings('[data-comment-form-for-id]').slideUp('fast')
  )

  $('[data-question-container], [data-answers-container]').on('click', '[data-comment-edit-button-for-id]', (event)->
    $this = $(this)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $this.siblings('[data-comment-body-for-id]').hide()
      $this.siblings('[data-comment-form-for-id]').show()
    else
      $this.text($this.attr('data-show-text'))
      $this.siblings('[data-comment-form-for-id]').hide()
      $this.siblings('[data-comment-body-for-id]').show()
  )