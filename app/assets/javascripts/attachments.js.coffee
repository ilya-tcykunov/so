$ ->
  $(document).on('click', '[data-attachment-remove-button-for-id]', (event) ->
    $this = $(this)
    $this.siblings('[data-attachment-destroy-parameter-for-id]').val(1)
    $this.parent().hide()
  )