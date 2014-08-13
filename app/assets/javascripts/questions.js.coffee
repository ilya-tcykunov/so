questionId = undefined
userId = undefined

$(->
  questionId = $('[data-full-question-container]').attr('data-full-question-container')
  userId = $('body').attr('data-user-id')

  initQuestionEditForm()
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

initCometProcessing = ->
  PrivatePub.subscribe "/admin/questions/" + questionId, privatePubHandler
  PrivatePub.subscribe "/questions/" + questionId, (message, channel)->
    `if(message.data.chunk_author_id == userId){
      return;
    };`
    privatePubHandler(message, channel)
  PrivatePub.subscribe "/chunk_author/questions/" + questionId, (message, channel)->
    `if(message.data.chunk_author_id != userId){
      return;
    };`
    privatePubHandler(message, channel)

privatePubHandler = (message, channel) ->
  data = message.data
  # actors get data in ajax response
  `if(data.actor_id == userId) {
    return;
  };`

  if data.chunk_type == 'question'
    $('[data-question="' + data.chunk_id + '"]').replaceWith(data.html)

  if data.chunk_type == 'answer'
    if data.action == 'update'
      $('[data-answer="' + data.chunk_id + '"]').replaceWith(data.html)
    else # create
      $('[data-answers-list]').append(data.html)

  if data.chunk_type == 'comment'
    if data.action == 'update'
      $('[data-comment="' + data.chunk_id + '"]').replaceWith(data.html)
    else
      $commentable = $('[data-' + data.commentable_type + '="' + data.commentable_id + '"]')
      $container = $commentable.closest('[data-' + data.commentable_type + '-container]')
      $('[data-comments-list]', $container).append(data.html)

  if data.chunk_type == 'voting'
    $votable = $('[data-' + data.votable_type + '="' + data.votable_id + '"]')
    $('[data-common-opinion]', $votable).html(data.html)

alertCometParams = (data) ->
  alert('chunk_type: ' + data.chunk_type +
        ', chunk_id: ' + data.chunk_id +
        ', chunk_author_id: ' + data.chunk_author_id +
        ', commentable_type: ' + data.commentable_type +
        ', commentable_id: ' + data.commentable_id +
        ', votable_type: ' + data.votable_type +
        ', votable_id: ' + data.votable_id +
        ', actor_id: ' + data.actor_id +
        ', action: ' + data.action)