var root = document.getElementById("cards")

var model = {
  articles: [],
  retrieveAllArticles: function() {
    var that = this
    m.request({
      method: "GET",
      url: "/api/articles",
    })
    .then(function(data) {
      that.articles = data
    })
  }
}

var Header = {
  view: function(vnode) {
    return m("header", {class: "card-header"},
      m("p", {class: "card-header-title"}, vnode.attrs.title))
  }
};

var Content = {
  view: function(vnode) {
    return m("", {class: "card-content"},
      m("", {class: "content"},
        [
          vnode.attrs.content,
          m("br"),
          m("time", {datetime: vnode.attrs.time.short}, vnode.attrs.time.long)
      ]));
  }
}

var Footer = {
  view: function(vnode) {
    return m("footer", {class: "card-footer"},[
      m("a", {href: vnode.attrs.link, class: "card-footer-item"}, "Open"),
      m("a", {href: `https://getpocket.com/edit.php?url=${vnode.attrs.link}`, class: "card-footer-item", target: "_blank"}, "Save to Pocket")
    ]);
  }
}

var Article = {
  view: function(vnode) {
    return m("", {class: "card"},
      [m(Header, {title: vnode.attrs.title}),
       m(Content,{content: vnode.attrs.content, time: vnode.attrs.time}),
       m(Footer, {link: vnode.attrs.link})
      ]);
  }
}

var ArticleList = {
 oninit: function() {
   model.retrieveAllArticles();
 },
 view: function() {
   return model.articles.map( (article) => m(Article, article) )
 }
}

m.mount(root, ArticleList);
