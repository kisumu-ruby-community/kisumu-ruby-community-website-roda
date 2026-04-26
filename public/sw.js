const CACHE = "krc-v1";
const STATIC = ["/assets/logo/KRC-1.png"];

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

  // Network-first for CSS: always serve the latest build, cache as offline fallback.
  if (url.pathname === "/style.css") {
    e.respondWith(
      fetch(request)
        .then(res => {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(request, clone));
          return res;
        })
        .catch(() => caches.match(request))
    );
    return;
  }

  // Cache-first for infrequently changing static assets.
  if (STATIC.some(p => url.pathname === p)) {
    e.respondWith(
      caches.match(request).then(cached => cached || fetch(request))
    );
    return;
  }

  // Network-first for navigation with offline fallback.
  if (request.mode === "navigate") {
    e.respondWith(
      fetch(request).catch(() => caches.match("/"))
    );
  }
});
