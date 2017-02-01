---
---

do ( $$ = window.rbf ||= {}, $=jQuery ) ->

  clearHash = ->
    window.location.hash = '' # NOTE: this triggers a 'hashchange' event

  showOnlyTagIndex = ->
    $('.tag-posts-list').css('display','none')
    $('#tag-index').css('display','inherit')
    updateTranslationLinks ''

  showOnlyTag = ($tagElem) ->
    $('#tag-index').css('display','none')
    $('.tag-posts-list').css('display','none')
    $tagElem.css('display','inherit')

  updateTranslationLinks = (tag) ->
    $('.translation-link:not(current-translation) a').attr 'href', (i, val) ->
      val.replace(/#\w*/, '') + tag

  updateElemsToShow = (e) ->
    if $('body.page-tags').length == 1
      hash = window.location.hash.trim()
      if hash? and hash != ''
        $tagElem = $(hash)
        if $tagElem.length == 1
          showOnlyTag $tagElem
          updateTranslationLinks hash
        else
          clearHash()
      else
        showOnlyTagIndex()

  updateElemsToShow()

  $(window).on 'hashchange', (e) ->
    updateElemsToShow()
