# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

questionId = undefined
userId = undefined

$(->
  questionId = $('[data-full-question-container]').attr('data-full-question-container')
  userId = $('body').attr('data-user-id')

  initQuestionEditForm()
  initAnswerEditForms()
  initCometProcessing()
)

initQuestionEditForm = ->
  $('[data-full-question-container]').on('click', '[data-edit-question-button]', (event)->
    $this = $(this)
    $question = $this.closest('[data-question]')
    $readonly_content = $('[data-readonly-content]', $question)
    $editable_content = $('[data-editable-content]', $question)

    if $this.text() == $this.attr('data-show-text')
      $this.text($this.attr('data-hide-text'))
      $readonly_content.hide()
      $editable_content.show()
    else
      $this.text($this.attr('data-show-text'))
      $editable_content.hide()
      $readonly_content.show()
  )

  $('[data-full-question-container]').on('ajax:success', '[data-question]', (event, data, status, xhr)->
    question = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).replaceWith(question)
  )

  $('[data-full-question-container]').on('ajax:error', '[data-question]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).find('.error-messages').html(errors)
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

initCometProcessing = ->
  PrivatePub.subscribe "/questions/" + questionId, privatePubHandler
  PrivatePub.subscribe "/admin/questions/" + questionId, privatePubHandler

privatePubHandler = (message, channel) ->
  data = message.data
  `if(data.user_id == userId) {
      return
    }`

  if data.type == 'question'
    $('[data-question="' + data.id + '"]').replaceWith(data.html)

  if data.type == 'answer'
    if data.action == 'update'
      $('[data-answer="' + data.id + '"]').replaceWith(data.html)
    else # create
      $('[data-answers-container]').append(data.html)

  if data.type == 'comment'
    if data.action == 'update'
      $('[data-comment="' + data.id + '"]').replaceWith(data.html)
    else
      $commentable = $('[data-' + data.commentable_type + '="' + data.commentable_id + '"]')
      $container = $commentable.closest('[data-' + data.commentable_type + '-container]')
      $('[data-comments-list]', $container).append(data.html)

alertCometParams = (data) ->
  alert('type: ' + data.type +
        ', id: ' + data.id +
        ', commentable_type: ' + data.commentable_type +
        ', commentable_id: ' + data.commentable_id +
        ', user_id: ' + data.user_id +
        ', action: ' + data.action)