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
  initCommentForms()
  initCometProcessing()
)

initQuestionEditForm = ->
  $('[data-full-question-container]').on('click', '[data-edit-button]', (event)->
    $this = $(this)
    $question = $this.closest('[data-question]')
    $readonly_content = $('[data-readonly-content]', $question)
    $editable_content = $('[data-editable-content]', $question)

    if $this.text() == $this.attr('data-edit-value')
      $this.text($this.attr('data-cancel-value'))
      $readonly_content.hide()
      $editable_content.show()
    else
      $this.text($this.attr('data-edit-value'))
      $editable_content.hide()
      $readonly_content.show()
  )

  $('[data-full-question-container]').on('ajax:success', '[data-question]', (event, data, status, xhr)->
    question = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).replaceWith(question)
  )

  $('[data-full-question-container]').on('ajax:error', '[data-question]', (event, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText).html
    $(event.currentTarget).find('.error-messages').replaceWith(errors)
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

initCometProcessing = ->
  #{type, id, commentable_type, commentable_id, user_id, action}
  PrivatePub.subscribe "/questions/" + questionId, (message, channel) ->
    data = message.data
    `if(data.user_id == userId) {
      return
    }`
    if data.type == 'question'
      $question = $('[data-question="' + data.id + '"]')
      if $('[data-editable-content]', $question).size() > 0
        $question.replaceWith(data.html.question)
      else
        $('[data-readonly-content]', $question).replaceWith(data.html.readonly_content)
      return

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
        $('[data-comments-contanier]', $commentable).append(data.html)

alerCometParams = ->
  alert('type: ' + data.type +
        ', id: ' + data.id +
        ', commentable_type: ' + data.commentable_type +
        ', commentable_id: ' + data.commentable_id +
        ', user_id: ' + data.user_id +
        ', action: ' + data.action)