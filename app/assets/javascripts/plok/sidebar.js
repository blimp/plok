var sidebar = {
  init: () => {
    sidebar.bind_mouse_events();
    $('#hamburger').on('click', sidebar.toggle_hamburger_click_listener)
    $(document).on('click', sidebar.document_click_listener)
  },

  bind_mouse_events: () => {
    $('.wrapper.compact ul li.top-level')
      .on('mouseenter', sidebar.list_item_mouseenter_listener)
      .on('mouseleave', sidebar.list_item_mouseleave_listener)
  },

  close_all_submenus: () => {
    $('[id^="nav-"]').each((_i, item) => { $(item).removeClass('show') })
    $('a.top-level-anchor').each((_i, item) => { $(item).removeClass('bg-secondary') })
  },

  document_click_listener: (e) => {
    if($('.compact:visible').length == 0) return
    if($(e.target).closest('.sidebar-menu').length === 0)
      sidebar.close_all_submenus();
  },

  list_item_mouseenter_listener: (e) => {
    sidebar.list_item_mouseleave_listener(e)

    let anchor = $(e.target)
    if(!anchor.hasClass('top-level-anchor')) return
    anchor.addClass('bg-secondary')
    $(anchor.attr('href')).addClass('show')
  },

  list_item_mouseleave_listener: (e) => {
    let anchor = $(e.target)
    if(!anchor.hasClass('top-level-anchor')) return
    sidebar.close_all_submenus();
  },

  toggle_hamburger_click_listener: e => {
    e.preventDefault()
    $('.wrapper').toggleClass('compact')

    $('[id^="nav-"]').each((index, item) => {
      if($('.wrapper').hasClass('compact')) {
        $(item).removeClass('show')
      }
    })

    if($('.wrapper').hasClass('compact')) {
      sidebar.bind_mouse_events()
      $('.sidebar-menu').removeClass('overflow-auto')
    } else {
      sidebar.unbind_mouse_events()
      $('.sidebar-menu').addClass('overflow-auto')
    }
  },

  unbind_mouse_events: () => {
    $('.wrapper ul li.top-level')
      .off('mouseenter')
      .off('mouseleave')
  }
}

$(() => { sidebar.init() })
