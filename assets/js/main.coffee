---
---

# SOURCE: https://learn.jquery.com/using-jquery-core/document-ready/
jQuery ->
  do ( $$ = window.rbf ||= {}, $=jQuery ) ->
    # Array prototype extensions
    $.extend Array.prototype,
      contains: (thing) -> $.inArray(thing, @) != -1

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
      if tag? and tag != ''
        $('.translation-link').css('display','none')
        $("#lang-tags .lang-tags[data-tags*='" + tag.slice(1) + "']").each (i,elem)->
          langWithTag = $(elem).data('lang')
          $('.translation-link.' + langWithTag).css('display','')
        if $('.translation-link').filter(-> $(@).css('display') != 'none').length == 1
          $('.translation-link').css('display','none')

    updateElemsToShow = ->
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
          updateTranslationLinks ''

    updateElemsToShow()

    $(window).on 'hashchange', updateElemsToShow

    # Make all non-local links open in new tab
    $("a[href^=http]").attr("target", "_blank");

    # SOURCE: https://github.com/basimilch/basimilch.github.io/blob/c3c8a6b/javascripts/custom.js#L21-L31
    $('[data-href]').click (e) ->
      href = $(@).data('href');
      if $(e.target).closest('a').length > 0
        # Let the a tag handle the link instead.
      else if e.metaKey or href.match(/^http/)
        # Open in new window.
        window.open(href, '_blank');
      else
        document.location = href;
      false
