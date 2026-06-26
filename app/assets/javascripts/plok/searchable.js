// Lightweight search autocomplete built on plain jQuery + Bootstrap 5 dropdown
// markup. Replaces the old jquery-ui.autocomplete widget.
//
// It fetches a JSON list of { label: <html>, value: <url> } from the form's
// action (see Backend::SearchController#query) and renders them as Bootstrap
// dropdown items. The HTML label embeds a type badge (see the result object
// partials in app/views/plok/search/result_objects/).
var search = search || {
  active: -1,

  init: function() {
    var $input = this.target();
    if(!$input.length) return;

    this.$menu = $('<ul class="plok-autocomplete dropdown-menu"></ul>');
    $input
      .attr('autocomplete', 'off')
      .parent().css('position', 'relative').append(this.$menu);

    $input
      .on('input', this.debounce(this.query.bind(this), 200))
      .on('keydown', this.keydown.bind(this))
      .on('blur', function() { setTimeout(function(){ search.close(); }, 150); });

    $(document).on('click', function(e) {
      if(!$(e.target).closest('[data-plok-searchable]').length) search.close();
    });
  },

  query: function() {
    var $input = this.target();
    var term = $input.val();
    if(term.length < 2) return this.close();

    $.getJSON($input.parents('form').attr('action'), { term: term })
      .done(function(items) { search.render(items); });
  },

  render: function(items) {
    this.$menu.empty();
    this.active = -1;

    if(!items.length) return this.close();

    items.forEach(function(item) {
      $('<li></li>')
        .append($('<a class="dropdown-item" href="' + item.value + '"></a>').html(item.label))
        .appendTo(search.$menu);
    });

    this.$menu.addClass('show');
  },

  keydown: function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    var $items = this.$menu.children('li');

    if(code == 13) { // Enter: follow the active item, never submit the form.
      if(this.active >= 0) {
        window.location = $items.eq(this.active).find('a').attr('href');
      }
      return false;
    }

    if(!this.$menu.hasClass('show')) return;

    if(code == 40) { // Down
      this.move(1, $items);
      e.preventDefault();
    } else if(code == 38) { // Up
      this.move(-1, $items);
      e.preventDefault();
    } else if(code == 27) { // Escape
      this.close();
    }
  },

  move: function(dir, $items) {
    $items.eq(this.active).find('a').removeClass('active');
    this.active = (this.active + dir + $items.length) % $items.length;
    $items.eq(this.active).find('a').addClass('active');
  },

  close: function() {
    if(this.$menu) this.$menu.removeClass('show').empty();
    this.active = -1;
  },

  debounce: function(fn, wait) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      clearTimeout(timeout);
      timeout = setTimeout(function(){ fn.apply(context, args); }, wait);
    };
  },

  target: function() {
    return $('[data-plok-searchable] input');
  }
};

$(function(){ search.init(); });
