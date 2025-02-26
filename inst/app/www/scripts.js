$(document).ready(function() {
  // 监听滚动事件
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('#back-to-top').fadeIn(); // 显示按钮
    } else {
      $('#back-to-top').fadeOut(); // 隐藏按钮
    }
  });

  // 点击返回顶部按钮
  $('#backToTop').click(function() {
    $('html, body').animate({ scrollTop: 0 }, 'fast'); // 滚动到顶部
    return false; // 阻止默认行为
  });
});
