---
layout: post
title:  "Print a lazy seq"
date:   2015-04-20
categories: code clojure
tags: clojure lazyness printing
---

To get a `str` representation of a non-lazy collection is not an issue:

{% highlight clojure %}
(str (mapv inc (range 10)))
;; => "[1 2 3 4 5 6 7 8 9 10]"
{% endhighlight %}

But for lazy seqs `str` does  evaluate the sequence (_Achtung_ with infinite sequences!) *but* we get the object representation:

{% highlight clojure %}
(str (map inc (range 10)))
;; => "clojure.lang.LazySeq@c5d38b66"
{% endhighlight %}

We can use `pr-str` for lazy seqs:

{% highlight clojure %}
(pr-str (map inc (range 10)))
;; => "(1 2 3 4 5 6 7 8 9 10)"
{% endhighlight %}

For printing with `print` or `println` this is not necessary:

{% highlight clojure %}
(println (map inc (range 10)))
;; (1 2 3 4 5 6 7 8 9 10)
;; => nil
{% endhighlight %}

But it is for `printf`:

{% highlight clojure %}
(printf "This is a lazy seq: %s\n" (map inc (range 10)))
;; This is a lazy seq: clojure.lang.LazySeq@c5d38b66
;; => nil
(printf "This is a lazy seq: %s\n" (pr-str (map inc (range 10))))
;; This is a lazy seq: (1 2 3 4 5 6 7 8 9 10)
;; => nil
{% endhighlight %}

