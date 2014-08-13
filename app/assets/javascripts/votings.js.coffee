$ ->
  $('[data-full-question-container]').on 'click', '[data-votable-button]', (e) ->
    $this = $(this)
    data = $this.data()
    params = {}
    params[data.votableIdName] = data.votableId
    params.opinion = data.votableOpinion
    $.ajax {
      type: 'POST',
      url: data.url,
      cache: false,
      dataType: 'json',
      data: params,
      success: (data, textStatus) ->
        $this.closest('[data-voting]').find('[data-common-opinion]').html(data.html)
    }
    $this.addClass('disabled')
    $this.siblings('[data-votable-button]').removeClass('disabled')