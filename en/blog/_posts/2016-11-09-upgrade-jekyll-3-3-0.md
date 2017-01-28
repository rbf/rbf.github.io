---
title: "Upgrade to Jekyll 3.3.0"
tags: jekyll
---

# Hello upgraded world!

Today I spent some time tiding up my environment in order to update
the site to the latest and greatest [Jekyll 3.3.0] which was released
beginning of October 2016 with [lots of changes]. About one month
later [GitHub announced] they followed by upgrading _GitHub Pages_ to
this version. The exact `gem` versions that _GitHub Pages_ is
currently using can be found at [`pages.github.com/versions`].

[Jekyll 3.3.0]: https://jekyllrb.com/news/2016/10/06/jekyll-3-3-is-here/
[lots of changes]: https://jekyllrb.com/docs/history/#v3-3-0
[GitHub announced]: https://github.com/blog/2277-what-s-new-in-github-pages-with-jekyll-3-3
[`pages.github.com/versions`]: https://pages.github.com/versions/

# Themes

One of the most interesting and welcome changes has been the adoption
of `gem`ed themes, which was already [released in 3.2.0] last July
2016. Now themes are properly packaged as `gems` and can be
accordingly installed from [RubyGems].

[released in 3.2.0]: https://jekyllrb.com/news/2016/07/26/jekyll-3-2-0-released/
[RubyGems]: https://rubygems.org

With the upgrade I sticked to the Jekyll's default theme [`minima`],
which is more than decent. But there are a lot of themes available,
and now that they can packaged and installed in a [consistent way],
it's easier than ever to try a new look.
[`planetjekyll/awesome-jekyll-themes`] is a good place to start to
find nice and easy-to-install Jekyll themes.

[`minima`]: https://github.com/jekyll/minima
[consistent way]: http://jekyllrb.com/docs/themes
[`planetjekyll/awesome-jekyll-themes`]: https://github.com/planetjekyll/awesome-jekyll-themes

But themes are also very easy to customize and some sites out there
do trigger sometimes unexpected inspiration. For example today I came
across Michael Lee's [Simple] theme while searching about how to
[integrate _Google Analytics_] into Jekyll (which turns out it's
[taken care of] by the default [`minima`] theme mentioned above). I
like it a lot.

[Simple]: https://michaelsoolee.com/about/#colophon
[integrate _Google Analytics_]: https://michaelsoolee.com/google-analytics-jekyll/
[taken care of]: https://github.com/jekyll/minima#enabling-google-analytics
