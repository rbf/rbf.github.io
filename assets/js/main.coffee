---
---

do ( $$ = window.rbf ||= {}, $=jQuery ) ->

  clearHash = ->
    window.location.hash = ''

  showOnlyTagIndex = ->
    $('.tag-posts-list').css('display','none')
    $('#tag-index').css('display','inherit')

  showOnlyTag = ($tagElem) ->
    $('#tag-index').css('display','none')
    $('.tag-posts-list').css('display','none')
    $tagElem.css('display','inherit')

  updateElemsToShow = (e) ->
    if $('body.page-tags').length == 1
      hash = window.location.hash
      if hash?
        $tagElem = $(hash)
        if $tagElem.length == 1
          showOnlyTag $tagElem
        else
          showOnlyTagIndex()
          clearHash()
      else
        showOnlyTagIndex()

  updateElemsToShow()

  $(window).on 'hashchange', (e) ->
    updateElemsToShow()
