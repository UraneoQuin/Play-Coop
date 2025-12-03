/**
 * script.js - Versión con depuración adicional y rutas absolutas para cargar images.json
 * Reemplaza completamente JS/script.js por este archivo.
 */

let products = [];
let orderItemsDB = [];
window.currentProductId = null;

// Endpoints para productos (se prueban en orden)
const PRODUCT_ENDPOINTS = [
  'get_products.php',
  '../get_products.php',
  '/get_products.php',
  window.location.origin + '/pc/Play-Coop-main/get_products.php'
];

// Candidatos para images.json (añadimos rutas absolutas y variantes)
const IMAGES_JSON_CANDIDATES = [
  'images.json',
  './images.json',
  '../images.json',
  '/images.json',
  window.location.origin + '/pc/Play-Coop-main/images.json',
  window.location.origin + '/images.json',
  window.location.origin + location.pathname.replace(/\/[^\/]*$/, '/images.json')
];

// -----------------------------
// Helpers de autenticación / UI
// -----------------------------
function getSession() {
  try {
    const s = localStorage.getItem('playCoopUser');
    return s ? JSON.parse(s) : null;
  } catch (e) { return null; }
}
function requireAuthOrRedirect() {
  const session = getSession();
  const href = window.location.href;
  const isMain = href.includes('index.html') || href.endsWith('/') || href.endsWith('index.html');
  if (!session && !isMain) { window.location.href = 'index.html'; return false; }
  return true;
}
function initAuthUI() {
  const session = getSession();
  document.querySelectorAll('#user-name').forEach(el => el.innerText = (session && session.user) ? session.user : 'Usuario');
  document.querySelectorAll('#logout-link').forEach(link => {
    link.addEventListener('click', e => { e.preventDefault(); try { localStorage.removeItem('playCoopUser'); } catch(_){}; window.location.href = 'index.html'; });
  });
  document.querySelectorAll('#cart-link, .shopping-btn').forEach(cl => cl.setAttribute('href','cart.html'));
}

// -----------------------------
// Cargar productos desde API
// -----------------------------
async function loadProducts() {
  let lastError = null;
  for (const url of PRODUCT_ENDPOINTS) {
    try {
      const response = await fetch(url, { cache: 'no-store' });
      if (!response.ok) throw new Error(`HTTP ${response.status} en ${url}`);
      const data = await response.json();
      if (data && data.error) throw new Error(data.error);
      products = Array.isArray(data) ? data : [];
      console.log(`Productos cargados desde ${url} -> ${products.length}`);
      return products;
    } catch (err) {
      lastError = err;
      console.warn(`Fallo al cargar productos desde ${url}:`, err.message);
    }
  }
  console.error('No se pudieron cargar productos:', lastError);
  const container = document.getElementById('product-list') || document.getElementById('products-container') || document.getElementById('details-container');
  if (container) container.innerHTML = `<p class="error-msg">Error al cargar productos: ${lastError ? lastError.message : 'Desconocido'}</p>`;
  products = [];
  return products;
}

// -----------------------------
// images.json: intentos y fusión (con logs)
// -----------------------------
async function fetchImagesJsonTryAll() {
  console.log('Intentando cargar images.json desde candidatos...', IMAGES_JSON_CANDIDATES);
  for (const path of IMAGES_JSON_CANDIDATES) {
    try {
      const res = await fetch(path, { cache: 'no-store' });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const json = await res.json();
      if (!Array.isArray(json)) throw new Error('images.json no es un array');
      console.log(`images.json cargado desde: ${path}`);
      return { data: json, path };
    } catch (err) {
      console.warn(`No se pudo cargar images.json desde ${path}: ${err.message}`);
    }
  }

  // Último recurso: intentar XMLHttpRequest en la ruta absoluta derivada
  try {
    const fallback = window.location.origin + '/pc/Play-Coop-main/images.json';
    console.log('Intentando fallback XHR en', fallback);
    const txt = await fetchTextXHR(fallback);
    if (txt) {
      const parsed = JSON.parse(txt);
      if (Array.isArray(parsed)) {
        console.log('images.json cargado via XHR fallback:', fallback);
        return { data: parsed, path: fallback };
      }
    }
  } catch (err) {
    console.warn('XHR fallback falló:', err.message);
  }

  return { data: null, path: null };
}

