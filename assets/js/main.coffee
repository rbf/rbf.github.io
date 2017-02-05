---
---

# SOURCE: https://learn.jquery.com/using-jquery-core/document-ready/
jQuery ->
  do ( $$ = window.rbf ||= {}, $=jQuery ) ->
    # Array prototype extensions
    $.extend Array.prototype,
      contains: (thing) -> $.inArray(thing, @) != -1

    # SOURCE: http://stackoverflow.com/questions/483212/effective-method-to-hide-email-from-spam-bots
    # SOURCE: http://stackoverflow.com/questions/748780/best-way-to-obfuscate-an-e-mail-address-on-a-website
    # SOURCE: http://stackoverflow.com/questions/5041494/selecting-and-manipulating-css-pseudo-elements-such-as-before-and-after-usin
    # SOURCE: http://stackoverflow.com/questions/2170484/shouldnt-we-use-noscript-tag
    # SOURCE: https://www.labnol.org/internet/hide-email-address-web-pages/28364/
    # SOURCE: http://joemaller.com/js-mailer.shtml
    # SOURCE: http://techblog.tilllate.com/2008/07/20/ten-methods-to-obfuscate-e-mail-addresses-compared/
    $('x-rbfe').click (e) ->
      document.location = 'mai' + 'lto:' + window.xrbfe
        .replace(/YYYYY/,'\u0040')
        .replace(/XXXXX/,'\u002E')
      false

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
    $('body').on 'click', '[data-href]', (e) ->
      href = $(@).data 'href'
      if $(e.target).closest('a').length > 0
        # Let the a tag handle the link instead.
      else if e.metaKey or href.match(/^http/)
        # Open in new window.
        window.open href, '_blank'
      else
        document.location = href
      false
