(function () {
  var root = document.documentElement;
  var buttons = document.querySelectorAll('.mode-toggle button');

  function paint() {
    buttons.forEach(function (b) {
      b.classList.toggle('is-active', b.dataset.mode === root.dataset.theme);
    });
  }
  buttons.forEach(function (b) {
    b.addEventListener('click', function () {
      root.dataset.theme = b.dataset.mode;
      try { localStorage.setItem('theme', b.dataset.mode); } catch (e) {}
      paint();
    });
  });
  paint();

  var tocLinks = document.querySelectorAll('.notes-toc a[href^="#"]');
  if (!tocLinks.length || !('IntersectionObserver' in window)) return;
  var byId = {};
  tocLinks.forEach(function (a) { byId[decodeURIComponent(a.hash.slice(1))] = a; });
  var visible = new Set();
  var observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (e.isIntersecting) visible.add(e.target.id); else visible.delete(e.target.id);
    });
    var first = null;
    Object.keys(byId).some(function (id) {
      if (visible.has(id)) { first = id; return true; }
      return false;
    });
    if (first === null) return;
    tocLinks.forEach(function (a) { a.classList.remove('is-active'); });
    byId[first].classList.add('is-active');
  }, { rootMargin: '-80px 0px -60% 0px' });
  Object.keys(byId).forEach(function (id) {
    var el = document.getElementById(id);
    if (el) observer.observe(el);
  });
})();
