---
title:  "Print a lazy seq"
tags: code clojure laziness printing
redirect_from:
    - /2015/04/20/print-lazy-seq/
---

To get a `str` representation of a non-lazy collection is not an issue:

```clojure
(str (mapv inc (range 10)))
;; => "[1 2 3 4 5 6 7 8 9 10]"
```

But for lazy seqs `str` does  evaluate the sequence (_Achtung_ with infinite sequences!) *but* we get the object representation:

```clojure
(str (map inc (range 10)))
;; => "clojure.lang.LazySeq@c5d38b66"
```

We can use `pr-str` for lazy seqs:

```clojure
(pr-str (map inc (range 10)))
;; => "(1 2 3 4 5 6 7 8 9 10)"
```

For printing with `print` or `println` this is not necessary:

```clojure
(println (map inc (range 10)))
;; (1 2 3 4 5 6 7 8 9 10)
;; => nil
```

But it is for `printf`:

```clojure
(printf "This is a lazy seq: %s\n" (map inc (range 10)))
;; This is a lazy seq: clojure.lang.LazySeq@c5d38b66
;; => nil
(printf "This is a lazy seq: %s\n" (pr-str (map inc (range 10))))
;; This is a lazy seq: (1 2 3 4 5 6 7 8 9 10)
;; => nil
```