function fetchTextXHR(url) {
  return new Promise((resolve, reject) => {
    try {
      const xhr = new XMLHttpRequest();
      xhr.open('GET', url, true);
      xhr.responseType = 'text';
      xhr.onload = function() {
        if (xhr.status >= 200 && xhr.status < 300) resolve(xhr.responseText);
        else reject(new Error('XHR HTTP ' + xhr.status));
      };
      xhr.onerror = function() { reject(new Error('XHR network error')); };
      xhr.send();
    } catch (e) {
      reject(e);
    }
  });
}

async function mergeImagesFromJson() {
  try {
    const { data: imgs, path } = await fetchImagesJsonTryAll();
    if (!imgs) {
      console.warn('images.json no disponible. Se usará product_image_url de la BD o img/{id}.jpg por defecto.');
      // Normalizar products para asegurar la key product_image_url
      products = products.map(p => ({ ...p, product_image_url: (p.product_image_url && String(p.product_image_url).trim()) ? String(p.product_image_url).trim() : null }));
      return;
    }

    const map = new Map();
    imgs.forEach(item => {
      const id = Number(item.product_id);
      if (!isNaN(id)) map.set(id, item.image_url || null);
    });

    products = products.map(p => {
      const pid = Number(p.product_id);
      const dbImg = (p.product_image_url && String(p.product_image_url).trim().length > 0) ? String(p.product_image_url).trim() : null;
      const jsonImg = map.has(pid) ? map.get(pid) : null;
      const finalImg = dbImg || (jsonImg && String(jsonImg).trim().length > 0 ? String(jsonImg).trim() : null);
      return { ...p, product_image_url: finalImg };
    });

    console.log(`mergeImagesFromJson: asignadas imágenes a ${products.filter(p => p.product_image_url).length} productos (de ${products.length}).`);
    preloadProductImages();
  } catch (e) {
    console.warn('Error en mergeImagesFromJson:', e);
  }
}

// Preload con logs para depuración
function preloadProductImages() {
  products.forEach(p => {
    const url = p.product_image_url && String(p.product_image_url).trim().length > 0 ? p.product_image_url.trim() : `img/${p.product_id}.jpg`;
    const img = new Image();
    img.onload = () => { /* ok */ };
    img.onerror = () => { console.warn('Preload fallo imagen:', url); };
    img.src = url;
  });
}

// -----------------------------
// Render catálogo
// -----------------------------
function renderizarProductos() {
  const container = document.getElementById('product-list') || document.getElementById('products-container');
  if (!container) return;
  container.innerHTML = '';

  products.forEach(prod => {
    const id = prod.product_id;
    const name = prod.product_name || 'Producto';
    const desc = prod.product_desc || '';
    const price = Number.isFinite(Number(prod.price)) ? parseFloat(prod.price) : 0;
    const stock = parseInt(prod.stock || 0, 10);
    const externalImage = prod.product_image_url && String(prod.product_image_url).trim().length > 0 ? String(prod.product_image_url).trim() : null;
    const imgUrl = externalImage || `img/${id}.jpg`;
    const shortDesc = (typeof desc === 'string') ? desc.substring(0, 80) : String(desc);

    const card = document.createElement('div');
    card.className = 'product-card';
    card.innerHTML = `
      <img class="card-img" src="${escapeHtml(imgUrl)}" alt="${escapeHtml(name)}" onerror="this.src='img/placeholder.png'">
      <h3 class="card-title">${escapeHtml(name)}</h3>
      <p class="card-desc">${escapeHtml(shortDesc)}${shortDesc.length>=80 ? '...' : ''}</p>
      <div class="card-footer">
        <span class="card-price">$${price.toFixed(2)}</span>
        <button class="btn-add" data-id="${id}" ${stock<=0 ? 'disabled' : ''}>+</button>
      </div>
      <a href="description.html?id=${encodeURIComponent(id)}" class="btn btn-primary btn-details">Ver detalles</a>
    `;
    container.appendChild(card);
  });

  container.querySelectorAll('.btn-add').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const id = parseInt(e.currentTarget.dataset.id, 10);
      agregarAlCarritoConCantidad(id, 1);
    });
  });
}

