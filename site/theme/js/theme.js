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

(function () {
  var root = document.querySelector('[data-browse]');
  if (!root) return;
  var params = new URLSearchParams(location.search);
  var type = params.get('type') || '';
  var tag = params.get('tag') || '';
  var rows = root.querySelectorAll('.browse-row');
  var tabs = root.querySelectorAll('.browse-tabs a');
  var chips = root.querySelectorAll('.browse-tags button');
  var title = root.querySelector('[data-browse-title]');
  var count = root.querySelector('[data-browse-count]');
  var empty = root.querySelector('.browse-empty');

  function apply() {
    var shown = 0;
    rows.forEach(function (r) {
      var ok = (!type || r.dataset.type === type) &&
               (!tag || r.dataset.tags.split('|').indexOf(tag) !== -1);
      r.hidden = !ok;
      if (ok) shown++;
    });
    var active = null;
    tabs.forEach(function (t) {
      var on = t.dataset.type === type;
      t.classList.toggle('is-active', on);
      if (on) active = t;
    });
    chips.forEach(function (c) { c.classList.toggle('is-active', c.dataset.tag === tag); });
    title.textContent = active && active.dataset.label ? active.dataset.label : 'All posts';
    count.textContent = shown + (shown === 1 ? ' post' : ' posts');
    empty.hidden = shown !== 0;
    var q = new URLSearchParams();
    if (type) q.set('type', type);
    if (tag) q.set('tag', tag);
    history.replaceState(null, '', location.pathname + (q.toString() ? '?' + q : ''));
    document.querySelectorAll('.site-nav a[data-type]').forEach(function (a) {
      a.classList.toggle('is-active', a.dataset.type === type);
    });
  }
  tabs.forEach(function (t) {
    t.addEventListener('click', function (e) { e.preventDefault(); type = t.dataset.type; apply(); });
  });
  chips.forEach(function (c) {
    c.addEventListener('click', function () { tag = tag === c.dataset.tag ? '' : c.dataset.tag; apply(); });
  });
  apply();
})();
