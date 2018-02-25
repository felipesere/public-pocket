var root = document.getElementById("cards")

var Header = {
  view: function() {
    return m("header", {class: "card-header"},
      m("p", {class: "card-header-title"}, "Generic numeric functions in safe, stable Rust with the num crate"))
  }
};

var Content = {
  view: function() {
    return m("", {class: "card-content"},
      m("", {class: "content"},
        [
        "Note: This post assumes some familiarity with Rust, in particular traits.  It is useful to be able to write code that is generic over multiple types, such as integer types.",
        m("br"),
        m("time", {datetime: "2017-4-3"}, "20:38 - 3 Apr 2017")
      ]));
  }
}

var Footer = {
  view: function() {
    return m("footer", {class: "card-footer"},[
      m("a", {href: "#", class: "card-footer-item"}, "Save"),
      m("a", {href: "https://travisf.net/rust-generic-numbers", class: "card-footer-item"}, "Open"),
    ]);
  }
}

var Article = {
  view: function() {
    return m("", {class: "card"},
      [m(Header),
       m(Content),
       m(Footer)
      ]);
  }
}

m.mount(root, Article);
