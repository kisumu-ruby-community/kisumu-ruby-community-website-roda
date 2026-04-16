const CACHE = "krc-v1";
const STATIC = ["/style.css", "/assets/logo/KRC-1.png"];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(STATIC)));
  self.skipWaiting();
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", e => {
  const { request } = e;
  const url = new URL(request.url);

  // Cache-first for static assets
  if (STATIC.some(p => url.pathname === p)) {
    e.respondWith(
      caches.match(request).then(cached => cached || fetch(request))
    );
    return;
  }

  // Network-first for navigation
  if (request.mode === "navigate") {
    e.respondWith(
      fetch(request).catch(() => caches.match("/"))
    );
  }
});
