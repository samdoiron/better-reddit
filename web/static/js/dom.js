export function read(callback) {
  fastdom.measure(callback);
}

export function write(callback) {
  fastdom.mutate(callback);
}

export function select(selector) {
  return Array.prototype.slice.call(
    document.querySelectorAll(selector)
  );
}

export function selectOne(selector) {
  var all = document.querySelectorAll(selector);
  if (all.length == 0) {
    throw new Error('selectOne: can\'t find ' + selecor);
  }
  return all[0];
}

export function addClass(element, klass) {
  write(() => element.classList.add(klass));
}

export function removeClass(element, klass) {
  read(() => element.classList.remove(klass));
}

export function behave(selector, callback) {
  select(selector).forEach(callback);
}
