---
title:        "React.js: Getting Started"
content_url:  https://app.pluralsight.com/library/courses/react-js-getting-started
author:       samer-buna
provider:     pluralsight
price:        requires-subscription-with-provider
start_date:   2017-02-05
type:         online
support:      video
level:        beginner
myrating:     5/5
release_date: 2015-06-13
tags:         code html javascript webdev react
duration:
  exact:      01:29h
  approx:
    value:    1.5
    unit:     hours
summary: >
  This course covers the basics of React.js and prepares the student
  to start developing web applications with the library. React.js is a
  an open-source JavaScript library for creating user interfaces with
  a focus on the UI that's abstracted from the DOM, and a one-way
  reactive data flow. The course will explain using an example web
  application how to use React.js. The application will be a simple
  in-browser, math skills kids' game.
---

# Comment

Very short and to the point. It's a very nice introduction to
[[react]], assuming good knowledge of [[html]], [[css]] and
[[javascript]]. It uses _traditional_
[ES5](https://johnpapa.net/es5-es2015-typescript/) [[javascript]]. I
practiced what I learned in this course in [this
pen](http://codepen.io/rbf/pen/dNKwKm).

# Basics

Let's meet the basics of [[react]] by building a minimal `Hello
World!` example. Note that since we are writing this summary after
having met [[react]] with the video tutorial
["{{page.title}}"]({{page.content_url}}), we will be using
_traditional_ pre–ES6 [[javascript]]. Therefore please refer to the
official documentation about [[react]] written [without ES6].

## Installation

There are several ways to install or refer to the [[react]] library as
explained in the [installation
page](((react.installation_doc_url))) of [[react]]. For example we can
include the corresponding `script` tags into our [[html]] file:

``` html
<script src="https://unpkg.com/react@15/dist/react.min.js"></script>
<script src="https://unpkg.com/react-dom@15/dist/react-dom.min.js"></script>
```

## Root element

The first thing that we need to modify the [[html]] with [[react]] is
an element that it will be able to control, like for example a basic
`div#root`:

``` html
<div id="root"></div>
```

## Component

Then we create a [[react]] _component_ using the function
[`React.createClass`], which receives a [[javascript]] object as
parameter. The only required key of this object is [`render`], which
contains a function that will return a _representation_ of the
[[html]] element that we want to display:

``` jsx
var Text = React.createClass({
  render:  function(){
    return (
      <h1>Hello World!</h1>
    )
  }
});
```

The value of the `return` statement is a special syntax called
[[jsx]], which is a kind of syntactic sugar that gets translated by
[[react]] into regular [[javascript]] code, in this case:
`React.createElement('h1', null, 'Hello World!');`. Files containing
[[jsx]] must be defined in a file with the ((jsx.ext)) extension to
let [[react]] know that it has to be preprocessed. It might look a bit
strange at the beginning to see a kind of [[html]] markup embedded
into [[javascript]], but you quickly get used to it and it has the
nice advantage to let us write the elements that we want to render in
a syntax very close to the actual targeted [[html]].

## Rendering the main component

Once we have defined the element that we want to display, we _render_
it on the `root` node that we prepared at the beginning using
[`ReactDOM.render`]:

``` jsx
ReactDOM.render(
  <Text />,
  document.getElementById('root')
);
```

## Running example 1

You can check this basic `Hello World!` example with the following
pen:

{% include codepen.html id='WRYGvE' %}

# Components

The basic things to know about a [[react]] components is that they can
be reused and they can have both [_properties_](#properties) and
[_state_](#state).

## Reusability

Components can be reused multiple times, and they can be nested. A
useful pattern might be to created a `Root` or `Main` component that
is the only one being rendered directly on the [[html]], and having
this component render the rest of the components.

``` jsx
var Text = React.createClass({
  render:  function(){
    return (
      <h1>Hello World!</h1>
    )
  }
});

var Main = React.createClass({
  render:  function(){
    return (
      <div>
        <Text />
        <Text />
      </div>
    )
  }
});

ReactDOM.render(
  <Main />,
  document.getElementById('root')
);
```

As in this example we can also render _standard_ [[html]] elements
like `div`s, `span`s and all the usual things. Note however that those
start with a lowercase letter whereas our custom elements have to
start  with an uppercase letter.

## Properties

To tweak the behavior of an element we can use **properties** when
adding the component to its parent. Properties are given with similar
syntax as the [[xml]] attributes, i.e. `<Text foo="bar"/>`. The
component itself can then access the property values with
`this.props.foo`. When embedding the property value within the [[jsx]]
it has to be enclosed with a pair of curly brackets.

``` jsx
var Text = React.createClass({
  render:  function(){
    return (
      <h1>Hello {this.props.name}!</h1>
    )
  }
});

var Main = React.createClass({
  render:  function(){
    return (
      <div className="container">
        <Text name="Major Tom"/>
        <Text name="Ground Control"/>
      </div>
    )
  }
});
```

Note that the [[html]] `class` of the component is given with the
property `className` instead of simply `class`.

## State

Each component can also have **state**. Whereas the
[properties](#properties) are not supposed to change during the
lifecycle of the component, the state can (and probably will) change.
And one of main interests of [[react]] is that **whenever the state of
a component changes, [[react]] will re-render the needed components
automatically** ([and in a very efficient
way](http://stackoverflow.com/a/23995928)).

The state is initialized as a [[javascript]] object returned by the
function under the [`getInitialState`] key of the parameter object of
the [`React.createClass`] call. The state is updated by passing
an object with the keys that need to change to [`this.setState()`].

``` jsx
var Text = React.createClass({
  getInitialState:  function() {
    return {
      times: 1
    }
  },
  increaseTimes: function() {
    this.setState({times: this.state.times + 1});
  },
  render:  function(){
    return (
      <h1 onClick={this.increaseTimes}>Hello {this.props.name}! x{this.state.times}</h1>
    )
  }
});

var Main = React.createClass({
  render:  function(){
    return (
      <div className="container">
        <Text name="Major Tom"/>
        <Text name="Ground Control"/>
      </div>
    )
  }
});
```

We call [`this.setState()`] within a new function that we have created
in a new property `increaseTimes` on the original component object. To
bind this function to the `mouse click` event, we use
`onClick={this.increaseTimes}`. There are a [lot of events] we can
bind behavior to.

## Running example 2

You can check this example with properties and state with the
following pen:

{% include codepen.html id='apPZzW' %}

A more complex pen is referenced in the [Comment section](#comment) at
the beginning of this article.

# Conclusion

This is a quick overview of the basics of [[react]] based of the
["{{page.title}}"]({{page.content_url}}) video tutorial, with the aim
of being a reference of the things learned. The video tutorial is very
worth watching since is much more interactive as reading this dry
text.


[without ES6]: https://facebook.github.io/react/docs/react-without-es6.html
[`React.createClass`]: https://facebook.github.io/react/docs/react-api.html#createclass
[`render`]: https://facebook.github.io/react/docs/react-component.html#render
[`ReactDOM.render`]: https://facebook.github.io/react/docs/react-dom.html#render
[`getInitialState`]: https://facebook.github.io/react/docs/react-without-es6.html#setting-the-initial-state
[`this.setState()`]: https://facebook.github.io/react/docs/react-component.html#setstate
[lot of events]: https://facebook.github.io/react/docs/events.html#supported-events
