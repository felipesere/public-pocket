var root = document.getElementById("cards")

var backend = {
  articles: [],
  starting_page: "/api/articles/0/10",
  next: null,
  previous: null,
  retrieveAllArticles: function() {
    var that = this
    m.request({
      method: "GET",
      url: that.starting_page,
    })
    .then(function(data) {
      that.articles = data.articles
      that.next = data.next
      that.previous = data.previous
    })
  },
  nextPage: function() {
    var that = this
    m.request({
      method: "GET",
      url: that.next,
    })
    .then(function(data) {
      that.articles = data.articles
      that.next = data.next
      that.previous = data.previous
    })
  },
  previousPage: function() {
    var that = this
    m.request({
      method: "GET",
      url: that.previous,
    })
    .then(function(data) {
      that.articles = data.articles
      that.next = data.next
      that.previous = data.previous
    })
  }
}

var Header = {
  view: function(vnode) {
    return m("header", {class: "card-header"},
      m("p", {class: "card-header-title"}, vnode.attrs.title))
  }
};

var Tag = {
  view: function(vnode) {
    return m("span", {class: "tag is-info is-rounded"}, vnode.attrs.tag_name)
  }
}

var Content = {
  view: function(vnode) {
    return m("", {class: "card-content"},
      m("", {class: "content article-structure"},
        [
          m("", vnode.attrs.content),
          m("time", {datetime: vnode.attrs.time.short}, vnode.attrs.time.long),
          m("", {class: "tags"}, vnode.attrs.tags.map( (t) => m(Tag, {tag_name: t})))
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
       m(Content,{
         content: vnode.attrs.content,
         time: vnode.attrs.time,
         tags: vnode.attrs.tags
       }),
       m(Footer, {link: vnode.attrs.link})
      ]);
  }
}

var ArticleList = {
 oninit: function() {
   backend.retrieveAllArticles();
 },
 view: function() {
   return backend.articles.map( (article) => m(Article, article) )
 }
}

var Pagination = {
  view:  () => {
    var links = []
    if (backend.previous) {
      links.push(m("a", {onclick: () => backend.previousPage(), class: "pagination-previous"}, "Previous"))
    }
    if (backend.next) {
      links.push(m("a", {onclick: () => backend.nextPage(), class: "pagination-next"}, "Next page"))
    }

    return m("nav", {class: "pagination is-right"}, links)
  }
}

var App = {
  view: function () {
    return [m(ArticleList), m(Pagination)]
  }
}

m.mount(root, App);
