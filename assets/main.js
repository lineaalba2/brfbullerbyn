// Liten klient-side runtime för Brf Bullerbyn
// - Injicerar delad header/footer
// - Markerar aktiv navlänk
// - Renderar nyheter och styrelseuppgifter från JSON

async function injectPartial(selector, url) {
  const el = document.querySelector(selector);
  if (!el) return;
  try {
    const res = await fetch(url, { cache: 'no-cache' });
    if (!res.ok) throw new Error(res.status);
    el.innerHTML = await res.text();
  } catch (err) {
    console.error('Kunde inte ladda ' + url, err);
  }
}

function highlightActiveNav() {
  const stripPath = (p) => {
    let s = p.replace(/^\.\//, '').replace(/\.html$/, '').replace(/\/$/, '');
    s = s.split('/').pop();
    return s === '' || s === 'index' ? 'home' : s;
  };
  const here = stripPath(window.location.pathname);
  document.querySelectorAll('.primary-nav a').forEach((a) => {
    const there = stripPath(a.getAttribute('href') || '');
    if (there === here) a.setAttribute('aria-current', 'page');
  });
}

function setupNavToggle() {
  const btn = document.querySelector('.nav-toggle');
  const nav = document.querySelector('.primary-nav');
  if (!btn || !nav) return;
  btn.addEventListener('click', () => {
    const open = nav.classList.toggle('is-open');
    btn.setAttribute('aria-expanded', String(open));
    btn.setAttribute('aria-label', open ? 'Stäng meny' : 'Öppna meny');
  });
}

function setYear() {
  const el = document.getElementById('year');
  if (el) el.textContent = new Date().getFullYear();
}

function formatDate(iso) {
  try {
    const d = new Date(iso);
    return d.toLocaleDateString('sv-SE', { year: 'numeric', month: 'long', day: 'numeric' });
  } catch {
    return iso;
  }
}

function escapeHTML(str) {
  return String(str).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[c]));
}

// Mycket enkel Markdown: rubriker, fet, kursiv, länkar, listor, paragrafer
function renderMarkdown(md) {
  if (!md) return '';
  const lines = md.split(/\r?\n/);
  const out = [];
  let inList = false;
  for (const raw of lines) {
    const line = raw.trim();
    if (!line) {
      if (inList) { out.push('</ul>'); inList = false; }
      continue;
    }
    if (/^[-*]\s+/.test(line)) {
      if (!inList) { out.push('<ul>'); inList = true; }
      out.push('<li>' + inlineFmt(line.replace(/^[-*]\s+/, '')) + '</li>');
      continue;
    }
    if (inList) { out.push('</ul>'); inList = false; }
    const h = line.match(/^(#{1,3})\s+(.*)$/);
    if (h) {
      const level = h[1].length + 1; // h2..h4
      out.push('<h' + level + '>' + inlineFmt(h[2]) + '</h' + level + '>');
      continue;
    }
    out.push('<p>' + inlineFmt(line) + '</p>');
  }
  if (inList) out.push('</ul>');
  return out.join('\n');
}

function inlineFmt(s) {
  let str = escapeHTML(s);
  str = str.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
  str = str.replace(/(^|[^*])\*([^*]+)\*/g, '$1<em>$2</em>');
  str = str.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
  return str;
}

async function renderNews(limit) {
  const container = document.querySelector('[data-news]');
  if (!container) return;
  try {
    const res = await fetch('data/news.json', { cache: 'no-cache' });
    const items = await res.json();
    items.sort((a, b) => (b.date || '').localeCompare(a.date || ''));
    const list = typeof limit === 'number' ? items.slice(0, limit) : items;
    if (!list.length) {
      container.innerHTML = '<p class="muted">Inga nyheter just nu.</p>';
      return;
    }
    container.innerHTML = list.map((n) => `
      <article class="news-item">
        <time datetime="${escapeHTML(n.date)}">${formatDate(n.date)}</time>
        <h3>${escapeHTML(n.title)}</h3>
        <div class="news-body">${renderMarkdown(n.body || '')}</div>
      </article>
    `).join('');
  } catch (err) {
    container.innerHTML = '<p class="muted">Kunde inte ladda nyheter.</p>';
    console.error(err);
  }
}

async function renderDocuments() {
  const containers = document.querySelectorAll('[data-documents]');
  if (!containers.length) return;
  let items;
  try {
    const res = await fetch('data/documents.json', { cache: 'no-cache' });
    items = await res.json();
  } catch (err) {
    containers.forEach((c) => { c.innerHTML = '<li class="muted">Kunde inte ladda dokumenten.</li>'; });
    console.error(err);
    return;
  }
  containers.forEach((container) => {
    const filter = container.dataset.documents.split(',').map((s) => s.trim()).filter(Boolean);
    const list = items
      .filter((d) => filter.length === 0 || filter.includes(d.category))
      .sort((a, b) => (b.date || '').localeCompare(a.date || ''));
    if (!list.length) {
      container.innerHTML = '<li class="muted">Inga dokument publicerade ännu.</li>';
      return;
    }
    container.innerHTML = list.map((d) => `
      <li class="doc-item">
        <a href="${escapeHTML(d.file)}" target="_blank" rel="noopener">
          <span class="doc-title">${escapeHTML(d.title)}</span>
          ${d.date ? `<span class="doc-date">${formatDate(d.date)}</span>` : ''}
        </a>
      </li>
    `).join('');
  });
}

async function renderBoard() {
  const container = document.querySelector('[data-board]');
  if (!container) return;
  try {
    const res = await fetch('data/board.json', { cache: 'no-cache' });
    const data = await res.json();
    const members = data.members || [];
    container.innerHTML = members.map((m) => `
      <li class="board-card">
        <div class="board-role">${escapeHTML(m.role)}</div>
        <div class="board-name">${escapeHTML(m.name)}</div>
        ${m.email ? `<a class="board-contact" href="mailto:${escapeHTML(m.email)}">${escapeHTML(m.email)}</a>` : ''}
      </li>
    `).join('');
    if (data.updated) {
      const meta = document.querySelector('[data-board-updated]');
      if (meta) meta.textContent = 'Uppdaterad ' + formatDate(data.updated);
    }
  } catch (err) {
    container.innerHTML = '<li class="muted">Kunde inte ladda styrelsen.</li>';
    console.error(err);
  }
}

document.addEventListener('DOMContentLoaded', async () => {
  await Promise.all([
    injectPartial('[data-include="header"]', 'partials/header.html'),
    injectPartial('[data-include="footer"]', 'partials/footer.html'),
  ]);
  highlightActiveNav();
  setupNavToggle();
  setYear();
  const newsEl = document.querySelector('[data-news]');
  if (newsEl) {
    const limit = newsEl.dataset.news ? parseInt(newsEl.dataset.news, 10) : undefined;
    renderNews(Number.isFinite(limit) ? limit : undefined);
  }
  renderBoard();
  renderDocuments();
});
