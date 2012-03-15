
Tower.View.cache = {
  'app/views/welcome': function() {
    return h1("Welcome to Tower.js");
  },
  'app/views/layouts/application': function() {
    doctype(5);
    return html(function() {
      head(function() {
        return partial("shared/meta");
      });
      body({
        role: "application"
      }, function() {
        if (hasContentFor("templates")) yields("templates");
        nav({
          id: "navigation",
          "class": "navbar navbar-fixed-top",
          role: "navigation"
        }, function() {
          return div({
            "class": "navbar-inner"
          }, function() {
            return div({
              "class": "container"
            }, function() {
              return partial("shared/navigation");
            });
          });
        });
        header({
          id: "header",
          "class": "header",
          role: "banner"
        }, function() {
          return div({
            "class": "container"
          }, function() {
            return partial("shared/header");
          });
        });
        section({
          id: "content",
          role: "main"
        }, function() {
          return div({
            "class": "container"
          }, function() {
            yields("body");
            return aside({
              id: "sidebar",
              role: "complementary"
            }, function() {
              if (hasContentFor("sidebar")) return yields("sidebar");
            });
          });
        });
        return footer({
          id: "footer",
          "class": "footer",
          role: "contentinfo"
        }, function() {
          return div({
            "class": "container"
          }, function() {
            return partial("shared/footer");
          });
        });
      });
      if (hasContentFor("popups")) {
        aside({
          id: "popups"
        }, function() {
          return yields("popups");
        });
      }
      if (hasContentFor("bottom")) return yields("bottom");
    });
  },
  'app/views/retrospectives/_form': function() {
    return formFor(this.retrospective, function(f) {
      f.fieldset(function(fields) {
        return fields.field("name", {
          as: "string"
        });
      });
      return f.fieldset(function(fields) {
        return fields.submit("Submit");
      });
    });
  },
  'app/views/retrospectives/_item': function() {
    return li({
      "class": "retrospective"
    }, function() {
      header({
        "class": "header"
      }, function() {
        return h3(this.retrospective.toLabel());
      });
      dl({
        "class": "content"
      }, function() {
        dt("Name:");
        return dd(this.retrospective.get("name"));
      });
      return footer({
        "class": "footer"
      }, function() {
        return menu(function() {
          return menuItem("Edit", urlFor(this.retrospective, {
            action: "edit"
          }));
        });
      });
    });
  },
  'app/views/retrospectives/_list': function() {
    return ol({
      "class": "retrospectives"
    }, function() {
      return partial("item", {
        collection: this.retrospectives
      });
    });
  },
  'app/views/retrospectives/_table': function() {
    return tableFor("retrospectives", function(t) {
      t.head(function() {
        return t.row(function() {
          return t.header("name", {
            sort: true
          });
        });
      });
      t.body(function() {
        var retrospective, _i, _len, _ref, _results;
        _ref = this.retrospectives;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          retrospective = _ref[_i];
          _results.push(t.row(function() {
            t.cell(function() {
              return retrospective.get("name");
            });
            return t.cell(function() {
              linkTo('Show', urlFor(retrospective));
              span("|");
              linkTo('Edit', urlFor(retrospective, {
                action: "edit"
              }));
              span("|");
              return linkTo('Destroy', urlFor(retrospective), {
                "data-method": "delete"
              });
            });
          }));
        }
        return _results;
      });
      return t.foot(function() {
        return t.row(function() {
          return t.cell({
            colspan: 4
          }, function() {
            return linkTo('New Retrospective', urlFor(App.Retrospective, {
              action: "new"
            }));
          });
        });
      });
    });
  },
  'app/views/retrospectives/edit': function() {
    this.title = "Editing Retrospective";
    partial("form");
    return contentFor("sidebar", function() {
      return header({
        "class": "widget header"
      }, function() {
        return h2(this.retrospective.toLabel());
      });
    });
  },
  'app/views/retrospectives/index': function() {
    this.title = "Listing retrospectives";
    return partial("table");
  },
  'app/views/retrospectives/new': function() {
    this.title = "New Retrospective";
    return partial("form");
  },
  'app/views/retrospectives/show': function() {
    this.title = "Retrospective " + (this.retrospective.toLabel());
    return dl({
      "class": "content"
    }, function() {
      dt("Name:");
      return dd(this.retrospective.get("name"));
    });
  },
  'app/views/shared/_footer': function() {
    return cite({
      "class": "copyright"
    }, function() {
      span("&copy;");
      linkTo(t("author"), t("email"));
      return span("" + (t("year")) + ".");
    });
  },
  'app/views/shared/_header': function() {
    return h1({
      id: "title"
    }, function() {
      return t("title");
    });
  },
  'app/views/shared/_meta': function() {
    meta({
      charset: "utf-8"
    });
    if (hasContentFor("title")) {
      title(this.title);
    } else {
      title(t("title"));
    }
    meta({
      name: "description",
      content: t("description")
    });
    meta({
      name: "keywords",
      content: t("keywords")
    });
    meta({
      name: "robots",
      content: t("robots")
    });
    meta({
      name: "author",
      content: t("author")
    });
    csrfMetaTag();
    appleViewportMetaTag({
      width: "device-width",
      max: 1,
      scalable: false
    });
    stylesheets("lib", "vendor", "application");
    link({
      href: "/favicon.png",
      rel: "icon shortcut-icon favicon"
    });
    javascriptTag("https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js");
    return contentFor("bottom", function() {
      javascripts("vendor");
      if (Tower.env === "development") javascripts("development");
      return javascripts("lib", "application");
    });
  },
  'app/views/shared/_navigation': function() {
    linkTo(t("title"), "/", {
      "class": "brand"
    });
    return div({
      "class": "nav-collapse"
    }, function() {
      ul({
        "class": "nav"
      }, function() {
        return navItem(t("links.retrospectives"), urlFor(App.Retrospective));
      });
      return ul({
        "class": "nav pull-right"
      }, function() {
        return li({
          "class": "dropdown"
        }, function() {
          linkTo(t("links.docs"), "#", {
            "class": "dropdown-toggle",
            "data-toggle": "dropdown"
          }, function() {
            return b({
              "class": "caret"
            });
          });
          return ul({
            "class": "dropdown-menu"
          }, function() {
            return li(function() {
              return linkTo("Tower.js", "http://towerjs.org");
            });
          });
        });
      });
    });
  },
  'app/views/shared/_sidebar': function() {}
};
