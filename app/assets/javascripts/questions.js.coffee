# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(->
  initQuestionEditForm()
  initAnswerEditForms()
)

initQuestionEditForm = ->
  $('[data-question-container]').on('click', '[data-question-edit-button-for-id]', (event)->
    $this = $(this)

    if $this.text() == $this.attr('data-edit-value')
      $this.text($this.attr('data-cancel-value'))
      $this.siblings('form').slideDown('fast')
    else
      $this.text($this.attr('data-edit-value'))
      $this.siblings('form').slideUp('fast')
  )


initAnswerEditForms = ->
  $('[data-answers-container]').on('click', '[data-answer-edit-button-for-id]', (event)->
    $this = $(this)

    if $this.text() == $this.attr('data-edit-value')
      $this.text($this.attr('data-cancel-value'))
      $this.siblings('form').slideDown('fast')
    else
      $this.text($this.attr('data-edit-value'))
      $this.siblings('form').slideUp('fast')
  )