// -----------------------------
// Detalle de producto
// -----------------------------
function loadProductDetails() {
  const params = new URLSearchParams(window.location.search);
  const idParam = params.get('id');
  const titleEl = document.getElementById('detail-title');
  const descEl = document.getElementById('detail-desc');
  const priceEl = document.getElementById('detail-price');
  const addBtn = document.getElementById('add-btn');
  const imgEl = document.getElementById('detail-img');
  const stockEl = document.getElementById('detail-stock');
  const qtyInput = document.getElementById('qty-input');
  const qtyInc = document.getElementById('qty-increase');
  const qtyDec = document.getElementById('qty-decrease');

  if (!idParam) { if (titleEl) titleEl.innerText = 'ID no especificado'; if (descEl) descEl.innerText = ''; if (addBtn) addBtn.disabled = true; return; }
  const parsedId = parseInt(idParam, 10);
  if (isNaN(parsedId)) { if (titleEl) titleEl.innerText = 'ID inválido'; if (descEl) descEl.innerText = ''; if (addBtn) addBtn.disabled = true; return; }

  const product = products.find(p => parseInt(p.product_id, 10) === parsedId);
  if (!product) { if (titleEl) titleEl.innerText = 'Producto no encontrado'; if (descEl) descEl.innerText = `No existe producto con ID ${parsedId}`; if (addBtn) addBtn.disabled = true; return; }

  if (titleEl) titleEl.innerText = product.product_name || 'Sin nombre';
  if (descEl) descEl.innerText = product.product_desc || '';
  if (priceEl) { const priceVal = Number.isFinite(Number(product.price)) ? parseFloat(product.price) : 0; priceEl.innerText = `$${priceVal.toFixed(2)}`; }
  const stock = parseInt(product.stock || 0, 10);
  if (stockEl) stockEl.innerText = `Stock: ${stock}`;

  const externalImage = product.product_image_url && String(product.product_image_url).trim().length > 0 ? String(product.product_image_url).trim() : null;
  const imgSrc = externalImage || `img/${product.product_id}.jpg`;
  if (imgEl) { imgEl.src = imgSrc; imgEl.onerror = () => { imgEl.src = 'img/placeholder.png'; }; }

  if (addBtn) {
    addBtn.disabled = stock <= 0;
    addBtn.onclick = () => {
      const qty = Number.isFinite(Number(qtyInput.value)) ? parseInt(qtyInput.value, 10) : 1;
      agregarAlCarritoConCantidad(product.product_id, qty);
    };
  }

  if (qtyInput) {
    qtyInput.value = '1';
    qtyInc && qtyInc.addEventListener('click', () => { let v = parseInt(qtyInput.value || '1', 10); v = Math.min(v + 1, stock); qtyInput.value = v; });
    qtyDec && qtyDec.addEventListener('click', () => { let v = parseInt(qtyInput.value || '1', 10); v = Math.max(v - 1, 1); qtyInput.value = v; });
  }
}

// -----------------------------
// Carrito (sin cambios funcionales importantes)
// -----------------------------
function cargarCarritoLocal() {
  try {
    const raw = localStorage.getItem('playCoopCart');
    orderItemsDB = raw ? JSON.parse(raw) : [];
    if (!Array.isArray(orderItemsDB)) orderItemsDB = [];
  } catch (e) {
    orderItemsDB = [];
  }
}
function guardarCarritoLocal() { try { localStorage.setItem('playCoopCart', JSON.stringify(orderItemsDB)); } catch (e) { console.warn('No se pudo guardar carrito local', e); } }
function agregarAlCarritoConCantidad(productId, qty) {
  productId = parseInt(productId, 10);
  qty = parseInt(qty, 10) || 1;
  const prod = products.find(p => parseInt(p.product_id, 10) === productId);
  if (!prod) { alert('Producto no encontrado'); return; }
  const stock = parseInt(prod.stock || 0, 10);
  const existing = orderItemsDB.find(i => parseInt(i.product_id,10) === productId);
  const currentQty = existing ? existing.quantity : 0;
  if (currentQty + qty > stock) { alert('No hay stock suficiente'); return; }
  if (existing) existing.quantity += qty; else orderItemsDB.push({ product_id: productId, quantity: qty });
  guardarCarritoLocal(); renderizarCarrito();
  try { window.alert('Producto agregado al carrito'); } catch(e){}
}
function renderizarCarrito() {
  document.querySelectorAll('#cart-count').forEach(el => { const totalQty = orderItemsDB.reduce((s,i)=> s + (i.quantity||0), 0); el.innerText = totalQty; });

  const container = document.getElementById('cart-items') || document.getElementById('cart-items-container');
  const totalDisplay = document.getElementById('cart-total') || document.getElementById('total-display');
  if (!container || !totalDisplay) return;
  container.innerHTML = '';
  let total = 0;
  if (orderItemsDB.length === 0) { container.innerHTML = '<p class="empty-msg">Carrito vacío</p>'; totalDisplay.innerText = '$0.00'; return; }
  orderItemsDB.forEach((it, idx) => {
    const prod = products.find(p => parseInt(p.product_id,10) === it.product_id);
    if (!prod) return;
    const price = Number.isFinite(Number(prod.price)) ? parseFloat(prod.price) : 0;
    const subtotal = price * it.quantity;
    total += subtotal;
    const imgSrc = prod.product_image_url && String(prod.product_image_url).trim().length > 0 ? String(prod.product_image_url).trim() : `img/${prod.product_id}.jpg`;
    const node = document.createElement('div');
    node.className = 'cart-item';
    node.innerHTML = `
      <img src="${escapeHtml(imgSrc)}" onerror="this.src='img/placeholder.png'" class="cart-item-img">
      <div class="cart-info">
        <h4>${escapeHtml(prod.product_name)}</h4>
      <div class="cart-controls">
        <button class="btn-decrease" data-idx="${idx}">-</button>
        <span class="qty">${it.quantity}</span>
        <button class="btn-increase" data-idx="${idx}">+</button>
        <span class="cart-subtotal">$${subtotal.toFixed(2)}</span>
      </div>
      </div>
      <button class="btn-remove" data-idx="${idx}">Eliminar</button>
    `;
    container.appendChild(node);
  });
  totalDisplay.innerText = `$${total.toFixed(2)}`;
  container.querySelectorAll('.btn-increase').forEach(b => b.addEventListener('click', e => { const idx = parseInt(e.currentTarget.dataset.idx,10); cambiarCantidadPorIndice(idx, 1); }));
  container.querySelectorAll('.btn-decrease').forEach(b => b.addEventListener('click', e => { const idx = parseInt(e.currentTarget.dataset.idx,10); cambiarCantidadPorIndice(idx, -1); }));
  container.querySelectorAll('.btn-remove').forEach(b => b.addEventListener('click', e => { const idx = parseInt(e.currentTarget.dataset.idx,10); eliminarDelCarrito(idx); }));
}
function cambiarCantidadPorIndice(idx, delta) {
  if (idx < 0 || idx >= orderItemsDB.length) return;
  const item = orderItemsDB[idx];
  const prod = products.find(p => parseInt(p.product_id,10) === item.product_id);
  const stock = prod ? parseInt(prod.stock||0,10) : Infinity;
  const nueva = item.quantity + delta;
  if (nueva <= 0) { eliminarDelCarrito(idx); return; }
  if (nueva > stock) { alert('No hay suficiente stock'); return; }
  item.quantity = nueva; guardarCarritoLocal(); renderizarCarrito();
}
function eliminarDelCarrito(idx) { if (idx < 0 || idx >= orderItemsDB.length) return; orderItemsDB.splice(idx,1); guardarCarritoLocal(); renderizarCarrito(); }
function finalizarCompra() { if (orderItemsDB.length === 0) return alert('Agrega productos primero.'); const totalEl = document.getElementById('cart-total') || document.getElementById('total-display'); const total = totalEl ? totalEl.innerText : 'N/A'; alert(`Compra realizada. Total: ${total}`); orderItemsDB = []; guardarCarritoLocal(); renderizarCarrito(); }

// -----------------------------
// Util
// -----------------------------
function escapeHtml(str) { if (typeof str !== 'string') return String(str); return str.replace(/[&<>"'`=\/]/g, function (s) { return ({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;','/':'&#x2F;','`':'&#x60;','=':'&#x3D;' })[s]; }); }

// -----------------------------
// Init
// -----------------------------
document.addEventListener('DOMContentLoaded', async () => {
  if (!requireAuthOrRedirect()) return;
  initAuthUI();
  cargarCarritoLocal();

  const href = location.href;
  if (href.includes('home.html') || href.endsWith('/') || href.endsWith('index.html')) {
    await loadProducts();
    await mergeImagesFromJson(); // <-- robust merge
    renderizarProductos();
  }

  if (href.includes('cart.html')) {
    await loadProducts();
    await mergeImagesFromJson();
  }

  if (href.includes('description.html')) {
    await loadProducts();
    await mergeImagesFromJson();
    loadProductDetails();
  }

  renderizarCarrito();
});